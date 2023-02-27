Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5178D6A35F0
	for <lists+io-uring@lfdr.de>; Mon, 27 Feb 2023 01:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbjB0A24 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 26 Feb 2023 19:28:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjB0A2z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 26 Feb 2023 19:28:55 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8714CA24A
        for <io-uring@vger.kernel.org>; Sun, 26 Feb 2023 16:28:53 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id k37so3265994wms.0
        for <io-uring@vger.kernel.org>; Sun, 26 Feb 2023 16:28:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xQnJvz9r//i40Q6M6D7Mlr1MIPxNoULnq+BRFHU1d6A=;
        b=lNQRkBW3mXT698WKQQNDF5hVpWndz/ftRGGYzsDf9qNReqb1dAN6SKRYCTS9TtQ756
         SCNUgp/WM2VfqWE94S0ov+2fQsu8+snNvvIOwqB9bn06NkpchnFUvxTRQlQ8HugrUgaq
         o4jk0z+ftZpyqct7b82D1lVunGvO6PiS7GlNH1FPS0n/To6u/bSNm3IBiwc/2B7HKt8m
         NoLn1NCMB9LLhwm6HvmPOzJorMWfgLtiCIPpg3rxHdEvFEZ1sU4X+eJox4SHhX5jgstG
         6juJlG3KeK/Ypj+a9xla5KaU8/lAu1SWTliS7/YyVUTwfIgAJkTM14ObfN6fBYZFkwi7
         9C8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xQnJvz9r//i40Q6M6D7Mlr1MIPxNoULnq+BRFHU1d6A=;
        b=Pit/rEOlXCW+3KiIeA3+6VFHJGQr4y3G557OUZc1f/4ms4ytg0WoY1ecKYmL2ZmB4T
         YE+eqNp2DQsleHaQKtR31vN6kPTABsKdiBm/lSrn+CA48nVbcfLZN/mQI6sJZoDAf5sw
         +Wui2rwB4OdDBstUONzlCNYfkVp0Gf2KIpdiwDTeO35saes7sjBf8lChaixCRdNe/oAG
         ZJcfbY3df0SJKq09I7jW7ODl4RX9Q1opq357Rj09uaTUHMUr9Ay0d1n6Z+Ki9Pt0zXit
         WRdMwwP8rHRRcvlGta5um0dDNnWmtCSnt81rJEl3ECAY4ud45NuP1j48j/Tc00tTiBgf
         q35g==
X-Gm-Message-State: AO0yUKVvtO1h77vgmd8ndTX6cxweI3dYycHlJztOeRo1zJpVNiFZQIds
        nT2Zln4lenW/5xxw5YzjXPUVVuAdmIr09ngqMWI=
X-Google-Smtp-Source: AK7set9qfdmeSrd19nfTWM1cr3oKrPd+bMT1RRiC4G6nqiqI1AL6Rt8aouUNDZYDZZ7g83kYmA1mSZhrTbACKJY0Mpk=
X-Received: by 2002:a05:600c:34d2:b0:3df:d8c9:ca84 with SMTP id
 d18-20020a05600c34d200b003dfd8c9ca84mr3196336wmq.1.1677457731758; Sun, 26 Feb
 2023 16:28:51 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:adf:d1ce:0:0:0:0:0 with HTTP; Sun, 26 Feb 2023 16:28:50
 -0800 (PST)
From:   Raymond Dafter <raymonddafter4992@gmail.com>
Date:   Sun, 26 Feb 2023 16:28:50 -0800
Message-ID: <CAN3-JYnVJi_56NhjLMkaBzFr5O1K6FfdsKnMbyDE=PypPU6G0g@mail.gmail.com>
Subject: We finance viable projects only
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Attention: Sir

We are interested in discussing with you, Entrepreneurs, Corporations
and Investors (start-up Owners included) with projects that require
financing also in helping you grow your network and offering you Loan
funds to complete and fund your existing Projects.

We finance viable projects only. The board will need to review the
detailed Business plan and executive summary of the project then
negotiate on the terms and conditions if the project is deemed viable.

If we can partner with you or your clients, We can send you our
Company Terms and Condition after review of your project plan and
executive summary of your project, if you are serious and Interested
contact us for further Information:

Thanks and best regards

Raymond Dafter
