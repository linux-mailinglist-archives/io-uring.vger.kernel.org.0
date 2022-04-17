Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 266A8504614
	for <lists+io-uring@lfdr.de>; Sun, 17 Apr 2022 04:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233309AbiDQCTr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 Apr 2022 22:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233392AbiDQCTm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 16 Apr 2022 22:19:42 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC46739179
        for <io-uring@vger.kernel.org>; Sat, 16 Apr 2022 19:17:04 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id i24-20020a17090adc1800b001cd5529465aso9977884pjv.0
        for <io-uring@vger.kernel.org>; Sat, 16 Apr 2022 19:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=e7rLfnATy9xIaXgzkFV4mffpoCy71ONwr7sohfESaIY=;
        b=7qcwe/J2quyhBkiT1FkypRPoDAmxgA9ao4ZiV44u03GptMWq5TwB4FFsmFdy5crMzL
         qVPEkR6RAWYbSu4tYuCdJGWqw61piz+8xqmWk72RQ/RfRtg5S+mIpTpWyly4jPxI+EWd
         siF5qVaOQLRqdXwQwvk7GpxMkF92ZWz+DOdLD/dM03oOKhBqzIriGNexBb2nqahcg99N
         0uvFsXl26vwTMPuMTEPhaHSw7d8cgeIO/Hd1td8X7K8O2eQnsfqc61t9MzDoGxi3Dqik
         cupmLeWjraNoIOx6TSMNeEgmg/7F5tVLaYYIinDYhkjupYPKUJChJmFio4+2jL89OIRE
         QZzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=e7rLfnATy9xIaXgzkFV4mffpoCy71ONwr7sohfESaIY=;
        b=k9MS9AGnbhXcojFIWciqwtF/x3okOgFWKNdvMN3wG9qOPqfjbsI5HGuKX/B/3J1Vjo
         Pap8zUIfhyKdy58hkLSgoKmLLJwZdKTywPqgjsUKmeRJlfPA2AYF4FGs84SXu4X4bwSz
         wSqZwKjFRvy7kNz4K07u61uNGZdZCiMptM78dlXWZQ5I8QsUTLeJzBXUNy4ytGltg8za
         Jiq5PsmSNf9OuCw6BIPCYR1UM7XqNkzwTmDVBH5aMbaDO8bqnhMt5yFrlCdcnuAwhffz
         5q8+72OVrR2tbmWWFr9vJjPOKWCWXCcgOiD4j9MPwMJRTGh6/NpT7LKADoCp8949a7Bp
         lSyw==
X-Gm-Message-State: AOAM533rExJLkmtLVq2nQgvLgoEp25qInoVFEf5c3MNuMwDUuvRZ9sGJ
        z4xPwQ+ZUl7qO6QMGAKsgUc+bBUb/rRwnU0c
X-Google-Smtp-Source: ABdhPJzKXcenvjYvmMIHs12Jif1rLfrVgxDO6pGpkbXeBumGRDv95Ovv/D6P0fFuY9l28sg+szyOyA==
X-Received: by 2002:a17:90a:558a:b0:1ca:a819:d2d1 with SMTP id c10-20020a17090a558a00b001caa819d2d1mr11693111pji.126.1650161824181;
        Sat, 16 Apr 2022 19:17:04 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id k187-20020a636fc4000000b003983a01b896sm8393327pgc.90.2022.04.16.19.17.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Apr 2022 19:17:03 -0700 (PDT)
