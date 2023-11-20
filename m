Return-Path: <io-uring+bounces-110-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EF9E37F2080
	for <lists+io-uring@lfdr.de>; Mon, 20 Nov 2023 23:41:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4454282868
	for <lists+io-uring@lfdr.de>; Mon, 20 Nov 2023 22:41:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 484B81DA26;
	Mon, 20 Nov 2023 22:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="ke7kozMX"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CAAEDC
	for <io-uring@vger.kernel.org>; Mon, 20 Nov 2023 14:41:12 -0800 (PST)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AKMea4K009917
	for <io-uring@vger.kernel.org>; Mon, 20 Nov 2023 14:41:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=5ew+XAuH3RqBNgWMEi/qeIiglxTH5oaEEznq/j3WIvo=;
 b=ke7kozMX8nqP3k4p0Ij3mD7IyFOoaoEtMM9U5c1Jdqs/+pPtUhII5K8YJLjNsf+FRHsD
 SSTCBrdFKK83HoILaOWXqy2Cugwng7btfhAu+PLNSC4UxAmXSBTFl/X7FIwmKTEv4U/y
 PVOv7tvm5miDMJcwgU+Slx6pervealhf+X5kNqgRIQkbZrOmPEJanSHX7OFDfsFdsllt
 UhYFYDoJX2TXJ7o1q4pGHvtoC22KChSmg6Uq2mr2OPQI3yowTXiXmZNqWA4mnnxsUdQ2
 VR9/rrhCeNh8iM7imMPr1gk37Q//I1RM2usQKLyULARy1dvWm9IHjOblp22GePBiOcHr oA== 
