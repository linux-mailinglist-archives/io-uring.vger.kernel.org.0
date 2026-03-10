Return-Path: <io-uring+bounces-12622-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wIvgCqw/sGkehgIAu9opvQ
	(envelope-from <io-uring+bounces-12622-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 16:58:36 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DB0D5254261
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 16:58:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4516E32F62BA
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2026 15:51:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 528C63A9620;
	Tue, 10 Mar 2026 15:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dGC1na4u"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886623AB26C
	for <io-uring@vger.kernel.org>; Tue, 10 Mar 2026 15:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773157798; cv=none; b=Cssp/kgHsFsDWt4bslOVXZZrY7DM16mZ2ziN0fOmsNNP1dIQ7NvRJ0l24SGJj2yIv7mdoDdY3qsf+UFWeil9B5gSgdClOJM+Pl4EpBc9mm/Yi6+XHBpzD6eTxVV1BCF6yCiFqVDlH2fgAs+x4gxjQpUwwBFjblVA6M3Pnh5aN8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773157798; c=relaxed/simple;
	bh=pa9LJ0pr5lucMOeQ501Q9Nc8bA1N5kBQmGw4H6ApFuo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LtU6Texa8jWgl96WNC3x0mcQhsDs3ahlY6mL0c+8tQFBHanYzk6pMbeMkB67Cry37CzFSBejlvasYp7ReUoE7NaGI3aWVhrfyLhavWutxl/mkmfg62iO+uWvSRV/CTptN6MexIi1YIcHzLOiWCJECs0UDlnk75w/HN86sDpNpLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dGC1na4u; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4852a8482fcso36580155e9.3
        for <io-uring@vger.kernel.org>; Tue, 10 Mar 2026 08:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773157793; x=1773762593; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qFGIcPCn0jLzCB0nuP8rkEVjzYjjNEyY+O+yewiFaGc=;
        b=dGC1na4u/PdQOzEVEQp6H/BiS+jxLKOgA1BuZjui+Yri/D2ktoDhO258NCiphS+UNK
         Nv/Fk2ChqyOw7LUkpPsIzjIjqeJIip69rJIIkGPA7T1zajA3h9urK5SDz0SA0teXr19w
         Za0WOoqZJZ02O8ACsxFYJ6yGaidN1+yc50aumgnRJgVDDUlZtzzLDOfXM6pFy0IGj6L3
         a211/RGC2kAClMPxPEDQReTaceKgJm785mfz7CSKlta484KPsjhYedCQvnUPIE6u8lFE
         BoSvO/b2YV4F6cj8hntflx5rn6obKzM5rAsfLLx/7FaBsd5nm5U+xJZak93l7RByid7Y
         SxQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773157793; x=1773762593;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qFGIcPCn0jLzCB0nuP8rkEVjzYjjNEyY+O+yewiFaGc=;
        b=WYSZC0Wn0cv8ogmzzFFnNDfvHg4CqqWE5TjgfjQGXI8N1xfc9Cp0iF1980EFnvYpXA
         VlyKUZbKqgDGcoZegc0IbGdijfkp2qDUlZ3yFhovtAC+dsZDg77Mzhfaq+xE08m6jNkU
         oTFDl7mi4u380nc4K4xc44OU5OFq1pCdlFfaNwHCYOC2c1MeifpLJdaD7FK7tVzOCrpn
         /hCYShMPxTihxzA8R7O4t6OJFDI3xG9N0/ZWYCcT9zcmoDdWDtERBKbfxWjm+4k2E1xH
         Xc1+hAhdzLu2DQVKPaYCOrD2Yd24Lth2f7SpqGn1dICOyDM73RDIknvkFJGY3EAWFx4s
         h6wQ==
X-Gm-Message-State: AOJu0Yxiy943bD3dIbFWwLq458f2qwF6a2efhJYUdopl23XHdpGuolKS
	iF4jz7Le03fq7CcPxJRX0bmNvFtWnz6/5dQNXgo+mfUrlGrWP9ZkCL4hWo4m35a2Nvw=
X-Gm-Gg: ATEYQzwOBcL2I3ifyj2TmtIU3Mh9FL5cll4Rh4YaDKgjjydRrXTOg9KUFVMUrSVQZQq
	zabp1aXeiPHe2oNLLFnIJWDB2AoYhjnOQvJqlNv4pRWtQggIbl75CGr0E6SNhFzTPq90nad5LNf
	tPZ5zth8S8Qg2cLluXsXdvE/xXXdv+FxX+cJoGxeuE+r961ZyiCrhyzaJ3eiV1g5lYpktnpWY0S
	odary6c9VhWKOpcsLo+apzLFb/wjdnMl0CDO1nxUdKaaL4j5TFEEonhtBmFIW31iR59bxJDp0OI
	HtNRgMq4x/c+8XgiWVmE5nfhAX6m4Q+A+1jyapXC1LdBxAI01JRL12TQDXfRKWPN7OU69NP7kcz
	lS7QE8J41fmbWLGG7NznU3KrPx/kcOPp1vjMcN/KoSsVlVRhROsxvLoiasXVZpdh6IH2T9+hHDM
	LZpq+KpvCeUEdo1YX9S0Cu+K394EqLv4OsR2b9Jyq41/rew824p2NKMAcc
X-Received: by 2002:a05:600c:348c:b0:480:1c69:9d36 with SMTP id 5b1f17b1804b1-4852695941dmr255039845e9.17.1773157793324;
        Tue, 10 Mar 2026 08:49:53 -0700 (PDT)
Received: from ddp-thinkpad.tail20b0d.ts.net ([80.208.222.2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48541a9e549sm84805865e9.12.2026.03.10.08.49.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 08:49:52 -0700 (PDT)
From: Daniele Di Proietto <daniele.di.proietto@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Daniele Di Proietto <daniele.di.proietto@gmail.com>
Subject: [PATCH] io_uring: Add IORING_OP_DUP
Date: Tue, 10 Mar 2026 15:49:33 +0000
Message-ID: <20260310154933.2500971-1-daniele.di.proietto@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DB0D5254261
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12622-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[kernel.dk,gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_NEQ_ENVFROM(0.00)[danielediproietto@gmail.com,io-uring@vger.kernel.org];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

The new operation is like dup3(). The source file can be a regular file
descriptor or a direct descriptor. The destination is a regular file
descriptor.

The direct descriptor variant is useful to move a descriptor to an fd
and close the existing fd with a single acquisition of the `struct
files_struct` `file_lock`. Combined with IORING_OP_ACCEPT or
IORING_OP_OPENAT2 with direct descriptors, it can reduce lock contention
for multithreaded applications.

Signed-off-by: Daniele Di Proietto <daniele.di.proietto@gmail.com>
---
 include/uapi/linux/io_uring.h | 10 +++++++
 io_uring/opdef.c              |  8 ++++++
 io_uring/openclose.c          | 49 +++++++++++++++++++++++++++++++++++
 io_uring/openclose.h          |  3 +++
 4 files changed, 70 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 1ff16141c8a5..472bebeb569d 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -74,6 +74,7 @@ struct io_uring_sqe {
 		__u32		install_fd_flags;
 		__u32		nop_flags;
 		__u32		pipe_flags;
+		__u32		dup_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	/* pack this to avoid bogus arm OABI complaints */
@@ -90,6 +91,7 @@ struct io_uring_sqe {
 		__u32	file_index;
 		__u32	zcrx_ifq_idx;
 		__u32	optlen;
+		__s32	dup_new_fd;
 		struct {
 			__u16	addr_len;
 			__u16	__pad3[1];
@@ -316,6 +318,7 @@ enum io_uring_op {
 	IORING_OP_PIPE,
 	IORING_OP_NOP128,
 	IORING_OP_URING_CMD128,
+	IORING_OP_DUP,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
@@ -475,6 +478,13 @@ enum io_uring_msg_ring_flags {
  */
 #define IORING_FIXED_FD_NO_CLOEXEC	(1U << 0)
 
+/*
+ * IORING_OP_DUP flags (sqe->dup_flags)
+ *
+ * IORING_DUP_NO_CLOEXEC	Don't mark the fd as O_CLOEXEC
+ */
+#define IORING_DUP_NO_CLOEXEC (1U << 0)
+
 /*
  * IORING_OP_NOP flags (sqe->nop_flags)
  *
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 91a23baf415e..34103b9108f6 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -599,6 +599,11 @@ const struct io_issue_def io_issue_defs[] = {
 		.prep			= io_uring_cmd_prep,
 		.issue			= io_uring_cmd,
 	},
+	[IORING_OP_DUP] = {
+		.needs_file		= 1,
+		.prep			= io_dup_prep,
+		.issue			= io_dup,
+	},
 };
 
 const struct io_cold_def io_cold_defs[] = {
@@ -857,6 +862,9 @@ const struct io_cold_def io_cold_defs[] = {
 		.sqe_copy		= io_uring_cmd_sqe_copy,
 		.cleanup		= io_uring_cmd_cleanup,
 	},
+	[IORING_OP_DUP] = {
+		.name			= "DUP",
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
diff --git a/io_uring/openclose.c b/io_uring/openclose.c
index c71242915dad..f7a6d45cba17 100644
--- a/io_uring/openclose.c
+++ b/io_uring/openclose.c
@@ -39,6 +39,12 @@ struct io_fixed_install {
 	unsigned int			o_flags;
 };
 
+struct io_dup {
+	struct file *file;
+	int new_fd;
+	unsigned int o_flags;
+};
+
 static bool io_openat_force_async(struct io_open *open)
 {
 	/*
@@ -446,3 +452,46 @@ int io_pipe(struct io_kiocb *req, unsigned int issue_flags)
 		fput(files[1]);
 	return ret;
 }
+
+int io_dup_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	unsigned int flags;
+	struct io_dup *id;
+	int new_fd;
+
+	if (sqe->off || sqe->addr || sqe->len || sqe->buf_index || sqe->addr3)
+		return -EINVAL;
+
+	flags = READ_ONCE(sqe->dup_flags);
+	if (flags & ~IORING_DUP_NO_CLOEXEC)
+		return -EINVAL;
+
+	new_fd = READ_ONCE(sqe->dup_new_fd);
+	if (new_fd < 0)
+		return -EBADF;
+
+	/* ensure the task's creds are used when installing/receiving fds */
+	if (req->flags & REQ_F_CREDS)
+		return -EPERM;
+
+	id = io_kiocb_to_cmd(req, struct io_dup);
+	id->o_flags = O_CLOEXEC;
+	if (flags & IORING_DUP_NO_CLOEXEC)
+		id->o_flags = 0;
+	id->new_fd = new_fd;
+
+	return 0;
+}
+
+int io_dup(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_dup *id;
+	int ret;
+
+	id = io_kiocb_to_cmd(req, struct io_dup);
+	ret = replace_fd(id->new_fd, id->file, id->o_flags);
+	if (ret < 0)
+		req_set_fail(req);
+	io_req_set_res(req, ret, 0);
+	return IOU_COMPLETE;
+}
diff --git a/io_uring/openclose.h b/io_uring/openclose.h
index 566739920658..86c91ad33714 100644
--- a/io_uring/openclose.h
+++ b/io_uring/openclose.h
@@ -21,3 +21,6 @@ int io_pipe(struct io_kiocb *req, unsigned int issue_flags);
 
 int io_install_fixed_fd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_install_fixed_fd(struct io_kiocb *req, unsigned int issue_flags);
+
+int io_dup_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_dup(struct io_kiocb *req, unsigned int issue_flags);
-- 
2.43.0


