Return-Path: <io-uring+bounces-2466-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0414D92B3D6
	for <lists+io-uring@lfdr.de>; Tue,  9 Jul 2024 11:30:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ABC561F23530
	for <lists+io-uring@lfdr.de>; Tue,  9 Jul 2024 09:30:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B2AF14E2C5;
	Tue,  9 Jul 2024 09:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="prXWFgTQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E50F15572C
	for <io-uring@vger.kernel.org>; Tue,  9 Jul 2024 09:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720517411; cv=none; b=lJkHuIhYneRF4WcIo8E1zcuMzMfccrLXvlHvu5FDAcs+VoDuBfleysiUynRDGLkxL0glJlHbrY29bht051fZ4DJkyFFPoejHNw8OHw8/8iAFZ0bKkZdRNY6PEvCQ1YGdeLgSlKdZnfmavmB5WwHAr1SzwAMFD5fI/4xzEJet7ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720517411; c=relaxed/simple;
	bh=vbDucMH9H69eD0NpQhQw+vNIyIVKugJLEy5UHPh7Zy4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=rKcbS8SWaZcvrwJqvKfwB4y3BHqatxfjqtAPdIx40KnGduWs3aAHF2VIsuKx7joR29uuFweBWJemNoGRsmQmi14HiI2vv5NipHwHdaSOtif3jTQSaojfAiZ7EQjZ62NgqQsKcChublGxx85rzCj9Fn0b05dOo6+HmcSPm0uYk5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=prXWFgTQ; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240709093006epoutp01eb124ba08f81f94a6c2a0cfd37514767~ggXc6iH9b2608426084epoutp01e
	for <io-uring@vger.kernel.org>; Tue,  9 Jul 2024 09:30:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240709093006epoutp01eb124ba08f81f94a6c2a0cfd37514767~ggXc6iH9b2608426084epoutp01e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1720517406;
	bh=vbDucMH9H69eD0NpQhQw+vNIyIVKugJLEy5UHPh7Zy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=prXWFgTQY9snb2B7EfS8iAEZE9QgeHQkxFzHU0XjZCHCyBoWBjMXmk5EzguG0YVRr
	 q2WG0cSBRxdX3GLUX9NdrY8JHiyQuLTYezBrNV10Egoq2BtE5k4aF2+e7kvPrqIjRB
	 j5eMzhmpRsQuyRLN7YnYbi4KeGW7M5hpPn2HtsMs=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240709093006epcas5p21271638f0d32bfdecb0e8df874afd4b9~ggXcpYfAT0471504715epcas5p2V;
	Tue,  9 Jul 2024 09:30:06 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4WJG192bjnz4x9Pq; Tue,  9 Jul
	2024 09:30:05 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	4C.10.07307.D130D866; Tue,  9 Jul 2024 18:30:05 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240709092454epcas5p4b4ffaa306b3ce12ec57ce4eb19e08572~ggS50YONn2428324283epcas5p4O;
	Tue,  9 Jul 2024 09:24:54 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240709092454epsmtrp25ebd14e215e4e7c00bc37c9dd7f00435~ggS5zdRKN1284412844epsmtrp2M;
	Tue,  9 Jul 2024 09:24:54 +0000 (GMT)