Received: from maileast.thefacebook.com ([163.114.130.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3uggeq808b-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 20 Nov 2023 14:41:11 -0800
Received: from twshared29647.38.frc1.facebook.com (2620:10d:c0a8:1b::2d) by
 mail.thefacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 20 Nov 2023 14:41:10 -0800
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
	id AD1E721F1B1AC; Mon, 20 Nov 2023 14:40:59 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <io-uring@vger.kernel.org>
CC: <axboe@kernel.dk>, <hch@lst.de>, <joshi.k@samsung.com>,
        <martin.petersen@oracle.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv3 2/5] block: bio-integrity: directly map user buffers
Date: Mon, 20 Nov 2023 14:40:55 -0800
Message-ID: <20231120224058.2750705-3-kbusch@meta.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231120224058.2750705-1-kbusch@meta.com>
References: <20231120224058.2750705-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: q1kM6MlkkQu6LM1rdTOFSGM2dBPv_3ch
X-Proofpoint-ORIG-GUID: q1kM6MlkkQu6LM1rdTOFSGM2dBPv_3ch
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-20_22,2023-11-20_01,2023-05-22_02

From: Keith Busch <kbusch@kernel.org>

Passthrough commands that utilize metadata currently bounce the user
space buffer through the kernel. Add support for mapping user space
directly so that we can avoid this costly overhead. This is similiar to
how the normal bio data payload utilizes user addresses with
bio_map_user_iov().

If the user address can't directly be used for reasons like too many
segments or address unalignement, fallback to a copy of the user vec
while keeping the user address pinned for the IO duration so that it
can safely be copied on completion in any process context.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 block/bio-integrity.c | 212 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/bio.h   |  12 +++
 2 files changed, 224 insertions(+)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index ec8ac8cf6e1b9..b761058bfb92f 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -91,6 +91,37 @@ struct bio_integrity_payload *bio_integrity_alloc(stru=
ct bio *bio,
 }
 EXPORT_SYMBOL(bio_integrity_alloc);
=20
+static void bio_integrity_unmap_user(struct bio_integrity_payload *bip)
+{
+	bool dirty =3D bio_data_dir(bip->bip_bio) =3D=3D READ;
+	struct bvec_iter iter;
+	struct bio_vec bv;
+
+	if (bip->bip_flags & BIP_COPY_USER) {
+		unsigned short nr_vecs =3D bip->bip_max_vcnt - 1;
+		struct bio_vec *copy =3D bvec_virt(&bip->bip_vec[nr_vecs]);
+		size_t bytes =3D bip->bip_iter.bi_size;
+		void *buf =3D bvec_virt(bip->bip_vec);
+
+		if (dirty) {
+			struct iov_iter iter;
+
+			iov_iter_bvec(&iter, ITER_DEST, copy, nr_vecs, bytes);
+			WARN_ON_ONCE(copy_to_iter(buf, bytes, &iter) !=3D bytes);
+		}
+
+		memcpy(bip->bip_vec, copy, nr_vecs * sizeof(*copy));
+		kfree(copy);
+		kfree(buf);
+	}
+
+	bip_for_each_mp_vec(bv, bip, iter) {
+		if (dirty && !PageCompound(bv.bv_page))
+			set_page_dirty_lock(bv.bv_page);
+		unpin_user_page(bv.bv_page);
+	}
+}
+
 /**
  * bio_integrity_free - Free bio integrity payload
  * @bio:	bio containing bip to be freed
@@ -105,6 +136,8 @@ void bio_integrity_free(struct bio *bio)
=20
 	if (bip->bip_flags & BIP_BLOCK_INTEGRITY)
 		kfree(bvec_virt(bip->bip_vec));
+	else if (bip->bip_flags & BIP_INTEGRITY_USER)
+		bio_integrity_unmap_user(bip);;
=20
 	__bio_integrity_free(bs, bip);
 	bio->bi_integrity =3D NULL;
@@ -160,6 +193,185 @@ int bio_integrity_add_page(struct bio *bio, struct =
page *page,
 }
 EXPORT_SYMBOL(bio_integrity_add_page);
=20
+static int bio_integrity_copy_user(struct bio *bio, struct bio_vec *bvec=
,
+				   int nr_vecs, unsigned int len,
+				   unsigned int direction, u32 seed)
+{
+	struct bio_integrity_payload *bip;
+	struct bio_vec *copy_vec =3D NULL;
+	struct iov_iter iter;
+	void *buf;
+	int ret;
+
+	/* We need to allocate a copy for the completion if bvec is on stack */
+	if (nr_vecs <=3D UIO_FASTIOV) {
+		copy_vec =3D kcalloc(sizeof(*bvec), nr_vecs, GFP_KERNEL);
+		if (!copy_vec)
+			return -ENOMEM;
+		memcpy(copy_vec, bvec, nr_vecs * sizeof(*bvec));
+		bvec =3D copy_vec;
+	}
+
+	buf =3D kmalloc(len, GFP_KERNEL);
+	if (!buf) {
+		ret =3D -ENOMEM;
+		goto free_copy;
+	}
+
+	if (direction =3D=3D ITER_SOURCE) {
+		iov_iter_bvec(&iter, direction, bvec, nr_vecs, len);
+		if (!copy_from_iter_full(buf, len, &iter)) {
+			ret =3D -EFAULT;
+			goto free_buf;
+		}
+	} else {
+		memset(buf, 0, len);
+	}
+
+	/*
+	 * We need just one vec for this bip, but we also need to preserve the
+	 * a pointer to the original bvec and the number of vecs in it for
+	 * completion handling
+	 */
+	bip =3D bio_integrity_alloc(bio, GFP_KERNEL, nr_vecs + 1);
+	if (IS_ERR(bip)) {
+		ret =3D PTR_ERR(bip);
+		goto free_buf;
+	}
+
+	ret =3D bio_integrity_add_page(bio, virt_to_page(buf), len,
+				     offset_in_page(buf));
+	if (ret !=3D len) {
+		ret =3D -ENOMEM;
+		goto free_bip;
+	}
+
+	/*
+	 * Save a pointer to the user bvec at the end of this bip's bvec for
+	 * completion handling: we know the index won't be used for anything
+	 * else.
+	 */
+	bvec_set_page(&bip->bip_vec[nr_vecs], virt_to_page(bvec), 0,
+		      offset_in_page(bvec));
+	bip->bip_flags |=3D BIP_INTEGRITY_USER | BIP_COPY_USER;
+	return 0;
+
+free_bip:
+	bio_integrity_free(bio);
+free_buf:
+	kfree(buf);
+free_copy:
+	kfree(copy_vec);
+	return ret;
+}
+
+static unsigned int bvec_from_pages(struct bio_vec *bvec, struct page **=
pages,
+				    int nr_vecs, ssize_t bytes, ssize_t offset)
+{
+	unsigned int nr_bvecs =3D 0;
+	int i, j;
+
+	for (i =3D 0; i < nr_vecs; i =3D j) {
+		size_t size =3D min_t(size_t, bytes, PAGE_SIZE - offset);
+		struct folio *folio =3D page_folio(pages[i]);
+
+		bytes -=3D size;
+		for (j =3D i + 1; j < nr_vecs; j++) {
+			size_t next =3D min_t(size_t, PAGE_SIZE, bytes);
+
+			if (page_folio(pages[j]) !=3D folio ||
+			    pages[j] !=3D pages[j - 1] + 1)
+				break;
+			unpin_user_page(pages[j]);
+			size +=3D next;
+			bytes -=3D next;
+		}
+
+		bvec_set_page(&bvec[nr_bvecs], pages[i], size, offset);
+		offset =3D 0;
+		nr_bvecs++;
+	}
+
+	return nr_bvecs;
+}
+
+int bio_integrity_map_user(struct bio *bio, void __user *ubuf, ssize_t b=
ytes,
+			   u32 seed)
+{
+	struct request_queue *q =3D bdev_get_queue(bio->bi_bdev);
+	unsigned int align =3D q->dma_pad_mask | queue_dma_alignment(q);
+	struct bio_vec bv, stack_vec[UIO_FASTIOV], *bvec =3D stack_vec;
+	struct page *stack_pages[UIO_FASTIOV], **pages =3D stack_pages;
+	struct bvec_iter bi =3D { bi.bi_size =3D bytes, };
+	unsigned int direction, nr_bvecs;
+	struct iov_iter iter;
+	int ret, nr_vecs;
+	size_t offset;
+	bool copy;
+
+	if (bio_integrity(bio))
+		return -EINVAL;
+	if (bytes >> SECTOR_SHIFT > queue_max_hw_sectors(q))
+		return -E2BIG;
+
+	if (bio_data_dir(bio) =3D=3D READ)
+		direction =3D ITER_DEST;
+	else
+		direction =3D ITER_SOURCE;
+
+	iov_iter_ubuf(&iter, direction, ubuf, bytes);
+	nr_vecs =3D iov_iter_npages(&iter, BIO_MAX_VECS + 1);
+	if (nr_vecs > BIO_MAX_VECS)
+		return -E2BIG;
+	if (nr_vecs > UIO_FASTIOV) {
+		bvec =3D kcalloc(sizeof(*bvec), nr_vecs, GFP_KERNEL);
+		if (!bvec)
+			return -ENOMEM;
+		pages =3D NULL;
+	}
+
+	copy =3D !iov_iter_is_aligned(&iter, align, align);
+	ret =3D iov_iter_extract_pages(&iter, &pages, bytes, nr_vecs, 0, &offse=
t);
+	if (unlikely(ret < 0))
+		goto free_bvec;
+
+	nr_bvecs =3D bvec_from_pages(bvec, pages, nr_vecs, bytes, offset);
+	if (pages !=3D stack_pages)
+		kvfree(pages);
+
+	if (nr_bvecs > queue_max_integrity_segments(q) || copy) {
+		ret =3D bio_integrity_copy_user(bio, bvec, nr_bvecs, bytes,
+					      direction, seed);
+		if (ret)
+			goto release_pages;
+	} else {
+		struct bio_integrity_payload *bip;
+
+		bip =3D bio_integrity_alloc(bio, GFP_KERNEL, nr_bvecs);
+		if (IS_ERR(bip)) {
+			ret =3D PTR_ERR(bip);
+			goto release_pages;
+		}
+
+		memcpy(bip->bip_vec, bvec, nr_bvecs * sizeof(*bvec));
+		bip->bip_flags |=3D BIP_INTEGRITY_USER;
+		bip->bip_iter.bi_size =3D bytes;
+		if (bvec !=3D stack_vec)
+			kfree(bvec);
+	}
+
+	return 0;
+
+release_pages:
+	for_each_bvec(bv, bvec, bi, bi)
+		unpin_user_page(bv.bv_page);
+free_bvec:
+	if (bvec !=3D stack_vec)
+		kfree(bvec);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(bio_integrity_map_user);
+
 /**
  * bio_integrity_process - Process integrity metadata for a bio
  * @bio:	bio to generate/verify integrity metadata for
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 41d417ee13499..09e123e7c4941 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -324,6 +324,8 @@ enum bip_flags {
 	BIP_CTRL_NOCHECK	=3D 1 << 2, /* disable HBA integrity checking */
 	BIP_DISK_NOCHECK	=3D 1 << 3, /* disable disk integrity checking */
 	BIP_IP_CHECKSUM		=3D 1 << 4, /* IP checksum */
+	BIP_INTEGRITY_USER	=3D 1 << 5, /* Integrity payload is user address */
+	BIP_COPY_USER		=3D 1 << 6, /* Kernel bounce buffer in use */
 };
