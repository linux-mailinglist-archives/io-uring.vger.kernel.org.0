Return-Path: <io-uring+bounces-5147-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B9AB9DE7B6
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 14:34:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9ED48164637
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 13:34:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0D9819E97F;
	Fri, 29 Nov 2024 13:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E3/8JUh2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D428519CC27
	for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 13:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732887252; cv=none; b=LKltf+dbTs3P8xruLdAShjK5MRd3rXTjG4EK5SKHhQTG2Q04K5OYMxx9otoAaqPxaGArCkDWcz2LUf/DzcyS1u3FdGWF9iH0quGovAs8+giG0FUFL/UkUpc+CX+J6bykZz+yo+RIOwgQE01DcF48hX0paQOrdUmqXpC17AK25ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732887252; c=relaxed/simple;
	bh=RUAORC0z2zGFT8COGi88os5W9yBRTJewsClQX5h78kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QxNeghuxpwHZ1upUJ+jUQ1+I5MNT2EXlXIUCoE3y+S+d/qTcqCeRHwvX8YTayWOWiY0PSWjPmngNE7ZrR9/BynRFsLb3M848UX7C7xWUJFIDxdsPcTE7i+bC73JxVEdbe6DQHGCQxEXGjlZMdxV6BUXnjRmEYStU0OJmsQKZMkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E3/8JUh2; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-aa53a971480so251455666b.1
        for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 05:34:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732887249; x=1733492049; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u4UMJAzKdYLVQw7XV+oSOHtwiytjSC+QvOsVrzAustw=;
        b=E3/8JUh2+kegIPZZ8/TS9QktQ6m2lWUmFdyo+VksXWlpxgrBc+aVgn1tpFAjeeKBPr
         as57PdRJVTtwWODBsfx1lUnylvre0uXx41C7s/C1R4DUklQgz9giU4PntNkbPphrvabD
         3h1sq2/RGa0oBDEatr4dBSGDG6SZmDa/cdviWs/ch4f+r9AGoHLnxv7kRxZmWY01ErtY
         14ZJS9kL3Y4fm/yr0FgQuB8vv/fENkTlt4pFOLcTdTTk//fDU2yHyrOj9jm72qd+35BP
         T47b/i6YJGbYKFE912zrLBcTDLMFt+fZ/ypzOzA1TrnIap8c3NlYARje0mF18hYDSzsx
         ux0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732887249; x=1733492049;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u4UMJAzKdYLVQw7XV+oSOHtwiytjSC+QvOsVrzAustw=;
        b=Hr/JX4FgQKlZrONNVcoQNJ1oL6IS27vToszhgOja2VGBO6rkGhXbS1Ajx+EE6+U2mi
         o/qnch5hSvjqlxno9V55QtJNR38lij03mmCC67xiAS2yBrggerNE+gYLfdaSJ+uvxdcZ
         4H4fBLn7SOaKIFF6zK8yn8P5kB+7Dhr6dMwovUUl3lv1Y7kZ1edca2+U8vpEE9iNvMBS
         1VoFazq32ump+UPSBVmrA7tBBqwmD9JhoCCNf4fxzKiIAUJxxtqO1BtwSvTjZkhF+g6r
         dt7AuUvH8A3LPljUMjLci9uZpvogcnBLoGvsLP+isfAZ5GB+5lUizeKXjXMNpskLHIjJ
         Evyw==
X-Gm-Message-State: AOJu0YxK42mxBAn45KGX2CX4IUPmQuTCyH3wDUZjqKmmgk0/xR71OR1N
	yrlMkhlPqsL6b9ixQ0NUHuJZGHMns5KL2AelygF9bk1nBPJ7LEt5xE89PQ==
X-Gm-Gg: ASbGncs2Zglvr6cztQKSXx5vYBYqdMm1lMWn+9rb4VIhyMD223cYuxhItX42Iju34m5
	Dq4yHUvry6U2As1+NNbmP3KUp+njGcfJE8jvRQFFZ3UL+BujlE/IYQHKfqbjEjHDexZyHN1JVdI
	hem84RBKeXQ8jd3Gw0ugqM4w0586BrNFa++ON8FX/a5au5EOP22oKTB0fb/ojvLiytPh/PPWeDk
	K32kdEcmEdG71Nu0rZ/34kW/lSyrUXHdld1tPMHSpuCBUnRVw1dVIdEt+h76lMh
