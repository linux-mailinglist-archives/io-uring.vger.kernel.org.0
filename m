Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00FFD3758F5
	for <lists+io-uring@lfdr.de>; Thu,  6 May 2021 19:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236113AbhEFRLV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 May 2021 13:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236042AbhEFRLV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 May 2021 13:11:21 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA66C061574
        for <io-uring@vger.kernel.org>; Thu,  6 May 2021 10:10:22 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id o21so5074505iow.13
        for <io-uring@vger.kernel.org>; Thu, 06 May 2021 10:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=84lxupcqQaQFrGMP0IrN6WhCQEfdb65ztnlv6Fsm/WE=;
        b=Iqa46ENdbjIw7KlK9h0xQBtqmYUI9uHSGI3C55Em2mdj6UcQRdIBMWZGaIubVE4h1d
         FQyzP1qFpFhHbQOiEin10V2XOR9bqEWz1jaAV5WXa8buI/0DA9+AySDmEvtNBuaK4GAg
         q4GLnOrFnkujRq1Ju4NNADqrii6vx0VxhOK84qvw4DmTcKGwKhU3fGpc2yjGPaOgSkJe
         u/wCXb11PFFvJvKNxonrPSlAePLmzz6+j5VwQo4JlhmXA3e4FkvjLZKxmm9O0JkCA9lY
         g512qtoUhEhoH7AQMMcFDCYwkpk8pMsyqTCgFBS5avapcqlddf62qJzzY33WwbAEjzGS
         ixjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=84lxupcqQaQFrGMP0IrN6WhCQEfdb65ztnlv6Fsm/WE=;
        b=Tf/DuaEnqCwHAA2OKK1y2PBwNnpyQ96cTodjwJTJBdnpLxt634Jsr+b2dz5qfHUkEZ
         I+XSsa8ysKFTwqI+zvSnJeZg6cv/gguSj45z/zK2QSgYJy1474tmnuoBgn+0H6NX3VB1
         PNoWQg+pyqzarbSAf5PGEhMrfYTVpW/b9/HI53A7fbdtJFDUN92yOSwjEptKiaYlm+Xv
         FxYoRYvFcxkByJXX1HuOlA2Osuwkt5rMqGoSGp2o5cMXif2Fvx2Bj4QZ7ggfm5Vho0D7
         Ul7Pao1Cb6SCkHHDxIYTymxuGNYo4dCJebeUBaaoKcVGFxPyHCwDQ0E1r6IV5hwhWMil
         ddKQ==
X-Gm-Message-State: AOAM533YEOlUWwD5diWtvjh13v0RmdOPumlwPCxPpShmuE3Guy4Z5L00
        VHvpKxeA06intT9zjUihoThFpg==
X-Google-Smtp-Source: ABdhPJxv4QhQA5EVbiyIRvNJFWBWrEoCVM5LKbvs3CAafO00H2c4Pekgbvx5jon4oMOzougpDzHsAA==
X-Received: by 2002:a02:ca4e:: with SMTP id i14mr4799809jal.101.1620321022247;
        Thu, 06 May 2021 10:10:22 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h11sm1627153ilr.84.2021.05.06.10.10.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 May 2021 10:10:21 -0700 (PDT)
Subject: Re: [PATCH RFC 5.13] io_uring: add IORING_REGISTER_PRIORITY
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1620311593-46083-1-git-send-email-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <38e587bb-a484-24dc-1ea9-cc252b1639ba@kernel.dk>
Date:   Thu, 6 May 2021 11:10:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1620311593-46083-1-git-send-email-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/6/21 8:33 AM, Hao Xu wrote:
> Users may want a higher priority for sq_thread or io-worker. Provide a
> way to change the nice value(for SCHED_NORMAL) or scheduling policy.

Silly question - why is this needed for sqpoll? With the threads now
being essentially user threads, why can't we just modify nice and
scheduler class from userspace instead? That should work now. I think
this is especially true for sqpoll where it's persistent, and argument
could be made for the io-wq worker threads that we'd need io_uring
support for that, as they come and go and there's no reliable way to
find and tweak the thread scheduler settings for that particular use
case.

It may be more convenient to support this through io_uring, and that is
a valid argument. I do think that the better way would then be to simply
pass back the sqpoll pid after ring setup, because then it'd almost be
as simple to do it from the app itself using the regular system call
interfaces for that.

In summary, I do think this _may_ make sense for the worker threads,
being able to pass in this information and have io-wq worker thread
setup perform the necessary tweaks when a thread is created, but it does
seem a bit silly to add this for sqpoll where it could just as easily be
achieved from the application itself without needing to add this
support.

What do you think?

-- 
Jens Axboe

