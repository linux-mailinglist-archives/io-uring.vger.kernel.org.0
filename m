Return-Path: <io-uring+bounces-6241-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C6E6A262EF
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2025 19:48:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AEEB21883C7E
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2025 18:48:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B33620DD5C;
	Mon,  3 Feb 2025 18:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="GJXBlChF"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFF6200B85
	for <io-uring@vger.kernel.org>; Mon,  3 Feb 2025 18:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738608425; cv=none; b=aN1vQsebNhFU4fqCsMK1FbJoQfhtv5b9gmF/QN02hSJRMUJhNHA4UfOvw/4cKhBNZyeFDKWY/p+He7Vl+v1Hb2Lbb0VG0aJ1oyJGh+dCb6tk0zxRd0WiMN1Cv3OEJuhUbJlGljxNNDGZhjPRexJ0T7irjPg9WxZkW65zyVrgdzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738608425; c=relaxed/simple;
	bh=/WYgHsLI5eifEYT5swohdT4yQ+49Q6fPRUFAd6eM6kk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SCIWnQfHf0hUtAOPksptrQFd6S94WkgnJBxadiFI+TUqr9vbb+iT7PueJfrU8a+63u29ch6LerTKCzMbxbfQbBD/ApzU0BfdsybvT02HPmR2aW37FgK/K53P0DaRYTxOcuFZ+zT9xENllB6tJuzZfZNxesHIE90HFRCbhKPlXcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=GJXBlChF; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 513II7Ui006733
	for <io-uring@vger.kernel.org>; Mon, 3 Feb 2025 10:47:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=KNtJy29+KoGrn3iBKs7XMNaUdfIgRyhno7K3eRzagcM=; b=GJXBlChF282J
	pNKHtixW1I3z5kcn6syrvDgUb2CEPZdC3pi4zqy4duQWcsP6ggnIaRdJrj1MOG7b
	ALlG9M29qgH48FKs77VgmUztkdrK/+/tlRP1LsFRby6RDpPIv6PkcC86gYsaCw66
	0EScuVLNCdXhWxt+DkPZE7h5LR9q5ODem0QZoUV2gykrYsmrLebd0ElRffe0Y7IE
	KE3cfyrMVeEdaF83iqOddRf3FxPvi4BXEsBN7iR/MZQShonaTomqbl/3bWTbT9Ps
	7RDjuxFdrV37GrS+/60PrjlZQO2Q73HiDOIH30B94FBJmcu7AAOsHpwB+/ukGysx
	jbMR4++c/A==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 44k2468qsc-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 03 Feb 2025 10:47:02 -0800 (PST)
Received: from twshared3076.40.frc1.facebook.com (2620:10d:c0a8:fe::f072) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Mon, 3 Feb 2025 18:47:00 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id D021F179C2631; Mon,  3 Feb 2025 10:41:34 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <linux-nvme@lists.infradead.org>, <io-uring@vger.kernel.org>,
        <linux-block@vger.kernel.org>
CC: <linux-fsdevel@vger.kernel.org>, <asml.silence@gmail.com>,
        <axboe@kernel.dk>, <hch@lst.de>, <sagi@grimberg.me>,
        Hannes Reinecke
	<hare@suse.de>, Nitesh Shetty <nj.shetty@samsung.com>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCHv2 08/11] nvme: pass a void pointer to nvme_get/set_features for the result
Date: Mon, 3 Feb 2025 10:41:26 -0800
Message-ID: <20250203184129.1829324-9-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250203184129.1829324-1-kbusch@meta.com>
References: <20250203184129.1829324-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: H57NGj7ulKTThxAMuDSQrZVOidwMnI1T
X-Proofpoint-GUID: H57NGj7ulKTThxAMuDSQrZVOidwMnI1T
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-03_08,2025-01-31_02,2024-11-22_01

From: Christoph Hellwig <hch@lst.de>

That allows passing in structures instead of the u32 result, and thus
reduce the amount of bit shifting and masking required to parse the
result.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/nvme/host/core.c | 4 ++--
 drivers/nvme/host/nvme.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 8c43823cc37e1..324b31ba270a6 100644
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
index 7be92d07430e9..9c94c1085869b 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -895,10 +895,10 @@ int __nvme_submit_sync_cmd(struct request_queue *q,=
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