X-Google-Smtp-Source: AGHT+IFVbbe6bZpLwZbx4Ki6eBspXglMQYh7Ks1e2jhMfk/HvTXGl2BFtxU8TZ2R9ifueiyUi1q5Yw==
X-Received: by 2002:a17:906:31cc:b0:a9a:bbcc:508c with SMTP id a640c23a62f3a-aa580ef2b02mr829547866b.2.1732887248786;
        Fri, 29 Nov 2024 05:34:08 -0800 (PST)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa5996c2471sm173996866b.13.2024.11.29.05.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2024 05:34:08 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 16/18] io_uring/kbuf: remove pbuf ring refcounting
Date: Fri, 29 Nov 2024 13:34:37 +0000
Message-ID: <4a9cc54bf0077bb2bf2f3daf917549ddd41080da.1732886067.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1732886067.git.asml.silence@gmail.com>
References: <cover.1732886067.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

struct io_buffer_list refcounting was needed for RCU based sync with
mmap, now  we can kill it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/kbuf.c   | 21 +++++++--------------
 io_uring/kbuf.h   |  3 ---
 io_uring/memmap.c |  1 -
 3 files changed, 7 insertions(+), 18 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 662e928cc3b0..644f61445ec9 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -48,7 +48,6 @@ static int io_buffer_add_list(struct io_ring_ctx *ctx,
 	 * always under the ->uring_lock, but lookups from mmap do.
 	 */
 	bl->bgid = bgid;
-	atomic_set(&bl->refs, 1);
 	guard(mutex)(&ctx->mmap_lock);
 	return xa_err(xa_store(&ctx->io_bl_xa, bgid, bl, GFP_KERNEL));
 }
@@ -385,12 +384,10 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx,
 	return i;
 }
 
-void io_put_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl)
+static void io_put_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl)
 {
-	if (atomic_dec_and_test(&bl->refs)) {
-		__io_remove_buffers(ctx, bl, -1U);
-		kfree(bl);
-	}
+	__io_remove_buffers(ctx, bl, -1U);
+	kfree(bl);
 }
 
 void io_destroy_buffers(struct io_ring_ctx *ctx)
@@ -804,10 +801,8 @@ struct io_buffer_list *io_pbuf_get_bl(struct io_ring_ctx *ctx,
 
 	bl = xa_load(&ctx->io_bl_xa, bgid);
 	/* must be a mmap'able buffer ring and have pages */
-	if (bl && bl->flags & IOBL_MMAP) {
-		if (atomic_inc_not_zero(&bl->refs))
-			return bl;
-	}
+	if (bl && bl->flags & IOBL_MMAP)
+		return bl;
 
 	return ERR_PTR(-EINVAL);
 }
@@ -817,7 +812,7 @@ int io_pbuf_mmap(struct file *file, struct vm_area_struct *vma)
 	struct io_ring_ctx *ctx = file->private_data;
 	loff_t pgoff = vma->vm_pgoff << PAGE_SHIFT;
 	struct io_buffer_list *bl;
-	int bgid, ret;
+	int bgid;
 
 	lockdep_assert_held(&ctx->mmap_lock);
 
@@ -826,7 +821,5 @@ int io_pbuf_mmap(struct file *file, struct vm_area_struct *vma)
 	if (IS_ERR(bl))
 		return PTR_ERR(bl);
 
-	ret = io_uring_mmap_pages(ctx, vma, bl->buf_pages, bl->buf_nr_pages);
-	io_put_bl(ctx, bl);
-	return ret;
+	return io_uring_mmap_pages(ctx, vma, bl->buf_pages, bl->buf_nr_pages);
 }
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index d5e4afcbfbb3..dff7444026a6 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -35,8 +35,6 @@ struct io_buffer_list {
 	__u16 mask;
 
 	__u16 flags;
-
-	atomic_t refs;
 };
 
 struct io_buffer {
@@ -83,7 +81,6 @@ void __io_put_kbuf(struct io_kiocb *req, int len, unsigned issue_flags);
 
 bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags);
 
-void io_put_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl);
 struct io_buffer_list *io_pbuf_get_bl(struct io_ring_ctx *ctx,
 				      unsigned long bgid);
 int io_pbuf_mmap(struct file *file, struct vm_area_struct *vma);
diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 668b1c3579a2..73b73f4ea1bd 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -383,7 +383,6 @@ static void *io_uring_validate_mmap_request(struct file *file, loff_t pgoff,
 		if (IS_ERR(bl))
 			return bl;
 		ptr = bl->buf_ring;
-		io_put_bl(ctx, bl);
 		return ptr;
 		}
 	case IORING_MAP_OFF_PARAM_REGION:
-- 
2.47.1


