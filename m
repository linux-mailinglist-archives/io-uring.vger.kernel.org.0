Return-Path: <io-uring+bounces-2344-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BA98917FF0
	for <lists+io-uring@lfdr.de>; Wed, 26 Jun 2024 13:42:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F0831C21D16
	for <lists+io-uring@lfdr.de>; Wed, 26 Jun 2024 11:42:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8815C17F4E8;
	Wed, 26 Jun 2024 11:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="FUyKPipq"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7C317DE11
	for <io-uring@vger.kernel.org>; Wed, 26 Jun 2024 11:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719402119; cv=none; b=jNQxWGGfL3crvBtBY8xjgkXw/oPgBlD/jLq88054e07Yz8e3yIMYpK1c2m3F2e2Y3AhS9gtnlpy4mr8dMRIyQdlgYK93NVs7q7AowW1rujfB9pAY92c3yoaLpxEqPG7za4YlZIY0q0ACR1/RbPhkaBEZRgJ99062WeYG2fStiJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719402119; c=relaxed/simple;
	bh=AEgBDzVQGk844Eegt8iw9oiuaHP/1nnfap0SBngaKCc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=my0oVGa7FOpehrMM7ZqmSYVFDKjKnfJ7maMiGlAO0ZtXqoD64RG5RTMa68nKCL5UjgVBbjIYntaeeAmOAQp4wUZ1lRew3dlhnV1iRV2cbmCeyuvZ1zrhGafN3jCB5o5xvQjl/jADNkU9o6XBdBk2Eya+IUCaa7QV451XkIyKBf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=FUyKPipq; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240626114148epoutp011b9c316d4e3c0e04de1f53bcef8488ee~cixuYY1aD1547215472epoutp01b
	for <io-uring@vger.kernel.org>; Wed, 26 Jun 2024 11:41:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240626114148epoutp011b9c316d4e3c0e04de1f53bcef8488ee~cixuYY1aD1547215472epoutp01b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1719402108;
	bh=ongxes/b/I2rMYT+M/pu4NPysiQI4JNAWQtlTRipnbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FUyKPipq2IMISo6NPjwdgYBjYsubH+2PqPaV9GYtdbDA71E2N0xjUbxdP3b/ouW+Q
	 O0G7yqhVj56yG2j/RS6fle6ramvmPGNB92nEZZ+c4B5AoWYCEToBEVUH5NjB9C9MYu
	 eR/lf2XbzFbmTD+K0v7GUPy7W5VBBkgyk+8GWrbM=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240626114147epcas5p480cd2670856e62bac64e977c3d60ce1a~cixt7nv2X2886328863epcas5p4L;
	Wed, 26 Jun 2024 11:41:47 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4W8KY611YWz4x9Q0; Wed, 26 Jun
	2024 11:41:46 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	5A.55.19174.97EFB766; Wed, 26 Jun 2024 20:41:46 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240626101511epcas5p31c95b67da58d408c371c49f8719140fc~chmGs7YSQ0746707467epcas5p3f;
	Wed, 26 Jun 2024 10:15:11 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240626101511epsmtrp13ad2443a21871fb5c01cdf4592ecaa63~chmGsLC0s1024010240epsmtrp1Y;
	Wed, 26 Jun 2024 10:15:11 +0000 (GMT)
X-AuditID: b6c32a50-87fff70000004ae6-9f-667bfe79f6f0
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	AD.4C.18846.F2AEB766; Wed, 26 Jun 2024 19:15:11 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240626101509epsmtip1c766cdc5fcd86fdcbf2919baa2f862c6~chmE1-8hw0147101471epsmtip1O;
	Wed, 26 Jun 2024 10:15:09 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: asml.silence@gmail.com, mpatocka@redhat.com, axboe@kernel.dk,
	hch@lst.de, kbusch@kernel.org, martin.petersen@oracle.com
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>, Anuj Gupta
	<anuj20.g@samsung.com>
Subject: [PATCH v2 01/10] block: change rq_integrity_vec to respect the
 iterator
