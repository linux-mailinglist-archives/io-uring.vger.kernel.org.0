Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60CDC550769
	for <lists+io-uring@lfdr.de>; Sun, 19 Jun 2022 01:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233221AbiFRXIw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Jun 2022 19:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbiFRXIw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Jun 2022 19:08:52 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 101B111808
        for <io-uring@vger.kernel.org>; Sat, 18 Jun 2022 16:08:51 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id w2so4893850lji.5
        for <io-uring@vger.kernel.org>; Sat, 18 Jun 2022 16:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=kL1PhX7sXeKhW4fetJZNIIwt2YUz+cHdR+yLTna0v7s=;
        b=h/d+xKVd3stTE8zVCC4p+8EXg2OzJjUKViMKMDDKAHbNMVqRmDZ8oNV0VJbfkLdWWv
         VPSylieR+nOplAu2aRTWESMnngGv3tAqlnVevr7N98TZcxz0IrJMc/dQCRm4oY63chJb
         nzb0NcbDU1wQnhZGtQcW4FeGmNKkvMzPvYvwdwBMgETM07Uwrq/snwppwoTiWT6aIkU1
         bEu6WYgL9QkPSZFPH64rcvZ0QEh+0/HkoDg9fFLzBOkHTGQ28O5MfxIfsMLBlRyzxma3
         sn9Zkha+GZKBKsSH8C6p9GV1edGRR9y7jk/HSovczVzFfI7DqSHnX3QonIwfoB01O5l7
         ZZhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=kL1PhX7sXeKhW4fetJZNIIwt2YUz+cHdR+yLTna0v7s=;
        b=DJ5I+9Maob5MiHmpx/hdKMxvpfBQsCjMNxcCZiECPCjUYO56/cdL1Scw0Z5j/q4mqO
         Lh+5kuoBWdyYJvxdNqfjsBUKnetPRo4SA/c5w/jrspsen371aKh34lNE1OUh5lSG0Zgi
         liB99uh5/fbaXsJFwHC2Z2U3lwZOyRO9w1y5Y4KbRDvdYLcpJedbZmOqVGtKUoiSEJ1Q
         bf/PWQNrJSN0ruaRgqnRvcQusBf9Lwpr3l2zJhKabuIV/2kr2iDsIcZcACRoKMWpcxp3
         h/HPx20bpcNz7/yCJ0DHMt1Ntdd8VfBTbQKm4YO+AWf9kwnaMRand8NslA5L3w1+gS2s
         H0Bg==
X-Gm-Message-State: AJIora9wCdiRdpmQa0a3R9SpiGVzDK+Gna3q5W9rjeNRspBIiv+RCkgC
        2nTnSTgoWBD2YnhPLNd+B1wJjSMrdseHB9eXqKk=
X-Google-Smtp-Source: AGRyM1u0nhPOvd+z5cT6s1MX6Gr3UQb9EKUm+B3CqFd1pJ0ID+XBcypV78v7KsmM7lP76qIkRpzioWqIaekx1x3Wu9A=
X-Received: by 2002:a2e:95c8:0:b0:255:abb5:d0e7 with SMTP id
 y8-20020a2e95c8000000b00255abb5d0e7mr8097410ljh.23.1655593728859; Sat, 18 Jun
 2022 16:08:48 -0700 (PDT)
MIME-Version: 1.0
Sender: janetibrahim250@gmail.com
Received: by 2002:a05:6504:a16:0:0:0:0 with HTTP; Sat, 18 Jun 2022 16:08:48
 -0700 (PDT)
From:   Sophia Erick <sdltdkggl3455@gmail.com>
Date:   Sun, 19 Jun 2022 01:08:48 +0200
X-Google-Sender-Auth: q0t8j42lOdl4r-TSpBB5XO4-TvI
Message-ID: <CANUF9+pHBVuuGHi4=TVcuvWUy+X7d4biXgcCaWv1b5n-BcMEAg@mail.gmail.com>
Subject: HELLO
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=6.1 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FROM_LOCAL_NOVOWEL,
        HK_RANDOM_FROM,LOTS_OF_MONEY,MONEY_FRAUD_8,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_MONEY_PERCENT,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:235 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.5 FROM_LOCAL_NOVOWEL From: localpart has series of non-vowel
        *      letters
        *  1.0 HK_RANDOM_FROM From username looks random
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [janetibrahim250[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [sdltdkggl3455[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 T_MONEY_PERCENT X% of a lot of money for you
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  0.7 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello

I am glad to know you, but God knows you better and he knows why he
has directed me to you at this point in time so do not be surprised at
all. My name is Mrs.Sophia Erick, a widow, i have been suffering from
ovarian cancer disease. At this moment i am about to end the race like
this because the illness has gotten to a very bad stage, without any
family members and no child. I hope that you will not expose or betray
this trust and confidence that I am about to entrust to you for the
mutual benefit of the orphans and the less privileged ones. I have
some funds I inherited from my late husband,the sum of ($11.000.000
Eleven million dollars.) deposited in the Bank. Having known my
present health status, I decided to entrust this fund to you believing
that you will utilize it the way i am going to instruct
herein.Therefore I need you to assist me and reclaim this money and
use it for Charity works, for orphanages and giving justice and help
to the poor, needy and to promote the words of God and the effort that
the house of God will be maintained says The Lord." Jeremiah
22:15-16.=E2=80=9C

It will be my great pleasure to compensate you with 35 % percent of
the total money for your personal use, 5 % percent for any expenses
that may occur during the international transfer process while 60% of
the money will go to the charity project. All I require from you is
sincerity and the ability to complete God's task without any failure.
It will be my pleasure to see that the bank has finally released and
transferred the fund into your bank account therein your country even
before I die here in the hospital, because of my present health status
everything needs to be processed rapidly as soon as possible. Please
kindly respond quickly. Thanks and God bless you,

Yours sincerely sister Mrs. Sophia Erick.
