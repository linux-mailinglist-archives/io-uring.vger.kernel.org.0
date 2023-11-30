Return-Path: <io-uring+bounces-184-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A9527FFE0A
	for <lists+io-uring@lfdr.de>; Thu, 30 Nov 2023 22:53:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E6E61C20CBA
	for <lists+io-uring@lfdr.de>; Thu, 30 Nov 2023 21:53:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B7375EE6C;
	Thu, 30 Nov 2023 21:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="LlwIWXd3"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CA2310DC
	for <io-uring@vger.kernel.org>; Thu, 30 Nov 2023 13:53:26 -0800 (PST)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AULK79C028667
	for <io-uring@vger.kernel.org>; Thu, 30 Nov 2023 13:53:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=5e0TgfFFgQy08YzjpeA6/6zT5/VcXS1eocs3PaK3skM=;
 b=LlwIWXd3XTKHd0k6aIOUbMoKWqmJscj4ckSdm8IokGU+wwyyHhSwZV19OePBFrlQfMEm
 OmmE2Z1EN/1gVaODS5b90+bRZoCOyrtYP1egnMinu2jJI6UB+9L8B+gfjwfvjaVG70SC
 r+UFClgM2ckoUlxTQacVMqz0Pv2mzaSuus/mgwPVr5kYuM2nWg/iEUO8N1hlHatGk1uH
 P3wp/GohOLdcS6VXCCNRy8UrLi3Blc5yFgvx+HrzCp8bja9YUmxyToWejfavgaLjxPx4
 hs7KnQ0C9ByWCZqO2sm+/gsFxrZ9pqxv572qq2N/xC+T47x2TXpvGALapyAZRKcrx4L0 6A== 
