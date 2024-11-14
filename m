Return-Path: <io-uring+bounces-4684-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 660989C88B2
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 12:19:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2056C282B6D
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 11:19:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DEAE1F8F0C;
	Thu, 14 Nov 2024 11:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="juDvAN+E"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B2A192D9D
	for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 11:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731583123; cv=none; b=TFpBU4D4lBm/LbIGY5U05cvaELg2xNnHPgxyAkoH+jLnlg1xIcx9pHee1z+RS9IoM4aNcrCp3rLWSlhUUopBJ65hBlI7AS/WXoA+nKc6BeP3hB/uy4pB0ADMNbC9ZLlgNdYsZCIPK54pVPKYDYWeBItz771FaRd0Sp0pBKmqvHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731583123; c=relaxed/simple;
	bh=BcTaUWXGiJ0MutknrUQXrJQN90XnKpmBvR8c/ClXdO0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=Jxbp/CY08gR7wrgrtt3PwaonyWCmGKCnAW9Pz5Rl9RU9qnztet00SKkh5q7XXq4/9+i+Wak0fPryL/WcssjK6Q0vK+o/wWBzQmlDOqnKE2AfyONorcFS0pY4lWC4cPqZSvd4wqvNFi2SBe2IeTkSZIFgI++c8UouOS/oMgjDP+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=juDvAN+E; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241114111839epoutp01708fc9257504be1d298bad05f0499c4c~H0axMZGPO2250322503epoutp01t
	for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 11:18:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241114111839epoutp01708fc9257504be1d298bad05f0499c4c~H0axMZGPO2250322503epoutp01t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1731583119;
	bh=XTd04aHy4nxYr+d1HX0L3NEK4IL9MMGxFYcE73udmyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=juDvAN+EQNBt4Bw7EB7uze/RZgwjZr8wrlPCTfkvcqsNvYVkG+GFQyFuUCFJcZdX/
	 49N18UkZzlJIcCwA/+6eBlOIc2R3OguPU0BfjijFfZwSYEh5yWAQWzQzErHdSpAkA4
	 uL9VWiBmX3I7t9+2/122CyF/C1eciWkEcwqTd+Co=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20241114111839epcas5p10637657526c1f3bf9f0c9c9d080c73d5~H0awl2q4z2217622176epcas5p1G;
	Thu, 14 Nov 2024 11:18:39 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4XpyMK28NGz4x9Pr; Thu, 14 Nov
	2024 11:18:37 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	12.B9.09770.D8CD5376; Thu, 14 Nov 2024 20:18:37 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241114105413epcas5p2d7da8675df2de0d1efba3057144e691d~H0FbrSgBA1555815558epcas5p2A;
	Thu, 14 Nov 2024 10:54:13 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241114105413epsmtrp19009de600359d144e1a2500fb3290860~H0Fbqa_3J1676616766epsmtrp1c;
	Thu, 14 Nov 2024 10:54:13 +0000 (GMT)
X-AuditID: b6c32a4a-e25fa7000000262a-59-6735dc8d17bd
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	99.6A.07371.5D6D5376; Thu, 14 Nov 2024 19:54:13 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241114105410epsmtip21979d9e042f8488f9e5c82fe85dbe60d~H0FZRGEOU1406514065epsmtip2a;
	Thu, 14 Nov 2024 10:54:10 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v9 09/11] nvme: add support for passing on the application
 tag
