Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE96051F995
	for <lists+io-uring@lfdr.de>; Mon,  9 May 2022 12:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiEIKSM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 May 2022 06:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231812AbiEIKSJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 May 2022 06:18:09 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6430E2802DC
        for <io-uring@vger.kernel.org>; Mon,  9 May 2022 03:14:15 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id l7-20020a17090aaa8700b001dd1a5b9965so1872641pjq.2
        for <io-uring@vger.kernel.org>; Mon, 09 May 2022 03:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=OE0cJSkFezf+YJwrcp188z4Lj5GTucq0T2aibHnjxt0=;
        b=SajeCZuBmdyPkfI8OAB5Hj7ZMCe6x0blyh8N6TEAq7WLkcI8TcouENcl9fX7eJYcrp
         Ztyay3PnMC1kDLU6ORZSbFOA2zRRagVsqPTVHZPZ2ZdHNXLyFeQXxi3OxkXT5G3ziqeK
         AINMrhZugOvG170pgAVKaS88/C3wA5PgppBjGG4ZX9WS3X2601iyd90W6MXZ+Nu1JWs2
         GaU/Uo1ZkcAl9rEqOouESxe5Ibqm+YbJMbDm7gdsNh1GN3Ushzn/bDr8byyIBnzbb6zb
         6QbLiZoKmLQcX28ZCyYTqH75UjzZZXfJIVtt7tjfeEA23RqKpiYTvqnosjMW8LIZj+4r
         T1Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=OE0cJSkFezf+YJwrcp188z4Lj5GTucq0T2aibHnjxt0=;
        b=QAOEtUnNdScugWuXJhhj9A98OEL5a5x14Av1gvT2lVV1fCXAPzyGMdA6M9vAs6oCc/
         2QcXKa9pAfozeiXsD1f8Ifb+p36qQDES5159VGZ9nt5l7vz/7XoKk5y4zCul6wBJYeTo
         P8r5UQu5R7iTXdbvaCyN1t9IlJKsb24/9w/sSmkkpXeXtJTVDZu9ui1JcHCEXxvHsjuN
         sZ6tsaw8/9S6TVhaqLPogpm7AeIhynCr9h3PsMPImKpcGuXaVjK6vcpM22YKUEh85tDo
         mFLh5WXsLtNfEJt2M7NnpwaGYhn2TSSzGCbgk6UMsq0zludwK0Kv/kP3Q7vpsSU6zCHJ
         WuRQ==
X-Gm-Message-State: AOAM533lm7hp3xnEs0uye7G90yzuJBF2Oz9ldvjpcqgSwW3u2gEDkavV
        UYWSg3SCjwLvy0ppHqgEqk1JL6T3I0Tnce5509w=
X-Google-Smtp-Source: ABdhPJysgE+Z+g0UQPjwCO4voeTKfatoYDBDNHZ8hhySGppsy4DWwAp41tRGs9cN5DVXwOWi5+y9wwZcDaH7wWHd/4k=
X-Received: by 2002:a67:2f55:0:b0:32c:f723:c3a1 with SMTP id
 v82-20020a672f55000000b0032cf723c3a1mr7230249vsv.11.1652090617945; Mon, 09
 May 2022 03:03:37 -0700 (PDT)
MIME-Version: 1.0
Sender: mrsnicolemarois8@gmail.com
Received: by 2002:a59:ad29:0:b0:2ba:1a7c:5596 with HTTP; Mon, 9 May 2022
 03:03:37 -0700 (PDT)
From:   Miss Qing Yu <qing9560yu@gmail.com>
Date:   Mon, 9 May 2022 10:03:37 +0000
X-Google-Sender-Auth: 1QzRdCrs3LbEN7iLEqgTE4xX_r4
Message-ID: <CAAadsjt1BVogz9knHNotgA77nQ0fNa+h3X166WMGS_7eWcD2hA@mail.gmail.com>
Subject: Hello!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,HK_NAME_FM_MR_MRS,HK_SCAM,LOTS_OF_MONEY,MILLION_USD,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:1041 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5106]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mrsnicolemarois8[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [mrsnicolemarois8[at]gmail.com]
        *  0.0 MILLION_USD BODY: Talks about millions of dollars
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  1.2 HK_SCAM No description available.
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  1.5 HK_NAME_FM_MR_MRS No description available.
        *  2.4 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I am Mrs Yu. Ging Yunnan, and i have Covid-19 and the doctor said I
will not survive it with the critical condition am in because all
vaccines has been given to me but to no avian, am a China woman but I
base here in France because am married here and I have no child for my
late husband and now am a widow. My reason of communicating you is
that i have $9.2million USD which was deposited in BNP Paribas Bank
here in France by my late husband which am the next of kin to and I
want you to stand as the replacement beneficiary beneficiary.

Can you handle the process?

Mrs Yu. Ging Yunnan.