Message-ID: <004e2f64-cf4e-2490-ed2c-29c073f76704@kernel.dk>
Date:   Sat, 16 Apr 2022 20:17:02 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [syzbot] memory leak in iovec_from_user
Content-Language: en-US
To:     syzbot <syzbot+96b43810dfe9c3bb95ed@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000951a1505dccf8b73@google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <000000000000951a1505dccf8b73@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/16/22 7:27 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    ce522ba9ef7e Linux 5.18-rc2
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=14225724f00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b8f1a3425e05af27
> dashboard link: https://syzkaller.appspot.com/bug?extid=96b43810dfe9c3bb95ed
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13c45d88f00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17b428af700000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+96b43810dfe9c3bb95ed@syzkaller.appspotmail.com
> 
> executing program
> BUG: memory leak
> unreferenced object 0xffff88810d698300 (size 192):
>   comm "syz-executor156", pid 3595, jiffies 4294944234 (age 12.580s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffff823357be>] kmalloc_array include/linux/slab.h:621 [inline]
>     [<ffffffff823357be>] iovec_from_user lib/iov_iter.c:1922 [inline]
>     [<ffffffff823357be>] iovec_from_user+0x13e/0x280 lib/iov_iter.c:1905
>     [<ffffffff82335945>] __import_iovec+0x45/0x250 lib/iov_iter.c:1948
>     [<ffffffff81668c8e>] __io_import_iovec+0xfe/0x800 fs/io_uring.c:3497
>     [<ffffffff8166d92f>] io_import_iovec fs/io_uring.c:3508 [inline]
>     [<ffffffff8166d92f>] io_read+0x59f/0x880 fs/io_uring.c:3803
>     [<ffffffff816727b4>] io_issue_sqe+0x364/0x3270 fs/io_uring.c:7122
>     [<ffffffff816761c3>] __io_queue_sqe fs/io_uring.c:7489 [inline]
>     [<ffffffff816761c3>] io_queue_sqe fs/io_uring.c:7531 [inline]
>     [<ffffffff816761c3>] io_submit_sqe fs/io_uring.c:7736 [inline]
>     [<ffffffff816761c3>] io_submit_sqes+0x553/0x3030 fs/io_uring.c:7842
>     [<ffffffff81679390>] __do_sys_io_uring_enter+0x6f0/0x1100 fs/io_uring.c:10780
>     [<ffffffff8451ca25>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>     [<ffffffff8451ca25>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>     [<ffffffff84600068>] entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> BUG: memory leak
> unreferenced object 0xffff88810d6983c0 (size 192):
>   comm "syz-executor156", pid 3603, jiffies 4294944759 (age 7.330s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffff823357be>] kmalloc_array include/linux/slab.h:621 [inline]
>     [<ffffffff823357be>] iovec_from_user lib/iov_iter.c:1922 [inline]
>     [<ffffffff823357be>] iovec_from_user+0x13e/0x280 lib/iov_iter.c:1905
>     [<ffffffff82335945>] __import_iovec+0x45/0x250 lib/iov_iter.c:1948
>     [<ffffffff81668c8e>] __io_import_iovec+0xfe/0x800 fs/io_uring.c:3497
>     [<ffffffff8166d92f>] io_import_iovec fs/io_uring.c:3508 [inline]
>     [<ffffffff8166d92f>] io_read+0x59f/0x880 fs/io_uring.c:3803
>     [<ffffffff816727b4>] io_issue_sqe+0x364/0x3270 fs/io_uring.c:7122
>     [<ffffffff816761c3>] __io_queue_sqe fs/io_uring.c:7489 [inline]
>     [<ffffffff816761c3>] io_queue_sqe fs/io_uring.c:7531 [inline]
>     [<ffffffff816761c3>] io_submit_sqe fs/io_uring.c:7736 [inline]
>     [<ffffffff816761c3>] io_submit_sqes+0x553/0x3030 fs/io_uring.c:7842
>     [<ffffffff81679390>] __do_sys_io_uring_enter+0x6f0/0x1100 fs/io_uring.c:10780
>     [<ffffffff8451ca25>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>     [<ffffffff8451ca25>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>     [<ffffffff84600068>] entry_SYSCALL_64_after_hwframe+0x44/0xae


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 659f8ecba5b7..d4feb5ca63ba 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3825,8 +3825,10 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		iovec = NULL;
 	}
 	ret = io_rw_init_file(req, FMODE_READ);
-	if (unlikely(ret))
+	if (unlikely(ret)) {
+		kfree(iovec);
 		return ret;
+	}
 	req->result = iov_iter_count(&s->iter);
 
 	if (force_nonblock) {
@@ -3951,8 +3953,10 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 		iovec = NULL;
 	}
 	ret = io_rw_init_file(req, FMODE_WRITE);
-	if (unlikely(ret))
+	if (unlikely(ret)) {
+		kfree(iovec);
 		return ret;
+	}
 	req->result = iov_iter_count(&s->iter);
 
 	if (force_nonblock) {

-- 
Jens Axboe

