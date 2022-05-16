Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06CE5528CCC
	for <lists+io-uring@lfdr.de>; Mon, 16 May 2022 20:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344704AbiEPSWP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 May 2022 14:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344665AbiEPSWM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 May 2022 14:22:12 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF682BB00
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 11:22:10 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id l15so11085656ilh.3
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 11:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fi2MKK4RDnx6306yvIj3WqOA9+3aIysOXF+Rc+RJb4Y=;
        b=ZoeYipp1srp2zffS6xSdw3auO/PUsqr9RF6aFDmflEnta+cN9h3QQekvih8nXjtLzx
         denBn/B1SfVOfEOGy2MF80u8pStM64jj/Q2zsXN+0DFTuPMdMb/kksBYYo5pDGgM6Yt+
         fQrwdiKbkUsAUy4DQF5f5RGSkh1OWCthVya+Z8j8X4Bt7hdKTcT7PU0zWixT1OJgcek/
         srWG6vzSTBHbi3Je60NibFukSh1mtN5de+TrSHi34uZCkJcKJYnVvJECuvwSJucjknSV
         D6xDfmCN71FptFkL1m+92AWgmDlknvKgLHAtCLgI4FND7h1wZvCv4Q/JcGlY1n3RjpjN
         00JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fi2MKK4RDnx6306yvIj3WqOA9+3aIysOXF+Rc+RJb4Y=;
        b=JuV+tNW70+Sg1FiaDx4UyXe4z/i7/cMQog9e8tDv++Q3LjZq9oDMFDJZDLIz3sd01O
         lsLfOI2CMRl7i2Ray5czMe/RgwcdD6617ZP5qfnMXEdtd0av3uiy9h2DTKHBzhJI0b3N
         GDczfUT3QbA6zfHjgowznKVtcGeWbUiKMPDV+0PNhcR+lsKCTTx/ngoFzpNO2ih8DVM6
         EyHFtZAE2qydyBL3tNpIw8HMaE4Fz28+8Tnp08gt2Gq6QJpuVI41G8tZMgpPPSZmvc/1
         +TqbrYv8MmJfqimw/YO3bNW43PhYlGH2FVK6VgkGB1JOMpdA5ZtMCDP4aRH5N5WPbYZj
         0MbA==
X-Gm-Message-State: AOAM532lavbinc8ypd936b51+XorBkqxXdf2sB8W7NblguSR0b6xk3tI
        dt/qG0KPw3Za9eYDt4X5yUOIbw==
X-Google-Smtp-Source: ABdhPJwu+uko3W1bDT97qFkqQc86IbLg5bTX+TVEm+Bg5/uK411UrX/M11NqCONlxy6V9sq7qROTPA==
X-Received: by 2002:a05:6e02:1c27:b0:2cf:6de9:5342 with SMTP id m7-20020a056e021c2700b002cf6de95342mr9584457ilh.176.1652725329933;
        Mon, 16 May 2022 11:22:09 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id l44-20020a026a2c000000b0032b3a7817d3sm2964148jac.151.2022.05.16.11.22.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 May 2022 11:22:08 -0700 (PDT)
Message-ID: <eaee4ea1-8e5a-dde8-472d-44241d992037@kernel.dk>
Date:   Mon, 16 May 2022 12:22:07 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [REGRESSION] lxc-stop hang on 5.17.x kernels
Content-Language: en-US
To:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Daniel Harding <dharding@living180.net>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     regressions@lists.linux.dev, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>
References: <7925e262-e0d4-6791-e43b-d37e9d693414@living180.net>
 <6ad38ecc-b2a9-f0e9-f7c7-f312a2763f97@kernel.dk>
 <ccf6cea1-1139-cd73-c4e5-dc9799708bdd@living180.net>
 <bb283ff5-6820-d096-2fca-ae7679698a50@kernel.dk>
 <371c01dd-258c-e428-7428-ff390b664752@kernel.dk>
 <2436d42c-85ca-d060-6508-350c769804f1@gmail.com>
 <ad9c31e5-ee75-4df2-c16d-b1461be1901a@living180.net>
 <fb0dbd71-9733-0208-48f2-c5d22ed17510@gmail.com>
 <a204ba93-7261-5c6e-1baf-e5427e26b124@living180.net>
 <bd932b5a-9508-e58f-05f8-001503e4bd2b@gmail.com>
 <12a57dd9-4423-a13d-559b-2b1dd2fb0ef3@living180.net>
 <897dc597-fc0a-34ec-84b8-7e1c4901e0fc@leemhuis.info>
 <c2f956e2-b235-9937-d554-424ae44c68e4@living180.net>
 <41c86189-0d1f-60f0-ca8e-f80b3ccf5130@gmail.com>
 <da56fa5f-0624-413e-74a1-545993940d27@gmail.com>
 <3fc08243-f9e0-9cec-4207-883c55ccff78@living180.net>
 <13028ff4-3565-f09e-818c-19e5f95fa60f@living180.net>
 <469e5a9b-c7e0-6365-c353-d831ff1c5071@leemhuis.info>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <469e5a9b-c7e0-6365-c353-d831ff1c5071@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/16/22 12:17 PM, Thorsten Leemhuis wrote:
>>> Pavel, I had actually just started a draft email with the same theory
>>> (although you stated it much more clearly than I could have).  I'm
>>> working on debugging the LXC side, but I'm pretty sure the issue is
>>> due to LXC using blocking reads and getting stuck exactly as you
>>> describe.  If I can confirm this, I'll go ahead and mark this
>>> regression as invalid and file an issue with LXC. Thanks for your help
>>> and patience.
>>
>> Yes, it does appear that was the problem.  The attach POC patch against
>> LXC fixes the hang.  The kernel is working as intended.
>>
>> #regzbot invalid:  userspace programming error
> 
> Hmmm, not sure if I like this. So yes, this might be a bug in LXC, but
> afaics it's a bug that was exposed by kernel change in 5.17 (correct me
> if I'm wrong!). The problem thus still qualifies as a kernel regression
> that normally needs to be fixed, as can be seen my some of the quotes
> from Linus in this file:
> https://www.kernel.org/doc/html/latest/process/handling-regressions.html

Sorry, but that's really BS in this particularly case. This could always
have triggered, it's the way multishot works. Will we count eg timing
changes as potential regressions, because an application relied on
something there? That does not make it ABI.

In general I agree with Linus on this, a change in behavior breaking
something should be investigated and figured out (and reverted, if need
be). This is not that.

-- 
Jens Axboe
I
