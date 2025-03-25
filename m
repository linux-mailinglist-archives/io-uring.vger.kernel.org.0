Return-Path: <io-uring+bounces-7238-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 829D8A70308
	for <lists+io-uring@lfdr.de>; Tue, 25 Mar 2025 15:01:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E00261653AC
	for <lists+io-uring@lfdr.de>; Tue, 25 Mar 2025 13:52:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25FF71F55EF;
	Tue, 25 Mar 2025 13:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P9+5jSwL"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AEC819CC2E
	for <io-uring@vger.kernel.org>; Tue, 25 Mar 2025 13:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742910757; cv=none; b=dxLzbjHi2ziQ8s0mh8wMHWWCY3L0dGEBtPxgFD7X5seMSCDMWPpEnRJHYeCJtyOuw93oNMuOg4Zb8r0V+yU/zU0HzTPvcm4T+JZEzEPxPGc9lSvGZGPHVN6CR6SyZ+ldWP02EVfnuR6f4tU4I/OqyjW6dfe5EzBv+ACnt1QNLE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742910757; c=relaxed/simple;
	bh=FwrxkCFJG4F70/anpzaL3+28jjGJ5iICqnIY3ARep98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p50ygrXdOLghLTHmujzB9mmpdTv/XL4GeoxF4jHC2WQLU01F2mUVdyavqWI9fcXuQARN0LzNgtILgq4guYGTRFR0YFJaRpBmtLjaKcCb/MrTWHysu3vGUnZt3Ad9O4RPpUU+sW77Xpjt+pZepHtCQcH/yLG9Rm+kGzPuHNmi9pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P9+5jSwL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742910754;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9rkCEpFx95kanqFRf/MgwM1jjt3NtateXS8tqInieTs=;
	b=P9+5jSwL5+YsR4CS5+HVGAvQ22Oi1i36Q+4Dcv0TouiETOomFo9TPGv2te5TGFH87AWK9q
	SLon56WbM1D8zL/lgB7V1awlypyYVB1UOLtDwax4e2MSNDoC9Ll6qMiFSkZ9MnlFjBoa99
	MxqXp8mYTauPBCUiA2ZmkV9+j37PzJI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-312-ZEF0iGyhPwG4UZjPawVyyw-1; Tue,
 25 Mar 2025 09:52:30 -0400
X-MC-Unique: ZEF0iGyhPwG4UZjPawVyyw-1
X-Mimecast-MFC-AGG-ID: ZEF0iGyhPwG4UZjPawVyyw_1742910749
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AC3F51933B4F;
	Tue, 25 Mar 2025 13:52:29 +0000 (UTC)
Received: from localhost (unknown [10.72.120.3])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B4C2F180A802;
	Tue, 25 Mar 2025 13:52:28 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 4/4] selftests: ublk: enable zero copy for stripe target
Date: Tue, 25 Mar 2025 21:51:53 +0800
Message-ID: <20250325135155.935398-5-ming.lei@redhat.com>
In-Reply-To: <20250325135155.935398-1-ming.lei@redhat.com>
References: <20250325135155.935398-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Use io_uring vectored fixed kernel buffer for handling stripe IO.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 tools/testing/selftests/ublk/Makefile |  1 +
 tools/testing/selftests/ublk/stripe.c | 69 ++++++++++++++++++++-------
 2 files changed, 53 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/ublk/Makefile b/tools/testing/selftests/ublk/Makefile
index d98680d64a2f..c7781efea0f3 100644
--- a/tools/testing/selftests/ublk/Makefile
+++ b/tools/testing/selftests/ublk/Makefile
@@ -17,6 +17,7 @@ TEST_PROGS += test_loop_05.sh
 TEST_PROGS += test_stripe_01.sh
 TEST_PROGS += test_stripe_02.sh
 TEST_PROGS += test_stripe_03.sh
+TEST_PROGS += test_stripe_04.sh
 
 TEST_PROGS += test_stress_01.sh
 TEST_PROGS += test_stress_02.sh
diff --git a/tools/testing/selftests/ublk/stripe.c b/tools/testing/selftests/ublk/stripe.c
index 98c564b12f3c..179731c3dd6f 100644
--- a/tools/testing/selftests/ublk/stripe.c
+++ b/tools/testing/selftests/ublk/stripe.c
@@ -111,43 +111,67 @@ static void calculate_stripe_array(const struct stripe_conf *conf,
 	}
 }
 
