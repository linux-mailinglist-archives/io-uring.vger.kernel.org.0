Return-Path: <io-uring+bounces-12105-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mAZUK9LviWn4EQAAu9opvQ
	(envelope-from <io-uring+bounces-12105-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 09 Feb 2026 15:31:46 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F160110617
	for <lists+io-uring@lfdr.de>; Mon, 09 Feb 2026 15:31:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 26C88300B59E
	for <lists+io-uring@lfdr.de>; Mon,  9 Feb 2026 14:31:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5AA823B604;
	Mon,  9 Feb 2026 14:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VmMVdOfb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5574537AA6B
	for <io-uring@vger.kernel.org>; Mon,  9 Feb 2026 14:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647495; cv=none; b=sEJH3qAfipqIzE5/iKW3S2o79bC8weukPvUhskh+PTrZ93EGses0UcXLde9nRVe7fVoiVbpicF583/Kn1xb/lqehocGy6k5lMsvobXYnGN/mK7wyD1OWbd7CMOLKtjP5yfWHLutzxOuzn5kqGNDnOYBKNuq8HlMuLxZ+0ckg7yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647495; c=relaxed/simple;
	bh=hdqRb1Eeai0XtpLJEQFkJk471HZnUjAoZasDZUhO1TE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oO5go6O4ntAqer6kaTw/7EtK4OP/ituT70vpbauQxYgXB5VjzzKD4FQ0XMazVnQ2IwK83/6RXHZmjGtiT2kbUY+rZZJ4qZtG5eYf9iS0n2d/b2s5e7C2AHTxALn3+cMvjYj2XEhB/yXFdIa0aXwS5jQjuHDrVZlxH5CADqTktQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VmMVdOfb; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-482f2599980so52727395e9.0
        for <io-uring@vger.kernel.org>; Mon, 09 Feb 2026 06:31:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770647493; x=1771252293; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=y+eTfYqpzLv3qJpfEOPfILGc8sYSd33j+ZqaH4Si4Zg=;
        b=VmMVdOfb7ajk46zD3ofu3FaInqcQUZ3ujNYql3NODiDgVUUEIQruhd0cskN6eL4Nq+
         Jy68Z76PPzWTirwn+kL+rMnr3CjqAjFZEyTJ62h3CoRKczKXHvnPi+BlTw3iojfSmI7O
         dBBvcp+ct00fHsr814ryBKseFhE0zhmOKbrMPkPXUgiIAvOvjJGwjdffhTlkBC9UJ0Ex
         rI3K1mtFdeZ92kHLtpomFOTSJVHqRPVKigXBwx+57sJhE+K5TvZSNEXCLVQXbHes+ItA
         nDw7/twd+68VEabWFD/cVuKaLQeZmB1VfCUvLm3OSqC1+gcp6rlz7bDknHSZo9cL+rHr
         kEnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770647493; x=1771252293;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y+eTfYqpzLv3qJpfEOPfILGc8sYSd33j+ZqaH4Si4Zg=;
        b=S8HGmmCIcsuF0N7qBTEZeKdpneoHIqxoIodZEO9Bwtk1Nvh16LTqzCqxY/kmczg8Jo
         fH5dKVOZ9IFIrArgeGcIJYuaP2amDztR4x+wUTbdI60Z8faRCH+9sdCAs4VK2Q9gtuUv
         r/qs97Tm+leXVypKu1IKnHQyZYa9UWJaGF5/iVj+e6fwz1uoO6rKEnBYCroypjjUHD6E
         MSAGhz3YOYiHkSoPW7wtNCnnNVHw5PP+rKR5qksfMwuQ7CpIlqfFtnJuOmRrBqvgl4KW
         5Hkhjj5VWD7/I3HbVnHmexJ3RVlblWYRJx3RNk9A+spiz+shgR0S8aKk64/tjihAAXYb
         6omw==
X-Gm-Message-State: AOJu0YxeQb9TXYszIP5UguVJlHk1PIn7OmscmU587Tj0eJh8SDhHUwSo
	V+Ws38ramZpaXbgnFdryj9+tcc02k71rbIlq9yz0Exllt0pn/JbffkqSYd+dyusl
X-Gm-Gg: AZuq6aJf+FXqGsLLS9HcDjyDjmlx8YkO1oaLat6eGQjMF1i56mdnw8/jNq+DASo38j5
	ECo4xgQfWDhlpK3L/J9s+bRYLbBQFGj421VPKCBYk/VFhzWv+CiNCOYZ2kl/ZWAxap1TAEkj0sf
	TToQgtDy67oUDCTB8E2gHingu8pJK9YZmDocrGSiwwaw9lUIj6nHgYObtoayif5LnurRrg+tUhH
	qLPo6bdKs8mZjIiIqQQi4X0PJ/NYFniJaar76aEif0E0Q5EcFrFz9VvN7IDmeGZ9Yktkvxp0dNF
	UU/Z106BSqM/gO3bJiG6qiIyRWt2+nl75FM9t7fh993Sr0pyeUhq704DJwqdxI0+N1ThV3XL0Ks
	6PqlSsjPyP5sCJ1eFn/MYBxVWmgqyQI5E0mHh0MgY/SSnLEVAN1DOpL7mnkWIOFXnmS/1yUoT/3
	7av+onewLshiL1xWFCpHPoyUPqKUKIL5jjRLR982eJ2n1MpDStDDb5rg4KTCc88NKLjH8IKw==
X-Received: by 2002:a05:600c:19c7:b0:477:9814:6882 with SMTP id 5b1f17b1804b1-483201dd0afmr151134645e9.5.1770647493054;
        Mon, 09 Feb 2026 06:31:33 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:9b67])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48333bad79bsm214219395e9.8.2026.02.09.06.31.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Feb 2026 06:31:32 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH] io_uring/rsrc: replace reg buffer bit field with flags
