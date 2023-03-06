Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA5D6ABC2D
	for <lists+io-uring@lfdr.de>; Mon,  6 Mar 2023 11:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbjCFK0O (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Mar 2023 05:26:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbjCFKZ4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Mar 2023 05:25:56 -0500
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDCDF25BB9
        for <io-uring@vger.kernel.org>; Mon,  6 Mar 2023 02:25:31 -0800 (PST)
Received: by mail-vs1-xe32.google.com with SMTP id v27so8609044vsa.7
        for <io-uring@vger.kernel.org>; Mon, 06 Mar 2023 02:25:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678098330;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vh7FN/ulAdnmY8O0LKz7bqpIFk4oOSQ9iCZ8VQ/AkNo=;
        b=FXYH3Khb7TkHebhMUbM1Yu51tZ26ORw6PyaaQMrcCbhZfocTv/iiJJu7orekMprgZ5
         GbPhkYyx0iHwA+UdNkhvP7cfrft0oAnvgn1BhUGKNupLoYtvIgYo/mwaF14UGiW1AkeL
         NXYQTiXUDre0qbbgSFVIQOJ0FfRUi6ZKhk5nKd3Ql+i75kOy8yx72KhCkpox9AS0XIZq
         6HWdJF/DrVNMafM0HI1HkNKD2SdFYwhaG3+lwX6e9cX/3sfs50wTnyeu4iKXz011MKhG
         nYiLFhB99jCZuJb3IuA+SUqU4mh6cL75rrQNmMW7LqTkegWbkNoGu3wTMgb0BPPX0vv/
         +3Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678098330;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vh7FN/ulAdnmY8O0LKz7bqpIFk4oOSQ9iCZ8VQ/AkNo=;
        b=IO3WoKJ7/hl9S0DcgSnIzL7gOTrrvbraS0CwFaZoUJIJmepTn88fa4+euiYu/x2An/
         Cx1tthKPRrYhaWrt1oBReiQrs3e5GF/Sk0/1drvk+KoSBJ9zGnTfL6jkIdxC4dp0lWnH
         MGeJysDPrebiHNWtQED83qYLZOEtxd65KMsq5e7JdH0awdLEnKnkdBU/dWFQyXX/hmB/
         EQ/xSqTeYXx7zhw3wN7RcscwOA7N6XQKt6JuC3uYxdx7R2QR2tu4zt4WuH8SgkqnR/r5
         6u2QLXcQq/Fcotk1PB5jdmrTwLEczXWS1aUPqjiw1poAQ1rCMTgNzuW5hO4LFJZef4vW
         Wk6w==
X-Gm-Message-State: AO0yUKVdALFsJkgR5k0i+dIB8EpXNvaTyAij6UXjhpOHDHspPfuvg1Lp
        70PZmD6WFOop++SsgY1vp/UlhwkqywqocOyq5/o=
X-Google-Smtp-Source: AK7set9YqazPiOkBuGm+YrFZOLe51O90+qKBrIr6WBjXtnVrmZ9RIOYyWRLBWcHI+/rsVoNhMQhwnCpcR6G8n2Z6mzE=
X-Received: by 2002:a05:6102:e44:b0:402:999f:44d3 with SMTP id
 p4-20020a0561020e4400b00402999f44d3mr6975472vst.1.1678098330725; Mon, 06 Mar
 2023 02:25:30 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a59:ce6f:0:b0:3ae:930b:3e70 with HTTP; Mon, 6 Mar 2023
 02:25:30 -0800 (PST)
Reply-To: madis.scarl@terlera.it
From:   "Ms Eve from U.N" <denisagotou@gmail.com>
Date:   Mon, 6 Mar 2023 11:25:30 +0100
Message-ID: <CAD6bNBi6bPCYboaF4-xBgmeUTFn6JMXqU6TNepQig=NRMqhdUg@mail.gmail.com>
Subject: Re: Claim of Fund:
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_SCAM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello Good Morning,
This is to bring to your notice that all our efforts to contact you
through this your email ID failed Please Kindly contact Barrister.
Steven Mike { mbarrsteven@gmail.com } on his private email for the
claim of your compensation entitlement

Note: You have to pay for the delivery fee.
Yours Sincerely
Mrs EVE LEWIS
