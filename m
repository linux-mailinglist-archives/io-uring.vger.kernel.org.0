Return-Path: <io-uring+bounces-7854-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA94BAAC42A
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 14:32:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 385613AF3E1
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 12:31:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBC0F2820B4;
	Tue,  6 May 2025 12:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="NoWiVmDQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29C72820AA
	for <io-uring@vger.kernel.org>; Tue,  6 May 2025 12:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746534419; cv=none; b=lK3Fwrdq6zqUZs4AHL0PgputiVrDE0vowQWBgeJHRljhC4u6TqYsjRrutSFYk3FJGgmBuVgCurqsS/ZWaxWlLFiKMyyjmhWaT9HSArvBFnXFPtBHlJwAGgeo7gBBev+3CSrfjtIQMXPOe103A9DFdW6LK+z3BDzzirC0zy85eyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746534419; c=relaxed/simple;
	bh=i8c4uUrUpHqyKCWuBJhFo0rwlKuwu2Q+QbCajtrihmU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=l7PqCoUUPa9UlqrRwhSoKTMorzE6WQfIYPm/34XUs6twyYq4Cu4dc/KVWQaDo4cOYKtQ2jfazLBn3YlbcQRdvYiLNOXCF76qwBHAGyj6wrZRsO+lKDTQ/8SUGJXHg64zDGVSOGWxnuE2NeuftLL6JCTEg9EY6LU+0WwXU23Gh4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=NoWiVmDQ; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250506122656epoutp0385b218005873aa40b07d29d38cec8179~878xG4qHR2443224432epoutp03p
	for <io-uring@vger.kernel.org>; Tue,  6 May 2025 12:26:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250506122656epoutp0385b218005873aa40b07d29d38cec8179~878xG4qHR2443224432epoutp03p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1746534416;
	bh=eAt1TC33VEZKhra4JdmMfO0QKM/NIeusGmijSmzNAoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NoWiVmDQEZUfT2ZpaVFQMyQV3Yq+IU9yx11r8ZHo8526edorEqAfePIAYsbQ1qUNY
	 8ZrujfOCB1uygcqDtgVTdN3cGZGQTmoznN7hzPv4bK5XKhginqwHn7EGgERp5ro/SS
	 qw2eUjByMMPCDpvS/+TORl9wESJxwTa0UcJG10U8=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250506122655epcas5p3963211a08a66813ef441cbf8ed7a413a~878wkyES03215232152epcas5p31;
	Tue,  6 May 2025 12:26:55 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.180]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4ZsHhF6Jvmz6B9m4; Tue,  6 May
	2025 12:26:53 +0000 (GMT)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250506122653epcas5p1824d4af64d0b599fde2de831d8ebf732~878uko59V0784707847epcas5p1N;
	Tue,  6 May 2025 12:26:53 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250506122653epsmtrp268652cf3359e450be94a9d41ddbf4d4a~878ujGNsm0522005220epsmtrp2T;
	Tue,  6 May 2025 12:26:53 +0000 (GMT)
X-AuditID: b6c32a2a-d63ff70000002265-6e-681a000dccfd
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	F3.6E.08805.D000A186; Tue,  6 May 2025 21:26:53 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250506122651epsmtip2c19c1d52165df07f6ff54d495a437a19~878s2hELM1663216632epsmtip2X;
	Tue,  6 May 2025 12:26:51 +0000 (GMT)
From: Kanchan Joshi <joshi.k@samsung.com>
To: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-nvme@lists.infradead.org, Hannes
	Reinecke <hare@suse.de>, Nitesh Shetty <nj.shetty@samsung.com>, Kanchan
	Joshi <joshi.k@samsung.com>
