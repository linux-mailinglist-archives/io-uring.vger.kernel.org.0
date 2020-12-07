Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A45F02D145D
	for <lists+io-uring@lfdr.de>; Mon,  7 Dec 2020 16:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgLGPF1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Dec 2020 10:05:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbgLGPF1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Dec 2020 10:05:27 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25380C061749
        for <io-uring@vger.kernel.org>; Mon,  7 Dec 2020 07:04:41 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id r9so13619947ioo.7
        for <io-uring@vger.kernel.org>; Mon, 07 Dec 2020 07:04:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wZXGgbnZ8cr/0Rdgsg8K6lYkELQtNZTW++ELghaI2sA=;
        b=nFRzR+gbLLYeXQW0Ah+9hwRhhbtRxhRC1Z+B71h5O3N88OlwY/9DsiwpvsO8u1hsPL
         UjeyktuhRCxR/CytnMiDmBtDLpzFKfdl74vr/XBK2GIIGUuXwYla/uUQLniWlySGZOMg
         UN8CuOVwThl2MUypIH9Dok/GCcwnymSYi4Jsa2xIDrkGFk050WVX79nIkvFckZu3eBX9
         LZM8F3ModQEeS5FT6Yex7JJI4P4qDjPkAZXvUj022+CZG4LB0YUjBqgUsE4t5vGxJIZx
         d//d70FjqUa7hKcmNcqQNljnzHkaM9IK+vYrf+TnqeNnn+HG4P3WFgUN2NHodcSHC9AI
         HkXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wZXGgbnZ8cr/0Rdgsg8K6lYkELQtNZTW++ELghaI2sA=;
        b=NMQdeoeu4H+OxXDAJj9zlf3XUJ8wrgRg7jovGxogE2v3CMZc31bw+6RDu5df7tEYqi
         gltWYpQYUWJ/6ElDxHmw0+rXqnRShgeK/10zuwy/xUSJL8KHGaqS54MyEZLkx0N1cd78
         QTaQ+kkt44iKkEUxULFv48O3lp80MGgwq32z+sdj/5kwO4E7LbbW3wag6Tc7LlMHvzHF
         o1MzDOdtUbAfKXXeSb4cD7Dj2arGA3ntcMV/wjVFhaGahzZQzqANkciuahekBH2fKejU
         xaHtb+OROkzqcyFehyQ+ffk5YBXyq1FD3z/BfZYIWVuFzPxoWYPGYl+t6REbK+eXJ/OO
         4Jsg==
X-Gm-Message-State: AOAM531FcyMwMw8rPydao1+fc/ksXIAsQc9iteA0+RS89bYIFVhQeNB8
        jU9Y3qIH+D4dGcRhdWKK1nlx6w==
X-Google-Smtp-Source: ABdhPJwVc+ApxMZ5Dz5ik7ifV1t7aLoJlEZO+JWLeP7ZNiFTeQZzBCNHB5hhoKQCGQqL0ZpZ+Ul15Q==
X-Received: by 2002:a5e:8344:: with SMTP id y4mr20562092iom.116.1607353480454;
        Mon, 07 Dec 2020 07:04:40 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id c2sm7562579iln.70.2020.12.07.07.04.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Dec 2020 07:04:39 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix file leak on creating io ctx
To:     Hillf Danton <hdanton@sina.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     io-uring@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot+71c4697e27c99fddcf17@syzkaller.appspotmail.com,
        Pavel Begunkov <asml.silence@gmail.com>
References: <20201207081558.2361-1-hdanton@sina.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <13bd991a-be45-6521-655d-74b8d810b714@kernel.dk>
Date:   Mon, 7 Dec 2020 08:04:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201207081558.2361-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/7/20 1:15 AM, Hillf Danton wrote:
> Put file as part of error handling when setting up io ctx to fix
> memory leak like the following one.
> 
>    BUG: memory leak
>    unreferenced object 0xffff888101ea2200 (size 256):
>      comm "syz-executor355", pid 8470, jiffies 4294953658 (age 32.400s)
>      hex dump (first 32 bytes):
>        00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>        20 59 03 01 81 88 ff ff 80 87 a8 10 81 88 ff ff   Y..............
>      backtrace:
>        [<000000002e0a7c5f>] kmem_cache_zalloc include/linux/slab.h:654 [inline]
>        [<000000002e0a7c5f>] __alloc_file+0x1f/0x130 fs/file_table.c:101
>        [<000000001a55b73a>] alloc_empty_file+0x69/0x120 fs/file_table.c:151
>        [<00000000fb22349e>] alloc_file+0x33/0x1b0 fs/file_table.c:193
>        [<000000006e1465bb>] alloc_file_pseudo+0xb2/0x140 fs/file_table.c:233
>        [<000000007118092a>] anon_inode_getfile fs/anon_inodes.c:91 [inline]
>        [<000000007118092a>] anon_inode_getfile+0xaa/0x120 fs/anon_inodes.c:74
>        [<000000002ae99012>] io_uring_get_fd fs/io_uring.c:9198 [inline]
>        [<000000002ae99012>] io_uring_create fs/io_uring.c:9377 [inline]
>        [<000000002ae99012>] io_uring_setup+0x1125/0x1630 fs/io_uring.c:9411
>        [<000000008280baad>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>        [<00000000685d8cf0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Applied for 5.10, thanks.

-- 
Jens Axboe

