Return-Path: <io-uring+bounces-4235-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ECEC59B6BD0
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 19:11:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3D831B21614
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 18:11:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B702A1CBEAD;
	Wed, 30 Oct 2024 18:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="QQOQqZpA"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881141CBE99
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 18:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730311825; cv=none; b=f2bMSPJ0bSCAGlJYXo02xf6EA9axDyzebFe8P/pgFgROIH03+JRGn3sokC8tKoCk69AFXklG2V4CSetL7/HU80ydFE1dOLlcQyubWM3zr9n8V8y7Z7yVyjDm6rvw40l+sU7RPOpSl+q63txCCYlYT0fvPllWcKMCCcQeHyRiinI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730311825; c=relaxed/simple;
	bh=8jIRO6c2zH9FenFN6dJIwf6/40j3vDnIZ8qwXmiThLo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=hecvsvL4yeMGkavn6iRZkQhRHU2bS+joI23TG4xEHWUnntbLlBBvTygHOFXABCRM6xdg/Ai2r9Nco6O89XXgPB4CFFxgJ1T0h445bxtmWJtVHKE5EKCLIn8CWhcxcndACIRdMknU2L2sNRF+ycuy3fiFcpgBQFa5UmFcsW8A3u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=QQOQqZpA; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20241030181021epoutp0221d378ff69b61e382c1b3a72e198d483~DTW82cL_n2034420344epoutp02V
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 18:10:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20241030181021epoutp0221d378ff69b61e382c1b3a72e198d483~DTW82cL_n2034420344epoutp02V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730311821;
	bh=3zdls5Iu7dt/fb3DAkxYZFdYirBlPjLOr6/nLEkVVNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QQOQqZpAsw8XkZFO3ZKtXFpgnje5np99WrU+/QDPyDq/vJjAO7adP4vMeFOSaf85F
	 BLs5WoUV9ETKSeYxvhxsw4T1ZTpa9PdWwTBzTsDavCcadC6w8QZQvTVEIrGovrImc2
	 QJrAtzQ5l2yrkZWms9Q6MrtfDy4nbHUMyPT4liLI=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20241030181021epcas5p4cea036251f5b3d3acdf1eeabcff49d67~DTW8U-awJ1337513375epcas5p4S;
	Wed, 30 Oct 2024 18:10:21 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4XdwCJ1StGz4x9Pq; Wed, 30 Oct
	2024 18:10:20 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	4A.10.09420.C8672276; Thu, 31 Oct 2024 03:10:20 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20241030181019epcas5p135961d721959d80f1f60bd4790ed52cf~DTW6QmZX-0989809898epcas5p1c;
	Wed, 30 Oct 2024 18:10:19 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241030181019epsmtrp2c438cc97667ed37f2776ae04c2d1308c~DTW6Pw6Y41079210792epsmtrp2K;
	Wed, 30 Oct 2024 18:10:19 +0000 (GMT)
X-AuditID: b6c32a49-0d5ff700000024cc-f9-6722768c816e
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	4D.78.08229.A8672276; Thu, 31 Oct 2024 03:10:18 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241030181016epsmtip2c10f0e1bb68f28d52711b13fe48bccae~DTW32YEvM0487504875epsmtip2_;
	Wed, 30 Oct 2024 18:10:16 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, brauner@kernel.org,
	viro@zeniv.linux.org.uk, jack@suse.cz
Cc: linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org, gost.dev@samsung.com, vishak.g@samsung.com,
	anuj1072538@gmail.com, Kanchan Joshi <joshi.k@samsung.com>, Anuj Gupta
	<anuj20.g@samsung.com>
Subject: [PATCH v6 08/10] nvme: add support for passing on the application
 tag
