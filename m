Return-Path: <io-uring+bounces-6719-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B5CAA42F2A
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 22:32:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 178C11890A01
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 21:32:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 780861DE3D9;
	Mon, 24 Feb 2025 21:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="SOaDFVEG"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07741F4177
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 21:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740432700; cv=none; b=dX6rcpzVbKS1wDhY4CZLmAAxpVz6cYHkelo+SlFlfCL9YV9V6cTcX1lYKF16zf/0ryNDexk3dj7hFGbwfK1JqMjC9PhUCa+kHQy3FrLWJAmaJiwxpYGlmGZJongTwWQ47NLe/9Uj0pGmkypgQkMk9Rlhfl+KqJNbiL3YNscNwWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740432700; c=relaxed/simple;
	bh=dyKlvxGB9ur3ivjBicd02vF8E+IwAJ77t9EMmbKZOx0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hsQn5+MfUS72ZfAvw6mjrrlTw1yaG5z8owUuZw17HibO7d2oahL27EEz+WgFegmcEh1yshyYyOROmbkyS1yy/oJPOWR/wQ1U7i7MTI+PbaosTMmL6g5joS28JLx5XFBqTqDBdT8rX18OJ9QtOl9diWOBkbCj/D/1aFn+K0+pVyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=SOaDFVEG; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51OFDF29023467
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 13:31:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=fjVHWXOFLhBd/242WbGuxfrakKcH9NPr2Y8uDvvW03U=; b=SOaDFVEG88s/
	/i3TBiiy8cHMS9LPi8/vEHijoEgXX1Y49bsGM+JYaiRYbx92CBdW72VIwr/eouMJ
	ad8BEmWgtjpF0L70jJnvthDYMEziE1LNZZQB6Pm9/et5Dq49F54Upfpy8eIaDWLP
	aElYXo3nu+se51NY90SI+FYg6ztKpUySHTcs9ARFOfTnbtQb6hP432jWFSH0j4iV
	tDbnSbnpwBdRqztWup4Sh+4RpPGVj5Ba3vsyODj0O2P8oqIkX66FL51yrqi+0pR3
	2Qu2p3MixZqlUhFUhABmZ53ZFjoeomXEpICysYjUE4CnIiO02qYcZm7Icv/xzZdx
	VFwyY325Nw==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 450tdcufs5-10
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 13:31:37 -0800 (PST)
Received: from twshared46479.39.frc1.facebook.com (2620:10d:c0a8:1b::8e35) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Mon, 24 Feb 2025 21:31:24 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 938C81868C4F6; Mon, 24 Feb 2025 13:31:17 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <ming.lei@redhat.com>, <asml.silence@gmail.com>, <axboe@kernel.dk>,
        <linux-block@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: <bernd@bsbernd.com>, <csander@purestorage.com>,
        Xinyu Zhang
	<xizhang@purestorage.com>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCHv5 08/11] nvme: map uring_cmd data even if address is 0
Date: Mon, 24 Feb 2025 13:31:13 -0800
Message-ID: <20250224213116.3509093-9-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250224213116.3509093-1-kbusch@meta.com>
References: <20250224213116.3509093-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 6FwKshz371lO-FuoqaD7jyAVsJWBQ0ZQ
X-Proofpoint-ORIG-GUID: 6FwKshz371lO-FuoqaD7jyAVsJWBQ0ZQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-24_10,2025-02-24_02,2024-11-22_01

From: Xinyu Zhang <xizhang@purestorage.com>

When using kernel registered bvec fixed buffers, the "address" is
actually the offset into the bvec rather than userspace address.
Therefore it can be 0.
We can skip checking whether the address is NULL before mapping
uring_cmd data. Bad userspace address will be handled properly later when
the user buffer is imported.
With this patch, we will be able to use the kernel registered bvec fixed
buffers in io_uring NVMe passthru with ublk zero-copy support in
https://lore.kernel.org/io-uring/20250218224229.837848-1-kbusch@meta.com/=
T/#u.

Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Xinyu Zhang <xizhang@purestorage.com>
---
 drivers/nvme/host/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index e0876bc9aacde..fe9fb80c6a144 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -513,7 +513,7 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, =
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


