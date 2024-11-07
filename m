Return-Path: <io-uring+bounces-4529-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DC029C0331
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 12:02:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF3801C20C1C
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 11:02:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 537EE1373;
	Thu,  7 Nov 2024 11:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aMO+2Qwy"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE36B13C682
	for <io-uring@vger.kernel.org>; Thu,  7 Nov 2024 11:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730977357; cv=none; b=r3CuZN6P3zPMMWmCnwA+lrcf1QzKSOGU7Y1ZHLE1UQ/wqkzUezwKZNlKphVThrmJk2+3d68dGKGDZAPkV69yi4QBSdigz850JB66JKr9i/zivh9U1UwPp5SoDfqEN5LemMNnkpKzf4+DexoJ6F5xxo0JH1klgwjIJapVww8KBO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730977357; c=relaxed/simple;
	bh=NQ+bwr1JB4p3kwCzYVnZV2mYuii1jbMOo79wlSQxK5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PoytXZmnsR6PHbNdOJ/A6yd1nJdTE/ll//2xQkXCvdrplZxleZndbIA4Z+uNKxoMJ+g5Cdb7MdufH6LYZQI71/HagZ6IBbsK7rjSt8qwn3o5EGrFCRPCabR3YnLpq12PmrXhCgQGpZ6WK02SPNM+v9yjJLTSz5/9b4da29j8B/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aMO+2Qwy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730977354;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V0VSqFzf1J9PU1pJLz6JPLAs1jAHK7dRkghElujlsZ8=;
	b=aMO+2QwyqX1aKdvo6jCIqxYhyKJGeLuq/MlyAI4zC9yqM1mo5ELdHhERZIYfSn/qtkENJc
	75R0/gqPW1Bilj+LcyUmScsPUBDLTd7dvbfYj1txgre5sIZ24av1t4t3FYu57JO7QQ8tBd
	uFRR4TI+FHN6rpU4DstRbdGA4x2DpfQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-624-3mZzLQx5Op2Hni-UDMWQGQ-1; Thu,
 07 Nov 2024 06:02:31 -0500
X-MC-Unique: 3mZzLQx5Op2Hni-UDMWQGQ-1
X-Mimecast-MFC-AGG-ID: 3mZzLQx5Op2Hni-UDMWQGQ
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D4F3D1956095;
	Thu,  7 Nov 2024 11:02:29 +0000 (UTC)
Received: from localhost (unknown [10.72.116.54])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5D0AE196BC05;
	Thu,  7 Nov 2024 11:02:27 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org,
	Uday Shankar <ushankar@purestorage.com>,
	Akilesh Kailash <akailash@google.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V10 07/12] io_uring: shrink io_mapped_buf
Date: Thu,  7 Nov 2024 19:01:40 +0800
Message-ID: <20241107110149.890530-8-ming.lei@redhat.com>
In-Reply-To: <20241107110149.890530-1-ming.lei@redhat.com>
References: <20241107110149.890530-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

`struct io_mapped_buf` will be extended to cover kernel buffer which
may be in fast IO path, and `struct io_mapped_buf` needs to be per-IO.

So shrink sizeof(struct io_mapped_buf) by the following ways:

- folio_shift is < 64, so 6bits are enough to hold it, the remained bits
  can be used for the coming kernel buffer

- define `acct_pages` as 'unsigned int', which is big enough for
  accounting pages in the buffer

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/rsrc.c | 2 ++
 io_uring/rsrc.h | 6 +++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index f57c4d295f09..99ff2797e6ec 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -685,6 +685,8 @@ static bool io_try_coalesce_buffer(struct page ***pages, int *nr_pages,
 		return false;
 
 	data->folio_shift = folio_shift(folio);
+	WARN_ON_ONCE(data->folio_shift >= 64);
+
 	/*
 	 * Check if pages are contiguous inside a folio, and all folios have
 	 * the same page count except for the head and tail.
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index c8a4db4721ca..bf0824b4beb6 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -32,9 +32,9 @@ struct io_mapped_buf {
 	u64		addr;
 	unsigned int	len;
 	unsigned int	nr_bvecs;
-	unsigned int    folio_shift;
 	refcount_t	refs;
-	unsigned long	acct_pages;
+	unsigned int	acct_pages;
+	unsigned int	folio_shift:6;
 	struct bio_vec	bvec[] __counted_by(nr_bvecs);
 };
 
@@ -43,7 +43,7 @@ struct io_imu_folio_data {
 	unsigned int	nr_pages_head;
 	/* For non-head/tail folios, has to be fully included */
 	unsigned int	nr_pages_mid;
-	unsigned int	folio_shift;
+	unsigned char	folio_shift;
 };
 
 struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx, int type);
-- 
2.47.0


