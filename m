Return-Path: <io-uring+bounces-5431-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BE5A69EC6A2
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 09:10:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B1552830AA
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 08:10:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02C831C5F03;
	Wed, 11 Dec 2024 08:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="EjxWY3XI"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6BD41D61A5
	for <io-uring@vger.kernel.org>; Wed, 11 Dec 2024 08:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733904638; cv=none; b=RL0E474dRyNyTKeaVOU0aA8RRqzNANa7HpLjDN82/GPLuDrVH33HaNSf1y1idP1046/zoY0XOPUTFAFJFjIv1DrGkOo7fbeSyWxTBKlwk3CXNNljsTa4CcAzLCRpNW6TxAoFVcKAJeBhsJetbfIXM7EuhpPCGdvZMeHf1HrgUa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733904638; c=relaxed/simple;
	bh=7hZvt3UaEzFme6v6X/TtoD4MO25W1cQYB8Sv/TFxD+A=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=CsgL+Hde000aXSMxmw3LGDJ3YonkN+RGDyXX+NNHPYVM5/Rtt1AJJ4AA25Z0dWYHfNGfyFJqnwUE4v1Ccr6bvr2HNbE6rPi3f72aWEvlqD7GqkGE7c74QupznBgzeXniqNOvrARgxycM+nkp3+DOt1ZF74NfyXeEumBXC6VVQ5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=EjxWY3XI; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20241211081031epoutp026a5ba0e90c6d069599e384ae742b2e40~QERNtFGeQ0925209252epoutp02P
	for <io-uring@vger.kernel.org>; Wed, 11 Dec 2024 08:10:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20241211081031epoutp026a5ba0e90c6d069599e384ae742b2e40~QERNtFGeQ0925209252epoutp02P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1733904631;
	bh=muEp29avMHP9Dfsx3yAgp2KHd89DMK17sHRSPGbmxUM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=EjxWY3XItegMM2or3nJIbZN6/D9TmxOj6NB1WHt7nkMdGqBURV5hlqZ4gsDBmb5A8
	 xU12CFjuVKTTf+aIvPPyifFhNCXwTSBh/vwT2XJvjYCjFrNK3qfio86VxMKA96HFbB
	 UaXprCWD+1M+nXtbg6QSsSiS+Vihz1iBLRmDVdRQ=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20241211081031epcas5p3f961c90a3a9ee92b09d418cfa7b1ddbd~QERNP_6dj1823818238epcas5p35;
	Wed, 11 Dec 2024 08:10:31 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.178]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Y7Svn2mH7z4x9Pq; Wed, 11 Dec
	2024 08:10:29 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	99.0B.19710.5F849576; Wed, 11 Dec 2024 17:10:29 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20241211064906epcas5p3828a664815dd92ac462aa22c3e64d469~QDKIUT2YH3167431674epcas5p3L;
	Wed, 11 Dec 2024 06:49:06 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241211064906epsmtrp21a72278a6cbc165e8d24f6eee0539b6a~QDKITZ-CA0834008340epsmtrp2j;
	Wed, 11 Dec 2024 06:49:06 +0000 (GMT)
X-AuditID: b6c32a44-36bdd70000004cfe-37-675948f55814
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	A8.74.18729.2E539576; Wed, 11 Dec 2024 15:49:06 +0900 (KST)
Received: from ubuntu (unknown [107.99.41.245]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20241211064904epsmtip2e061df1a4f20639f72ba1c92a3f34579~QDKGeWa8x0125501255epsmtip21;
	Wed, 11 Dec 2024 06:49:04 +0000 (GMT)
Date: Wed, 11 Dec 2024 12:11:11 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Keith Busch <kbusch@meta.com>
Cc: axboe@kernel.dk, hch@lst.de, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, sagi@grimberg.me, asml.silence@gmail.com,
	anuj20.g@samsung.com, joshi.k@samsung.com, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv13 10/11] nvme: register fdp parameters with the block
 layer
