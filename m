Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E473412BB7
	for <lists+io-uring@lfdr.de>; Tue, 21 Sep 2021 04:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347269AbhIUC0M (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Sep 2021 22:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236922AbhIUBvu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Sep 2021 21:51:50 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C103C0363DD
        for <io-uring@vger.kernel.org>; Mon, 20 Sep 2021 16:08:08 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id m4so20572728ilj.9
        for <io-uring@vger.kernel.org>; Mon, 20 Sep 2021 16:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6nsdqj3UHDbO3giqKZCyQmFR45po2boiCmbBviozSlc=;
        b=0p+zZCBqCGtcXQqUWVQUmzHqR7f/oLGHPoU1FnYxFuhsiysrcnEBpLeJ6qIQNhWYei
         NJtWaLkEpPJusdafyD1/LbfWbNrdeEpNdHddhACIH+RgALgMVyfWU5OlnqY/KyWRANOT
         xo02k58GP+Dpsbl63sVnyMPRXi8Htk3p7gM61cvNv8b4JRxI0AgSGkW+VdeC/PEvQkgq
         sH1MIdoUkvggXCRTI77mFgKtanO27qcYtVruyYxfFH/Ywrk87W6D2O10Pisy/qD93le/
         +8fLshkXRz93aCE7GtfU3LiiGmTue3girs11cHMR8IKMy50VO7GO7CadfMt4Fm+m5YMq
         9l3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6nsdqj3UHDbO3giqKZCyQmFR45po2boiCmbBviozSlc=;
        b=S8U0A+L+d4WbAtv9v9RUwCpLkcB0ANfiQPMBe3f8Ijbanan3GYOIgmx74FrHlMmoV3
         u1e1gaYlE4iztwdO1sCHUgbSH7LwfCVkTf5jIVrx6gIW7zW/rdnmyM0RZ830gLJEiqja
         EGtxwgKejfhRxA/z3Gj9dN1z68pHROtnsNPjHlbEeTWu8BSvZVIDv3qmIpaDHPtajRbz
         gNupaXlIPDaCyzbWkSIi8lZ164JV5xl+UiIvkgEeg6lIhQYKhBrjHsDnCHmDRZ9ZEayD
         M6c1Pq1x+UvpLsHGkFbBL+Jo1i4qHtkmLBVZGPOX377ULGDI6aLDc2MSTRfmhJB7uJqY
         u8Lg==
X-Gm-Message-State: AOAM530OTSmQp7nntSzPW6q3audpgJht5hoe+VR4sO17ebNwTERqv6Ef
        LI7ob0/3uQIDqGMAxyNa3GjxnVkjHYbVzw==
X-Google-Smtp-Source: ABdhPJyWJswT76DlW9F8kqRCuz6bnBO3G6KG75a2BeFNfZTl0MIwdiG0J8JUkJaQDGiIljlc2b22sQ==
X-Received: by 2002:a05:6e02:b2d:: with SMTP id e13mr6149731ilu.154.1632179287162;
        Mon, 20 Sep 2021 16:08:07 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id o11sm9147672ilq.12.2021.09.20.16.08.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 16:08:06 -0700 (PDT)
Subject: Re: [PATCH] [RFC] io_uring: warning about unused-but-set parameter
To:     Arnd Bergmann <arnd@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210920121352.93063-1-arnd@kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5458ee0e-573c-fbc4-5cdd-5f319f78e3cb@kernel.dk>
Date:   Mon, 20 Sep 2021 17:08:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210920121352.93063-1-arnd@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/20/21 6:13 AM, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> When enabling -Wunused warnings by building with W=1, I get an
> instance of the -Wunused-but-set-parameter warning in the io_uring code:
> 
> fs/io_uring.c: In function 'io_queue_async_work':
> fs/io_uring.c:1445:61: error: parameter 'locked' set but not used [-Werror=unused-but-set-parameter]
>  1445 | static void io_queue_async_work(struct io_kiocb *req, bool *locked)
>       |                                                       ~~~~~~^~~~~~
> 
> There are very few warnings of this type, so it would be nice to enable
> this by default and fix all the existing instances. I was almost
> done, but this was added recently as a precaution to prevent code
> from using the parameter, which could be done by either removing
> the initialization, or by adding a (fake) use of the variable, which
> I do here with the cast to void.

I would just rename the argument here 'dont_use' or something like that,
that should be enough of a signal for future cases that it should need
extra consideration.

-- 
Jens Axboe

