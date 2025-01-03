Return-Path: <io-uring+bounces-5661-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 265DFA00AFF
	for <lists+io-uring@lfdr.de>; Fri,  3 Jan 2025 16:03:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C152F1611BA
	for <lists+io-uring@lfdr.de>; Fri,  3 Jan 2025 15:03:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84A101FAC55;
	Fri,  3 Jan 2025 15:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="KRSxVasi"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D861FA25D
	for <io-uring@vger.kernel.org>; Fri,  3 Jan 2025 15:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735916572; cv=none; b=UthqbmnnbhYGdkfq0xfmnpEy5Im4xsqREDeM64He5A83aA01a19xpIVrr940xrCH0JhHNUIU2zCx0UudSJO29ZKpu4/wkk0M3WVUy3toabnqdlE9xHZjXy1tSCc9zrbf8Qn1X9DUpNzs47/gUdIzZUj04DecHlEv02t7IXS+QKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735916572; c=relaxed/simple;
	bh=MRZM34NMV0EgI7G+9M5FBvWGqIbheVLEfaJJi05jtzk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a9G+FCKX7ubwCTXSAfTNK8aLCGLxlu8cBorOm9SKdAjovclji7AnXEsicQrhXqNTpiU08WYZ7XrpblMXGDysXLI3aOhF64qOlBuXi8CrB8tuzxlVlR6gy3UXZV+FhvN3bSpWrkGYPecbAN0ubYkqYFrFuSPTd7freQTofs35W6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b=KRSxVasi; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 503F0kZj009872
	for <io-uring@vger.kernel.org>; Fri, 3 Jan 2025 07:02:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=facebook; bh=u
	kEv+MRk0M738B1YTBkjNZ/0oAAvdQd0LX84fQr8t2k=; b=KRSxVasi2KCN9kAQE
	oabbSp0MtSMHAOXltlk3uFuZmRec6PT1VYCSAu2v7x0BtX2jKIkyGt/BsoMHH1F/
	oCfoPMBS2zvy7d60I/VGQWBVdbUe93ymrThNtcERIQEjfBhHg4c1qZokRyYELOpT
	CPzSB14ZlWwjF5fE4QpvxCQsh0=
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 43xf01gxj1-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Fri, 03 Jan 2025 07:02:50 -0800 (PST)
Received: from twshared8234.09.ash9.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Fri, 3 Jan 2025 15:02:48 +0000
Received: by devbig276.nha1.facebook.com (Postfix, from userid 660015)
	id 6E6B4A240686; Fri,  3 Jan 2025 15:02:34 +0000 (GMT)
From: Mark Harmstone <maharmstone@fb.com>
To: <linux-btrfs@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: Mark Harmstone <maharmstone@fb.com>
Subject: [PATCH 3/4] io_uring: add io_uring_cmd_get_async_data helper
Date: Fri, 3 Jan 2025 15:02:25 +0000
Message-ID: <20250103150233.2340306-4-maharmstone@fb.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250103150233.2340306-1-maharmstone@fb.com>
References: <20250103150233.2340306-1-maharmstone@fb.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: cqkDSxdt6r2LUgA2nxOMG23WwUc7tmtM
X-Proofpoint-ORIG-GUID: cqkDSxdt6r2LUgA2nxOMG23WwUc7tmtM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

Add a helper function in include/linux/io_uring/cmd.h to read the
async_data pointer from a struct io_uring_cmd.

Signed-off-by: Mark Harmstone <maharmstone@fb.com>
---
 include/linux/io_uring/cmd.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index a65c7043078f..a3ce553413de 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -118,4 +118,9 @@ static inline struct task_struct *io_uring_cmd_get_ta=
sk(struct io_uring_cmd *cmd
 	return cmd_to_io_kiocb(cmd)->tctx->task;
 }
=20
+static inline struct io_uring_cmd_data *io_uring_cmd_get_async_data(stru=
ct io_uring_cmd *cmd)
+{
+	return cmd_to_io_kiocb(cmd)->async_data;
+}
+
 #endif /* _LINUX_IO_URING_CMD_H */
--=20
2.45.2


