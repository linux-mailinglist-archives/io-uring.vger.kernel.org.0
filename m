Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2381A40C56B
	for <lists+io-uring@lfdr.de>; Wed, 15 Sep 2021 14:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232179AbhIOMm3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Sep 2021 08:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232127AbhIOMm2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Sep 2021 08:42:28 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8FAC061574
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 05:41:09 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id a22so3159723iok.12
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 05:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=53T1efqn7HLtGEpN+jDYdjIxehGMmAuwT1pQL96/u9A=;
        b=Na3b5Kro4uYVyEX1XGybfkO18MRf9nf0dmx6TpAPLWXCzhs/3WbhIB9LOnqCOqyu+A
         /l/eGO41J4y4Yrq9Y9V8aEl/n1PKuDzpVpS+K2A7aYTgFO9O+aTR06jMUaDRquHb8e2E
         nhSuyBrQJbnyfqNP7+rcGUxFk8CHUNnZs/YRMZDqSL3hGZ1wdOFqA3Ej+1vJzjeYcJfV
         ZMqOAZ1goHuczWxzY7oTl74pMcZ0Iv256S5K1O5M8VColDJdnm4Z6mk7Ltd1LEdfFo8G
         YkXHPj5zr1DDdCapHGWQGwDMDyBTjYEEzBlrB4DuPLmSif/+exUQQ4kD93ufJvJaIeWA
         5p2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=53T1efqn7HLtGEpN+jDYdjIxehGMmAuwT1pQL96/u9A=;
        b=QMvAW7AxyKn3c0hZilcfo0lCboyQJQiORYpi4ZD7gTVTuGoXpLfQjBtMViyjkWOu5c
         y7xr7c7njQed2h8XWx7dQ4rT1SggJXBV8+2guqOqdVQbXOk+aUh1I0wdsDxhoHijZIMR
         bVoqV3nY9ZHwIdGBA4cX4N6JcwIdDhC78QIthneKuFOqU7PARL09SeOs9fRoPlF3gHbM
         F2zYh8HjEMZhSTCaoYnh12DLedndx7xeVEryxV0u2T6uRjArp0Ubh0e3jvjrTw1+PtUc
         CXvHtLtxnMVqolMK3F1qrHEQqcMaCvhMzTX/052Pkww//45YVCKEOW3eU1Mt/cdoKw2+
         VIQg==
X-Gm-Message-State: AOAM530NLv3FAuNP26twc/rsBZTKIu50PDlHGd4XLOlrzXsW4gVxlga3
        mqYx+k6DybO3B+8QyoBi3hOZ4VvV9EGIkw==
X-Google-Smtp-Source: ABdhPJxMGQDxxLhIVP9+Y5rxPr008gOq9LKEoE5vkpzLrk3uAJKDA74rYy8Hn0ySxTbR8hlmGePFEA==
X-Received: by 2002:a6b:2c14:: with SMTP id s20mr18194886ios.218.1631709668598;
        Wed, 15 Sep 2021 05:41:08 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id w18sm2281474ilg.13.2021.09.15.05.41.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Sep 2021 05:41:08 -0700 (PDT)
Subject: Re: [PATCH liburing 0/3] Fix build and add /test/output dir to
 .gitignore
To:     Ammar Faizi <ammarfaizi2@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <20210915081158.102266-1-ammarfaizi2@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7f168e72-b425-327f-3516-eb79fec6fc10@kernel.dk>
Date:   Wed, 15 Sep 2021 06:41:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210915081158.102266-1-ammarfaizi2@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/15/21 2:11 AM, Ammar Faizi wrote:
> - Louvian reported build error (2 fixes from me).
> - Add `/test/output` dir to .gitignore from me.
> 
> Ammar Faizi (3):
>       test/io_uring_setup: Don't use `__errno` as local variable name
>       test/send_recv: Use proper cast for (struct sockaddr *) argument
>       .gitignore: add `/test/output/`
> 
>  .gitignore            |  1 +
>  test/io_uring_setup.c | 10 +++++-----
>  test/send_recv.c      |  2 +-
>  3 files changed, 7 insertions(+), 6 deletions(-)

Applied, thanks.

-- 
Jens Axboe

