Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8C7D407B52
	for <lists+io-uring@lfdr.de>; Sun, 12 Sep 2021 04:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbhILCfZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Sep 2021 22:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbhILCfY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Sep 2021 22:35:24 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42EC3C061574;
        Sat, 11 Sep 2021 19:34:11 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id v19so1241000pjh.2;
        Sat, 11 Sep 2021 19:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :cc:to;
        bh=df5oH4bbAuFgf4U6jABKSHj6wtfq2+TWBnGOzgk7ZLk=;
        b=KQYB164/O06T6epovdKBQ3vZSa+h1ofkJ3ldRkE8k4GQqI8D65DxjYK41FnS7uXl8w
         vNm7weHhvX64r8T24Q0fmU1WZwRSiaepUdzt/cQMd/O5x7aNBMQWTjM+qMWgsw2jzxo5
         abz6ffUzqC49tYySvtqr+CiYpVzxOnW0Htop0SwGkSjLKpQdzQOi9Aab6fCvGUluZz2G
         3+Ii+jWP0LeRzRXxx6d8OIEhN2EzDzi2UZqsfhsFX4RsY4fDpa2WZ14JuUt94QlVw64T
         6CNsOyelzlnOmAw7jU+4dsm5XXo+Du+/HfcbYQm2tCwkX9fewhFqZZFDuyUlChn2LC0y
         8KIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:cc:to;
        bh=df5oH4bbAuFgf4U6jABKSHj6wtfq2+TWBnGOzgk7ZLk=;
        b=ew3l4w+pgEcjmq25H7LD6XT+sKmvJXGUhAkKB3KL0L0yigVaEtqs9RYqqorJ5iGwYG
         dPjbYlEeXUmSKflNvBMf17KGCN40rWDFQ/5WqKlwS7FNL7B52LYy8Sj6/p6fq1bzUJTV
         HhB98/rTMrXrgFOXXvcBUEowjnctTzoc0BO8fGAhokcwHEvfaaC9QPSi/Pv77QOmgBH1
         +rO7V49B+Rkj8gyL7sNvgxuxsD7CrF0HrJZfSnwznv61if1skcgI3kmV1cRN7EIJmXJu
         lHAiiBE8aO7qygCq7L8Z0PZSMEi8KBexActohLVYImN0MwjZYLp7QBMJWnPK6912MS/X
         ZbUQ==
X-Gm-Message-State: AOAM532NrYajjonEW7mO6LiGUdoLQwxyIoJg3jKzy7usJSL8yHvkC8Dn
        Ka32eYJDOLlYe5F7nEmDL+3xv+p2b1fzTw==
X-Google-Smtp-Source: ABdhPJxSqUIlAthFXC4PewbWKVdcZhyLylQE28bxDneqlyoQuw1pJThDcxtgAzGZ6mqVnBzUBI65iw==
X-Received: by 2002:a17:90b:4a84:: with SMTP id lp4mr5614832pjb.34.1631414050292;
        Sat, 11 Sep 2021 19:34:10 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id j6sm3214393pgh.17.2021.09.11.19.34.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Sep 2021 19:34:09 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: io-uring: KASAN failure, presumably 
Message-Id: <2C3AECED-1915-4080-B143-5BA4D76FB5CD@gmail.com>
Date:   Sat, 11 Sep 2021 19:34:08 -0700
Cc:     io-uring@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello Jens (& Pavel),

I hope you are having a nice weekend. I ran into a KASAN failure in =
io-uring
which I think is not "my fault".

The failure does not happen very infrequently, so my analysis is based =
on
reading the code. IIUC the failure, then I do not understand the code =
well
enough, as to say I do not understand how it was supposed to work. I =
would
appreciate your feedback.

The failure happens on my own custom kernel (do not try to correlate the =
line
numbers). The gist of the splat is:

