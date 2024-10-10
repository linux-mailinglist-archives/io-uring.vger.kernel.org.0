Return-Path: <io-uring+bounces-3552-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4908B9982C7
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 11:50:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 033F2281A32
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 09:50:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE6C01BCA07;
	Thu, 10 Oct 2024 09:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ZuMDp5Vg"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8696F1BC9FE
	for <io-uring@vger.kernel.org>; Thu, 10 Oct 2024 09:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728553750; cv=none; b=rDhBXQ9JiLha5PEpN1daQyRYgYcxs2CrHth/kSAYoPyq/xKqYvlGKEmSmx/2ofckVo03hsxw4inh7+VeSE2tI9NR7QP2ITdb6iR7fwT/6otOZsggv09gPF0gW/cY7UMbZ8JkMiOqb78MePGfuCgU+RZ4T/tN2BuukkOIZr36gDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728553750; c=relaxed/simple;
	bh=u8smGMxe7I6SDzmR4h+bIeQ8OGFXW4NhD8nmS056mss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:MIME-Version:
	 Content-Type:References; b=qIbhg50jUeC8cSUJqkoUBehklL+sSTax5H9znL0r8kTIcpAj5PPp1osGmsEYkgeUsazXk2My6rQZV65eYdfI/h82+ivtKeF/IUGZuqeLVQVc9H+gvFu2hPbsUY+Py99F15Dl+oMqI68uxRofuTRLWOb40U0IukMm+h/KIk7C/UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ZuMDp5Vg; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20241010094906epoutp0278a1868b62164c9ce38fb835d21d8c4e~9Dnlbu_Xz0358503585epoutp02n
	for <io-uring@vger.kernel.org>; Thu, 10 Oct 2024 09:49:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20241010094906epoutp0278a1868b62164c9ce38fb835d21d8c4e~9Dnlbu_Xz0358503585epoutp02n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1728553746;
	bh=u8smGMxe7I6SDzmR4h+bIeQ8OGFXW4NhD8nmS056mss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZuMDp5Vguh7ZAJUyMZn1TBS9NVgQN1P78VBGZJp28KXP+gDko6IcIdsVn1xI6Whtp
	 knQIQceS3DzDmVbGor1H1q5f83ml/a1UXYErfjb7zqxriIKpvR2lkL9hgq+UA1Z9A1
	 t+chomn6tvB4NonzGRr7zzVfcugvWf729cNIgX5s=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20241010094905epcas5p1895c82ccf5ded1a6269fd9874d3299f9~9DnktG3KM0390103901epcas5p1i;
	Thu, 10 Oct 2024 09:49:05 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.183]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4XPQ265vmDz4x9Pw; Thu, 10 Oct
	2024 09:49:02 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	3C.06.18935.E03A7076; Thu, 10 Oct 2024 18:49:02 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241010092012epcas5p2bc333a1f880209003523e71d97ba3298~9DOWjE8IC3201132011epcas5p2Q;
	Thu, 10 Oct 2024 09:20:12 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241010092012epsmtrp2036b1ed46d6c1b4bc3ef4bf02bcdb5d9~9DOWhVmon0902409024epsmtrp2i;
	Thu, 10 Oct 2024 09:20:12 +0000 (GMT)
