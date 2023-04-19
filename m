Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1D666E8112
	for <lists+io-uring@lfdr.de>; Wed, 19 Apr 2023 20:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbjDSSOu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 14:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233646AbjDSSOo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 14:14:44 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7906FE53
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 11:14:28 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-187edc01fa3so24480fac.3
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 11:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681928068; x=1684520068;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=o3b1j9earyKDPLXja95cUoLYgB+R59ZB0hBsTrgJDpA=;
        b=al5bsBTgf3aQOyFxwbvGK3zclHAjx60P/gAQzUPTuqGUnHM3tvqYA7pNt5PzVdCvAV
         Z3aRdnvn/1T75fhAsLDvGi4x1E8LcOronhG+CeidOnbFB6iN+AWRIhPi4EfkNawHbnRr
         n+N5qUrmMbS+Ow/sqPE0+4MAlkABotPnOKBd1xEEPexw80TlOkJ5Vfh0uprY+7xjI21a
         EVkGsJE0TW3p0ctu5Tz+NHrNE/3wmJVM2czffYuQWvsxSFFSBzxhheCNjUCkQbuZkr/Q
         9xZSeTS+OLkndazMd272h1VrhDh0tw7LeJyAT8hijfkGsYYQbB438LPUHuEa9xNWddN2
         RW5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681928068; x=1684520068;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o3b1j9earyKDPLXja95cUoLYgB+R59ZB0hBsTrgJDpA=;
        b=LU0CSOMwMXcwHs0ixqd29gK7IJ32ebqZ8jfbMYbNyeSIEMgVA/mfpRLdbFz3e8IFJw
         OfToHR8a94Q0gNIUP+zKBUddXAlQKeDSbGpwPhYwwyIkUKSckR+cyd6v4VMn+Hy6EOe+
         z66ZPxRU0S9HHMmgKzmUmNiW6fZTcvRqkWx+cbb/73UvWo6GY4EXdsuSIhvN8ejMd3Fg
         Y7xBCnxsZ7LSsOglZFwDO+STDmDJNAmiypG3/s5DW4FiNutFT3D99fLerL+KUf/7Pn0V
         ZXLxDFSRdH3e+q6sP2z5EjhrMuTsb6NPpzEidCrhaEtW2Jx2AGk09yZHhS3wzqPkaa+p
         jnHA==
X-Gm-Message-State: AAQBX9dLCb/tTbhgv1xmp+ZO8bi3ZRy9S+T7tFrMgVaylFkL9jApPN1z
        WncNctN0JcxTD5gf+Pigh5RltuOKJ9R0vZsRLw==
X-Google-Smtp-Source: AKy350YTmSXtQSpOAfB/YEEmSHMC/Sled8rewIgI5n/JEN6PLug5bBd+Br4n2Je70pqjBoUlDQOJl3SRZJe07Z0WMhw=
X-Received: by 2002:a05:6870:9a1d:b0:187:b646:a735 with SMTP id
 fo29-20020a0568709a1d00b00187b646a735mr442811oab.13.1681928067809; Wed, 19
 Apr 2023 11:14:27 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6870:3451:b0:17a:b0cb:f50e with HTTP; Wed, 19 Apr 2023
 11:14:27 -0700 (PDT)
Reply-To: angelikasibyle@gmail.com
From:   Angelika SIBYLLE <anthonharmsworth@gmail.com>
Date:   Wed, 19 Apr 2023 20:14:27 +0200
Message-ID: <CAHQq_ms5obD4X7bY9pbPuaY-++v88BLO9OhtAckTnJXLRWRH-A@mail.gmail.com>
Subject: Guten Morgen
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2001:4860:4864:20:0:0:0:36 listed in]
        [list.dnswl.org]
        * -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
        *      [score: 0.0000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [anthonharmsworth[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.0 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  2.2 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  3.2 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Guten Morgen
  Mein Name ist Frau Angelika SYBILLE mit deutscher
Staatsangeh=C3=B6rigkeit. Ich wende mich an Sie, um Ihnen mein Eigentum zu
schenken.  Wie wir
  Ich kenne die Gnade Gottes nicht, ich habe dich ausgew=C3=A4hlt, weil mir
mein geistlicher Vater geraten hat, eine zuf=C3=A4llige Person im Internet
auszuw=C3=A4hlen, und es ist eine Gnade, auf dich zu sto=C3=9Fen.  Ich leid=
e an
einer schweren Krankheit, die mich in den sicheren, verdammten Tod
bringt: Es ist Kehlkopfkrebs.  Meine letzten Analysen haben gezeigt,
dass meine Tage gez=C3=A4hlt sind, vor drei Jahren habe ich meinen Vater
verloren.  Ich und mein verstorbener Mann haben eine gro=C3=9Fe Geldsumme,
aber leider hatten wir keine Kinder, die nach meinem Tod von diesem
Geld profitieren werden, es ist eine Summe von einer Million
zweihundertf=C3=BCnfundzwanzigtausend Euro (1.225.000.00=E2=82=AC). werde z=
ur Bank
zur=C3=BCckkehren, wenn ich dieses Geld nicht schnell spende.  Ich habe
Angst, dass die Bank diesen riesigen Geldbetrag ausnutzen wird, ohne
den =C3=84rmsten und =C3=84rmsten helfen zu k=C3=B6nnen, deshalb m=C3=B6cht=
e ich dieses
Geld einer vertrauensw=C3=BCrdigen, ehrlichen Person, die Gottesfurcht hat,
schenken welche 50 % dieses Geldes verwendet werden, um den =C3=A4rmsten
Menschen um ihn herum zu helfen.  Ich habe dich ausgew=C3=A4hlt, um dir
dieses Geld zu geben, ich brauche nur deine Gebete f=C3=BCr den Rest meiner
Seele.  Ich gebe Ihnen dieses Geld von ganzem Herzen.
  Ich habe alle Dokumente, um die Echtheit meiner Spende nachzuweisen,
und sie wird von den Beh=C3=B6rden genehmigt.  Bitte schreiben Sie mir an
meine E-Mail-Adresse, um weitere Einzelheiten zu meiner Spende zu
erfahren
 angelikasibyle@gmail.com

 Frau Angelika SIBYLE

 angelikasibyle@gmail.com
