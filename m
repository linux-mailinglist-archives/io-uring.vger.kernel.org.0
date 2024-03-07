Return-Path: <io-uring+bounces-858-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BB407875862
	for <lists+io-uring@lfdr.de>; Thu,  7 Mar 2024 21:31:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2A39EB21F07
	for <lists+io-uring@lfdr.de>; Thu,  7 Mar 2024 20:31:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 782F65DF27;
	Thu,  7 Mar 2024 20:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="urmOzs3j"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91DA7250F8
	for <io-uring@vger.kernel.org>; Thu,  7 Mar 2024 20:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709843483; cv=none; b=GFnBdvl5IEXJWj7IEcjNSxyS6VSka6DS8WL/g+uvP10sK97vNYfubyr+DUueE7fLeICMItWBtoWoKcLKL+pGtSnqW/JZY1dtcVUZlQCp3Hl5UooVHbEc13JTlaRAIWLJ+WNmRKuc0Cdm7K58JTYhdVvy1floiikW3SYBeMHkL4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709843483; c=relaxed/simple;
	bh=2+RPus01m4Xw6sTEhw8vNksYC2MghJDb7pcAejpJNUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n4R55EPOr4C106Z2OAiKLQusolJ87cyi2xBCwVgSz1jjdH/sZ8fsCDo/1xk4ytdAsWu9YKXbjggUx7PPnvVJ75G0p5vL2u3p2xuBeP9kzDvRqFFoT5KC7p+4WEcGnxwlVPSkZdS3DaJ2XgbB/oZDE/XPERC6W2nIJziMucDyTRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=urmOzs3j; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-7c495be1924so20176139f.1
        for <io-uring@vger.kernel.org>; Thu, 07 Mar 2024 12:31:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709843479; x=1710448279; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SnMcoyCrC2eEkuIEAAmWnSMiZWHvwaAKzGPEpmxj7Mc=;
        b=urmOzs3j1NC0ZFOUVMm7CMCUVJrU4Uy+d8TJ/n/a/8IYnDxZ6+wENnG0lkdtvD5KjW
         JD4nSgsLX4VW7jlq4C2HpelBzRllYO16Qr+iBXqKIMxFv51c+r8PzhPUMb47edHNr+Sb
         WqEarWVCZOUcpyazxiNt1p3vtlyLLIHXXDR/TYS+Pz2RjCJXv0tc22uXNFxU1g3maDsc
         lTNWNuV5otIUckv8j6dFhCWQFV7YQTIXeZe3ZWXPzEzsvZBFjSbPDljhphg8O/RRcqrk
         82qYoM5ynfdp1E2UVhyFu4ip6nOHu87h0QNS0S9UVx64jvjCiELj1ieZwpbAW93AMv3Z
         igAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709843479; x=1710448279;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SnMcoyCrC2eEkuIEAAmWnSMiZWHvwaAKzGPEpmxj7Mc=;
        b=a+YykBFEUOKQ2eQE4ll/PNtKNgHHS/CPToLDqHWmjikFoR3+mlXEs/yTQ9WBLnGubF
         J3YqmpAL0qpqag7txhTWiaQCc4/9s/KryDPZT5lGpGlUtac8H6MBi0J3RWZsiDprnHZR
         msOrTwWPZue0a02WYFPocJ3r2/M2QK0S1Giw1KvIR37BbZ39DrHJZJWQqEH/59Pw6bVD
         V9ZTXs7Xxp26fROZVBjg1dr/xztLjY0lxl4Dj6MU5sNMF5oHhKhzIT6gBok/b8BVfHok
         KYkvJxRjCXBZfbrOxqMu1sM7LvqvqcqQXSwSbXubMMdK+3ldFVnogyVo/soxFxhrMbGX
         fVWg==
X-Gm-Message-State: AOJu0YyBlEqg+7sGYCnhZ0OECYoL3dBZSOdSX3v4W8AdYhzQtHmz2v3S
	bH25CLI5OKEMleZpnFraf4Vf6eBXsSPbMFuLq1TtrMIOf4EWgcgbQpUwAjvo3Hb5UCoc/e883rV
	2
