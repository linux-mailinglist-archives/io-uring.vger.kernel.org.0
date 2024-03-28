Return-Path: <io-uring+bounces-1304-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 599ED890C45
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 22:09:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1098D2A862A
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 21:09:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA41A12F385;
	Thu, 28 Mar 2024 21:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Z0sID2Cz";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="cR3JNJKy"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C8B2EAE9
	for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 21:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711660182; cv=none; b=Z0wFmMcEd86cfELBl5DLcxHss7sDTE5Q3OTIes4jztrqcX/OVh+1p5vdm+dThPqOnW3E5qJBXIdSXl2FPGos6KP2HF20tnCzO9ugL7aCWvbDQRH06XDUM4Qx9S4hMqqNvTu8j9WEu66ryT8sNCTPfBL3tEX+SF3/thgof/4gdSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711660182; c=relaxed/simple;
	bh=OZjAqKCP9JJ4WdxMOuJmwic0hmfMYbBp5vPm5tx/gfc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kFQpB52XkEt9QvH2bu9SbTIWPArcSxrqPJqGDAIit13DohgYjojzWFcXUSo9Mx6gWCXtRVwOAVF0iXATZTJByyv15pFodiJm+FO4h4LGujhnObiTha2vMd7lYH/jZIyM/6AZ06yETHjlpmN6dxBLDht8DagWeP4eylsCtBKkSrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Z0sID2Cz; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=cR3JNJKy; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0BB7220F09;
	Thu, 28 Mar 2024 21:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1711660179; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=pjkjGtkSPUBP1Dgkdujx6hpbhoQtzHbUeWSX8WVmmvY=;
	b=Z0sID2CzEfptJOQczoPNbpMEmmVbg4JBBv3zgDMmGsg5aO5BOawqDfKIG87dSHrzs+IZ0N
	VvxvJA9DrepGha5VmYyU3Ujr00g0sHvq36Ud9mApxXHau0maPgttodSTjiyLVIQk8yT0pb
	IkeKhsLCk17ZyEJclE3DQU5+gyI/QK4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1711660179;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=pjkjGtkSPUBP1Dgkdujx6hpbhoQtzHbUeWSX8WVmmvY=;
	b=cR3JNJKyvU1gT1I9CxjqAw2A/PPVwdoypYBYSdWUNXMdYxFzQEZQdN+wuC0NQn9Z8+Mvrx
	4fxtdedys9NCXCBA==
Authentication-Results: smtp-out2.suse.de;
	dkim=none
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id C63CE13A94;
	Thu, 28 Mar 2024 21:09:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id 1fciKpLcBWZ+TQAAn2gu4w
	(envelope-from <krisman@suse.de>); Thu, 28 Mar 2024 21:09:38 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH] io_uring: Avoid anonymous enums in io_uring uapi
Date: Thu, 28 Mar 2024 17:09:35 -0400
Message-ID: <20240328210935.25640-1-krisman@suse.de>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [1.13 / 50.00];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	BAYES_HAM(-0.06)[61.08%];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:98:from];
	R_DKIM_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	RCVD_TLS_ALL(0.00)[]
X-Spamd-Bar: +
X-Spam-Score: 1.13
X-Spam-Level: *
X-Rspamd-Queue-Id: 0BB7220F09

While valid C, anonymous enums confuse Cython (Python to C translator),
as reported by Ritesh (YoSTEALTH) [1] .  Since people rely on it when
building against liburing and we want to keep this header in sync with
the library version, let's name the existing enums in the uapi header.

[1] https://github.com/cython/cython/issues/3240

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 include/uapi/linux/io_uring.h | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 7bd10201a02b..a7f847543a7f 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -115,7 +115,7 @@ struct io_uring_sqe {
  */
 #define IORING_FILE_INDEX_ALLOC		(~0U)
 
-enum {
+enum io_uring_sqe_flags_bit {
 	IOSQE_FIXED_FILE_BIT,
 	IOSQE_IO_DRAIN_BIT,
 	IOSQE_IO_LINK_BIT,
@@ -374,7 +374,7 @@ enum io_uring_op {
 /*
  * IORING_OP_MSG_RING command types, stored in sqe->addr
  */
-enum {
+enum io_uring_msg_ring_flags {
 	IORING_MSG_DATA,	/* pass sqe->len as 'res' and off as user_data */
 	IORING_MSG_SEND_FD,	/* send a registered fd to another ring */
 };
@@ -425,9 +425,7 @@ struct io_uring_cqe {
 #define IORING_CQE_F_SOCK_NONEMPTY	(1U << 2)
 #define IORING_CQE_F_NOTIF		(1U << 3)
 
-enum {
-	IORING_CQE_BUFFER_SHIFT		= 16,
-};
+#define IORING_CQE_BUFFER_SHIFT		16
 
 /*
  * Magic offsets for the application to mmap the data it needs
@@ -526,7 +524,7 @@ struct io_uring_params {
 /*
  * io_uring_register(2) opcodes and arguments
  */
-enum {
+enum io_uring_register_op {
 	IORING_REGISTER_BUFFERS			= 0,
 	IORING_UNREGISTER_BUFFERS		= 1,
 	IORING_REGISTER_FILES			= 2,
@@ -583,7 +581,7 @@ enum {
 };
 
 /* io-wq worker categories */
-enum {
+enum io_wq_type {
 	IO_WQ_BOUND,
 	IO_WQ_UNBOUND,
 };
@@ -688,7 +686,7 @@ struct io_uring_buf_ring {
  *			IORING_OFF_PBUF_RING | (bgid << IORING_OFF_PBUF_SHIFT)
  *			to get a virtual mapping for the ring.
  */
-enum {
+enum io_uring_register_pbuf_ring_flags {
 	IOU_PBUF_RING_MMAP	= 1,
 };
 
@@ -719,7 +717,7 @@ struct io_uring_napi {
 /*
  * io_uring_restriction->opcode values
  */
-enum {
+enum io_uring_register_restriction_op {
 	/* Allow an io_uring_register(2) opcode */
 	IORING_RESTRICTION_REGISTER_OP		= 0,
 
@@ -775,7 +773,7 @@ struct io_uring_recvmsg_out {
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


