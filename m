Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA97D29E457
	for <lists+io-uring@lfdr.de>; Thu, 29 Oct 2020 08:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbgJ2Hhv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Oct 2020 03:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727977AbgJ2HYz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Oct 2020 03:24:55 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A703C0613D8
        for <io-uring@vger.kernel.org>; Wed, 28 Oct 2020 20:00:43 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x23so620634plr.6
        for <io-uring@vger.kernel.org>; Wed, 28 Oct 2020 20:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=QnRqT+DTnhCtv/uzA0Ou8yECKhGEkvuBg66dxz5w41I=;
        b=a/0di8ztvYUmdfV5lx1S8JnbFYtXqCwjgOPHgbzvkuvN+EqMdjAqOemyvdGi6zmKn3
         WlJxQ9r1aCgYiHGGLjeP86MHV9DUrPJ/icboHEq9kKRblguvZkJTitmj/EpHvstclgzL
         1c4T97KRYTsGyR40lCulaM8WBthqZoYjMnJ/NtRwfeVKTmQ1ZeggmkUWcQCFzI93afmb
         Ihew9UQiHNFoMKVQKTx3Lw8KYCjPhrCkzS4e4ilBBY13bLcrjUo7cpp0K5dzU0vyi9kj
         9svrlwuJEwbV33xN4Tiyp542kzpwn3GT+EO57S3EjmtHmwJXZpnnNlqul3mtoV7J4Hlm
         UMNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QnRqT+DTnhCtv/uzA0Ou8yECKhGEkvuBg66dxz5w41I=;
        b=d5ofCa03EEYyX6LUeVK4KgWGIZzElRSSLj1p+jPEVMfErWEW74hez7yQP8NEnOiqnw
         lKAhr3CsLtExxA3Zl0EwQ1YztkzcX1ISqYJSYD6FyfnzEsL/uVqVfD0T8AASnxm3ia3y
         KmyZnkSxhiLKp4nrpaqsRNV5+GHjZe/kydAi/XXNgY2rRiUKz9A/60GYdXx7IjHQvdSt
         6ESrM92KlkBlb68U5yIXINp9hXlL7TrEFsynvMEq/MWkVkaFW2aS0k4KDp/vxUSINYlT
         DODZtnxdP8H1PzqbLAc3Ovox78q7P59G1uICB3GOhrH/FJ9lMUurhAvUZEW/p8X7Htcl
         NkkA==
X-Gm-Message-State: AOAM5327WX5Wk50WG0KJQd/ue/w+LdGqnabma+DhhAlJS6/SiwbioTJF
        yzTWpYqVL+cza4dlzFX2j5sBRjoR7YIrcw==
X-Google-Smtp-Source: ABdhPJzvUvrr7/m5hQ9GuVhExHHC5/VcPdXf8Qv4Yvg4qVb51/qtKKjCNinGZF7vCkIs282cEVYq5g==
X-Received: by 2002:a17:902:8691:b029:d3:9c6b:d326 with SMTP id g17-20020a1709028691b02900d39c6bd326mr1864520plo.60.1603940442694;
        Wed, 28 Oct 2020 20:00:42 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id i1sm932817pfa.168.2020.10.28.20.00.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 20:00:42 -0700 (PDT)
Subject: Re: [PATCH] examples: disable ucontext-cp if ucontext.h is not
 available
To:     Simon Zeni <simon@bl4ckb0ne.ca>, io-uring@vger.kernel.org
References: <C6OZDHZNAEV7.2KUIZYYGFKTWW@gengar>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0d1a5ce5-e805-a253-4a6e-e6d0d90406fd@kernel.dk>
Date:   Wed, 28 Oct 2020 21:00:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <C6OZDHZNAEV7.2KUIZYYGFKTWW@gengar>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/28/20 7:23 PM, Simon Zeni wrote:
> On Wed Oct 28, 2020 at 3:06 PM EDT, Jens Axboe wrote:
>> The log for those would be interesting. rename/unlink is probably
>> me messing up on skipping on not-supported, sq-poll-* ditto. The
>> others, not sure - if you fail with -1/-12, probably just missing
>> capability checks.
> 
> There you go
> https://paste.sr.ht/~bl4ckb0ne/61a962894091a8442fc7ab66934e22930122ff18

Yeah, so outside of the double-poll-crash which crashes due to some
syzbot mmap magic unrelated to io_uring, all failures are either:

-EPERM: don't properly check for !root
-ENOMEM: user doesn't have a high enough ulimit -l setting
unlink/rename not properly checking kernel level support (fixed this one)

I need to provide a generic queue setup helper that catches the two
general error cases and skips tests (saying why), then it should run
clean there too.

-- 
Jens Axboe

