Return-Path: <io-uring+bounces-1336-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8653789267F
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 22:57:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B882C1C20FA2
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 21:57:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17D5239FD6;
	Fri, 29 Mar 2024 21:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Jcgl+STJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="awVAF/Uo"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CDBE28DCA
	for <io-uring@vger.kernel.org>; Fri, 29 Mar 2024 21:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711749450; cv=none; b=FBwNA8lgyO3OWvkzxepIcGBWUwBZ/DPDCqco7aMP4nIWDK+IMWYFUibIBLRx7FeCm3nZ9qx8RnU3wwT1+s7iLWZed0lZVahTUhJQthzQ5xwFgL1ix+S1GhD1fBqSuAftvg/hpjvQJlxdll9bVBoHl4+C7eRoVTzjkYnzyh38eo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711749450; c=relaxed/simple;
	bh=fSwH55OeWKbayUGTLyEhVZG3AiFUUaYkSyA3gNY16h4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TIGJmnMFrJOAMOMda03errZgoCqm7iEM80K3Nw4HKDgz5Ov5K7Vritz8aiydEzfHQpHUyfLAR+daIFeG1AuDp9XTh23AfPDl2Fc/ApP8T1lInsDp33FTSfohXrgQa0QoUqpPbiyPELgg6ljwLgj4cSqGNNf8/5VcksG9qOaabL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Jcgl+STJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=awVAF/Uo; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 23B9E35361;
	Fri, 29 Mar 2024 21:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1711749446; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=6p+Y9TEfnPR2yEHKmM+vJ3AptBwPcPIFtjLLBOhO/Z0=;
	b=Jcgl+STJFi+ZRUmepvl+uBIMP9Jtc/7qpMjeflMQo1uqdUF9dSaHLmYMyxGfRILX+wYZ2r
	vn2P4qAthAwlK5bYNgvM45I7+A2j2MCzblURmyKAo2/afr7Ag7gcGXdQ75tiedwKCtHpcP
	tb1YXji6OMwkeh03YCskCaqp+hGfQlw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1711749446;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=6p+Y9TEfnPR2yEHKmM+vJ3AptBwPcPIFtjLLBOhO/Z0=;
	b=awVAF/UoBRDEif2lOTJFCQyCK1mfENuQtV8jtY/PzydZDoDNX7Fnpc1T1vJ8cX0wOIBgOn
	oaLgrQHVOh7Ls+Bw==
Authentication-Results: smtp-out1.suse.de;
	dkim=none
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id DFA5513A89;
	Fri, 29 Mar 2024 21:57:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id pY+GMEU5B2aRUgAAn2gu4w
	(envelope-from <krisman@suse.de>); Fri, 29 Mar 2024 21:57:25 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH liburing] io_uring.h: Sync kernel header to fetch enum names
Date: Fri, 29 Mar 2024 17:57:18 -0400
Message-ID: <20240329215718.25048-1-krisman@suse.de>
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
X-Spamd-Result: default: False [1.19 / 50.00];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.18)[-0.912];
	MIME_GOOD(-0.10)[text/plain];
	BAYES_HAM(-0.02)[52.67%];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	R_DKIM_NA(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:98:from];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[]
X-Spamd-Bar: +
X-Spam-Score: 1.19
X-Spam-Level: *
X-Rspamd-Queue-Id: 23B9E35361

After a report by Ritesh (YoSTEALTH) on github, we named the enums in
the io_uring uapi header.  Sync the change into liburing.

[1] https://github.com/cython/cython/issues/3240.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>

---
Do we want to sync with the kernel header?
---
 src/include/liburing/io_uring.h | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index bde1199..25e83e1 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -115,7 +115,7 @@ struct io_uring_sqe {
  */
 #define IORING_FILE_INDEX_ALLOC		(~0U)
 
-enum {
+enum io_uring_sqe_flags_bit {
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
+enum io_uring_register_restriction_op {
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


