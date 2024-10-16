Return-Path: <io-uring+bounces-3731-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75BBD9A0A03
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 14:37:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E5A3286334
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 12:37:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F8BA208972;
	Wed, 16 Oct 2024 12:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="u72UPhap"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14887208970
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 12:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729082235; cv=none; b=heLijqHBmndQsLgZumUr8QletJo4FabwOxcIIRCQulQHaTP9FoCFSt5TxTye7WkQqjcrBMjcb/5jnm51H53hpSV4SCR87JmYrd/++vT7uY3lQv7sBIj7/kYkO6eHJdb0U7lUVWHMirz6V6cVO2sNzEhO+cbdSvVSHWN+J9wu83U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729082235; c=relaxed/simple;
	bh=FmY5BXEWM+NaI9Vzxv8DOlPlOtT5OJ1qgnE39com+lY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=PukMaD/MSS1NWXV2kuCtKyuHPk2rpM5vPl34O/BHkkpAO6mB5sghvYa+P8+rQFoR6fMbz+QYpgiz6BvAwETYMJCovbJVs89Kffh8ZOEAtME8h5QrMmRrbr+Q0boMguSilv1j9l+dYfO+u2OUu9AXmKPQe67AKuR0NK9YOzFeUug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=u72UPhap; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241016123711epoutp017a7398a16ac7fb0555154aaea31a138e~_7yDgfgIJ1583515835epoutp013
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 12:37:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241016123711epoutp017a7398a16ac7fb0555154aaea31a138e~_7yDgfgIJ1583515835epoutp013
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1729082231;
	bh=wzmB/TWoyocJzmZU34Ksi+Owp+0Flh6pJN0TsToBSPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u72UPhapnGgMZin9WRB+O9eyo0lUo5IUvyumME4bHyjazDHx/1zLI/hEgdkR4YzcJ
	 Dk0kndTTrE5IHJf2pv5+i7luWSaU21YutNGC/C0QHaeOP3pBlpnJzYUWHtmdWk2pA6
	 ngJe6+ZPKvHdcmaRP9zIt1HpK1GPhStFxyKQfaXI=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20241016123710epcas5p4c8c3f8e11d0940ef04e5bae573107331~_7yCasbmB1722117221epcas5p4i;
	Wed, 16 Oct 2024 12:37:10 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4XT9TJ490Mz4x9Pv; Wed, 16 Oct
	2024 12:37:08 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	91.47.08574.473BF076; Wed, 16 Oct 2024 21:37:08 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241016113750epcas5p2089e395ca764de023be64519da9b0982~_6_PBvkgZ3038630386epcas5p2I;
	Wed, 16 Oct 2024 11:37:50 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241016113750epsmtrp22c814f9026baaea6d5e51cb50909d6ca~_6_O-nlbU1554615546epsmtrp2x;
	Wed, 16 Oct 2024 11:37:50 +0000 (GMT)
X-AuditID: b6c32a44-6dbff7000000217e-56-670fb3747bd0
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	31.CA.08229.E85AF076; Wed, 16 Oct 2024 20:37:50 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241016113748epsmtip183e9a7ec82ba541b29d1130741cc0b4d~_6_M1iVTA2875928759epsmtip1J;
	Wed, 16 Oct 2024 11:37:47 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	krisman@suse.de
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com, Anuj Gupta
	<anuj20.g@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v4 08/11] block: introduce BIP_CHECK_GUARD/REFTAG/APPTAG
 bip_flags
