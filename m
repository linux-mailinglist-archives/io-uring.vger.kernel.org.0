Return-Path: <io-uring+bounces-3663-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 89EE399D570
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 19:18:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 411D41F24033
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 17:18:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4899C1B85E4;
	Mon, 14 Oct 2024 17:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b="b1Ib3pUZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CBBC1AE877
	for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 17:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728926327; cv=none; b=JkWgmxSutziGfpr0Pq29+sg0G3WaXLA/gOTPsYO9y3D+sKgJBtdLGRE/4y0CHiqtkNXfFsWdEliLBr6HqqCNWfSKP6Zyf1xGbVBSar+vn3Ks3IJEpjkmte4YmSwgS0WpOtyaG4WzbB5VRAbTAGZo3DT8w9lye839aaZCHTXn6A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728926327; c=relaxed/simple;
	bh=/9jnXkipEwHnJUja/lmHyvciFO49j2jUVw6pc4xQM+k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SrOLEe9adlJfuCfj3xs7i+yS2LCJsyfxW3b+M6fd4SIba+FEI7E40HvTDfftfZBMaeH+Yn5VCyIky3YYrM1qt1oobQKuYYv5QjIzcaqCFCkYztxHnCgX0P0mwVCsJPdhDCXqElfRr8E/C/t5uD/cQdbuv/G/+JXgTWJ5QOnDqew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (1024-bit key) header.d=fb.com header.i=@fb.com header.b=b1Ib3pUZ; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49EFq0uT016802
	for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 10:18:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=facebook; bh=5
	GUqpnZKhj1jMR5QISWrdlkk0+/xKkKtZ15yLU1WySU=; b=b1Ib3pUZ8MmKnrxC3
	BstYyt4GTOCzdcr2XjI7XqVV/aSM34WkB//p+M0KY1Dkxm6wXx5fIpUYY6TLlRB5
	QhMelA6o9tF2eLXghqVokcYqUj1VSpWb2VAcCHFFO93wUlEJBjq3ouDUzs6OjmZN
	ZT03ekKY9SPQVdn8tKuddE8+Xw=
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4291qjtmxc-8
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 10:18:44 -0700 (PDT)
Received: from twshared60308.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Mon, 14 Oct 2024 17:18:43 +0000
Received: by devbig276.nha1.facebook.com (Postfix, from userid 660015)
	id 4E9657C37EF5; Mon, 14 Oct 2024 18:18:41 +0100 (BST)
From: Mark Harmstone <maharmstone@fb.com>
To: <linux-btrfs@vger.kernel.org>, <io-uring@vger.kernel.org>
CC: Mark Harmstone <maharmstone@fb.com>
Subject: [PATCH 1/5] btrfs: remove pointless addition in btrfs_encoded_read
Date: Mon, 14 Oct 2024 18:18:23 +0100
Message-ID: <20241014171838.304953-2-maharmstone@fb.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241014171838.304953-1-maharmstone@fb.com>
References: <20241014171838.304953-1-maharmstone@fb.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: P1AXZiWwKntNiT-uogKixv2xzmM66MgG
X-Proofpoint-GUID: P1AXZiWwKntNiT-uogKixv2xzmM66MgG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_02,2024-10-04_01,2024-09-30_01

iocb->ki_pos isn't used after this function, so there's no point in
changing its value.

Signed-off-by: Mark Harmstone <maharmstone@fb.com>
---
 fs/btrfs/inode.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b1b6564ab68f..b024ebc3dcd6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9280,7 +9280,7 @@ ssize_t btrfs_encoded_read(struct kiocb *iocb, stru=
ct iov_iter *iter,
 		ret =3D btrfs_encoded_read_inline(iocb, iter, start, lockend,
 						&cached_state, extent_start,
 						count, encoded, &unlocked);
-		goto out;
+		goto out_em;
 	}
=20
 	/*
@@ -9346,9 +9346,6 @@ ssize_t btrfs_encoded_read(struct kiocb *iocb, stru=
ct iov_iter *iter,
 						 &unlocked);
 	}
=20
-out:
-	if (ret >=3D 0)
-		iocb->ki_pos +=3D encoded->len;
 out_em:
 	free_extent_map(em);
 out_unlock_extent:
--=20
2.44.2


