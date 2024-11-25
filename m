Return-Path: <io-uring+bounces-5034-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 73C769D7C81
	for <lists+io-uring@lfdr.de>; Mon, 25 Nov 2024 09:09:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 337962821FF
	for <lists+io-uring@lfdr.de>; Mon, 25 Nov 2024 08:09:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26C9B8827;
	Mon, 25 Nov 2024 08:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Gi51t0L7"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F3E155747
	for <io-uring@vger.kernel.org>; Mon, 25 Nov 2024 08:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732522138; cv=none; b=oBbnZfdDbPARRaZg50+KhVosmrpO+p4AoR2cYUAmob+KPnVte6VbewaCzpLH3lCPhjV/WHv9rinlBWmTUZkSXS6cGMjonwDW62kUatpj1BnoOto0dmKHHYJOVk9/54P4TstZfK0bi7MUYh1G5b/jO4oeq53g+UVCC49fry5sNNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732522138; c=relaxed/simple;
	bh=4bwNPqd2mgS/me72gS6c9qKx3N7iAIorybNdKO8yxVU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=G//kvcnwr66Qy8HAdsDcMIJK6uVuMgFKB12Eqpj6OvCexb8is6GFQ4yRYnA8+avJkC6edDZYYl4ezRW9CtPLD+Dop79BSBrcKEpPFYZj/MctGGuizwVfQbf9PUTiSn6LM6ML3w16hllUWO3y7N99w5VNHZLQx8N5ViGFWagW3K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Gi51t0L7; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241125080854epoutp01b07fb177d72f655af5195a219c373485~LJ7PGspIL1222612226epoutp01d
	for <io-uring@vger.kernel.org>; Mon, 25 Nov 2024 08:08:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241125080854epoutp01b07fb177d72f655af5195a219c373485~LJ7PGspIL1222612226epoutp01d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1732522134;
	bh=1yhnn/JEQDkJO7MPiDYhPt3P6x3KI+3HedoJWLZAeh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gi51t0L7ERwclevYi5LtaTTQDtEm28SxoSUzGiVe1vOoNSxF+JmKWMnKNREjsUNbN
	 NvIqJE8LimufJU92nWHsBzRKGd9kZU4FkmGieGART11J9zK9L/2ZFrisPallKt2z0P
	 qH8B03alLKFtITqP/6HZiojUi75u+tZxT5dLydmU=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20241125080854epcas5p28027fe1fdf39dbf760d7f276354c4abc~LJ7OoAKUy2571325713epcas5p2o;
	Mon, 25 Nov 2024 08:08:54 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4XxddJ1b3Kz4x9QF; Mon, 25 Nov
	2024 08:08:52 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	C0.96.29212.29034476; Mon, 25 Nov 2024 17:08:50 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20241125071505epcas5p34469830c74b82603c57cb4122d0850f7~LJMPZnSRq1112311123epcas5p37;
	Mon, 25 Nov 2024 07:15:05 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241125071505epsmtrp227628f991ca4fb5f4a3720189936742f~LJMPYs44Y0299802998epsmtrp2x;
	Mon, 25 Nov 2024 07:15:05 +0000 (GMT)
X-AuditID: b6c32a50-7ebff7000000721c-0b-67443092d7ea
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	FF.45.19220.9F324476; Mon, 25 Nov 2024 16:15:05 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241125071502epsmtip199c59c7e4832cf9b10800d051cb2fdc4~LJMM6vyav0365203652epsmtip1o;
	Mon, 25 Nov 2024 07:15:02 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>, Kanchan
	Joshi <joshi.k@samsung.com>
Subject: [PATCH v10 07/10] block: introduce BIP_CHECK_GUARD/REFTAG/APPTAG
 bip_flags
