Return-Path: <io-uring+bounces-5032-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF1B99D7C79
	for <lists+io-uring@lfdr.de>; Mon, 25 Nov 2024 09:08:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78762282365
	for <lists+io-uring@lfdr.de>; Mon, 25 Nov 2024 08:08:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77C1518859A;
	Mon, 25 Nov 2024 08:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="smbc0ws0"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1408149E00
	for <io-uring@vger.kernel.org>; Mon, 25 Nov 2024 08:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732522092; cv=none; b=IEuZZhYdlNki43v08sIPVYix73ZLFSFeo3A3mBKJeBKMRrXfGBy0E0iETQErNlki4AyvcSI3DSlVdSjMg8zssriGaZf8ZZufj78wiT0z35JnwOMTO/n5ATRL6Wchae3dK+r0fFWOss5W/xktt0PkMPMV6Ch2xvwPpXHjl2SU5+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732522092; c=relaxed/simple;
	bh=mlLpOADJdimbzMrJqxVCIky165ZgGg3a+54zC1LiT88=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=qBx9u65KSGHfPaJlYVaGBNN1jk6R0sKhP8nr/tz9zAvT8Aw8XYHeeHk0u6bHHmhw+ozcQmfahi5xXGJYFckpIJ2xEcUNLnsH6hBtOy7NX455ejeWknFUQqAMpRLgtpCcsjnwjJygR8GvLzHYwTWXJLLluOkzeZZM4LYtlrC6ijA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=smbc0ws0; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241125080809epoutp01aabc6ef1e1ce83d4d38f28d05fcf8eba~LJ6kmJI310923509235epoutp01b
	for <io-uring@vger.kernel.org>; Mon, 25 Nov 2024 08:08:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241125080809epoutp01aabc6ef1e1ce83d4d38f28d05fcf8eba~LJ6kmJI310923509235epoutp01b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1732522089;
	bh=cRuOygxyfLjl7ybgQ+EVk9IvCIBAqSeYwRZ/zr1tr/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=smbc0ws0smxYmZG/CN7HVxuM6t7MWsPu1ZeXvsgB5MNj6A6nhjUaXoeri2hI37nUS
	 1K2G9kfk2mdlt0AXni41gERpc/n78v0lnyxA7ZVLJUgRLj5THnSX9S3VxSMc9XLoJc
	 SS+cb8YaMXeKtnh0KebK3fydemKw5FmW/SsTSaNA=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20241125080808epcas5p2b7dd75e2725ca299b9ea22c81ac446c2~LJ6jzKWdX0648106481epcas5p28;
	Mon, 25 Nov 2024 08:08:08 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.180]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4XxdcQ1smBz4x9QB; Mon, 25 Nov
	2024 08:08:06 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	B2.ED.19956.36034476; Mon, 25 Nov 2024 17:08:03 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20241125071459epcas5p3f603d511a03c790476cce37505e61a0b~LJMKR1yvq1112911129epcas5p34;
	Mon, 25 Nov 2024 07:14:59 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241125071459epsmtrp1ed6807f767e39f81d65beacab6a7ddc4~LJMKPu7VC0302403024epsmtrp1z;
	Mon, 25 Nov 2024 07:14:59 +0000 (GMT)
X-AuditID: b6c32a4b-fd1f170000004df4-30-674430635e64
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	83.45.19220.3F324476; Mon, 25 Nov 2024 16:14:59 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241125071457epsmtip1090cf8f1a1638fb76db36ee392448f28~LJMH4TYPm0365203652epsmtip1U;
	Mon, 25 Nov 2024 07:14:57 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, asml.silence@gmail.com, anuj1072538@gmail.com,
	brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH v10 05/10] fs: introduce IOCB_HAS_METADATA for metadata