X-AuditID: b6c32a50-a99ff700000049f7-f9-6707a30e3822
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	74.91.08227.C4C97076; Thu, 10 Oct 2024 18:20:12 +0900 (KST)
Received: from dev.. (unknown [109.105.118.18]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20241010092011epsmtip1c884ed7c717d5c99fda30e37a13a14e4~9DOVptx_P0740307403epsmtip1y;
	Thu, 10 Oct 2024 09:20:11 +0000 (GMT)
From: Ruyi Zhang <ruyi.zhang@samsung.com>
To: asml.silence@gmail.com, axboe@kernel.dk
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
	peiwei.li@samsung.com, ruyi.zhang@samsung.com
Subject: RE: Re: [PATCH v2 RESEND] io_uring/fdinfo: add timeout_list to
 fdinfo
Date: Thu, 10 Oct 2024 09:20:03 +0000
Message-ID: <20241010092003.2894-1-ruyi.zhang@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <1f21a22b-e5a7-48bd-a1c8-b9d817b2291a@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmk+LIzCtJLcpLzFFi42LZdlhTQ5dvMXu6watF+hZzVm1jtFh9t5/N
	4l3rORaLX913GS0u75rDZvFsL6fFl8Pf2S3OTvjA6sDhsXPWXXaPy2dLPfq2rGL0+LxJLoAl
	KtsmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+gIJYWy
	xJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUmpBSk6BSYFecWJucWleul5eaomVoYGBkSlQYUJ2
	xr81rAXzOSpOdD1gbWC8xNbFyMkhIWAi8ePDTuYuRi4OIYE9jBKNXR9ZQBJCAp8YJe7e0YRI
	fGOU2HvrHhNMx/1bf9ggEnsZJQ4s/88G0fGEUWLS+lIQm01AU+LyzAZGEFtEQFti7f3tYFOZ
	BbIlDp6fCjSIg0NYIEBi9mw9kDCLgKrEvkm7mEFsXgEriY7+y8wQu+QlFu9YDmZzCthKLL74
	lgmiRlDi5MwnUCPlJZq3zgb7QELgFrvE5b2bWCCaXSSuftwNZQtLvDq+hR3ClpL4/G4vG8gN
	EgLFEg/78iHCDYwS237XQdjWEv+u7GEBKWEGemX9Ln2IsKzE1FPrmCDW8kn0/n4CDRJeiR3z
	YGwVifcr3jHBbFrfuhvK9pC4cu4/CyTYJjBKrFj6kn0Co8IsJO/MQvLOLITVCxiZVzFKpRYU
	56anJpsWGOrmpZbDozg5P3cTIzhVagXsYFy94a/eIUYmDsZDjBIczEoivLoLWdOFeFMSK6tS
	i/Lji0pzUosPMZoCA3wis5Rocj4wWeeVxBuaWBqYmJmZmVgamxkqifO+bp2bIiSQnliSmp2a
	WpBaBNPHxMEp1cC0+vQOo9s13XuU21+EzLy/aOOaV1f5mvcJxHMFiPNXu1t48604om+94YXm
	yTzXN8XT927xdlxh7fDZyzieKVUz9WfN+o3575JmHFV6qB79u/DSjOm5ijcTqgrv31j46cqi
	V4df7gicx2k6d3mj0Rv+2AqzHXEKLzvLOd66rr0VabnPuNBlQ8Q8tgcty4NPM8yOmqW6sPLw
	l5s6Dqev5HbxM71j4FrZk3mlIi1yv45u7l0O+zUbJmcmRp5sr2m7JLukt8Gn8+XKH3bP3KYY
	31iUd6zau0zfxjDTnJfzVJ2X0uFzEpp7/lqW1F93Znl562HSgebpNV4uSlxzPiX29zd6/Qu4
	znJvs0SpRNHLigtKLMUZiYZazEXFiQDtJ18kHgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsWy7bCSnK7PHPZ0g5v3RCzmrNrGaLH6bj+b
	xbvWcywWv7rvMlpc3jWHzeLZXk6LL4e/s1ucnfCB1YHDY+esu+wel8+WevRtWcXo8XmTXABL
	FJdNSmpOZllqkb5dAlfGvzWsBfM5Kk50PWBtYLzE1sXIySEhYCJx/9YfMFtIYDejxJy76RBx
	KYmbTceYIGxhiZX/nrND1DxilPiyTxHEZhPQlLg8s4ERxBYR0JVYu6kRzGYWyJc41rCeGcQW
	FvCT+P6+D6yXRUBVYt+kXWBxXgEriY7+y8wQ8+UlFu9YDmZzCthKLL74FmgvB9AuG4klU7gg
	ygUlTs58wgIxXl6ieets5gmMArOQpGYhSS1gZFrFKJlaUJybnltsWGCUl1quV5yYW1yal66X
	nJ+7iREcylpaOxj3rPqgd4iRiYPxEKMEB7OSCK/uQtZ0Id6UxMqq1KL8+KLSnNTiQ4zSHCxK
	4rzfXvemCAmkJ5akZqemFqQWwWSZODilGpg2Zp66OW255uXNV/5unPvMRGeK/EPZw8nJa3b2
	e4gWTJsXt1ptVpXf4oT2ispfV775O3MJshe+dfXrbruQkl1+dWqjiVzX/uN9p2a9ucD0Jv2G
	ulm78fa2rWrhL3XuZS2Idjp2xaTWwkPfVPN6b89shlebQibKOk/p7PoaviX9gNv5NQtSLA9F
	p7GZ3D/gtLb5cPLnxRcNC4UWS9x+HWR31CrFUinorG1iRM4vxwKemT+N3ZkO6C1+s+9UtEPN
	9/pP8c2vef/858hitEkNXa5/IiVgQdurbpPnHA80lL9euW3GfG6JtELxrGeK6y5xhnQxLtX+
	b1x4o/ln27IrrAIls9Q4nBn1XX98yLjW36rEUpyRaKjFXFScCACmoiMs1AIAAA==
X-CMS-MailID: 20241010092012epcas5p2bc333a1f880209003523e71d97ba3298
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241010092012epcas5p2bc333a1f880209003523e71d97ba3298
References: <1f21a22b-e5a7-48bd-a1c8-b9d817b2291a@gmail.com>
	<CGME20241010092012epcas5p2bc333a1f880209003523e71d97ba3298@epcas5p2.samsung.com>

---
On 25 Sep 2024 12:58 Pavel Begunkov wrote
> On 9/25/24 09:58, Ruyi Zhang wrote:
>> io_uring fdinfo contains most of the runtime information,which is
>> helpful for debugging io_uring applications; However, there is
>> currently a lack of timeout-related information, and this patch adds
>> timeout_list information.

> Please refer to unaddressed comments from v1. We can't have irqs
> disabled for that long. And it's too verbose (i.e. depends on
> the number of timeouts).

Two questions:

1. I agree with you, we shouldn't walk a potentially very long list
under spinlock. but i can't find any other way to get all the timeout
information than to walk the timeout_list. Do you have any good ideas?

2. I also agree seq_printf heavier, if we use seq_put_decimal_ull and
seq_puts to concatenate strings, I haven't tested whether it's more
efficient or not, but the code is certainly not as readable as the
former. It's also possible that I don't fully understand what you mean
and want to hear your opinion.

---
Ruyi Zhang

