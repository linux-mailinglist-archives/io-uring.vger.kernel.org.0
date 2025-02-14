Return-Path: <io-uring+bounces-6437-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 45B26A36216
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 16:45:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0B4EF1896006
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 15:44:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 268A5266B64;
	Fri, 14 Feb 2025 15:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="dU3XyOpp"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA7226738C
	for <io-uring@vger.kernel.org>; Fri, 14 Feb 2025 15:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739547838; cv=none; b=TwGFxB3lx5tkVj19Zvsx6mmf+sTcYCpp/4RUYhobIdPjs9aEIxvX7ikXnqI6Pm/s4QCbkUsiTi3XI6HTox9E22T/DBD3CnkCcJobugJNVFIY4bfFanrv3O3AbjOMsCWfNv6UOMLOq+/MjNr61RFPBBQanzTlQgsArykk3afEyVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739547838; c=relaxed/simple;
	bh=9IyapXbV+vB6yb2jeHmjAgFGUni4n4kMtZNOgkf6MBU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=inoH11zQFzlyxPIQD7zkG/gNnSC0ZQvSiqFlXNQTAGN6Wp1h1ooRKY4W9jBgezs3ZrqXHUjqx0gvLdPdISb/vxoAT03oKAM6rGSdOV+iHDtO0FMJd8QOpmcb+sW5Gr6vqyIZS5AS2+ITB2yhYH/AJxwhiQBfG9hJc+Ul+oh3EsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=dU3XyOpp; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51EE0IUc016881
	for <io-uring@vger.kernel.org>; Fri, 14 Feb 2025 07:43:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=dq+jTPDTa0ZtncWASHXMIQipxuYmV9Q0E23gWy3m3r0=; b=dU3XyOppPukM
	I7P8nHnXxWtelD3D/xCultKrmPWUYEtiDVqG9OnptOGCnlKo9eQshS94CZ597FYo
	3E3MS8eb9tnVrSjc03aTbNVmfEFrxxXuYJZq/J1UPKKFcZrlsks04swVV4plUsem
	qmDlPAISpu+iuNsOODIT3vTPAZeuH2Oou9H2aLpWinKSnByz2EftiPhWyQgRvnj0
	Uq660YJNuNIP8qIo2I/F8hNuvXpAAe9+DcwRMJUPQrLpELPTDcq6vPo12koi0jrm
	T0xiuVwurrBRmZ0FVk5ECMS767JCyA5mEgGPNTrvSnynON+USWk1SpSYasYct7ew
	ExZn6toeIw==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 44t6b59491-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Fri, 14 Feb 2025 07:43:53 -0800 (PST)
Received: from twshared18153.09.ash9.facebook.com (2620:10d:c0a8:fe::f072) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Fri, 14 Feb 2025 15:43:49 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 311FB18060B5A; Fri, 14 Feb 2025 07:43:49 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <ming.lei@redhat.com>, <asml.silence@gmail.com>, <axboe@kernel.dk>,
        <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: <bernd@bsbernd.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv3 2/5] io_uring: add support for kernel registered bvecs
Date: Fri, 14 Feb 2025 07:43:45 -0800
Message-ID: <20250214154348.2952692-3-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250214154348.2952692-1-kbusch@meta.com>
References: <20250214154348.2952692-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 01X7MaoeFcwEkjXRf96IwhjUN--8ENG5
X-Proofpoint-ORIG-GUID: 01X7MaoeFcwEkjXRf96IwhjUN--8ENG5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-14_06,2025-02-13_01,2024-11-22_01

From: Keith Busch <kbusch@kernel.org>

Provide an interface for the kernel to leverage the existing
pre-registered buffers that io_uring provides. User space can reference
these later to achieve zero-copy IO.

User space must register a sparse fixed buffer table with io_uring in
order for the kernel to make use of it. Kernel users of this interface
need to register a callback to know when the last reference is released.
io_uring uses the existence of this callback to differentiate user vs
kernel register buffers.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 include/linux/io_uring.h       |   1 +
 include/linux/io_uring_types.h |   6 ++
 io_uring/rsrc.c                | 112 ++++++++++++++++++++++++++++++---
 io_uring/rsrc.h                |   2 +
 4 files changed, 113 insertions(+), 8 deletions(-)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 85fe4e6b275c7..b5637a2aae340 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -5,6 +5,7 @@
 #include <linux/sched.h>
 #include <linux/xarray.h>
 #include <uapi/linux/io_uring.h>
+#include <linux/blk-mq.h>
=20
 #if defined(CONFIG_IO_URING)
 void __io_uring_cancel(bool cancel_all);
diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
index d5bf336882aa8..b9feba4df60c9 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -696,4 +696,10 @@ static inline bool io_ctx_cqe32(struct io_ring_ctx *=
ctx)
 	return ctx->flags & IORING_SETUP_CQE32;
 }
