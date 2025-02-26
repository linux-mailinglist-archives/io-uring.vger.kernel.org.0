Return-Path: <io-uring+bounces-6792-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6450DA46783
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 18:10:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 314D53A6E8D
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 17:10:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43CC52248B5;
	Wed, 26 Feb 2025 17:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FzAs2B+9"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185FE2248AC;
	Wed, 26 Feb 2025 17:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740589835; cv=none; b=bIPZxyVpOwkQKqzngI9AOG4qXhskzYE0ev9g16HtxyXBESLI2kRGgtUyUApHjPTDDnSCs/JPVY4y5YQzWPQfSeNb2tTPjV8JAURGh8tqvHeoPiPDi4vSD08bK+Q5MIbXurT2QiHDmBNj3mH2Kt1tSoip/9ySQ1oLbHhW5Q0TI/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740589835; c=relaxed/simple;
	bh=L/OAu1/Elx04wc3U3fD0kyjGYwdzW/nGzcSlbj1elIs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U++uUd94sO5psxeSNuB/ywB6A+2a69SzVWYA315KNV2Qagfg0yT+n/4z+/2RoTpnaq/vZSHWsP0tSGsCHbLq716j1A4kZWmmFqSIn+bXm5YpCydpT5v9P4XQSljUlLJParJXZodxCtTn2A4QRCh/QS4JrRKIx3YPlBdLiOwOBaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FzAs2B+9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8C0C4CEE4;
	Wed, 26 Feb 2025 17:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740589834;
	bh=L/OAu1/Elx04wc3U3fD0kyjGYwdzW/nGzcSlbj1elIs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FzAs2B+9aPHSVeqURKUrYEldPQ1U0fiyAMWYX244a7xgLP+h6NF+Yov7WoS94b9e1
	 nipW/LfPIJumeItVfcm80iBnvvDVcO+lp35f7dCDGLWMOUOq5D7qQeATEfrywyJ3zE
	 y08FEfvTZWdktz2PmZRcWG2YlPMB444JNuewyuYKDnrTZJamvnTDfccV09Lg88fOBR
	 un4vF1pEg1WIfjHnL77I9qjqkq8wumpighJRiHe2APss21W6wK5Q10ZAKnkCmxVGP9
	 thKdpD4qiu1eL0T6nnyJt60QzKr2I826EpR/LBO6kKvQdJjju48n2Ei5chb265slsO
	 KZXGQkGJMUlZw==
Date: Wed, 26 Feb 2025 10:10:31 -0700
From: Keith Busch <kbusch@kernel.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Keith Busch <kbusch@meta.com>, asml.silence@gmail.com, axboe@kernel.dk,
	linux-block@vger.kernel.org, io-uring@vger.kernel.org,
	bernd@bsbernd.com, csander@purestorage.com
Subject: Re: [PATCHv5 09/11] ublk: zc register/unregister bvec
Message-ID: <Z79LB3T5Aa6RoaDo@kbusch-mbp>
References: <20250224213116.3509093-1-kbusch@meta.com>
 <20250224213116.3509093-10-kbusch@meta.com>
 <Z77Nq_5ZGxUjxkau@fedora>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z77Nq_5ZGxUjxkau@fedora>

On Wed, Feb 26, 2025 at 04:15:39PM +0800, Ming Lei wrote:
> On Mon, Feb 24, 2025 at 01:31:14PM -0800, Keith Busch wrote:
> > From: Keith Busch <kbusch@kernel.org>
> > 
> > Provide new operations for the user to request mapping an active request
> > to an io uring instance's buf_table. The user has to provide the index
> > it wants to install the buffer.
> > 
> > A reference count is taken on the request to ensure it can't be
> > completed while it is active in a ring's buf_table.
> > 
> > Signed-off-by: Keith Busch <kbusch@kernel.org>
> > ---
> 
> Looks IO_LINK doesn't work, and UNREG_BUF cqe can be received from userspace.

You can link the register, but should do the unregister with COMMIT
command on the frontend when the backend is complete. This doesn't need
the triple SQE requirement.

I was going to share with the next version, but since you bring it up
now, here's the reference patch for ublksrv using links:

---
diff --git a/include/ublk_cmd.h b/include/ublk_cmd.h
index 0150003..07439be 100644
--- a/include/ublk_cmd.h
+++ b/include/ublk_cmd.h
@@ -94,6 +94,10 @@
 	_IOWR('u', UBLK_IO_COMMIT_AND_FETCH_REQ, struct ublksrv_io_cmd)
 #define	UBLK_U_IO_NEED_GET_DATA		\
 	_IOWR('u', UBLK_IO_NEED_GET_DATA, struct ublksrv_io_cmd)