Message-ID: <20241211064111.zo7nxoqczftixedt@ubuntu>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241210194722.1905732-11-kbusch@meta.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOJsWRmVeSWpSXmKPExsWy7bCmhu5Xj8h0g9ffhSyaJvxltpizahuj
	xeq7/WwWK1cfZbJ413qOxeLo/7dsFpMOXWO0OHN1IYvF3lvaFnv2nmSxmL/sKbvFutfvWRx4
	PHbOusvucf7eRhaPy2dLPTat6mTz2Lyk3mP3zQY2j3MXKzz6tqxi9Pi8SS6AMyrbJiM1MSW1
	SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoXiWFssScUqBQQGJx
	sZK+nU1RfmlJqkJGfnGJrVJqQUpOgUmBXnFibnFpXrpeXmqJlaGBgZEpUGFCdkbTnNdMBTe4
	Kv5cW8XewLiKs4uRk0NCwETiwYNzjF2MXBxCArsZJT7eWskG4XxilLh69QsTSJWQwDdGienL
	/WA6Dhw/zwxRtJdRor1xBlTHE0aJxh/n2UCqWARUJVZOmQA0l4ODTUBb4vR/DpCwiICixHlg
	SIDUMwtMZJL4faiJHaRGWCBIYsq1OJAaXqAFF7ecYIKwBSVOznzCAmJzClhILD+4lBWkV0Jg
	LYfEvNm72EB6JQRcJB6tSYI4Tlji1fEt7BC2lMTnd3vZIOxyoHNWsEH0tjBKzLo+ixEiYS/R
	eqqfGcRmFsiQ6F51hRUiLisx9dQ6Jog4n0Tv7ydMEHFeiR3zYGxliTXrF0AtkJS49r0R6h4P
	iT/NEZAw2cEoceTIZvYJjHKzkPwzC8k6CNtKovNDE5DNAWRLSyz/xwFhakqs36W/gJF1FaNk
	akFxbnpqsmmBYV5qOTyOk/NzNzGCU7CWyw7GG/P/6R1iZOJgPMQowcGsJMJ7wz4yXYg3JbGy
	KrUoP76oNCe1+BCjKTB6JjJLiSbnA7NAXkm8oYmlgYmZmZmJpbGZoZI47+vWuSlCAumJJanZ
	qakFqUUwfUwcnFINTAaipd86NupMSv7EGNK97uWlG5dPfnmvee6EmsLPtXuXdXVsu+Zbei7y
	X7Rl9CXtO+zpkncVJvtNuPhBmNNRJ173yVXbSfWPGF6/XlPwueTKPB2x379Kdiz6s/aG3E2L
	W2pPb2xsnHhs19cjygIPXRe3TTd+zSyv+iBMUEeYr3PNxsU1PiKvFK/wVJ+5m2v92ffM7sOz
	FQW/3U07tfD0/caTn2Rqt3i9W3tC+z3z2mOJ4qIrPRs3X9jebDn5vE2p7Eu1pfs4i6Q+98/a
	r7b/21/WAwKHet68eVvPN4tX6nvrgkWbph1S93k0o56n9bPCGdWiY6H9zQKi4Q9OLfogcODS
	N8f7Ji2G+Vc3NctmB0hUKbEUZyQaajEXFScCANDJx4JKBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsWy7bCSvO4j08h0g+52bYumCX+ZLeas2sZo
	sfpuP5vFytVHmSzetZ5jsTj6/y2bxaRD1xgtzlxdyGKx95a2xZ69J1ks5i97ym6x7vV7Fgce
	j52z7rJ7nL+3kcXj8tlSj02rOtk8Ni+p99h9s4HN49zFCo++LasYPT5vkgvgjOKySUnNySxL
	LdK3S+DKeNxymbWgi6Oi6esHpgbGb2xdjJwcEgImEgeOn2fuYuTiEBLYzShx69FOdoiEpMSy
	v0eYIWxhiZX/noPFhQQeMUrM6UgHsVkEVCVWTpnA2MXIwcEmoC1x+j8HSFhEQFHiPNA1IDOZ
	BSYzSTyfeYwFpEZYIEhiyrU4kBpeoL0Xt5xgghiZIvH09yomiLigxMmZT1hAbGYBM4l5mx8y
	g7QyC0hLLP8HNp5TwEJi+cGlrBMYBWYh6ZiFpGMWQscCRuZVjJKpBcW56bnFhgWGeanlesWJ
	ucWleel6yfm5mxjBkaOluYNx+6oPeocYmTgYDzFKcDArifByeIemC/GmJFZWpRblxxeV5qQW
	H2KU5mBREucVf9GbIiSQnliSmp2aWpBaBJNl4uCUamBiEnTS/TGDe8+Nv/Ot/Wb8CzN4Yjnb
	p/2VwLkkkyeiWwoU06Z13bnwgLdbRWFSa9u+r6uybhpsmL3pgpcpr3OsQPqyp/cPdXmW794U
	tSwhXPyS3i7DTVXyWg+P2CyftTLm/tl0m/m9e+7mWRu2+c1a+3VyKwfn2vOe1TskfJqOcSQL
	TH5jE5JYW/7iF6OTz7OX8Vt7ltxwPLiYU/1NbfniidfsXhc+XtzmK7z4hfanjF+TTPK+5tZy
	VAXH/Go70TxHc3niQtXMUw3vWou0Qi++8civ1eo3KVslZSU165Kp93PRkCsz9xU2TvltZXb8
	zSmjaKk5GRkmJ5V1uXkTl7b3MdSctJRXjPC5fa5U4a8SS3FGoqEWc1FxIgCodVCnCwMAAA==
