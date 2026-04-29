Return-Path: <io-uring+bounces-13180-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0HgHFD0l8mm/oQEAu9opvQ
	(envelope-from <io-uring+bounces-13180-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2026 17:35:25 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CB848497074
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2026 17:35:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2A20331478BB
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2026 15:27:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24B5E37CD45;
	Wed, 29 Apr 2026 15:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="itq6qZ7P"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580DB38239C
	for <io-uring@vger.kernel.org>; Wed, 29 Apr 2026 15:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777476423; cv=none; b=niuvlFPJ8CmU6UIiIGj1ZigVsYc5lxXPUGDHKF8Gnsni2o40Izw080/NOozX8rZ6l4NCZFJv009oDvZz6wYr4LzhrQJD1HyYs2/3uHgcd1WTpellslDr1f7VG5vfZhAgovHTnzdXmAv7IXJWakSFLcp4QN+tJ2l6w06oNpqcIYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777476423; c=relaxed/simple;
	bh=8Q724PKAeWMa6roOSMmfJBPXkxkRSKnlWqU8HQUxKDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WdPAfzoZkgfmrkywcQ8KT2jiMGbSTqvJcAyBd+WBVKbXGnspPW4GXxSiyqGE1fYDmzQA9nqzAQH9OoBgY6dexApFLo+TRtfN8lA/1lUUnYEsqiCbYEwGh7JZ/2PbW3HRS3fn1soCs9bYjEPObGfnVIbfF7WTfaVy/VtYfFMkEs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=itq6qZ7P; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-43d77f60944so9087132f8f.3
        for <io-uring@vger.kernel.org>; Wed, 29 Apr 2026 08:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777476420; x=1778081220; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Okho95RNKRmNJtlBZrtRfvb3jbBLTZKlsmbr0Q4pBPI=;
        b=itq6qZ7PTBJI54cVGL7/SgM5oWV1agvjlAAOYuZW4kRdal5vy2XeXvfkrJCaMztAQp
         ngePVXhwmcThB6gUEOgDruHlCvQsy15ncOeLhubY/U7i1aWdUk/YrEekg31w/lAJaBbe
         Uf3mjWpRVSn+a/bFdvdIL7x60AjxfTWYjvMUhsl4RpUUXsRMADB91a4ivaSVHAxR3ztv
         /ftx/Z4W7eTDhwSqOYwKWJ6iqn+hx7M2LrFxwH7i4PpeynJmBRuB6m61vgdJI2iJMbnG
         tL9HtOOsVgKQ2r3gjPXx7HyyEHrCs5vBSGF+KEsTXOIxTV82BU87wO3L5A/yXzZnb6CA
         dJoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777476420; x=1778081220;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Okho95RNKRmNJtlBZrtRfvb3jbBLTZKlsmbr0Q4pBPI=;
        b=CQuUrzwoNyE+Lz9Gr7NoUpkYGf3eYWbMtZpfrGS5yzumj5m8ZBDiVTcDBm3qt/P/rY
         u/srDt0z0WkcTfvt/RT2P5TBo7i+nS/EG6SRPQwG1NLn85GSs49IA2ere1LYhpVEJlHe
         VI+pb/KckbNYJNbjBBwYhkeF0vptVMruZnLa0W20Q98yRYsIXsqaw+7rdjKKK1wLgK2u
         1sES36G47rIPdZ4JOFSWDnYGDRbtaQvf+RVv2jRr8UK+l7X2MJeRbURhk9PmEGvm7OEn
         bYdF8QPJImZzXua3+YVfK9TjDzN6SXXXccBdbndAm9ECsHGQbjDvG0aBw1/0e3S5wcv4
         RLrw==
X-Forwarded-Encrypted: i=1; AFNElJ/2Gi2feXU2Sd6aJj4/V4PiHCQYDDa17H6zFrmqU7WLVE4Pd4UtLX7oVpz8OGGQcbLKoxb34kzHbQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/fqVDIaEbfJzxraYkh6lWNb/TEk3pJjolWl94bDqcVvv128Bn
	sB8WlERARwCdoIecI+Oay7vrjHpcHY8IY5Sv7c/vFZlihjRsocwT6S4e
X-Gm-Gg: AeBDiesxTFco6vu6yvwS3I0fzYNkvOAy0jcv2ZFpntjWAOp2W19eScLnrUcT6vFMMwG
	DHa2a9n687K7rskNMpOeXHak/h5JNsSITGsxq2jgHsD6dZfHKDKBcd++AJY1Eja+HrbUgBaVAyT
	mSRihfkyWxqriCF27m8O4LR2NMezrmcJt3x2QjQFyVdhuQPHDrXFywngbch2NorJcAiusM9keEw
	DBwG/BjrAtIU/7DZsJdxwOlhfLKchhZU2KK18nJraheueGzyF3gtEdyLFovbac7VSWjy/1yVWkN
	ptatjEW6REEnEdnNQ7KTxm45uAkHV83wAMQ+y0rW4VrOwyzBQj5sUNN3YNbxhKeK8PE2YcWr3/g
	KC2Y8H+JYXuNMnFBTQ6A1gtbAS2A53HckSMsrmlIoWXAkLfoUJJB87CWn0OnWrA7o6lDnPD3yNu
	U4mgMlGboA6vTID2+uOyjVuBacUrJUw8BD2uHFIrIBoSV30INM8aA7QUUpvHCVJgjMYwD1C1PN5
	cJx5r3KW8oceEwSDfhbNZv9CzbSJTFr1szvRwYztgXf
X-Received: by 2002:a05:6000:1a89:b0:43d:7d6f:f529 with SMTP id ffacd0b85a97d-44790a325e5mr7826316f8f.31.1777476419464;
        Wed, 29 Apr 2026 08:26:59 -0700 (PDT)
Received: from 127.0.0.1localhost ([82.132.184.31])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-447b76e5c22sm6382951f8f.28.2026.04.29.08.26.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 08:26:58 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org
Cc: asml.silence@gmail.com,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Tushar Gohad <tushar.gohad@intel.com>,
	William Power <william.power@intel.com>,
	Phil Cayton <phil.cayton@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v3 08/10] io_uring/rsrc: introduce buf registration structure