=20
 /*
@@ -714,12 +716,16 @@ static inline bool bioset_initialized(struct bio_se=
t *bs)
 #define bip_for_each_vec(bvl, bip, iter)				\
 	for_each_bvec(bvl, (bip)->bip_vec, iter, (bip)->bip_iter)
=20
+#define bip_for_each_mp_vec(bvl, bip, iter)				\
+	for_each_mp_bvec(bvl, (bip)->bip_vec, iter, (bip)->bip_iter)
+
 #define bio_for_each_integrity_vec(_bvl, _bio, _iter)			\
 	for_each_bio(_bio)						\
 		bip_for_each_vec(_bvl, _bio->bi_integrity, _iter)
=20
 extern struct bio_integrity_payload *bio_integrity_alloc(struct bio *, g=
fp_t, unsigned int);
 extern int bio_integrity_add_page(struct bio *, struct page *, unsigned =
int, unsigned int);
+extern int bio_integrity_map_user(struct bio *, void __user *, ssize_t, =
u32);
 extern bool bio_integrity_prep(struct bio *);
 extern void bio_integrity_advance(struct bio *, unsigned int);
 extern void bio_integrity_trim(struct bio *);
@@ -789,6 +795,12 @@ static inline int bio_integrity_add_page(struct bio =
*bio, struct page *page,
 	return 0;
 }
=20
+static inline int bio_integrity_map_user(struct bio *bio, void __user *u=
buf,
+					 ssize_t len, u32 seed)
+{
+	return -EINVAL;
+}
+
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
=20
 /*
--=20
2.34.1