X-Google-Smtp-Source: AGHT+IFju2+pk1q+U7m1W7ga4Ad0dN1Zyf4JTX6Yk1Z5OOYA0bxwfzdhqguG9xWeCYl2HzztIfnrVg==
X-Received: by 2002:a6b:f20c:0:b0:7c8:8a21:7156 with SMTP id q12-20020a6bf20c000000b007c88a217156mr1918722ioh.2.1709843479260;
        Thu, 07 Mar 2024 12:31:19 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id f1-20020a028481000000b0047469b04c35sm4198921jai.65.2024.03.07.12.31.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Mar 2024 12:31:17 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] io_uring/kbuf: rename REQ_F_PARTIAL_IO to REQ_F_BL_NO_RECYCLE
Date: Thu,  7 Mar 2024 13:30:25 -0700
Message-ID: <20240307203113.575893-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240307203113.575893-1-axboe@kernel.dk>
References: <20240307203113.575893-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We only use the flag for this purpose, so rename it accordingly. This
further prevents various other use cases of it, keeping it clean and
consistent. Then we can also check it in one spot, when it's being
attempted recycled, and remove some dead code in io_kbuf_recycle_ring().

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  6 +++---
 io_uring/kbuf.c                |  9 ---------
 io_uring/kbuf.h                | 20 +++++---------------
 io_uring/net.c                 | 12 ++++++------
 io_uring/rw.c                  |  4 ++--
 5 files changed, 16 insertions(+), 35 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index d8111d64812b..e24893625085 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -470,7 +470,6 @@ enum {
 	REQ_F_SKIP_LINK_CQES_BIT,
 	REQ_F_SINGLE_POLL_BIT,
 	REQ_F_DOUBLE_POLL_BIT,
-	REQ_F_PARTIAL_IO_BIT,
 	REQ_F_APOLL_MULTISHOT_BIT,
 	REQ_F_CLEAR_POLLIN_BIT,
 	REQ_F_HASH_LOCKED_BIT,
@@ -481,6 +480,7 @@ enum {
 	REQ_F_CANCEL_SEQ_BIT,
 	REQ_F_CAN_POLL_BIT,
 	REQ_F_BL_EMPTY_BIT,
+	REQ_F_BL_NO_RECYCLE_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -543,8 +543,6 @@ enum {
 	REQ_F_SINGLE_POLL	= IO_REQ_FLAG(REQ_F_SINGLE_POLL_BIT),
 	/* double poll may active */
 	REQ_F_DOUBLE_POLL	= IO_REQ_FLAG(REQ_F_DOUBLE_POLL_BIT),
-	/* request has already done partial IO */
-	REQ_F_PARTIAL_IO	= IO_REQ_FLAG(REQ_F_PARTIAL_IO_BIT),
 	/* fast poll multishot mode */
 	REQ_F_APOLL_MULTISHOT	= IO_REQ_FLAG(REQ_F_APOLL_MULTISHOT_BIT),
 	/* recvmsg special flag, clear EPOLLIN */
@@ -559,6 +557,8 @@ enum {
 	REQ_F_CAN_POLL		= IO_REQ_FLAG(REQ_F_CAN_POLL_BIT),
 	/* buffer list was empty after selection of buffer */
 	REQ_F_BL_EMPTY		= IO_REQ_FLAG(REQ_F_BL_EMPTY_BIT),
+	/* don't recycle provided buffers for this request */
+	REQ_F_BL_NO_RECYCLE	= IO_REQ_FLAG(REQ_F_BL_NO_RECYCLE_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 3d257ed9031b..9be42bff936b 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -81,15 +81,6 @@ bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags)
 	struct io_buffer_list *bl;
 	struct io_buffer *buf;
 
-	/*
-	 * For legacy provided buffer mode, don't recycle if we already did
-	 * IO to this buffer. For ring-mapped provided buffer mode, we should
-	 * increment ring->head to explicitly monopolize the buffer to avoid
-	 * multiple use.
-	 */
-	if (req->flags & REQ_F_PARTIAL_IO)
-		return false;
-
 	io_ring_submit_lock(ctx, issue_flags);
 
 	buf = req->kbuf;
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index f74c910b83f4..5218bfd79e87 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -73,21 +73,9 @@ static inline bool io_kbuf_recycle_ring(struct io_kiocb *req)
 	 * to monopolize the buffer.
 	 */
 	if (req->buf_list) {
-		if (req->flags & REQ_F_PARTIAL_IO) {
-			/*
-			 * If we end up here, then the io_uring_lock has
-			 * been kept held since we retrieved the buffer.
-			 * For the io-wq case, we already cleared
-			 * req->buf_list when the buffer was retrieved,
-			 * hence it cannot be set here for that case.
-			 */
-			req->buf_list->head++;
-			req->buf_list = NULL;
-		} else {
-			req->buf_index = req->buf_list->bgid;
-			req->flags &= ~REQ_F_BUFFER_RING;
-			return true;
-		}
+		req->buf_index = req->buf_list->bgid;
+		req->flags &= ~REQ_F_BUFFER_RING;
+		return true;
 	}
 	return false;
 }
@@ -101,6 +89,8 @@ static inline bool io_do_buffer_select(struct io_kiocb *req)
 
 static inline bool io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
 {
+	if (req->flags & REQ_F_BL_NO_RECYCLE)
+		return false;
 	if (req->flags & REQ_F_BUFFER_SELECTED)
 		return io_kbuf_recycle_legacy(req, issue_flags);
 	if (req->flags & REQ_F_BUFFER_RING)
diff --git a/io_uring/net.c b/io_uring/net.c
index eacbe9295a7f..f8495f6a0bda 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -456,7 +456,7 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 			kmsg->msg.msg_controllen = 0;
 			kmsg->msg.msg_control = NULL;
 			sr->done_io += ret;
-			req->flags |= REQ_F_PARTIAL_IO;
+			req->flags |= REQ_F_BL_NO_RECYCLE;
 			return io_setup_async_msg(req, kmsg, issue_flags);
 		}
 		if (ret == -ERESTARTSYS)
@@ -535,7 +535,7 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 			sr->len -= ret;
 			sr->buf += ret;
 			sr->done_io += ret;
-			req->flags |= REQ_F_PARTIAL_IO;
+			req->flags |= REQ_F_BL_NO_RECYCLE;
 			return io_setup_async_addr(req, &__address, issue_flags);
 		}
 		if (ret == -ERESTARTSYS)
@@ -907,7 +907,7 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 		}
 		if (ret > 0 && io_net_retry(sock, flags)) {
 			sr->done_io += ret;
-			req->flags |= REQ_F_PARTIAL_IO;
+			req->flags |= REQ_F_BL_NO_RECYCLE;
 			return io_setup_async_msg(req, kmsg, issue_flags);
 		}
 		if (ret == -ERESTARTSYS)
@@ -1006,7 +1006,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 			sr->len -= ret;
 			sr->buf += ret;
 			sr->done_io += ret;
-			req->flags |= REQ_F_PARTIAL_IO;
+			req->flags |= REQ_F_BL_NO_RECYCLE;
 			return -EAGAIN;
 		}
 		if (ret == -ERESTARTSYS)
