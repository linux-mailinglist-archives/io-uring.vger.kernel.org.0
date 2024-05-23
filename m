Return-Path: <io-uring+bounces-1956-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE8BD8CDC48
	for <lists+io-uring@lfdr.de>; Thu, 23 May 2024 23:46:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D299D1C22902
	for <lists+io-uring@lfdr.de>; Thu, 23 May 2024 21:46:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22ABC84DE2;
	Thu, 23 May 2024 21:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="zNwSvOMK";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/IVbyZyh";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="RLLie8sG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="U6YEaLfy"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0440212839E
	for <io-uring@vger.kernel.org>; Thu, 23 May 2024 21:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716500744; cv=none; b=FbgtaKGdCIr+wt32Lzn+/Fr2hc/ntF1VNvotqEfFD8kozM8BXgPtbwc12yfNxAVUxr3A+r1LPofxFMnd1hKAi9XnZdSTHMbov52SiIPdGb5+poUcqq+M99zHbo1WhNUsGHosAbLZkRftoO8b5aRF1hjwzMhA0c2PAddHB8gCnP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716500744; c=relaxed/simple;
	bh=TxQRxS8X/03briVa2udum2GE1r/KdNob982WwPGwtpU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=N7xEN/JoV+uuOLZR6JXINds7BJGQ5NeUbf843k4ViX//nybsEXR4m26rNdo04uCDxAnhq+FbvJI78TAXPKPc5rcMoSn4r5t0S09P/hQcNiosIgoEHk/g/UlSKyQ57dNAjWEZy7cC4BKvkbbMneifCkfv6w9HUHdFOEy2EeIsmSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=zNwSvOMK; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/IVbyZyh; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=RLLie8sG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=U6YEaLfy; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2DA1820527;
	Thu, 23 May 2024 21:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1716500740; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=PamAmXDsW+KYUr5r2h71AzoDE2JzN+s30VJRtBm+BDQ=;
	b=zNwSvOMKw//A2DCzFD2Lmw0qnLcEWVy4HBJGsMowlJgK4210b8OFwn/SFxDfJpl+Rz3p8O
	2+zldSxAS3wZlIOrdaogTc4E9JQ79fpez/qcFCHh+hFLWNA4g6LqO0vJ713/1pHEeDMQxR
	3UHG1IMoKejTL2udw19LGKFnQ1c5tio=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1716500740;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=PamAmXDsW+KYUr5r2h71AzoDE2JzN+s30VJRtBm+BDQ=;
	b=/IVbyZyhWuZGDpfm8t3SxJYIAj/OxM2cKSX5iJ7FMtKbJh7OSJgWyx/xOFWjHWvJ/WVsUB
	vrrUDLH/mZY5njAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RLLie8sG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=U6YEaLfy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1716500739; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=PamAmXDsW+KYUr5r2h71AzoDE2JzN+s30VJRtBm+BDQ=;
	b=RLLie8sGftddjeaiGmIYMDifPsshqkay5Fg+FAnaIbYyEYiFDiUirN7lqSKWKrdFJwcjty
	+CQGfqoTWeMQVHt4x6/zc9A8NAkFklMoHOYjK2ySqhi2I3JVyhWY8XBTWxKGuibUtAf3Tw
	+YAHo01Sf8z+9OMCT4cEMHyhlTNYVG4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1716500739;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=PamAmXDsW+KYUr5r2h71AzoDE2JzN+s30VJRtBm+BDQ=;
	b=U6YEaLfy7zzAlxniZ/TEN5XhI4zV/nkWRRTavT39Ooj6TrDmLHHDqoZAdPMckWL5+NrDxH
	lQBroQ0rSeSVxTCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E9C6C13A6C;
	Thu, 23 May 2024 21:45:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uDMLMwK5T2b4PwAAD6G6ig
	(envelope-from <krisman@suse.de>); Thu, 23 May 2024 21:45:38 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH] io_uring/rsrc: Drop io_copy_iov in favor of iovec API
Date: Thu, 23 May 2024 17:45:35 -0400
Message-ID: <20240523214535.31890-1-krisman@suse.de>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 2DA1820527
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]

Instead of open coding an io_uring function to copy iovs from userspace,
rely on the existing iovec_from_user function.  While there, avoid
repeatedly zeroing the iov in the !arg case for io_sqe_buffer_register.