=20
+int io_buffer_register_bvec(struct io_ring_ctx *ctx, struct request *rq,
+			    void (*release)(void *), unsigned int index,
+			    unsigned int issue_flags);
+void io_buffer_unregister_bvec(struct io_ring_ctx *ctx, unsigned int tag=
,
+			       unsigned int issue_flags);
+
 #endif
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index af39b69eb4fde..0e323ca1e8e5c 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -103,19 +103,23 @@ static int io_buffer_validate(struct iovec *iov)
=20
 static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_rsrc_node=
 *node)
 {
-	unsigned int i;
+	struct io_mapped_ubuf *imu =3D node->buf;
=20
-	if (node->buf) {
-		struct io_mapped_ubuf *imu =3D node->buf;
+	if (!refcount_dec_and_test(&imu->refs))
+		return;
+
+	if (imu->release) {
+		imu->release(imu->priv);
+	} else {
+		unsigned int i;
=20
-		if (!refcount_dec_and_test(&imu->refs))
-			return;
 		for (i =3D 0; i < imu->nr_bvecs; i++)
 			unpin_user_page(imu->bvec[i].bv_page);
 		if (imu->acct_pages)
 			io_unaccount_mem(ctx, imu->acct_pages);
-		kvfree(imu);
 	}
+
+	kvfree(imu);
 }
=20
 struct io_rsrc_node *io_rsrc_node_alloc(int type)
@@ -764,6 +768,8 @@ static struct io_rsrc_node *io_sqe_buffer_register(st=
ruct io_ring_ctx *ctx,
 	imu->len =3D iov->iov_len;
 	imu->nr_bvecs =3D nr_pages;
 	imu->folio_shift =3D PAGE_SHIFT;
+	imu->release =3D NULL;
+	imu->priv =3D NULL;
 	if (coalesced)
 		imu->folio_shift =3D data.folio_shift;
 	refcount_set(&imu->refs, 1);
@@ -860,6 +866,89 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx,=
 void __user *arg,
 	return ret;
 }
=20
+int io_buffer_register_bvec(struct io_ring_ctx *ctx, struct request *rq,
+			    void (*release)(void *), unsigned int index,
+			    unsigned int issue_flags)
+{
+	struct io_rsrc_data *data =3D &ctx->buf_table;
+	struct req_iterator rq_iter;
+	struct io_mapped_ubuf *imu;
+	struct io_rsrc_node *node;
+	int ret =3D 0, i =3D 0;
+	struct bio_vec bv;
+	u16 nr_bvecs;
+
+	io_ring_submit_lock(ctx, issue_flags);
+
+	if (index >=3D data->nr) {
+		ret =3D -EINVAL;
+		goto unlock;
+	}
+
+	node =3D data->nodes[index];
+	if (node) {
+		ret =3D -EBUSY;
+		goto unlock;
+	}
+
+	node =3D io_rsrc_node_alloc(IORING_RSRC_BUFFER);
+	if (!node) {
+		ret =3D -ENOMEM;
+		goto unlock;
+	}
+
+	nr_bvecs =3D blk_rq_nr_phys_segments(rq);
+	imu =3D kvmalloc(struct_size(imu, bvec, nr_bvecs), GFP_KERNEL);
+	if (!imu) {
+		kfree(node);
+		ret =3D -ENOMEM;
+		goto unlock;
+	}
+
+	imu->ubuf =3D 0;
+	imu->len =3D blk_rq_bytes(rq);
+	imu->acct_pages =3D 0;
+	imu->nr_bvecs =3D nr_bvecs;
+	refcount_set(&imu->refs, 1);
+	imu->release =3D release;
+	imu->priv =3D rq;
+
+	rq_for_each_bvec(bv, rq, rq_iter)
+		bvec_set_page(&imu->bvec[i++], bv.bv_page, bv.bv_len,
+			      bv.bv_offset);
+
+	node->buf =3D imu;
+	data->nodes[index] =3D node;
+unlock:
+	io_ring_submit_unlock(ctx, issue_flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(io_buffer_register_bvec);
+
+void io_buffer_unregister_bvec(struct io_ring_ctx *ctx, unsigned int ind=
ex,
+			       unsigned int issue_flags)
+{
+	struct io_rsrc_data *data =3D &ctx->buf_table;
+	struct io_rsrc_node *node;
+
+	io_ring_submit_lock(ctx, issue_flags);
+
+	if (!data->nr)
+		goto unlock;
+	if (index >=3D data->nr)
+		goto unlock;
+
+	node =3D data->nodes[index];
+	if (!node || !node->buf)
+		goto unlock;
+	if (!node->buf->release)
+		goto unlock;
+	io_reset_rsrc_node(ctx, data, index);
+unlock:
+	io_ring_submit_unlock(ctx, issue_flags);
+}
+EXPORT_SYMBOL_GPL(io_buffer_unregister_bvec);
+
 int io_import_fixed(int ddir, struct iov_iter *iter,
 			   struct io_mapped_ubuf *imu,
 			   u64 buf_addr, size_t len)
@@ -886,8 +975,8 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 		/*
 		 * Don't use iov_iter_advance() here, as it's really slow for
 		 * using the latter parts of a big fixed buffer - it iterates
-		 * over each segment manually. We can cheat a bit here, because
-		 * we know that:
+		 * over each segment manually. We can cheat a bit here for user
+		 * registered nodes, because we know that:
 		 *
 		 * 1) it's a BVEC iter, we set it up
 		 * 2) all bvecs are the same in size, except potentially the
@@ -901,8 +990,15 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 		 */
 		const struct bio_vec *bvec =3D imu->bvec;
=20
+		/*
+		 * Kernel buffer bvecs, on the other hand, don't necessarily
+		 * have the size property of user registered ones, so we have
+		 * to use the slow iter advance.
+		 */
 		if (offset < bvec->bv_len) {
 			iter->iov_offset =3D offset;
+		} else if (imu->release) {
+			iov_iter_advance(iter, offset);
 		} else {
 			unsigned long seg_skip;
=20
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 190f7ee45de93..2e8d1862caefc 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -33,6 +33,8 @@ struct io_mapped_ubuf {
 	unsigned int    folio_shift;
 	refcount_t	refs;
 	unsigned long	acct_pages;
+	void		(*release)(void *);
+	void		*priv;
 	struct bio_vec	bvec[] __counted_by(nr_bvecs);
 };
=20
--=20
2.43.5


