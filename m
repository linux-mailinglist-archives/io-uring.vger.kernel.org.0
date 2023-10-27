Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8A497D9FC0
	for <lists+io-uring@lfdr.de>; Fri, 27 Oct 2023 20:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbjJ0SUP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Oct 2023 14:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231594AbjJ0SUO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Oct 2023 14:20:14 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB1CAC
        for <io-uring@vger.kernel.org>; Fri, 27 Oct 2023 11:20:11 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39RE5mPB006170
        for <io-uring@vger.kernel.org>; Fri, 27 Oct 2023 11:20:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=PeYXdDD9BDy0e7ssYNWuuSlwKOHdUA7B3s3SZXstLZY=;
 b=k2984Iyczg58uKzsKECSyrffc0HQFOwZWyt7tuvyBhhpolnpp4JTmLB4+JY5I7u2P7v1
 OQk8DtfrJlpQ5Xe5WDZ50V7F+EwdcCTJ/6jlBX2cLSEIiCW+LCr5eeL5WzVmm1lTmyBu
 nimJJaVB8yttwM3v6Sl66PBx2+6dONYftN+QjZSr2mcDr9JRtxcgdfyhZpcgbfUJXvTA
 WaHdQGyqdzoyXJolIRrGVCcZaK+qKT1ArhH5BLnPaXqGR+3lf/E8aRbu5RMx7/fgFQF/
 avfN9pPIKvwZbU7pVhCUZI1BJJ3YvDdENteK1DfloUYKoO++3My6rtks2qhbC7mlCZy5 eA== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3tywry0fu4-20
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 27 Oct 2023 11:20:10 -0700
Received: from twshared15991.38.frc1.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Fri, 27 Oct 2023 11:20:04 -0700
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id 4268A20D093C1; Fri, 27 Oct 2023 11:19:50 -0700 (PDT)
From:   Keith Busch <kbusch@meta.com>
To:     <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <hch@lst.de>, <joshi.k@samsung.com>,
        <martin.petersen@oracle.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv2 1/4] block: bio-integrity: directly map user buffers
Date:   Fri, 27 Oct 2023 11:19:26 -0700
Message-ID: <20231027181929.2589937-2-kbusch@meta.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231027181929.2589937-1-kbusch@meta.com>
References: <20231027181929.2589937-1-kbusch@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: nQ_Si2SFuWJzEvUz-TV5i3bHPN_Yg_nC
X-Proofpoint-GUID: nQ_Si2SFuWJzEvUz-TV5i3bHPN_Yg_nC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-27_17,2023-10-27_01,2023-05-22_02
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

Passthrough commands that utilize metadata currently need to bounce the
user space buffer through the kernel. Add support for mapping user space
directly so that we can avoid this costly overhead. This is similiar to
how the normal bio data payload utilizes user addresses with
bio_map_user_iov().

