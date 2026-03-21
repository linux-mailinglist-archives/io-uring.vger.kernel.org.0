Return-Path: <io-uring+bounces-12780-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IO30B0kov2mDxAMAu9opvQ
	(envelope-from <io-uring+bounces-12780-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 22 Mar 2026 00:22:49 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BA7E72E7A1F
	for <lists+io-uring@lfdr.de>; Sun, 22 Mar 2026 00:22:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 08CB33010B9A
	for <lists+io-uring@lfdr.de>; Sat, 21 Mar 2026 23:22:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6381C2EC0A1;
	Sat, 21 Mar 2026 23:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iDVuVrgb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B320D2D979C
	for <io-uring@vger.kernel.org>; Sat, 21 Mar 2026 23:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774135361; cv=none; b=CwWEsfYqlmeae8wo9L8xw1wytTz/QSFq0+S/dTswegQX4+HcCAOmU10mJVQPY7BMijf5/jl/IQwk6cq0bH1x1txvmn8zthzBBjMVEFskPtCFNd5ZJ+9o/BsvaAcysJIrmt0OgRy63mVDIFQYxSQv15kRioJV44/d4rJBZhR0kXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774135361; c=relaxed/simple;
	bh=+RkS1R4yg/o24fmGmdAL8yVoMJtCpik+cMew9HRv3Dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Endqv4HKtHDIvP/ZMGXdTbE8Vw6Vyf/NWE7jmdHSJx25dR/FXgl2rG9boZPa5WQmS7NKV93+7rJSF18e+VorMruDGVWGkj9tuBDNsoIm08npnMfmJGVJKQn9tULQFZQcXUVlXNbid1T4JQNZS2dxRx3x8P4TTLyalvPGsCDMDzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iDVuVrgb; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-43b4d734678so3120046f8f.1
        for <io-uring@vger.kernel.org>; Sat, 21 Mar 2026 16:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774135358; x=1774740158; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AwKZT9Z25S6E5hv2QONWp1kCppLkFiKumHns+JrmTEY=;
        b=iDVuVrgbimMxz4YOiDXLt0yWhGnwxUNrWUqZhWBggGTMMSkUWP830e7xORqxV5xmwW
         /2w/zgI3I1PaKowzOdpdaSGMwacESRaV68HI7MnJDk1b4oNwEO78qkxD+CZNvzCqc5Wc
         3dds21gLsJtXT9jwF/o+c+w01hHn0QzZQ+f/zdooGrH8X/KgvipYo5BGDhbax5n6syPK
         wgc5MdfzsAnp++EbNaTGa+SFq0XTzQgpqXUqY4ACadGeXfGiM21jyeTjmIi3B7IRdHZ9
         dkPDTqRbOWsxb050CIWwsyC5TQAboO8SA4rbE8uKpiG4HyRPVNO35n132nx0TzDJ/1F1
         22Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774135358; x=1774740158;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AwKZT9Z25S6E5hv2QONWp1kCppLkFiKumHns+JrmTEY=;
        b=sRTvU4cvvSQHKHa7jo5PVaQonLTa7eTca1F2T2lqXNXdaOd94KB9vwZ/X23e8i/86e
         PJm7Qf3Hd7b6G0+/+gdc8fyxHjT/htu5mBSj3ipUZoVR3ooChqCKc8NRL4/gfBc73HXR
         uqCmO3vujjBLlZOCXrS9oTT/yMn75V/Zn3rqkrcJUDtud+BEET//79Abg6T1bpE36NbT
         q4z2lD5V+BrBjiL9x4CfnC+NLPQyJGhf6kjTAjmrRpvd78jFUiBFw1NdDCChZFrtEruG
         aL4Df+cIctYsNA+g3U3HUisfzdzwiZ3QjyN9pHs7wHOnC9PRdwa9tAkOg/Gi0uKBNPpn
         /Msw==
X-Gm-Message-State: AOJu0YzW+CRc3psmZEKOI+n3brvp3CdfCI4ca0ObGTbfjHLURcsnowmw
	Ks87ntiASDaWMiDXqwWYdxsggZepqx11syhQ3UcIrZobHfZuyKK4oxm5dwkfR4pF+UA=
X-Gm-Gg: ATEYQzzxALoLqr4mze5ZVxkfF4L2lVnLzdTK5i3vFu25lGPB4f4ehok3lr7gNsBRa9Y
	+xaiZi4VbS08y1SSacz+Ajynd4tx6I8mXzZydl3N6QxuIZr8whSWzdiv0SwL9RoGIyqt2Md49Rs
	tiP59MTdVXktZqVYb7RAmdJpHaSjatVDaQOZIRDMpRbUb7TQnn5VH4ZPGMH94mG0QcnMMPJraoA
	02s5WVDeFmeVICKt0jbIpxdyjAagTviU2SHsUqE/xpgHYqXAxeT5y0vqqAWwQvdbjWygSmw2NPf
	xcbtGjntIVfH1f47B6W4/ge7vLDJeo9u8rbd27QI3HYtq4/VWu95WWXumOoibkWf1FfJ0N0v0D8
	K98pu6rLQBLBGNBHmf2LiVw0svh2D/k3uaw2PnAGftEOOYkc1yV4DRp2+BN6NXS3qUMCBNFfnQb
	WUZhR0qHxTkMZCRSQS5m9Vx6vfh1PlFZY8mpzR2r7hwwQxa8IdMls4KSdDYmQ=
X-Received: by 2002:a05:6000:22c7:b0:43b:4d25:959b with SMTP id ffacd0b85a97d-43b6423bc16mr12570651f8f.17.1774135357731;
        Sat, 21 Mar 2026 16:22:37 -0700 (PDT)
Received: from ddp-thinkpad.tail20b0d.ts.net ([95.141.20.197])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b6425eeb4sm15609897f8f.0.2026.03.21.16.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 16:22:37 -0700 (PDT)
From: Daniele Di Proietto <daniele.di.proietto@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Daniele Di Proietto <daniele.di.proietto@gmail.com>
Subject: [PATCH v3 4/4] io_uring: Add IORING_OP_DUP
Date: Sat, 21 Mar 2026 23:21:42 +0000
Message-ID: <20260321232142.911280-5-daniele.di.proietto@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260321232142.911280-1-daniele.di.proietto@gmail.com>
References: <20260321232142.911280-1-daniele.di.proietto@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-12780-lists,io-uring=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[kernel.dk,kernel.org,gmail.com,vger.kernel.org,zeniv.linux.org.uk,suse.cz];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[danielediproietto@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BA7E72E7A1F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

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
 include/uapi/linux/io_uring.h |  17 ++++
 io_uring/opdef.c              |   8 ++
 io_uring/openclose.c          | 180 ++++++++++++++++++++++++++++++++++
 io_uring/openclose.h          |   4 +
 4 files changed, 209 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 1ff16141c8a5..1612aa2db846 100644
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
@@ -475,6 +478,20 @@ enum io_uring_msg_ring_flags {
  */
 #define IORING_FIXED_FD_NO_CLOEXEC	(1U << 0)
 
+/*
+ * IORING_OP_DUP flags (sqe->dup_flags)
+ *
+ * IORING_DUP_NO_CLOEXEC	Don't mark the new fd as O_CLOEXEC. Only valid
+ *				if IORING_DUP_NEW_FIXED is not set.
+ * IORING_DUP_OLD_FIXED		sqe->fd (the source) is a fixed descriptor.
+ *				Otherwise it's a regular fd.
+ * IORING_DUP_NEW_FIXED		sqe->dup_new_fd (the destination) is a fixed
+ *				descriptor. Otherwise is a regular fd.
+ */
+#define IORING_DUP_NO_CLOEXEC	(1U << 0)
+#define IORING_DUP_OLD_FIXED	(1U << 1)
+#define IORING_DUP_NEW_FIXED	(1U << 2)
+
 /*
  * IORING_OP_NOP flags (sqe->nop_flags)
  *
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 91a23baf415e..62fe566d2cad 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -599,6 +599,10 @@ const struct io_issue_def io_issue_defs[] = {
 		.prep			= io_uring_cmd_prep,
 		.issue			= io_uring_cmd,
 	},
+	[IORING_OP_DUP] = {
+		.prep			= io_dup_prep,
+		.issue			= io_dup,
+	},
 };
 
 const struct io_cold_def io_cold_defs[] = {
@@ -857,6 +861,10 @@ const struct io_cold_def io_cold_defs[] = {
 		.sqe_copy		= io_uring_cmd_sqe_copy,
 		.cleanup		= io_uring_cmd_cleanup,
 	},
+	[IORING_OP_DUP] = {
+		.name			= "DUP",
+		.cleanup		= io_dup_cleanup,
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
diff --git a/io_uring/openclose.c b/io_uring/openclose.c
index c71242915dad..b3e5ce9e827c 100644
--- a/io_uring/openclose.c
+++ b/io_uring/openclose.c
@@ -39,6 +39,14 @@ struct io_fixed_install {
 	unsigned int			o_flags;
 };
 
+struct io_dup {
+	struct file *file;
+	int old_fd;
+	int new_fd;
+	unsigned int flags;
+	struct io_rsrc_node *rsrc_node;
+};
+
 static bool io_openat_force_async(struct io_open *open)
 {
 	/*
@@ -446,3 +454,175 @@ int io_pipe(struct io_kiocb *req, unsigned int issue_flags)
 		fput(files[1]);
 	return ret;
 }
+
+void io_dup_cleanup(struct io_kiocb *req)
+{
+	struct io_dup *id = io_kiocb_to_cmd(req, struct io_dup);
+
+	if (id->rsrc_node)
+		io_put_rsrc_node(req->ctx, id->rsrc_node);
+	id->rsrc_node = NULL;
+}
+
+#define IORING_DUP_FLAGS \
+	(IORING_DUP_NO_CLOEXEC | IORING_DUP_OLD_FIXED | IORING_DUP_NEW_FIXED)
+
+int io_dup_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_dup *id;
+
+	if (sqe->off || sqe->addr || sqe->len || sqe->buf_index || sqe->addr3)
+		return -EINVAL;
+
+	id = io_kiocb_to_cmd(req, struct io_dup);
+	id->flags = READ_ONCE(sqe->dup_flags);
+	if (id->flags & ~IORING_DUP_FLAGS)
+		return -EINVAL;
+
+	if ((id->flags & IORING_DUP_NO_CLOEXEC) &&
+	    (id->flags & IORING_DUP_NEW_FIXED))
+		return -EINVAL;
+
+	id->old_fd = READ_ONCE(sqe->fd);
+	id->new_fd = READ_ONCE(sqe->dup_new_fd);
+
+	if (((id->flags & IORING_DUP_NEW_FIXED) == 0) ==
+		    ((id->flags & IORING_DUP_OLD_FIXED) == 0) &&
+	    id->old_fd == id->new_fd)
+		return -EINVAL;
+
+	id->rsrc_node = NULL;
+
+	/* ensure the task's creds are used when installing/receiving fds */
+	if (req->flags & REQ_F_CREDS)
+		return -EPERM;
+
+	return 0;
+}
+
+static struct file *io_dup_get_old_file_fixed(struct io_kiocb *req,
+					      unsigned int issue_flags,
+					      unsigned int file_slot)
+{
+	struct io_dup *id = io_kiocb_to_cmd(req, struct io_dup);
+	struct file *file = NULL;
+
+	if (!id->rsrc_node)
+		id->rsrc_node = io_file_get_fixed_node(req, file_slot, issue_flags);
+
+	if (id->rsrc_node) {
+		file = io_slot_file(id->rsrc_node);
+		req->flags |= REQ_F_NEED_CLEANUP;
+	}
+	return file;
+}
+
+static int io_dup_to_fixed(struct io_kiocb *req, unsigned int issue_flags,
+			   bool old_fixed, int old_fd, unsigned int file_slot)
+{
+	struct file *old_file = NULL;
+	int ret;
+
+	if (!old_fixed) {
+		old_file = io_file_get_normal(req, old_fd);
+		if (old_file && io_is_uring_fops(old_file)) {
+			fput(old_file);
+			old_file = NULL;
+		}
+	} else {
+		old_file = io_dup_get_old_file_fixed(req, issue_flags, old_fd);
+		if (old_file)
+			get_file(old_file);
+	}
+	if (!old_file)
+		return -EBADF;
+
+	if (file_slot != IORING_FILE_INDEX_ALLOC)
+		file_slot++;
+
+	ret = io_fixed_fd_install(req, issue_flags, old_file, file_slot);
+	if (file_slot == IORING_FILE_INDEX_ALLOC || ret < 0)
+		return ret;
+	return file_slot - 1;
+}
+
+static int io_dup_complete(struct io_kiocb *req, int ret)
+{
+	if (ret < 0)
+		req_set_fail(req);
+	io_req_set_res(req, ret, 0);
+	return IOU_COMPLETE;
+}
+
+static int io_dup_to_fd(struct io_kiocb *req, unsigned int issue_flags,
+			bool old_fixed, int old_fd, int new_fd, int o_flags)
+{
+	bool non_block = issue_flags & IO_URING_F_NONBLOCK;
+	struct files_struct *files = current->files;
+	struct file *old_file, *to_close = NULL;
+	int err;
+
+	if (new_fd >= rlimit(RLIMIT_NOFILE))
+		return -EBADF;
+
+	if (old_fixed)
+		old_file = io_dup_get_old_file_fixed(req, issue_flags, old_fd);
+
+	{
+		guard(spinlock)(&files->file_lock);
+
+		/* Do we need to expand? If so, be safe and punt to async */
+		if (new_fd >= files_fdtable(files)->max_fds && non_block)
+			return -EAGAIN;
+		err = expand_files(files, new_fd);
+		if (err < 0)
+			return io_dup_complete(req, err);
+
+		if (!old_fixed)
+			old_file = files_lookup_fd_locked(files, old_fd);
+
+		if (!old_file)
+			return io_dup_complete(req, -EBADF);
+
+		to_close = files_lookup_fd_locked(files, new_fd);
+		if (to_close) {
+			if (io_is_uring_fops(to_close))
+				return io_dup_complete(req, -EBADF);
+
+			/* if the file has a flush method, be safe and punt to async */
+			if (to_close->f_op->flush && non_block)
+				return -EAGAIN;
+		}
+		to_close = do_replace_fd_locked(files, old_file, new_fd, o_flags);
+		if (IS_ERR(to_close))
+			return io_dup_complete(req, PTR_ERR(to_close));
+	}
+
+	if (to_close)
+		filp_close(to_close, files);
+
+	return io_dup_complete(req, new_fd);
+}
+
+int io_dup(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_dup *id = io_kiocb_to_cmd(req, struct io_dup);
+	bool old_fixed = id->flags & IORING_DUP_OLD_FIXED;
+	bool new_fixed = id->flags & IORING_DUP_NEW_FIXED;
+	int ret, o_flags;
+
+	if (new_fixed) {
+		ret = io_dup_to_fixed(req, issue_flags, old_fixed, id->old_fd,
+				      id->new_fd);
+		if (ret < 0)
+			req_set_fail(req);
+		io_req_set_res(req, ret, 0);
+		return IOU_COMPLETE;
+	}
+
+	o_flags = O_CLOEXEC;
+	if (id->flags & IORING_DUP_NO_CLOEXEC)
+		o_flags = 0;
+	return io_dup_to_fd(req, issue_flags, old_fixed, id->old_fd, id->new_fd,
+			    o_flags);
+}
diff --git a/io_uring/openclose.h b/io_uring/openclose.h
index 566739920658..95d6a338ac66 100644
--- a/io_uring/openclose.h
+++ b/io_uring/openclose.h
@@ -21,3 +21,7 @@ int io_pipe(struct io_kiocb *req, unsigned int issue_flags);
 
 int io_install_fixed_fd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_install_fixed_fd(struct io_kiocb *req, unsigned int issue_flags);
+
+void io_dup_cleanup(struct io_kiocb *req);
+int io_dup_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_dup(struct io_kiocb *req, unsigned int issue_flags);
-- 
2.43.0


