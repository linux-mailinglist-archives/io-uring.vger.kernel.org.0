Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 294A842F7BD
	for <lists+io-uring@lfdr.de>; Fri, 15 Oct 2021 18:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241135AbhJOQMU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Oct 2021 12:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241137AbhJOQMP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Oct 2021 12:12:15 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39511C061767
        for <io-uring@vger.kernel.org>; Fri, 15 Oct 2021 09:10:09 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id g198-20020a1c20cf000000b0030d60cd7fd6so2756638wmg.0
        for <io-uring@vger.kernel.org>; Fri, 15 Oct 2021 09:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uF84gtAz0m9P5TQwf10BmuUUFMOx1aVa4LjSpnXnbs4=;
        b=DYJVUh6S9Ni0s1eaPzInwuxLkR5JAKGOeTAWQrSzePIwh7nO2ilT64PbGxtPAL9VPA
         Yw5y6rllBQ808ifslU/Ao3nxWSQToj/76cFVmRnkhQx/akyQlHpm4JrzfXewsaW/2Bxc
         62c5CiTmZidXRHA7B8PfQ2XL+78dxmxFyuzpfmx+mTDpxWWLhaPAyEOmgm9doqZwn6HL
         q6XfnRGoslPxqtMjCk65uCYhO3a0N6KHXh8hPQy8cs8xZaePJV8pG+LjOwHKuiGwYw8q
         HaRDBvFPeVRSb5HBlkdoM4b5yGcZ3pU1KOdy5n+qWLDEOiRVzflXCzSTPjZ3Gvhgmjvh
         K5UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uF84gtAz0m9P5TQwf10BmuUUFMOx1aVa4LjSpnXnbs4=;
        b=IfPohLAzx1Rqhg6Wj5KXFFw0okGuWVqOTUn194Ld3yLdHmg1HS4Kn39DoLZGWD1ToC
         ItGitkvS4oCDu4Don4TxSoGwHuN5Mb5JO/lPHAn0YrqAD72aIzz+StwzzVothXe0RN4c
         ull3CIpTvGVdxEe+eN5TWMS/EM+KtH2cEiHprjk2H+YhTkmtRXC+B6UpWNrr3rbhrD9r
         aNnUizG6UpL8uCaYmOfdwhdY3wQihrWQZV06hul0zLsD35LAZ+mBP5NRiZgJEgnc6Jhe
         ZaLXnF3hYjuwBLsahlr148T/aVmUDwAuajQJXRHiZ5PqD5p4jV8sXyUda+F2inXH6gEm
         TnQw==
X-Gm-Message-State: AOAM5320qFTu+7QT/wOuTvmrxTU0Ag8ct6P02RtAuh9r5Invto99MsXk
        3Gbs2P/p8phlpwGZ8/K5GbvsJ7/tAbw=
X-Google-Smtp-Source: ABdhPJxXE16ZBLu5LnYLJQrMcLvBZtilM4nt4Kvbm54C4fQ/kf4Dw7zqKlDhjDLEZKls/vnugV0JOQ==
X-Received: by 2002:a1c:1bce:: with SMTP id b197mr27356443wmb.88.1634314207650;
        Fri, 15 Oct 2021 09:10:07 -0700 (PDT)
Received: from localhost.localdomain ([185.69.145.218])
        by smtp.gmail.com with ESMTPSA id c15sm5282811wrs.19.2021.10.15.09.10.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 09:10:07 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 4/8] io_uring: return iovec from __io_import_iovec
Date:   Fri, 15 Oct 2021 17:09:14 +0100
Message-Id: <6230e9769982f03a8f86fa58df24666088c44d3e.1634314022.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1634314022.git.asml.silence@gmail.com>
References: <cover.1634314022.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We pass iovec** into __io_import_iovec(), which should keep it,
initialise and modify accordingly. It's expensive, return it directly
from __io_import_iovec encoding errors with ERR_PTR if needed.

