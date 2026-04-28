Return-Path: <io-uring+bounces-13161-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +PuqC23W8GkSZQEAu9opvQ
	(envelope-from <io-uring+bounces-13161-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 17:46:53 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C4A0F4882B1
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 17:46:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 11FDA3060ADF
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2026 15:46:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3D4E3A9638;
	Tue, 28 Apr 2026 15:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="UPpl9Rrl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077D13BF684
	for <io-uring@vger.kernel.org>; Tue, 28 Apr 2026 15:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777391164; cv=none; b=Vd5dWlgQXSbI9UZSP6RyWo+9ZZVkDnUp4svjT7cYTrYf3G3Qx50yeQDqrPGpXjiwyD692yZTCPkFBxrdtSoF/Kh40XC0rKTqauG5LcA2ylaUgzmpxG6/S6Ox/UQqUDzlGgqmbYM0tRml/IpUg0ZP8NdlJ5T8xbVY60pVs8aJVQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777391164; c=relaxed/simple;
	bh=lZ8GVIQeyx6FhafZAJBBqfDuAvMKXOY+e5J3qcPq8kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FbQv+SdVS1Bk6BC28x0Pc8T5lMC4SxwqYHFVV1nKydtpvtE9pAf8dUl2/u/cH0fY7a1y3yvhk+xYesXl3NfIvn0kZzO7fG2AAKcxmICqJ6YOROoEqg2MXQhnRtsEGMKdPHFkELM74XJPdprgOoYXF/0RhcoRLz35vOGzHhfjQKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=UPpl9Rrl; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-42c08cbae4cso6534381fac.2
        for <io-uring@vger.kernel.org>; Tue, 28 Apr 2026 08:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777391162; x=1777995962; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pwoQUuKpX/ekRA8Qo1PHn8+ae1HpgVzRgnT0CoXolUA=;
        b=UPpl9RrlsrxtUgRHCoIZxAcNrjEL2kTjCZxj72+qp2smvSXkytx2P+UcZcQb/l9p6x
         qdAXVR+vrVwZKB042aJP7erNlh1SYW3rzcQDybbOKDxiz9Se2zL9DFnyx8y+rnSfnB8u
         SBm0DO2LCVauy2i3gFTlNPJIlL7+0loBLo1b4wZFhi11VLVxgKJABd1aKFCtubQN+ucf
         w/CGd6zCMKuh6YOUojm6a762tPvqXuAjI8wj/i6yRolwItKrvKf7g1SzYshQpH1nYTyS
         5VN6DGhuyamtkCkFT7nY6PnI7RKJhSsIqZ9vpDb99YT4UPSYJT/29Gr9Y+Cp/j7gvni6
         agXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777391162; x=1777995962;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pwoQUuKpX/ekRA8Qo1PHn8+ae1HpgVzRgnT0CoXolUA=;
        b=eXPYz3T8MBy7OHeKjZzE2g6lyEca5I/3E4TUvRmg20tFiPmybhFMp2pAxrA7ErUEE3
         icwHFZRgJsWazSc2CsBhEpIZQkT/9g/rItYRgIQsqiWbblfeHrIJqix53+LaBN8Q7ghZ
         xR0MrJLqCj2QuVOd/8HqAw24RmGp47BI+Cpgo00ZwE3crm/l9nbctOOcVngWgBZlJbic
         1QpZmcWINPMuSRPRJ4GSRy9qTopW1TsLTWj1rrJ2bctyVaiXGHox7FoJ2BYruzqTax6u
         qh0I+rqp7FWW2Pk4a1/yxVDHgwpCjsNekJwbLt+2vUYhV1XKJrnMFABuqWDj89omD4p4
         v3mw==
X-Gm-Message-State: AOJu0YxVQIRCNjOCnOGBkHOu+NNf/fBU7W9zGUvFTaBr5Lkaarble36P
	qEUWIv+ehRulxPybWi9pV58KGhHtCbAqzhBx/VSzc+xN1sBCQYKOoJ9zN3HISRdEVeqPWpKrPR5
	b/qYnJZA=
X-Gm-Gg: AeBDies6IgJNklvAW0fHFiissclE4sDd4tGWjvmABhgkXE0aK8jZEDO5R+fXL5AIkAn
	rBHZb3pCyNdYdKEov2XlqgSv2v79F9SqQkbZirhsX/TWO97dDUlvW2PHUw9CiuWUR/qOUiSZBHr
	i2IDj/494EEfhs7zrng/REsVQG56LIy4btYLbBnTVMwXoIfoKz8sSrx0cqGkmDtHVSLvKDiihsU
	asDhOvG45gMG5rYc6GyEUU7juYiU4MdfI0LzDc9SptIrZbKjKQnBjuxodhH+IMwL9VU0h6N2w5t
	DouSTh8yQqTEunu8f+iLmtmrsHd6tfNJPWAn5nHH+4dMgbUc6cmcj8ZWOhGzIoBXz+cyRw9AKj5
	Eke/Ah1aGTrfST5zrfpX0N3V0E3qs938p8pQo96BTRKmfTZ0gK7HqfQLDpkt5xIlKYAg00vm1fC
	lDZX9A1uzb9Vpp3Rw0F6czqgDULPq4KDDHqVApsGX4vUpplbERCKOhNqTGc1BTxZfg8Yn4k5xMk
	IE/Ug==
X-Received: by 2002:a05:6870:2e88:b0:42f:c1ea:f19d with SMTP id 586e51a60fabf-4340a89d62bmr22904fac.10.1777391161589;
        Tue, 28 Apr 2026 08:46:01 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-433effdc79bsm2109567fac.18.2026.04.28.08.46.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 08:46:00 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Martin Michaelis <code@mgjm.de>,
	stable@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring/kbuf: support min length left for incremental buffers
Date: Tue, 28 Apr 2026 09:44:50 -0600
Message-ID: <20260428154557.2150818-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428154557.2150818-1-axboe@kernel.dk>
References: <20260428154557.2150818-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C4A0F4882B1
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13161-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mgjm.de:email,kernel-dk.20251104.gappssmtp.com:dkim,kernel.dk:mid,kernel.dk:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]

