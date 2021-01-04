Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33B302E8FFA
	for <lists+io-uring@lfdr.de>; Mon,  4 Jan 2021 06:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbhADFYP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jan 2021 00:24:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727676AbhADFYP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jan 2021 00:24:15 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6BCC061574;
        Sun,  3 Jan 2021 21:23:34 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id o13so61669828lfr.3;
        Sun, 03 Jan 2021 21:23:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xtfLC+93w3itoyz4P7sF0tQMz1DxxHp2FUnJwDzp3Gk=;
        b=BBT9h33S2l3iEDMxLrX0iowTroll+rFiqGgK8g9PRQ05cc9mznHyRXzPXIC+3QXoEm
         46wwMyzAtc9RDHl4T/FDMJGYJ9KQnZn5AMgGHQKTnZOpEwIFr9etfrlhRFQUsI8almbB
         TjXiMK0TOYr5+gMcoEkZrBD4XFmlSYjcVqBAFrHqCP4bzo6c1vDHVqOzVyYh16/tprEB
         tp3Bu96D6W2BMPqJFppVzgrgk3ZL+qT7PXRJrpXrlKSSA+iu1fUz1d8R3qVP+VuW37GJ
         Xz3CPn3fO3WWuwJQJNf3h5+CzdINSHZCjG7m/TVqAOjlIyTw9NUQiCbAIAf2kNv4BNsg
         HPxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xtfLC+93w3itoyz4P7sF0tQMz1DxxHp2FUnJwDzp3Gk=;
        b=iltADJ0eWW75yY/bzypSZMPAzTsb6B/mRe0ArvPc2YktHfu9U0oAmOPjbfyDEN9bxW
         fVl1LPt0yFwsBgiJMm4/2iEj1v1dr6/3HujVabGFbjcF80TxpxXqyXdJONynRwlu6n0+
         LjvzWKrEgGodTdryC/ymJUq6/dnW9d0eWrFiHztP8wRWIazqIG5fLjhquujqbsyYuBtx
         fZLAMdZWLdo5djHotX0EGjGGCxkpGI7bievOC4CgiMepZxSxfY5ujloXVjmREirIbQCk
         cmQLF48H49CrFAT/6xO5eU2qxmFDx9jnURjUr4lZ/ei73gaKw1vHJNdMgLf0zyMbMpjR
         aduQ==
X-Gm-Message-State: AOAM533Jctfa7nZqCiyuePxeymy32Uv4yTt42T8/C9wTTWFO0GvDPxSW
        +AbePqeAZRmE+NAwH2BCZuh78bHpvI6PISbADhk=
X-Google-Smtp-Source: ABdhPJzTsJPdDXn6X0wbuXnkMrIDfYV9Kilkr3ap5kA+nCCPq+/G9WMmgAthICTij9toii7SymCCdoHJewDn9yvXBPo=
X-Received: by 2002:ac2:5c08:: with SMTP id r8mr31137914lfp.12.1609737811095;
 Sun, 03 Jan 2021 21:23:31 -0800 (PST)
MIME-Version: 1.0
References: <CAGyP=7cFM6BJE7X2PN9YUptQgt5uQYwM4aVmOiVayQPJg1pqaA@mail.gmail.com>
 <20210103123701.1500-1-hdanton@sina.com>
In-Reply-To: <20210103123701.1500-1-hdanton@sina.com>
From:   Palash Oswal <oswalpalash@gmail.com>
Date:   Mon, 4 Jan 2021 10:53:20 +0530
Message-ID: <CAGyP=7eJKvVXDK+qo9d-AmxC2=QCKPKeGrEJm1bcYNN9f4AKmg@mail.gmail.com>
Subject: Re: INFO: task hung in __io_uring_task_cancel
To:     Hillf Danton <hdanton@sina.com>, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Pavel Begunkov <asml.silence@gmail.com>,
        viro@zeniv.linux.org.uk, will@kernel.org, rostedt@goodmis.org,
        peterz@infradead.org, mingo@redhat.com, mingo@kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hillf -
