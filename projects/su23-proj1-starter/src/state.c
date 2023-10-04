#include "state.h"

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "snake_utils.h"

/* Helper function definitions */
static void set_board_at(game_state_t* state, unsigned int row, unsigned int col, char ch);
static bool is_tail(char c);
static bool is_head(char c);
static bool is_snake(char c);
static char body_to_tail(char c);
static char head_to_body(char c);
static unsigned int get_next_row(unsigned int cur_row, char c);
static unsigned int get_next_col(unsigned int cur_col, char c);
static void find_head(game_state_t* state, unsigned int snum);
static char next_square(game_state_t* state, unsigned int snum);
static void update_tail(game_state_t* state, unsigned int snum);
static void update_head(game_state_t* state, unsigned int snum);

/* Task 1 */
game_state_t* create_default_state() {
  // TODO: Implement this function.
  /*  default_state:
    ####################
    #                  #
    # d>D    *         #
    #                  #
    #                  #
    #                  #
    #                  #
    #                  #
    #                  #
    #                  #
    #                  #
    #                  #
    #                  #
    #                  #
    #                  #
    #                  #
    #                  #
    ####################
  */
  const unsigned int default_num_rows = 18;
  const unsigned int default_num_cols = 20;
  const unsigned int default_num_snakes = 1;
  const snake_t default_snake = {.tail_row=2, .tail_col=2, .head_row=2, .head_col=4, .live=true};

  game_state_t* default_state = (game_state_t*)malloc(sizeof(game_state_t));
  default_state->num_rows = default_num_rows;
  default_state->num_snakes = default_num_snakes;
  default_state->snakes = (snake_t*)malloc(sizeof(snake_t)*default_num_snakes);
  default_state->snakes[0] = default_snake;
  default_state->board = (char**)malloc(sizeof(char*)*default_num_rows);
  for (size_t i = 0; i < default_num_rows; i++) {
    default_state->board[i] = (char*)malloc(sizeof(char*)*default_num_cols);
    if (i == 0 || i == default_num_rows - 1) {
      strcpy(default_state->board[i], "####################");
    }
    else if (i == 2) {
      strcpy(default_state->board[i], "# d>D    *         #");
    }
    else {
      strcpy(default_state->board[i], "#                  #");
    }
  }
  return default_state;
}

/* Task 2 */
void free_state(game_state_t* state) {
  // TODO: Implement this function.
  free(state->snakes);
  for (size_t i = 0; i < state->num_rows; i++) {
    free(state->board[i]);
  }
  free(state->board);
  free(state);
  return;
}

/* Task 3 */
void print_board(game_state_t* state, FILE* fp) {
  // TODO: Implement this function.
  for (size_t i = 0; i < state->num_rows; i++) {
    // fputs(state->board[i], fp);
    fprintf(fp, "%s\n", state->board[i]);
  }
  return;
}

/*
  Saves the current state into filename. Does not modify the state object.
  (already implemented for you).
*/
void save_board(game_state_t* state, char* filename) {
  FILE* f = fopen(filename, "w");
  print_board(state, f);
  fclose(f);
}

/* Task 4.1 */

/*
  Helper function to get a character from the board
  (already implemented for you).
*/
char get_board_at(game_state_t* state, unsigned int row, unsigned int col) {
  return state->board[row][col];
}

/*
  Helper function to set a character on the board
  (already implemented for you).
*/
static void set_board_at(game_state_t* state, unsigned int row, unsigned int col, char ch) {
  state->board[row][col] = ch;
}

/*
  Returns true if c is part of the snake's tail.
  The snake consists of these characters: "wasd"
  Returns false otherwise.
*/
static bool is_tail(char c) {
  // TODO: Implement this function.
  switch(c) {
  case 'w': case 'a': case 's': case 'd':
    return true;
  default:
    return false;
  }
}

/*
  Returns true if c is part of the snake's head.
  The snake consists of these characters: "WASDx"
  Returns false otherwise.
*/
static bool is_head(char c) {
  // TODO: Implement this function.
  switch (c) {
  case 'W': case 'A': case 'S': case 'D': case 'x':
    return true;
  default:
    return false;
  }
}

