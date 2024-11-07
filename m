Return-Path: <io-uring+bounces-4528-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E4ECD9C032E
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 12:02:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7442B1F23539
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 11:02:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B2AA1EF958;
	Thu,  7 Nov 2024 11:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jcb1uQpD"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB991DFE2F
	for <io-uring@vger.kernel.org>; Thu,  7 Nov 2024 11:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730977352; cv=none; b=BXu7EeGeLkg3yJK5Ie4Pdux74EJOow6Jh/A5clkbAiMHEPnq1AHqYLNrfhxpJlClYi+8rugWR1/AzhJUpHgbYEbJGccUOqbafnPJSLw4I8qkwueh6PKpY19CDDzGApnl00dNflbO4oaRbZsoqXftq4Ipe2z+R4H/u5FbVbV6+vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730977352; c=relaxed/simple;
	bh=4F/eQLyt7fZU/1nE3xYwdURyTRkBywW2ceBXmGIM698=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZbpMdJOu9K3J0g584JgtcGAgVE0qthBYMYb8gvY6pbB9v9LZTSVNR14yYl7UNRb44iQb9NTjR+ypYi8sBNjKLXi90vqPSevk+wjNTPR2C8kbNIglGy6Jdeu6Vk7kDEIhKgd7z3/d4vlZRVOZ2b3/aUTTtE+oGLF1zp1zcFIXBSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jcb1uQpD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730977349;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i0iUgUH84D+XrrmkG/wx4I+A+vYyGBAwJCNYHpW9PhY=;
	b=Jcb1uQpDtKiezbbileb+HGsBl/wSVcKvwlnM/TlNEsl+OT94tx6khFhvB93FKAv58xwaSm
	LnPtBomRrJtlMFKDUG+TgZjVvpAuljb8Re5wUcIrgoXpuykPvPEOKhBAexBz1ylvfRxPxi
	VQsNRX4ZwLkSjM/CvbTOda5JIRui6dg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-347-dqsWXi6DNDyuaoYjwVOwGA-1; Thu,
 07 Nov 2024 06:02:26 -0500
X-MC-Unique: dqsWXi6DNDyuaoYjwVOwGA-1
X-Mimecast-MFC-AGG-ID: dqsWXi6DNDyuaoYjwVOwGA
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4839B195608B;
	Thu,  7 Nov 2024 11:02:25 +0000 (UTC)
Received: from localhost (unknown [10.72.116.54])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E50EB195E480;
	Thu,  7 Nov 2024 11:02:23 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org,
	Uday Shankar <ushankar@purestorage.com>,
	Akilesh Kailash <akailash@google.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V10 06/12] io_uring: rename io_mapped_buf->ubuf as io_mapped_buf->addr
Date: Thu,  7 Nov 2024 19:01:39 +0800
Message-ID: <20241107110149.890530-7-ming.lei@redhat.com>
In-Reply-To: <20241107110149.890530-1-ming.lei@redhat.com>
References: <20241107110149.890530-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

->addr of `io_mapped_buf` stores the start address of userspace fixed
buffer. `io_mapped_buf` will be extended for covering kernel buffer,
so rename ->ubuf as ->addr.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/fdinfo.c | 2 +-
 io_uring/rsrc.c   | 6 +++---
 io_uring/rsrc.h   | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 9ca95f877312..1fd05e78ce15 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -223,7 +223,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
 		if (ctx->buf_table.nodes[i])
 			buf = ctx->buf_table.nodes[i]->buf;
 		if (buf)
-			seq_printf(m, "%5u: 0x%llx/%u\n", i, buf->ubuf, buf->len);
+			seq_printf(m, "%5u: 0x%llx/%u\n", i, buf->addr, buf->len);
 		else
 			seq_printf(m, "%5u: <none>\n", i);
 	}
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index a4a553bbbbfa..f57c4d295f09 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -765,7 +765,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 
 	size = iov->iov_len;
 	/* store original address for later verification */
-	imu->ubuf = (unsigned long) iov->iov_base;
+	imu->addr = (unsigned long) iov->iov_base;
 	imu->len = iov->iov_len;
 	imu->nr_bvecs = nr_pages;
 	imu->folio_shift = PAGE_SHIFT;
@@ -877,14 +877,14 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 	if (unlikely(check_add_overflow(buf_addr, (u64)len, &buf_end)))
 		return -EFAULT;
 	/* not inside the mapped region */
-	if (unlikely(buf_addr < imu->ubuf || buf_end > (imu->ubuf + imu->len)))
+	if (unlikely(buf_addr < imu->addr || buf_end > (imu->addr + imu->len)))
 		return -EFAULT;
 
 	/*
 	 * Might not be a start of buffer, set size appropriately
 	 * and advance us to the beginning.
 	 */
-	offset = buf_addr - imu->ubuf;
+	offset = buf_addr - imu->addr;
 	iov_iter_bvec(iter, ddir, imu->bvec, imu->nr_bvecs, offset + len);
 
 	if (offset) {
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 0867dc304f4f..c8a4db4721ca 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -29,7 +29,7 @@ struct io_rsrc_node {
 };
 
 struct io_mapped_buf {
-	u64		ubuf;
+	u64		addr;
 	unsigned int	len;
 	unsigned int	nr_bvecs;
 	unsigned int    folio_shift;
-- 
2.47.0


