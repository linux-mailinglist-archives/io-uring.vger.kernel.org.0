Return-Path: <io-uring+bounces-5282-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 16D189E7BC7
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 23:30:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CE8D018878F5
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 22:30:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C83DB22C6DD;
	Fri,  6 Dec 2024 22:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="EEJpDR2S"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BAA819ABC6
	for <io-uring@vger.kernel.org>; Fri,  6 Dec 2024 22:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733524200; cv=none; b=u5OiamKGIrkCAGUCifhyGJiHpsfyGyHMShmwGF42MzuAX6usUn9wlFONXYokmp2Fvg4PJnTRViCQdRimTI/9fAYUIekXgINGJUGS4AWU0Ri8rRjkTcKPtTaYnN2kSpnQXXYP7e1HQUr++dERPk4xU0Put8yqRrWW/IjKjLdbWzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733524200; c=relaxed/simple;
	bh=eOuO4i4yPLsc2Im8KihmSljRQ8rTc0TOPgnR2AUqOdU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uMQ0oRLxDCdcHla1+njSZr7v5OJ+2DitgfUndU5owHoCjL+eKD4BIAw2tDBwVZV+kf8vdUq0aL/44iAY2yULA1Jt3zqJ77A99gKBjT1lgQZyEGdyQYljqYlOk0rZ/wRv63h26KI1NrTn1/owHiC9Vj14FnfMNKKqU+qfIAS/UQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=EEJpDR2S; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B6Lh83D030247
	for <io-uring@vger.kernel.org>; Fri, 6 Dec 2024 14:29:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=qzN9V22hHNPCY40Lp/Ysqsn5kxkAoYivYUU6jILwvog=; b=EEJpDR2SJIhO
	h3HfDz3yAvaNWeiwepFTxsQ/izLsizdVvQBou3TVBfm7uIltSOmrMVkcbKd03Xr9
	3nRDBjSaFEQinCc32mHA1sXRQgE+5Z9aGPrz3D0Z68yJl9+yq01mDhDeqjhpf8qW
	LKF3WgFxFq6p36aI+5t8uihFCgWFbIZoi8mXlkmJ3wwBlh45Le9dFgr4xJpp5//S
	iULHXwklnd+hweRVgIqvirLkcXkyjMDxocnQ1ufSXXkeMlbVAVQQ0qOb4uFQMN8S
	MQX+DbrFHDECZVLCAaJN9Z/xi8Jj/T11GfrzPy9saPjlOex0VQvPHD+i7M2ouVGu
	tP0EoJN6Cg==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 43c592tbsf-9
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Fri, 06 Dec 2024 14:29:58 -0800 (PST)
Received: from twshared55211.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Fri, 6 Dec 2024 22:29:56 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 0003415B8CB6E; Fri,  6 Dec 2024 14:18:26 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <hch@lst.de>, <linux-block@vger.kernel.org>,
        <linux-nvme@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
        <io-uring@vger.kernel.org>
CC: <sagi@grimberg.me>, <asml.silence@gmail.com>, <anuj20.g@samsung.com>,
        <joshi.k@samsung.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv12 02/12] fs: add a write stream field to the kiocb
Date: Fri, 6 Dec 2024 14:17:51 -0800
Message-ID: <20241206221801.790690-3-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241206221801.790690-1-kbusch@meta.com>
References: <20241206221801.790690-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: ovQoEl9_NtDe9swl-4Vi3I1wlGWEbWMn
X-Proofpoint-ORIG-GUID: ovQoEl9_NtDe9swl-4Vi3I1wlGWEbWMn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

From: Christoph Hellwig <hch@lst.de>

Prepare for io_uring passthrough of write streams. The write stream
field in the kiocb structure fits into an existing 2-byte hole, so its
size is not changed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 include/linux/fs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2cc3d45da7b01..26940c451f319 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -373,6 +373,7 @@ struct kiocb {
 	void			*private;
 	int			ki_flags;
 	u16			ki_ioprio; /* See linux/ioprio.h */
+	u8			ki_write_stream;
 	union {
 		/*
 		 * Only used for async buffered reads, where it denotes the
--=20
2.43.5