Subject: [PATCH v16 11/11] nvme: use fdp streams if write stream is provided
Date: Tue,  6 May 2025 17:47:32 +0530
Message-Id: <20250506121732.8211-12-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250506121732.8211-1-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsWy7bCSvC4vg1SGwbUeLos5q7YxWqy+289m
	sWfRJCaLlauPMlm8az3HYnH0/1s2i0mHrjFa7L2lbbFn70kWi/nLnrJbbPs9n9mB22PnrLvs
	HpfPlnpsWtXJ5rF5Sb3H7psNbB59W1Yxemw+Xe3xeZNcAEcUl01Kak5mWWqRvl0CV8ae5iNM
	Ba9FK7qeXWNpYPwq2MXIySEhYCJxfsN6ti5GLg4hgd2MEssPf2eESIhLNF/7wQ5hC0us/Pec
	HaLoI6PE+UUNQA4HB5uApsSFyaUgNSICARIvFz9mBqlhFvjAKLFn4mywQcICPhIzZ+5jBbFZ
	BFQl7kycCmbzClhIzL77igligbzEzEvfwZZxAsWX75kF1iskYC7x4ugRdoh6QYmTM5+wgNjM
	QPXNW2czT2AUmIUkNQtJagEj0ypGydSC4tz03GLDAqO81HK94sTc4tK8dL3k/NxNjOCo0NLa
	wbhn1Qe9Q4xMHIyHGCU4mJVEeO/fl8wQ4k1JrKxKLcqPLyrNSS0+xCjNwaIkzvvtdW+KkEB6
	YklqdmpqQWoRTJaJg1OqgUlBTeBT2h7hgHXmVbrvY9/1/g2WN5hVzxe45NFBuYpp0ue3Pr6a
	o1T4LK3+mr6MD6NI2/OH9d1FVs5nJWWll5st7fu2Wui+1ooFqmbTbvbVR/rUPdkRvzvA51Pf
	r99rGRiUDBkWaC/fvctqh5qB8jLhKaY52Y+fNPyokl97YM30xqtne7LOLjN/a9OkYPTEwWCl
	g55x3M3She38gQ8SheqO8tqx/V1etGRa4ZpQ/zfXN3yWTL3Yc2GlX21k88STMqm/mmbP8FmQ
	Wipff+M1y6c9OYbc/Yv3qeVkBFW1qBs+NZnYqvHE/tnSvyGZrJPWPbF4V8V9Lnfp6i79hJ35
	ua0+UUEx7pd8PgTozOc5pMRSnJFoqMVcVJwIAMo9x6P5AgAA
X-CMS-MailID: 20250506122653epcas5p1824d4af64d0b599fde2de831d8ebf732
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250506122653epcas5p1824d4af64d0b599fde2de831d8ebf732
References: <20250506121732.8211-1-joshi.k@samsung.com>
	<CGME20250506122653epcas5p1824d4af64d0b599fde2de831d8ebf732@epcas5p1.samsung.com>

From: Keith Busch <kbusch@kernel.org>

Maps a user requested write stream to an FDP placement ID if possible.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 drivers/nvme/host/core.c | 31 ++++++++++++++++++++++++++++++-
 drivers/nvme/host/nvme.h |  1 +
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index f25e03ff03df..52331a14bce1 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -672,6 +672,7 @@ static void nvme_free_ns_head(struct kref *ref)
 	ida_free(&head->subsys->ns_ida, head->instance);
 	cleanup_srcu_struct(&head->srcu);
 	nvme_put_subsystem(head->subsys);
+	kfree(head->plids);
 	kfree(head);
 }
 
@@ -995,6 +996,18 @@ static inline blk_status_t nvme_setup_rw(struct nvme_ns *ns,
 	if (req->cmd_flags & REQ_RAHEAD)
 		dsmgmt |= NVME_RW_DSM_FREQ_PREFETCH;
 
+	if (op == nvme_cmd_write && ns->head->nr_plids) {
+		u16 write_stream = req->bio->bi_write_stream;
+
+		if (WARN_ON_ONCE(write_stream > ns->head->nr_plids))
+			return BLK_STS_INVAL;
+
+		if (write_stream) {
+			dsmgmt |= ns->head->plids[write_stream - 1] << 16;
+			control |= NVME_RW_DTYPE_DPLCMT;
+		}
+	}
+
 	if (req->cmd_flags & REQ_ATOMIC && !nvme_valid_atomic_write(req))
 		return BLK_STS_INVAL;
 
@@ -2240,7 +2253,7 @@ static int nvme_query_fdp_info(struct nvme_ns *ns, struct nvme_ns_info *info)
 	struct nvme_fdp_config fdp;
 	struct nvme_command c = {};
 	size_t size;
-	int ret;
+	int i, ret;
 
 	/*
 	 * The FDP configuration is static for the lifetime of the namespace,
@@ -2280,6 +2293,22 @@ static int nvme_query_fdp_info(struct nvme_ns *ns, struct nvme_ns_info *info)
 	}
 
 	head->nr_plids = le16_to_cpu(ruhs->nruhsd);
+	if (!head->nr_plids)
+		goto free;
+
+	head->plids = kcalloc(head->nr_plids, sizeof(head->plids),
+			      GFP_KERNEL);
+	if (!head->plids) {
+		dev_warn(ctrl->device,
+			 "failed to allocate %u FDP placement IDs\n",
+			 head->nr_plids);
+		head->nr_plids = 0;
+		ret = -ENOMEM;
+		goto free;
+	}
+
+	for (i = 0; i < head->nr_plids; i++)
+		head->plids[i] = le16_to_cpu(ruhs->ruhsd[i].pid);
 free:
 	kfree(ruhs);
 	return ret;
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 3e14daa4ed3e..7aad581271c7 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -498,6 +498,7 @@ struct nvme_ns_head {
 	struct gendisk		*disk;
 
 	u16			nr_plids;
+	u16			*plids;
 #ifdef CONFIG_NVME_MULTIPATH
 	struct bio_list		requeue_list;
 	spinlock_t		requeue_lock;
-- 
2.25.1


