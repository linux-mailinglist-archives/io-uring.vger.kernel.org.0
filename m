Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEA70296716
	for <lists+io-uring@lfdr.de>; Fri, 23 Oct 2020 00:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S372764AbgJVWYy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Oct 2020 18:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S372761AbgJVWYy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Oct 2020 18:24:54 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3229CC0613CF
        for <io-uring@vger.kernel.org>; Thu, 22 Oct 2020 15:24:54 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id c20so2166517pfr.8
        for <io-uring@vger.kernel.org>; Thu, 22 Oct 2020 15:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R4HF3ZPPmNYAYd78JzkiBYt49AZyQYqCb7Mcda7OhbQ=;
        b=tdgg/AF3hVE0MX6vhOsQqr/4dz6/LMRm3L7ZVIze8v6uFHrZCSkh4P/gv1LWc/Yfoq
         dOOK2CjyMYfdJQ9vzgPtpCH3/t672djzq9C4t8rEy2OW9YC5Ogp6bwfMx9BaFAThJzi0
         QggS8U3qt8toBHCzpn8anxp0SfkcYrc2yX6d7iu6gRo5DcOWFV8/Zs7t5XU5yFc+6lRc
         zOHLUTq8ZrTm8vR0n9lSPDmTNVP1hxKKZ+2eKWPbi0FG5gRbFq1lvg27hmcW/TzBtOQ1
         nW5D07Y53XxldhgOk50OtuzElUaQPZOs1gZEcptTBgPv19kXvTfCVk9zmP6GerCyCS1B
         MnBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R4HF3ZPPmNYAYd78JzkiBYt49AZyQYqCb7Mcda7OhbQ=;
        b=cu4Lumll+J0wwDgN2DhkgF2Xwu9Kd+7buccGE4nikcfmbBmZ0xpTr7mFloIhBROxG1
         P7JQx20hIsGSwRAw6syCS3/cuKCiifPGVEg+56MozcqORFHxcLru9RaGUF8s280i3toN
         YkORkBAiwTlTq37FSysSVSRBCRlcS40lNnOmrNbYHzcsEBrqgJuv909EEahE907xFefn
         rfOY41ZLHs1S5ft/m8ZbcBaSG50PY3mRCRAXMJgeDNNpME6JHVyDACQBtbHHVBVIr8At
         jga52tH+HAVxxRrtiAuxJmB5/UV05px1/70pOoB9r6WdibRfiYCcaScDbqLBKvwpiKad
         YUCw==
X-Gm-Message-State: AOAM530rk9O/QDQuraoEkXEDwbUnbR8AYC+soeJIqPc3GaQZQaOrm0PE
        3MKZaWMIXuJHPPlohthYakCd2hivldHHkg==
X-Google-Smtp-Source: ABdhPJxvyxCM/p4f/EMPz4UOBufoBKfoR8rxh3h87A0hbDie7M5YNDtQOWOvSx2vb7w6qyTd1p2BJg==
X-Received: by 2002:a17:90a:6301:: with SMTP id e1mr4434408pjj.131.1603405493491;
        Thu, 22 Oct 2020 15:24:53 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id e5sm3516437pfl.216.2020.10.22.15.24.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 15:24:53 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] io_uring: make loop_rw_iter() use original user supplied pointers
Date:   Thu, 22 Oct 2020 16:24:46 -0600
Message-Id: <20201022222447.62020-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20201022222447.62020-1-axboe@kernel.dk>
References: <20201022222447.62020-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We jump through a hoop for fixed buffers, where we first map these to
a bvec(), then kmap() the bvec to obtain the pointer we copy to/from.
This was always a bit ugly, and with the set_fs changes, it ends up
being practically problematic as well.

There's no need to jump through these hoops, just use the original user
pointers and length for the non iter based read/write.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 45320458a5f9..70ce36612e12 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3115,9 +3115,10 @@ static inline loff_t *io_kiocb_ppos(struct kiocb *kiocb)
  * For files that don't have ->read_iter() and ->write_iter(), handle them
  * by looping over ->read() or ->write() manually.
  */
-static ssize_t loop_rw_iter(int rw, struct file *file, struct kiocb *kiocb,
-			   struct iov_iter *iter)
+static ssize_t loop_rw_iter(int rw, struct io_kiocb *req, struct iov_iter *iter)
 {
+	struct kiocb *kiocb = &req->rw.kiocb;
+	struct file *file = req->file;
 	ssize_t ret = 0;
 
 	/*
@@ -3137,11 +3138,8 @@ static ssize_t loop_rw_iter(int rw, struct file *file, struct kiocb *kiocb,
 		if (!iov_iter_is_bvec(iter)) {
 			iovec = iov_iter_iovec(iter);
 		} else {
-			/* fixed buffers import bvec */
-			iovec.iov_base = kmap(iter->bvec->bv_page)
-						+ iter->iov_offset;
-			iovec.iov_len = min(iter->count,
-					iter->bvec->bv_len - iter->iov_offset);
+			iovec.iov_base = (void __user *) req->rw.addr;
+			iovec.iov_len = req->rw.len;
 		}
 
 		if (rw == READ) {
@@ -3152,9 +3150,6 @@ static ssize_t loop_rw_iter(int rw, struct file *file, struct kiocb *kiocb,
 					       iovec.iov_len, io_kiocb_ppos(kiocb));
 		}
 
-		if (iov_iter_is_bvec(iter))
-			kunmap(iter->bvec->bv_page);
-
 		if (nr < 0) {
 			if (!ret)
 				ret = nr;
@@ -3163,6 +3158,8 @@ static ssize_t loop_rw_iter(int rw, struct file *file, struct kiocb *kiocb,
 		ret += nr;
 		if (nr != iovec.iov_len)
 			break;
+		req->rw.len -= nr;
+		req->rw.addr += nr;
 		iov_iter_advance(iter, nr);
 	}
 
@@ -3352,7 +3349,7 @@ static int io_iter_do_read(struct io_kiocb *req, struct iov_iter *iter)
 	if (req->file->f_op->read_iter)
 		return call_read_iter(req->file, &req->rw.kiocb, iter);
 	else if (req->file->f_op->read)
-		return loop_rw_iter(READ, req->file, &req->rw.kiocb, iter);
+		return loop_rw_iter(READ, req, iter);
 	else
 		return -EINVAL;
 }
@@ -3543,7 +3540,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 	if (req->file->f_op->write_iter)
 		ret2 = call_write_iter(req->file, kiocb, iter);
 	else if (req->file->f_op->write)
-		ret2 = loop_rw_iter(WRITE, req->file, kiocb, iter);
+		ret2 = loop_rw_iter(WRITE, req, iter);
 	else
 		ret2 = -EINVAL;
 
-- 
2.29.0