[84142.034456] =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[84142.035552] BUG: KASAN: use-after-free in io_req_complete_post =
(fs/io_uring.c:1629)
[84142.036473] Read of size 4 at addr ffff8881a1577e60 by task =
memcached/246246
[84142.037415]
[84142.037621] CPU: 0 PID: 246246 Comm: memcached Not tainted 5.13.1+ =
#236
[84142.038509] Hardware name: VMware, Inc. VMware Virtual Platform/440BX =
Desktop Reference Platform, BIOS 6.00 07/22/2020
[84142.040151] Call Trace:     =20
[84142.040495] dump_stack (lib/dump_stack.c:122)
[84142.040962] print_address_description.constprop.0 =
(mm/kasan/report.c:234)
[84142.041751] ? io_req_complete_post (fs/io_uring.c:1629)
[84142.042365] kasan_report.cold (mm/kasan/report.c:420 =
mm/kasan/report.c:436)
[84142.042921] ? io_req_complete_post (fs/io_uring.c:1629)
[84142.043534] __asan_load4 (mm/kasan/generic.c:252)=20
[84142.044008] io_req_complete_post (fs/io_uring.c:1629)=20
[84142.044609] __io_complete_rw.isra.0 (fs/io_uring.c:2525)=20
[84142.045264] ? lockdep_hardirqs_on_prepare =
(kernel/locking/lockdep.c:4123)=20
[84142.045949] io_complete_rw (fs/io_uring.c:2532)=20
[84142.046447] handle_userfault (fs/userfaultfd.c:778)=20

[snip]

[84142.072667] Freed by task 246231:
[84142.073197] kasan_save_stack (mm/kasan/common.c:39)
[84142.073896] kasan_set_track (mm/kasan/common.c:46)
[84142.074421] kasan_set_free_info (mm/kasan/generic.c:359)
[84142.075015] __kasan_slab_free (mm/kasan/common.c:362 =
mm/kasan/common.c:325 mm/kasan/common.c:368)
[84142.075578] kmem_cache_free (mm/slub.c:1608 mm/slub.c:3168 =
mm/slub.c:3184)
[84142.076116] __io_free_req (./arch/x86/include/asm/preempt.h:80 =
./include/linux/rcupdate.h:68 ./include/linux/rcupdate.h:655 =
./include/linux/percpu-refcount.h:317 =
./include/linux/percpu-refcount.h:338 fs/io_uring.c:1802)
[84142.076641] io_free_req (fs/io_uring.c:2113)
[84142.077110] __io_queue_sqe (fs/io_uring.c:2208 fs/io_uring.c:6533)
[84142.077628] io_queue_sqe (fs/io_uring.c:6568)
[84142.078121] io_submit_sqes (fs/io_uring.c:6730 fs/io_uring.c:6838)
[84142.078665] __x64_sys_io_uring_enter (fs/io_uring.c:9428 =
fs/io_uring.c:9369 fs/io_uring.c:9369)
[84142.079463] do_syscall_64 (arch/x86/entry/common.c:47)
[84142.079967] entry_SYSCALL_64_after_hwframe =
(arch/x86/entry/entry_64.S:112)


I believe the issue is related to the handling of REQ_F_REISSUE and
specifically to commit 230d50d448acb ("io_uring: move reissue into =
regular IO
path"). There seems to be a race between io_write()/io_read()
and __io_complete_rw()/kiocb_done().

__io_complete_rw() sets REQ_F_REIUSSE:

               if ((res =3D=3D -EAGAIN || res =3D=3D -EOPNOTSUPP) &&
                    io_rw_should_reissue(req)) {
                        req->flags |=3D REQ_F_REISSUE;
                        return;
               }

And then kiocb_done() then checks REQ_F_REISSUE and clear it:

        if (check_reissue && req->flags & REQ_F_REISSUE) {
                req->flags &=3D ~REQ_F_REISSUE;
                ...


These two might race with io_write() for instance, which issues the I/O
(__io_complete_rw() and kiocb_done() might run immediately after
call_write_iter() is called) and then check and clear REQ_F_REISSUE.

        if (req->file->f_op->write_iter)
                ret2 =3D call_write_iter(req->file, kiocb, iter);
        else if (req->file->f_op->write)
                ret2 =3D loop_rw_iter(WRITE, req, iter);
        else
                ret2 =3D -EINVAL;

        if (req->flags & REQ_F_REISSUE) {
                req->flags &=3D ~REQ_F_REISSUE;
                ret2 =3D -EAGAIN;
        }


So if call_write_iter() returns -EIOCBQUEUED, this return value can be
lost/ignored if kiocb_done() was called with result of -EAGAIN. =
Presumably,
other bad things might happen due to the fact both io_write() and
kiocb_done() see REQ_F_REISSUE set.

You might ask why, after enqueuing the IO for async execution, =
kiocb_done()
would be called with -EAGAIN as a result. Indeed, this might be more
unique to my use-case that is under development (userfaultfd might
return -EAGAIN if the mappings undergoing changes; presumably -EBUSY or =
some
wait-queue would be better.) Having said that, the current behavior =
still
seems valid.

So I do not understand the check for REQ_F_REISSUE in =
io_write()/io_read().
Shouldn't it just be removed? I do not suppose you want to do
bit-test-and-clear to avoid such a race.

Thanks,
Nadav=
