Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C964D6FEFF4
	for <lists+io-uring@lfdr.de>; Thu, 11 May 2023 12:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237671AbjEKKbn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 May 2023 06:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237872AbjEKKbR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 May 2023 06:31:17 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB139ECF
        for <io-uring@vger.kernel.org>; Thu, 11 May 2023 03:30:55 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id 2adb3069b0e04-4f24d4900bbso5878947e87.3
        for <io-uring@vger.kernel.org>; Thu, 11 May 2023 03:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683801054; x=1686393054;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ea5EsVfSPs6miZODjcYZrrG1DH5IFW4cy6+9nRxfFgM=;
        b=kagn/b+0ltByB1NvWh++ENyYIuzc0n+q7KGZhsNOhcoTWa9aeSlv0KNIXYnnH0o9Fs
         zU3+WRr3H89N5b1+a/E2odDxbs8CusUSDJCFmiZkPSfsa3ZXSp7eGM9EYwKyEtrayKp3
         1jtzu9M8XHk7a1xciFlBNrf9rB6S9Ddc19nlDQRHYjGHbks27p0qgiDOdPH+lF4O8G3u
         Qal8wHUkV8rotjNeMUt06LLJ7PdM9a1p/dyf9DCd935oL5TWn8MAUEP+7SrcolbtB3po
         l+FktkHkuSiv+06TJjW/K76HWpsrZQKeGyjmxaol+38KCoU+bEWbRqGpi0gdUmCPt3SH
         AErQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683801054; x=1686393054;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ea5EsVfSPs6miZODjcYZrrG1DH5IFW4cy6+9nRxfFgM=;
        b=G6AqYIEZm0zL2TPVGYnAXtYv3fzKJLMuMdp31pGd9wJnx/QlanDYjeUqELXW9KyYnx
         QAyuHSxg0FmMHsMeGapNhv/6Uz7wxXMMud6FvSTkuDFzOTXGztd6nwnteqND7kZ1td04
         Z1oKWDMldDSSJjCwwaFsYZbaAGmE9uPKZTT7jZsyqhLNmVAhbPvlxCzpxfsaehQL2TSA
         PngrVQ6qkZbayXz6anOUshBLsAR/YtzHsatQe6JZmxWoJ1JTXh2CgBxJHo3jDNs728Kz
         MLdcPuVDM6onNJzbX63ONB5B3Z9cfXhT9TAK2X2z0HDIWNT9mlhrNxR9ih6rK/c+LOSN
         JWAA==
X-Gm-Message-State: AC+VfDz3U3Vi+exmltJr5HHv0ZIbUQkyEZYlGGeH3MBFpqxJwvLT+rKN
        8toAzN2gOZf7FHexuuh+hUkeut4AHOzCIOnQINo=
X-Google-Smtp-Source: ACHHUZ5FrdmEg+aUOVERX4xM0Wr60fyUtHkQXnKpKhroVBE6ZOePC0MeUlkDRWOfzCsoYv0BZpad50U+UXi3AFBzupQ=
X-Received: by 2002:ac2:529b:0:b0:4f1:4996:7e84 with SMTP id
 q27-20020ac2529b000000b004f149967e84mr2567736lfm.34.1683801053824; Thu, 11
 May 2023 03:30:53 -0700 (PDT)
MIME-Version: 1.0
Sender: larruben995@gmail.com
Received: by 2002:ab3:6886:0:b0:224:22e9:91ee with HTTP; Thu, 11 May 2023
 03:30:53 -0700 (PDT)
From:   Sophia Erick <sdltdkggl3455@gmail.com>
Date:   Thu, 11 May 2023 12:30:53 +0200
X-Google-Sender-Auth: LzjrLjoU2lxJDy42yXVFSKIwfo8
Message-ID: <CAPoE+8PP4UN0jkafdiL4f4TPKOat_A53m2PATzMw2rRZZ=n5KA@mail.gmail.com>
Subject: HELLO
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.3 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FROM_LOCAL_NOVOWEL,
        HK_RANDOM_FROM,LOTS_OF_MONEY,MONEY_FRAUD_8,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_MONEY_PERCENT,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:129 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.5 FROM_LOCAL_NOVOWEL From: localpart has series of non-vowel
        *      letters
        *  0.0 HK_RANDOM_FROM From username looks random
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [larruben995[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [larruben995[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 T_MONEY_PERCENT X% of a lot of money for you
        *  0.0 MONEY_FRAUD_8 Lots of money and very many fraud phrases
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  2.9 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

With tears in my eyes and grief in my heart, I am writing this email
to you, my name is Mrs.Sophia Erick, I am from Tunisia, I am
contacting you in a hospital in
Burkina Faso, I want to tell you this because I have no choice but to
tell you, because I am moved to open my heart to you, I am married to
Mr. Sofia, who in 2011 He worked with the Tunisian ambassador to
Burkina Faso for nine years before his death in 2009. We have been
married for eleven years and have no children.
He died after a brief illness that lasted only five days. Since his
death I decided not to remarry, my late husband was alive. He
deposited the sum of  ( Eleven Million Dollars) in a bank in
Ouagadougou, the capital of Burkina Faso, West Africa. The money is
still in the bank. He used the money to export gold from the mining
industry in Burkina Faso. Recently, my doctor told me that I couldn't
last seven months because of cancer and a stroke. What bothered me the
most was my stroke. Knowing my situation, I have decided to hand over
this money to you to take care of the vulnerable and you will use it
in the manner I will instruct here.
I want you to take out 30% of the total amount for your personal use
And 70% of the money you will use to build an orphanage in my name to
help the poor on the street. I grew up as an orphan without anyone as
my family, just to maintain God's family I do this so that God will
forgive my sins and accept my soul in heaven, because this disease has
caused me a lot

As soon as I hear back from you I will give you the contact details of
the Bank of Burkina Faso and I will also instruct the bank manager to
send you a power of attorney certifying that you are the current
beneficiary of the money in the bank if you said Yes please assure me
that you will act in the manner I declare here.

Mrs. Sophia Erick.