@@ -1249,7 +1249,7 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 			zc->len -= ret;
 			zc->buf += ret;
 			zc->done_io += ret;
-			req->flags |= REQ_F_PARTIAL_IO;
+			req->flags |= REQ_F_BL_NO_RECYCLE;
 			return io_setup_async_addr(req, &__address, issue_flags);
 		}
 		if (ret == -ERESTARTSYS)
@@ -1319,7 +1319,7 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 
 		if (ret > 0 && io_net_retry(sock, flags)) {
 			sr->done_io += ret;
-			req->flags |= REQ_F_PARTIAL_IO;
+			req->flags |= REQ_F_BL_NO_RECYCLE;
 			return io_setup_async_msg(req, kmsg, issue_flags);
 		}
 		if (ret == -ERESTARTSYS)
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 7733449271f2..5651a5ad4e11 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -275,7 +275,7 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 			 * current cycle.
 			 */
 			io_req_io_end(req);
-			req->flags |= REQ_F_REISSUE | REQ_F_PARTIAL_IO;
+			req->flags |= REQ_F_REISSUE | REQ_F_BL_NO_RECYCLE;
 			return true;
 		}
 		req_set_fail(req);
@@ -342,7 +342,7 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res)
 		io_req_end_write(req);
 	if (unlikely(res != req->cqe.res)) {
 		if (res == -EAGAIN && io_rw_should_reissue(req)) {
-			req->flags |= REQ_F_REISSUE | REQ_F_PARTIAL_IO;
+			req->flags |= REQ_F_REISSUE | REQ_F_BL_NO_RECYCLE;
 			return;
 		}
 		req->cqe.res = res;
-- 
2.43.0


