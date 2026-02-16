Return-Path: <io-uring+bounces-12242-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UAF/DCcik2kX1wEAu9opvQ
	(envelope-from <io-uring+bounces-12242-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 14:56:55 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 19C26144490
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 14:56:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 72EEC30010CD
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 13:55:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D93D22C0F8E;
	Mon, 16 Feb 2026 13:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QwVHQjQ2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2FF1F2BAD
	for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 13:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771250143; cv=none; b=QnKR3lTEpmkqIWXigSFA1quDupEdkO5xXorX7unonomjehGcJ9L4EZr2SHmtrQFWzVgtP+fUTaREtCdloCBQc5/fqUYZrL7N+hafGed+J8B7VU4awyxJeBd+0V3nEs9aOa45g43I0VJi6PrvPNeaFPYdZLxdNM+h0LOCw0kHE7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771250143; c=relaxed/simple;
	bh=oaCrjkvYlf8krFwKSzTwmb9JrIjqaJWyCvsDB8aff8A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VMkfqbIHPjZdHHDz/GxS+IPcMy3AaeMbMuzV8FMWI/efh7+8lL0JQNos5fSVK4M0LShScEWVT5jP05Ud2ZiybwRa8NdBzNTlMzOv2lfV+2V6C5xoXn3kTkx0unG1vps6HHK9UdYtpFTMvPxiAZAQoiDYyzGTgrQxGtQZILvkNjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QwVHQjQ2; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-4362197d174so2154541f8f.3
        for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 05:55:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771250138; x=1771854938; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bCA21JTXJk/4tyy17gVodw69oj6HgTg56RZiVS1nQ7E=;
        b=QwVHQjQ2i/y9mUCw+dZywp6ttzC8DJnzyIcOWMjW2vlioWxr5k6AJVJ6hP+oQ1uD/6
         cDOop+dlP/9t4waREpKk5ppFlcHSwOiKSkVv6Pcvhyi7ecsaz8FPrcCGm+uAN9dvFsqN
         8oidHdaFowNaXWz+7LT1PBUXeFo/yIh+4QJp6w30voNnP9smzZTVsrhe/PwEi6rZ1Vma
         oqw89cbArkEfPbIKhZs+IGQE/hl6LSD/sq8LJjzluQnIscVz99e79g6r2ve8nsm5v46/
         OiCGxPzWeAL2sbp5bCqD55hv923ona2aCQ0t3/9hYWjFUy5/qBx2m12ZHD6jtMFbf2Eu
         Yhwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771250138; x=1771854938;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bCA21JTXJk/4tyy17gVodw69oj6HgTg56RZiVS1nQ7E=;
        b=ZhMfxN0HGFY2K0FH3JIvoJIXP1ElnrPbp5qwsG41x9RlGZYRy8lkBDLeZ1WThiDXZj
         5A3k3zzDsIUkcjrmf7KsDRKKH1UeCYdjfAzmperXpvwDceMe4WrmX4oDrpOcKDSW2oGJ
         bpyECiKuA990FawtJKny9waBYAlTFLyhfzauXJeYMhW+7TKNxVdE2Wp42nhcR6Dztr9W
         5kByg+P2EXv1MX2BnLJMFIyRmzpP5Vum5YhwRJuid/Xh59x2gLatfT9NXmPSQxjg3hRZ
         mHbBCsJmzrjTyv6+3XASeKvIWfUANMAIhz1Zt+dCr6plux/dtLAM0Fr/yQYpto3xsE3f
         6TuA==
X-Gm-Message-State: AOJu0Yz7Y0Cm6KQUtm/Wtc0E8t9z00l2Od5HZr6wDsDHKiE8VXhKjof6
	yG+dGd3FCXGCEU5FTfIGQVnJpTq9RkKGzcDTqA0ADwOTroYOzRJNe1kFFAJQJrcZ
X-Gm-Gg: AZuq6aLP53RyZWXPizkV3CzC5wUqcMQhVGrIz8rjuAVhOXNjephMfhAWifM34aLL/jB
	wOxb3nTAVo1ATuzfx3tLDO9vhzPDmuolEfqNNE6OnYyOU8pG8ZjQYQUOYaDCPQ0mQE2AMhZCrpO
	GzH+qhdRNM3zV0mlJ0gYp3PfJoh4swPn2dqcD4QPYSTEtT8QKEy0KTCzjgef32GomXekdwpmNcT
	PDr0OCFuzOC6XWuZSoo+Msb4rk1qZSIayg4rCEbbvo8vu0SlOp1ZaZW+6NttOtdrNlIGJQMsV+A
	jl3pCcsly4f+qgj3FIRP32M4VTUT8jUapLjOFeb7ntUxy/wEBHIGUcmJqCEzTRBFaZTRAfuV4Ix
	Hk8wr66V97IoDN0aMM0FWyKbWzeHWDefZ985elo1YEjOQ/WdMMke3W9cbYK4YPGKpU0dw6jOXy9
	LmYTh/YTwqkyalPaC6WsaTJRN+diLfXuwbSXq6zccnGNu9RvIQcOB8lxVWvD08AsrLMrW+mmh9S
	mPqgpU4
X-Received: by 2002:a5d:5f82:0:b0:437:6b73:ffb1 with SMTP id ffacd0b85a97d-4379790e752mr19176974f8f.30.1771250138286;
        Mon, 16 Feb 2026 05:55:38 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:c3fa])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796ac9d77sm25299234f8f.33.2026.02.16.05.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Feb 2026 05:55:37 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH 1/1] io_uring/rsrc: improve regbuf iov validation
