# Kitsu - Платформа для обучения с менторами и учениками

**Kitsu** — это мобильное приложение, разработанное с использованием Flutter и Firebase, которое предоставляет возможность для обучения в рамках системы с менторами и учениками.

В этом приложении существует две основные категории пользователей:

- **Менторы** — люди, которые обучают других.
- **Ученики** — пользователи, которые проходят обучение.

Проект включает в себя авторизацию через Firebase, создание и редактирование профилей пользователей, а также функциональность для общения и обучающих материалов.

## Стек технологий

- **Flutter** — для разработки мобильного приложения.
- **Firebase** — для хранения данных и аутентификации.
- **Firestore** — для работы с базой данных.
- **Firebase Authentication** — для аутентификации пользователей.

## Возможности приложения

- **Авторизация и регистрация**: Возможность регистрации новых пользователей и авторизации для существующих.
- **Профили пользователей**: У каждого пользователя есть личный профиль, который можно редактировать.
- **Роли пользователей**: Приложение различает пользователей по ролям: ментор и ученик.
- **Платформа для обучения**: Менторы могут создавать курсы, а ученики — записываться на них и отслеживать свой прогресс.

## Как запустить проект

### Шаг 1: Клонирование репозитория

Сначала клонируйте репозиторий на ваш локальный компьютер:

```bash
git clone https://github.com/yourusername/kitsu.git
```
```bash
cd kitsu
```
```bash
flutter pub get
```
