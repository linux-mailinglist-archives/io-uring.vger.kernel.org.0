Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDE192E92BD
	for <lists+io-uring@lfdr.de>; Mon,  4 Jan 2021 10:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbhADJll (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jan 2021 04:41:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbhADJll (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jan 2021 04:41:41 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C59DC061574;
        Mon,  4 Jan 2021 01:41:01 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id h22so62917427lfu.2;
        Mon, 04 Jan 2021 01:41:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OHZHM+kRFdG223NS2eR7v7jqwBdYWtuAly4gGYaAomk=;
        b=RikCPw4A/akfu966sM6AxZPOpnBace4zpl6logtwXF7fr1XUhKEYm+LTLi8MV6wLuK
         MaIXBURN+IdueYf86bTmMBCSKWyvXWTwP4lUkCrILOESeRb4TpmDjxRYO+sTwSeakOII
         1Nz/GCIJrmDDaNg48Lk5W9APeCu1qefVNQQYJ07wTXVV8B1VCXma/RmMMNbMY/C6pHET
         sjsd8Lw73zhz/7118877wLQunOCRlTT24Z1d8U2fucK2m5htBmZ0IADTow/uX/C/Yd9G
         nizBbWCzdqd2yeIebl8aEZDl2mrybm0BPDmFf5zEFnnvsl9/EdFDrX07dBhdZmZhM31G
         kWjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OHZHM+kRFdG223NS2eR7v7jqwBdYWtuAly4gGYaAomk=;
        b=KwNMpJ3rJKuDQ/PtgS3oIDiYX2PVQL3V5mwp+6aTv/8DwOtHrg8weiC7OYLe9Pg2f4
         cKX1AWidxF5szRHi2WeTKT0M568O3z8br88ZPV3nCY9XJ19scU0eySGu1rh52FIa5P5Z
         LhblrPgFny6sOwCN9nntw++EN8KQYKoZT/2MGGDn/4g0a14S+tFxBwDKhN6IPrTImS/G
         /N1lOW0t3Lvr1vZVAUsczkVEnncAs7MQASROH5dCy8co6tFr1F2X+FDSZx/vBQRXi7j+
         957ZG++ACi0MJY8VLkDWZW9sR5a95HDDdYqfOXes8Ma47CaZ80oKh1S0tw6F+IKvHuV2
         s5vA==
X-Gm-Message-State: AOAM531JNTFgv6HOqtHYsdEltAtXeGaUAfQggJgPYgw5tfqtWLpBNyEB
        ELQxj2wbss23EDSk1nk/R3ifnMmyQPD3ORKPO0FC6jce5KppKNH+
X-Google-Smtp-Source: ABdhPJyC7e5FpObyXe93kKe73TNcg2UGQkmuqvCYioPd4bf9WeMdtkd6y+pEn3zt8vfFZ7QNCwkWYibqbuEbtXrQA7s=
X-Received: by 2002:a2e:b5d9:: with SMTP id g25mr36639429ljn.471.1609753259430;
 Mon, 04 Jan 2021 01:40:59 -0800 (PST)
MIME-Version: 1.0
References: <CAGyP=7cFM6BJE7X2PN9YUptQgt5uQYwM4aVmOiVayQPJg1pqaA@mail.gmail.com>
 <20210103123701.1500-1-hdanton@sina.com> <CAGyP=7eJKvVXDK+qo9d-AmxC2=QCKPKeGrEJm1bcYNN9f4AKmg@mail.gmail.com>
 <20210104065231.2579-1-hdanton@sina.com>
In-Reply-To: <20210104065231.2579-1-hdanton@sina.com>
From:   Palash Oswal <oswalpalash@gmail.com>
Date:   Mon, 4 Jan 2021 15:10:48 +0530
Message-ID: <CAGyP=7dQP_b066kgDjeUCs1RUNvkOwoxirHsubL2yG2ZyjwsqA@mail.gmail.com>
Subject: Re: INFO: task hung in __io_uring_task_cancel
To:     Hillf Danton <hdanton@sina.com>
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jan 4, 2021 at 12:22 PM Hillf Danton <hdanton@sina.com> wrote:
> It is now updated.

Hello Hilf,

Thanks for the new diff. I tested by applying the diff on 5.10.4 with
the original reproducer, and the issue still persists.

root@syzkaller:~# [  242.925799] INFO: task repro:416 blocked for more
than 120 seconds.
[  242.928095]       Not tainted 5.10.4+ #12
[  242.929034] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  242.930825] task:repro           state:D stack:    0 pid:  416
ppid:   415 flags:0x00000004
[  242.933404] Call Trace:
[  242.934365]  __schedule+0x28d/0x7e0
[  242.935199]  ? __percpu_counter_sum+0x75/0x90
[  242.936265]  schedule+0x4f/0xc0
[  242.937159]  __io_uring_task_cancel+0xc0/0xf0
[  242.938340]  ? wait_woken+0x80/0x80
[  242.939380]  bprm_execve+0x67/0x8a0
[  242.940163]  do_execveat_common+0x1d2/0x220
[  242.941090]  __x64_sys_execveat+0x5d/0x70
[  242.942056]  do_syscall_64+0x38/0x90
[  242.943088]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  242.944511] RIP: 0033:0x7fd0b781e469
[  242.945422] RSP: 002b:00007fffda20e9c8 EFLAGS: 00000246 ORIG_RAX:
0000000000000142
[  242.947289] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fd0b781e469
[  242.949031] RDX: 0000000000000000 RSI: 0000000020000180 RDI: 00000000ffffffff
[  242.950683] RBP: 00007fffda20e9e0 R08: 0000000000000000 R09: 00007fffda20e9e0
[  242.952450] R10: 0000000000000000 R11: 0000000000000246 R12: 0000556068200bf0
[  242.954045] R13: 00007fffda20eb00 R14: 0000000000000000 R15: 0000000000000000


linux git:(b1313fe517ca)  git diff
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0fcd065baa76..e0c5424e28b1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1867,8 +1867,7 @@ static void __io_free_req(struct io_kiocb *req)
     io_dismantle_req(req);

     percpu_counter_dec(&tctx->inflight);
-    if (atomic_read(&tctx->in_idle))
-        wake_up(&tctx->wait);
+    wake_up(&tctx->wait);
     put_task_struct(req->task);

     if (likely(!io_is_fallback_req(req)))
@@ -8853,12 +8852,11 @@ void __io_uring_task_cancel(void)
          * If we've seen completions, retry. This avoids a race where
          * a completion comes in before we did prepare_to_wait().
          */
-        if (inflight != tctx_inflight(tctx))
-            continue;
-        schedule();
+        if (inflight == tctx_inflight(tctx))
+            schedule();
+        finish_wait(&tctx->wait, &wait);
     } while (1);

-    finish_wait(&tctx->wait, &wait);
     atomic_dec(&tctx->in_idle);
 }
