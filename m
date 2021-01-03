Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C91412E8E97
	for <lists+io-uring@lfdr.de>; Sun,  3 Jan 2021 22:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbhACVyT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Jan 2021 16:54:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbhACVyS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Jan 2021 16:54:18 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74B4C0613CF
        for <io-uring@vger.kernel.org>; Sun,  3 Jan 2021 13:53:38 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id x18so13374795pln.6
        for <io-uring@vger.kernel.org>; Sun, 03 Jan 2021 13:53:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=SOqNdsnqAMqhnVr3MpJKK4X9DOOmp6814kfWnP9S4FM=;
        b=y1cdXFGZJpYOh6kKX1ouuWSEilCExSz9gYHJ17RezGNA/EBig5DR8biiZGQ4rpGNct
         84MUcwh0/tba3K7LqfC/lcL2DjJZnm+5v1GgbZjD3jUONljic/IGEPgqMXLn+PxlmQG5
         uFzNAC9H2TU6buFlKO5fgSlWKK2KthjIGCHjZNEzMuabjwU/0MnyQq185SBoH7wREmoh
         MfWh5ApELl6ld4c5QvbfdF2y38tFJzDPMFokc0wnQrB14WkKDzB4izb2ef3DPiima6Rd
         UkeOpyNw5diJEwiqfEEmLTqy6GicK7lCJwdogwg6o6a18cy0oKyfQ+SJBE9IQQieHyQ3
         G/hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SOqNdsnqAMqhnVr3MpJKK4X9DOOmp6814kfWnP9S4FM=;
        b=nwgXkVgzvMikWtDyAF5wSiiPHhrNM9vLeXmzWPeO9qgOn3i1GqxvpN2E615H9JI4cU
         IKzbrd4L9AidXE75OyA083cHwY1gwwHkXYcWIGs+mcAzyUHdQl+3YxOn68s+4PRo5iPE
         2JqfInpCVHhLX4wuz2KLfwwIjZrXzdGab4B98Wi1Rn3z5Dsr8lghvCC8dLbUn2VilcrV
         QRhDfswkOZPnM1WWyqR9z/5QP6DiIuO5caNfKA8KmzLN9ULys/iZHmXKhCeX4MzgKK7D
         wzpAaAgQframevR2rqQARwQQTuv4WlIsCVVxzO4yaoqhAX/fiM00Rv9e9NnEeYJgMw/j
         jWXw==
X-Gm-Message-State: AOAM532hauj4iufoVXA8ArIV8uNV/0jgwyRS8hdVV8ojJw+UJn/mhdGM
        HPHd+6ff75yQwOei2CORkhC2+qinKBVPjQ==
X-Google-Smtp-Source: ABdhPJzcd8BBndSAfUu2cIdM/q7zeKNDdn3Zp84q+JXRLH44Np6UcYZ63lGG/K661Ig5IZzidwyodg==
X-Received: by 2002:a17:90a:a394:: with SMTP id x20mr26316806pjp.24.1609710818032;
        Sun, 03 Jan 2021 13:53:38 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id c10sm54804651pfj.54.2021.01.03.13.53.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Jan 2021 13:53:37 -0800 (PST)
Subject: Re: INFO: task hung in __io_uring_task_cancel
To:     Palash Oswal <oswalpalash@gmail.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@kernel.org, mingo@redhat.com, peterz@infradead.org,
        rostedt@goodmis.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk, will@kernel.org
References: <CAGyP=7cFM6BJE7X2PN9YUptQgt5uQYwM4aVmOiVayQPJg1pqaA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e3bd8214-830d-ab3e-57ba-564c5adcac52@kernel.dk>
Date:   Sun, 3 Jan 2021 14:53:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAGyP=7cFM6BJE7X2PN9YUptQgt5uQYwM4aVmOiVayQPJg1pqaA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/2/21 9:14 PM, Palash Oswal wrote:
>  Hello,
> 
> I was running syzkaller and I found the following issue :
> 
> Head Commit : b1313fe517ca3703119dcc99ef3bbf75ab42bcfb ( v5.10.4 )
> Git Tree : stable
> Console Output :
> [  242.769080] INFO: task repro:2639 blocked for more than 120 seconds.
> [  242.769096]       Not tainted 5.10.4 #8
> [  242.769103] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  242.769112] task:repro           state:D stack:    0 pid: 2639
> ppid:  2638 flags:0x00000004
> [  242.769126] Call Trace:
> [  242.769148]  __schedule+0x28d/0x7e0
> [  242.769162]  ? __percpu_counter_sum+0x75/0x90
> [  242.769175]  schedule+0x4f/0xc0
> [  242.769187]  __io_uring_task_cancel+0xad/0xf0
> [  242.769198]  ? wait_woken+0x80/0x80
> [  242.769210]  bprm_execve+0x67/0x8a0
> [  242.769223]  do_execveat_common+0x1d2/0x220
> [  242.769235]  __x64_sys_execveat+0x5d/0x70
> [  242.769249]  do_syscall_64+0x38/0x90
> [  242.769260]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [  242.769270] RIP: 0033:0x7f59ce45967d
> [  242.769277] RSP: 002b:00007ffd05d10a58 EFLAGS: 00000246 ORIG_RAX:
> 0000000000000142
> [  242.769290] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f59ce45967d
> [  242.769297] RDX: 0000000000000000 RSI: 0000000020000180 RDI: 00000000ffffffff
> [  242.769304] RBP: 00007ffd05d10a70 R08: 0000000000000000 R09: 00007ffd05d10a70
> [  242.769311] R10: 0000000000000000 R11: 0000000000000246 R12: 000055a91d37d320
> [  242.769318] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Can you see if this helps? The reproducer is pretty brutal, it'll fork
thousands of tasks with rings! But should work of course. I think this
one is pretty straight forward, and actually an older issue with the
poll rewaiting.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ca46f314640b..539de04f9183 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5103,6 +5103,12 @@ static bool io_poll_rewait(struct io_kiocb *req, struct io_poll_iocb *poll)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
+	/* Never re-wait on poll if the ctx or task is going away */
+	if (percpu_ref_is_dying(&ctx->refs) || req->task->flags & PF_EXITING) {
+		spin_lock_irq(&ctx->completion_lock);
+		return false;
+	}
+
 	if (!req->result && !READ_ONCE(poll->canceled)) {
 		struct poll_table_struct pt = { ._key = poll->events };
 

-- 
Jens Axboe

