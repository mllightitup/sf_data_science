import game_v2


def game_core_v3(number: int = 1) -> int:
    """
    Args:
        number (int, optional): Загаданное число. Defaults to 1.

    Returns:
        int: Число попыток
    """
    min_value = 1
    max_value = 100
    count = 0

    while True:
        count += 1
        guessed_number = (min_value + max_value) // 2  # Бинарный поиск

        if guessed_number == number:
            break
        elif guessed_number < number:
            min_value = guessed_number + 1
        else:
            max_value = guessed_number - 1

    return count


if __name__ == "__main__":
    game_v2.score_game(game_core_v3)