X-AuditID: b6c32a44-18dff70000011c8b-f0-668d031dd0e1
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	D7.F9.18846.6E10D866; Tue,  9 Jul 2024 18:24:54 +0900 (KST)
Received: from testpc11818.samsungds.net (unknown [109.105.118.18]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240709092453epsmtip2669b99b14c4e27fb0e1dc6d17e1ed81f~ggS5F7KBJ2283622836epsmtip2b;
	Tue,  9 Jul 2024 09:24:53 +0000 (GMT)
From: hexue <xue01.he@samsung.com>
To: xue01.he@samsung.com
Cc: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: io_uring: releasing CPU resources when polling
Date: Tue,  9 Jul 2024 17:24:48 +0800
Message-Id: <20240709092448.3205817-1-xue01.he@samsung.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240709081619.3177418-1-xue01.he@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDKsWRmVeSWpSXmKPExsWy7bCmhq4sc2+awceNQhZzVm1jtFh9t5/N
	4l3rORaLy7vmsFl0XTjF5sDqsXPWXXaPy2dLPfq2rGL0+LxJLoAlKtsmIzUxJbVIITUvOT8l
	My/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2itkkJZYk4pUCggsbhYSd/Opii/
	tCRVISO/uMRWKbUgJafApECvODG3uDQvXS8vtcTK0MDAyBSoMCE741d/D2NBdsXM3f4NjCFd
	jJwcEgImElcmdTN2MXJxCAnsZpSYv+wbO4TziVGi4UYLI5yzZ8JSJpiWd/3Loap2Mkr8OXOd
	CcL5wSjxoXEXWBWbgJLE/i0fGEFsEQEJiXXnV7GA2MwCqRI/700HiwsLWEv0rT0KZHNwsAio
	Snw9ZwQS5gUKzzzTxgqxTF7iZtd+ZhCbU8BGYl77EkaIGkGJkzOfQI2Ul2jeOpsZ5AYJgX3s
	Eme/bGABmSkh4CLxYqsKxBxhiVfHt7BD2FISn9/tZYOw8yUmf1/PCGHXSKzb/I4FwraW+Hdl
	D9gYZgFNifW79CHCshJTT61jgljLJ9H7+wk0THgldsyDsZUklhxZATVSQuL3hEVQr3hI9G3a
	xAYJqn5GiVMHV7FOYFSYheSdWUjemYWwegEj8ypGydSC4tz01GTTAsO81HJ4DCfn525iBCdD
	LZcdjDfm/9M7xMjEwXiIUYKDWUmEd/6N7jQh3pTEyqrUovz4otKc1OJDjKbA4J7ILCWanA9M
	x3kl8YYmlgYmZmZmJpbGZoZK4ryvW+emCAmkJ5akZqemFqQWwfQxcXBKNTAdzl518kHT3K9L
	ffhDNqYdflN3dn8cV8bVvj+fSvrSUjY+uTfJ/0XMn0Ptq60F3wqd2mEUefiE6ezre4pnbUvT
	zVt+bCHnNgFlwcLX7r6/nyVZpJub/o56tln9h9LyUuk/865cfPPS+KpKuXb31Y5rllfXvBVu
	bv/JJxL0UHXivmuSvSlfPv47sk/s+9fnfg3nbn4+cvG9YV1f+sTz6SsP7W6KzI9VrTza5ep6
	jiPe3sAtNju43jAjcHu/oaObZ2zOh8OPlR3fSzrZflZRXjFpcfa5Eyfv37RKEJK4uWGetuYX
	wYX1/cv/BCRKReaWxG1kEHseeZdFk33vwc170r4U/17md8Kv3WD7/M76F7e1lFiKMxINtZiL
	ihMBy2dTiA8EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsWy7bCSvO4zxt40g+0X2SzmrNrGaLH6bj+b
	xbvWcywWl3fNYbPounCKzYHVY+esu+wel8+WevRtWcXo8XmTXABLFJdNSmpOZllqkb5dAlfG
	r/4exoLsipm7/RsYQ7oYOTkkBEwk3vUvZ+9i5OIQEtjOKDF3yzlGiISExI5Hf1ghbGGJlf+e
	QxV9Y5TYfnk+WBGbgJLE/i0fwGwRoIZ151exgNjMApkSuybcZAaxhQWsJfrWHgWq4eBgEVCV
	+HrOCCTMCxSeeaYNar68xM2u/WDlnAI2EvPal4CNFAKqWbp5JRNEvaDEyZlPoMbLSzRvnc08
	gVFgFpLULCSpBYxMqxhFUwuKc9NzkwsM9YoTc4tL89L1kvNzNzGCw1QraAfjsvV/9Q4xMnEw
	HmKU4GBWEuGdf6M7TYg3JbGyKrUoP76oNCe1+BCjNAeLkjivck5nipBAemJJanZqakFqEUyW
	iYNTqoHJZUn2hLBtL24ckrxW6HvYX7aw4Vw6X/37JydVJr6XcWkS8z+0plfi8OqJasGTlrEk
	mJ86br4k7NZ5ow0vnv88F+18YXu8e+/OyVytdcf4e89evla1bgfPaXZTwTtH7j9+yP3x2GvP
	BbNNLOLS7vnYKXeq/Azes+6bRZg6c3DP8kk2G1IP6Vh+tL1/91bnjZ21ryT79rtuy21jNuuJ
	3Wx0ytNF+47grfTPoYdTX/FofJQ0trFgqz5p3Rr3mnHRx/0v1pxy3t8X8eCcWoOC/c5Zob0c
	zhFVLdMKSyXXl9Yo96U+j8/e+JZd8t+sq2/rK686rP0UYzdR88GHHP1UhtMvn5ko5eQaH5yz
	nTfvwwkuJZbijERDLeai4kQAufGf0sICAAA=
X-CMS-MailID: 20240709092454epcas5p4b4ffaa306b3ce12ec57ce4eb19e08572
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240709092454epcas5p4b4ffaa306b3ce12ec57ce4eb19e08572
References: <20240709081619.3177418-1-xue01.he@samsung.com>
	<CGME20240709092454epcas5p4b4ffaa306b3ce12ec57ce4eb19e08572@epcas5p4.samsung.com>

Sorry, please ignore this patch, I will resend one later, I'm
sorry for improper operation.

--
hexue