/*
  Returns true if c is part of the snake.
  The snake consists of these characters: "wasd^<v>WASDx"
*/
static bool is_snake(char c) {
  // TODO: Implement this function.
  switch (c) {
  case '^': case '<': case 'v': case '>':
    return true;
  default:
    return is_head(c) || is_tail(c);
  }
}

/*
  Converts a character in the snake's body ("^<v>")
  to the matching character representing the snake's
  tail ("wasd").
*/
static char body_to_tail(char c) {
  // TODO: Implement this function.
  switch (c) {
  case '^':
    return 'w';
  case '<':
    return 'a';
  case 'v':
    return 's';
  case '>':
    return 'd';
  default:
    return '?';
  }
}

/*
  Converts a character in the snake's head ("WASD")
  to the matching character representing the snake's
  body ("^<v>").
*/
static char head_to_body(char c) {
  // TODO: Implement this function.
  switch (c) {
  case 'W':
    return '^';
  case 'A':
    return '<';
  case 'S':
    return 'v';
  case 'D':
    return '>';
  default:
    return '?';
  }
}

/*
  Returns cur_row + 1 if c is 'v' or 's' or 'S'.
  Returns cur_row - 1 if c is '^' or 'w' or 'W'.
  Returns cur_row otherwise.
*/
static unsigned int get_next_row(unsigned int cur_row, char c) {
  // TODO: Implement this function.
  switch (c) {
  case 'v': case 's': case 'S':
    return cur_row + 1;
  case '^': case 'w': case 'W':
    return cur_row - 1;
  default:
    return cur_row;
  }
}

/*
  Returns cur_col + 1 if c is '>' or 'd' or 'D'.
  Returns cur_col - 1 if c is '<' or 'a' or 'A'.
  Returns cur_col otherwise.
*/
static unsigned int get_next_col(unsigned int cur_col, char c) {
  // TODO: Implement this function.
  switch (c) {
  case '>': case 'd': case 'D':
    return cur_col + 1;
  case '<': case 'a': case 'A':
    return cur_col - 1;
  default:
    return cur_col;
  }
}

/*
  Task 4.2

  Helper function for update_state. Return the character in the cell the snake is moving into.

  This function should not modify anything.
*/
static char next_square(game_state_t* state, unsigned int snum) {
  // TODO: Implement this function.
  unsigned int cur_row = state->snakes[snum].head_row;
  unsigned int cur_col = state->snakes[snum].head_col;
  char cur_head = get_board_at(state, cur_row, cur_col);
  unsigned int next_row = get_next_row(cur_row, cur_head);
  unsigned int next_col = get_next_col(cur_col, cur_head);
  return get_board_at(state, next_row, next_col);
}

/*
  Task 4.3

  Helper function for update_state. Update the head...

  ...on the board: add a character where the snake is moving

  ...in the snake struct: update the row and col of the head

  Note that this function ignores food, walls, and snake bodies when moving the head.
*/
static void update_head(game_state_t* state, unsigned int snum) {
  // TODO: Implement this function.
  unsigned int cur_row = state->snakes[snum].head_row;
  unsigned int cur_col = state->snakes[snum].head_col;
  char cur_head = get_board_at(state, cur_row, cur_col);
  unsigned int next_row = get_next_row(cur_row, cur_head);
  unsigned int next_col = get_next_col(cur_col, cur_head);
  set_board_at(state, next_row, next_col, cur_head);
  set_board_at(state, cur_row, cur_col, head_to_body(cur_head));
  state->snakes[snum].head_row = next_row;
  state->snakes[snum].head_col = next_col;
}