Date: Wed, 26 Jun 2024 15:36:51 +0530
Message-Id: <20240626100700.3629-2-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240626100700.3629-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKJsWRmVeSWpSXmKPExsWy7bCmhm7Vv+o0g0fdzBZNE/4yW8xZtY3R
	YvXdfjaLlauPMlm8az3HYnH0/1s2i0mHrjFa7L2lbTF/2VN2i+XH/zFZTOy4yuTA7bFz1l12
	j8tnSz02repk89i8pN5j980GNo+PT2+xeLzfd5XNo2/LKkaPz5vkAjijsm0yUhNTUosUUvOS
	81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgG5VUihLzCkFCgUkFhcr6dvZ
	FOWXlqQqZOQXl9gqpRak5BSYFOgVJ+YWl+al6+WlllgZGhgYmQIVJmRnzPylVnBBruL86+lM
	DYzHJLsYOTkkBEwkltx7xw5iCwnsYZQ4f0+1i5ELyP7EKLGk7SAbnPOz7R8LTMf0180sEImd
	jBKHdk5jhHA+M0rcuP2CGaSKTUBd4sjzVkYQW0SgVmJl63R2kCJmgaWMEgd2rQdLCAsESRx7
	95UNxGYRUJV43HuAFcTmFbCQmD5hEyvEOnmJmZe+gx3IKWApcWfzdkaIGkGJkzOfgJ3EDFTT
	vHU2M8gCCYGpHBJ3up4CNXAAOS4SN45nQMwRlnh1fAs7hC0l8bK/DcpOl/hx+SkThF0g0Xxs
	HyOEbS/ReqqfGWQMs4CmxPpd+hBhWYmpp9YxQazlk+j9/QSqlVdixzwYW0mifeUcKFtCYu+5
	BijbQ2Lt06mskMDqYZRY2HeRbQKjwiwk78xC8s4shNULGJlXMUqlFhTnpqcmmxYY6uallsNj
	OTk/dxMjOP1qBexgXL3hr94hRiYOxkOMEhzMSiK8oSVVaUK8KYmVValF+fFFpTmpxYcYTYEB
	PpFZSjQ5H5gB8kriDU0sDUzMzMxMLI3NDJXEeV+3zk0REkhPLEnNTk0tSC2C6WPi4JRqYDIy
	/tsqOeHLJpVJVl+KNoTn2Lxev1CAl1PleFUb3yKruQ27LfM7/L68Y9b+zt7CutcvuGh1KOu5
	A/zS4VcfiNb3ed6x6koINmGLv1f7N2ABV+BO98TlW/hfn5VVWPKjLMybi2+BpMhEy8+71our
	nZzV4LDnj+L3XzeNGlUDX7yOs113Xc75kMD/jaqqKw45MeZUPZ0hwWPxUvC84ttfZvwVZwtK
	BVpO9kpcuXXkHnOmq/2GnErXTzEvTFbWyXUKLp65feeM3wt6JSZeDHOKE1RLarR3XXXg262N
	b7IOzA2eMbPs78JZ2l88Kleemzv1y3b1131t1l892Y+xOkf2nTu8ffMXlb8nElZp8Nx+ZK7E
	UpyRaKjFXFScCACGcECnSAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsWy7bCSnK7+q+o0g1nL9CyaJvxltpizahuj
	xeq7/WwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22L+sqfsFsuP/2OymNhxlcmB22PnrLvs
	HpfPlnpsWtXJ5rF5Sb3H7psNbB4fn95i8Xi/7yqbR9+WVYwenzfJBXBGcdmkpOZklqUW6dsl
	cGXM/KVWcEGu4vzr6UwNjMckuxg5OSQETCSmv25m6WLk4hAS2M4o0dG8hhUiISFx6uUyRghb
	WGLlv+fsILaQwEdGiXmzBEBsNgF1iSPPWxlBmkUEWhklDkxtAXOYBVYCOR3nwTqEBQIkVkyZ
	zQJiswioSjzuPQC2gVfAQmL6hE1Q2+QlZl76DlbPKWApcWfzdkaIbRYSD543Q9ULSpyc+QRs
	DjNQffPW2cwTGAVmIUnNQpJawMi0ilE0taA4Nz03ucBQrzgxt7g0L10vOT93EyM4MrSCdjAu
	W/9X7xAjEwfjIUYJDmYlEd7Qkqo0Id6UxMqq1KL8+KLSnNTiQ4zSHCxK4rzKOZ0pQgLpiSWp
	2ampBalFMFkmDk6pBqbWzGkG7h79Co4GTn5Kyq9Mi06f6uBbUsa+ZvV7qbdHHy678Z9350eF
	f5rd5o2PP+5MEZseuSXq9+zi++6lGZ6dBWtFFhmuORk+beKt6Un/9ba5nLHWzsqPPb/6mkta
	v2oC00Thkr0/TG9kFHSvS4m/cW2qQkupusv8Bw4V2983/3HjWL1IuOq/hvgBjUkBAQbuQbVq
	iu8+fPrgXqtxxeV7b9tb6aX1V0wavxjFfHlcn8JXJn8tcq3xv7DZpc4P8wT1nn1KmP6//JjD
	zXbeuK1Tn75OOKLpVxLKMFsryXLF19QFJ0JmGIs0uG2dPb3ywvy7V082f3MX/RN8lafVYcXW
	lQ/2hnO+bkpSDvcUr1ViKc5INNRiLipOBABObQ/H+wIAAA==
