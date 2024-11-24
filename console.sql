create table if not exists Genres (
    id serial primary key,
    name varchar(20) not null
);

create table if not exists Artist (
    id serial primary key,
    name varchar(40) not null
);

create table if not exists Albums (
    id serial primary key,
    title varchar(20) not null,
    release_year integer
);

create table if not exists Tracks (
    id serial primary key,
    title varchar(20) not null,
    duration integer,
    album_id integer references albums(id)
);


create table if not exists artist_genre (
    artist_id int references artist(id),
    genre_id int references genres(id)
);


create table if not exists artist_album (
    artist_id int references artist(id),
    album_id int references albums(id)
);


create table if not exists compilations (
    id serial primary key,
    name varchar(20) not null,
    release_year integer
);


create table if not exists compilations_tracks (
    compilations_id int references compilations(id),
    track_id int references tracks(id));


insert into artist (name)
values ('Nickelback'), ('Валерий Кипелов'), ('Валерий Миладзе'), ('Eminem');


insert into genres (name)
values ('Pock'), ('Rap'), ('Pop');


insert into albums (title, release_year)
values ('Silver Side Up', 2001), ('Recovery', 2010), ('Судьба', 2019);


insert into tracks (title, duration, album_id) values
('How You Remind Me', 223, 1), ('Not Afraid', 248, 2), ('Мой путь', 305, 3), ('My Love', 225, 2), ('Память', 252, 3), ('Обними меня', 200, null);


insert into compilations (name, release_year) values
('Лучшее 2018', 2018), ('Рок-классика 2019', 2019), ('Топ-40 хитов 2020', 2020), ('Лучшие баллады', 2021);


insert into artist_genre (artist_id, genre_id) values
((select id from artist where name = 'Eminem'), (select id from genres where name = 'Rap')),
((select id from artist where name = 'Валерий Кипелов'), (select id from genres where name = 'Pock')),
((select id from artist where name = 'Валерий Миладзе'), (select id from genres where name = 'Pop')),
((select id from artist where name = 'Nickelback'), (select id from genres where name = 'Pock'));


insert into artist_album (artist_id, album_id) values
((select id from artist where name = 'Eminem'), (select id from albums where title = 'Recovery')),
((select id from artist where name = 'Валерий Кипелов'), (select id from albums where title = 'Судьба')),
((select id from artist where name = 'Nickelback'), (select id from albums where title = 'Silver Side Up'));


insert into compilations_tracks (compilations_id, track_id) values
((select id from compilations where name = 'Лучшее 2018'), (select id from tracks where title = 'How You Remind Me')),
((select id from compilations where name = 'Лучшее 2018'), (select id from tracks where title = 'Not Afraid')),
((select id from compilations where name = 'Рок-классика 2019'), (select id from tracks where title = 'Мой путь')),
((select id from compilations where name = 'Рок-классика 2019'), (select id from tracks where title = 'Память')),
((select id from compilations where name = 'Топ-40 хитов 2020'), (select id from tracks where title = 'My Love')),
((select id from compilations where name = 'Топ-40 хитов 2020'), (select id from tracks where title = 'Обними меня')),
((select id from compilations where name = 'Лучшие баллады'), (select id from tracks where title = 'Обними меня'));


select title, duration from tracks
order by duration desc
limit 1;


select title from tracks
where duration >= 210;


select name from compilations
where release_year between 2018 and 2020;


select name from artist
where name not like '% %';


select title from tracks
where lower(title) like '%мой%' or lower(title) like '%my%';


select genres.name as genre_name, count(artist_genre.artist_id) as artist_count
from genres
left join artist_genre on genres.id = artist_genre.genre_id
group by genres.name
order by artist_count desc;


select count(tracks.id) as track_count
from tracks
join albums on tracks.album_id = albums.id
where albums.release_year between 2019 and 2020;


select albums.title, avg(tracks.duration)
from albums
join tracks on albums.id = tracks.album_id
group by albums.title
order by avg(tracks.duration) desc;


select artist.name
from artist
left join artist_album on artist.id = artist_album.artist_id
left join albums on artist_album.album_id = albums.id
where albums.release_year != 2020 or albums.release_year is null;


select compilations.name
from compilations
join compilations_tracks on compilations.id = compilations_tracks.compilations_id
join tracks on compilations_tracks.track_id = tracks.id
join artist_album on tracks.album_id = artist_album.album_id
join artist on artist_album.artist_id = artist.id
where artist.name = 'Eminem';