-static inline enum io_uring_op stripe_to_uring_op(const struct ublksrv_io_desc *iod)
+static inline enum io_uring_op stripe_to_uring_op(
+		const struct ublksrv_io_desc *iod, int zc)
 {
 	unsigned ublk_op = ublksrv_get_op(iod);
 
 	if (ublk_op == UBLK_IO_OP_READ)
-		return IORING_OP_READV;
+		return zc ? IORING_OP_READV_FIXED : IORING_OP_READV;
 	else if (ublk_op == UBLK_IO_OP_WRITE)
-		return IORING_OP_WRITEV;
+		return zc ? IORING_OP_WRITEV_FIXED : IORING_OP_WRITEV;
 	assert(0);
 }
 
 static int stripe_queue_tgt_rw_io(struct ublk_queue *q, const struct ublksrv_io_desc *iod, int tag)
 {
 	const struct stripe_conf *conf = get_chunk_shift(q);
-	enum io_uring_op op = stripe_to_uring_op(iod);
+	int zc = !!(ublk_queue_use_zc(q) != 0);
+	enum io_uring_op op = stripe_to_uring_op(iod, zc);
 	struct io_uring_sqe *sqe[NR_STRIPE];
 	struct stripe_array *s = alloc_stripe_array(conf, iod);
 	struct ublk_io *io = ublk_get_io(q, tag);
-	int i;
+	int i, extra = zc ? 2 : 0;
 
 	io->private_data = s;
 	calculate_stripe_array(conf, iod, s);
 
-	ublk_queue_alloc_sqes(q, sqe, s->nr);
-	for (i = 0; i < s->nr; i++) {
-		struct stripe *t = &s->s[i];
+	ublk_queue_alloc_sqes(q, sqe, s->nr + extra);
+
+	if (zc) {
+		io_uring_prep_buf_register(sqe[0], 0, tag, q->q_id, tag);
+		sqe[0]->flags |= IOSQE_CQE_SKIP_SUCCESS | IOSQE_IO_HARDLINK;
+		sqe[0]->user_data = build_user_data(tag,
+			ublk_cmd_op_nr(sqe[0]->cmd_op), 0, 1);
+	}
+
+	for (i = zc; i < s->nr + extra - zc; i++) {
+		struct stripe *t = &s->s[i - zc];
 
 		io_uring_prep_rw(op, sqe[i],
 				t->seq + 1,
 				(void *)t->vec,
 				t->nr_vec,
 				t->start << 9);
-		io_uring_sqe_set_flags(sqe[i], IOSQE_FIXED_FILE);
+		if (zc) {
+			sqe[i]->buf_index = tag;
+			io_uring_sqe_set_flags(sqe[i],
+					IOSQE_FIXED_FILE | IOSQE_IO_HARDLINK);
+		} else {
+			io_uring_sqe_set_flags(sqe[i], IOSQE_FIXED_FILE);
+		}
 		/* bit63 marks us as tgt io */
-		sqe[i]->user_data = build_user_data(tag, ublksrv_get_op(iod), i, 1);
+		sqe[i]->user_data = build_user_data(tag, ublksrv_get_op(iod), i - zc, 1);
+	}
+	if (zc) {
+		struct io_uring_sqe *unreg = sqe[s->nr + 1];
+
+		io_uring_prep_buf_unregister(unreg, 0, tag, q->q_id, tag);
+		unreg->user_data = build_user_data(tag, ublk_cmd_op_nr(unreg->cmd_op), 0, 1);
 	}
-	return s->nr;
+
+	/* register buffer is skip_success */
+	return s->nr + zc;
 }
 
 static int handle_flush(struct ublk_queue *q, const struct ublksrv_io_desc *iod, int tag)
@@ -208,19 +232,27 @@ static void ublk_stripe_io_done(struct ublk_queue *q, int tag,
 	struct ublk_io *io = ublk_get_io(q, tag);
 	int res = cqe->res;
 
-	if (res < 0) {
+	if (res < 0 || op != ublk_cmd_op_nr(UBLK_U_IO_UNREGISTER_IO_BUF)) {
 		if (!io->result)
 			io->result = res;
-		ublk_err("%s: io failure %d tag %u\n", __func__, res, tag);
+		if (res < 0)
+			ublk_err("%s: io failure %d tag %u\n", __func__, res, tag);
 	}
 
+	/* buffer register op is IOSQE_CQE_SKIP_SUCCESS */
+	if (op == ublk_cmd_op_nr(UBLK_U_IO_REGISTER_IO_BUF))
+		io->tgt_ios += 1;
+
 	/* fail short READ/WRITE simply */
 	if (op == UBLK_IO_OP_READ || op == UBLK_IO_OP_WRITE) {
 		unsigned seq = user_data_to_tgt_data(cqe->user_data);
 		struct stripe_array *s = io->private_data;
 
-		if (res < s->s[seq].vec->iov_len)
+		if (res < s->s[seq].nr_sects << 9) {
 			io->result = -EIO;
+			ublk_err("%s: short rw op %u res %d exp %u tag %u\n",
+					__func__, op, res, s->s[seq].vec->iov_len, tag);
+		}
 	}
 
 	if (ublk_completed_tgt_io(q, tag)) {
@@ -253,7 +285,7 @@ static int ublk_stripe_tgt_init(const struct dev_ctx *ctx, struct ublk_dev *dev)
 	struct stripe_conf *conf;
 	unsigned chunk_shift;
 	loff_t bytes = 0;
-	int ret, i;
+	int ret, i, mul = 1;
 
 	if ((chunk_size & (chunk_size - 1)) || !chunk_size) {
 		ublk_err("invalid chunk size %u\n", chunk_size);
@@ -295,8 +327,11 @@ static int ublk_stripe_tgt_init(const struct dev_ctx *ctx, struct ublk_dev *dev)
 	dev->tgt.dev_size = bytes;
 	p.basic.dev_sectors = bytes >> 9;
 	dev->tgt.params = p;
-	dev->tgt.sq_depth = dev->dev_info.queue_depth * conf->nr_files;
-	dev->tgt.cq_depth = dev->dev_info.queue_depth * conf->nr_files;
+
+	if (dev->dev_info.flags & UBLK_F_SUPPORT_ZERO_COPY)
+		mul = 2;
+	dev->tgt.sq_depth = mul * dev->dev_info.queue_depth * conf->nr_files;
+	dev->tgt.cq_depth = mul * dev->dev_info.queue_depth * conf->nr_files;
 
 	printf("%s: shift %u files %u\n", __func__, conf->shift, conf->nr_files);
 
-- 
2.47.0


