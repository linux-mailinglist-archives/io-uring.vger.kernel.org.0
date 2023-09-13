Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 383F279E7B4
	for <lists+io-uring@lfdr.de>; Wed, 13 Sep 2023 14:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240220AbjIMMNG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Sep 2023 08:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234499AbjIMMNF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Sep 2023 08:13:05 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88EE419AC;
        Wed, 13 Sep 2023 05:13:01 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id 2adb3069b0e04-5007abb15e9so11607959e87.0;
        Wed, 13 Sep 2023 05:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694607180; x=1695211980; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dihLHUKNpOLl7vI7drB7y10ne7MOYFQJv3dnSlFJytw=;
        b=Gm3fQ2gJ2HZgw8N7AyVpb3R9iANIYWKWzauPR7ixhaqtNC6NywEjqXobNr1EjMKRlZ
         oUFNxp5KlRoFh5LSIL36DGGw3N7yWoCDBANdyT5ybca+6PRhQ2RINcjsdfmJZNkcwg/S
         fgn03l8haxMDQoMnnFOY2bzAajy5qNNW0iFyYYQqhLpczjt5pRmZ41JBPkOkK/J/2Yu0
         GOtqOu2WBPb+hY7kdEpFJ7xdjcefe/tr24zhX20lyQwXYWXYUTCFiD/uW1LGGfJRT/BG
         E969rX5UtQfbZDCnNtQrjcS0xDdMd/MM9syA+Comx/adEBCwWbhbJuNMVPaJKgOFjpEp
         tuvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694607180; x=1695211980;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dihLHUKNpOLl7vI7drB7y10ne7MOYFQJv3dnSlFJytw=;
        b=IAdWiDtXbbPEtNyhxxlLzZxpQlzzOUPBIuyFNZscXplGBpVzbCnyB13aJ0XHkUmlil
         afoZOSELzD/QhF0pp1MUaDppvUXaeSfUuGcaUlHK739oa2VofjyIqDrRsPcrsTOGEy+p
         Jn5jFdkVfITbUs68t9d0SZkkXV2n+vEP3YH9lLqJxsSdP3rzzylXaa1EH1GefzmN1avI
         dUXInNJRovGvT0dlBk8IWcWWy27aQPgRCGSd8DWTroEy/PRbzJU/FI2swOMBx7bcS5oq
         94+QPGGwR5pQNyRpcniUhzL5dZ0OLOu+XlDIrtv95jnOg3pCUcFn69/i6biOZrTyfjHs
         UcKA==
X-Gm-Message-State: AOJu0YxSQTFIcnHf2M1h/xS/lJh+uWQsYX6XhgxJS3Gg4Dxd+FyUtTMa
        SN62sffoE3yvcw3TS9CUZAg=
X-Google-Smtp-Source: AGHT+IHYxl7iJu4hI9w0O9muce3waKWk/c25RtnObBfgxJ43h4eRII8zKvsU1FVYc+z3SPcNwV+3Wg==
X-Received: by 2002:a05:6512:3d0e:b0:500:9ab8:b790 with SMTP id d14-20020a0565123d0e00b005009ab8b790mr2085946lfv.60.1694607178202;
        Wed, 13 Sep 2023 05:12:58 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:7e52])
        by smtp.gmail.com with ESMTPSA id r25-20020aa7d599000000b005256d80cdaesm7142811edq.65.2023.09.13.05.12.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Sep 2023 05:12:57 -0700 (PDT)
Message-ID: <4e400095-7205-883b-c8fd-4aa95a1b6423@gmail.com>
Date:   Wed, 13 Sep 2023 13:12:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] KCSAN: data-race in
 io_wq_activate_free_worker / io_wq_worker_running
To:     syzbot <syzbot+a36975231499dc24df44@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000fc6ba706053be013@google.com>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <000000000000fc6ba706053be013@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/13/23 12:29, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    f97e18a3f2fb Merge tag 'gpio-updates-for-v6.6' of git://gi..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=12864667a80000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=fe440f256d065d3b
> dashboard link: https://syzkaller.appspot.com/bug?extid=a36975231499dc24df44
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/b1781aaff038/disk-f97e18a3.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/5b915468fd6d/vmlinux-f97e18a3.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/abc8ece931f3/bzImage-f97e18a3.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+a36975231499dc24df44@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KCSAN: data-race in io_wq_activate_free_worker / io_wq_worker_running
> 
> write to 0xffff888127f736c4 of 4 bytes by task 4731 on cpu 1:
>   io_wq_worker_running+0x64/0xa0 io_uring/io-wq.c:668
>   schedule_timeout+0xcc/0x230 kernel/time/timer.c:2167
>   io_wq_worker+0x4b2/0x840 io_uring/io-wq.c:633
>   ret_from_fork+0x2e/0x40 arch/x86/kernel/process.c:145
>   ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:304
> 
> read to 0xffff888127f736c4 of 4 bytes by task 4719 on cpu 0:
>   io_wq_get_acct io_uring/io-wq.c:168 [inline]
>   io_wq_activate_free_worker+0xfa/0x280 io_uring/io-wq.c:267
>   io_wq_enqueue+0x262/0x450 io_uring/io-wq.c:914

1) the worst case scenario we'll choose a wrong type of
worker, which is inconsequential.

2) we're changing the IO_WORKER_F_RUNNING bit, but checking
for IO_WORKER_F_BOUND. The latter one is set at the very
beginning, it would require compiler to be super inventive
to actually hit the problem.

I don't believe it's a problem, but it'll nice to attribute
it properly, READ_ONCE?, or split IO_WORKER_F_BOUND out into
a separate field.


>   io_queue_iowq+0x1d1/0x310 io_uring/io_uring.c:514
>   io_queue_sqe_fallback+0x82/0xe0 io_uring/io_uring.c:2084
>   io_submit_sqe io_uring/io_uring.c:2305 [inline]
>   io_submit_sqes+0xbd3/0xfb0 io_uring/io_uring.c:2420
>   __do_sys_io_uring_enter io_uring/io_uring.c:3628 [inline]
>   __se_sys_io_uring_enter+0x1f8/0x1c10 io_uring/io_uring.c:3562
>   __x64_sys_io_uring_enter+0x78/0x90 io_uring/io_uring.c:3562
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> value changed: 0x0000000d -> 0x0000000b
> 
> Reported by Kernel Concurrency Sanitizer on:
> CPU: 0 PID: 4719 Comm: syz-executor.1 Not tainted 6.5.0-syzkaller-01810-gf97e18a3f2fb #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/26/2023
> ==================================================================
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the bug is already fixed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want to overwrite bug's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the bug is a duplicate of another bug, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup

-- 
Pavel Begunkov