Date: Thu, 14 Nov 2024 16:15:15 +0530
Message-Id: <20241114104517.51726-10-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241114104517.51726-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPJsWRmVeSWpSXmKPExsWy7bCmpm7vHdN0g3MLeCw+fv3NYtE04S+z
	xZxV2xgtVt/tZ7N4ffgTo8XNAzuZLFauPspk8a71HIvF7OnNTBZH/79ls5h06Bqjxd5b2hZ7
	9p5ksZi/7Cm7Rff1HWwWy4//Y7I4//c4q8X5WXPYHYQ8ds66y+5x+Wypx6ZVnWwem5fUe+y+
	2cDm8fHpLRaPvi2rGD3OLDjC7vF5k5zHpidvmQK4orJtMlITU1KLFFLzkvNTMvPSbZW8g+Od
	403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4B+UlIoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fY
	KqUWpOQUmBToFSfmFpfmpevlpZZYGRoYGJkCFSZkZ5w+e4u9YAt3RevJY4wNjEc5uxg5OSQE
	TCRm9T9n7GLk4hAS2M0ocehTCyuE84lR4srvJSwQzjdGiY7eU2wwLdcfP4Wq2sso8eH4Haj+
	z4wSFw9eZAKpYhNQlzjyvBUsISKwh1Gid+FpsFnMAhOYJBZM38IMUiUsECDxomMdK4jNIqAq
	8eTmWiCbg4NXwEpiy84SiHXyEjMvfWcHsTmBwisatoK18goISpyc+YQFxGYGqmneOpsZZL6E
	wAMOiRsLVkPd6iKx/MAPZghbWOLV8S3sELaUxMv+Nig7XeLH5adMEHaBRPOxfYwQtr1E66l+
	ZpB7mAU0Jdbv0ocIy0pMPbWOCWIvn0Tv7ydQrbwSO+bB2EoS7SvnQNkSEnvPNUDZHhKrnjxi
	g4RWL6PExNZLLBMYFWYh+WcWkn9mIaxewMi8ilEytaA4Nz212LTAKC+1HB7Pyfm5mxjBKV3L
	awfjwwcf9A4xMnEwHmKU4GBWEuE95WycLsSbklhZlVqUH19UmpNafIjRFBjeE5mlRJPzgVkl
	ryTe0MTSwMTMzMzE0tjMUEmc93Xr3BQhgfTEktTs1NSC1CKYPiYOTqkGpqUaYr6MWa0HDarC
	8jKMb6/92To5Ys5FicVbeT6effRp8qUou1nnNkydIZVRFtRfWGtp/3KOUBzz6ZzWXP8XyQ8r
	Ay2tw9ynv0+4c8tq39MzVb7cq5Uvra84d0voP9u2D3ksUSxrdZVcvv3L9OT++uWaIM96+ygP
	9icJu+vtJi7lj3t26vl9n7tRty38iu2Y67kUfY1zQs/+n75OJtH2xt7z7SfW9j0PmvFrJ4/+
	+xQPy/vaJmJH1+hIhJlONNobWsU4cw3bFZFbhrvi1i5tWvV0TX2TE//fpu16etOmbpHo9nH8
	6m6krLbXSEjQX8f/wdZv74oq7VkUai+t2mTAqeR8TGPOWYdnFTFp7vOKlViKMxINtZiLihMB
	AIslunIEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsWy7bCSvO7Va6bpBhdmiFt8/PqbxaJpwl9m
	izmrtjFarL7bz2bx+vAnRoubB3YyWaxcfZTJ4l3rORaL2dObmSyO/n/LZjHp0DVGi723tC32
	7D3JYjF/2VN2i+7rO9gslh//x2Rx/u9xVovzs+awOwh57Jx1l93j8tlSj02rOtk8Ni+p99h9
	s4HN4+PTWywefVtWMXqcWXCE3ePzJjmPTU/eMgVwRXHZpKTmZJalFunbJXBlnD57i71gC3dF
	68ljjA2MRzm7GDk5JARMJK4/fsraxcjFISSwm1Fi7sQvLBAJCYlTL5cxQtjCEiv/PWeHKPrI
	KNH5ZhkTSIJNQF3iyPNWsCIRgROMEvMnuoEUMQvMYJL4/WcB2CRhAT+JOXsPs4LYLAKqEk9u
	rgWyOTh4BawktuwsgVggLzHz0nd2EJsTKLyiYSszSImQgKXE9/UiIGFeAUGJkzOfgE1kBipv
	3jqbeQKjwCwkqVlIUgsYmVYxSqYWFOem5yYbFhjmpZbrFSfmFpfmpesl5+duYgTHm5bGDsZ7
	8//pHWJk4mA8xCjBwawkwnvK2ThdiDclsbIqtSg/vqg0J7X4EKM0B4uSOK/hjNkpQgLpiSWp
	2ampBalFMFkmDk6pBqZDB+Z94Zx3pLX1Q+NJbacb+ktPqv2svpd7S3Ohp2WI/LYkMYPba+dY
	ehy89+Gheb1IR3FJ5vRU078Pr7iIOftFN1jyzf25o2rb+oYEru/680T/rWXVnT9Nes3E0Ajx
	4k0J0x5cXN3RuVXn7nLmx7P82v/8zGb6VVubF3ulRyoo6Nzxqe86ot9HrzggdixkorP/nSpv
	jvbddtt4GAvTAldJW/aUiE/1fWby7/Cign/72iQO7+mtkfyxUn7dvd/CMyY9PSz85RMne8X6
	FM3sb8ZWxXfc7gXn/rsXu2uKrtyn03dmXrXscyvpnqy5jVtV31XnjP/W3zHFz+5rL4vhyV9V
	mzJpxoz3jwNkOhNVDLcrsRRnJBpqMRcVJwIAgX1xNCYDAAA=
X-CMS-MailID: 20241114105413epcas5p2d7da8675df2de0d1efba3057144e691d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241114105413epcas5p2d7da8675df2de0d1efba3057144e691d
References: <20241114104517.51726-1-anuj20.g@samsung.com>
	<CGME20241114105413epcas5p2d7da8675df2de0d1efba3057144e691d@epcas5p2.samsung.com>

From: Kanchan Joshi <joshi.k@samsung.com>

With user integrity buffer, there is a way to specify the app_tag.
Set the corresponding protocol specific flags and send the app_tag down.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
---
 drivers/nvme/host/core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index bd309e98ffac..4a6ed8f38b77 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -885,6 +885,12 @@ static blk_status_t nvme_setup_discard(struct nvme_ns *ns, struct request *req,
 	return BLK_STS_OK;
 }
 
+static void nvme_set_app_tag(struct request *req, struct nvme_command *cmnd)
+{
+	cmnd->rw.lbat = cpu_to_le16(bio_integrity(req->bio)->app_tag);
+	cmnd->rw.lbatm = cpu_to_le16(0xffff);
+}
+
 static void nvme_set_ref_tag(struct nvme_ns *ns, struct nvme_command *cmnd,
 			      struct request *req)
 {
@@ -1025,6 +1031,10 @@ static inline blk_status_t nvme_setup_rw(struct nvme_ns *ns,
 				control |= NVME_RW_APPEND_PIREMAP;
 			nvme_set_ref_tag(ns, cmnd, req);
 		}
+		if (bio_integrity_flagged(req->bio, BIP_CHECK_APPTAG)) {
+			control |= NVME_RW_PRINFO_PRCHK_APP;
+			nvme_set_app_tag(req, cmnd);
+		}
 	}
 
 	cmnd->rw.control = cpu_to_le16(control);
-- 
2.25.1


