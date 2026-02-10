Return-Path: <io-uring+bounces-12118-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QGT8Ha58imkgLAAAu9opvQ
	(envelope-from <io-uring+bounces-12118-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 01:32:46 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D1DFA115A2C
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 01:32:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 27EB43036776
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 00:31:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA14A186E58;
	Tue, 10 Feb 2026 00:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C7IfW9oc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1511F37D3
	for <io-uring@vger.kernel.org>; Tue, 10 Feb 2026 00:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770683508; cv=none; b=PuG3X1/wAKzIHJVeZ+BbEv5PW36506xNHnzppYuBsTIj9TEOjSeoCu17dX2qz3wY8jK5i60gfwBUVMfuJbU/KJxs2p8J7gkrs67CrN4qiUS2OV8qMvv9SkEzIxa3jnOw7QWOCZKqFYeb3gMxsaGXG6SqLu0DYsKE7EXIc0mF8FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770683508; c=relaxed/simple;
	bh=TNIaYzai+T+QREjQ4KAVP/jgzM01dHQ6tT3+tHEBzGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DOE1qnGO+ghZ/t8qOpp0BOe/J20Lu7cnfvSqresahrce4LXPd/dtBYgZGLyIpQTlKr7joVKd0WnDWzXwqM6ZjEq4cACgV8wmgRfipXGWfz6CdKV7bG82ouTBzqWAoaZRDo0xi5stzrBGdsRpT1IrO9/3xcvRdoBLpjda4poFQz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C7IfW9oc; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-352e3d18fa7so2794682a91.1
        for <io-uring@vger.kernel.org>; Mon, 09 Feb 2026 16:31:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770683506; x=1771288306; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U3y/6Mxtdpafe2mJqvrMRavfqgGwOCaEQ6R27Qx9SLQ=;
        b=C7IfW9ocz8xUpuxK4yCO+Q+4dSzGcEbnzoxqIrCFwJ09AOh2hyF58/DQSf5w1gFerv
         eoDrpv+k0w2m2GP8/KEOztxrdc14swoAJdEsisNxCVqW49o/GRdbxsjpnSsMj1DPfCrQ
         /gZ9pWaLJuJiF391Qgwrtjpr7MxPaTw/rrRrpwvNK+cwgDafm4SgTmujzgW8UUzGpB+F
         T7Uzyk5izpB5lvd+79gFij8yMp1gb3PlxSMbpE2Gx24cxjZ5eXsJZIFzCEuLjLr4/xsV
         s+h1uuxnk03CL3tt0Jwp2yXntH8PgCel1bSddQ1hjMzmnCOHl4X8tiuQFcfR3EIhcXtL
         +1+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770683506; x=1771288306;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=U3y/6Mxtdpafe2mJqvrMRavfqgGwOCaEQ6R27Qx9SLQ=;
        b=NqYH+ZoFyHEKjpINV7DxWGjogsMXObVHRHs1RAOXmc99JTPCrWE4QcP+iu+27KXpcE
         kICV1BfpJFEYRTVFkxNWkJlIKllpgQLh+mPl3hBby8jAu4LpbqeLMhsUG9BKppzoxlXg
         /XRYSzzb7cfpT3+jQStQsrZjMZH4eoqCeSFy5Luyl1NgCD96YmzZA5mhg58cTtFiW31N
         PxBMH8ajesIzC23U8UaCs+UT8vLczTYPmCIcppH9fTiVyOrvmBqIG7P3K/2rmv5Xxsup
         HEJ9294EVE73FOTuFwDOdHfIeNgiyaOBNAYEwMacDC67JJY9O15lte0+jt0FC5K2B3Fo
         toaA==
X-Forwarded-Encrypted: i=1; AJvYcCUppE5j+JkZt50Xjkf6fX9NDdVycsJykn1CDD6piQ9JXZCM8AQoeL+hJfBgRUrmL+ZMzkW+126A1A==@vger.kernel.org
X-Gm-Message-State: AOJu0YysH/t5eDMlCzxWPgxd1r9Q70kXRiA69rxt0AC5aASaRxLprQZl
	GdRXlwJrAJNBC7f8aTa7jpjZIttcxepDNzKKBNZCuPbQJp8r6rG+WGzy
X-Gm-Gg: AZuq6aJhvDXteqI3suAjWiVlgZYpanvw4xFUyyrsS8jCpX4fze0EKZ0BQG2OZ4/i3oB
	12lkrQF8JmXVXx5R8IufA/5oagOVkMLVEyF0I8OC/ERSl/oyZkTM2Bmyk3bRkMw4OKFJUq6ZbtO
	Rp4LJX5hL7S0gHEgJsQOSItb9zhw9l6wwXup6YYsVg1zQVoNxAjPadO1KW5rBhJHvWr6IdYmsYn
	gPE3pRTYz0TtjFJEdOnEqcOk2Hm8so1ezoE7qmzlBFnHJyBxDYF/fGIy0h2P1rT4yZj5xYxmxsJ
	7CEBvQkBeBjGoshok10SdwQM7Af/4xvs9qkSMRkw8iMY8hV+PiJJ6VJji6XgECLkmtkon3QRWfw
	ttyYjqP0wAt9wnx4KCT/xUmY5dp87KeaxRylUsrS3bdgUL4vU1sSLtmk2bLfCGK72PEeCBsZRIL
	iCSgPb
X-Received: by 2002:a17:90b:4f84:b0:356:2eff:deff with SMTP id 98e67ed59e1d1-3562effe224mr5610626a91.15.1770683505642;
        Mon, 09 Feb 2026 16:31:45 -0800 (PST)
Received: from localhost ([2a03:2880:ff:4::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35662f8cd1esm687796a91.15.2026.02.09.16.31.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Feb 2026 16:31:45 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk,
	io-uring@vger.kernel.org
Cc: csander@purestorage.com,
	krisman@suse.de,
	bernd@bsbernd.com,
	hch@infradead.org,
	asml.silence@gmail.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 04/11] io_uring/kbuf: add mmap support for kernel-managed buffer rings
Date: Mon,  9 Feb 2026 16:28:45 -0800
Message-ID: <20260210002852.1394504-5-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260210002852.1394504-1-joannelkoong@gmail.com>
References: <20260210002852.1394504-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[purestorage.com,suse.de,bsbernd.com,infradead.org,gmail.com,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12118-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[8];
	TO_DN_NONE(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D1DFA115A2C
X-Rspamd-Action: no action

Add support for mmapping kernel-managed buffer rings (kmbuf) to
userspace, allowing applications to access the kernel-allocated buffers.

Similar to application-provided buffer rings (pbuf), kmbuf rings use the
buffer group ID encoded in the mmap offset to identify which buffer ring
to map. The implementation follows the same pattern as pbuf rings.

New mmap offset constants are introduced:
  - IORING_OFF_KMBUF_RING (0x88000000): Base offset for kmbuf mappings
  - IORING_OFF_KMBUF_SHIFT (16): Shift value to encode buffer group ID

The mmap offset encodes the bgid shifted by IORING_OFF_KMBUF_SHIFT.
The io_buf_get_region() helper retrieves the appropriate region.

This allows userspace to mmap the kernel-allocated buffer region and
access the buffers directly.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/uapi/linux/io_uring.h |  2 ++
 io_uring/kbuf.c               | 11 +++++++++--
 io_uring/kbuf.h               |  5 +++--
 io_uring/memmap.c             |  5 ++++-
 4 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index a0889c1744bd..42a2812c9922 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -545,6 +545,8 @@ struct io_uring_cqe {
 #define IORING_OFF_SQES			0x10000000ULL
 #define IORING_OFF_PBUF_RING		0x80000000ULL
 #define IORING_OFF_PBUF_SHIFT		16
+#define IORING_OFF_KMBUF_RING		0x88000000ULL
+#define IORING_OFF_KMBUF_SHIFT		16
 #define IORING_OFF_MMAP_MASK		0xf8000000ULL
 
 /*
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 9bc36451d083..ccf5b213087b 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -770,16 +770,23 @@ int io_register_pbuf_status(struct io_ring_ctx *ctx, void __user *arg)
 	return 0;
 }
 
-struct io_mapped_region *io_pbuf_get_region(struct io_ring_ctx *ctx,
-					    unsigned int bgid)
+struct io_mapped_region *io_buf_get_region(struct io_ring_ctx *ctx,
+					   unsigned int bgid,
+					   bool kernel_managed)
 {
 	struct io_buffer_list *bl;
+	bool is_kernel_managed;
 
 	lockdep_assert_held(&ctx->mmap_lock);
 
 	bl = xa_load(&ctx->io_bl_xa, bgid);
 	if (!bl || !(bl->flags & IOBL_BUF_RING))
 		return NULL;
+
+	is_kernel_managed = !!(bl->flags & IOBL_KERNEL_MANAGED);
+	if (is_kernel_managed != kernel_managed)
+		return NULL;
+
 	return &bl->region;
 }
 
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 62c80a1ebf03..11d165888b8e 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -88,8 +88,9 @@ unsigned int __io_put_kbufs(struct io_kiocb *req, struct io_buffer_list *bl,
 bool io_kbuf_commit(struct io_kiocb *req,
 		    struct io_buffer_list *bl, int len, int nr);
 
-struct io_mapped_region *io_pbuf_get_region(struct io_ring_ctx *ctx,
-					    unsigned int bgid);
+struct io_mapped_region *io_buf_get_region(struct io_ring_ctx *ctx,
+					   unsigned int bgid,
+					   bool kernel_managed);
 
 static inline bool io_kbuf_recycle_ring(struct io_kiocb *req,
 					struct io_buffer_list *bl)
diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 8d37e93c0433..916315122323 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -356,7 +356,10 @@ static struct io_mapped_region *io_mmap_get_region(struct io_ring_ctx *ctx,
 		return &ctx->sq_region;
 	case IORING_OFF_PBUF_RING:
 		id = (offset & ~IORING_OFF_MMAP_MASK) >> IORING_OFF_PBUF_SHIFT;
-		return io_pbuf_get_region(ctx, id);
+		return io_buf_get_region(ctx, id, false);
+	case IORING_OFF_KMBUF_RING:
+		id = (offset & ~IORING_OFF_MMAP_MASK) >> IORING_OFF_KMBUF_SHIFT;
+		return io_buf_get_region(ctx, id, true);
 	case IORING_MAP_OFF_PARAM_REGION:
 		return &ctx->param_region;
 	case IORING_MAP_OFF_ZCRX_REGION:
-- 
2.47.3