Date: Mon, 16 Feb 2026 13:55:30 +0000
Message-ID: <ecd56e25297fa8e9cdd03420f96e994d763f984d.1771249534.git.asml.silence@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12242-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_THREE(0.00)[3];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 19C26144490
X-Rspamd-Action: no action

Deduplicate io_buffer_validate() calls by moving the checks into
io_sqe_buffer_register(). Now we also don't need special handling in
io_buffer_validate() passing through buffer removal requests. I also
was using it as a cleanup before some other changes.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 31 ++++++++++---------------------
 1 file changed, 10 insertions(+), 21 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 05f00bdb02d7..842e231c8a7c 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -96,20 +96,6 @@ int io_validate_user_buf_range(u64 uaddr, u64 ulen)
 	return 0;
 }
 
-static int io_buffer_validate(struct iovec *iov)
-{
-	/*
-	 * Don't impose further limits on the size and buffer
-	 * constraints here, we'll -EINVAL later when IO is
-	 * submitted if they are wrong.
-	 */
-	if (!iov->iov_base)
-		return iov->iov_len ? -EFAULT : 0;
-
-	return io_validate_user_buf_range((unsigned long)iov->iov_base,
-					  iov->iov_len);
-}
-
 static void io_release_ubuf(void *priv)
 {
 	struct io_mapped_ubuf *imu = priv;
@@ -319,9 +305,6 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 			err = -EFAULT;
 			break;
 		}
-		err = io_buffer_validate(iov);
-		if (err)
-			break;
 		node = io_sqe_buffer_register(ctx, iov, &last_hpage);
 		if (IS_ERR(node)) {
 			err = PTR_ERR(node);
@@ -790,8 +773,17 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	struct io_imu_folio_data data;
 	bool coalesced = false;
 
-	if (!iov->iov_base)
+	if (!iov->iov_base) {
+		if (iov->iov_len)
+			return ERR_PTR(-EFAULT);
+		/* remove the buffer without installing a new one */
 		return NULL;
+	}
+
+	ret = io_validate_user_buf_range((unsigned long)iov->iov_base,
+					 iov->iov_len);
+	if (ret)
+		return ERR_PTR(ret);
 
 	node = io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
 	if (!node)
@@ -897,9 +889,6 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 				ret = PTR_ERR(iov);
 				break;
 			}
-			ret = io_buffer_validate(iov);
-			if (ret)
-				break;
 			if (ctx->compat)
 				arg += sizeof(struct compat_iovec);
 			else
-- 
2.52.0


