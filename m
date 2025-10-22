Return-Path: <io-uring+bounces-10144-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A9E5BFE3A6
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 22:56:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 05FDF4E2146
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 20:56:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52D532FFDD8;
	Wed, 22 Oct 2025 20:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="NJf4sEkb"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68942F619C
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 20:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761166577; cv=none; b=YSAccpFBu8OAixzFhdxjxNGG5BO7h86N0MXY3WnXoQZU+hbFvXvkvABqHGJGJ7u5ZfDIsVuf/2Swy1cSRqSNkH9VvuK6GlFEYzsaOLo/Vrx9zlmkes+YeGW44JNJdElYPmjB7k32RTp4gqcVvkNBCNsvMLGceOD5iCSsN3fBcv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761166577; c=relaxed/simple;
	bh=hh7k3pAn55Mq0KrC4z+09nJOkzhr7ce+bTm8aTFaFEI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Xm7l9GMV90dU2IhT7YKm1mMdO8Fg9dEJ1T15sjzQFRfVzoGWkOqIAvhxsjVyHd9z9J14vO53rQyPeT5X4TTQI2dNtMvTWMAOuSJ9152uVbhsYOCBbKLxeQXYJrYqD1RBCmg6LATG/sMkF9Oq5FApAnk7McVupZ5UPVFgp10XDJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=NJf4sEkb; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 59MGYeoE2150923
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 13:56:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=bixJNST93seoEOEZA8
	s49JOAqqA5k3CAxU1D6QY/bfY=; b=NJf4sEkbe8d/y5iT9BgFT4IjPfdKx6FCgY
	sOWDW054B09Rt3UXOPpUCYIsssEIMqX1e+q0dnEURnL7TVzhDi9ndoPk52EOMYEH
	H4S/RxAev57Gq+yuRHndacAKx4OEhULV9gUbjYSVqg0nt78PvUpFiojkmDVchzyq
	RV+YvIo9BELdbi6c5IH7eATnzDFfrgHzww1ePgpKISgaun3ItkKClj9YIP7trmuG
	phs+w8DE60RfioFCkp782AMTp2q5RxzguKuukfqxXv5C8tgJ8DA5yhBo/e755fZE
	13PvG+eclTvYQDBgy6/DGySbeYbJpkOFPD4ZrZAoC9uGbtZgKe0Q==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 49y2wqj79h-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 13:56:13 -0700 (PDT)
Received: from twshared28390.17.frc2.facebook.com (2620:10d:c0a8:1b::2d) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Wed, 22 Oct 2025 20:56:12 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id BA0E92FAA7D5; Wed, 22 Oct 2025 13:56:07 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <io-uring@vger.kernel.org>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCH] io_uring/fdinfo: show SQEs for no array setup
Date: Wed, 22 Oct 2025 13:56:07 -0700
Message-ID: <20251022205607.4035359-1-kbusch@meta.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: ywp2oF74gM80gJ5vdnpePd-mNbmm2Uex
X-Proofpoint-ORIG-GUID: ywp2oF74gM80gJ5vdnpePd-mNbmm2Uex
X-Authority-Analysis: v=2.4 cv=JOY2csKb c=1 sm=1 tr=0 ts=68f944ed cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8
 a=yrzCLZB7q3RD1rw1K8oA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDE3MyBTYWx0ZWRfX7bjIV7+X/Jpk
 AQVFsiYB5szfPQHe5NfPoWbUd0izvvFrDqSS4YZSoOB2cDR7JG/DLFnzbjGi7DZUhJ3JvojdlwY
 SzDIesLj0YvDum4+i5eKN40CB4iDydA6L+W/DXyAIg/3kgiaroCxjUAeNgcTMuJayr8hqUV2sQx
 vkhtvMvAUXRjlamlo9rVGZ8USjIMQ7VlOnx/aMOqaPtUv906lrmHXqbNHO8Vr70doUTp28zXVxV
 C/3BBOTkpz6OY8pPTBW+8+195pBgTcPvrOvKsDGIq+DaUxdFicVZ3kccIx6ueVDfaEUM4CFypsu
 3r8EDTBnVd5nxDw7Za1lsithwTWTWqKNERkuK7d3SqvQK8jvt5imCSAPrl7/DOABOhGX1nrVebk
 QJDidohio+T8Pj204zcdk2SCdNMHlw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_08,2025-10-22_01,2025-03-28_01

From: Keith Busch <kbusch@kernel.org>

The sq_head indicates the index directly in the submission queue when
the IORING_SETUP_NO_SQARRAY option is used, so use that instead of
skipping showing the entries.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 io_uring/fdinfo.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 5b26b2a97e1b9..f034786030105 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -95,8 +95,10 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx =
*ctx, struct seq_file *m)
 		u8 opcode;
=20
 		if (ctx->flags & IORING_SETUP_NO_SQARRAY)
-			break;
-		sq_idx =3D READ_ONCE(ctx->sq_array[sq_head & sq_mask]);
+			sq_idx =3D sq_head & sq_mask;
+		else
+			sq_idx =3D READ_ONCE(ctx->sq_array[sq_head & sq_mask]);
+
 		if (sq_idx > sq_mask)
 			continue;
=20
--=20
2.47.3