Date: Wed, 16 Oct 2024 16:59:09 +0530
Message-Id: <20241016112912.63542-9-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241016112912.63542-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFJsWRmVeSWpSXmKPExsWy7bCmhm7JZv50g63/ZCw+fv3NYtE04S+z
	xZxV2xgtVt/tZ7O4eWAnk8XK1UeZLN61nmOxOPr/LZvFpEPXGC22n1nKbLH3lrbF/GVP2S26
	r+9gs1h+/B+TxflZc9gd+D12zrrL7nH5bKnHplWdbB6bl9R77L7ZwObx8ektFo++LasYPTaf
	rvb4vEkugDMq2yYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DX
	LTMH6HwlhbLEnFKgUEBicbGSvp1NUX5pSapCRn5xia1SakFKToFJgV5xYm5xaV66Xl5qiZWh
	gYGRKVBhQnZG+69u5oJZEhWdR8+zNDB+Eu5i5OSQEDCRuLKjhbmLkYtDSGA3o8T5032sEM4n
	RokVz28wQjjfGCXmrWtkhWn5tesAE0RiL6NEw6yFUP2fGSUWr7kKVsUmoC5x5HkrI4gtIjCJ
	UeL55VCQImaB94wS7/cvBysSFgiRmP/9NRuIzSKgKrHiZhs7iM0rYCnR/PYs1Dp5iZmXvoPF
	OQWsJE6dOwhVIyhxcuYTFhCbGaimeetssCskBPZwSKzc0MIO0ewi8bhzMiOELSzx6vgWqLiU
	xOd3e9kg7HSJH5efMkHYBRLNx/ZB1dtLtJ7qBxrKAbRAU2L9Ln2IsKzE1FPrmCD28kn0/n4C
	1corsWMejK0k0b5yDpQtIbH3XAOU7SHxe9oMNkho9TJKvJ3azjqBUWEWkn9mIflnFsLqBYzM
	qxglUwuKc9NTk00LDPNSy+HxnJyfu4kRnKi1XHYw3pj/T+8QIxMH4yFGCQ5mJRHeSV286UK8
	KYmVValF+fFFpTmpxYcYTYEBPpFZSjQ5H5gr8kriDU0sDUzMzMxMLI3NDJXEeV+3zk0REkhP
	LEnNTk0tSC2C6WPi4JRqYArwaLH5Wjgt/k87x5dzTZOET3dOu32kInf6zv9HZd8/3dTdefrj
	4uUPkk/vzVDenf0q+IZF1J3AIt45/i8n/drRKndt0ZH7Djlyz//t298gPWWRwOs7F0T1lCPf
	yn6ckjg9w4UrzHySx8PQhunvbzc93Wj/7nVnyiyfzpdFv897OAjckY2bzLTs5IF5z1Z8WqrH
	uD372+XD/vOSNju/XZxQtEZBtvK3lKbQwjncweeYCu7qSVbK22oIKmx7fNdk1f8nYZwd7it4
	ir4bp1+WOd/+dVfnnouFUq9c7+ya/bdga9mXZw7Mp3Pjdc1eWIb/5d9+sb/b5OJhhx9vz37t
	/jDT5tvEFVeu7j5xTyn1nf+5GUosxRmJhlrMRcWJAFR7iohdBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkkeLIzCtJLcpLzFFi42LZdlhJTrdvKX+6wc57/BYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1ncPLCTyWLl6qNMFu9az7FYHP3/ls1i0qFrjBbbzyxltth7S9ti/rKn7Bbd
	13ewWSw//o/J4vysOewO/B47Z91l97h8ttRj06pONo/NS+o9dt9sYPP4+PQWi0ffllWMHptP
	V3t83iQXwBnFZZOSmpNZllqkb5fAldH+q5u5YJZERefR8ywNjJ+Euxg5OSQETCR+7TrA1MXI
	xSEksJtRYuLGG+wQCQmJUy+XMULYwhIr/z1nhyj6yChx6s5nNpAEm4C6xJHnrYwgCRGBWYwS
	h2fNBxvFLPCdUWLa8mssIFXCAkEST26/YwWxWQRUJVbcbANbwStgKdH89iwrxAp5iZmXvoPF
	OQWsJE6dOwhmCwHV/Jv8gRGiXlDi5MwnYDOZgeqbt85mnsAItBYhNQtJagEj0ypGydSC4tz0
	3GLDAsO81HK94sTc4tK8dL3k/NxNjOBY0tLcwbh91Qe9Q4xMHIyHGCU4mJVEeCd18aYL8aYk
	VlalFuXHF5XmpBYfYpTmYFES5xV/0ZsiJJCeWJKanZpakFoEk2Xi4JRqYAr4NtNUjM+TwyrI
	fNm0jfLstz3O6nT77S3NT/7VJbC/8NHeu0d6pLQfFLNcS3vQeVqu8jB7uckcyTfLigw4r66N
	OBcddf/DhPStxioy3WejbfuNJdKVfbfs+dr7akZW8t41Tdv4v7/Y8vC1bvmimvIT9ov/lc+2
	3lww5yYzt4ilyYlL80+H79nU6OPKYMSy4HqmW5jRseuz9y+d6P01darv17SNic51V2eHcnYs
	96jgfHtJ9G7APK2PCp1zZR+wacobrNzV63QpkPeSPbfL69uH6nvq2M4Km3MbTz913GKZ9vb2
	JXf4+iLDrn+apHbEmenmjJYkprmsWpJXFCP+ujobTTHLqvm+i3HPcmWvD0osxRmJhlrMRcWJ
	AFXA9EwUAwAA
