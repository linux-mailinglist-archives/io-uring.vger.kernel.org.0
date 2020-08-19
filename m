Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1087B24A49A
	for <lists+io-uring@lfdr.de>; Wed, 19 Aug 2020 19:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgHSREo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Aug 2020 13:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726209AbgHSREn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Aug 2020 13:04:43 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33848C061757
        for <io-uring@vger.kernel.org>; Wed, 19 Aug 2020 10:04:43 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id a79so11979428pfa.8
        for <io-uring@vger.kernel.org>; Wed, 19 Aug 2020 10:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=nQN/k5knGMlePdrXlCw4LsT0N+8ZfeG+paoz4hTkyuM=;
        b=cnvoqy8perljChEyCE9IuX9CdvpDZCtv0ssmGy4Z35q15DlqkI3aBPm87dZWuc5bA7
         syf3I71l8P+8n3DfTq0cCXO5lIGR7Ls2Gteb0UrlKgK8ySh96csJSRePoRagjJ+X8GtU
         oPWr2U58QiNBX2vdfxeoSlQGjo/DTC8h4nchw5DAzQprdUGkPwoKVt0h/BMvmCne5Tbo
         IjyRM8gfzMZMn2H8Zd154qraZlTyz2QENEPszFRrN+twUGr8pXOxHZlTu+DfpLLiylQ/
         q3BNNLajKP2GOiTk1UH2WfB9c7nJJm7dkumDmnQybxMIcozERZc/u1jqV/4MKR1jJEkM
         yzOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=nQN/k5knGMlePdrXlCw4LsT0N+8ZfeG+paoz4hTkyuM=;
        b=dQC42gte9lWjJrb7UZ/AWT0Nqxb76Rd5DR6dJEgSe+PqXeJKfUd/AU0AJaNS/pEFkj
         qGCed/8FtzhprNwBZ3JaWpJIi9urNPXwubJ9ueql9Ih2SPQTxgPO47qZtVyi8Vrg72/A
         28j8OUARMNYW7BgRp0SkHm5iBSyujW6I2FDB2kmdLc9cEs4YyEaR6ZverxT6kewLlLG5
         dcEnaVthbpwrJ0/TP/68UR/vU0hFjDugPoTwPfk3JAcuWu6e7g0yR7+a9J9DNomTFR2z
         9i3wLoHJT+Tx1NObRUoRnu5giGFEXL5F0jUzLOjWfkqQyTQgkR0OQjjT6eoDNPsypTRL
         6upg==
X-Gm-Message-State: AOAM531skuXU4UyejHbE9PXkj65xXiyR8JeUWFD4S6IRhnPvSGeUahDx
        5//+V/WK2kfQIOjoxHPS6kFps2R0lMqoXDqo
X-Google-Smtp-Source: ABdhPJwf8fv9DjlYo+b1qMiSacNONBHOv5ObHfqnHSOmLA2vJeQt8dvp2J9/1YiOkJ0N9dkHq7QHbg==
X-Received: by 2002:a62:8881:: with SMTP id l123mr19129661pfd.186.1597856682413;
        Wed, 19 Aug 2020 10:04:42 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id m26sm28411186pfe.184.2020.08.19.10.04.41
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Aug 2020 10:04:41 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: cleanup io_import_iovec() of pre-mapped request
Message-ID: <2a954670-3c5c-af5b-c226-417c81c24b6d@kernel.dk>
Date:   Wed, 19 Aug 2020 11:04:40 -0600
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

io_rw_prep_async() goes through a dance of clearing req->io, calling
the iovec import, then re-setting req->io. Provide an internal helper
that does the right thing without needing state tweaked to get there.

This enables further cleanups in io_read, io_write, and
io_resubmit_prep(), but that's left for another time.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4b102d9ad846..e325895d681b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2819,22 +2819,15 @@ static ssize_t io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
 	return __io_iov_buffer_select(req, iov, needs_lock);
 }
 
-static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
-			       struct iovec **iovec, struct iov_iter *iter,
-			       bool needs_lock)
+static ssize_t __io_import_iovec(int rw, struct io_kiocb *req,
+				 struct iovec **iovec, struct iov_iter *iter,
+				 bool needs_lock)
 {
 	void __user *buf = u64_to_user_ptr(req->rw.addr);
 	size_t sqe_len = req->rw.len;
 	ssize_t ret;
 	u8 opcode;
 
-	if (req->io) {
-		struct io_async_rw *iorw = &req->io->rw;
-
-		*iovec = NULL;
-		return iov_iter_count(&iorw->iter);
-	}
-
 	opcode = req->opcode;
 	if (opcode == IORING_OP_READ_FIXED || opcode == IORING_OP_WRITE_FIXED) {
 		*iovec = NULL;
@@ -2879,6 +2872,16 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 	return import_iovec(rw, buf, sqe_len, UIO_FASTIOV, iovec, iter);
 }
 
+static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
+			       struct iovec **iovec, struct iov_iter *iter,
+			       bool needs_lock)
+{
+	if (!req->io)
+		return __io_import_iovec(rw, req, iovec, iter, needs_lock);
+	*iovec = NULL;
+	return iov_iter_count(&req->io->rw.iter);
+}
+
 /*
  * For files that don't have ->read_iter() and ->write_iter(), handle them
  * by looping over ->read() or ->write() manually.
@@ -3001,11 +3004,8 @@ static inline int io_rw_prep_async(struct io_kiocb *req, int rw,
 	ssize_t ret;
 
 	iorw->iter.iov = iorw->fast_iov;
-	/* reset ->io around the iovec import, we don't want to use it */
-	req->io = NULL;
-	ret = io_import_iovec(rw, req, (struct iovec **) &iorw->iter.iov,
+	ret = __io_import_iovec(rw, req, (struct iovec **) &iorw->iter.iov,
 				&iorw->iter, !force_nonblock);
-	req->io = container_of(iorw, struct io_async_ctx, rw);
 	if (unlikely(ret < 0))
 		return ret;
 
-- 
Jens Axboe