Date: Mon, 25 Nov 2024 12:36:28 +0530
Message-Id: <20241125070633.8042-6-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241125070633.8042-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xTVxzHd+697S2wwpWHHFGh3rgZNEA7KFwMOA1s3sgwJCZmY4nspj1p
	SZ/2Mba5YAcDIj5AFzYEBFEEKRkLVRCRKqswxApsQ3yQkeiEuU4QqBtuMehaWjf/+/we3/N7
	nHMEeOgdfpQgX2tCBi2npvmBRNfV2A1xMnGmQtww8Dqz8NczgimqXMKZOmsXYNomK/jMo6tu
	wNztu4gxrW0DGPO4ZIRgar8pxphjjluAsU9sYnrtQwTT0DxNMgdvd/OZlsHnGDO6NMhjRmvq
	yK0r2Is1kyQ7NmxmbdYDfPZc03720l0Ln12YniDYI+etgL1xsp9kn9iiWdvULJYTmKtKUyJO
	jgwipJXp5PlaRTqdtSsvI0+aLJbESVKZFFqk5TQonc58Lyfu3Xy1Zxxa9DGnNntcOZzRSCds
	STPozCYkUuqMpnQa6eVqfZI+3shpjGatIl6LTJslYvFbUk/iRyqle7CFp7/J+2TI+g9uAbeI
	ciAQQCoJzrXFl4NAQSh1CcCW8S/5PsMN4PeuccxnLAJ42z3kiQQsK+6VXvMH7ADOdFkJbyCU
	egKgy7LWy3xqA+x/WAK8SeFUL4CHG52E18ApF4BnrKeWFWHUdmgvv8L3NkJQb8DBU5u9biHF
	wP6z07ivWgw8/vNT0ssBVCqcLe0jfDkr4NDxqWXGPTnFnbW493xI/SiATY4yvzgTln7RxfNx
	GPxj8Dzp4yjoqij1swL+PTaN+VgPi3+4DHz8Niy5XoF7e8OpWPhdT4LPvRZWXW/HfHWD4eFn
	U36pEHbXv2QalrXW+RlC+4jFzyyculzu3+8hABtnq4hKIKp5ZZ6aV+ap+b/0SYBbwSqkN2oU
	yCjVJ2pRwX+3LNNpbGD5iW/M6ga/3puPdwBMABwACnA6XBgcmaEIFcq5Tz9DBl2ewaxGRgeQ
	evZ9FI+KkOk8f0RrypMkpYqTkpOTk1ITkyV0pPBRyQl5KKXgTEiFkB4ZXuowQUCUBePuN5uI
	6m+PZC/ucbpXtzV3kLb5BPP2fZw+3yItjODqn9eukoQ412u2tquuzO12ji2MaG5sCiNbU4oi
	P+RGJlH2Pt6Fjgc7hiN62vtmG0PIjAcTMbLUlNHes3tOu3bHTQSG7Fgf/nC+47WAtL1f//nO
	yt76Hmnh2E7zaUdWQq0LbFtyskond1BkLTz6Vct+00iVqXh1XVETGVtduwbZS9bERi++//uL
	6Moudwo610nufbM65encbz/9cl99Iij3zueHCgI6c2bKIFppurAUY/uA2zUeFzRPLCbw9cPr
	CmYaHgepLC3bFBUdwnVl0QMUoboWnLtF+2I2MjH9ZvCBbIwmjEpOshE3GLl/AYVka55rBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42LZdlhJTvezsku6weq3KhYfv/5msWia8JfZ
	Ys6qbYwWq+/2s1m8PvyJ0eLmgZ1MFitXH2WyeNd6jsVi9vRmJotJh64xWuy9pW2xZ+9JFov5
	y56yW3Rf38Fmsfz4PyaL83+Ps1qcnzWH3UHQY+esu+wel8+Wemxa1cnmsXlJvcfumw1sHh+f
	3mLx6NuyitHjzIIj7B6fN8l5bHrylimAK4rLJiU1J7MstUjfLoEr49Px5awFV1grTq76ydzA
	eI2li5GTQ0LAROJB2wmmLkYuDiGB3YwSM28fh0pISJx6uYwRwhaWWPnvOTtE0UdGie17JrKC
	JNgE1CWOPG8FKxIROMEoMX+iG0gRM0jRhC+zwSYJC7hL7O3az9bFyMHBIqAqcXyRFUiYV8BC
	4siKp8wQC+QlZl76zg5icwpYSrxtOwDWKgRUM6tzJStEvaDEyZlPwOLMQPXNW2czT2AUmIUk
	NQtJagEj0ypGydSC4tz03GLDAqO81HK94sTc4tK8dL3k/NxNjOA409Lawbhn1Qe9Q4xMHIyH
	GCU4mJVEePnEndOFeFMSK6tSi/Lji0pzUosPMUpzsCiJ83573ZsiJJCeWJKanZpakFoEk2Xi
	4JRqYLK44/y6f1+ZkHfC1nUW5aWafll1Zz9Z3LPZYclX+4H5zbsXSux3U46YruS02rHVNKBB
	y9E9wHf/k9o/q477MXdP+yi9NXNKeR5j6AwbtZ/f3l+wOrhe7o5r+Yp+puiT5qf4M1aWVqyM
	+K44O3l2idUjixBjo5uXnO846zioV4eunBA2o+nrgXvrEvckRtczb91bGcX/vFBjZd1dq65a
	5iNu/CqOZq3H90Wpf/wur3dnZsf0sit8VsvrP9a/3fZORSQobmHg/7MJ6ncSzS4+m7/DN/ht
	wL5DDiLrL7lOqagUajQMaTWOF5u+vfLV5X0xSxlWyvpnxeZZSCkvPtK9jlfn33exbjGXyqMb
	BQL4lFiKMxINtZiLihMB9+Bh4yIDAAA=
X-CMS-MailID: 20241125071459epcas5p3f603d511a03c790476cce37505e61a0b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241125071459epcas5p3f603d511a03c790476cce37505e61a0b
References: <20241125070633.8042-1-anuj20.g@samsung.com>
	<CGME20241125071459epcas5p3f603d511a03c790476cce37505e61a0b@epcas5p3.samsung.com>

Introduce an IOCB_HAS_METADATA flag for the kiocb struct, for handling
requests containing meta payload.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/fs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7e29433c5ecc..2cc3d45da7b0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -348,6 +348,7 @@ struct readahead_control;
 #define IOCB_DIO_CALLER_COMP	(1 << 22)
 /* kiocb is a read or write operation submitted by fs/aio.c. */
 #define IOCB_AIO_RW		(1 << 23)
+#define IOCB_HAS_METADATA	(1 << 24)
 
 /* for use in trace events */
 #define TRACE_IOCB_STRINGS \
-- 
2.25.1


