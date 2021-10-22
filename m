Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F23843785D
	for <lists+io-uring@lfdr.de>; Fri, 22 Oct 2021 15:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbhJVNvy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Oct 2021 09:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbhJVNvy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Oct 2021 09:51:54 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36B4C061764;
        Fri, 22 Oct 2021 06:49:36 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id g8so1581568edb.12;
        Fri, 22 Oct 2021 06:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=fvpZOAAFqxccN6t+CkdWkIvI92JSi1/qd9eo1f100tM=;
        b=qK9+vhHUBre4dSbVZnMg9iLlSAaWTkFDw/6rsVihuUHzgHhI3DAxax8zi+w1dm+c/m
         aEBt5MScBHqjDU16eLExVW38nzjc6dYjx4y1d8xjDqUkZcpFpk1AqDs23xq2s/huDoUN
         z7FComNlz+im9abOzIoX4qN24GtdNRqXlIbxR6RxjU17GyBEiu2K2KEAYzfKPlbg6BTf
         biZkG3w83ObAQ4vyz2Hcsnt2toYcaVxT9fe/YFgFS1ya5md0VegdTFxkyJWFIGcdgxx0
         NprRH7lEdL0rsdFkPs3DTurwkpkBjHpavW5zczjFDAMnQTKo6X9YccQKjuoikRF8l9vH
         yxYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fvpZOAAFqxccN6t+CkdWkIvI92JSi1/qd9eo1f100tM=;
        b=Rytg+jR1XqDMNSUtFJg0MoRlVClhQ4jwQkmQBpUpaFC+B+ppy7oKElaK0ze84hQsI+
         Zn95QToJNpgRUMf+q8Dp8l6hcu7CnX/LsfsX4K5c7gFE36UFbL7g8KqJvptTTXZCtB49
         LkkR4aRQYegzzz+jOJdAl5qTgb/mBkxUKSdALtY9eW9ewKjOafQJjvaNhdqHnI0GqGpt
         ikTyr2ghZHFRw4284JovxDWHP6pX7nh438OVLW83QQ9JLTcErll6eGTDPwywkJFvJE0C
         sNz3YdJWTd6CpFAYQgkR7MSVx7xtaU+PLz5uObVfgRWbe8tbw7l3+ylNpY64n7SSDojz
         EfIA==
X-Gm-Message-State: AOAM533gREyRJTQHrRptngbLvTlv//pwlCeV1GyW2rK7ePilWtDos7vL
        scLEw5q3AqTg7YUCgcqrbE8=
X-Google-Smtp-Source: ABdhPJyRismCHPkF/z+GwcqNJajj9EJ/kUo7tTLGiuNdQJVUkKA/c5g6tAnzWasnKWpzgPGHZtgF+Q==
X-Received: by 2002:a05:6402:90c:: with SMTP id g12mr82958edz.369.1634910575197;
        Fri, 22 Oct 2021 06:49:35 -0700 (PDT)
Received: from [192.168.8.198] ([148.252.133.195])
        by smtp.gmail.com with ESMTPSA id m3sm5103729edc.11.2021.10.22.06.49.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 06:49:34 -0700 (PDT)
Message-ID: <85f96aab-4127-f494-9718-d7bfc035db54@gmail.com>
Date:   Fri, 22 Oct 2021 14:49:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [syzbot] INFO: task hung in io_wqe_worker
Content-Language: en-US
To:     syzbot <syzbot+27d62ee6f256b186883e@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000000012fb05cee99477@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <0000000000000012fb05cee99477@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/22/21 05:38, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> INFO: task hung in io_wqe_worker
> 
> INFO: task iou-wrk-9392:9401 blocked for more than 143 seconds.
>        Not tainted 5.15.0-rc2-syzkaller #0
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:iou-wrk-9392    state:D stack:27952 pid: 9401 ppid:  7038 flags:0x00004004
> Call Trace:
>   context_switch kernel/sched/core.c:4940 [inline]
>   __schedule+0xb44/0x5960 kernel/sched/core.c:6287
>   schedule+0xd3/0x270 kernel/sched/core.c:6366
>   schedule_timeout+0x1db/0x2a0 kernel/time/timer.c:1857
>   do_wait_for_common kernel/sched/completion.c:85 [inline]
>   __wait_for_common kernel/sched/completion.c:106 [inline]
>   wait_for_common kernel/sched/completion.c:117 [inline]
>   wait_for_completion+0x176/0x280 kernel/sched/completion.c:138
>   io_worker_exit fs/io-wq.c:183 [inline]
>   io_wqe_worker+0x66d/0xc40 fs/io-wq.c:597
>   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

Easily reproducible, it's stuck in

static void io_worker_exit(struct io_worker *worker)
{
	...
	wait_for_completion(&worker->ref_done);
	...
}

The reference belongs to a create_worker_cb() task_work item. It's expected
to either be executed or cancelled by io_wq_exit_workers(), but the owner
task never goes __io_uring_cancel (called in do_exit()) and so never
reaches io_wq_exit_workers().

Following the owner task, cat /proc/<pid>/stack:

[<0>] do_coredump+0x1d0/0x10e0
[<0>] get_signal+0x4a3/0x960
[<0>] arch_do_signal_or_restart+0xc3/0x6d0
[<0>] exit_to_user_mode_prepare+0x10e/0x190
[<0>] irqentry_exit_to_user_mode+0x9/0x20
[<0>] irqentry_exit+0x36/0x40
[<0>] exc_page_fault+0x95/0x190
[<0>] asm_exc_page_fault+0x1e/0x30

(gdb) l *(do_coredump+0x1d0-5)
0xffffffff81343ccb is in do_coredump (fs/coredump.c:469).
464
465             if (core_waiters > 0) {
466                     struct core_thread *ptr;
467
468                     freezer_do_not_count();
469                     wait_for_completion(&core_state->startup);
470                     freezer_count();

Can't say anything more at the moment as not familiar with coredump

-- 
Pavel Begunkov
