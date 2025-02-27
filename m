Return-Path: <io-uring+bounces-6848-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF806A48BD5
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2025 23:42:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD1103B7DBE
	for <lists+io-uring@lfdr.de>; Thu, 27 Feb 2025 22:41:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 452BA27004B;
	Thu, 27 Feb 2025 22:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="Akr2HU5E"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C2026F469
	for <io-uring@vger.kernel.org>; Thu, 27 Feb 2025 22:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740696006; cv=none; b=qyi2pX8Tv1RYKcjIbbE+cPOy08dPx0w6OL/EXGBB1caOeDySTO+YW/EUlbvys5SyE6sjLxbvjX8ijVPwak2nU5+N4Slpm9/ljkWyNuWF6dYNM/kUpb7i1GqJUlULuJx0TYXqxh9HiPZhY9MNm6i7z6zoDpATBYoY/j55S+r9xag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740696006; c=relaxed/simple;
	bh=VCYCRmQ8GMsCSkoa2Oba5wZwysPaX545Y5agb0250v0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T21X1u9bQlhhCI1Iamtcu5mIvy4SY2tPC3NlNRoW1GKHp3LZccnYS0Yr0HFIEDfq6QGRfCjCBHd2z0nw8tapEPFEjK9z80VH750PKj0F1sVzzcf5JZY42pru3F/YLFlBThVeqbD8oRtnzasH3aoReq/pQxr+v7NYKAc8VCyT/18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=Akr2HU5E; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51RMdiR9011881
	for <io-uring@vger.kernel.org>; Thu, 27 Feb 2025 14:40:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=c/rvD21U8zQ6S1LUw7Ft4KPhPGl3wO16d7e5rYdZ1sM=; b=Akr2HU5EQlFn
	Ei4zV5oDaV2kKUYbt/L7XlG3V5JUGz6bI19UNQ3x6u7r8gms+h3VrQ8PqYWMazhR
	KQ9vCXFmfOjfJADjrvtLYaPyvy5k9/pUCrmSYBlPfDg21K4X+TfMFD+LV2IbXfFp
	YQVtdDQE1EJr17Qp0+7IaljDqwfPiEadsgK7yxbEEjPHAlCbi7QXScyvW1KidVId
	2n14Ixw8CYdhrlLw9b1/+a7um08H8Z4z5/261pWJwWF2GzZrclfHE5OR+L4rxGj0
	VYHaBUi0U8MO//xYYey57/2FHKVnfZWWtW64vi9B6i3bx/N0OWgDXoFJI5uzt7zY
	7VuHBm4uZA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 452wtb9nsk-17
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Thu, 27 Feb 2025 14:40:03 -0800 (PST)
Received: from twshared40462.17.frc2.facebook.com (2620:10d:c0a8:fe::f072) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Thu, 27 Feb 2025 22:39:14 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id C14AF18882811; Thu, 27 Feb 2025 14:39:17 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <ming.lei@redhat.com>, <axboe@kernel.dk>, <asml.silence@gmail.com>,
        <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: <linux-nvme@lists.infradead.org>, <csander@purestorage.com>,
        Xinyu Zhang
	<xizhang@purestorage.com>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCHv8 3/6] nvme: map uring_cmd data even if address is 0
Date: Thu, 27 Feb 2025 14:39:13 -0800
Message-ID: <20250227223916.143006-4-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250227223916.143006-1-kbusch@meta.com>
References: <20250227223916.143006-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: JyZcHzVH-RReOtcrp5O5aBrDG3NEIgna
X-Proofpoint-ORIG-GUID: JyZcHzVH-RReOtcrp5O5aBrDG3NEIgna
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-27_08,2025-02-27_01,2024-11-22_01

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
index fb266cf1f8c66..98a0750c0cda5 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -512,7 +512,7 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, =
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


