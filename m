Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90F0E2347AF
	for <lists+io-uring@lfdr.de>; Fri, 31 Jul 2020 16:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbgGaOZB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jul 2020 10:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728838AbgGaOZA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jul 2020 10:25:00 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D6D0C061574
        for <io-uring@vger.kernel.org>; Fri, 31 Jul 2020 07:25:00 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id l17so31811756iok.7
        for <io-uring@vger.kernel.org>; Fri, 31 Jul 2020 07:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=21RnN7Ra2Q1BemnESt3idMvxSze5j8lO/ZMniBhdSfI=;
        b=2DBWjEHw9JKhffI0032Na2dpe3H/IO5q/shVi/T3BjD47Fa9Ul5AuYTddFxAnqqnod
         c4JETudi3oE2rS63vQkL7iu9HLXXjzJZIf3ecRfCEoEswuNNREYVNxemDRXvLq342H7j
         tuZ0A/jBIfgi3l6LAWeWasWTab86VYcelMS6UYQgXDtSD9klWC1Jdx+H4XSPeLoFhF6o
         Ik7RDnDeuOm0LeMSxZmizxGsUw4v2HwSQJVt+qWCm+ZRgoS0asJvBmBDdvgFx+IZRZHq
         7eadwPGNgikibZsrZlse3qPDLpnrakoAIt7cZoZq3uLmmCq/wAypNt7BPOXL+AtjzFgr
         2Zrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=21RnN7Ra2Q1BemnESt3idMvxSze5j8lO/ZMniBhdSfI=;
        b=EwtOMlLzny9TXJWNK1SVurjNM5lYN4hQYI2bHRVecOfd9Qez+/TVrRAU5EP50eJ4pg
         z0fMFhKL2zC3hHnreqn1cTxXhWuPHCG0qSQjDA4kJfxHkEatgR/Rkjbn6n2J5X07ycQP
         cbf7k82+oTudViworfPepmRYm1z6l/72Y8xIBwlmjHqUyG95zIVEf1feDS8LdLggOry4
         SW+9Q4y4mjju1u/hwwLHJHSMp9t2a4qA01m2Rlywm9Z18HG1gwhevhF2mioh/eeYCcVw
         +Eus+OYIdHyBwhqCOetUqSs4z7YGoEX6cbP3g8RBzOonqsBKEB6W21sCDyADAhb6a3rW
         995A==
X-Gm-Message-State: AOAM531ynB4W1IngwCTK4WKKdyvf5fPN64hXzHTuAI0rvdgVxHgOmMsF
        ALIz9sVBhR3auWgda/Z0atzrLHVqdO8=
X-Google-Smtp-Source: ABdhPJyNiO1pxHMLX6Q2sKgZiGdarXGxZOEr9wBmV7QOivn+rtq3K/vwASmRydkHssVM0ov/XG/+hQ==
X-Received: by 2002:a02:c735:: with SMTP id h21mr5367864jao.90.1596205499255;
        Fri, 31 Jul 2020 07:24:59 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r7sm4364830ioj.42.2020.07.31.07.24.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2020 07:24:58 -0700 (PDT)
Subject: Re: [PATCH] io_uring: don't touch 'ctx' after installing file
 descriptor
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <5c2ac23d-3801-c06f-8bf6-4096fef88113@kernel.dk>
 <20200731075813.wi4cyjmz7cql6mry@steredhat>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c17d944e-5e24-b6ff-0b03-9c60fdf72ae9@kernel.dk>
Date:   Fri, 31 Jul 2020 08:24:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200731075813.wi4cyjmz7cql6mry@steredhat>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/31/20 1:58 AM, Stefano Garzarella wrote:
> On Thu, Jul 30, 2020 at 01:47:52PM -0600, Jens Axboe wrote:
>> As soon as we install the file descriptor, we have to assume that it
>> can get arbitrarily closed. We currently account memory (and note that
>> we did) after installing the ring fd, which means that it could be a
>> potential use-after-free condition if the fd is closed right after
>> being installed, but before we fiddle with the ctx.
>>
>> In fact, syzbot reported this exact scenario:
>>
>> BUG: KASAN: use-after-free in io_account_mem fs/io_uring.c:7397 [inline]
>> BUG: KASAN: use-after-free in io_uring_create fs/io_uring.c:8369 [inline]
>> BUG: KASAN: use-after-free in io_uring_setup+0x2797/0x2910 fs/io_uring.c:8400
>> Read of size 1 at addr ffff888087a41044 by task syz-executor.5/18145
>>
>> CPU: 0 PID: 18145 Comm: syz-executor.5 Not tainted 5.8.0-rc7-next-20200729-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> Call Trace:
>>  __dump_stack lib/dump_stack.c:77 [inline]
>>  dump_stack+0x18f/0x20d lib/dump_stack.c:118
>>  print_address_description.constprop.0.cold+0xae/0x497 mm/kasan/report.c:383
>>  __kasan_report mm/kasan/report.c:513 [inline]
>>  kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
>>  io_account_mem fs/io_uring.c:7397 [inline]
>>  io_uring_create fs/io_uring.c:8369 [inline]
>>  io_uring_setup+0x2797/0x2910 fs/io_uring.c:8400
>>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> RIP: 0033:0x45c429
>> Code: 8d b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 5b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
>> RSP: 002b:00007f8f121d0c78 EFLAGS: 00000246 ORIG_RAX: 00000000000001a9
>> RAX: ffffffffffffffda RBX: 0000000000008540 RCX: 000000000045c429
>> RDX: 0000000000000000 RSI: 0000000020000040 RDI: 0000000000000196
>> RBP: 000000000078bf38 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078bf0c
>> R13: 00007fff86698cff R14: 00007f8f121d19c0 R15: 000000000078bf0c
>>
>> Move the accounting of the ring used locked memory before we get and
>> install the ring file descriptor.
> 
> Maybe we can add:
> Fixes: 309758254ea6 ("io_uring: report pinned memory usage")

For sure, I just checked and had sort of assumed this existed in earlier
versions too, but it is indeed a recent issue. I'll add the Fixes tag
and your Reviewed-by, thanks!

-- 
Jens Axboe

