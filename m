Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99706376AD5
	for <lists+io-uring@lfdr.de>; Fri,  7 May 2021 21:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhEGTuO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 May 2021 15:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbhEGTuN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 May 2021 15:50:13 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E03C061574;
        Fri,  7 May 2021 12:49:12 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id t18so10388942wry.1;
        Fri, 07 May 2021 12:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ssdAUcnXtt401L+SImO691JRXwB9qES+510O8xa3Y9Y=;
        b=f8JvGKdnVyJkd5fBITq63yBSZ0ElthuoEkmgki1uJK8K6iRRo0zPyvDTq2dVg1Fuoo
         MTxb9xY3BR/S7RvJ3A9bqCWFK/ZwldQ9Vl/kRgngvECdP7TLcomEJlj056Z3GYnLeG3Q
         6Yq0flPKUZgWCemMH4rWV0EUID7ks7Xi8M8r7Cix4oZlF30759k1MFMa+9Q8PTZpfHLZ
         GI45lpKlZlct6neOQltNmIHSfIpC3wyRaXJ6WPIAcgKaI/CMpAp3CYFlNlu8Kh64ZV8z
         2xt/gDcFzkIbQfRxVBznVU4QV3Bl8+DYl+G6U8sehS0F+ZZf7R0k4EzBI+2CJ63/SmGR
         gZBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ssdAUcnXtt401L+SImO691JRXwB9qES+510O8xa3Y9Y=;
        b=mr58lxIYwlKJk7kKBe+DTZ8e0YQp6C05oleWRVqCO0Q+AHT49deNwC8WDd7nBWhpH/
         nHFPmG3D7YsvwKhbLuBDPCqDStzT4fAq/vRUkyGYPdR0y/ZoEsJI9kU+DMKrdqxDkb2c
         T/Venblrw+7dCAl5Du+bvlL1+3jk0dsYOHq1KsRWO+ZZsoMjSZ4MsUbpxdWPyxiSz8Zh
         v3VvzWQ7OcoHlwXtxqeRXSeQyGT99lmTWAaUtYcwvYBDSArVAjZZB/X1R0BTBt1Bl5HR
         QoUgTpboyILE6A1dXAX620ggHrQtCoOT+SuxtT8Cs2gajh5/L0Hq92+a8vTNutc4uvXe
         JWRQ==
X-Gm-Message-State: AOAM530tYXJc9CPw15T1D16BW4lT+/ez85SA6lwuFvqX3ySRtA+l8LDd
        znu52wrNuWUj4j9h/iVb+kc=
X-Google-Smtp-Source: ABdhPJxBkZCHac2ZWbOeGIri8hXu7pz2CpEh9Ll6KHlV+sOSFb4Xdxi7qTojiJmqfORgeJxQHU6mnQ==
X-Received: by 2002:a5d:6885:: with SMTP id h5mr14410667wru.229.1620416951597;
        Fri, 07 May 2021 12:49:11 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id e8sm9369279wrt.30.2021.05.07.12.49.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 May 2021 12:49:11 -0700 (PDT)
Subject: Re: [syzbot] INFO: task hung in __io_uring_cancel
To:     syzbot <syzbot+47fc00967b06a3019bd2@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
References: <000000000000aca64205c05dcab3@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <c2cab9a3-b821-e4fa-3a8a-c66f15a642c3@gmail.com>
Date:   Fri, 7 May 2021 20:49:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <000000000000aca64205c05dcab3@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/20/21 2:59 AM, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> KASAN: null-ptr-deref Write in io_uring_cancel_sqpoll

#syz test: git://git.kernel.dk/linux-block io_uring-5.13

> 
> ==================================================================
> BUG: KASAN: null-ptr-deref in instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
> BUG: KASAN: null-ptr-deref in atomic_inc include/asm-generic/atomic-instrumented.h:240 [inline]
> BUG: KASAN: null-ptr-deref in io_uring_cancel_sqpoll+0x150/0x310 fs/io_uring.c:8930
> Write of size 4 at addr 0000000000000114 by task iou-sqp-31588/31596
> 
> CPU: 0 PID: 31596 Comm: iou-sqp-31588 Not tainted 5.12.0-rc7-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x141/0x1d7 lib/dump_stack.c:120
>  __kasan_report mm/kasan/report.c:403 [inline]
>  kasan_report.cold+0x5f/0xd8 mm/kasan/report.c:416
>  check_region_inline mm/kasan/generic.c:180 [inline]
>  kasan_check_range+0x13d/0x180 mm/kasan/generic.c:186
>  instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
>  atomic_inc include/asm-generic/atomic-instrumented.h:240 [inline]
>  io_uring_cancel_sqpoll+0x150/0x310 fs/io_uring.c:8930
>  io_sq_thread+0x47e/0x1310 fs/io_uring.c:6873
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
> ==================================================================
> Kernel panic - not syncing: panic_on_warn set ...
> CPU: 1 PID: 31596 Comm: iou-sqp-31588 Tainted: G    B             5.12.0-rc7-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x141/0x1d7 lib/dump_stack.c:120
>  panic+0x306/0x73d kernel/panic.c:231
>  end_report mm/kasan/report.c:102 [inline]
>  end_report.cold+0x5a/0x5a mm/kasan/report.c:88
>  __kasan_report mm/kasan/report.c:406 [inline]
>  kasan_report.cold+0x6a/0xd8 mm/kasan/report.c:416
>  check_region_inline mm/kasan/generic.c:180 [inline]
>  kasan_check_range+0x13d/0x180 mm/kasan/generic.c:186
>  instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
>  atomic_inc include/asm-generic/atomic-instrumented.h:240 [inline]
>  io_uring_cancel_sqpoll+0x150/0x310 fs/io_uring.c:8930
>  io_sq_thread+0x47e/0x1310 fs/io_uring.c:6873
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
> Kernel Offset: disabled
> Rebooting in 86400 seconds..
> 
> 
> Tested on:
> 
> commit:         734551df io_uring: fix shared sqpoll cancellation hangs
> git tree:       git://git.kernel.dk/linux-block for-5.13/io_uring
> console output: https://syzkaller.appspot.com/x/log.txt?x=175fec6dd00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=601d16d8cd22e315
> dashboard link: https://syzkaller.appspot.com/bug?extid=47fc00967b06a3019bd2
> compiler:       
> 

-- 
Pavel Begunkov