Date: Mon,  9 Feb 2026 14:31:22 +0000
Message-ID: <b2fa5a88797fc54bc365f88f4884a845b0a16530.1770646345.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12105-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_THREE(0.00)[3];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5F160110617
X-Rspamd-Action: no action

I'll need a flag in the registered buffer struct for dmabuf work, and
it'll be more convenient to have a flags field rather than bit fields,
especially for io_mapped_ubuf initialisation.

We might want to add more flags in the future as well. For example, it
might be useful for debugging and potentially optimisations to split out
a flag indicating the shape of the buffer to gate iov_iter_advance()
walks vs bit/mask arithmetics. It can also be combined with the
direction mask field.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 12 ++++++------
 io_uring/rsrc.h |  6 +++++-
 io_uring/rw.c   |  3 ++-
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 95ce553fff8d..05f00bdb02d7 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -828,7 +828,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	imu->folio_shift = PAGE_SHIFT;
 	imu->release = io_release_ubuf;
 	imu->priv = imu;
-	imu->is_kbuf = false;
+	imu->flags = 0;
 	imu->dir = IO_IMU_DEST | IO_IMU_SOURCE;
 	if (coalesced)
 		imu->folio_shift = data.folio_shift;
@@ -985,7 +985,7 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
 	refcount_set(&imu->refs, 1);
 	imu->release = release;
 	imu->priv = rq;
-	imu->is_kbuf = true;
+	imu->flags = IO_REGBUF_F_KBUF;
 	imu->dir = 1 << rq_data_dir(rq);
 
 	rq_for_each_bvec(bv, rq, rq_iter)
@@ -1020,7 +1020,7 @@ int io_buffer_unregister_bvec(struct io_uring_cmd *cmd, unsigned int index,
 		ret = -EINVAL;
 		goto unlock;
 	}
-	if (!node->buf->is_kbuf) {
+	if (!(node->buf->flags & IO_REGBUF_F_KBUF)) {
 		ret = -EBUSY;
 		goto unlock;
 	}
@@ -1076,7 +1076,7 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
 
 	offset = buf_addr - imu->ubuf;
 
-	if (imu->is_kbuf)
+	if (imu->flags & IO_REGBUF_F_KBUF)
 		return io_import_kbuf(ddir, iter, imu, len, offset);
 
 	/*
@@ -1496,7 +1496,7 @@ int io_import_reg_vec(int ddir, struct iov_iter *iter,
 	iovec_off = vec->nr - nr_iovs;
 	iov = vec->iovec + iovec_off;
 
-	if (imu->is_kbuf) {
+	if (imu->flags & IO_REGBUF_F_KBUF) {
 		int ret = io_kern_bvec_size(iov, nr_iovs, imu, &nr_segs);
 
 		if (unlikely(ret))
@@ -1534,7 +1534,7 @@ int io_import_reg_vec(int ddir, struct iov_iter *iter,
 		req->flags |= REQ_F_NEED_CLEANUP;
 	}
 
-	if (imu->is_kbuf)
+	if (imu->flags & IO_REGBUF_F_KBUF)
 		return io_vec_fill_kern_bvec(ddir, iter, imu, iov, nr_iovs, vec);
 
 	return io_vec_fill_bvec(ddir, iter, imu, iov, nr_iovs, vec);
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 4a5db2ad1af2..cff0f8834c35 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -28,6 +28,10 @@ enum {
 	IO_IMU_SOURCE	= 1 << ITER_SOURCE,
 };
 
+enum {
+	IO_REGBUF_F_KBUF		= 1,
+};
+
 struct io_mapped_ubuf {
 	u64		ubuf;
 	unsigned int	len;
@@ -37,7 +41,7 @@ struct io_mapped_ubuf {
 	unsigned long	acct_pages;
 	void		(*release)(void *);
 	void		*priv;
-	bool		is_kbuf;
+	u8		flags;
 	u8		dir;
 	struct bio_vec	bvec[] __counted_by(nr_bvecs);
 };
diff --git a/io_uring/rw.c b/io_uring/rw.c
index d10386f56d49..b3971171c342 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -702,7 +702,8 @@ static ssize_t loop_rw_iter(int ddir, struct io_rw *rw, struct iov_iter *iter)
 	if ((kiocb->ki_flags & IOCB_NOWAIT) &&
 	    !(kiocb->ki_filp->f_flags & O_NONBLOCK))
 		return -EAGAIN;
-	if ((req->flags & REQ_F_BUF_NODE) && req->buf_node->buf->is_kbuf)
+	if ((req->flags & REQ_F_BUF_NODE) &&
+	     (req->buf_node->buf->flags & IO_REGBUF_F_KBUF))
 		return -EFAULT;
 
 	ppos = io_kiocb_ppos(kiocb);
-- 
2.52.0


