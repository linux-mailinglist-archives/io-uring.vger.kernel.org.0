Return-Path: <io-uring+bounces-4420-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B722F9BB98C
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 16:57:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DADAE1C214AC
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 15:57:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF4DD1C2325;
	Mon,  4 Nov 2024 15:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="eyaKIkyq"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040791C230E
	for <io-uring@vger.kernel.org>; Mon,  4 Nov 2024 15:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730735787; cv=none; b=Fz8kszDbyMrCWEMYAGI95bGCzyxla849PlGt3P//+h7/VTA7UxqTLyI1TqoJ7F5csZbhCOndMBwSktW4Hfp7Pxa/nIRbyfMGNGmYnrzNX/P+olMfukpBeW8nmF19oSFBj9SJi2ooo2Y6+jPUPoNmazlaMPGZCUgnNHRVhdoh1ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730735787; c=relaxed/simple;
	bh=Ti2AMmSbrMFScqU9q3xm9tPPI9IzzdHtGuAbg5J+KzE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=VRGvuNSdQNM2alV2C9jOcEYoww7rhtEPinK0v6lA1IUBl115IUNY/r+GCoaL7zwglQ9aU7EB/N1wrZgvVcoGFXGLB7jWdNKyxB8Ew3Jldm1BbHRSAMejO0+KXg+u+NG9kVm9Llt+gOxCPn2zX3TpZZ+ZlMqaKt3i80uXV4StE00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=eyaKIkyq; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20241104155623epoutp0211530c400cdf5f00ff3383f3c57eb4e2~EzwZuWIVG1479614796epoutp02W
	for <io-uring@vger.kernel.org>; Mon,  4 Nov 2024 15:56:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20241104155623epoutp0211530c400cdf5f00ff3383f3c57eb4e2~EzwZuWIVG1479614796epoutp02W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730735783;
	bh=TdzGTMHoJr7DsmAYK7dZF3Jk+VkM+gVW6lv3bLW8Di0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eyaKIkyqn9+MnsrBSN0W0u8PaG0t+Gu2GHegB+s4I7RQ0u6hq4Rw0lzJX5BwgRHJC
	 wtvi8fFvwmOZMY4PPE8sqzixZMUXNzqlUI5J/MRfR74xvOiC6qxA2US40rUseyGgFL
	 1p2o6sB96XWNnje8rpeYm76VUiZWq0W/mgS68/Ys=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20241104155622epcas5p37fc4250e11a34029e910dfcdce649715~EzwY9sY380268302683epcas5p3C;
	Mon,  4 Nov 2024 15:56:22 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.178]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4Xhx0N59wzz4x9Pp; Mon,  4 Nov
	2024 15:56:20 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	E8.A7.09420.4AEE8276; Tue,  5 Nov 2024 00:56:20 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20241104141504epcas5p47e46a75f9248a37c9a4180de8e72b54c~EyX8jQoAX3055130551epcas5p4j;
	Mon,  4 Nov 2024 14:15:04 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241104141504epsmtrp185b3edd7ba835d76c7ea980221a18c8e~EyX8cS1Vl1329813298epsmtrp14;
	Mon,  4 Nov 2024 14:15:04 +0000 (GMT)
X-AuditID: b6c32a49-0d5ff700000024cc-16-6728eea4e0f6
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	5A.8D.07371.8E6D8276; Mon,  4 Nov 2024 23:15:04 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241104141501epsmtip273173b25c2459b8858b68de6692b678e~EyX6AFrz83074930749epsmtip2w;
	Mon,  4 Nov 2024 14:15:01 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v7 08/10] nvme: add support for passing on the application
 tag