Date: Mon, 25 Nov 2024 12:36:30 +0530
Message-Id: <20241125070633.8042-8-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241125070633.8042-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPJsWRmVeSWpSXmKPExsWy7bCmlu4kA5d0g+lTFS0+fv3NYtE04S+z
	xZxV2xgtVt/tZ7N4ffgTo8XNAzuZLFauPspk8a71HIvF7OnNTBZH/79ls5h06Bqjxd5b2hZ7
	9p5ksZi/7Cm7Rff1HWwWy4//Y7I4//c4q8X5WXPYHYQ8ds66y+5x+Wypx6ZVnWwem5fUe+y+
	2cDm8fHpLRaPvi2rGD3OLDjC7vF5k5zHpidvmQK4orJtMlITU1KLFFLzkvNTMvPSbZW8g+Od
	403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4B+UlIoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fY
	KqUWpOQUmBToFSfmFpfmpevlpZZYGRoYGJkCFSZkZ/QfvclY8Eyy4vvkvSwNjMtFuxg5OSQE
	TCRONfxn7GLk4hAS2MMo8fnSUmaQhJDAJ0aJDbflIRLfGCXmHF/ABtOx9f5MqI69jBJTVm5k
	gnA+M0os2jGLHaSKTUBd4sjzVrAqEZC5vQtPs4A4zAITmCTaJ84BqxIWCJVYdesrkM3BwSKg
	KrFwnzdImFfAQuL61n3sEOvkJWZe+g5mcwpYSrxtO8ACUSMocXLmEzCbGaimeetsZpD5EgI3
	OCQOH1rDAtHsIvHqzCyou4UlXh3fAjVUSuLzu71Q8XSJH5efMkHYBRLNx/YxQtj2Eq2n+plB
	bmMW0JRYv0sfIiwrMfXUOiaIvXwSvb+fQLXySuyYB2MrSbSvnANlS0jsPdcAZXtIzLjfCA26
	HkaJvdPfME1gVJiF5J9ZSP6ZhbB6ASPzKkap1ILi3PTUZNMCQ9281HJ4PCfn525iBKd0rYAd
	jKs3/NU7xMjEwXiIUYKDWUmEl0/cOV2INyWxsiq1KD++qDQntfgQoykwwCcyS4km5wOzSl5J
	vKGJpYGJmZmZiaWxmaGSOO/r1rkpQgLpiSWp2ampBalFMH1MHJxSDUzxHW42YXWrWLhLOm7X
	pt3veb97tbJb2aQVmxcHv9u8rLSZyX9ZMMMr3uKKukD+3wfU5S0Oc1002FcZ8rBb0+Px99kc
	yl+zLkicNt7ifOHEtE0vUs/nZCvc4DldGHuw/mbw3b8qCXuWP7nM9vVDphLHHd8JqlY/y/c0
	C6zl5XAsDr/Cwq2gtOpRa+ny46EOW5636O+QuDh/Rv/3k6seSz43nSHW0lanw7dP5Nrt+w6N
	/4Pj3Krtz2pmcjVk2J/VrvnsvV1+73pvX0adaXNX9vkK6fTn7zPO2C4W/JI1boF7+6R9q/Z9
	ZRKXDb002zBxLvtPGZ5Jm43tWHtN7gkb85b8c4jKELh963JtwWndHiWW4oxEQy3mouJEAE5M
	B4hyBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsWy7bCSnO5PZZd0g1ebWC0+fv3NYtE04S+z
	xZxV2xgtVt/tZ7N4ffgTo8XNAzuZLFauPspk8a71HIvF7OnNTBZH/79ls5h06Bqjxd5b2hZ7
	9p5ksZi/7Cm7Rff1HWwWy4//Y7I4//c4q8X5WXPYHYQ8ds66y+5x+Wypx6ZVnWwem5fUe+y+
	2cDm8fHpLRaPvi2rGD3OLDjC7vF5k5zHpidvmQK4orhsUlJzMstSi/TtErgy+o/eZCx4Jlnx
	ffJelgbG5aJdjJwcEgImElvvz2QEsYUEdjNKrHmvABGXkDj1chkjhC0ssfLfc3aImo+MEtfv
	5IPYbALqEkeet4LViAicYJSYP9Gti5GLg1lgBpNEz68VbCAJYYFgiYeT/7J2MXJwsAioSizc
	5w0S5hWwkLi+dR87xHx5iZmXvoPZnAKWEm/bDrBA7LKQmNW5khWiXlDi5MwnYHFmoPrmrbOZ
	JzAKzEKSmoUktYCRaRWjZGpBcW56brFhgVFearlecWJucWleul5yfu4mRnC0aWntYNyz6oPe
	IUYmDsZDjBIczEoivHzizulCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeb+97k0REkhPLEnNTk0t
	SC2CyTJxcEo1MEkv0lxdVastm8chtmdVE6fU9+vGuVsi1s185C2vfdg0fpe5yl7uSQ7Mi88F
	XJvLk9F3csLnr1vnid4/mGa4WlPk5baYL8F7/+uuFnRN9fMo8+0W3Fbjb+pgI1UXk/urs41B
	X/SQ+5cDNya1Nn46Hjv//gMdhZmKckujOhx2Ofvw+PXM+u4ZpeslvWjyw12H3jhM/hh8hu3c
	IUFpiWLxwuAmk/m/HzS5xrT2T7/8562Wje7Kt1K+DSfPPOQ5eHKWpcujvDsLvpv37pknkzH7
	7d6URWmxbH7Xrot2+LySDop3lrttH5Tl/eQq48UM45XnrebOn/q5+qRx9Ef/q5+n/Lxb9uKG
	NMujcDV7ea/FUkosxRmJhlrMRcWJANX3MgolAwAA
X-CMS-MailID: 20241125071505epcas5p34469830c74b82603c57cb4122d0850f7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241125071505epcas5p34469830c74b82603c57cb4122d0850f7
References: <20241125070633.8042-1-anuj20.g@samsung.com>
	<CGME20241125071505epcas5p34469830c74b82603c57cb4122d0850f7@epcas5p3.samsung.com>

This patch introduces BIP_CHECK_GUARD/REFTAG/APPTAG bip_flags which
indicate how the hardware should check the integrity payload.
BIP_CHECK_GUARD/REFTAG are conversion of existing semantics, while
BIP_CHECK_APPTAG is a new flag. The driver can now just rely on block
layer flags, and doesn't need to know the integrity source. Submitter
of PI decides which tags to check. This would also give us a unified
interface for user and kernel generated integrity.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
---
 block/bio-integrity.c         |  5 +++++
 drivers/nvme/host/core.c      | 11 +++--------
 include/linux/bio-integrity.h |  6 +++++-
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index f56d01cec689..3bee43b87001 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -434,6 +434,11 @@ bool bio_integrity_prep(struct bio *bio)
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
index 40e7be3b0339..e4e3653c27fb 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1017,18 +1017,13 @@ static inline blk_status_t nvme_setup_rw(struct nvme_ns *ns,
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
index 58ff9988433a..fe2bfe122db2 100644
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
@@ -31,7 +34,8 @@ struct bio_integrity_payload {
 };
 
 #define BIP_CLONE_FLAGS (BIP_MAPPED_INTEGRITY | BIP_CTRL_NOCHECK | \
-			 BIP_DISK_NOCHECK | BIP_IP_CHECKSUM)
+			 BIP_DISK_NOCHECK | BIP_IP_CHECKSUM | \
+			 BIP_CHECK_GUARD | BIP_CHECK_REFTAG | BIP_CHECK_APPTAG)
 
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 
-- 
2.25.1