X-CMS-MailID: 20240626101511epcas5p31c95b67da58d408c371c49f8719140fc
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240626101511epcas5p31c95b67da58d408c371c49f8719140fc
References: <20240626100700.3629-1-anuj20.g@samsung.com>
	<CGME20240626101511epcas5p31c95b67da58d408c371c49f8719140fc@epcas5p3.samsung.com>

From: Mikulas Patocka <mpatocka@redhat.com>

If we allocate a bio that is larger than NVMe maximum request size,
attach integrity metadata to it and send it to the NVMe subsystem, the
integrity metadata will be corrupted.

Splitting the bio works correctly. The function bio_split will clone the
bio, trim the iterator of the first bio and advance the iterator of the
second bio.

However, the function rq_integrity_vec has a bug - it returns the first
vector of the bio's metadata and completely disregards the metadata
iterator that was advanced when the bio was split. Thus, the second bio
uses the same metadata as the first bio and this leads to metadata
corruption.

This commit changes rq_integrity_vec, so that it calls mp_bvec_iter_bvec
instead of returning the first vector. mp_bvec_iter_bvec reads the
iterator and uses it to build a bvec for the current position in the
iterator.

The "queue_max_integrity_segments(rq->q) > 1" check was removed, because
the updated rq_integrity_vec function works correctly with multiple
segments.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
---
 drivers/nvme/host/pci.c       |  6 +++---
 include/linux/blk-integrity.h | 16 ++++++++--------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 102a9fb0c65f..5d8035218de9 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -826,9 +826,9 @@ static blk_status_t nvme_map_metadata(struct nvme_dev *dev, struct request *req,
 		struct nvme_command *cmnd)
 {
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
+	struct bio_vec bv = rq_integrity_vec(req);
 
-	iod->meta_dma = dma_map_bvec(dev->dev, rq_integrity_vec(req),
-			rq_dma_dir(req), 0);
+	iod->meta_dma = dma_map_bvec(dev->dev, &bv, rq_dma_dir(req), 0);
 	if (dma_mapping_error(dev->dev, iod->meta_dma))
 		return BLK_STS_IOERR;
 	cmnd->rw.metadata = cpu_to_le64(iod->meta_dma);
@@ -967,7 +967,7 @@ static __always_inline void nvme_pci_unmap_rq(struct request *req)
 	        struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
 
 		dma_unmap_page(dev->dev, iod->meta_dma,
-			       rq_integrity_vec(req)->bv_len, rq_dma_dir(req));
+			       rq_integrity_vec(req).bv_len, rq_dma_dir(req));
 	}
 
 	if (blk_rq_nr_phys_segments(req))
diff --git a/include/linux/blk-integrity.h b/include/linux/blk-integrity.h
index d201140d77a3..c58634924782 100644
--- a/include/linux/blk-integrity.h
+++ b/include/linux/blk-integrity.h
@@ -90,14 +90,13 @@ static inline bool blk_integrity_rq(struct request *rq)
 }
 
 /*
- * Return the first bvec that contains integrity data.  Only drivers that are
- * limited to a single integrity segment should use this helper.
+ * Return the current bvec that contains the integrity data. bip_iter may be
+ * advanced to iterate over the integrity data.
  */
-static inline struct bio_vec *rq_integrity_vec(struct request *rq)
+static inline struct bio_vec rq_integrity_vec(struct request *rq)
 {
-	if (WARN_ON_ONCE(queue_max_integrity_segments(rq->q) > 1))
-		return NULL;
-	return rq->bio->bi_integrity->bip_vec;
+	return mp_bvec_iter_bvec(rq->bio->bi_integrity->bip_vec,
+				 rq->bio->bi_integrity->bip_iter);
 }
 #else /* CONFIG_BLK_DEV_INTEGRITY */
 static inline int blk_rq_count_integrity_sg(struct request_queue *q,
@@ -146,9 +145,10 @@ static inline int blk_integrity_rq(struct request *rq)
 	return 0;
 }
 
-static inline struct bio_vec *rq_integrity_vec(struct request *rq)
+static inline struct bio_vec rq_integrity_vec(struct request *rq)
 {
-	return NULL;
+	/* the optimizer will remove all calls to this function */
+	return (struct bio_vec){ };
 }
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
 
-- 
2.25.1


