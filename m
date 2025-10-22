Return-Path: <io-uring+bounces-10131-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 68E8BBFD89D
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 19:21:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8646818862DC
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 17:22:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FC3E27A10D;
	Wed, 22 Oct 2025 17:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="hIbwc/3f"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1AF27442
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 17:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761153691; cv=none; b=hiQy9cmJaTJrMFodzzuvF3H7ZFLRwWYbFzzzKOd2xAL8OQSqrkoHPyjtqPdgQuPWfir38hhLUg0tSrr4y0yEugULeaKH/UnpVi0tE88GdciB0zGQNAPltXolcnxhuxnWH14PJoFvnHbfoGn8hdoNUu7/c3nQVgKutPUpAy3GnNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761153691; c=relaxed/simple;
	bh=KFe5Mofj2+KK+CvN9m5SU6q6qMU7rLmX/9+z4W61Swk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YVrINc8QUfLI1C6R8xmv0bQkxYx58zT4i/tpsd2yVeeEiHj75D5YhKrnjccgk0kuFDkgCr6R2P6HiyDJzsjXyPr1HnjECfptDojlTj8hExzPkN3eQYwU/JPuspk/k5FHBTnU9EbrhD2I+hDUyJzCAGW8Ja/14hDc9U+ALMAMEKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=hIbwc/3f; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59MG9CDl3395534
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 10:21:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=RbHjjwqMvJDaAlNXncy+xkS8zxOsxLHCEScJykExcZk=; b=hIbwc/3f7pEL
	kT0fgrQGV1nUzTewCcSwsnGmQAKxo+GksV9aFp7zAEjLtF0FfY4g/xs7G93cFVA9
	S1woFuf1bVgdh7DQpfmzrETP9JOUvNdzh6MheJ/zRaVcXyFekSLVmHPJe6L21vbh
	KOOocPFk2XgKBZNMOdOmqDg1a7rJ1+QgBJUHSc8qCcAj+PSXog2AGCko3A4fIG23
	s83r23eyZKYB0DbJBduDaKDQYkRMqBaGRJl+MWJfsyzGNxJ4ID6Yh4FCHX3X9vII
	LpE6xkzCB+vhsLnMmMq9HCTZy1TqqCmDlLtddJchyPvoL3u411g2F0Uj5nBbpfTT
	VKnUvbylXQ==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 49xvtebqfw-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 10:21:28 -0700 (PDT)
Received: from twshared17671.07.ash8.facebook.com (2620:10d:c0a8:fe::f072) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Wed, 22 Oct 2025 17:21:24 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id EB6D22F95CB7; Wed, 22 Oct 2025 10:21:04 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <io-uring@vger.kernel.org>, <axboe@kernel.dk>, <csander@purestorage.com>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCHv6 5/6] test/fdinfo: flush sq prior to reading
Date: Wed, 22 Oct 2025 10:19:23 -0700
Message-ID: <20251022171924.2326863-6-kbusch@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251022171924.2326863-1-kbusch@meta.com>
References: <20251022171924.2326863-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Qx3Qc1ECvtfW-pZ5jijka2K_uTYT160y
X-Authority-Analysis: v=2.4 cv=bsdBxUai c=1 sm=1 tr=0 ts=68f91298 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8
 a=dP-AYbWbu4cuEZD88EMA:9
X-Proofpoint-GUID: Qx3Qc1ECvtfW-pZ5jijka2K_uTYT160y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDE0MSBTYWx0ZWRfX2yM6QrF3KjYp
 u1ygEieN5r/h0tgTjNGLTb/qJpyDHASfk5RPu07Hs5qq4aeDvCH2YB/IrRyp7PnEjabM8oYmdE5
 Ok820YbKl4GHi7QA4gV4DLDch0zLm0+F+nOM5QCnr85lxmK/RD/ofLZnmq/Y1kQb0oC932xP0b3
 QLITsghMnhCNMZk2XNwAVepoHVBsFJy/34p0+AkMpr3rh3ebrG2sYuhIoj4Xtz9IzAYvjCYdzGN
 gdkkV64qaNO5j1s4FjglJvGkYNvO/irnw5nXaXduvJtOS/SFgFOYcfgCbopY32lYRhtVt5S7fdw
 H0jMjiiFRop937OAjNmMQBHkQUUdnh8nMmx5qC9Sum1qpN+X1YAZP3p47CnXhcX0rZAO+UTRXGN
 cYHywgdDCEuo+1kuVlQoLF52Y7N05w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_07,2025-10-22_01,2025-03-28_01

From: Keith Busch <kbusch@kernel.org>

Ensure the kernel can see the updated tail value before reading the
ring's fdinfo. This tests the kernel's handling for walking the
submission queue.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 test/fdinfo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/test/fdinfo.c b/test/fdinfo.c
index 179f575f..49522a0a 100644
--- a/test/fdinfo.c
+++ b/test/fdinfo.c
@@ -167,6 +167,7 @@ static int __test_io(const char *file, struct io_urin=
g *ring, int write,
 			offset +=3D BS;
 	}
=20
+	__io_uring_flush_sq(ring);
 	fdinfo_read(ring);
=20
 	ret =3D io_uring_submit(ring);
--=20
2.47.3


