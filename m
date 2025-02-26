Return-Path: <io-uring+bounces-6811-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BAEBA469AA
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 19:27:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3399C1886F11
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 18:27:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E97F523ED40;
	Wed, 26 Feb 2025 18:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="XTjFnQAX"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514092356CB
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 18:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740594086; cv=none; b=BUuibqt2mCcVA+x+dmRp68KAyx/s332cJa214EDMnF7QbOUWyGSz0IhT22WYAFwcxNe5ujOpwRow15nDfDyGk2XZwjCT+WJZ2lYY/e0UjrbRgtTSzW2wtUqydRIY6Wk5OSDvNS3HMp7dTRZKc0to72Oh+d8UP5msXWmhu6GIemA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740594086; c=relaxed/simple;
	bh=vXpPB62p/gOzDfVR0WVJxsPbSl2431glAEKWypdX2WI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gzamQEWcrEznhAoGxxwyzHHq5F1/F3M70A2Lg9bHhljmV/WUeCfL459E1YmmEp4t9ldFFGq1PObc/tpDjG1wV8MjfzAoRPnuJaagay5wj13kkfb7kO9pCyGzi2cRnRc103C6dSo3/GhlNc876SpliHH8CAaEHD5+T5N6KrOC5wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=XTjFnQAX; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51QF0nII019916
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 10:21:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=rhZprq/fhlitTeHklVfwoWYolzCx7OIds6d1dWBk5OU=; b=XTjFnQAXg4xI
	WeqXWBWb30Xt6tDWW7TF6EtQZvilQ9Fc/UR4/c8GHNZew8b9Flx2ucQaqxUKxGSU
	FY1cAkyXpa9D8w/K6FhqapM7P6K4PCfZ3nPTz8tPJP5Lb2KtJaOuwtYot5yKyh0K
	zgKJ7I7wTjInTcMWyJQJwIjIapapMwYTMFtqbiUmKXxPs1ZSf7a511vRD8YvvgVw
	/GnefufHBWx75pExZmpA2gRV+WWOZD9xUepFcnFlj9lWSwa2yrwqT6a7voz2aB8L
	dK9kpOH5jTnMpxHLzbk822Itt5wdomtaj9wU3uRlbyN/xfIsXLypIFSYlqSpyy1e
	EvroPGKXxQ==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 45257j1hut-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 10:21:23 -0800 (PST)
Received: from twshared32179.32.frc3.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Wed, 26 Feb 2025 18:21:07 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id BEB64187C82C8; Wed, 26 Feb 2025 10:21:04 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <ming.lei@redhat.com>, <asml.silence@gmail.com>, <axboe@kernel.dk>,
        <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: <bernd@bsbernd.com>, <csander@purestorage.com>,
        <linux-nvme@lists.infradead.org>,
        Xinyu Zhang <xizhang@purestorage.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv7 3/6] nvme: map uring_cmd data even if address is 0
Date: Wed, 26 Feb 2025 10:20:58 -0800
Message-ID: <20250226182102.2631321-4-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250226182102.2631321-1-kbusch@meta.com>
References: <20250226182102.2631321-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 7PA5ZkULyf-OHEe2ILdeC5p3PXjeZXw0
X-Proofpoint-GUID: 7PA5ZkULyf-OHEe2ILdeC5p3PXjeZXw0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-26_04,2025-02-26_01,2024-11-22_01

From: Xinyu Zhang <xizhang@purestorage.com>

When using kernel registered bvec fixed buffers, the "address" is
actually the offset into the bvec rather than userspace address.
Therefore it can be 0.

We can skip checking whether the address is NULL before mapping
uring_cmd data. Bad userspace address will be handled properly later when
the user buffer is imported.

With this patch, we will be able to use the kernel registered bvec fixed
buffers in io_uring NVMe passthru with ublk zero-copy support.

Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Xinyu Zhang <xizhang@purestorage.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/nvme/host/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 5078d9aaf88fc..ecf136489044f 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -516,7 +516,7 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, =
struct nvme_ns *ns,
 		return PTR_ERR(req);
 	req->timeout =3D d.timeout_ms ? msecs_to_jiffies(d.timeout_ms) : 0;
=20
-	if (d.addr && d.data_len) {
+	if (d.data_len) {
 		ret =3D nvme_map_user_request(req, d.addr,
 			d.data_len, nvme_to_user_ptr(d.metadata),
 			d.metadata_len, ioucmd, vec, issue_flags);
--=20
2.43.5