+#define UBLK_U_IO_REGISTER_IO_BUF	\
+	_IOWR('u', 0x23, struct ublksrv_io_cmd)
+#define UBLK_U_IO_UNREGISTER_IO_BUF	\
+	_IOWR('u', 0x24, struct ublksrv_io_cmd)
 
 /* only ABORT means that no re-fetch */
 #define UBLK_IO_RES_OK			0
diff --git a/include/ublksrv_tgt.h b/include/ublksrv_tgt.h
index 1deee2b..c331963 100644
--- a/include/ublksrv_tgt.h
+++ b/include/ublksrv_tgt.h
@@ -99,6 +99,7 @@ struct ublk_io_tgt {
 	co_handle_type co;
 	const struct io_uring_cqe *tgt_io_cqe;
 	int queued_tgt_io;	/* obsolete */
+	bool needs_unregister;
 };
 
 static inline struct ublk_io_tgt *__ublk_get_io_tgt_data(const struct ublk_io_data *io)
diff --git a/lib/ublksrv.c b/lib/ublksrv.c
index 16a9e13..7205247 100644
--- a/lib/ublksrv.c
+++ b/lib/ublksrv.c
@@ -619,6 +619,15 @@ skip_alloc_buf:
 		goto fail;
 	}
 
+	if (ctrl_dev->dev_info.flags & UBLK_F_SUPPORT_ZERO_COPY) {
+		ret = io_uring_register_buffers_sparse(&q->ring, q->q_depth);
+		if (ret) {
+			ublk_err("ublk dev %d queue %d register spare buffers failed %d",
+					q->dev->ctrl_dev->dev_info.dev_id, q->q_id, ret);
+			goto fail;
+		}
+	}
+
 	io_uring_register_ring_fd(&q->ring);
 
 	/*
diff --git a/tgt_loop.cpp b/tgt_loop.cpp
index 0f16676..91f8c81 100644
--- a/tgt_loop.cpp
+++ b/tgt_loop.cpp
@@ -246,12 +246,70 @@ static inline int loop_fallocate_mode(const struct ublksrv_io_desc *iod)
        return mode;
 }
 
+static inline void io_uring_prep_buf_register(struct io_uring_sqe *sqe,
+		int dev_fd, int tag, int q_id, __u64 index)
+{
+	struct ublksrv_io_cmd *cmd = (struct ublksrv_io_cmd *)sqe->cmd;
+
+	io_uring_prep_read(sqe, dev_fd, 0, 0, 0);
+	sqe->opcode		= IORING_OP_URING_CMD;
+	sqe->flags		|= IOSQE_IO_LINK | IOSQE_CQE_SKIP_SUCCESS | IOSQE_FIXED_FILE;
+	sqe->cmd_op		= UBLK_U_IO_REGISTER_IO_BUF;
+
+	cmd->tag		= tag;
+	cmd->addr		= index;
+	cmd->q_id		= q_id;
+}
+
+static inline void io_uring_prep_buf_unregister(struct io_uring_sqe *sqe,
+		int dev_fd, int tag, int q_id, __u64 index)
+{
+	struct ublksrv_io_cmd *cmd = (struct ublksrv_io_cmd *)sqe->cmd;
+
+	io_uring_prep_read(sqe, dev_fd, 0, 0, 0);
+	sqe->opcode             = IORING_OP_URING_CMD;
+	sqe->flags              |= IOSQE_CQE_SKIP_SUCCESS | IOSQE_FIXED_FILE;
+	sqe->cmd_op             = UBLK_U_IO_UNREGISTER_IO_BUF;
+
+	cmd->tag                = tag;
+	cmd->addr               = index;
+	cmd->q_id               = q_id;
+}
+
+static void loop_unregister(const struct ublksrv_queue *q, int tag)
+{
+	struct io_uring_sqe *sqe;
+
+	ublk_get_sqe_pair(q->ring_ptr, &sqe, NULL);
+	io_uring_prep_buf_unregister(sqe, 0, tag, q->q_id, tag);
+}
+
 static void loop_queue_tgt_read(const struct ublksrv_queue *q,
-		const struct ublksrv_io_desc *iod, int tag)
+		const struct ublk_io_data *data, int tag)
 {
+	struct ublk_io_tgt *io = __ublk_get_io_tgt_data(data);
+	const struct ublksrv_io_desc *iod = data->iod;
+	const struct ublksrv_ctrl_dev_info *info =
+		ublksrv_ctrl_get_dev_info(ublksrv_get_ctrl_dev(q->dev));
 	unsigned ublk_op = ublksrv_get_op(iod);
 
-	if (user_copy) {
+	if (info->flags & UBLK_F_SUPPORT_ZERO_COPY) {
+		struct io_uring_sqe *reg;
+		struct io_uring_sqe *read;
+
+		ublk_get_sqe_pair(q->ring_ptr, &reg, &read);
+
+		io_uring_prep_buf_register(reg, 0, tag, q->q_id, tag);
+
+		io_uring_prep_read_fixed(read, 1 /*fds[1]*/,
+			0,
+			iod->nr_sectors << 9,
+			iod->start_sector << 9,
+			tag);
+		io_uring_sqe_set_flags(read, IOSQE_FIXED_FILE);
+		read->user_data = build_user_data(tag, ublk_op, 0, 1);
+		io->needs_unregister = true;
+	} else if (user_copy) {
 		struct io_uring_sqe *sqe, *sqe2;
 		__u64 pos = ublk_pos(q->q_id, tag, 0);
 		void *buf = ublksrv_queue_get_io_buf(q, tag);
@@ -284,11 +342,31 @@ static void loop_queue_tgt_read(const struct ublksrv_queue *q,
 }
 
 static void loop_queue_tgt_write(const struct ublksrv_queue *q,
-		const struct ublksrv_io_desc *iod, int tag)
+		const struct ublk_io_data *data, int tag)
 {
+	const struct ublksrv_io_desc *iod = data->iod;
+	const struct ublksrv_ctrl_dev_info *info =
+		ublksrv_ctrl_get_dev_info(ublksrv_get_ctrl_dev(q->dev));
 	unsigned ublk_op = ublksrv_get_op(iod);
 
-	if (user_copy) {
+	if (info->flags & UBLK_F_SUPPORT_ZERO_COPY) {
+		struct ublk_io_tgt *io = __ublk_get_io_tgt_data(data);
+		struct io_uring_sqe *reg;
+		struct io_uring_sqe *write;
+
+		ublk_get_sqe_pair(q->ring_ptr, &reg, &write);
+		io_uring_prep_buf_register(reg, 0, tag, q->q_id, tag);
+
+		io_uring_prep_write_fixed(write, 1 /*fds[1]*/,
+			0,
+			iod->nr_sectors << 9,
+			iod->start_sector << 9,
+			tag);
+		io_uring_sqe_set_flags(write, IOSQE_FIXED_FILE);
+		write->user_data = build_user_data(tag, ublk_op, 0, 1);
+
+		io->needs_unregister = true;
+	} else if (user_copy) {
 		struct io_uring_sqe *sqe, *sqe2;
 		__u64 pos = ublk_pos(q->q_id, tag, 0);
 		void *buf = ublksrv_queue_get_io_buf(q, tag);
@@ -352,10 +430,10 @@ static int loop_queue_tgt_io(const struct ublksrv_queue *q,
 		sqe->user_data = build_user_data(tag, ublk_op, 0, 1);
 		break;
 	case UBLK_IO_OP_READ:
-		loop_queue_tgt_read(q, iod, tag);
+		loop_queue_tgt_read(q, data, tag);
 		break;
 	case UBLK_IO_OP_WRITE:
-		loop_queue_tgt_write(q, iod, tag);
+		loop_queue_tgt_write(q, data, tag);
 		break;
 	default:
 		return -EINVAL;
@@ -387,6 +465,10 @@ static co_io_job __loop_handle_io_async(const struct ublksrv_queue *q,
 		if (io->tgt_io_cqe->res == -EAGAIN)
 			goto again;
 
+		if (io->needs_unregister) {
+			io->needs_unregister = false;
+			loop_unregister(q, tag);
+		}
 		ublksrv_complete_io(q, tag, io->tgt_io_cqe->res);
 	} else if (ret < 0) {
 		ublk_err( "fail to queue io %d, ret %d\n", tag, tag);
diff --git a/ublksrv_tgt.cpp b/ublksrv_tgt.cpp
index 8f9cf28..f3ebe14 100644
--- a/ublksrv_tgt.cpp
+++ b/ublksrv_tgt.cpp
@@ -723,7 +723,7 @@ static int cmd_dev_add(int argc, char *argv[])
 			data.tgt_type = optarg;
 			break;
 		case 'z':
-			data.flags |= UBLK_F_SUPPORT_ZERO_COPY;
+			data.flags |= UBLK_F_SUPPORT_ZERO_COPY | UBLK_F_USER_COPY;
 			break;
 		case 'q':
 			data.nr_hw_queues = strtol(optarg, NULL, 10);
--