Received: from maileast.thefacebook.com ([163.114.130.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3uphtvxqh6-9
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Thu, 30 Nov 2023 13:53:25 -0800
Received: from twshared51573.38.frc1.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Thu, 30 Nov 2023 13:53:23 -0800
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
	id 3B0D9226BF683; Thu, 30 Nov 2023 13:53:10 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <io-uring@vger.kernel.org>
CC: <axboe@kernel.dk>, <hch@lst.de>, <joshi.k@samsung.com>,
        <martin.petersen@oracle.com>, <ming.lei@redhat.com>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCHv5 1/4] block: bio-integrity: directly map user buffers
Date: Thu, 30 Nov 2023 13:53:06 -0800
Message-ID: <20231130215309.2923568-2-kbusch@meta.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231130215309.2923568-1-kbusch@meta.com>
References: <20231130215309.2923568-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: HzaNeyDIePWGXS6IrC8G5wbw0dBy3gdX
X-Proofpoint-GUID: HzaNeyDIePWGXS6IrC8G5wbw0dBy3gdX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-30_22,2023-11-30_01,2023-05-22_02

From: Keith Busch <kbusch@kernel.org>

Passthrough commands that utilize metadata currently need to bounce the
user space buffer through the kernel. Add support for mapping user space
directly so that we can avoid this costly overhead. This is similar to
how the normal bio data payload utilizes user addresses with
bio_map_user_iov().

If the user address can't directly be used for reason, like too many
segments or address unalignement, fallback to a copy of the user vec
while keeping the user address pinned for the IO duration so that it
can safely be copied on completion in any process context.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 block/bio-integrity.c | 214 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/bio.h   |   9 ++
 2 files changed, 223 insertions(+)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index ec8ac8cf6e1b9..674a2c80454b3 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -91,6 +91,47 @@ struct bio_integrity_payload *bio_integrity_alloc(stru=
ct bio *bio,
 }
 EXPORT_SYMBOL(bio_integrity_alloc);
=20
+static void bio_integrity_unpin_bvec(struct bio_vec *bv, int nr_vecs,
+				     bool dirty)
+{
+	int i;
+
+	for (i =3D 0; i < nr_vecs; i++) {
+		if (dirty && !PageCompound(bv[i].bv_page))
+			set_page_dirty_lock(bv[i].bv_page);
+		unpin_user_page(bv[i].bv_page);
+	}
+}
+
+static void bio_integrity_uncopy_user(struct bio_integrity_payload *bip)
+{
+	unsigned short nr_vecs =3D bip->bip_max_vcnt - 1;
+	struct bio_vec *copy =3D &bip->bip_vec[1];
+	size_t bytes =3D bip->bip_iter.bi_size;
+	struct iov_iter iter;
+	int ret;
+
+	iov_iter_bvec(&iter, ITER_DEST, copy, nr_vecs, bytes);
+	ret =3D copy_to_iter(bvec_virt(bip->bip_vec), bytes, &iter);
+	WARN_ON_ONCE(ret !=3D bytes);
+
+	bio_integrity_unpin_bvec(copy, nr_vecs, true);
+}
+
+static void bio_integrity_unmap_user(struct bio_integrity_payload *bip)
+{
+	bool dirty =3D bio_data_dir(bip->bip_bio) =3D=3D READ;
+
+	if (bip->bip_flags & BIP_COPY_USER) {
+		if (dirty)
+			bio_integrity_uncopy_user(bip);
+		kfree(bvec_virt(bip->bip_vec));
+		return;
+	}
+
+	bio_integrity_unpin_bvec(bip->bip_vec, bip->bip_max_vcnt, dirty);
+}
+
 /**
  * bio_integrity_free - Free bio integrity payload
  * @bio:	bio containing bip to be freed
@@ -105,6 +146,8 @@ void bio_integrity_free(struct bio *bio)
=20
 	if (bip->bip_flags & BIP_BLOCK_INTEGRITY)
 		kfree(bvec_virt(bip->bip_vec));
+	else if (bip->bip_flags & BIP_INTEGRITY_USER)
+		bio_integrity_unmap_user(bip);
=20
 	__bio_integrity_free(bs, bip);
 	bio->bi_integrity =3D NULL;
@@ -160,6 +203,177 @@ int bio_integrity_add_page(struct bio *bio, struct =
page *page,
 }
 EXPORT_SYMBOL(bio_integrity_add_page);
=20
+static int bio_integrity_copy_user(struct bio *bio, struct bio_vec *bvec=
,
+				   int nr_vecs, unsigned int len,
+				   unsigned int direction, u32 seed)
+{
+	bool write =3D direction =3D=3D ITER_SOURCE;
+	struct bio_integrity_payload *bip;
+	struct iov_iter iter;
+	void *buf;
+	int ret;
+
+	buf =3D kmalloc(len, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	if (write) {
+		iov_iter_bvec(&iter, direction, bvec, nr_vecs, len);
+		if (!copy_from_iter_full(buf, len, &iter)) {
+			ret =3D -EFAULT;
+			goto free_buf;
+		}
+
+		bip =3D bio_integrity_alloc(bio, GFP_KERNEL, 1);
+	} else {
+		memset(buf, 0, len);
+
+		/*
+		 * We need to preserve the original bvec and the number of vecs
+		 * in it for completion handling
+		 */
+		bip =3D bio_integrity_alloc(bio, GFP_KERNEL, nr_vecs + 1);
+	}
+
+	if (IS_ERR(bip)) {
+		ret =3D PTR_ERR(bip);
+		goto free_buf;
+	}
+
+	if (write)
+		bio_integrity_unpin_bvec(bvec, nr_vecs, false);
+	else
+		memcpy(&bip->bip_vec[1], bvec, nr_vecs * sizeof(*bvec));
+
+	ret =3D bio_integrity_add_page(bio, virt_to_page(buf), len,
+				     offset_in_page(buf));
+	if (ret !=3D len) {
+		ret =3D -ENOMEM;
+		goto free_bip;
+	}
+
+	bip->bip_flags |=3D BIP_INTEGRITY_USER | BIP_COPY_USER;
+	bip->bip_iter.bi_sector =3D seed;
+	return 0;
+free_bip:
+	bio_integrity_free(bio);
+free_buf:
+	kfree(buf);
+	return ret;
+}
+
+static int bio_integrity_init_user(struct bio *bio, struct bio_vec *bvec=
,
+				   int nr_vecs, unsigned int len, u32 seed)
+{
+	struct bio_integrity_payload *bip;
+
+	bip =3D bio_integrity_alloc(bio, GFP_KERNEL, nr_vecs);
+	if (IS_ERR(bip))
+		return PTR_ERR(bip);
+
+	memcpy(bip->bip_vec, bvec, nr_vecs * sizeof(*bvec));
+	bip->bip_flags |=3D BIP_INTEGRITY_USER;
+	bip->bip_iter.bi_sector =3D seed;
+	bip->bip_iter.bi_size =3D len;
+	return 0;
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
+	struct page *stack_pages[UIO_FASTIOV], **pages =3D stack_pages;
+	struct bio_vec stack_vec[UIO_FASTIOV], *bvec =3D stack_vec;
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
+	if (nr_bvecs > queue_max_integrity_segments(q))
+		copy =3D true;
+
+	if (copy)
+		ret =3D bio_integrity_copy_user(bio, bvec, nr_bvecs, bytes,
+					      direction, seed);
+	else
+		ret =3D bio_integrity_init_user(bio, bvec, nr_bvecs, bytes, seed);
+	if (ret)
+		goto release_pages;
+	if (bvec !=3D stack_vec)
+		kfree(bvec);
+
+	return 0;
+
+release_pages:
+	bio_integrity_unpin_bvec(bvec, nr_bvecs, false);
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
index 41d417ee13499..ec4db73e5f4ec 100644
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
@@ -718,6 +720,7 @@ static inline bool bioset_initialized(struct bio_set =
*bs)
 	for_each_bio(_bio)						\
 		bip_for_each_vec(_bvl, _bio->bi_integrity, _iter)
=20
+int bio_integrity_map_user(struct bio *bio, void __user *ubuf, ssize_t l=
en, u32 seed);
 extern struct bio_integrity_payload *bio_integrity_alloc(struct bio *, g=
fp_t, unsigned int);
 extern int bio_integrity_add_page(struct bio *, struct page *, unsigned =
int, unsigned int);
 extern bool bio_integrity_prep(struct bio *);
@@ -789,6 +792,12 @@ static inline int bio_integrity_add_page(struct bio =
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


