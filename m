Return-Path: <io-uring+bounces-5287-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CB659E7BDA
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 23:36:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A7D3283E50
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 22:36:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73F611F667C;
	Fri,  6 Dec 2024 22:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="SEW/b3uo"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C307D1F472F
	for <io-uring@vger.kernel.org>; Fri,  6 Dec 2024 22:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733524598; cv=none; b=KwB8NaeMQzGXVOiUdxNMv14P1tF42+arF+OpYQ1BZ4JEJ4NPWuTccl/8xgaPfT50q42RBhEu/8EzhPp+q/z+FWE8GtsF1yP8nxksfj6L31TU+YHKJa/iGb0s/HTex4bf56Dwh+12EOlv8g6XaA9slgTmySZa9/+MgKx7+oyQqUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733524598; c=relaxed/simple;
	bh=CHBzC+VplJqsQBK7O9+6FtU38cmqBWKdPrsSajpo3Lk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BfEvziiAj6WMB/sopuQmUhHvffD9dCBi8QLJ9zX0nTjXB750ht/KnQUEzrmp2ej7wVZPQMr3xYM0D5SS5nHds9Qwc1lJyxF3c4U233ZhPprwOUYrUZehwPYi4HHYeFyp6fiiePuUkQ/I9b+qwVRaO1QxsPksrjONp0ee+6uKDdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=SEW/b3uo; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B6MaRT6002274
	for <io-uring@vger.kernel.org>; Fri, 6 Dec 2024 14:36:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=885q4w1E275nZID7YwFrzIPpvQxYrUJuHVeBYMPoQ1s=; b=SEW/b3uoyR/S
	5uRPc7klboFCNYbnRyDEMBquoHx86w2IdhP8H7B5PI+LcwNX5xm0CbQi0bXDBLfO
	xPjBRhcnhig8EktkfuWyhHCXADM3Em261jktOhOt0kaQY9cO17FJRwj8KLBfaoSg
	nkzLPNgpySFVi66VWzfSXUqx+mlVePnZRVO2XFG3G97BFnXIzZhSPThqFv+YKoXV
	2YY+600epmpXF3TtXjnlXjyfzlYsOoUo4u4uw+oDN7AGDcfkPjK7KBIQRooOs20M
	PZcPVlt86O5NmZLYU+jvlycqOzEAaIQw/ZHGPYr7FYE+bZucu9bNMI1I+pQm8CRA
	/lAxPVGg8A==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 43c8kv8nyk-11
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Fri, 06 Dec 2024 14:36:35 -0800 (PST)
Received: from twshared7122.08.ash9.facebook.com (2620:10d:c0a8:1c::11) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Fri, 6 Dec 2024 22:35:50 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 5591415B8CB87; Fri,  6 Dec 2024 14:18:27 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <hch@lst.de>, <linux-block@vger.kernel.org>,
        <linux-nvme@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
        <io-uring@vger.kernel.org>
CC: <sagi@grimberg.me>, <asml.silence@gmail.com>, <anuj20.g@samsung.com>,
        <joshi.k@samsung.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv12 09/12] nvme: pass a void pointer to nvme_get/set_features for the result
Date: Fri, 6 Dec 2024 14:17:58 -0800
Message-ID: <20241206221801.790690-10-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241206221801.790690-1-kbusch@meta.com>
References: <20241206221801.790690-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: a8-dgWpj-e9R1hvY9ANcJZ23iGvWpUYk
X-Proofpoint-ORIG-GUID: a8-dgWpj-e9R1hvY9ANcJZ23iGvWpUYk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

From: Christoph Hellwig <hch@lst.de>

That allows passing in structures instead of the u32 result, and thus
reduce the amount of bit shifting and masking required to parse the
result.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/nvme/host/core.c | 4 ++--
 drivers/nvme/host/nvme.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 36c44be98e38c..c2a3585a3fa59 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1678,7 +1678,7 @@ static int nvme_features(struct nvme_ctrl *dev, u8 =
op, unsigned int fid,
=20
 int nvme_set_features(struct nvme_ctrl *dev, unsigned int fid,
 		      unsigned int dword11, void *buffer, size_t buflen,
-		      u32 *result)
+		      void *result)
 {
 	return nvme_features(dev, nvme_admin_set_features, fid, dword11, buffer=
,
 			     buflen, result);
@@ -1687,7 +1687,7 @@ EXPORT_SYMBOL_GPL(nvme_set_features);
=20
 int nvme_get_features(struct nvme_ctrl *dev, unsigned int fid,
 		      unsigned int dword11, void *buffer, size_t buflen,
-		      u32 *result)
+		      void *result)
 {
 	return nvme_features(dev, nvme_admin_get_features, fid, dword11, buffer=
,
 			     buflen, result);
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 611b02c8a8b37..c1995d89ffdb8 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -890,10 +890,10 @@ int __nvme_submit_sync_cmd(struct request_queue *q,=
 struct nvme_command *cmd,
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
--=20
2.43.5