X-CMS-MailID: 20241016113750epcas5p2089e395ca764de023be64519da9b0982
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241016113750epcas5p2089e395ca764de023be64519da9b0982
References: <20241016112912.63542-1-anuj20.g@samsung.com>
	<CGME20241016113750epcas5p2089e395ca764de023be64519da9b0982@epcas5p2.samsung.com>

This patch introduces BIP_CHECK_GUARD/REFTAG/APPTAG bip_flags which
indicate how the hardware should check the integrity payload. The
driver can now just rely on block layer flags, and doesn't need to
know the integrity source. Submitter of PI decides which tags to check.
This would also give us a unified interface for user and kernel
generated integrity.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 block/bio-integrity.c         |  5 +++++
 drivers/nvme/host/core.c      | 11 +++--------
 include/linux/bio-integrity.h |  6 +++++-
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 341a0382befd..d3c8b56d3fe6 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -436,6 +436,11 @@ bool bio_integrity_prep(struct bio *bio)
 	if (bi->csum_type == BLK_INTEGRITY_CSUM_IP)
 		bip->bip_flags |= BIP_IP_CHECKSUM;
 
+	/* describe what tags to check in payload */
+	if (bi->csum_type)
+		bip->bip_flags |= BIP_CHECK_GUARD;
+	if (bi->flags & BLK_INTEGRITY_REF_TAG)
+		bip->bip_flags |= BIP_CHECK_REFTAG;
 	if (bio_integrity_add_page(bio, virt_to_page(buf), len,
 			offset_in_page(buf)) < len) {
 		printk(KERN_ERR "could not attach integrity payload\n");
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 43d73d31c66f..211f44cc02a3 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1004,18 +1004,13 @@ static inline blk_status_t nvme_setup_rw(struct nvme_ns *ns,
 			control |= NVME_RW_PRINFO_PRACT;
 		}
 
-		switch (ns->head->pi_type) {
-		case NVME_NS_DPS_PI_TYPE3:
+		if (bio_integrity_flagged(req->bio, BIP_CHECK_GUARD))
 			control |= NVME_RW_PRINFO_PRCHK_GUARD;
-			break;
-		case NVME_NS_DPS_PI_TYPE1:
-		case NVME_NS_DPS_PI_TYPE2:
-			control |= NVME_RW_PRINFO_PRCHK_GUARD |
-					NVME_RW_PRINFO_PRCHK_REF;
+		if (bio_integrity_flagged(req->bio, BIP_CHECK_REFTAG)) {
+			control |= NVME_RW_PRINFO_PRCHK_REF;
 			if (op == nvme_cmd_zone_append)
 				control |= NVME_RW_APPEND_PIREMAP;
 			nvme_set_ref_tag(ns, cmnd, req);
-			break;
 		}
 	}
 
diff --git a/include/linux/bio-integrity.h b/include/linux/bio-integrity.h
index 529ec7a8df20..a9dd0594dfc8 100644
--- a/include/linux/bio-integrity.h
+++ b/include/linux/bio-integrity.h
@@ -11,6 +11,9 @@ enum bip_flags {
 	BIP_DISK_NOCHECK	= 1 << 3, /* disable disk integrity checking */
 	BIP_IP_CHECKSUM		= 1 << 4, /* IP checksum */
 	BIP_COPY_USER		= 1 << 5, /* Kernel bounce buffer in use */
+	BIP_CHECK_GUARD		= 1 << 6, /* guard check */
+	BIP_CHECK_REFTAG	= 1 << 7, /* reftag check */
+	BIP_CHECK_APPTAG	= 1 << 8, /* apptag check */
 };
 
 struct bio_integrity_payload {
@@ -41,7 +44,8 @@ struct uio_meta {
 };
 
 #define BIP_CLONE_FLAGS (BIP_MAPPED_INTEGRITY | BIP_CTRL_NOCHECK | \
-			 BIP_DISK_NOCHECK | BIP_IP_CHECKSUM)
+			 BIP_DISK_NOCHECK | BIP_IP_CHECKSUM | \
+			 BIP_CHECK_GUARD | BIP_CHECK_REFTAG | BIP_CHECK_APPTAG)
 
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 
-- 
2.25.1


