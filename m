Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 374D83266DA
	for <lists+io-uring@lfdr.de>; Fri, 26 Feb 2021 19:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhBZSWd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Feb 2021 13:22:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbhBZSWb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Feb 2021 13:22:31 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C68C061574
        for <io-uring@vger.kernel.org>; Fri, 26 Feb 2021 10:21:51 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id u8so10552343ior.13
        for <io-uring@vger.kernel.org>; Fri, 26 Feb 2021 10:21:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RuCzz8wYxgnqysIX2xqECmRUMXFGyGzwdjkQuTBpY8A=;
        b=YkAsu+urgiIQZOVquR1SbFjMHh5DAYds4CPDyLAlRZe/dReUQr5nAGLTtg2w58lRMj
         CPlu7fk1iAR7pXsr/qCrOzPbvzfzCUQEecjnGWsC9ERcVzMLtbZCr/RIH0zc4NXIBvX/
         sKGxEvQTKtzSUiSGwHIUKznRFSvbi7LEFXnSlROfOUgAY4kVAL7DU9ux0GruC52UgITi
         MGcWH2WAKE+iH88mTGKKPowVKPj0dP/qB1dgGm+PKsYvnOzD3g/FjVcXYYLaOuX80e1X
         vk8wc3ezEIonnLF1qr2nv9YXP5x6FDOLC93yK6ZZ/XETMXhl+l/M83ID7Gfv3nmrBUGN
         160g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RuCzz8wYxgnqysIX2xqECmRUMXFGyGzwdjkQuTBpY8A=;
        b=PrQSml0xFGXBtXkL6iGgTPOu5+8XbG6nuGgtc9iNSUV1/VdgAnpEc5U8z7s5s7n7Ub
         w62TXq9Hn2IJYJURpNt17aE9lZd+lPPKsSZl72XskzUmJvmLTPSrIiH35MVP6y/9X6Ld
         0qYW2DtSsfhT7Gmkr0D8GwfmZeBrijI3xwJwKwgOPmD4T323byQS1mGUbL/xuo6kyoqo
         QH03om1mlLiUfTkOhrHmfMhurQwsSS+uBao/w0natCV93F05zpmrNOJ5qXV4Z4YfFtJb
         KXrf0xAi9x99zzaWvOhq6c2l4Z0yTY1EBRHsGrJwH3dqUHDu9pe0F7+8OR+JLEneb9NB
         ySUQ==
X-Gm-Message-State: AOAM532pUkDOdKf2tWUF1XFiXbzRaYfjdIxJgquE/Z6eQJ9BBNFb/xnS
        UvCtWXotImB1st2xjdaEBeHNL3YAdPDdR5q5
X-Google-Smtp-Source: ABdhPJxeopWMc45RJl3teUFmTYm5MtXnx8JHYT4nLRcUhNnyJDB6HpCPuafRTV2GzgaLNE+f4ocPVw==
X-Received: by 2002:a5e:cb4c:: with SMTP id h12mr2718808iok.183.1614363709757;
        Fri, 26 Feb 2021 10:21:49 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r3sm5044401ilq.42.2021.02.26.10.21.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Feb 2021 10:21:49 -0800 (PST)
Subject: Re: [GIT PULL] Followup io_uring fixes for 5.12-rc
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <c044d125-76d4-2ac0-bcb1-96db348ee747@kernel.dk>
 <CAHk-=wjT=EZEeNScNUv4z-KoMphFSw4PM95e=MUXtBXMQF+VgA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <139d61c7-e3d2-aea6-cc03-78ec7d268ac9@kernel.dk>
Date:   Fri, 26 Feb 2021 11:21:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wjT=EZEeNScNUv4z-KoMphFSw4PM95e=MUXtBXMQF+VgA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/26/21 11:16 AM, Linus Torvalds wrote:
> On Thu, Feb 25, 2021 at 2:27 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> A collection of later fixes that we should get into this release:
> 
> So you decided to not try to push the "user threads" rewrite for 5.12?
> 
> Probably just as well.

Heh, I actually did decide to push it, just wanted to flush this out
first... I have it all ready to go, it's based on (a few patches back)
of this branch. I'll still send this out later today, it's totally up to
you of course, and the email has a lengthier explanation.

There's a few minor issues around referencing since we get auto-exit
of threads, where we managed it fully before with kthreads. But nothing
really major, and we have it mostly flushed out already. So those followup
fixes should be ready to go in a day or so. It's what syzbot is tripping
up on, and they are known and mostly edge cases.

-- 
Jens Axboe

