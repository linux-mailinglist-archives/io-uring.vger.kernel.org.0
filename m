Return-Path: <io-uring+bounces-7852-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EFC95AAC427
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 14:31:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A09A13A76F8
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 12:30:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFBF9281510;
	Tue,  6 May 2025 12:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="VHVmvkUd"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0AC281513
	for <io-uring@vger.kernel.org>; Tue,  6 May 2025 12:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746534414; cv=none; b=OH5iTPrHXEMAMfyeZKoocwooBl4pfpbqsdgAl0ipjCFSq2ASnbco963x4rUA1JJabLYDjvoTsZapNkmLiPat3i11N5K2KlKv6hTCeRNlQ6ElXTJqFtlgFf7xsmjm9wG1MTOO7HAEKzcjZ49fL813hngBkvbPigtbsbuUXYYg8Ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746534414; c=relaxed/simple;
	bh=mAUv0/zqqHxjVYrhOCGJzBmQB9fnzleTgb18cDhZ0mg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=ka6gmUdC4T1fEsfhJPYEtc8vvRQfVZND63K6U/J/b8O4BW/2axRu10fVYw/ReYCMmRI3/+1JrTlePP4xA1qwTg+IFy6mcDvfLSycSp03l5hvj9yjLd81SyNjF1OnJMBuldHb96UBrpbKomm12l5cIuigkXjThykklDxHYkCzO9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=VHVmvkUd; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250506122650epoutp04f172efbd04263f54cd99856babfee22d~878sLfU9p1132311323epoutp047
	for <io-uring@vger.kernel.org>; Tue,  6 May 2025 12:26:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250506122650epoutp04f172efbd04263f54cd99856babfee22d~878sLfU9p1132311323epoutp047
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1746534410;
	bh=MJD8ankdZER6jge4j8Y32fgNROIBVqL1ceDFGhbO5HM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VHVmvkUdh+VvTfU5XTRhpB6zUGzyrurSawWlht8eAsDjp1CVhOjV5gTwI9s7XSbAa
	 6B0aiWy+vDoJ+saj3gZ5I2tMQgbmZEsvU4QIqApWqevIBD4zCt3Mfx3Fu9Umpx5ylO
	 zrLLqYi2LQ3bDaj8ZqsDp0+oo1TMDvHrCNieOfW8=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250506122650epcas5p412bb5de505d7306215c115325bb78017~878rgFvwB0663906639epcas5p49;
	Tue,  6 May 2025 12:26:50 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.182]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4ZsHh82MB5z6B9m5; Tue,  6 May
	2025 12:26:48 +0000 (GMT)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250506122647epcas5p41ed9efc231e2300a1547f6081db73842~878pU-PdT1362913629epcas5p4F;
	Tue,  6 May 2025 12:26:47 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250506122647epsmtrp2de951215c2662c79b011527770b10b29~878pUWFSc0521905219epsmtrp2V;
	Tue,  6 May 2025 12:26:47 +0000 (GMT)
X-AuditID: b6c32a28-460ee70000001e8a-f2-681a0007313f
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	EF.E5.07818.7000A186; Tue,  6 May 2025 21:26:47 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250506122646epsmtip20fbf6247dc39f07bafd4d1a7f430124c~878nzHN1Z1704417044epsmtip2U;
	Tue,  6 May 2025 12:26:46 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-nvme@lists.infradead.org, Hannes
	Reinecke <hare@suse.de>, Nitesh Shetty <nj.shetty@samsung.com>, Kanchan
	Joshi <joshi.k@samsung.com>
Subject: [PATCH v16 08/11] nvme: pass a void pointer to
 nvme_get/set_features for the result
