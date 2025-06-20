// lib/data/quiz_data.dart
import '../models/quiz_models.dart';

final List<QuizQuestion> romanEmpireQuestions = [
  QuizQuestion(
    question: 'Uno dei personaggi più famosi della storia romana è stato Giulio Cesare. Ma qual era il titolo ufficiale del leader dell\'Impero Romano?',
    answers: ['Imperatore', 'Console', 'Re', 'Senatore'],
    correctAnswerIndex: 0,
    imagePath: 'assets/caesar.png', // Assicurati che l'immagine esista
  ),
  QuizQuestion(
    question: 'Nella vita romana c\'era un luogo dove si facevano affari e si incontravano i cittadini. Com\'era chiamato il mercato centrale dell\'antica Roma?',
    answers: ['Il Foro', 'Il Colosseo', 'Il Pantheon', 'La Domus'],
    correctAnswerIndex: 0,
    imagePath: 'assets/forum.png', // Assicurati che l'immagine esista
  ),
  QuizQuestion(
    question: 'Qual era la lingua parlata nell\'Impero Romano?',
    answers: ['Greco', 'Latino', 'Aramaico', 'Ebraico'],
    correctAnswerIndex: 1,
    imagePath: 'assets/lingua.png',
  ),
  QuizQuestion(
    question: 'Quale imperatore romano rese il Cristianesimo la religione di Stato?',
    answers: ['Costantino', 'Nerone', 'Augusto', 'Diocleziano'],
    correctAnswerIndex: 0,
    imagePath: 'assets/costantino.jpg',
  ),
  QuizQuestion(
    question: 'Qual era il nome della famosa strada che collegava Roma a Brindisi?',
    answers: ['Via Aurelia', 'Via Salaria', 'Via Appia', 'Via Flaminia'],
    correctAnswerIndex: 2,
    imagePath: 'assets/appia.jpg',
  ),
  QuizQuestion(
    question: 'Quale animale era sacro a Marte, il dio della guerra romano?',
    answers: ['Lupo', 'Aquila', 'Cavallo', 'Toro'],
    correctAnswerIndex: 0,
    imagePath: 'assets/lupo.jpg',
  ),
  QuizQuestion(
    question: 'Qual era la dea romana dell\'amore e della bellezza?',
    answers: ['Giunone', 'Minerva', 'Venere', 'Diana'],
    correctAnswerIndex: 2,
    imagePath: 'assets/venere.jpg',
  ),
  QuizQuestion(
    question: 'Quale struttura romana era famosa per le battaglie dei gladiatori?',
    answers: ['Il Pantheon', 'Il Circo Massimo', 'Le Terme di Caracalla', 'Il Colosseo'],
    correctAnswerIndex: 3,
    imagePath: 'assets/gladiator.jpg',
  ),
  QuizQuestion(
    question: 'Quale fiume attraversa Roma?',
    answers: ['Arno', 'Po', 'Tevere', 'Adige'],
    correctAnswerIndex: 2,
    imagePath: 'assets/tevere.jpg',
  ),
  QuizQuestion(
    question: 'Chi fu il primo imperatore romano?',
    answers: ['Giulio Cesare', 'Augusto', 'Nerone', 'Tiberio'],
    correctAnswerIndex: 1,
    imagePath: 'assets/augusto.jpg',
  ),
];

final List<QuizQuestion> frenchRevolutionQuestions = [
  QuizQuestion(
    question: 'In che anno ebbe inizio la Rivoluzione Francese?',
    answers: ['1776', '1789', '1799', '1804'],
    correctAnswerIndex: 1,
    imagePath: 'assets/napoleon.png', // Puoi usare la stessa immagine o una specifica
  ),
  QuizQuestion(
    question: 'Chi era il re di Francia all\'inizio della Rivoluzione?',
    answers: ['Luigi XIV', 'Luigi XV', 'Luigi XVI', 'Luigi XVIII'],
    correctAnswerIndex: 2,
  ),
  QuizQuestion(
    question: 'Quale evento segnò l\'inizio simbolico della Rivoluzione Francese?',
    answers: ['La presa della Bastiglia', 'La marcia su Versailles', 'Il giuramento della Pallacorda', 'La fuga di Varennes'],
    correctAnswerIndex: 0,
  ),
  QuizQuestion(
    question: 'Quale fu il periodo di violenza e terrore durante la Rivoluzione, guidato da Robespierre?',
    answers: ['Il Grande Terrore', 'Il Regime del Terrore', 'La Ghigliottina', 'La Grande Paura'],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: 'Quale documento fondamentale della Rivoluzione affermava i diritti dell\'uomo e del cittadino?',
    answers: ['Costituzione Francese', 'Dichiarazione d\'Indipendenza', 'Dichiarazione dei Diritti dell\'Uomo e del Cittadino', 'Codice Napoleonico'],
    correctAnswerIndex: 2,
  ),
  QuizQuestion(
    question: 'Chi fu il generale che pose fine alla Rivoluzione Francese e divenne imperatore?',
    answers: ['Maximilien Robespierre', 'Georges Danton', 'Jean-Paul Marat', 'Napoleone Bonaparte'],
    correctAnswerIndex: 3,
  ),
  QuizQuestion(
    question: 'Qual era il simbolo principale della ghigliottina, l\'arma della Rivoluzione?',
    answers: ['Libertà', 'Uguaglianza', 'Fraternità', 'Morte'],
    correctAnswerIndex: 3,
  ),
  QuizQuestion(
    question: 'Quale fu l\'organo esecutivo che governò la Francia dopo la fase più radicale della Rivoluzione?',
    answers: ['Il Comitato di Salute Pubblica', 'Il Direttorio', 'La Convenzione Nazionale', 'L\'Assemblea Legislativa'],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: 'Qual era il motto della Rivoluzione Francese?',
    answers: ['Liberté, égalité, fraternité', 'Vivre libre ou mourir', 'La Nation, la Loi, le Roi', 'Du peuple, par le peuple, pour le peuple'],
    correctAnswerIndex: 0,
  ),
  QuizQuestion(
    question: 'Quale fu la battaglia che segnò la sconfitta finale di Napoleone?',
    answers: ['Battaglia di Austerlitz', 'Battaglia di Trafalgar', 'Battaglia di Waterloo', 'Battaglia di Borodino'],
    correctAnswerIndex: 2,
  ),
];