Date: Wed, 30 Oct 2024 23:31:10 +0530
Message-Id: <20241030180112.4635-9-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241030180112.4635-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIJsWRmVeSWpSXmKPExsWy7bCmum5PmVK6QV8Hu8XHr79ZLJom/GW2
	mLNqG6PF6rv9bBavD39itLh5YCeTxcrVR5ks3rWeY7GYPb2ZyeLo/7dsFpMOXWO02HtL22LP
	3pMsFvOXPWW36L6+g81i+fF/TBbn/x5ntTg/aw67g5DHzll32T0uny312LSqk81j85J6j903
	G9g8Pj69xeLRt2UVo8eZBUfYPT5vkvPY9OQtUwBXVLZNRmpiSmqRQmpecn5KZl66rZJ3cLxz
	vKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBPSgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJb
	pdSClJwCkwK94sTc4tK8dL281BIrQwMDI1OgwoTsjL/T9jMWtHNXXL9zhbWBcT5nFyMnh4SA
	icT7uR9Zuhi5OIQEdjNKPL1/ixnC+cQosfTXMjYI5xujxKX9j1hgWi48a4Cq2ssosWbNV1YI
	5zOjxOpLPexdjBwcbAKaEhcml4I0iAgsZZRYeT0apIZZYDmTxIH7u8EmCQsESPQ962QCsVkE
	VCXWzjrNBmLzCphLNO19yASxTV5i5qXv7CA2p4CFxIcdN1kgagQlTs58AmYzA9U0b50NdpGE
	wB0Oia9TV7FDNLtIrPvZCzVIWOLV8S1QcSmJz+/2skHY2RIPHj2Aeq1GYsfmPlYI216i4c8N
	VpBnmIGeWb9LH2IXn0Tv7ydMIGEJAV6JjjYhiGpFiXuTnkJ1iks8nLEEyvaQ+PnqKxMkfLoZ
	JbbNm8Q0gVF+FpIXZiF5YRbCtgWMzKsYJVMLinPTU4tNCwzzUsvhMZucn7uJEZy2tTx3MN59
	8EHvECMTB+MhRgkOZiURXssgxXQh3pTEyqrUovz4otKc1OJDjKbAMJ7ILCWanA/MHHkl8YYm
	lgYmZmZmJpbGZoZK4ryvW+emCAmkJ5akZqemFqQWwfQxcXBKNTClL45O3ODYzBd/x3NeXB0b
	v26DyCPn8pMcSUeeOFRmWgf2/LvWHrq6m1HlWEDNmuLwI1zlmndVXcSO8LILZZ+flWh4Y/O+
	pPre/ds/pO9KVW9NvSwVc+/OIob85lS/d3WyJZf/fLwlW7zg9dN5s5c+vdO0eo266fPNUp9/
	iXmuOWxyR0nvbey+3qZ1dR2c85VF8loivbrubPKa8EwrKMtPneebQu/Vr55qR+IKOO2v/12d
	9DfcPTflmMQUn79hgS8yV9mVzBKcw/z4/JRox+ZnTz4/KZ+mvsOIT0r/8mm263vn7er2cDz8
	a7us3Y77mdEO0QFll8J2vjAWVYt4NnERg4jh38BbH/bnCbYvfqXEUpyRaKjFXFScCADt010P
	ZAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsWy7bCSvG53mVK6weMci49ff7NYNE34y2wx
	Z9U2RovVd/vZLF4f/sRocfPATiaLlauPMlm8az3HYjF7ejOTxdH/b9ksJh26xmix95a2xZ69
	J1ks5i97ym7RfX0Hm8Xy4/+YLM7/Pc5qcX7WHHYHIY+ds+6ye1w+W+qxaVUnm8fmJfUeu282
	sHl8fHqLxaNvyypGjzMLjrB7fN4k57HpyVumAK4oLpuU1JzMstQifbsEroy/0/YzFrRzV1y/
	c4W1gXE+ZxcjJ4eEgInEhWcNzF2MXBxCArsZJf5332SDSIhLNF/7wQ5hC0us/PecHaLoI6PE
	liWTWboYOTjYBDQlLkwuBYmLCKxnlDi7dwILiMMssJFJ4uyeH2CThAX8JD51LQGbxCKgKrF2
	1mmwOK+AuUTT3odMEBvkJWZe+g5WwylgIfFhx00WEFsIqOb6wjPsEPWCEidnPgGLMwPVN2+d
	zTyBUWAWktQsJKkFjEyrGCVTC4pz03OLDQsM81LL9YoTc4tL89L1kvNzNzGCI05Lcwfj9lUf
	9A4xMnEwHmKU4GBWEuG1DFJMF+JNSaysSi3Kjy8qzUktPsQozcGiJM4r/qI3RUggPbEkNTs1
	tSC1CCbLxMEp1cCkP+X3m64PNa8fhuYqTmxXPpE6+xrDiV2LLkVq30hcpft274l4/6VbdH5t
	v1ziPufA0RAprjWXj634taX43o+zMlF1q79e+Vh75f+TYxXvH51YsCHjZgjX8alifVqW1foL
	si8vmSVq+1IgSHyV+4mgbbypipEm0kfbV97hCn717Fmd0xGL2xz1Gy1X8ql67gxTcPztIuF9
	dWLKP61tDzZ2idy9Z6zq0s8lFbA0KlpCgpMldO6BqZZCVbKM7DcvMh5u/3HTdEH+4o7lsjzZ
	ab0+Mqc/2/JfeDMx+/DNVNfJ33qN1xnY103IjXjW/MmT7VeYm+RBzot+LO8ui1iEuEuZzM2s
	EFrE+u3z1I2cpVwblViKMxINtZiLihMBAM4v/ycDAAA=
X-CMS-MailID: 20241030181019epcas5p135961d721959d80f1f60bd4790ed52cf
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241030181019epcas5p135961d721959d80f1f60bd4790ed52cf
References: <20241030180112.4635-1-joshi.k@samsung.com>
	<CGME20241030181019epcas5p135961d721959d80f1f60bd4790ed52cf@epcas5p1.samsung.com>

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
index 79bd6b22e88d..3b329e036d33 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -872,6 +872,12 @@ static blk_status_t nvme_setup_discard(struct nvme_ns *ns, struct request *req,
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
@@ -1012,6 +1018,10 @@ static inline blk_status_t nvme_setup_rw(struct nvme_ns *ns,
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


