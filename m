Return-Path: <io-uring+bounces-6937-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 837EBA4E5F2
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 17:31:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C972A3BFC49
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 15:58:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8350E298CA7;
	Tue,  4 Mar 2025 15:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R92IPqWJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9512F280CC4
	for <io-uring@vger.kernel.org>; Tue,  4 Mar 2025 15:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741102779; cv=none; b=c85mdoJovAd9X/FLyfN+sLZ7bPfZqgAjlu7Pajmci37HBZMyyqEOnuIi3CF8jZdSrZ7pjh5j1XMFnIJ7OGExmY9pK/YOK13Nv5Hi77Cf0JyEYMUa/28UypAoAVdUPJON6Hz4J1pR6D51g8IqZGIDm1DDCDt0SRgAu6dvAF3kdpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741102779; c=relaxed/simple;
	bh=z68zN+i+UX2eMqGbGdS9FjdQEKbOuwEhXBJrRHSKZrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebIarzQkqnVuKC8M5H2CacNiUA5/nY8DCin1S9QC4PLmY271wBTHcmvTCRGeDi0FLFh5jFEDAh5abxY6bvnqd4j5IpzUS9aZ2eH2qXWlGn6/ykN5BkeqLy8W/CPtQn4bGWcdC8IfEIT6Xuwe7Hohou55dQns0UyhVoaM9woEMb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R92IPqWJ; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-aaee2c5ee6eso839148866b.1
        for <io-uring@vger.kernel.org>; Tue, 04 Mar 2025 07:39:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741102775; x=1741707575; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1OuBKjwGr0UgawHOumxXWMKAPfGEiLxbUH2ylFtbJ/Q=;
        b=R92IPqWJlQNx6u2uw5oWES7JkoBeHnrfwTlxKJu2KbadgybaYhhrrqJce1nSyBi5tt
         PxPUTBNwyXZx4WRWQlbvQN0itD+BTL4Y8xxjxeWVBD7+ZDT8WtRQ1FKi6RtkuILpRRTj
         NLS2Wi8KjORZGTqEcA4dD1TT0copmPnRwuknk6QA3iKt8kQjENbdLoovbqkOPiMjmUCg
         yFv5qhroS/5ugEkksLQyPFAnlEDYtrZ8F6CTVBQsMcDOlbnPY/pammBbaL/7DntpbV/0
         1a+ku6sL+fQoDCB1/HaF9vxVUiWg2nlcJBt0VckMFDrI/qezZI4sFak9yIJ5oUBHIcJ6
         68ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741102775; x=1741707575;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1OuBKjwGr0UgawHOumxXWMKAPfGEiLxbUH2ylFtbJ/Q=;
        b=lWejVClj+kikuiq6ivj8OWVrephNYMYBB1T8GABjEWYCgWpOJHHrrKJUPH6vXnmyks
         vWL28hGmrvMk7CVohyUz9HdaKrg11ev9GqQmg5kmD6YbxDlYLigdxa6S1XeIaHScJvmw
         Wo8EJXnm7x3ekwHqE/7b6eGMiJ/tviUH5a6+cW/79YfeDKmayYp3Av0JDbtJHvqTj9pQ
         hp+3/8M8QY+uJo9Q64dA0p35+mYNR/1U9mB8hQMwgeBn2QN0IK7uxmjPjf84aWloKSZL
         n+Lx7m/Dn+RjbF7DNEMTAiQwzcEmPNy7SuLKADzqRQikIsRtnJELvyGhskQMMCrsd4+c
         WLyQ==
X-Gm-Message-State: AOJu0YxqzsO8SPT29fZazthU3F0jlFSu80ixUUd8PjfpmXHUpEmWUgVz
	dF5x5V2+J1KQWpmZGl7dM2sFfRKKHPhkY+Ma4kp4zGNcYB6gPF+V4Tl4tw==
X-Gm-Gg: ASbGncsJtUMMIoi9JXrI7gZMto3onU+lkA0kOQFTVefo4mXF7xVwr2Fe2jeaDWb7IDR
	nVNCFc2IXhBq4u6JZfvLryKf/gspPZXAuH5fDTptnLamdIaoXDaNBQOYPs2lei28KT1ePS5FNm8
	hS/v54SkwA45eL6hMwTJRAgau/iQpC7UinN6Sk5XujlLi1u3J7QrnItO41Ls7FmJoaKY9wuEIZc
	u8iMt+oY7RMieu1CAcqETXeyIGqC2JzjnB3IU8Ay/ZCiwCA23xk90unb0MjR0EVPndH9X+InI6W
	mr9fyUE/Us73zdJlB1F8g1ZMpXhQ
X-Google-Smtp-Source: AGHT+IGluVtNgHr+YrNc/9AEjetNP299tL1fJT+OT5WwItcxeCX2SVjperWjdb34jkhMNddCCboQ2g==
X-Received: by 2002:a17:907:7a8e:b0:abf:6d24:10bb with SMTP id a640c23a62f3a-abf6d241c9emr1034399966b.44.1741102775331;
        Tue, 04 Mar 2025 07:39:35 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:3bd7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac1ecafa17fsm168420966b.162.2025.03.04.07.39.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 07:39:34 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Andres Freund <andres@anarazel.de>
