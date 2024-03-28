Return-Path: <io-uring+bounces-1271-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D596888F374
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 01:17:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B2D4E1C25BF6
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 00:17:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34851ED8;
	Thu, 28 Mar 2024 00:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZiwpSW6U";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="5IgW6hGf";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZiwpSW6U";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="5IgW6hGf"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6342E193
	for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 00:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711585032; cv=none; b=pQUr7OZXmjKlZuyipg429YCV80fmbyovgCuXTbVYKqG++FsuCP5LuIEx07RESUz9Rq7MOA7SHKJQ2GwlXE/ZT1sTw12XHTn7mS0r52E0vgYuv2mnfIEeIuS7gWhqwl/o5qWVeWbyX/6Dn+1T4aqeoHMIurEQD0Jxr2b4Alc//RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711585032; c=relaxed/simple;
	bh=tfxQcYc97pYyLNjgIe07XrjrWc4OnWbM1yGouGfOQNo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iScYgwpVEbJJxxSRmq2aGEauTPJwYUpfyfi5G1UP3M2XzGA7Tt7PT1SWZH4kpPzbbE4d4zh87e6AY1hDLuj5irUQiInY+YtaQSN2ghuKyc5ZPHSqZ3tB33djTeiIZqyf2sBtzaAzdjnGQ7YWsge93dilNJ0zDz/ERTJO+v6mpaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZiwpSW6U; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=5IgW6hGf; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZiwpSW6U; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=5IgW6hGf; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [10.150.64.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 911001FFCF;
	Thu, 28 Mar 2024 00:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1711585027; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=oPircWkxUyBo0aXsToWeKEDbkHDT4K3KdTzKoqY0VlQ=;
	b=ZiwpSW6UbPpEehxMDLsbECSUpzui85zyAQQiY6bBFDKRaUrVNQucu5VTaG9SOfY2EBsDfp
	mDtX4l+oUXo29mS47yM4otPg+CLodSOM9SI4RQ7sLRTyi2Ma0Bh+3kg75LZa81K4jwokeL
	FwDUJw49b9u30rIrU2WtkqVGykqRNaA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1711585027;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=oPircWkxUyBo0aXsToWeKEDbkHDT4K3KdTzKoqY0VlQ=;
	b=5IgW6hGfJEl5rg5RGfwkaEYukYSG0jaWu/WdX8CveBS+4cnoOqKWOHMexOo6nnhpUG4l7x
	IUzWfIAkL5E7dnAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1711585027; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=oPircWkxUyBo0aXsToWeKEDbkHDT4K3KdTzKoqY0VlQ=;
	b=ZiwpSW6UbPpEehxMDLsbECSUpzui85zyAQQiY6bBFDKRaUrVNQucu5VTaG9SOfY2EBsDfp
	mDtX4l+oUXo29mS47yM4otPg+CLodSOM9SI4RQ7sLRTyi2Ma0Bh+3kg75LZa81K4jwokeL
	FwDUJw49b9u30rIrU2WtkqVGykqRNaA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1711585027;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=oPircWkxUyBo0aXsToWeKEDbkHDT4K3KdTzKoqY0VlQ=;
	b=5IgW6hGfJEl5rg5RGfwkaEYukYSG0jaWu/WdX8CveBS+4cnoOqKWOHMexOo6nnhpUG4l7x
	IUzWfIAkL5E7dnAA==
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id 5691C13AB3;
	Thu, 28 Mar 2024 00:17:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id xonkDgO3BGY3TwAAn2gu4w
	(envelope-from <krisman@suse.de>); Thu, 28 Mar 2024 00:17:07 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH liburing] io_uring.h: Avoid anonymous enums
Date: Wed, 27 Mar 2024 20:16:53 -0400
Message-ID: <20240328001653.31124-1-krisman@suse.de>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: 3.44
X-Spamd-Result: default: False [3.44 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 RCPT_COUNT_THREE(0.00)[3];
	 R_MISSING_CHARSET(2.50)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 BROKEN_CONTENT_TYPE(1.50)[];
	 TO_DN_SOME(0.00)[];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 MID_CONTAINS_FROM(1.00)[];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-0.26)[73.65%]
X-Spam-Level: ***
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Flag: NO

anonymous enums, while valid, confuses Cython (Python to C translator),
as reported by Ritesh (YoSTEALTH) .  Since people are using this, just
name the existing enums.

See https://github.com/cython/cython/issues/3240.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>

---
Do we want to sync with the kernel header?
---
 src/include/liburing/io_uring.h | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index bde1199..efa3b78 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -115,7 +115,7 @@ struct io_uring_sqe {
  */
 #define IORING_FILE_INDEX_ALLOC		(~0U)
 
-enum {
+enum io_uring_sqe_flag_bit {
 	IOSQE_FIXED_FILE_BIT,
 	IOSQE_IO_DRAIN_BIT,
 	IOSQE_IO_LINK_BIT,
@@ -369,7 +369,7 @@ enum io_uring_op {
 /*
  * IORING_OP_MSG_RING command types, stored in sqe->addr
  */
-enum {
+enum io_uring_msg_ring_flags {
 	IORING_MSG_DATA,	/* pass sqe->len as 'res' and off as user_data */
 	IORING_MSG_SEND_FD,	/* send a registered fd to another ring */
 };
@@ -420,9 +420,7 @@ struct io_uring_cqe {
 #define IORING_CQE_F_SOCK_NONEMPTY	(1U << 2)
 #define IORING_CQE_F_NOTIF		(1U << 3)
 
-enum {
-	IORING_CQE_BUFFER_SHIFT		= 16,
-};
+#define IORING_CQE_BUFFER_SHIFT 16
 
 /*
  * Magic offsets for the application to mmap the data it needs
@@ -521,7 +519,7 @@ struct io_uring_params {
 /*
  * io_uring_register(2) opcodes and arguments
  */
-enum {
+enum io_uring_register_op {
 	IORING_REGISTER_BUFFERS			= 0,
 	IORING_UNREGISTER_BUFFERS		= 1,
 	IORING_REGISTER_FILES			= 2,
@@ -578,7 +576,7 @@ enum {
 };
 
 /* io-wq worker categories */
-enum {
+enum io_wq_type {
 	IO_WQ_BOUND,
 	IO_WQ_UNBOUND,
 };
@@ -683,7 +681,7 @@ struct io_uring_buf_ring {
  *			IORING_OFF_PBUF_RING | (bgid << IORING_OFF_PBUF_SHIFT)
  *			to get a virtual mapping for the ring.
  */
-enum {
+enum io_uring_register_pbuf_ring_flags {
 	IOU_PBUF_RING_MMAP	= 1,
 };
 
@@ -714,7 +712,7 @@ struct io_uring_napi {
 /*
  * io_uring_restriction->opcode values
  */
-enum {
+enum io_uring_register_restrictions {
 	/* Allow an io_uring_register(2) opcode */
 	IORING_RESTRICTION_REGISTER_OP		= 0,
 
@@ -768,7 +766,7 @@ struct io_uring_recvmsg_out {
 /*
  * Argument for IORING_OP_URING_CMD when file is a socket
  */
-enum {
+enum io_uring_socket_op {
 	SOCKET_URING_OP_SIOCINQ		= 0,
 	SOCKET_URING_OP_SIOCOUTQ,
 	SOCKET_URING_OP_GETSOCKOPT,
-- 
2.44.0


