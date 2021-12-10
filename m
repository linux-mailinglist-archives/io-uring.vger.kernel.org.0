Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C26D44703EF
	for <lists+io-uring@lfdr.de>; Fri, 10 Dec 2021 16:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239838AbhLJPg6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Dec 2021 10:36:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242879AbhLJPg5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Dec 2021 10:36:57 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92928C061353
        for <io-uring@vger.kernel.org>; Fri, 10 Dec 2021 07:33:22 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id gx15-20020a17090b124f00b001a695f3734aso7862286pjb.0
        for <io-uring@vger.kernel.org>; Fri, 10 Dec 2021 07:33:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=+Esq0sZPdw3CUxbw90CaKjttg63CC/0FtTnNLHVgmwI=;
        b=Xp2aY5/mUAdqIk01AyFEyxgsVqFLG+FbOiR7C9BxjePy79yFkIuwRNLaeHlSuzJITw
         MZ+zJ0V+kJE24ZF2MKGlQUv4YMlLvcCxcm4M0q5NNCMHXLDOel1Xr+nqXqJm/NMZpv2E
         m8wvlPxzaduZyLQso4P2xi2nTJHiRZ9UsuHzgRntHV+w5QxRS1Y2pyiKCVKEA2LwdqPB
         IdUD73haKh+vGZE5/3bo9GUW3u2MuRIB99j4CK0wZCW8nVxAfvM3WC1lT7WtZwh+Bka6
         UWCjbCntvub27qGRhZjer9XfedW4QJUn7jdK+dGGf6Qar8+vOL03yaR6YvmPWyy5m97r
         XxKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+Esq0sZPdw3CUxbw90CaKjttg63CC/0FtTnNLHVgmwI=;
        b=jVpYXdBudnihrjdt8J1MgLEom60JMEKuv185Oz84TRgXmT88B2DsFW/gwhEGyTjs/8
         w+cgvyomQQyVig5QueFAOOMkKru+leYAFqVYBBBH92wYz1IAgocwM92Ju+bk9fRbR1Lm
         sSVHOFhikRYBIn+p+NrsgUrmmkewnDOjvaepV2odcItsXwhrYJqF5rcMmzxfAx19pFUe
         fXfga0A21ndhPHF73fd6UwwxSkmERdMC/VEC5yenj/YjExHatqwGNRXPKczk79UmN4Iw
         LbS5dJCPutkQmQOXWfMvdS/omEMDhDyEpIK8MUpWdsjZTdgh1nXxtCy+P+Va/8772fBm
         xDQQ==
X-Gm-Message-State: AOAM5305OvuS7aRWf27LCGEVXQyvC+5NqpNa2yoG6JY8eP8V/2Rgx+8E
        eYyVFyKF4+gHX3XQ8j/cJbHRbg==
X-Google-Smtp-Source: ABdhPJx5r6aZDrgRAjs5N8RFRVvklLrmHTgFw9ZGeuUK0e3eo9H/ga+H5kpiwNSB0MZFyWYriQEOFw==
X-Received: by 2002:a17:90b:1d81:: with SMTP id pf1mr25132213pjb.134.1639150401989;
        Fri, 10 Dec 2021 07:33:21 -0800 (PST)
Received: from [172.20.4.26] ([66.185.175.30])
        by smtp.gmail.com with ESMTPSA id fw21sm12546666pjb.25.2021.12.10.07.33.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 07:33:21 -0800 (PST)
Subject: Re: [syzbot] KASAN: use-after-free Write in io_queue_worker_create
To:     syzbot <syzbot+b60c982cb0efc5e05a47@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000003cd27305d2c8a028@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8544854b-226d-befd-bd91-5af182c2b03d@kernel.dk>
Date:   Fri, 10 Dec 2021 08:33:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0000000000003cd27305d2c8a028@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/10/21 4:00 AM, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> INFO: task hung in io_wq_put_and_exit
> 
> INFO: task syz-executor.2:8594 blocked for more than 143 seconds.
>       Not tainted 5.16.0-rc1-syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz-executor.2  state:D stack:26928 pid: 8594 ppid:  3894 flags:0x00024004
> Call Trace:
>  <TASK>
>  context_switch kernel/sched/core.c:4972 [inline]
>  __schedule+0xa9a/0x4940 kernel/sched/core.c:6253
>  schedule+0xd2/0x260 kernel/sched/core.c:6326
>  schedule_timeout+0x1db/0x2a0 kernel/time/timer.c:1857
>  do_wait_for_common kernel/sched/completion.c:85 [inline]
>  __wait_for_common kernel/sched/completion.c:106 [inline]
>  wait_for_common kernel/sched/completion.c:117 [inline]
>  wait_for_completion+0x174/0x270 kernel/sched/completion.c:138
>  io_wq_exit_workers fs/io-wq.c:1222 [inline]
>  io_wq_put_and_exit+0x33a/0xb70 fs/io-wq.c:1257
>  io_uring_clean_tctx fs/io_uring.c:9803 [inline]
>  io_uring_cancel_generic+0x622/0x695 fs/io_uring.c:9886
>  io_uring_files_cancel include/linux/io_uring.h:16 [inline]
>  do_exit+0x60c/0x2b40 kernel/exit.c:787
>  do_group_exit+0x125/0x310 kernel/exit.c:929
>  get_signal+0x47d/0x2220 kernel/signal.c:2830
>  arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:868
>  handle_signal_work kernel/entry/common.c:148 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
>  exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:207
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
>  syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
>  do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7fe940cbfb49
> RSP: 002b:00007fe940435218 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
> RAX: fffffffffffffe00 RBX: 00007fe940dd2f68 RCX: 00007fe940cbfb49
> RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007fe940dd2f68
> RBP: 00007fe940dd2f60 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007fe940dd2f6c
> R13: 00007ffc1b1af90f R14: 00007fe940435300 R15: 0000000000022000
>  </TASK>

#syz test git://git.kernel.dk/linux-block io_uring-5.16

-- 
Jens Axboe