/*
  Task 4.4

  Helper function for update_state. Update the tail...

  ...on the board: blank out the current tail, and change the new
  tail from a body character (^<v>) into a tail character (wasd)

  ...in the snake struct: update the row and col of the tail
*/
static void update_tail(game_state_t* state, unsigned int snum) {
  // TODO: Implement this function.
  unsigned int cur_row = state->snakes[snum].tail_row;
  unsigned int cur_col = state->snakes[snum].tail_col;
  char cur_tail = get_board_at(state, cur_row, cur_col);
  unsigned int next_row = get_next_row(cur_row, cur_tail);
  unsigned int next_col = get_next_col(cur_col, cur_tail);
  char tail_next_body = get_board_at(state, next_row, next_col);
  set_board_at(state, cur_row, cur_col, ' ');
  set_board_at(state, next_row, next_col, body_to_tail(tail_next_body));
  state->snakes[snum].tail_row = next_row;
  state->snakes[snum].tail_col = next_col;
}

/* Task 4.5 */
void update_state(game_state_t* state, int (*add_food)(game_state_t* state)) {
  // TODO: Implement this function.
  for (unsigned int i = 0; i < state->num_snakes; i++) {
    char next_head_square = next_square(state, i);
    if (is_snake(next_head_square) || next_head_square == '#') {
      unsigned int cur_head_row = state->snakes[i].head_row;
      unsigned int cur_head_col = state->snakes[i].head_col;
      set_board_at(state, cur_head_row, cur_head_col, 'x');
      state->snakes[i].live = false;
    }
    else if (next_head_square == '*') {
      update_head(state, i);
      add_food(state);
    }
    else {
      update_head(state, i);
      update_tail(state, i);
    }
  }
}

/* Task 5 */
game_state_t* load_board(FILE* fp) {
  // TODO: Implement this function.
  game_state_t* state = malloc(sizeof *state);
  state->snakes = NULL;
  state->num_snakes = 0;
  const unsigned int MAXCOLLEN = 1000000;
  state->num_rows = 0;
  state->board = NULL;
  char* line = malloc((sizeof *line) * MAXCOLLEN);
  while (fgets(line, MAXCOLLEN, fp) != NULL) {
    if (line[strlen(line)] != '\0') {
      printf("length of col of the board out of MAX_COL_LENGTH\n");
      exit(1);
    }
    line[strlen(line)-1] = '\0';

    state->num_rows++;
    state->board= realloc(state->board, (sizeof *state->board) * state->num_rows);
    if (state->board == NULL) {
      printf("out of memory\n");
      free_state(state);
      exit(1);
    }
    state->board[state->num_rows-1] = malloc((sizeof **state->board) * (strlen(line) + 1));
    strcpy(state->board[state->num_rows-1], line);
  }
  free(line);
  return state;
}

/*
  Task 6.1

  Helper function for initialize_snakes.
  Given a snake struct with the tail row and col filled in,
  trace through the board to find the head row and col, and
  fill in the head row and col in the struct.
*/
static void find_head(game_state_t* state, unsigned int snum) {
  // TODO: Implement this function.
  unsigned int cur_row = state->snakes[snum].tail_row;
  unsigned int cur_col = state->snakes[snum].tail_col;
  char cur_square = get_board_at(state, cur_row, cur_col);
  while(!is_head(cur_square)) {
    cur_row = get_next_row(cur_row, cur_square);
    cur_col = get_next_col(cur_col, cur_square);
    cur_square = get_board_at(state, cur_row, cur_col);
  }
  state->snakes[snum].head_row = cur_row;
  state->snakes[snum].head_col = cur_col;
}

/* Task 6.2 */
game_state_t* initialize_snakes(game_state_t* state) {
  // TODO: Implement this function.
  state->num_snakes = 0;
  for (unsigned int i = 0; i < state->num_rows; i++) {
    for (unsigned int j = 0; state->board[i][j] != '\0'; j++) {
      char cur_square = get_board_at(state, i, j);
      if (is_tail(cur_square)) {
        state->num_snakes++;
        state->snakes = realloc(state->snakes, state->num_snakes * (sizeof *state->snakes));
        if (state->snakes == NULL) {
          printf("out of memory\n");
          free_state(state);
          exit(1);
        }
        state->snakes[state->num_snakes-1].tail_row = i;
        state->snakes[state->num_snakes-1].tail_col = j;
        state->snakes[state->num_snakes-1].live = true;
        find_head(state, state->num_snakes-1);
      }
    }
  }
  return state;
}