tested with liburing testsuite.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/rsrc.c | 60 +++++++++++++++++--------------------------------
 1 file changed, 21 insertions(+), 39 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 65417c9553b1..338e771bcafb 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -85,31 +85,6 @@ static int io_account_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
 	return 0;
 }
 
-static int io_copy_iov(struct io_ring_ctx *ctx, struct iovec *dst,
-		       void __user *arg, unsigned index)
-{
-	struct iovec __user *src;
-
-#ifdef CONFIG_COMPAT
-	if (ctx->compat) {
-		struct compat_iovec __user *ciovs;
-		struct compat_iovec ciov;
-
-		ciovs = (struct compat_iovec __user *) arg;
-		if (copy_from_user(&ciov, &ciovs[index], sizeof(ciov)))
-			return -EFAULT;
-
-		dst->iov_base = u64_to_user_ptr((u64)ciov.iov_base);
-		dst->iov_len = ciov.iov_len;
-		return 0;
-	}
-#endif
-	src = (struct iovec __user *) arg;
-	if (copy_from_user(dst, &src[index], sizeof(*dst)))
-		return -EFAULT;
-	return 0;
-}
-
 static int io_buffer_validate(struct iovec *iov)
 {
 	unsigned long tmp, acct_len = iov->iov_len + (PAGE_SIZE - 1);
@@ -419,8 +394,9 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 				   struct io_uring_rsrc_update2 *up,
 				   unsigned int nr_args)
 {
+	struct iovec __user *uvec = u64_to_user_ptr(up->data);
 	u64 __user *tags = u64_to_user_ptr(up->tags);
-	struct iovec iov, __user *iovs = u64_to_user_ptr(up->data);
+	struct iovec fast_iov, *iov;
 	struct page *last_hpage = NULL;
 	__u32 done;
 	int i, err;
@@ -434,21 +410,23 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 		struct io_mapped_ubuf *imu;
 		u64 tag = 0;
 
-		err = io_copy_iov(ctx, &iov, iovs, done);
-		if (err)
+		iov = iovec_from_user(&uvec[done], 1, 1, &fast_iov, ctx->compat);
+		if (IS_ERR(iov)) {
+			err = PTR_ERR(iov);
 			break;
+		}
 		if (tags && copy_from_user(&tag, &tags[done], sizeof(tag))) {
 			err = -EFAULT;
 			break;
 		}
-		err = io_buffer_validate(&iov);
+		err = io_buffer_validate(iov);
 		if (err)
 			break;
-		if (!iov.iov_base && tag) {
+		if (!iov->iov_base && tag) {
 			err = -EINVAL;
 			break;
 		}
-		err = io_sqe_buffer_register(ctx, &iov, &imu, &last_hpage);
+		err = io_sqe_buffer_register(ctx, iov, &imu, &last_hpage);
 		if (err)
 			break;
 
@@ -970,8 +948,9 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 {
 	struct page *last_hpage = NULL;
 	struct io_rsrc_data *data;
+	struct iovec fast_iov, *iov = &fast_iov;
+	const struct iovec __user *uvec = (struct iovec * __user) arg;
 	int i, ret;
-	struct iovec iov;
 
 	BUILD_BUG_ON(IORING_MAX_REG_BUFFERS >= (1u << 16));
 
@@ -988,24 +967,27 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 		return ret;
 	}
 
+	if (!arg)
+		memset(iov, 0, sizeof(*iov));
+
 	for (i = 0; i < nr_args; i++, ctx->nr_user_bufs++) {
 		if (arg) {
-			ret = io_copy_iov(ctx, &iov, arg, i);
-			if (ret)
+			iov = iovec_from_user(&uvec[i], 1, 1, &fast_iov, ctx->compat);
+			if (IS_ERR(iov)) {
+				ret = PTR_ERR(iov);
 				break;
-			ret = io_buffer_validate(&iov);
+			}
+			ret = io_buffer_validate(iov);
 			if (ret)
 				break;
-		} else {
-			memset(&iov, 0, sizeof(iov));
 		}
 
-		if (!iov.iov_base && *io_get_tag_slot(data, i)) {
+		if (!iov->iov_base && *io_get_tag_slot(data, i)) {
 			ret = -EINVAL;
 			break;
 		}
 
-		ret = io_sqe_buffer_register(ctx, &iov, &ctx->user_bufs[i],
+		ret = io_sqe_buffer_register(ctx, iov, &ctx->user_bufs[i],
 					     &last_hpage);
 		if (ret)
 			break;
-- 
2.44.0


