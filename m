Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6247B573FED
	for <lists+io-uring@lfdr.de>; Thu, 14 Jul 2022 01:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbiGMXJB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Jul 2022 19:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiGMXI7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Jul 2022 19:08:59 -0400
Received: from mail-oa1-x41.google.com (mail-oa1-x41.google.com [IPv6:2001:4860:4864:20::41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB1D1901D
        for <io-uring@vger.kernel.org>; Wed, 13 Jul 2022 16:08:58 -0700 (PDT)
Received: by mail-oa1-x41.google.com with SMTP id 586e51a60fabf-10c0430e27dso461585fac.4
        for <io-uring@vger.kernel.org>; Wed, 13 Jul 2022 16:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=eWssZ8ZNk3gocz18m8mxnb0jwQqX8IeZqZTs5Fk7aHM=;
        b=QTTcUNuuxhlzjNaiKOLDwkjaE3mG/iqa/T9Uw+kGx/85+TyzJmP1XqQEy4tH6zxYS4
         Mp+lSIMdl/ITfh3xPeZ1ESfv9H/6DSIoa+6aznnOmiclS3Y4qR+CoMrinFtqDlsnTHTO
         3mHIV9H8t2ihrZfozS8KMylErMy9O8vXVcdJaqGMgFrFGzl0EAySmt0YdwW1mLazfJeC
         8hwiK/hoPgIh0inasZMZcF1C5R6sWRrKhUGYSo8yDoQvOGVvlGHn6NJe1zWwS4Ur0gHQ
         lhkJmK82JjolA1kzwMNfy+giBnNANqXqJGG5RaPfwkBvNciAc7x0WJKOx57mMy3S0bM1
         kTrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=eWssZ8ZNk3gocz18m8mxnb0jwQqX8IeZqZTs5Fk7aHM=;
        b=Fb3SZfV2kkiq8hBS03+bkYt+hOxPyYeFyEqILUM1l4oIO6qB7XLkf24nXCGyJXxyDD
         N9NaWldoXv/mRTS6PBAbeLQomJggSN5epnytNOT0r548WaGDKJh+zgzV3PhmvKujN/Z6
         nQQRctNBOK0ApbRobggdUgmGALQ34KSXQI12Lz4YsYzX4rgpIG9QVaRybrYp1hDvL30b
         lBymbBug5QWts4/S5JY0nP1coUw40MA8o6ZHVU3rPiVRTOCUKL6yC4qExMcuYhbxYwxF
         lcm9iimhue2qSl+2f+/reU0vha0EDiaTXkHeJNZrJ4nJ06Qb/y33PTu1lOJnO5Lf+lT/
         mZYg==
X-Gm-Message-State: AJIora/yHRp1QdQGc5gMVF/mUfdX5YYyHcy1NGq2a53ubTByF3Z3O4mL
        nsJPgjtv1EnBFTwSL/j25glqFtNdpg1dxQj3udU=
X-Google-Smtp-Source: AGRyM1vVWbp6yC3nUEvRz5neq45m5LqvoUeL4V3cb4aevoJEOkyjp0R1XvA9G9ME95y9/JudLJ70ZU2wOTGli+CS7go=
X-Received: by 2002:a05:6870:b005:b0:10c:1c42:4f7e with SMTP id
 y5-20020a056870b00500b0010c1c424f7emr5814886oae.252.1657753737329; Wed, 13
 Jul 2022 16:08:57 -0700 (PDT)
MIME-Version: 1.0
Sender: samco.chambers1988@gmail.com
Received: by 2002:a05:6358:a087:b0:a3:1662:bcab with HTTP; Wed, 13 Jul 2022
 16:08:56 -0700 (PDT)
From:   Doris David <mrs.doris.david02@gmail.com>
Date:   Wed, 13 Jul 2022 16:08:56 -0700
X-Google-Sender-Auth: dzdwpg30E-FZtMTo8mBDBwjpW5M
Message-ID: <CACePhLnwh_=Wjg-xe_2QBxdAhuQ-25siX_522YV24orGDgd_FQ@mail.gmail.com>
Subject: Re: Greetings My Dear,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.5 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,MONEY_FRAUD_8,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2001:4860:4864:20:0:0:0:41 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [samco.chambers1988[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [samco.chambers1988[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  2.7 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Greetings,

I sent this mail praying it will find you in a good condition, since I
myself am in a very critical health condition in which I sleep every
night  without knowing if I may be alive to see the next day. I am
Mrs.Doris David, a widow suffering from a long time illness. I have
some funds I  inherited from my late husband, the sum of
($11,000,000.00) my Doctor told me recently that I have serious
sickness which is a cancer problem. What disturbs me most is my stroke
sickness. Having known my condition, I decided to donate this fund to
a good person that will utilize it the way I am going to instruct
herein. I need a very honest God.

fearing a person who can claim this money and use it for charity
works, for orphanages, widows and also build schools for less
privileges that will be named after my late husband if possible and to
promote the word of God and the effort that the house of God is
maintained. I do not want a situation where this money will be used in
an ungodly manner. That's why I' making this decision. I'm not afraid
of death so I know where I'm going. I accept this decision because I
do not have any child who will inherit this money after I die. Please
I want your sincere and urgent answer to know if you will be able to
execute this project, and I will give you more information on how
thunder will be transferred to your bank account. I am waiting for
your reply.

May God Bless you,
Mrs.Doris David,
