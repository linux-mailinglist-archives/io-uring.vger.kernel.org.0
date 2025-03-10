Return-Path: <io-uring+bounces-7041-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBC59A5A363
	for <lists+io-uring@lfdr.de>; Mon, 10 Mar 2025 19:48:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F2D9016E7DF
	for <lists+io-uring@lfdr.de>; Mon, 10 Mar 2025 18:48:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BE3D22FF32;
	Mon, 10 Mar 2025 18:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="YXB+qR3v"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D317422D7AF
	for <io-uring@vger.kernel.org>; Mon, 10 Mar 2025 18:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741632515; cv=none; b=BQFRRv0lzJlQLE3/60dSAB7vrCoWICwYuRbIaWsuZiv/LEJ8HMZGlFyOWEt029KsgmeEGRk25+ZTiF2ux+fUAY2CpY1EViHsDbuaGtBSw17cW0Yc8jA2tDMd6ZXYDFk9MkAqo0aq0ZHs9W3C2LZOzLF0sNjlVwu9x8aVWT4Ulx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741632515; c=relaxed/simple;
	bh=V4ngJNbYjOFauRLK2XDDOdlnswaLoXdsDuZ+qO1iiPc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sK8AaP1uQywN2YGCamhUNBLr+J+yVdmqF8432VLlJOrUXeyIV7n5/k3W8sFZEy+t4GCorhI8XyF/Q36NZ+f7y4tL198CtNCua+H+okbOdZTDJLzvAx62P7/EL2ew96viHR4365yhsrDTPk9Crwzei0T/ZEqnjdqBB0iXyIe/nvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=YXB+qR3v; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52AIjtUE011966
	for <io-uring@vger.kernel.org>; Mon, 10 Mar 2025 11:48:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2021-q4; bh=NeweqHG3cjEJrEffK7
	KGPSo7e/jAIZ8WVL8aMOTEhZM=; b=YXB+qR3vuiVEvIwZ4139nW0akolqwHEZSb
	LIg0ePGpnj/m8kd+o7KYW6Hq9+RF3rA6z70XtMMB5kttGfJ8WZ4oUgORQ8ykuOgi
	9kg/7NkjPKDlxg/GkgTEez4LyULXxoYDQmJBi/vZXJqmQ5fMGiTtNZetX9yk/TBI
	YQgZDIao0csaMUdMM7fgeO6+penKHwUMrpaF/YZwJ0ReUzZFFyvDQOAn7LMq5Avp
	FiNLAQ/+mnFXy2Ht2KHNUeJeA9SSQFbCNTBScDFBfEDUfl3BPtT2gyqDcaNUkNy7
	wqXda0VTfmG1vLvLMqTKvPA9BTfbfh0WeKmzgZFd9lmQ5sYQyv7w==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 459tj155ha-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 10 Mar 2025 11:48:32 -0700 (PDT)
Received: from twshared18153.09.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Mon, 10 Mar 2025 18:48:30 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 425F618F06D72; Mon, 10 Mar 2025 11:48:26 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <asml.silence@gmail.com>, <io-uring@vger.kernel.org>
CC: Keith Busch <kbusch@kernel.org>,
        Caleb Sander Mateos
	<csander@purestorage.com>
Subject: [PATCH] Revert "io_uring/rsrc: simplify the bvec iter count calculation"
Date: Mon, 10 Mar 2025 11:48:25 -0700
Message-ID: <20250310184825.569371-1-kbusch@meta.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: C-7lnt3cumMaC3pvP1yYirhr1UcIysCf
X-Proofpoint-ORIG-GUID: C-7lnt3cumMaC3pvP1yYirhr1UcIysCf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-10_07,2025-03-07_03,2024-11-22_01

From: Keith Busch <kbusch@kernel.org>

This reverts commit 2a51c327d4a4a2eb62d67f4ea13a17efd0f25c5c.

The kernel registered bvecs do use the iov_iter_advance() API, so we
can't rely on this simplification anymore.

Fixes: 27cb27b6d5ea40 ("io_uring: add support for kernel registered bvecs=
")
Reported-by: Caleb Sander Mateos <csander@purestorage.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 io_uring/rsrc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 5dd1e08275594..5fff6ba2b7c05 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1024,7 +1024,7 @@ static int io_import_fixed(int ddir, struct iov_ite=
r *iter,
 	 * and advance us to the beginning.
 	 */
 	offset =3D buf_addr - imu->ubuf;
-	iov_iter_bvec(iter, ddir, imu->bvec, imu->nr_bvecs, len);
+	iov_iter_bvec(iter, ddir, imu->bvec, imu->nr_bvecs, offset + len);
=20
 	if (offset) {
 		/*
@@ -1051,6 +1051,7 @@ static int io_import_fixed(int ddir, struct iov_ite=
r *iter,
 		 * to use the slow iter advance.
 		 */
 		if (offset < bvec->bv_len) {
+			iter->count -=3D offset;
 			iter->iov_offset =3D offset;
 		} else if (imu->is_kbuf) {
 			iov_iter_advance(iter, offset);
@@ -1063,6 +1064,7 @@ static int io_import_fixed(int ddir, struct iov_ite=
r *iter,
=20
 			iter->bvec +=3D seg_skip;
 			iter->nr_segs -=3D seg_skip;
+			iter->count -=3D bvec->bv_len + offset;
 			iter->iov_offset =3D offset & ((1UL << imu->folio_shift) - 1);
 		}
 	}
--=20
2.47.1


