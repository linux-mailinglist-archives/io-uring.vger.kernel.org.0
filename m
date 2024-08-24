Return-Path: <io-uring+bounces-2942-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D67C95DEBB
	for <lists+io-uring@lfdr.de>; Sat, 24 Aug 2024 17:46:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 987BF1F21AED
	for <lists+io-uring@lfdr.de>; Sat, 24 Aug 2024 15:46:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BA1E36124;
	Sat, 24 Aug 2024 15:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ck0HSYzO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1577729CEB
	for <io-uring@vger.kernel.org>; Sat, 24 Aug 2024 15:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724514365; cv=none; b=ZEa884hjFmArYFrW9EiKNWnzcp1cq24HZjO6WkIOlqJOTWxBIUYhpEce4K6jDb2zqj4dfayH+Uo37mIxNosSBpyzOQd5q9F04whZhkZjOo+NtjeB3gVqj7eJEVJTnvAT/dZwcyfScG+0RKujDgpokS5yCFPVeEWqsfVMRsklvUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724514365; c=relaxed/simple;
	bh=S4vGWTfy4BnpV4s+s0ZfEUKuJbSzm3xvA6tvTUOFk7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oyCptsjj8cZeg2eGUF/VKi6QHxJ0eXZ74bOSscHebvfZ9bvnxUFmCoVuyqtstDs7QZ2nlHIlfS04QFU9dp+7C1xvGOeUEEYefaIM1e+EiCU5SeHP5W96UP7Jgp6+mTDYddYVa+jpEc2gLBr+YJazZp7+8iWfkIFkpZ+hWbQWOC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ck0HSYzO; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-7cf5e179b68so751349a12.1
        for <io-uring@vger.kernel.org>; Sat, 24 Aug 2024 08:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724514362; x=1725119162; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IpXZSAiEflQrGxhh6J+qkCCS28mzL/xqe1qvT/saV5A=;
        b=ck0HSYzOJqfApAtTUsuXgoiemQmpB4do3FT3aL5C5FOf2/ItsfBE4896pibdHhbwgL
         a+oC2J9zb4QdT7dZcyl/aTXzP+3TLBfy1YUafEYNLFzjrGxNFs/vyAOZgVdqtrA71779
         2wpz+Z4s1OS9vxvLjgrhn4shHgvfLUyJFP/hsg2qG4nPQFCYkNGwwp5YEaCfUUx/Djlh
         2YzGVCPp6ePNiBmyi7sEI08AyRf6sczDUcvvupvRBgZoDLKmvm0D25H2Qc7A7SrAYZlN
         LYKW0PM+Ugo3Cke5m9qgiyHfNfdRNyhu4pzzX8sEtdP0A84SGMMAvgcleFJpaRvpR4Hm
         8ECg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724514362; x=1725119162;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IpXZSAiEflQrGxhh6J+qkCCS28mzL/xqe1qvT/saV5A=;
        b=rG4hr4kF7BFlECOUll6Qixh9e/q34dd/Aqa/77E8L/HSN9IcTNfxThwK8ArDy5Oyv+
         NBAug9HO0h5hB03jzahBSQDfJqz+995xslHNnBecZfLI0gl2TrtQVH4mIpArHKJzQIrR
         mAmtvWFPoQfNcpnRFFyNJbh7JoZtuvMfbSzspcPeX20IATGsPL7zyTgNBQ6B2uz8HmcC
         ecFjngnri86gXWcy9CyMRutE7mnBrY2UzaigaQuf+e7rkX8IHU4DMvmy+1jAtsNI5wUF
         WI3qZ8lxOsgIySxz4od4IgtLCZcWEbAOF34gZ95WIS3eREmuohZbzR1sM9QNTFIh08RE
         zbrQ==
X-Gm-Message-State: AOJu0Yyl2NNaB5PAQqJpEy+q7axYLL+o3at69IJ0DCN0Bp2wmGtojHeF
	Cv06NCmuPy9FPRZo21366vL5NwF6E0fHOypDPEXXqUiWv3uCCesMMMw9jRAwDxgq1C/vct/DBOU
	l
X-Google-Smtp-Source: AGHT+IEjbyFVXnWaMUd/1K0fFmwkxAeCKS5/QlcBVqu8sug1kfDs2hzpa5HDkGX1YFjfuxksY4V+mQ==
X-Received: by 2002:a17:90a:d508:b0:2c8:4250:66a7 with SMTP id 98e67ed59e1d1-2d644778207mr9227848a91.1.1724514361803;
        Sat, 24 Aug 2024 08:46:01 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d5eb9049b0sm8596939a91.17.2024.08.24.08.46.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Aug 2024 08:46:00 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] io_uring/kbuf: add io_kbuf_commit() helper
Date: Sat, 24 Aug 2024 09:43:54 -0600
Message-ID: <20240824154555.110170-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240824154555.110170-1-axboe@kernel.dk>
References: <20240824154555.110170-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Committing the selected ring buffer is currently done in three different
spots, combine it into a helper and just call that.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/kbuf.c |  7 +++----
 io_uring/kbuf.h | 14 ++++++++++----
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index a4bde998f50d..c69f69807885 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -171,9 +171,8 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 		 * the transfer completes (or if we get -EAGAIN and must poll of
 		 * retry).
 		 */
-		req->flags &= ~REQ_F_BUFFERS_COMMIT;
+		io_kbuf_commit(req, bl, 1);
 		req->buf_list = NULL;
-		bl->head++;
 	}
 	return u64_to_user_ptr(buf->addr);
 }
@@ -297,8 +296,8 @@ int io_buffers_select(struct io_kiocb *req, struct buf_sel_arg *arg,
 		 * committed them, they cannot be put back in the queue.
 		 */
 		if (ret > 0) {
-			req->flags |= REQ_F_BL_NO_RECYCLE;
-			bl->head += ret;
+			req->flags |= REQ_F_BUFFERS_COMMIT | REQ_F_BL_NO_RECYCLE;
+			io_kbuf_commit(req, bl, ret);
 		}
 	} else {
 		ret = io_provided_buffers_select(req, &arg->out_len, bl, arg->iovs);
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index ab30aa13fb5e..43c7b18244b3 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -121,15 +121,21 @@ static inline bool io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
 	return false;
 }
 
+static inline void io_kbuf_commit(struct io_kiocb *req,
+				  struct io_buffer_list *bl, int nr)
+{
+	if (unlikely(!(req->flags & REQ_F_BUFFERS_COMMIT)))
+		return;
+	bl->head += nr;
+	req->flags &= ~REQ_F_BUFFERS_COMMIT;
+}
+
 static inline void __io_put_kbuf_ring(struct io_kiocb *req, int nr)
 {
 	struct io_buffer_list *bl = req->buf_list;
 
 	if (bl) {
-		if (req->flags & REQ_F_BUFFERS_COMMIT) {
-			bl->head += nr;
-			req->flags &= ~REQ_F_BUFFERS_COMMIT;
-		}
+		io_kbuf_commit(req, bl, nr);
 		req->buf_index = bl->bgid;
 	}
 	req->flags &= ~REQ_F_BUFFER_RING;
-- 
2.43.0