> Can you reproduce it again against 5.11-rc1 with the tiny diff applied
> to see if there is a missing wakeup in the mainline?

Hey Hillf, thanks for sharing the diff. It seems like the reproducer
that I had sent did not work on 5.11-rc1 itself, so I'm trying to get
an updated reproducer for that.
I'm not well versed with the io_uring code yet, and therefore it'll
take me longer to get the reproducer going for 5.11-rc1.

Jens -
> Can you see if this helps? The reproducer is pretty brutal, it'll fork
> thousands of tasks with rings! But should work of course. I think this
> one is pretty straight forward, and actually an older issue with the
> poll rewaiting.

Hey Jens, I applied your diff to 5.10.4 (
b1313fe517ca3703119dcc99ef3bbf75ab42bcfb ), and unfortunately, I'm
still seeing the task being hung. Here's the console log if this helps
further -
root@syzkaller:~# [  242.840696] INFO: task repro:395 blocked for more
than 120 seconds.
[  242.846353]       Not tainted 5.10.4+ #9
[  242.849951] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  242.857665] task:repro           state:D stack:    0 pid:  395
ppid:   394 flags:0x00000004
[  242.867346] Call Trace:
[  242.870521]  __schedule+0x28d/0x7e0
[  242.873597]  ? __percpu_counter_sum+0x75/0x90
[  242.876794]  schedule+0x4f/0xc0
[  242.878803]  __io_uring_task_cancel+0xad/0xf0
[  242.880952]  ? wait_woken+0x80/0x80
[  242.882330]  bprm_execve+0x67/0x8a0
[  242.884142]  do_execveat_common+0x1d2/0x220
[  242.885610]  __x64_sys_execveat+0x5d/0x70
[  242.886708]  do_syscall_64+0x38/0x90
[  242.887727]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  242.889298] RIP: 0033:0x7ffabedd6469
[  242.890265] RSP: 002b:00007ffc56b8bc78 EFLAGS: 00000246 ORIG_RAX:
0000000000000142
[  242.892055] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ffabedd6469
[  242.893776] RDX: 0000000000000000 RSI: 0000000020000180 RDI: 00000000ffffffff
[  242.895400] RBP: 00007ffc56b8bc90 R08: 0000000000000000 R09: 00007ffc56b8bc90
[  242.896879] R10: 0000000000000000 R11: 0000000000000246 R12: 0000559c19400bf0
[  242.898335] R13: 00007ffc56b8bdb0 R14: 0000000000000000 R15: 0000000000000000
[  363.691144] INFO: task repro:395 blocked for more than 241 seconds.
[  363.693724]       Not tainted 5.10.4+ #9
[  363.695513] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  363.700543] task:repro           state:D stack:    0 pid:  395
ppid:   394 flags:0x00000004
[  363.705747] Call Trace:
[  363.707359]  __schedule+0x28d/0x7e0
[  363.709603]  ? __percpu_counter_sum+0x75/0x90
[  363.712900]  schedule+0x4f/0xc0
[  363.715002]  __io_uring_task_cancel+0xad/0xf0
[  363.718026]  ? wait_woken+0x80/0x80
[  363.720137]  bprm_execve+0x67/0x8a0
[  363.721992]  do_execveat_common+0x1d2/0x220
[  363.723997]  __x64_sys_execveat+0x5d/0x70
[  363.725857]  do_syscall_64+0x38/0x90
[  363.727501]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  363.729510] RIP: 0033:0x7ffabedd6469
[  363.730913] RSP: 002b:00007ffc56b8bc78 EFLAGS: 00000246 ORIG_RAX:
0000000000000142
[  363.733747] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ffabedd6469
[  363.736138] RDX: 0000000000000000 RSI: 0000000020000180 RDI: 00000000ffffffff
[  363.738431] RBP: 00007ffc56b8bc90 R08: 0000000000000000 R09: 00007ffc56b8bc90
[  363.740504] R10: 0000000000000000 R11: 0000000000000246 R12: 0000559c19400bf0
[  363.742560] R13: 00007ffc56b8bdb0 R14: 0000000000000000 R15: 0000000000000000
