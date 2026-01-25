Return-Path: <io-uring+bounces-11918-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SFROGhLMdWnVIgEAu9opvQ
	(envelope-from <io-uring+bounces-11918-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 25 Jan 2026 08:53:54 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B160C7FFE3
	for <lists+io-uring@lfdr.de>; Sun, 25 Jan 2026 08:53:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1F5B13008D21
	for <lists+io-uring@lfdr.de>; Sun, 25 Jan 2026 07:53:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED7F3226CEB;
	Sun, 25 Jan 2026 07:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XaSKuXIq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f65.google.com (mail-oo1-f65.google.com [209.85.161.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9331818AFD
	for <io-uring@vger.kernel.org>; Sun, 25 Jan 2026 07:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769327627; cv=none; b=L+vEDpOuGpX61RGH/4elgh8OCVdsJ+dVZAHAKVZwkonWCRPOMEhpGkZEcfmDjmxCL5RnMH+ex3iewvAtvSaqoX3IvSTj1z18+cYCSAqWh+Ax+LkDDV71FOaQCezWUBms7tzCPZLYIx6yofw+M4Cc3D/0w9hf4F/MRbRMCjFXQfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769327627; c=relaxed/simple;
	bh=y9Pi1sKe68oODiWAUWccViyCxgEMk25r1TDK30DicS8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HgaksGJO6hklVa/GoDawhxhL5VGPYQyCugsuKpb9tB49CQzKnEpbm311rLHRPz6PbIIKk3mKmrGN61RaRP4gGdbG9HyncLObIjJNyfXFcNNycyz1Zuw77jL8unASkJN5wsDOlUSdbGueCOcsV8sqbYMCAdXn9SGyWxM7+pJ5Q5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XaSKuXIq; arc=none smtp.client-ip=209.85.161.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f65.google.com with SMTP id 006d021491bc7-66113013158so137398eaf.0
        for <io-uring@vger.kernel.org>; Sat, 24 Jan 2026 23:53:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769327624; x=1769932424; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hHMac+Y7jUcS3qG21NW9q7VLIIJKSsv5RU/hi8sm4Dk=;
        b=XaSKuXIqLzuuDVe09TH1gRnMAQxnBCPgd8Zrp9aZjHQaPs/PblqLRFdbv9Nd2g0Kfv
         PbWzaNFixSgmFSm/cim0iNj15teIRDmCzhoQzGcZzo4qykRDB5ftbk+mK7WeS5dJxjYz
         LTIHwveg9B857WO2t3JmBdxKt2nNTiaVfurWz6pS8AtP6teDJsCJfJZl+laSrZ0ugWPj
         bicNRGscHxDA+2NhzGZjHfoDKkhHJfz+vY+ODTJIxQb+BTmd2k0eh2C7+n5ZZ3nS1Q/r
         SPo8oRIi7QQJcZMLJ/6kV4ev/A9HL2cxyHoOpSXZw+kjlyHg87y36T2VCyjofb+82SNT
         fi4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769327624; x=1769932424;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hHMac+Y7jUcS3qG21NW9q7VLIIJKSsv5RU/hi8sm4Dk=;
        b=Er9c9VdRo7mVCavhtSxpSWI58Qr8yRQyfSdPcsZNIKU2Abz+UOxBTyK6/56vwL+GH1
         Q7mJBckhMqurUpeNJtBBIeU+jelqBHb1Um6d1+PtbWFa3bU7SFNXgiQJTf3d68OUA40P
         nL8how/TEC/ja4coCg6qYN3xA3CwHM4/LjqtsBG0XcT6FDinUnnFOKFQMoKQ++zftsB1
         sT25EIUMEY3EI5+8tGfbsi5keDXa5z84YxrwkKSlFm2BMZN9/oTBQDRuPSGi5HNqIHM1
         BmfCmmk1aP/5eg9dSXk3XRDWpmvhVb4nh2tIExd4B0kzgAx0zmuP2+6YVnKb2ZLXbyon
         VVbQ==
X-Gm-Message-State: AOJu0YxV4L6ZwC9urC61eAmVFI4ZA46bmhMbUg1R0oN1RFKo4PGF7/sa
	6hChO/n+vyT2xJH7KbLCWACPXPrUnOlzwW/hUQ6RbK+9uUqCHu6PRj6j
X-Gm-Gg: AZuq6aKKLUJhv2ttgBwMZ/cobHimLNBFBIpmAHpno1V0x+GbQ8YPhNVf/QGE4ds1J8Z
	+TRT8Ynex6XGYXNurLfqnBPK7uaiRs53WaC08zR/3dVToiaYqEVz08QXFoT0iX5mg2OsNM/RrR8
	tj9Al/t7N2Aju+U+CrCVFFBFWkml7e+T4tKs5rfVcBhgG5t/tvuSOIxiSP4IOp5emzrzbgxNqme
	plHK3zNBCdPOG9LSHdBO5Inu3PkdW6qmaUPsTKUh8hOL7DYTuUHOIUEZGgzO0GMoQD7brZLnVyz
	el0GYaOqg3p969zXNIjlw2pdbyj4yKGYGT1KAM9HfNsnlXo5fNphKoKd8Y9AdSnd4+Cwkdh8XZW
	Kydfquo5zM/cOkkrgCM/broUgHA/a488tNGSJlwtHRIFuP9Zakn1BygdL1J8kAllWc7HkweuVE5
	Pf
X-Received: by 2002:a05:6820:4a18:b0:661:1d11:9a5c with SMTP id 006d021491bc7-662e045d8f5mr382989eaf.1.1769327624253;
        Sat, 24 Jan 2026 23:53:44 -0800 (PST)
Received: from user.. ([140.235.142.61])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-662cb46b991sm3521920eaf.0.2026.01.24.23.53.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Jan 2026 23:53:43 -0800 (PST)
From: clingfei <clf700383@gmail.com>
X-Google-Original-From: clingfei <1599101385@qq.com>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	clf700383@gmail.com
Subject: [PATCH] io_uring: gate personality per opcode to fix TOCTOU check in io_msg_ring_prep
Date: Sun, 25 Jan 2026 15:53:02 +0800
Message-Id: <20260125075302.621785-1-1599101385@qq.com>
X-Mailer: git-send-email 2.34.1
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-11918-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[clf700383@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[qq.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B160C7FFE3
X-Rspamd-Action: no action

From: Cheng Lingfei <clf700383@gmail.com>

Add allow_personality io_issue_def and reject personality use in
io_init_req for opcodes that do not permit it. This fixes a TOCTOU
window in the prior implementation: userspace could race-update
sqe->personality and bypass the __io_msg_ring_prep personality check.

Signed-off-by: Cheng Lingfei <clf700383@gmail.com>
---
 io_uring/io_uring.c |  2 ++
 io_uring/msg_ring.c |  2 +-
 io_uring/opdef.c    | 64 +++++++++++++++++++++++++++++++++++++++++++++
 io_uring/opdef.h    |  2 ++
 4 files changed, 69 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b7a077c11c21..7a898b19a340 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2219,6 +2219,8 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	personality = READ_ONCE(sqe->personality);
 	if (personality) {
 		int ret;
+		if (unlikely(!def->allow_personality))
+			return -EINVAL;
 
 		req->creds = xa_load(&ctx->personalities, personality);
 		if (!req->creds)
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 7063ea7964e7..758635753da6 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -260,7 +260,7 @@ static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
 
 static int __io_msg_ring_prep(struct io_msg *msg, const struct io_uring_sqe *sqe)
 {
-	if (unlikely(sqe->buf_index || sqe->personality))
+	if (unlikely(sqe->buf_index))
 		return -EINVAL;
 
 	msg->src_file = NULL;
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index df52d760240e..ee2dfc673fdf 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -55,6 +55,7 @@ const struct io_issue_def io_issue_defs[] = {
 	[IORING_OP_NOP] = {
 		.audit_skip		= 1,
 		.iopoll			= 1,
+		.allow_personality = 1,
 		.prep			= io_nop_prep,
 		.issue			= io_nop,
 	},
@@ -69,6 +70,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
 		.vectored		= 1,
+		.allow_personality = 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.prep			= io_prep_readv,
 		.issue			= io_read,
@@ -84,6 +86,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
 		.vectored		= 1,
+		.allow_personality = 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.prep			= io_prep_writev,
 		.issue			= io_write,
@@ -91,6 +94,7 @@ const struct io_issue_def io_issue_defs[] = {
 	[IORING_OP_FSYNC] = {
 		.needs_file		= 1,
 		.audit_skip		= 1,
+		.allow_personality = 1,
 		.prep			= io_fsync_prep,
 		.issue			= io_fsync,
 	},
@@ -103,6 +107,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.ioprio			= 1,
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
+		.allow_personality = 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.prep			= io_prep_read_fixed,
 		.issue			= io_read_fixed,
@@ -117,6 +122,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.ioprio			= 1,
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
+		.allow_personality = 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.prep			= io_prep_write_fixed,
 		.issue			= io_write_fixed,
@@ -125,17 +131,20 @@ const struct io_issue_def io_issue_defs[] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.audit_skip		= 1,
+		.allow_personality = 1,
 		.prep			= io_poll_add_prep,
 		.issue			= io_poll_add,
 	},
 	[IORING_OP_POLL_REMOVE] = {
 		.audit_skip		= 1,
+		.allow_personality = 1,
 		.prep			= io_poll_remove_prep,
 		.issue			= io_poll_remove,
 	},
 	[IORING_OP_SYNC_FILE_RANGE] = {
 		.needs_file		= 1,
 		.audit_skip		= 1,
+		.allow_personality = 1,
 		.prep			= io_sfr_prep,
 		.issue			= io_sync_file_range,
 	},
@@ -144,6 +153,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
 		.ioprio			= 1,
+		.allow_personality = 1,
 #if defined(CONFIG_NET)
 		.async_size		= sizeof(struct io_async_msghdr),
 		.prep			= io_sendmsg_prep,
@@ -158,6 +168,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.pollin			= 1,
 		.buffer_select		= 1,
 		.ioprio			= 1,
+		.allow_personality = 1,
 #if defined(CONFIG_NET)
 		.async_size		= sizeof(struct io_async_msghdr),
 		.prep			= io_recvmsg_prep,
@@ -168,6 +179,7 @@ const struct io_issue_def io_issue_defs[] = {
 	},
 	[IORING_OP_TIMEOUT] = {
 		.audit_skip		= 1,
+		.allow_personality = 1,
 		.async_size		= sizeof(struct io_timeout_data),
 		.prep			= io_timeout_prep,
 		.issue			= io_timeout,
@@ -175,6 +187,7 @@ const struct io_issue_def io_issue_defs[] = {
 	[IORING_OP_TIMEOUT_REMOVE] = {
 		/* used by timeout updates' prep() */
 		.audit_skip		= 1,
+		.allow_personality = 1,
 		.prep			= io_timeout_remove_prep,
 		.issue			= io_timeout_remove,
 	},
@@ -184,6 +197,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.pollin			= 1,
 		.poll_exclusive		= 1,
 		.ioprio			= 1,	/* used for flags */
+		.allow_personality = 1,
 #if defined(CONFIG_NET)
 		.prep			= io_accept_prep,
 		.issue			= io_accept,
@@ -193,11 +207,13 @@ const struct io_issue_def io_issue_defs[] = {
 	},
 	[IORING_OP_ASYNC_CANCEL] = {
 		.audit_skip		= 1,
+		.allow_personality = 1,
 		.prep			= io_async_cancel_prep,
 		.issue			= io_async_cancel,
 	},
 	[IORING_OP_LINK_TIMEOUT] = {
 		.audit_skip		= 1,
+		.allow_personality = 1,
 		.async_size		= sizeof(struct io_timeout_data),
 		.prep			= io_link_timeout_prep,
 		.issue			= io_no_issue,
@@ -206,6 +222,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
+		.allow_personality = 1,
 #if defined(CONFIG_NET)
 		.async_size		= sizeof(struct io_async_msghdr),
 		.prep			= io_connect_prep,
@@ -217,25 +234,30 @@ const struct io_issue_def io_issue_defs[] = {
 	[IORING_OP_FALLOCATE] = {
 		.needs_file		= 1,
 		.hash_reg_file          = 1,
+		.allow_personality = 1,
 		.prep			= io_fallocate_prep,
 		.issue			= io_fallocate,
 	},
 	[IORING_OP_OPENAT] = {
+		.allow_personality = 1,
 		.prep			= io_openat_prep,
 		.issue			= io_openat,
 	},
 	[IORING_OP_CLOSE] = {
+		.allow_personality = 1,
 		.prep			= io_close_prep,
 		.issue			= io_close,
 	},
 	[IORING_OP_FILES_UPDATE] = {
 		.audit_skip		= 1,
 		.iopoll			= 1,
+		.allow_personality = 1,
 		.prep			= io_files_update_prep,
 		.issue			= io_files_update,
 	},
 	[IORING_OP_STATX] = {
 		.audit_skip		= 1,
+		.allow_personality = 1,
 		.prep			= io_statx_prep,
 		.issue			= io_statx,
 	},
@@ -249,6 +271,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.ioprio			= 1,
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
+		.allow_personality = 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.prep			= io_prep_read,
 		.issue			= io_read,
@@ -263,6 +286,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.ioprio			= 1,
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
+		.allow_personality = 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.prep			= io_prep_write,
 		.issue			= io_write,
@@ -270,11 +294,13 @@ const struct io_issue_def io_issue_defs[] = {
 	[IORING_OP_FADVISE] = {
 		.needs_file		= 1,
 		.audit_skip		= 1,
+		.allow_personality = 1,
 		.prep			= io_fadvise_prep,
 		.issue			= io_fadvise,
 	},
 	[IORING_OP_MADVISE] = {
 		.audit_skip		= 1,
+		.allow_personality = 1,
 		.prep			= io_madvise_prep,
 		.issue			= io_madvise,
 	},
@@ -285,6 +311,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.audit_skip		= 1,
 		.ioprio			= 1,
 		.buffer_select		= 1,
+		.allow_personality = 1,
 #if defined(CONFIG_NET)
 		.async_size		= sizeof(struct io_async_msghdr),
 		.prep			= io_sendmsg_prep,
@@ -300,6 +327,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.buffer_select		= 1,
 		.audit_skip		= 1,
 		.ioprio			= 1,
+		.allow_personality = 1,
 #if defined(CONFIG_NET)
 		.async_size		= sizeof(struct io_async_msghdr),
 		.prep			= io_recvmsg_prep,
@@ -309,12 +337,14 @@ const struct io_issue_def io_issue_defs[] = {
 #endif
 	},
 	[IORING_OP_OPENAT2] = {
+		.allow_personality = 1,
 		.prep			= io_openat2_prep,
 		.issue			= io_openat2,
 	},
 	[IORING_OP_EPOLL_CTL] = {
 		.unbound_nonreg_file	= 1,
 		.audit_skip		= 1,
+		.allow_personality = 1,
 #if defined(CONFIG_EPOLL)
 		.prep			= io_epoll_ctl_prep,
 		.issue			= io_epoll_ctl,
@@ -327,18 +357,21 @@ const struct io_issue_def io_issue_defs[] = {
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.audit_skip		= 1,
+		.allow_personality = 1,
 		.prep			= io_splice_prep,
 		.issue			= io_splice,
 	},
 	[IORING_OP_PROVIDE_BUFFERS] = {
 		.audit_skip		= 1,
 		.iopoll			= 1,
+		.allow_personality = 1,
 		.prep			= io_provide_buffers_prep,
 		.issue			= io_manage_buffers_legacy,
 	},
 	[IORING_OP_REMOVE_BUFFERS] = {
 		.audit_skip		= 1,
 		.iopoll			= 1,
+		.allow_personality = 1,
 		.prep			= io_remove_buffers_prep,
 		.issue			= io_manage_buffers_legacy,
 	},
@@ -347,11 +380,13 @@ const struct io_issue_def io_issue_defs[] = {
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.audit_skip		= 1,
+		.allow_personality = 1,
 		.prep			= io_tee_prep,
 		.issue			= io_tee,
 	},
 	[IORING_OP_SHUTDOWN] = {
 		.needs_file		= 1,
+		.allow_personality = 1,
 #if defined(CONFIG_NET)
 		.prep			= io_shutdown_prep,
 		.issue			= io_shutdown,
@@ -360,22 +395,27 @@ const struct io_issue_def io_issue_defs[] = {
 #endif
 	},
 	[IORING_OP_RENAMEAT] = {
+		.allow_personality = 1,
 		.prep			= io_renameat_prep,
 		.issue			= io_renameat,
 	},
 	[IORING_OP_UNLINKAT] = {
+		.allow_personality = 1,
 		.prep			= io_unlinkat_prep,
 		.issue			= io_unlinkat,
 	},
 	[IORING_OP_MKDIRAT] = {
+		.allow_personality = 1,
 		.prep			= io_mkdirat_prep,
 		.issue			= io_mkdirat,
 	},
 	[IORING_OP_SYMLINKAT] = {
+		.allow_personality = 1,
 		.prep			= io_symlinkat_prep,
 		.issue			= io_symlinkat,
 	},
 	[IORING_OP_LINKAT] = {
+		.allow_personality = 1,
 		.prep			= io_linkat_prep,
 		.issue			= io_linkat,
 	},
@@ -387,24 +427,29 @@ const struct io_issue_def io_issue_defs[] = {
 	},
 	[IORING_OP_FSETXATTR] = {
 		.needs_file = 1,
+		.allow_personality = 1,
 		.prep			= io_fsetxattr_prep,
 		.issue			= io_fsetxattr,
 	},
 	[IORING_OP_SETXATTR] = {
+		.allow_personality = 1,
 		.prep			= io_setxattr_prep,
 		.issue			= io_setxattr,
 	},
 	[IORING_OP_FGETXATTR] = {
 		.needs_file = 1,
+		.allow_personality = 1,
 		.prep			= io_fgetxattr_prep,
 		.issue			= io_fgetxattr,
 	},
 	[IORING_OP_GETXATTR] = {
+		.allow_personality = 1,
 		.prep			= io_getxattr_prep,
 		.issue			= io_getxattr,
 	},
 	[IORING_OP_SOCKET] = {
 		.audit_skip		= 1,
+		.allow_personality = 1,
 #if defined(CONFIG_NET)
 		.prep			= io_socket_prep,
 		.issue			= io_socket,
@@ -418,6 +463,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.plug			= 1,
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
+		.allow_personality = 1,
 		.async_size		= sizeof(struct io_async_cmd),
 		.prep			= io_uring_cmd_prep,
 		.issue			= io_uring_cmd,
@@ -428,6 +474,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.pollout		= 1,
 		.audit_skip		= 1,
 		.ioprio			= 1,
+		.allow_personality = 1,
 #if defined(CONFIG_NET)
 		.async_size		= sizeof(struct io_async_msghdr),
 		.prep			= io_send_zc_prep,
@@ -441,6 +488,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
 		.ioprio			= 1,
+		.allow_personality = 1,
 #if defined(CONFIG_NET)
 		.async_size		= sizeof(struct io_async_msghdr),
 		.prep			= io_send_zc_prep,
@@ -455,16 +503,19 @@ const struct io_issue_def io_issue_defs[] = {
 		.pollin			= 1,
 		.buffer_select		= 1,
 		.audit_skip		= 1,
+		.allow_personality = 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.prep			= io_read_mshot_prep,
 		.issue			= io_read_mshot,
 	},
 	[IORING_OP_WAITID] = {
+		.allow_personality = 1,
 		.async_size		= sizeof(struct io_waitid_async),
 		.prep			= io_waitid_prep,
 		.issue			= io_waitid,
 	},
 	[IORING_OP_FUTEX_WAIT] = {
+		.allow_personality = 1,
 #if defined(CONFIG_FUTEX)
 		.prep			= io_futex_prep,
 		.issue			= io_futex_wait,
@@ -473,6 +524,7 @@ const struct io_issue_def io_issue_defs[] = {
 #endif
 	},
 	[IORING_OP_FUTEX_WAKE] = {
+		.allow_personality = 1,
 #if defined(CONFIG_FUTEX)
 		.prep			= io_futex_prep,
 		.issue			= io_futex_wake,
@@ -481,6 +533,7 @@ const struct io_issue_def io_issue_defs[] = {
 #endif
 	},
 	[IORING_OP_FUTEX_WAITV] = {
+		.allow_personality = 1,
 #if defined(CONFIG_FUTEX)
 		.prep			= io_futexv_prep,
 		.issue			= io_futexv_wait,
@@ -490,16 +543,19 @@ const struct io_issue_def io_issue_defs[] = {
 	},
 	[IORING_OP_FIXED_FD_INSTALL] = {
 		.needs_file		= 1,
+		.allow_personality = 1,
 		.prep			= io_install_fixed_fd_prep,
 		.issue			= io_install_fixed_fd,
 	},
 	[IORING_OP_FTRUNCATE] = {
 		.needs_file		= 1,
 		.hash_reg_file		= 1,
+		.allow_personality = 1,
 		.prep			= io_ftruncate_prep,
 		.issue			= io_ftruncate,
 	},
 	[IORING_OP_BIND] = {
+		.allow_personality = 1,
 #if defined(CONFIG_NET)
 		.needs_file		= 1,
 		.prep			= io_bind_prep,
@@ -510,6 +566,7 @@ const struct io_issue_def io_issue_defs[] = {
 #endif
 	},
 	[IORING_OP_LISTEN] = {
+		.allow_personality = 1,
 #if defined(CONFIG_NET)
 		.needs_file		= 1,
 		.prep			= io_listen_prep,
@@ -524,6 +581,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.unbound_nonreg_file	= 1,
 		.pollin			= 1,
 		.ioprio			= 1,
+		.allow_personality = 1,
 #if defined(CONFIG_NET)
 		.prep			= io_recvzc_prep,
 		.issue			= io_recvzc,
@@ -535,6 +593,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.needs_file		= 1,
 		.audit_skip		= 1,
 		.pollin			= 1,
+		.allow_personality = 1,
 #if defined(CONFIG_EPOLL)
 		.prep			= io_epoll_wait_prep,
 		.issue			= io_epoll_wait,
@@ -552,6 +611,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
 		.vectored		= 1,
+		.allow_personality = 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.prep			= io_prep_readv_fixed,
 		.issue			= io_read,
@@ -567,11 +627,13 @@ const struct io_issue_def io_issue_defs[] = {
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
 		.vectored		= 1,
+		.allow_personality = 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.prep			= io_prep_writev_fixed,
 		.issue			= io_write,
 	},
 	[IORING_OP_PIPE] = {
+		.allow_personality = 1,
 		.prep			= io_pipe_prep,
 		.issue			= io_pipe,
 	},
@@ -579,6 +641,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.audit_skip		= 1,
 		.iopoll			= 1,
 		.is_128			= 1,
+		.allow_personality = 1,
 		.prep			= io_nop_prep,
 		.issue			= io_nop,
 	},
@@ -589,6 +652,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.iopoll			= 1,
 		.iopoll_queue		= 1,
 		.is_128			= 1,
+		.allow_personality = 1,
 		.async_size		= sizeof(struct io_async_cmd),
 		.prep			= io_uring_cmd_prep,
 		.issue			= io_uring_cmd,
diff --git a/io_uring/opdef.h b/io_uring/opdef.h
index aa37846880ff..f4a98339aa79 100644
--- a/io_uring/opdef.h
+++ b/io_uring/opdef.h
@@ -29,6 +29,8 @@ struct io_issue_def {
 	unsigned		vectored : 1;
 	/* set to 1 if this opcode uses 128b sqes in a mixed sq */
 	unsigned		is_128 : 1;
+	/* set to 1 if this opcode allows using personality */
+	unsigned    allow_personality : 1;
 
 	/* size of async data needed, if any */
 	unsigned short		async_size;
-- 
2.34.1