Date: Tue,  6 May 2025 17:47:29 +0530
Message-Id: <20250506121732.8211-9-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250506121732.8211-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWy7bCSvC47g1SGwdI32hZzVm1jtFh9t5/N
	Ys+iSUwWK1cfZbJ413qOxeLo/7dsFpMOXWO02HtL22LP3pMsFvOXPWW32PZ7PrMDt8fOWXfZ
	PS6fLfXYtKqTzWPzknqP3Tcb2Dz6tqxi9Nh8utrj8ya5AI4oLpuU1JzMstQifbsEroxbH/4y
	F/wVrPh17DJbA+M5vi5GTg4JAROJ/fMamboYuTiEBHYzSmx92sYKkRCXaL72gx3CFpZY+e85
	O0TRR0aJGZ82MHYxcnCwCWhKXJhcClIjIhAg8XLxY2aQGmaBD4wSeybOZgRJCAvESBz6fxms
	nkVAVWLpZCeQMK+AucSDvYcZIebLS8y89B1sF6eAhcTyPbPA4kJANS+OHmGHqBeUODnzCQuI
	zQxU37x1NvMERoFZSFKzkKQWMDKtYpRMLSjOTc9NNiwwzEst1ytOzC0uzUvXS87P3cQIjgkt
	jR2M77416R9iZOJgPMQowcGsJMJ7/75khhBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHelYYR6UIC
	6YklqdmpqQWpRTBZJg5OqQamuoczE9mef9hhcOXB3ck3dj6f6GJ9x+Do3ci9Pw6V24kdSlqk
	cP3kn4oX5o1TD/D82iM9Y7V7n+2NniydcC+OLldb11rb1UFPGzwq/j5pmcT27tmHFNfSn0rr
	Hz3w9/nNPOvkxYWn/fgLtB/cPNbZsV1inuiEi813j5hXi8QaPvDjOcl+u87U6VX74t7tH/3U
	8q+s3Gj0o9qujVeobntHzp7S72Yzf1xOWCN8r3NCQ59eu+Gaun+e85O18o+/MDf0nybwVMPZ
	e8UN/aQS3biI40rX7/6P/3LpkpWHszLjBM1ps1KvXly97N0soZQV+sZdu850rk0V69rh+4Nb
	68N5rh1L976IV9t+4e2aDzv3syixFGckGmoxFxUnAgASh4Y9+AIAAA==
X-CMS-MailID: 20250506122647epcas5p41ed9efc231e2300a1547f6081db73842
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250506122647epcas5p41ed9efc231e2300a1547f6081db73842
References: <20250506121732.8211-1-joshi.k@samsung.com>
	<CGME20250506122647epcas5p41ed9efc231e2300a1547f6081db73842@epcas5p4.samsung.com>

From: Christoph Hellwig <hch@lst.de>

That allows passing in structures instead of the u32 result, and thus
reduce the amount of bit shifting and masking required to parse the
result.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 drivers/nvme/host/core.c | 4 ++--
 drivers/nvme/host/nvme.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 0d834ca606d9..dd71b4c2b7b7 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1676,7 +1676,7 @@ static int nvme_features(struct nvme_ctrl *dev, u8 op, unsigned int fid,
 
 int nvme_set_features(struct nvme_ctrl *dev, unsigned int fid,
 		      unsigned int dword11, void *buffer, size_t buflen,
-		      u32 *result)
+		      void *result)
 {
 	return nvme_features(dev, nvme_admin_set_features, fid, dword11, buffer,
 			     buflen, result);
@@ -1685,7 +1685,7 @@ EXPORT_SYMBOL_GPL(nvme_set_features);
 
 int nvme_get_features(struct nvme_ctrl *dev, unsigned int fid,
 		      unsigned int dword11, void *buffer, size_t buflen,
-		      u32 *result)
+		      void *result)
 {
 	return nvme_features(dev, nvme_admin_get_features, fid, dword11, buffer,
 			     buflen, result);
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 51e078642127..aedb734283b8 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -896,10 +896,10 @@ int __nvme_submit_sync_cmd(struct request_queue *q, struct nvme_command *cmd,
 		int qid, nvme_submit_flags_t flags);
 int nvme_set_features(struct nvme_ctrl *dev, unsigned int fid,
 		      unsigned int dword11, void *buffer, size_t buflen,
-		      u32 *result);
+		      void *result);
 int nvme_get_features(struct nvme_ctrl *dev, unsigned int fid,
 		      unsigned int dword11, void *buffer, size_t buflen,
-		      u32 *result);
+		      void *result);
 int nvme_set_queue_count(struct nvme_ctrl *ctrl, int *count);
 void nvme_stop_keep_alive(struct nvme_ctrl *ctrl);
 int nvme_reset_ctrl(struct nvme_ctrl *ctrl);
-- 
2.25.1