Date: Mon,  4 Nov 2024 19:35:59 +0530
Message-Id: <20241104140601.12239-9-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241104140601.12239-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHJsWRmVeSWpSXmKPExsWy7bCmuu6SdxrpBpvvKll8/PqbxaJpwl9m
	izmrtjFarL7bz2bx+vAnRoubB3YyWaxcfZTJ4l3rORaL2dObmSyO/n/LZjHp0DVGi723tC32
	7D3JYjF/2VN2i+7rO9gslh//x2Rx/u9xVovzs+awOwh57Jx1l93j8tlSj02rOtk8Ni+p99h9
	s4HN4+PTWywefVtWMXqcWXCE3ePzJjmPTU/eMgVwRWXbZKQmpqQWKaTmJeenZOal2yp5B8c7
	x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gD9pKRQlphTChQKSCwuVtK3synKLy1JVcjILy6x
	VUotSMkpMCnQK07MLS7NS9fLSy2xMjQwMDIFKkzIzvi8o4+lYAt3xfsdP5gbGI9ydjFyckgI
	mEi8O7eBpYuRi0NIYDejxLFbV9khnE+MEvueXYJyvjFKzLy8gh2mZeufr1CJvYwSX6fMZARJ
	CAl8ZpQ4NCEVxGYTUJc48ryVEaRIRGAPo0TvwtNgS5gFJjBJLJi+hRmkSlggQGLq2n9ACQ4O
	FgFViS33KkDCvAKWEguXHmSB2CYvMfPSd7DNnAJWEnP+3mWBqBGUODnzCZjNDFTTvHU2M8h8
	CYE7HBLzu7vZIJpdJI723II6W1ji1fEtULaUxMv+Nig7XeLH5adMEHaBRPOxfYwQtr1E66l+
	ZpDbmAU0Jdbv0ocIy0pMPbWOCWIvn0Tv7ydQrbwSO+bB2EoS7SvnQNkSEnvPNUDZHhL90w9D
	Q66XUeLR717GCYwKs5D8MwvJP7MQVi9gZF7FKJlaUJybnlpsWmCYl1oOj+bk/NxNjOCEruW5
	g/Hugw96hxiZOBgPMUpwMCuJ8M5LVU8X4k1JrKxKLcqPLyrNSS0+xGgKDO+JzFKiyfnAnJJX
	Em9oYmlgYmZmZmJpbGaoJM77unVuipBAemJJanZqakFqEUwfEwenVAPTyr4/1yROcayR1Gie
	ZHZY2uZp9RtDvj9CO9OrBNJ8OuY0LJ1ir/9O3nbWYY9bcxpq2tKkJ24+LTQnZrrp3+niMp4V
	xt/y/W7+vLS8cz9388aw66r2rGaZH467FlilFeTb1D3wOZZwoc3l/uKIMCmtYoPGDo0FlgHv
	Uxz/zlDZOu9knHjTcgP+lH3TznKJvLYUVp5RtVXS7YrGhSDH3PhZO304TdcuNn15Jvz1LM3l
	51YnyGa9jX3A1mQ/fYro1B/fOXfMnr6bq8d69UfheZzRP+5efadlVBGd5sasY56yZJZv30NN
	zxgpIy9uyQuZfm1adZo1r+6x+OVazTpSyP2/Ttj4Sej2wvCdvCfyViixFGckGmoxFxUnAgDF
	mwMmcQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsWy7bCSvO6LaxrpBrevylh8/PqbxaJpwl9m
	izmrtjFarL7bz2bx+vAnRoubB3YyWaxcfZTJ4l3rORaL2dObmSyO/n/LZjHp0DVGi723tC32
	7D3JYjF/2VN2i+7rO9gslh//x2Rx/u9xVovzs+awOwh57Jx1l93j8tlSj02rOtk8Ni+p99h9
	s4HN4+PTWywefVtWMXqcWXCE3ePzJjmPTU/eMgVwRXHZpKTmZJalFunbJXBlfN7Rx1Kwhbvi
	/Y4fzA2MRzm7GDk5JARMJLb++crexcjFISSwm1FiytODjBAJCYlTL5dB2cISK/89hyr6yCix
	+do5dpAEm4C6xJHnrWBFIgInGCXmT3QDKWIWmMEk8fvPAhaQhLCAn0TPxUdADRwcLAKqElvu
	VYCEeQUsJRYuPcgCsUBeYual72AzOQWsJOb8vQsWFwKq2dR0iQWiXlDi5MwnYDYzUH3z1tnM
	ExgFZiFJzUKSWsDItIpRMrWgODc9N9mwwDAvtVyvODG3uDQvXS85P3cTIzjitDR2MN6b/0/v
	ECMTB+MhRgkOZiUR3nmp6ulCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeQ1nzE4REkhPLEnNTk0t
	SC2CyTJxcEo1MM06EG7VJaU36/eqd3cK323YI7IwYZWyiqfvZCGH5+sfvJn4YvOmy5GurYIL
	jae7PVl8Y8bmpZdWcm8RfcwcJ6c7K/bX+k2vPn/YffVQRKtCguuXJcK3lt2OyDg40cfg52Sb
	1f0R0x3OdDJK8Pt7mVampt9b2Lf7x6TGRtXkpevW7umwS3u2e/HqiqMX2ZwXicad++q99u4a
	uZbNR6eFbNfpTpLQ2bfpT9ae1jjpNsFHgcqlypPnP9h5VPvUXavi9c4SzG9+SM1yvzWncI2W
	sF1t0JkZl+65bT/+8PCfMNdw3zV6f794TI/r3Xkp0bx5+5G3vrpG/FLpte5MX7sMn1RGMbyv
	6TTVvvzWacEpEcsEJZbijERDLeai4kQAWokeuScDAAA=
X-CMS-MailID: 20241104141504epcas5p47e46a75f9248a37c9a4180de8e72b54c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241104141504epcas5p47e46a75f9248a37c9a4180de8e72b54c
References: <20241104140601.12239-1-anuj20.g@samsung.com>
	<CGME20241104141504epcas5p47e46a75f9248a37c9a4180de8e72b54c@epcas5p4.samsung.com>

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


