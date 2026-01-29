Return-Path: <io-uring+bounces-11980-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qD97JG7be2noIwIAu9opvQ
	(envelope-from <io-uring+bounces-11980-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 29 Jan 2026 23:13:02 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DA951B5359
	for <lists+io-uring@lfdr.de>; Thu, 29 Jan 2026 23:13:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E1C143007AD9
	for <lists+io-uring@lfdr.de>; Thu, 29 Jan 2026 22:12:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 425AA36A004;
	Thu, 29 Jan 2026 22:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="HsMeNVkw";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="jd96ovGf";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="HsMeNVkw";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="jd96ovGf"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5CC1326922
	for <io-uring@vger.kernel.org>; Thu, 29 Jan 2026 22:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769724779; cv=none; b=VbFDOaTbwN8SeFcz4TQ8/Uc2I2O73vgVnmigswaczP4ZbO1ZH1yVXhfbiTDV7F4pj7ftE8bvl21hWc6/4/S8uVS7bzKPO50wpwtgt4Kv/8xnEQg0p8OVqSNoCKFaJDh8/0Z/wu0y3KDYpinp3/xyemIbxmZQDguEuQoV5I3LRMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769724779; c=relaxed/simple;
	bh=JrZOG7376h9iFqSo1Yg6mvvHzPp8uGenTXORCoN8KQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=puT5xw30tXQh3luvbVa26dGxiPR/rco11CoPWbBNdk0cimAD+lHjIwUwb9sKYJrrCsHQyL+2Ir1vGfGLis838oBJX8ke02UnpkGyIb1Kq735m5XpetxEM2WnRZEUuOiKc8/GP0FEXvRSqAMBhzIx+QyqBWtskHKLuuAM9KfCsiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=HsMeNVkw; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=jd96ovGf; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=HsMeNVkw; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=jd96ovGf; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6233E34363;
	Thu, 29 Jan 2026 22:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769724763; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OuLVFjSbwKOShraZP6Rjg2j7COTq7NCewUMG0xiM65k=;
	b=HsMeNVkwmH+q+l/zntSP457B4zoDpWsL+xs+MMOkHxO2GpNPrahRCHEFskZksIHB+XOchy
	Ng4mpSG+FxqAVtoYNQ6zA0F+x1MDB98zG31dUzGNWWrcc3xBHISUTZw+NxFd4ipzMwyjPm
	U3RyhDqMZBNokNO0wovI8mZlhG1j/9I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769724763;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OuLVFjSbwKOShraZP6Rjg2j7COTq7NCewUMG0xiM65k=;
	b=jd96ovGfdheiocuc1m5CJQwh4WxihQqFLMYPkcVjHPFrbCU00TWLJzMoImi2owdK4xLGc1
	Zoecrmar+Yi3ybBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769724763; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OuLVFjSbwKOShraZP6Rjg2j7COTq7NCewUMG0xiM65k=;
	b=HsMeNVkwmH+q+l/zntSP457B4zoDpWsL+xs+MMOkHxO2GpNPrahRCHEFskZksIHB+XOchy
	Ng4mpSG+FxqAVtoYNQ6zA0F+x1MDB98zG31dUzGNWWrcc3xBHISUTZw+NxFd4ipzMwyjPm
	U3RyhDqMZBNokNO0wovI8mZlhG1j/9I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769724763;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OuLVFjSbwKOShraZP6Rjg2j7COTq7NCewUMG0xiM65k=;
	b=jd96ovGfdheiocuc1m5CJQwh4WxihQqFLMYPkcVjHPFrbCU00TWLJzMoImi2owdK4xLGc1
	Zoecrmar+Yi3ybBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1BD993EA61;
	Thu, 29 Jan 2026 22:12:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UHOdAFvbe2kvcAAAD6G6ig
	(envelope-from <krisman@suse.de>); Thu, 29 Jan 2026 22:12:43 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH liburing 1/2] liburing: Add support to IORING_OP_MMAP
Date: Thu, 29 Jan 2026 17:12:35 -0500
Message-ID: <20260129221236.898135-2-krisman@suse.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260129221236.898135-1-krisman@suse.de>
References: <20260129221236.898135-1-krisman@suse.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11980-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-0.999];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DA951B5359
X-Rspamd-Action: no action

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 src/include/liburing.h          |  8 ++++++++
 src/include/liburing/io_uring.h | 10 ++++++++++
 src/liburing-ffi.map            |  2 ++
 3 files changed, 20 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 861e9673..903c60b7 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -1669,6 +1669,14 @@ IOURINGINLINE void io_uring_prep_pipe(struct io_uring_sqe *sqe, int *fds,
 	sqe->pipe_flags = (__u32) pipe_flags;
 }
 
+IOURINGINLINE void io_uring_prep_mmap(struct io_uring_sqe *sqe, int fd,
+				      struct io_uring_mmap_desc *descs,
+				      int nr_maps, int flags)
+{
+	io_uring_prep_rw(IORING_OP_MMAP, sqe, fd, descs, nr_maps, 0);
+	sqe->mmap_flags = flags;
+}
+
 /* setup pipe directly into the fixed file table */
 IOURINGINLINE void io_uring_prep_pipe_direct(struct io_uring_sqe *sqe, int *fds,
 					     int pipe_flags,
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 3e88e796..2e1ac37d 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -74,6 +74,7 @@ struct io_uring_sqe {
 		__u32		install_fd_flags;
 		__u32		nop_flags;
 		__u32		pipe_flags;
+		__u32		mmap_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	/* pack this to avoid bogus arm OABI complaints */
@@ -311,6 +312,7 @@ enum io_uring_op {
 	IORING_OP_PIPE,
 	IORING_OP_NOP128,
 	IORING_OP_URING_CMD128,
+	IORING_OP_MMAP,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
@@ -1069,6 +1071,14 @@ struct io_uring_zcrx_ifq_reg {
 	__u64	__resv[3];
 };
 
+struct io_uring_mmap_desc {
+	void *addr;
+	unsigned long len;
+	unsigned long pgoff;
+	unsigned int prot;
+	unsigned int flags;
+};
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/src/liburing-ffi.map b/src/liburing-ffi.map
index 7202ffd0..b16de5aa 100644
--- a/src/liburing-ffi.map
+++ b/src/liburing-ffi.map
@@ -264,4 +264,6 @@ LIBURING_2.13 {
 LIBURING_2.14 {
 	global:
 		io_uring_register_task_restrictions;
+		io_uring_prep_mmap;
+
 } LIBURING_2.13;
-- 
2.52.0


