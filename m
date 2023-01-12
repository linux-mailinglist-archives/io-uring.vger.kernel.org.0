Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA840667007
	for <lists+io-uring@lfdr.de>; Thu, 12 Jan 2023 11:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbjALKob (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Jan 2023 05:44:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239822AbjALKnn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Jan 2023 05:43:43 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9302559D9;
        Thu, 12 Jan 2023 02:39:14 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id i17-20020a05600c355100b003d99434b1cfso14668333wmq.1;
        Thu, 12 Jan 2023 02:39:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n5eLFSOd8hGHKcznirlhZQ5YpZwAr0yVreyD+9Nwzis=;
        b=lOwjNN67zXGf0H2E7iTsuCDCflnpyLORYKPTHs7fBVbHT4PXAV9YrGmyAIzSKem71U
         DqAdH9qqBZc3l6mG2bRb7LtSXsnoy9ii5p9AV/g+yp72eeT9fNupdXE/L1dfkEaT6sTW
         PJ3qs6V0Ag0lowOWwGt9fr73bEQvD6Zb9epGLRzh9sd9DVmia9iq1hK28E3ZTea6117/
         hGu28edvlhZb2vJsNo934vNaubhuL7C3AEUXbATTC5CnXRZEvKkqsD4iKr+cwbRFjusU
         4/mnjYHMlUfci0tbMQ/oy+mH5CZnJSVd0a5qv6EU/mHaYUKQ7XMWoo4zHk3B8WG+5w8Y
         7iVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n5eLFSOd8hGHKcznirlhZQ5YpZwAr0yVreyD+9Nwzis=;
        b=uA/CPEIck6HLnGYFwkyJUOxBfkxhx/HqfkjLO5Q4WRgb43f9bBIzBB6dvc5SCcy4Ae
         Ak4zGRr8UPUJ/4kr6OQ7dcLfCazVz3FHLbFwUdy6DMZLVeqENfioKBFj+HZ+pNleeQxv
         cp8FaDoFRC8zKA4Ew+7ChT0n4gAP4bWeQ58ZLJ4kGxmiGxCfWMTx2e664vKDnP/mHwTn
         baWwKOL/dOzD6ZjtNxi4d8YPaWEofHBSOIy2rGD6Slo3sqCJxip76nyRd9mWi7IhGuFB
         opNrvFbzc9cAGK/z4YOj/YRPL8KIeLQKSDMG6Ovy2Yy66UFoZcVmcgKQUq3XEQtos/as
         weDg==
X-Gm-Message-State: AFqh2kqggAZ7Q8bL3KP7gncpFNHi8Z06YeaZlwWDPSE83yaNx/tkKXJG
        erzLJNRyKwObA3rIG7zeBts=
X-Google-Smtp-Source: AMrXdXuEwBnHdIOUedZwGSCFO/s1hIK2TvhfVgNqPk5UeDO6ZT67StLCv4rseGUohKZRWDdfHOKo3g==
X-Received: by 2002:a05:600c:154b:b0:3cf:674a:aefe with SMTP id f11-20020a05600c154b00b003cf674aaefemr54948033wmg.22.1673519953245;
        Thu, 12 Jan 2023 02:39:13 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:310::21ef? ([2620:10d:c092:600::2:478])
        by smtp.gmail.com with ESMTPSA id m18-20020a05600c4f5200b003c6b70a4d69sm24250325wmq.42.2023.01.12.02.39.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 02:39:12 -0800 (PST)
Message-ID: <541f398a-1ac2-3cc8-33cc-eda9511c7e2e@gmail.com>
Date:   Thu, 12 Jan 2023 10:37:44 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [syzbot] WARNING: ODEBUG bug in __io_put_task
Content-Language: en-US
To:     syzbot <syzbot+1aa0bce76589e2e98756@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000098a61b05f20e62db@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <00000000000098a61b05f20e62db@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/12/23 10:14, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    0a093b2893c7 Add linux-next specific files for 20230112
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=14d269ce480000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=835f3591019836d5
> dashboard link: https://syzkaller.appspot.com/bug?extid=1aa0bce76589e2e98756
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> 
> Unfortunately, I don't have any reproducer for this issue yet.

#syz test: git://git.kernel.dk/linux.git syztest

> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/8111a570d6cb/disk-0a093b28.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/ecc135b7fc9a/vmlinux-0a093b28.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/ca8d73b446ea/bzImage-0a093b28.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+1aa0bce76589e2e98756@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> ODEBUG: free active (active state 1) object: ffff88801fe06ca8 object type: rcu_head hint: 0x0
> WARNING: CPU: 0 PID: 6765 at lib/debugobjects.c:509 debug_print_object+0x194/0x2c0 lib/debugobjects.c:509
> Modules linked in:
> CPU: 0 PID: 6765 Comm: kworker/0:29 Not tainted 6.2.0-rc3-next-20230112-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Workqueue: events io_fallback_req_func
> RIP: 0010:debug_print_object+0x194/0x2c0 lib/debugobjects.c:509
> Code: df 48 89 fe 48 c1 ee 03 80 3c 16 00 0f 85 c7 00 00 00 48 8b 14 dd c0 dc a6 8a 50 4c 89 ee 48 c7 c7 80 d0 a6 8a e8 00 79 ae 05 <0f> 0b 58 83 05 ce 27 66 0a 01 48 83 c4 20 5b 5d 41 5c 41 5d 41 5e
> RSP: 0018:ffffc900057df950 EFLAGS: 00010286
> RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
> RDX: ffff88807d03d7c0 RSI: ffffffff8166972c RDI: fffff52000afbf1c
> RBP: 0000000000000001 R08: 0000000000000005 R09: 0000000000000000
> R10: 0000000000000001 R11: 0000000000000000 R12: ffffffff8a4dd0a0
> R13: ffffffff8aa6d580 R14: ffff88802a8da408 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055574b30e000 CR3: 000000001ddab000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   <TASK>
>   __debug_check_no_obj_freed lib/debugobjects.c:996 [inline]
>   debug_check_no_obj_freed+0x305/0x420 lib/debugobjects.c:1027
>   slab_free_hook mm/slub.c:1756 [inline]
>   slab_free_freelist_hook+0xeb/0x1c0 mm/slub.c:1807
>   slab_free mm/slub.c:3787 [inline]
>   kmem_cache_free+0xec/0x4e0 mm/slub.c:3809
>   put_task_struct_many include/linux/sched/task.h:125 [inline]
>   __io_put_task+0x155/0x1e0 io_uring/io_uring.c:725
>   io_put_task io_uring/io_uring.h:328 [inline]
>   __io_req_complete_post+0x7ac/0xcd0 io_uring/io_uring.c:978
>   io_req_complete_post+0xf1/0x1a0 io_uring/io_uring.c:992
>   io_req_task_complete+0x189/0x260 io_uring/io_uring.c:1623
>   io_poll_task_func+0xa95/0x1220 io_uring/poll.c:347
>   io_fallback_req_func+0xfd/0x204 io_uring/io_uring.c:252
>   process_one_work+0x9bf/0x1750 kernel/workqueue.c:2293
>   worker_thread+0x669/0x1090 kernel/workqueue.c:2440
>   kthread+0x2e8/0x3a0 kernel/kthread.c:376
>   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
>   </TASK>
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

-- 
Pavel Begunkov
