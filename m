Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3ECB1A1080
	for <lists+io-uring@lfdr.de>; Tue,  7 Apr 2020 17:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgDGPqR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Apr 2020 11:46:17 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37883 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbgDGPqR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Apr 2020 11:46:17 -0400
Received: by mail-pl1-f193.google.com with SMTP id x1so1397051plm.4
        for <io-uring@vger.kernel.org>; Tue, 07 Apr 2020 08:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qWxR6EjG3S5lrycZGlKvPiaZb9Wsuu37Si9larm9oEk=;
        b=QFHMLu3I372o3RClJKtt/weQtgfvaqtPYdepOZ+tp4yuY0TVKCEQX1cmSFvcZTPqLH
         rhhKCslN+L4iDPlU5sPSd3U4ZvS1FZ+g4Ws2+ha/sWg0ILFD92CS0y1fvy6K5LoRV1R3
         mLCE0UxUI6lslRs+MQZDLtjduJYYOwTLRuAT5twjf0pdGVi1rDX8VrVDCecDnQadYh39
         /lNIqv2vJ8WhudAsu8h/S9uB1PJhN4I4g3O87OtestQtVilo3HYO3n//TANDHvtpHLRo
         t13//SUTJkwKI2qVnzN2r3Y6ZtwyB0wLsM2jPKGbk5YkCFcbgpJgYEeDnI7R3lcT7d13
         LXug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qWxR6EjG3S5lrycZGlKvPiaZb9Wsuu37Si9larm9oEk=;
        b=eotICG6qytqqeGZQtsEZvhbfAK3sBmuHCIMvP1W0ThvZYwWF7E0z2UJ/yuYwfcqt5g
         MYRjR+TxP3yN3uu/7PGMJHpuvNt4ZX8VMeNMepnusfSXe7N4ALGESnmIbYGKNcA82JWk
         ODvgsQbG3gZ0SL9bVNL9DAxEeq7ZtnbVHmXTqkx4qYWBltqmWhjOiDkUq+n40m08psST
         CYX5igaNOGD+APiT2dZnsD0o3udQHnMOciGhJW0pdwAwhcwpnFBecO4+rTivyilZV+9r
         5nJtrLOW5Bk4Y8HhcF5U3sL6gbsxVGAvCQJQH4MBnovQF7H7adWK42HvKs0rb5I8iVe1
         9fIA==
X-Gm-Message-State: AGi0PubRS9hA4fTiiTvVXa0PVEJCT+6Ptu3RMt3RxrKOAJeS44aC3FA0
        uSRmneecw0pXAu5u/dY+qsNBJjmIZ7Vl6g==
X-Google-Smtp-Source: APiQypJ3RDDsszFo1lDuEClzy0Bi2sYlgLrz5cawLR6DzHVZAspRTzVH+iGS2uO/3UvpZBsFCzZllg==
X-Received: by 2002:a17:90a:dac2:: with SMTP id g2mr3683297pjx.112.1586274376438;
        Tue, 07 Apr 2020 08:46:16 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:ec7d:96d3:6e2d:dcab? ([2605:e000:100e:8c61:ec7d:96d3:6e2d:dcab])
        by smtp.gmail.com with ESMTPSA id i187sm14293353pfg.33.2020.04.07.08.46.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2020 08:46:15 -0700 (PDT)
Subject: Re: [PATCH for-next] io_uring: initialize fixed_file_data lock
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200407120231.2644-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e9720c15-caff-0704-1ffc-2d85a965afd6@kernel.dk>
Date:   Tue, 7 Apr 2020 08:46:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200407120231.2644-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/7/20 5:02 AM, Xiaoguang Wang wrote:
> syzbot reports below warning:
> INFO: trying to register non-static key.
> the code is fine but needs lockdep annotation.
> turning off the locking correctness validator.
> CPU: 1 PID: 7099 Comm: syz-executor897 Not tainted 5.6.0-next-20200406-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x188/0x20d lib/dump_stack.c:118
>  assign_lock_key kernel/locking/lockdep.c:913 [inline]
>  register_lock_class+0x1664/0x1760 kernel/locking/lockdep.c:1225
>  __lock_acquire+0x104/0x4e00 kernel/locking/lockdep.c:4223
>  lock_acquire+0x1f2/0x8f0 kernel/locking/lockdep.c:4923
>  __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
>  _raw_spin_lock_irqsave+0x8c/0xbf kernel/locking/spinlock.c:159
>  io_sqe_files_register fs/io_uring.c:6599 [inline]
>  __io_uring_register+0x1fe8/0x2f00 fs/io_uring.c:8001
>  __do_sys_io_uring_register fs/io_uring.c:8081 [inline]
>  __se_sys_io_uring_register fs/io_uring.c:8063 [inline]
>  __x64_sys_io_uring_register+0x192/0x560 fs/io_uring.c:8063
>  do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
>  entry_SYSCALL_64_after_hwframe+0x49/0xb3
> RIP: 0033:0x440289
> Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7
> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
> ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007ffff1bbf558 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
> RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440289
> RDX: 0000000020000280 RSI: 0000000000000002 RDI: 0000000000000003
> RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
> R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000401b10
> R13: 0000000000401ba0 R14: 0000000000000000 R15: 0000000000000000
> 
> Initialize struct fixed_file_data's lock to fix this issue.

Applied, thanks.

-- 
Jens Axboe

