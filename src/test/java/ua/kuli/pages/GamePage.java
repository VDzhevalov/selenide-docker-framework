package ua.kuli.pages;

import io.qameta.allure.Step;

import static com.codeborne.selenide.Condition.*;
import static com.codeborne.selenide.Selenide.*;

public class GamePage {

    @Step
    public void shouldHaveTitle(String expectedTitle) {
        $("h1.product-title-name").shouldHave(text(expectedTitle));
    }

    @Step
    public void shouldHaveShowAllTranslationsButton() {
        $("div#show-all-translations").shouldHave(text("Переглянути"));
    }
}
