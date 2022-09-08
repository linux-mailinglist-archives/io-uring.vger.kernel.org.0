Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 134615B2383
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 18:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbiIHQXT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 12:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiIHQXR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 12:23:17 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 263B5F8274
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 09:23:16 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id d82so4809884pfd.10
        for <io-uring@vger.kernel.org>; Thu, 08 Sep 2022 09:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date;
        bh=9ZFpt/foVGQHDYdWFxLDfNkzYkIk3H2JJygdZbdIkYI=;
        b=FyLwdLQ7UhDTQCypyEtHxXGispxWhs6fUxIOxX2F5CDjYOey4m6oH4xx5AyLmj3OmH
         INyF91lWnQH3rjqffbkea4UOyrQML7QHMMM6NZgu5Vy5uG6ShWnKTm0gJbMi5bcDDo7t
         1FP3Rqx3adbu818tlFBRxKR8goK+Y/B4VToEQfYvuNqAbF5zHOKuu4jOKPYUc0B/4bCu
         ebDq4juV0hbQS1s5rubhoOLYcREd0uzl3de8PQadzMVr2oJDq4gXD2S7CGtEnKjHuxiT
         0C8rECvQA/fWVum60fsW2dc36fA5HYlZfHNphCJ53/aXCfA+qCtjBTv++fmQCKTTdCcq
         O5SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=9ZFpt/foVGQHDYdWFxLDfNkzYkIk3H2JJygdZbdIkYI=;
        b=Gd+AwhKxNnbZ3femx0bV+rCieVauA9zG0/UdWToqOp4g1cKN6M6dd6RDURXwfynX9q
         FuUmpRlEsp3MqGwa9gn9dCHn2Ok3Uggn+4cQkdDJAjGjKTsOIApBnw4tHnQ2Qp/ODOzT
         nYJXd/v1dsLr6l4qeLdqrww8JSAYngsiRCwBmSfwVBso71ewaA7be4TmNKXK/tNvrH1W
         DqJsge1seZMk3QAQgheGDHjHpjP0X02nRsfUDBplnGOMMo5pQVrJ/QJq3T51nCmETK3C
         jDQ6KyXej2I226DTxvSYnTJp85Gry0ZoktuO2kf3vL4Uqe/fdDSYaA/JVauBg4IN+w50
         1mNw==
X-Gm-Message-State: ACgBeo0j3C1mBqf96YjX7wS6b6E/p08x+4L7OreVvU4h/4TRTxfzNG+V
        9EOKgn7tK9Fkm2VuRQlwVU3Di5s+j4nk1mUKY/o=
X-Google-Smtp-Source: AA6agR4Zklew1RH5dCrhQC2ZTO6Syutok9QRZXxkz8VSHFyIWEeBk2ckEvzAE0PVaAIOZr+GZEI8/gnWR3g7MiBgYQw=
X-Received: by 2002:a05:6a00:4c1a:b0:540:d5de:7c42 with SMTP id
 ea26-20020a056a004c1a00b00540d5de7c42mr184241pfb.84.1662654195675; Thu, 08
 Sep 2022 09:23:15 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a20:12d4:b0:8e:e10d:7a77 with HTTP; Thu, 8 Sep 2022
 09:23:14 -0700 (PDT)
Reply-To: cfc.ubagroup09@gmail.com
From:   Kristalina Georgieva <unitedbankafrica962@gmail.com>
Date:   Thu, 8 Sep 2022 09:23:14 -0700
Message-ID: <CAPbXNa0G+Mxa9wLK8T3jFEOwxS3EtXGKqYGV0EDHRs0vPeQ3EA@mail.gmail.com>
Subject: XUSH HABAR
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hurmatli Benefisiar,
Men sizga bir oy oldin bu xatni yuborgan edim, lekin sizdan xabar yo'q, yo'=
q
Ishonchim komilki, siz uni oldingiz va shuning uchun uni yana sizga yubordi=
m,
Avvalo, men Kristalina Georgieva xonim, boshqaruvchi direktor va
Xalqaro valyuta jamg'armasi prezidenti.

Aslida, biz atrofdagi barcha to'siqlar va muammolarni ko'rib chiqdik
sizning to'liq bo'lmagan tranzaksiyangiz va to'lovlarni to'lay olmasligingi=
z
o'tkazish to'lovlari olinadi, sizga qarshi, imkoniyatlari uchun
oldingi transferlar, tasdiqlash uchun bizning saytimizga tashrif buyuring 3=
8
=C2=B0 53'56 =E2=80=B3 N 77 =C2=B0 2 =E2=80=B2 39 =E2=80=B3 Vt

Biz Direktorlar kengashi, Jahon banki va Valyuta jamg'armasimiz
Vashingtondagi Xalqaro (XVF) Departamenti bilan birgalikda
Amerika Qo'shma Shtatlari G'aznachiligi va boshqa ba'zi tergov idoralari
Amerika Qo'shma Shtatlarida bu erda tegishli. buyurdi
Bizning Chet eldagi to'lov pul o'tkazmalari bo'limi, Birlashgan Bank
Afrika Lome Togo, sizga VISA kartasini chiqarish uchun, bu erda $
Sizning fondingizdan ko'proq pul olish uchun 1,5 million.

Tekshiruvimiz davomida biz aniqladik
Sizning to'lovingiz korruptsionerlar tomonidan kechiktirilganidan xafa bo'l=
ing
Sizning mablag'laringizni hisoblaringizga yo'naltirishga harakat qilayotgan=
 bank
xususiy.

Va bugun biz sizning mablag'ingiz Kartaga o'tkazilganligi haqida xabar bera=
miz
UBA Bank tomonidan VISA va u ham yetkazib berishga tayyor. Hozir
UBA Bank direktori bilan bog'laning, uning ismi janob Toni
Elumelu, elektron pochta: (cfc.ubagroup09@gmail.com)
ATM VISA kartangizni qanday qabul qilishni aytib berish.

Hurmat bilan,

Kristalina Georgieva xonim