Date: Wed, 29 Apr 2026 16:25:54 +0100
Message-ID: <881422d8d613a8370ed98b158d2b57b46bb37230.1777475843.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1777475843.git.asml.silence@gmail.com>
References: <cover.1777475843.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CB848497074
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[25];
	FREEMAIL_CC(0.00)[gmail.com,samsung.com,intel.com,nvidia.com];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13180-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]

In preparation to following changes, instead of passing an iovec for
buffer registration introduce a new structure. It'll be moved to uapi
later, but for now it's initialised early from a user provided iovec.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 50 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 16 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index c4a7a77d1ee9..ba00238941ed 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -27,8 +27,14 @@ struct io_rsrc_update {
 	u32				offset;
 };
 
+struct io_uring_regbuf_desc {
+	__u64 uaddr;
+	__u64 size;
+};
+
 static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
-			struct iovec *iov, struct page **last_hpage);
+					struct io_uring_regbuf_desc *desc,
+					struct page **last_hpage);
 
 /* only define max */
 #define IORING_MAX_FIXED_FILES	(1U << 20)
@@ -36,6 +42,15 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 
 #define IO_CACHED_BVECS_SEGS	32
 
+static void io_iov_to_regbuf_desc(const struct iovec *iov,
+				  struct io_uring_regbuf_desc *desc)
+{
+	*desc = (struct io_uring_regbuf_desc) {
+		.uaddr = (u64)iov->iov_base,
+		.size = iov->iov_len,
+	};
+}
+
 int __io_account_mem(struct user_struct *user, unsigned long nr_pages)
 {
 	unsigned long page_limit, cur_pages, new_pages;
@@ -291,6 +306,7 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 		return -EINVAL;
 
 	for (done = 0; done < nr_args; done++) {
+		struct io_uring_regbuf_desc desc;
 		struct io_rsrc_node *node;
 		u64 tag = 0;
 
@@ -304,7 +320,9 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 			err = -EFAULT;
 			break;
 		}
-		node = io_sqe_buffer_register(ctx, iov, &last_hpage);
+
+		io_iov_to_regbuf_desc(iov, &desc);
+		node = io_sqe_buffer_register(ctx, &desc, &last_hpage);
 		if (IS_ERR(node)) {
 			err = PTR_ERR(node);
 			break;
@@ -760,27 +778,27 @@ bool io_check_coalesce_buffer(struct page **page_array, int nr_pages,
 }
 
 static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
-						   struct iovec *iov,
-						   struct page **last_hpage)
+					struct io_uring_regbuf_desc *desc,
+					struct page **last_hpage)
 {
+	unsigned long uaddr = (unsigned long)desc->uaddr;
+	size_t size = desc->size;
 	struct io_mapped_ubuf *imu = NULL;
 	struct page **pages = NULL;
 	struct io_rsrc_node *node;
 	unsigned long off;
-	size_t size;
 	int ret, nr_pages, i;
 	struct io_imu_folio_data data;
 	bool coalesced = false;
 
-	if (!iov->iov_base) {
-		if (iov->iov_len)
+	if (!uaddr) {
+		if (size)
 			return ERR_PTR(-EFAULT);
 		/* remove the buffer without installing a new one */
 		return NULL;
 	}
 
-	ret = io_validate_user_buf_range((unsigned long)iov->iov_base,
-					 iov->iov_len);
+	ret = io_validate_user_buf_range(uaddr, size);
 	if (ret)
 		return ERR_PTR(ret);
 
@@ -789,8 +807,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 		return ERR_PTR(-ENOMEM);
 
 	ret = -ENOMEM;
-	pages = io_pin_pages((unsigned long) iov->iov_base, iov->iov_len,
-				&nr_pages);
+	pages = io_pin_pages(uaddr, size, &nr_pages);
 	if (IS_ERR(pages)) {
 		ret = PTR_ERR(pages);
 		pages = NULL;
@@ -812,10 +829,9 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	if (ret)
 		goto done;
 
-	size = iov->iov_len;
 	/* store original address for later verification */
-	imu->ubuf = (unsigned long) iov->iov_base;
-	imu->len = iov->iov_len;
+	imu->ubuf = uaddr;
+	imu->len = size;
 	imu->folio_shift = PAGE_SHIFT;
 	imu->release = io_release_ubuf;
 	imu->priv = imu;
@@ -825,7 +841,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 		imu->folio_shift = data.folio_shift;
 	refcount_set(&imu->refs, 1);
 
-	off = (unsigned long)iov->iov_base & ~PAGE_MASK;
+	off = uaddr & ~PAGE_MASK;
 	if (coalesced)
 		off += data.first_folio_page_idx << PAGE_SHIFT;
 
@@ -878,6 +894,7 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 		memset(iov, 0, sizeof(*iov));
 
 	for (i = 0; i < nr_args; i++) {
+		struct io_uring_regbuf_desc desc;
 		struct io_rsrc_node *node;
 		u64 tag = 0;
 
@@ -901,7 +918,8 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 			}
 		}
 
-		node = io_sqe_buffer_register(ctx, iov, &last_hpage);
+		io_iov_to_regbuf_desc(iov, &desc);
+		node = io_sqe_buffer_register(ctx, &desc, &last_hpage);
 		if (IS_ERR(node)) {
 			ret = PTR_ERR(node);
 			break;
-- 
2.53.0


