Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E51218D61F
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2020 18:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgCTRnJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Mar 2020 13:43:09 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39344 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727041AbgCTRnI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Mar 2020 13:43:08 -0400
Received: by mail-pg1-f195.google.com with SMTP id b22so3445691pgb.6
        for <io-uring@vger.kernel.org>; Fri, 20 Mar 2020 10:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=X8r1aBrMESUOXYJR8iYH/tmDDJBg+vBwW37QGmvrF3U=;
        b=kabsfx/NH02W+9UwF8vGbugLGF58w1USiVsJkZI9I0IDnn+sU/E/KIpPXSPYH86jMU
         g1A9LWSFF2UrfZ7VEz1cmXu1USmxDOhPU/JGiNvZvgBlPVbBp9pOhFWdsnAU3eDdhjnj
         UjVnLSTNxvKESzH9+ymCAxD7qfJwN+ugtysu7ceKope5/SsLgXcAcFWzR3Sp2QgWcvKZ
         MHSII5OPoaKVkqIWTs2vN+I2H8PbNzEXPmJPclwcSv6Larg0MnPkBFSUdUY7KE+jMCle
         hqTprkS1NotM7tCil4Dm1deJ1HbiYksh3s5WoI1hypqryJZoGCdtPfhJ1qJjfiTW7YNR
         Melw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=X8r1aBrMESUOXYJR8iYH/tmDDJBg+vBwW37QGmvrF3U=;
        b=tnytrc/z+BgIJtcXLDysVdcFRZObJPZtpvIVhCO8DtnovZ+G5XOW31qHomJZaTF6jy
         W148mOdtA7rMNAgY8D8SOfhQ3H46CTCa5f0W7Qk/CPCnMwVOqpJ1nJK7QXooLQnnKMdI
         ElZiRRnxzoOZKUJw/pTv9Krc3Apjo6d1mqMwDXnBcDTxjv2AH5bh53jUgyZEKn19JwIu
         2EfPTPZADKNB5vFXqM5d9UZVsdsKchvpH7bCwWNaXaitKvRP8P7mtyvNahH2Tvoci/vc
         wAXfRHuoruD8UBBLShfyWKZSeM0PNmhvgmDfQsELlzU5jG5pbg/NcUuSy6FrOppQDoNS
         m2Eg==
X-Gm-Message-State: ANhLgQ3nVv8505N6HNUc+tWVkkcldOxZPxvELVLxRGSs0T0jx0fm9ElB
        bUGvxO8p32sNzDlru/GvbK7MTSaAlNDLKQ==
X-Google-Smtp-Source: ADFU+vuW6l0tPYp7ekYy7h00L94XlqBpxiXlRtneHP5/iCnaHJVfzFPPAtDPJuQTvRcCYBPUiRdCOQ==
X-Received: by 2002:a63:1547:: with SMTP id 7mr9454622pgv.353.1584726186555;
        Fri, 20 Mar 2020 10:43:06 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id 18sm6041555pfj.140.2020.03.20.10.43.04
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Mar 2020 10:43:05 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2] io_uring: honor original task RLIMIT_FSIZE
Message-ID: <7f5763b0-0141-8aae-016d-58f441178d78@kernel.dk>
Date:   Fri, 20 Mar 2020 11:43:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

With the previous fixes for number of files open checking, I added some
debug code to see if we had other spots where we're checking rlimit()
against the async io-wq workers. The only one I found was file size
checking, which we should also honor.

During write and fallocate prep, store the max file size and override
that for the current ask if we're in io-wq worker context.

Cc: stable@vger.kernel.org # 5.1+
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Changes:
- Ran a test and noticed I forgot fallocate. This one adds fallocate
  RLIMIT_FSIZE handling, too.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index dfe40bf80adc..05260ed485ad 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -604,7 +604,10 @@ struct io_kiocb {
 	struct list_head	list;
 	unsigned int		flags;
 	refcount_t		refs;
-	struct task_struct	*task;
+	union {
+		struct task_struct	*task;
+		unsigned long		fsize;
+	};
 	u64			user_data;
 	u32			result;
 	u32			sequence;
@@ -2593,6 +2596,8 @@ static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (unlikely(!(req->file->f_mode & FMODE_WRITE)))
 		return -EBADF;
 
+	req->fsize = rlimit(RLIMIT_FSIZE);
+
 	/* either don't need iovec imported or already have it */
 	if (!req->io || req->flags & REQ_F_NEED_CLEANUP)
 		return 0;
@@ -2662,10 +2667,17 @@ static int io_write(struct io_kiocb *req, bool force_nonblock)
 		}
 		kiocb->ki_flags |= IOCB_WRITE;
 
+		if (!force_nonblock)
+			current->signal->rlim[RLIMIT_FSIZE].rlim_cur = req->fsize;
+
 		if (req->file->f_op->write_iter)
 			ret2 = call_write_iter(req->file, kiocb, &iter);
 		else
 			ret2 = loop_rw_iter(WRITE, req->file, kiocb, &iter);
+
+		if (!force_nonblock)
+			current->signal->rlim[RLIMIT_FSIZE].rlim_cur = RLIM_INFINITY;
+
 		/*
 		 * Raw bdev writes will -EOPNOTSUPP for IOCB_NOWAIT. Just
 		 * retry them without IOCB_NOWAIT.
@@ -2848,8 +2860,10 @@ static void __io_fallocate(struct io_kiocb *req)
 {
 	int ret;
 
+	current->signal->rlim[RLIMIT_FSIZE].rlim_cur = req->fsize;
 	ret = vfs_fallocate(req->file, req->sync.mode, req->sync.off,
 				req->sync.len);
+	current->signal->rlim[RLIMIT_FSIZE].rlim_cur = RLIM_INFINITY;
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
@@ -2875,6 +2889,7 @@ static int io_fallocate_prep(struct io_kiocb *req,
 	req->sync.off = READ_ONCE(sqe->off);
 	req->sync.len = READ_ONCE(sqe->addr);
 	req->sync.mode = READ_ONCE(sqe->len);
+	req->fsize = rlimit(RLIMIT_FSIZE);
 	return 0;
 }
 
-- 
Jens Axboe

