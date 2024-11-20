Return-Path: <io-uring+bounces-4873-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 960729D40B4
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 18:01:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 05DF4B256E6
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 16:02:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E55F13AA31;
	Wed, 20 Nov 2024 16:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="B/CcH8E3"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59B244C77
	for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 16:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732118565; cv=none; b=RGyaxCZFkogFZfuvh8gEy7ZrPTsSUNyhY7dsP6TLaDinBi8pTlw3ZbJ/uTrJHHxnTjFqplZv4dlcViCXMHm3NSw1bxLd8sI5GZnArYViM3lMprTA5MRxk0zFdJpduUSROT5/gcLT4g8+lgY8mtkbPqhMSss7a+kH1G+m5dD0C+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732118565; c=relaxed/simple;
	bh=OqtJq3ahlSGdHyPJbgGHNCqxDAgenh7DESWAVPuKH04=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PMoreeIwQZDoTAkx2uZupqSAL5QXNDYFWvIGCI0kCL001RMfHyPG3QMCbTYx2Sv17LWMMYwWgpt4WDXFdoO1qBNO13B3pDj5xUkNdAzbJVhOc7aikojiV9JJQHf8GSyiR/SaCuNN/UjCo6uT7zK0tY0wx+WlwkOmOLfzck/QLMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b=B/CcH8E3; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AKEoVAU025849
	for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 08:02:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=facebook; bh=S
	HVX3sOvMshIuyLKRxsT8AWGWEzv/R6py4+nRM3QQdk=; b=B/CcH8E3gGGwuVw6W
	gEZ3n+YjFwltCRbMqSQ+wt8wyiQILDmH4MowO/ZyfNIvNeKDPw3kcUznk7LLSbnw
	+cjAQxJ+IWluUvznmjh05k09JElQ5XKOuqyMHGovIdxQ87K5HGysNbCPUgvYMTLB
	DJfBrZ0e4MAoIcTEZyn35yNWCw=
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 431dmc9xem-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 08:02:42 -0800 (PST)
Received: from twshared12347.06.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Wed, 20 Nov 2024 16:02:41 +0000
Received: by devbig276.nha1.facebook.com (Postfix, from userid 660015)
	id C6C6C8D1CF07; Wed, 20 Nov 2024 16:02:35 +0000 (GMT)
From: Mark Harmstone <maharmstone@fb.com>
To: <linux-btrfs@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: Mark Harmstone <maharmstone@fb.com>
Subject: [PATCH 2/4] io_uring: use sizeof for io_issue_defs[IORING_OP_URING_CMD].async_size
Date: Wed, 20 Nov 2024 16:02:20 +0000
Message-ID: <20241120160231.1106844-2-maharmstone@fb.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241120160231.1106844-1-maharmstone@fb.com>
References: <20241120160231.1106844-1-maharmstone@fb.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: GfVJuFulFZmew5mRR_1DKkS_eKY4lHtK
X-Proofpoint-GUID: GfVJuFulFZmew5mRR_1DKkS_eKY4lHtK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

Correct the value of io_issue_defs[IORING_OP_URING_CMD].async_size so
that it is derived from the size of the struct rather than being
calculated.

Signed-off-by: Mark Harmstone <maharmstone@fb.com>
---
 io_uring/opdef.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index a2be3bbca5ff..c7746f67cc65 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -7,6 +7,7 @@
 #include <linux/fs.h>
 #include <linux/file.h>
 #include <linux/io_uring.h>
+#include <linux/io_uring/cmd.h>
=20
 #include "io_uring.h"
 #include "opdef.h"
@@ -414,7 +415,7 @@ const struct io_issue_def io_issue_defs[] =3D {
 		.plug			=3D 1,
 		.iopoll			=3D 1,
 		.iopoll_queue		=3D 1,
-		.async_size		=3D 2 * sizeof(struct io_uring_sqe),
+		.async_size		=3D sizeof(struct io_uring_cmd_data),
 		.prep			=3D io_uring_cmd_prep,
 		.issue			=3D io_uring_cmd,
 	},
--=20
2.45.2