If the user address can't directly be used for reasons like too many
segments or address unalignement, fallback to a copy of the user vec
while keeping the user address pinned for the IO duration so that it
can safely be copied on completion in any process context.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 block/bio-integrity.c | 195 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/bio.h   |   9 ++
 2 files changed, 204 insertions(+)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index ec8ac8cf6e1b9..7f9d242ad79df 100644
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
+	struct bio_vec *copy =3D bip->copy_vec;
+	struct bvec_iter iter;
+	struct bio_vec bv;
+
+	if (copy) {
+		unsigned short nr_vecs =3D bip->bip_max_vcnt;
+		size_t bytes =3D bip->bip_iter.bi_size;
+		void *buf =3D bvec_virt(bip->bip_vec);
+
+		if (dirty) {
+			struct iov_iter iter;
+
+			iov_iter_bvec(&iter, ITER_DEST, copy, nr_vecs, bytes);
+			WARN_ON(copy_to_iter(buf, bytes, &iter) !=3D bytes);
+		}
+
+		memcpy(bip->bip_vec, copy, nr_vecs * sizeof(*copy));
+		kfree(copy);
+		kfree(buf);
+	}
+
+	bip_for_each_vec(bv, bip, iter) {
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
+		bio_integrity_unmap_user(bip);
=20
 	__bio_integrity_free(bs, bip);
 	bio->bi_integrity =3D NULL;
@@ -160,6 +193,168 @@ int bio_integrity_add_page(struct bio *bio, struct =
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
+	/* if bvec is on the stack, we need to allocate a copy for the completi=
on */
+	if (nr_vecs <=3D UIO_FASTIOV) {
+		copy_vec =3D kcalloc(sizeof(*bvec), nr_vecs, GFP_KERNEL);
+		if (!copy_vec)
+			return -ENOMEM;
+		memcpy(copy_vec, bvec, nr_vecs * sizeof(*bvec));
+	}
+
+	buf =3D kmalloc(len, GFP_KERNEL);
+	if (!buf)
+		goto free_copy;
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
+	 * We just need one vec for this bip, but we need to preserve the
+	 * number of vecs in the user bvec for the completion handling, so use
+	 * nr_vecs.
+	 */
+	bip =3D bio_integrity_alloc(bio, GFP_KERNEL, nr_vecs);
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
+	bip->bip_flags |=3D BIP_INTEGRITY_USER;
+	bip->copy_vec =3D copy_vec ?: bvec;
+	return 0;
+free_bip:
+	bio_integrity_free(bio);
+free_buf:
+	kfree(buf);
+free_copy:
+	kfree(copy_vec);
+	return ret;
+}
+
+int bio_integrity_map_user(struct bio *bio, void __user *ubuf, unsigned =
int len,
+			   u32 seed)
+{
+	struct request_queue *q =3D bdev_get_queue(bio->bi_bdev);
+	unsigned long offs, align =3D q->dma_pad_mask | queue_dma_alignment(q);
+	int ret, direction, nr_vecs, i, j, folios =3D 0;
+	struct bio_vec stack_vec[UIO_FASTIOV];
+	struct bio_vec bv, *bvec =3D stack_vec;
+	struct page *stack_pages[UIO_FASTIOV];
+	struct page **pages =3D stack_pages;
+	struct bio_integrity_payload *bip;
+	struct iov_iter iter;
+	struct bvec_iter bi;
+	u32 bytes;
+
+	if (bio_integrity(bio))
+		return -EINVAL;
+	if (len >> SECTOR_SHIFT > queue_max_hw_sectors(q))
+		return -E2BIG;
+
+	if (bio_data_dir(bio) =3D=3D READ)
+		direction =3D ITER_DEST;
+	else
+		direction =3D ITER_SOURCE;
+
+	iov_iter_ubuf(&iter, direction, ubuf, len);
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
+	bytes =3D iov_iter_extract_pages(&iter, &pages, len, nr_vecs, 0, &offs)=
;
+	if (unlikely(bytes < 0)) {
+		ret =3D  bytes;
+		goto free_bvec;
+	}
+
+	for (i =3D 0; i < nr_vecs; i =3D j) {
+		size_t size =3D min_t(size_t, bytes, PAGE_SIZE - offs);
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
+		bvec_set_page(&bvec[folios], pages[i], size, offs);
+		offs =3D 0;
+		folios++;
+	}
+
+	if (pages !=3D stack_pages)
+		kvfree(pages);
+
+	if (folios > queue_max_integrity_segments(q) ||
+	    !iov_iter_is_aligned(&iter, align, align)) {
+		ret =3D bio_integrity_copy_user(bio, bvec, folios, len,
+					      direction, seed);
+		if (ret)
+			goto release_pages;
+		return 0;
+	}
+
+	bip =3D bio_integrity_alloc(bio, GFP_KERNEL, folios);
+	if (IS_ERR(bip)) {
+		ret =3D PTR_ERR(bip);
+		goto release_pages;
+	}
+
+	memcpy(bip->bip_vec, bvec, folios * sizeof(*bvec));
+	if (bvec !=3D stack_vec)
+		kfree(bvec);
+
+	bip->bip_flags |=3D BIP_INTEGRITY_USER;
+	bip->copy_vec =3D NULL;
+	return 0;
+
+release_pages:
+	bi.bi_size =3D len;
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
index 41d417ee13499..2b4a0de838ed1 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -324,6 +324,7 @@ enum bip_flags {
 	BIP_CTRL_NOCHECK	=3D 1 << 2, /* disable HBA integrity checking */
 	BIP_DISK_NOCHECK	=3D 1 << 3, /* disable disk integrity checking */
 	BIP_IP_CHECKSUM		=3D 1 << 4, /* IP checksum */
+	BIP_INTEGRITY_USER	=3D 1 << 5, /* Integrity payload is user address */
 };
=20
 /*
@@ -342,6 +343,7 @@ struct bio_integrity_payload {
=20
 	struct work_struct	bip_work;	/* I/O completion */
=20
+	struct bio_vec		*copy_vec;	/* for bounce buffering */
 	struct bio_vec		*bip_vec;
 	struct bio_vec		bip_inline_vecs[];/* embedded bvec array */
 };
@@ -720,6 +722,7 @@ static inline bool bioset_initialized(struct bio_set =
*bs)
=20
 extern struct bio_integrity_payload *bio_integrity_alloc(struct bio *, g=
fp_t, unsigned int);
 extern int bio_integrity_add_page(struct bio *, struct page *, unsigned =
int, unsigned int);
+extern int bio_integrity_map_user(struct bio *, void __user *, unsigned =
int, u32);
 extern bool bio_integrity_prep(struct bio *);
 extern void bio_integrity_advance(struct bio *, unsigned int);
 extern void bio_integrity_trim(struct bio *);
@@ -789,6 +792,12 @@ static inline int bio_integrity_add_page(struct bio =
*bio, struct page *page,
 	return 0;
 }
=20
+static inline int bio_integrity_map_user(struct bio *bio, void __user *u=
buf,
+					 unsigned int len, u32 seed)
+{
+	return -EINVAL
+}
+
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
=20
 /*
--=20
2.34.1

