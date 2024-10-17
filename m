Return-Path: <io-uring+bounces-3790-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B03639A2814
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 18:10:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 65CA61F213EA
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 16:10:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EB501DF256;
	Thu, 17 Oct 2024 16:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="c31A6XtI"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FA11DBB13
	for <io-uring@vger.kernel.org>; Thu, 17 Oct 2024 16:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729181424; cv=none; b=XpcPMw4fPEBJ6s7P/G2vyHj/tVnwckWSMsfCn3os5yGniuoMvu2bSVemSKU60UMa4u9WQtS/oOTihmHZCJkUsH2mv2pFt/hF5o2SH8EoCst3iPiJ1uSa+Rss+tqj5PMZ3qPbV+LBkxO8RT/0Tk0N6aWs1EGyKcBYgYIZHwQiIA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729181424; c=relaxed/simple;
	bh=C/WBRiycOZQcPwrC1sW8w8AXc0VnrI4DNeQOyGBCoeE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iuSjELf0P0uacW+oitrLvYxTkOoy3wosvnMOESN101x8Ahvp/p3DdvxRmDYOTO4cC6gbO6Rz0fd+lgEwIWyRInwCuiw0u8KkBou+YIeS0Z0xb6TK2E8pt4IYVe4GfQqKYQa7nYHFlEBtmlyIlsb2CzSfD7GtqqLG9aA/t+FEvJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=c31A6XtI; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49HCh1EN006877
	for <io-uring@vger.kernel.org>; Thu, 17 Oct 2024 09:10:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=F8aJRbYmwU4rV7+ts4Kj/9zivoR8gg/b0xX0kqcFNzw=; b=c31A6XtIm9Ci
	gcYKQ3yho/Rzn03fosS0zovJ8pJxkiDkTSxJ159qOZNIwJxcwVflTWKo9WDoAC66
	4x1hvBwCv0zqpUOLVYfMIVOhFzhbbi2aaAlPXRIZ5mLfqrjGooGC3BATWk07ACgF
	ISkgHrk0D9MzomGroaLmlrROTq1Kud2GwcAQNVgT4tSLjY3rAUzN74yqTNAGL7Nt
	Nu5aaGNgCVhnoUZjbClcnQ+vfc/OHNWN3j0a3NKrUkPCj0DVq3Ohvl7n5HnU5Hm0
	N/pDuGDEvvpQ5S+1z3MpjIKULRoFcErSyOhneyx/PoJIEOqE+HtgYBy5X8Mq+fHA
	Vy02XrAjUQ==
Received: from maileast.thefacebook.com ([163.114.130.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 42ar0mn3pw-6
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Thu, 17 Oct 2024 09:10:22 -0700 (PDT)
Received: from twshared16035.07.ash9.facebook.com (2620:10d:c0a8:1c::1b) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Thu, 17 Oct 2024 16:10:17 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 2D3EF143A4AB4; Thu, 17 Oct 2024 09:10:01 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <axboe@kernel.dk>, <hch@lst.de>, <io-uring@vger.kernel.org>
CC: <linux-fsdevel@vger.kernel.org>, <joshi.k@samsung.com>,
        <javier.gonz@samsung.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv8 2/6] block: use generic u16 for write hints
Date: Thu, 17 Oct 2024 09:09:33 -0700
Message-ID: <20241017160937.2283225-3-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241017160937.2283225-1-kbusch@meta.com>
References: <20241017160937.2283225-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: HHyzj1eQxHxLSOYNOLfM5vwVZoHEnWT2
X-Proofpoint-GUID: HHyzj1eQxHxLSOYNOLfM5vwVZoHEnWT2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_02,2024-10-04_01,2024-09-30_01

From: Keith Busch <kbusch@kernel.org>

This is still backwards compatible with lifetime hints. It just doesn't
constrain the hints to that definition.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 include/linux/blk-mq.h    | 3 +--
 include/linux/blk_types.h | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 59e9adf815a49..bf007a4081d9b 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -8,7 +8,6 @@
 #include <linux/scatterlist.h>
 #include <linux/prefetch.h>
 #include <linux/srcu.h>
-#include <linux/rw_hint.h>
=20
 struct blk_mq_tags;
 struct blk_flush_queue;
@@ -156,7 +155,7 @@ struct request {
 	struct blk_crypto_keyslot *crypt_keyslot;
 #endif
=20
-	enum rw_hint write_hint;
+	unsigned short write_hint;
 	unsigned short ioprio;
=20
 	enum mq_rq_state state;
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index dce7615c35e7e..56b7fb961e0c7 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -219,7 +219,7 @@ struct bio {
 						 */
 	unsigned short		bi_flags;	/* BIO_* below */
 	unsigned short		bi_ioprio;
-	enum rw_hint		bi_write_hint;
+	unsigned short		bi_write_hint;
 	blk_status_t		bi_status;
 	atomic_t		__bi_remaining;
=20
--=20
2.43.5


