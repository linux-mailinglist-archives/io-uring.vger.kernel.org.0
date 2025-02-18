Return-Path: <io-uring+bounces-6529-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B509CA3ABE4
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 23:43:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 933F6188DEA3
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 22:43:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DA931DB951;
	Tue, 18 Feb 2025 22:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="WAx+wGiS"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DB3286284
	for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 22:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739918578; cv=none; b=VKjTl9NNM9ybCUNLRm7laNd/GHmGDLNHZJcz/+7F3BvOYIWwJwT5+9wk/j7hGjBYnykniSS3uFqMFOqO25HzVvcXR6BffKfm6MFfEB/a4XkFoPeQuNoLroclHf2gGOgmkRNFbbbCbie1FN7hV8a/Z1KY4jH8Zu5YjAPnk8lbsOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739918578; c=relaxed/simple;
	bh=jTjy7LPNvqFdALtiiffxQqcnndBUqhfFd1xPCKV5Mfk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZKa3/ano767Q/5XOb7Vqjniq3vLkzxRt0XMxE9T+i7guQw8HVuNz7C0xm6JT9Wb3ekNTFwi0OiSpIwL440i6tXM3gvhjuUu0HozUUqzGUEKTrR4UvBCX9k/vfB7VHAf3SJnBGrEmqJrkBy9z/Wh0eK/jiqb+emJtjpdrLvl1Di4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=WAx+wGiS; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 51IM833k012484
	for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 14:42:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=YdhinO9MgygS1g0RgVUmEgkJ4y2AQsblBI+d5/g87Q0=; b=WAx+wGiSoEHT
	OLvPPdEDbJnOBpY0Mp6A1x/CLDX3Rsq1cRmnHkbYaIoexaWXXphckYMmNq8AIx4T
	edGQW2OrYDsn0sKdW5I7KxHislh3vNXokQ+pXh2pDVX2lYHBIF392AGeDujDZZZ5
	WIiNetsQTMvYEV+qJB6LhyZbrKAwnT5Wv3GGJoBnjY8cBvr9rWtmVcEedBdfN5ps
	ZXoRU0ZMU6Tqb7x/RqenddWgqRsGouVa/uGwh4IvgOokqf0Jy+gqI8SkVmC7QRGc
	wPL4VqTu/Zh2ohisMHgU8Y1rRBukv5KurVMo3FaDXOTboALlD3zix61IR2DKtNb5
	Dgfy326SVA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 44w018fc2g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 14:42:53 -0800 (PST)
Received: from twshared24170.03.ash8.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Tue, 18 Feb 2025 22:42:47 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 7505C182F61C6; Tue, 18 Feb 2025 14:42:49 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <ming.lei@redhat.com>, <asml.silence@gmail.com>, <axboe@kernel.dk>,
        <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: <bernd@bsbernd.com>, <csander@purestorage.com>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCHv4 2/5] io_uring: add support for kernel registered bvecs
Date: Tue, 18 Feb 2025 14:42:26 -0800
Message-ID: <20250218224229.837848-3-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250218224229.837848-1-kbusch@meta.com>
References: <20250218224229.837848-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 3hurAnMEaPJ8tMB6_5r21-p-8J3SzzHI
X-Proofpoint-ORIG-GUID: 3hurAnMEaPJ8tMB6_5r21-p-8J3SzzHI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-18_10,2025-02-18_01,2024-11-22_01

From: Keith Busch <kbusch@kernel.org>

Provide an interface for the kernel to leverage the existing
pre-registered buffers that io_uring provides. User space can reference
these later to achieve zero-copy IO.

User space must register an empty fixed buffer table with io_uring in
order for the kernel to make use of it.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 include/linux/io_uring.h       |   1 +
 include/linux/io_uring_types.h |   6 ++
 io_uring/rsrc.c                | 115 ++++++++++++++++++++++++++++++---
 io_uring/rsrc.h                |   4 ++
 4 files changed, 118 insertions(+), 8 deletions(-)

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
index 0bcaefc4ffe02..2aed51e8c79ee 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -709,4 +709,10 @@ static inline bool io_ctx_cqe32(struct io_ring_ctx *=
ctx)
 	return ctx->flags & IORING_SETUP_CQE32;
 }
=20
+int io_buffer_register_bvec(struct io_ring_ctx *ctx, struct request *rq,
+			    void (*release)(void *), unsigned int index,
+			    unsigned int issue_flags);
+void io_buffer_unregister_bvec(struct io_ring_ctx *ctx, unsigned int ind=
ex,
+			       unsigned int issue_flags);
+
 #endif
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 20b884c84e55f..88bcacc77b72e 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -103,19 +103,23 @@ int io_buffer_validate(struct iovec *iov)
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
@@ -764,6 +768,10 @@ static struct io_rsrc_node *io_sqe_buffer_register(s=
truct io_ring_ctx *ctx,
 	imu->len =3D iov->iov_len;
 	imu->nr_bvecs =3D nr_pages;
 	imu->folio_shift =3D PAGE_SHIFT;
+	imu->release =3D NULL;
+	imu->priv =3D NULL;
+	imu->readable =3D true;
+	imu->writeable =3D true;
 	if (coalesced)
 		imu->folio_shift =3D data.folio_shift;
 	refcount_set(&imu->refs, 1);
@@ -860,6 +868,87 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx,=
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
+	struct bio_vec bv, *bvec;
+	int ret =3D 0;
+	u16 nr_bvecs;
+
+	io_ring_submit_lock(ctx, issue_flags);
+
+	if (io_rsrc_node_lookup(data, index)) {
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
+	imu->folio_shift =3D PAGE_SHIFT;
+	imu->nr_bvecs =3D nr_bvecs;
+	refcount_set(&imu->refs, 1);
+	imu->release =3D release;
+	imu->priv =3D rq;
+
+	if (rq_data_dir(rq))
+		imu->writeable =3D true;
+	else
+		imu->readable =3D true;
+
+	bvec =3D imu->bvec;
+	rq_for_each_bvec(bv, rq, rq_iter)
+		*bvec++ =3D bv;
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
+
+	node =3D io_rsrc_node_lookup(data, index);
+	if (!node || !node->buf->release)
+		goto unlock;
+
+	io_put_rsrc_node(ctx, node);
+	data->nodes[index] =3D NULL;
+unlock:
+	io_ring_submit_unlock(ctx, issue_flags);
+}
+EXPORT_SYMBOL_GPL(io_buffer_unregister_bvec);
+
 int io_import_fixed(int ddir, struct iov_iter *iter,
 			   struct io_mapped_ubuf *imu,
 			   u64 buf_addr, size_t len)
@@ -874,6 +963,9 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 	/* not inside the mapped region */
 	if (unlikely(buf_addr < imu->ubuf || buf_end > (imu->ubuf + imu->len)))
 		return -EFAULT;
+	if ((ddir =3D=3D READ && !imu->readable) ||
+	    (ddir =3D=3D WRITE && !imu->writeable))
+		return -EFAULT;
=20
 	/*
 	 * Might not be a start of buffer, set size appropriately
@@ -886,8 +978,8 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
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
@@ -901,8 +993,15 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
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
index abf86b5b86140..81c31b93d4f7b 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -33,6 +33,10 @@ struct io_mapped_ubuf {
 	unsigned int    folio_shift;
 	refcount_t	refs;
 	unsigned long	acct_pages;
+	void		(*release)(void *);
+	void		*priv;
+	bool		readable;
+	bool		writeable;
 	struct bio_vec	bvec[] __counted_by(nr_bvecs);
 };
=20
--=20
2.43.5


