Return-Path: <io-uring+bounces-6216-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E040AA25F16
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2025 16:45:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 828F13A1023
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2025 15:45:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22715205E12;
	Mon,  3 Feb 2025 15:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="iU5MAg3V"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7B61FFC5B
	for <io-uring@vger.kernel.org>; Mon,  3 Feb 2025 15:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738597532; cv=none; b=i4XmhNYWYiWH5DaFrKa+4LjwL4FmBjQGzhCCm/+NTbRbQDDHA1XmPvfYsnshiuxOONp5RZyFKcjBaOaX/vxdQxYQgTH9Q03jpRi+YvUjuz+g8GpBZZxELPkoQvH1mgBDZwCqzPtgx/alYwztJR403fsFslrAvp3I7CxV38fEvHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738597532; c=relaxed/simple;
	bh=ZVpnQeZDvmWq8PWdrxYLmBji7nWmv/s8k945A+PflJc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DeROrZMY9/7cjb4TleVbn6/wvXhpuxKDnsiU2nCS7xRE3qBj3saTLYq672o2CGSyS6DD8ru8kY01uf9RHNQeWLILEGd2ctCpbkjvXPngL3/ui6LpkSffW9VaOy69CiU1uNjYjJk0ERCEr8Txeb2NUz5Ac1TDk0rkLB/3iaoBc5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=iU5MAg3V; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 513FjCvn004352
	for <io-uring@vger.kernel.org>; Mon, 3 Feb 2025 07:45:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=3LzCimmsEH510F0QP2lhVvZdh6+zWH5CEv8c030524E=; b=iU5MAg3V5dBo
	gyxfUPoujVpdZrBQrSEROiQv5214TszNiL2dO62gVFQFkBTtxVvIXPjvmYWz/3Je
	+QpTFrphOzZeolxvLChMX9Ug8A6JDGvI86LRtASaDkVByNT0VyP0u5auQMcyLjSu
	CxdCVvEMjETIvQvRqU5OmooQ68duiPXDJiLTEG6P12NGA6IGcsokCuPfLG/sSQ6X
	AsEyR8Rx0ywt3DX/4y60F+kZBXZyF863Q3FsiFUQzicK0suO5LBnjRHABkCK2R1i
	eVZVczLtUZXPx3Dja8raY0W/vymVjOUSJHC1K3DSwWNn+s712+GwVb9hS8lIC2hV
	q6dPJrXfRQ==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 44k0q6r041-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 03 Feb 2025 07:45:29 -0800 (PST)
Received: from twshared55211.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Mon, 3 Feb 2025 15:45:27 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 67695179A9844; Mon,  3 Feb 2025 07:45:21 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <io-uring@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <ming.lei@redhat.com>, <axboe@kernel.dk>, <asml.silence@gmail.com>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCH 1/6] block: const blk_rq_nr_phys_segments request
Date: Mon, 3 Feb 2025 07:45:12 -0800
Message-ID: <20250203154517.937623-2-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250203154517.937623-1-kbusch@meta.com>
References: <20250203154517.937623-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: M005xvZIguV9UIiogZugaBIYg7Spu1e2
X-Proofpoint-GUID: M005xvZIguV9UIiogZugaBIYg7Spu1e2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-03_06,2025-01-31_02,2024-11-22_01

From: Keith Busch <kbusch@kernel.org>

The request is not modified. Mark it as const so that other const
functions may use this helper.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 include/linux/blk-mq.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index a0a9007cc1e36..56ef03bc68884 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -1125,7 +1125,7 @@ void blk_abort_request(struct request *);
  * own special payload.  In that case we still return 1 here so that thi=
s
  * special payload will be mapped.
  */
-static inline unsigned short blk_rq_nr_phys_segments(struct request *rq)
+static inline unsigned short blk_rq_nr_phys_segments(const struct reques=
t *rq)
 {
 	if (rq->rq_flags & RQF_SPECIAL_PAYLOAD)
 		return 1;
--=20
2.43.5