io_import_iovec keeps the old interface, but it's inline and so
everything is optimised nicely.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 45 +++++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f354f4ae4f8c..a2514d2937c0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3158,23 +3158,25 @@ static ssize_t io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
 	return __io_iov_buffer_select(req, iov, issue_flags);
 }
 
-static int __io_import_iovec(int rw, struct io_kiocb *req, struct iovec **iovec,
-			     struct io_rw_state *s, unsigned int issue_flags)
+static struct iovec *__io_import_iovec(int rw, struct io_kiocb *req,
+				       struct io_rw_state *s,
+				       unsigned int issue_flags)
 {
 	struct iov_iter *iter = &s->iter;
 	u8 opcode = req->opcode;
+	struct iovec *iovec;
 	void __user *buf;
 	size_t sqe_len;
 	ssize_t ret;
 
-	if (opcode == IORING_OP_READ_FIXED || opcode == IORING_OP_WRITE_FIXED) {
-		*iovec = NULL;
-		return io_import_fixed(req, rw, iter);
-	}
+	BUILD_BUG_ON(ERR_PTR(0) != NULL);
+
+	if (opcode == IORING_OP_READ_FIXED || opcode == IORING_OP_WRITE_FIXED)
+		return ERR_PTR(io_import_fixed(req, rw, iter));
 
 	/* buffer index only valid with fixed read/write, or buffer select  */
 	if (unlikely(req->buf_index && !(req->flags & REQ_F_BUFFER_SELECT)))
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
 	buf = u64_to_user_ptr(req->rw.addr);
 	sqe_len = req->rw.len;
@@ -3183,40 +3185,39 @@ static int __io_import_iovec(int rw, struct io_kiocb *req, struct iovec **iovec,
 		if (req->flags & REQ_F_BUFFER_SELECT) {
 			buf = io_rw_buffer_select(req, &sqe_len, issue_flags);
 			if (IS_ERR(buf))
-				return PTR_ERR(buf);
+				return ERR_PTR(PTR_ERR(buf));
 			req->rw.len = sqe_len;
 		}
 
 		ret = import_single_range(rw, buf, sqe_len, s->fast_iov, iter);
-		*iovec = NULL;
-		return ret;
+		return ERR_PTR(ret);
 	}
 
-	*iovec = s->fast_iov;
-
+	iovec = s->fast_iov;
 	if (req->flags & REQ_F_BUFFER_SELECT) {
-		ret = io_iov_buffer_select(req, *iovec, issue_flags);
+		ret = io_iov_buffer_select(req, iovec, issue_flags);
 		if (!ret)
-			iov_iter_init(iter, rw, *iovec, 1, (*iovec)->iov_len);
-		*iovec = NULL;
-		return ret;
+			iov_iter_init(iter, rw, iovec, 1, iovec->iov_len);
+		return ERR_PTR(ret);
 	}
 
-	return __import_iovec(rw, buf, sqe_len, UIO_FASTIOV, iovec, iter,
+	ret = __import_iovec(rw, buf, sqe_len, UIO_FASTIOV, &iovec, iter,
 			      req->ctx->compat);
+	if (unlikely(ret < 0))
+		return ERR_PTR(ret);
+	return iovec;
 }
 
 static inline int io_import_iovec(int rw, struct io_kiocb *req,
 				  struct iovec **iovec, struct io_rw_state *s,
 				  unsigned int issue_flags)
 {
-	int ret;
+	*iovec = __io_import_iovec(rw, req, s, issue_flags);
+	if (unlikely(IS_ERR(*iovec)))
+		return PTR_ERR(*iovec);
 
-	ret = __io_import_iovec(rw, req, iovec, s, issue_flags);
-	if (unlikely(ret < 0))
-		return ret;
 	iov_iter_save_state(&s->iter, &s->iter_state);
-	return ret;
+	return 0;
 }
 
 static inline loff_t *io_kiocb_ppos(struct kiocb *kiocb)
-- 
2.33.0

