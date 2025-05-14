package ua.kuli.pages;

import com.codeborne.selenide.Condition;
import io.qameta.allure.Step;

import static com.codeborne.selenide.CollectionCondition.sizeGreaterThan;
import static com.codeborne.selenide.Condition.text;
import static com.codeborne.selenide.Selenide.*;

public class MainPage {

    public void openMainPage() {
        open("/");
    }

    @Step
    public SearchResultPage searchFor(String query) {
        $("input#small-searchterms").setValue(query).pressEnter();
        return new SearchResultPage();
    }

    @Step
    public void shouldHaveMenuLinks() {
        $(".header-actions__menu").$$("a").shouldHave(sizeGreaterThan(0));
    }

    @Step
    public void pageTitleShouldContain(String expected) {
        $("h1").shouldHave(text(expected));
    }
}