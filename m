Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D29022458EB
	for <lists+io-uring@lfdr.de>; Sun, 16 Aug 2020 20:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbgHPSBR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 Aug 2020 14:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726699AbgHPSBK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 Aug 2020 14:01:10 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E99C6C061786
        for <io-uring@vger.kernel.org>; Sun, 16 Aug 2020 11:01:09 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id i92so6977348pje.0
        for <io-uring@vger.kernel.org>; Sun, 16 Aug 2020 11:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=oKfrynH+Hm+mLsoqP6uWcUvSwKOt12FuIjlY+T2+81U=;
        b=G3Ljv1lGk2ogZCs8XEjVkIl7Km8J3c4IreckGq7mpBhon15kqLVlIwEJ1ZrvIX/hp+
         yXD8ggfZX+gaUuZRGky94zRrFlzju6ZpkLoI46HKSb1xsCpEo4GOn2WTCxBqIsuKM13z
         c+BTre72KfyEEsCL/3wcVMLMJrgoMIImaWHgtnsEc1bdpsJrzXqXbkYlMOcSBeShMRG6
         34aoYUVIfTvy6sfFQay1ilEQM0nXtJ9XfawNsVz8GJJKMThcRZm0QS3NgMn4CUrjNSr0
         otN/TarNRuHINEEaGgrWM/dWWs+gaEc2+9GQqVV7+sUjxsDnpp6Psn+2/HZZv4A8QT4c
         tXfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=oKfrynH+Hm+mLsoqP6uWcUvSwKOt12FuIjlY+T2+81U=;
        b=TKYIBPy9KDz93gn/WCFZAWGVtaw8gIM7j8PBLb5G9uLue0NMtDMU5mHQ3oFVAOyHyP
         BUEKLv1E2AzQFO+zMGCMOLR/TYjbImmbwD+1ebgaYFEJ7b4DGa0/F9YdISpM8s8eZPyr
         V0xhLxbm/Rv2jjrdLXyY6c+iL2MyXXkwsLgE6TUGEoH6qlbl90TPNAPMCPlg1/dEp+s+
         5v5F/KgUw+bNZKHAUhcLd2LqoWuqR86TB/27aKUo565qSclGRQRyrLVVaqOqZNbOhwDg
         uIsGftvr1SE8WFnAgImLJRcRgb80aBST67cy8YiRD6op3GnRsrZRcWin42MwXJpW7Um/
         diEA==
X-Gm-Message-State: AOAM530sKo+lHvLiVKopz65WWmN5EPkr2v0sPHSwye5YcSBjyrpaDrj+
        OFewfMArLOqycJ9r8D5y6/CMcWqiEXSKFA==
X-Google-Smtp-Source: ABdhPJzsbqY9w9U/+v8slF8s2y22J86LGTj/H/y+LUw0qpv3RWFj1ofCVlnxJ2UE2aourtlCXib2Ig==
X-Received: by 2002:a17:90b:4a4e:: with SMTP id lb14mr9718806pjb.228.1597600868800;
        Sun, 16 Aug 2020 11:01:08 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:80d9:87c:7a0f:8256? ([2605:e000:100e:8c61:80d9:87c:7a0f:8256])
        by smtp.gmail.com with ESMTPSA id r15sm16912942pfq.189.2020.08.16.11.01.07
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Aug 2020 11:01:08 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: get rid of kiocb_wait_page_queue_init()
Message-ID: <9112b60f-c2ac-b40d-bb26-743fdc4fd434@kernel.dk>
Date:   Sun, 16 Aug 2020 11:01:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The 5.9 merge moved this function io_uring, which means that we don't
need to retain the generic nature of it. Clean up this part by removing
redundant checks, and just inlining the small remainder in
io_rw_should_retry().

No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 346a3eb84785..4b102d9ad846 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3074,27 +3074,6 @@ static int io_async_buf_func(struct wait_queue_entry *wait, unsigned mode,
 	return 1;
 }
 
-static inline int kiocb_wait_page_queue_init(struct kiocb *kiocb,
-					     struct wait_page_queue *wait,
-					     wait_queue_func_t func,
-					     void *data)
-{
-	/* Can't support async wakeup with polled IO */
-	if (kiocb->ki_flags & IOCB_HIPRI)
-		return -EINVAL;
-	if (kiocb->ki_filp->f_mode & FMODE_BUF_RASYNC) {
-		wait->wait.func = func;
-		wait->wait.private = data;
-		wait->wait.flags = 0;
-		INIT_LIST_HEAD(&wait->wait.entry);
-		kiocb->ki_flags |= IOCB_WAITQ;
-		kiocb->ki_waitq = wait;
-		return 0;
-	}
-
-	return -EOPNOTSUPP;
-}
-
 /*
  * This controls whether a given IO request should be armed for async page
  * based retry. If we return false here, the request is handed to the async
@@ -3109,16 +3088,17 @@ static inline int kiocb_wait_page_queue_init(struct kiocb *kiocb,
  */
 static bool io_rw_should_retry(struct io_kiocb *req)
 {
+	struct wait_page_queue *wait = &req->io->rw.wpq;
 	struct kiocb *kiocb = &req->rw.kiocb;
-	int ret;
 
 	/* never retry for NOWAIT, we just complete with -EAGAIN */
 	if (req->flags & REQ_F_NOWAIT)
 		return false;
 
 	/* Only for buffered IO */
-	if (kiocb->ki_flags & IOCB_DIRECT)
+	if (kiocb->ki_flags & (IOCB_DIRECT | IOCB_HIPRI))
 		return false;
+
 	/*
 	 * just use poll if we can, and don't attempt if the fs doesn't
 	 * support callback based unlocks
@@ -3126,14 +3106,15 @@ static bool io_rw_should_retry(struct io_kiocb *req)
 	if (file_can_poll(req->file) || !(req->file->f_mode & FMODE_BUF_RASYNC))
 		return false;
 
-	ret = kiocb_wait_page_queue_init(kiocb, &req->io->rw.wpq,
-						io_async_buf_func, req);
-	if (!ret) {
-		io_get_req_task(req);
-		return true;
-	}
+	wait->wait.func = io_async_buf_func;
+	wait->wait.private = req;
+	wait->wait.flags = 0;
+	INIT_LIST_HEAD(&wait->wait.entry);
+	kiocb->ki_flags |= IOCB_WAITQ;
+	kiocb->ki_waitq = wait;
 
-	return false;
+	io_get_req_task(req);
+	return true;
 }
 
 static int io_iter_do_read(struct io_kiocb *req, struct iov_iter *iter)

-- 
Jens Axboe