From: Martin Michaelis <code@mgjm.de>

Incrementally consumed buffer rings are generally fully consumed, but
it's quite possible that the application has a minimum size it needs to
meet to avoid truncation. Currently that minimum limit is 1 byte, but
this should be a setting that is the hands of the application. For
recvmsg multishot, a prime use case for incrementally consumed buffers,
the application may get spurious -EFAULT returned at the end of an
incrementally consumed buffer, as less space is available than the
headers need.

Grab a u32 field in struct io_uring_buf_reg, which the application can
use to inform the kernel of the minimum size that should be available
in an incrementally consumed buffer. If less than that is available,
the current buffer is fully processed and the next one will be picked.

Cc: stable@vger.kernel.org
Fixes: ae98dbf43d75 ("io_uring/kbuf: add support for incremental buffer consumption")
Link: https://github.com/axboe/liburing/issues/1433
Signed-off-by: Martin Michaelis <code@mgjm.de>
[axboe: write commit message, change io_buffer_list member name]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h | 3 ++-
 io_uring/kbuf.c               | 8 +++++++-
 io_uring/kbuf.h               | 7 +++++++
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 17ac1b785440..909fb7aea638 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -905,7 +905,8 @@ struct io_uring_buf_reg {
 	__u32	ring_entries;
 	__u16	bgid;
 	__u16	flags;
-	__u64	resv[3];
+	__u32	min_left;
+	__u32	resv[5];
 };
 
 /* argument for IORING_REGISTER_PBUF_STATUS */
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 43e4f8615fe8..63061aa1cab9 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -47,7 +47,7 @@ static bool io_kbuf_inc_commit(struct io_buffer_list *bl, int len)
 		this_len = min_t(u32, len, buf_len);
 		buf_len -= this_len;
 		/* Stop looping for invalid buffer length of 0 */
-		if (buf_len || !this_len) {
+		if (buf_len > bl->min_left_sub_one || !this_len) {
 			WRITE_ONCE(buf->addr, READ_ONCE(buf->addr) + this_len);
 			WRITE_ONCE(buf->len, buf_len);
 			return false;
@@ -637,6 +637,10 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	if (reg.ring_entries >= 65536)
 		return -EINVAL;
 
+	/* minimum left byte count is a property of incremental buffers */
+	if (!(reg.flags & IOU_PBUF_RING_INC) && reg.min_left)
+		return -EINVAL;
+
 	bl = io_buffer_get_list(ctx, reg.bgid);
 	if (bl) {
 		/* if mapped buffer ring OR classic exists, don't allow */
@@ -683,6 +687,8 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	bl->mask = reg.ring_entries - 1;
 	bl->flags |= IOBL_BUF_RING;
 	bl->buf_ring = br;
+	if (reg.min_left)
+		bl->min_left_sub_one = reg.min_left - 1;
 	if (reg.flags & IOU_PBUF_RING_INC)
 		bl->flags |= IOBL_INC;
 	ret = io_buffer_add_list(ctx, bl, reg.bgid);
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index abf7052b556e..401773e1ef80 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -32,6 +32,13 @@ struct io_buffer_list {
 
 	__u16 flags;
 
+	/*
+	 * minimum required amount to be left to reuse an incrementally
+	 * consumed buffer. If less than this is left at consumption time,
+	 * buffer is done and head is incremented to the next buffer.
+	 */
+	__u32 min_left_sub_one;
+
 	struct io_mapped_region region;
 };
 
-- 
2.53.0