Subject: [PATCH v2 3/9] io_uring/rw: implement vectored registered rw
Date: Tue,  4 Mar 2025 15:40:24 +0000
Message-ID: <7d37e52d36b645fb7c70f41a85fc704d8bca5f4a.1741102644.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1741102644.git.asml.silence@gmail.com>
References: <cover.1741102644.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement registered buffer vectored reads with new opcodes
IORING_OP_WRITEV_FIXED and IORING_OP_READV_FIXED.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h |  2 ++
 io_uring/opdef.c              | 39 +++++++++++++++++++++++++++
 io_uring/rw.c                 | 51 +++++++++++++++++++++++++++++++++++
 io_uring/rw.h                 |  2 ++
 4 files changed, 94 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 1e02e94bc26d..9dd384b369ee 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -280,6 +280,8 @@ enum io_uring_op {
 	IORING_OP_BIND,
 	IORING_OP_LISTEN,
 	IORING_OP_RECV_ZC,
+	IORING_OP_READV_FIXED,
+	IORING_OP_WRITEV_FIXED,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 9511262c513e..6655d2cbf74d 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -529,6 +529,35 @@ const struct io_issue_def io_issue_defs[] = {
 		.prep			= io_eopnotsupp_prep,
 #endif
 	},
+	[IORING_OP_READV_FIXED] = {
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollin			= 1,
+		.plug			= 1,
+		.audit_skip		= 1,
+		.ioprio			= 1,
+		.iopoll			= 1,
+		.iopoll_queue		= 1,
+		.vectored		= 1,
+		.async_size		= sizeof(struct io_async_rw),
+		.prep			= io_prep_readv_fixed,
+		.issue			= io_read,
+	},
+	[IORING_OP_WRITEV_FIXED] = {
+		.needs_file		= 1,
+		.hash_reg_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollout		= 1,
+		.plug			= 1,
+		.audit_skip		= 1,
+		.ioprio			= 1,
+		.iopoll			= 1,
+		.iopoll_queue		= 1,
+		.vectored		= 1,
+		.async_size		= sizeof(struct io_async_rw),
+		.prep			= io_prep_writev_fixed,
+		.issue			= io_write,
+	},
 };
 
 const struct io_cold_def io_cold_defs[] = {
@@ -761,6 +790,16 @@ const struct io_cold_def io_cold_defs[] = {
 	[IORING_OP_RECV_ZC] = {
 		.name			= "RECV_ZC",
 	},
+	[IORING_OP_READV_FIXED] = {
+		.name			= "READV_FIXED",
+		.cleanup		= io_readv_writev_cleanup,
+		.fail			= io_rw_fail,
+	},
+	[IORING_OP_WRITEV_FIXED] = {
+		.name			= "WRITEV_FIXED",
+		.cleanup		= io_readv_writev_cleanup,
+		.fail			= io_rw_fail,
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
diff --git a/io_uring/rw.c b/io_uring/rw.c
index ad7f647d48e9..4c4229f41aaa 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -381,6 +381,57 @@ int io_prep_write_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return __io_prep_rw(req, sqe, ITER_SOURCE);
 }
 
+static int io_rw_prep_reg_vec(struct io_kiocb *req, int ddir)
+{
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+	struct io_async_rw *io = req->async_data;
+	const struct iovec __user *uvec;
+	size_t uvec_segs = rw->len;
+	struct iovec *iov;
+	int iovec_off, ret;
+	void *res;
+
+	if (uvec_segs > io->vec.nr) {
+		ret = io_vec_realloc(&io->vec, uvec_segs);
+		if (ret)
+			return ret;
+		req->flags |= REQ_F_NEED_CLEANUP;
+	}
+	/* pad iovec to the right */
+	iovec_off = io->vec.nr - uvec_segs;
+	iov = io->vec.iovec + iovec_off;
+	uvec = u64_to_user_ptr(rw->addr);
+	res = iovec_from_user(uvec, uvec_segs, uvec_segs, iov,
+			      io_is_compat(req->ctx));
+	if (IS_ERR(res))
+		return PTR_ERR(res);
+
+	ret = io_import_reg_vec(ddir, &io->iter, req, &io->vec,
+				uvec_segs, iovec_off, 0);
+	iov_iter_save_state(&io->iter, &io->iter_state);
+	return ret;
+}
+
+int io_prep_readv_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	int ret;
+
+	ret = __io_prep_rw(req, sqe, ITER_DEST);
+	if (unlikely(ret))
+		return ret;
+	return io_rw_prep_reg_vec(req, ITER_DEST);
+}
+
+int io_prep_writev_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	int ret;
+
+	ret = __io_prep_rw(req, sqe, ITER_SOURCE);
+	if (unlikely(ret))
+		return ret;
+	return io_rw_prep_reg_vec(req, ITER_SOURCE);
+}
+
 /*
  * Multishot read is prepared just like a normal read/write request, only
  * difference is that we set the MULTISHOT flag.
diff --git a/io_uring/rw.h b/io_uring/rw.h
index 529fd2f96a7f..81d6d9a8cf69 100644
--- a/io_uring/rw.h
+++ b/io_uring/rw.h
@@ -32,6 +32,8 @@ struct io_async_rw {
 
 int io_prep_read_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_prep_write_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_prep_readv_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_prep_writev_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_prep_readv(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_prep_writev(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_prep_read(struct io_kiocb *req, const struct io_uring_sqe *sqe);
-- 
2.48.1