X-CMS-MailID: 20241211064906epcas5p3828a664815dd92ac462aa22c3e64d469
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----QQbx9Hk6-Xl4D1oMwM2uYkP7uAkYtjoi7zPie6od2LiHNIsi=_765e6_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241211064906epcas5p3828a664815dd92ac462aa22c3e64d469
References: <20241210194722.1905732-1-kbusch@meta.com>
	<20241210194722.1905732-11-kbusch@meta.com>
	<CGME20241211064906epcas5p3828a664815dd92ac462aa22c3e64d469@epcas5p3.samsung.com>

------QQbx9Hk6-Xl4D1oMwM2uYkP7uAkYtjoi7zPie6od2LiHNIsi=_765e6_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 10/12/24 11:47AM, Keith Busch wrote:
>From: Keith Busch <kbusch@kernel.org>
>
>Register the device data placement limits if supported. This is just
>registering the limits with the block layer. Nothing beyond reporting
>these attributes is happening in this patch.
>
>Merges parts from a patch by Christoph Hellwig <hch@lst.de>
>Link: https://lore.kernel.org/linux-nvme/20241119121632.1225556-15-hch@lst.de/
>
>Signed-off-by: Keith Busch <kbusch@kernel.org>
>---
> drivers/nvme/host/core.c | 139 +++++++++++++++++++++++++++++++++++++++
> drivers/nvme/host/nvme.h |   2 +
> 2 files changed, 141 insertions(+)
>
>diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
>index c2a3585a3fa59..f7aeda601fcd6 100644
>--- a/drivers/nvme/host/core.c
>+++ b/drivers/nvme/host/core.c
>+	/*
>+	 * The FDP configuration is static for the lifetime of the namespace,
>+	 * so return immediately if we've already registered this namespaces's
Nit: namespace's

Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>

------QQbx9Hk6-Xl4D1oMwM2uYkP7uAkYtjoi7zPie6od2LiHNIsi=_765e6_
Content-Type: text/plain; charset="utf-8"


------QQbx9Hk6-Xl4D1oMwM2uYkP7uAkYtjoi7zPie6od2LiHNIsi=_765e6_--

