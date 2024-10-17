Return-Path: <io-uring+bounces-3774-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 40AAB9A219F
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 13:57:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C6E671F23B82
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 11:57:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 188141DDC2E;
	Thu, 17 Oct 2024 11:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="S1RiwAGw"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB551DDC20
	for <io-uring@vger.kernel.org>; Thu, 17 Oct 2024 11:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729166212; cv=none; b=Cp42diUE+6UqbzFw6ECFCiiDvl6sB46JHNwvH6x02+vUvet4XfnQoPCjcVUO5zvYSoYLuLl2G3lD4cDVeo9r5Gv4JvOsuNFfLfW5TpafNFTYoE2gkZElaahBrd9MdDqaQTc+JwHBz0axPPp1scXnTq7/YeBVQVn45kJIPDzHflY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729166212; c=relaxed/simple;
	bh=bFB+zdaI20NkM3jkSFczM9bO6pSVlhNzAe6+pIvaRgo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=cRzGZaW+0J88rOA3tmqXmHDSiRLo4tVExfaLsGhYT9twB0D8TyC7vc5H3EJgDlqx0EjqWGU7YZBm4MvKdNyCkHANrM2n8fU7Pbiw8L5QlShnnJpr4NS6vmS9DbzoUzwhr8r95XJe75wViKU3JoL01K4pnr+7P7ABfZw3gUxs/yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=S1RiwAGw; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241017115648epoutp01bd2c273a3548dcb76f302ca4178adea5~-O4E-7_il0961509615epoutp01L
	for <io-uring@vger.kernel.org>; Thu, 17 Oct 2024 11:56:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241017115648epoutp01bd2c273a3548dcb76f302ca4178adea5~-O4E-7_il0961509615epoutp01L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1729166208;
	bh=JGpzDGVaE1lyC65xxnGtMRRj8bOMxuFA9l7ACd4tCDg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=S1RiwAGwFrQARxgsvmSkRvMEetoXvozPS1l8Z0OJ7Pq9UfTcu+YHGbE/7viwNqHEr
	 oxJEIGIPDAKrhchfePIqIPCi+IW95dYcFB5QWqLkcCEt/KeIsys6HkltksKfFD0wa4
	 zB6v3h6/8N9NIrqI2U6iAGCNtfpawKK7IIB0qzOM=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20241017115647epcas5p311df0bbda6841a5fe1e4486a8208fefa~-O4EZfU0O2963329633epcas5p3M;
	Thu, 17 Oct 2024 11:56:47 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.180]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4XTmXF6VYQz4x9Pp; Thu, 17 Oct
	2024 11:56:45 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	4C.E1.18935.D7BF0176; Thu, 17 Oct 2024 20:56:45 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241017105350epcas5p2e264a0a661cf4ef7f89a83e1442dfb45~-OBHKks7s2988629886epcas5p2z;
	Thu, 17 Oct 2024 10:53:50 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241017105350epsmtrp18b6356bbd55706546d9e07c29ef7e1c2~-OBHJgRMf1024010240epsmtrp16;
	Thu, 17 Oct 2024 10:53:50 +0000 (GMT)
X-AuditID: b6c32a50-a99ff700000049f7-d5-6710fb7db290
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	A2.0D.07371.EBCE0176; Thu, 17 Oct 2024 19:53:50 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20241017105348epsmtip2ad12481247dac8c03807c53baa2b6a23~-OBFOFtpd2743927439epsmtip29;
	Thu, 17 Oct 2024 10:53:48 +0000 (GMT)
Date: Thu, 17 Oct 2024 16:16:13 +0530
From: Anuj Gupta <anuj20.g@samsung.com>
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, kbusch@kernel.org, martin.petersen@oracle.com,
	asml.silence@gmail.com, anuj1072538@gmail.com, krisman@suse.de,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: Re: [PATCH v4 08/11] block: introduce BIP_CHECK_GUARD/REFTAG/APPTAG
 bip_flags
Message-ID: <20241017104613.GB1885@green245>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241017081223.GB27241@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02TfUxTVxjGd27L7QVWdi2wnXTZxLs5AgNsXekuBLYJulw347oQDXFs5dpe
	y0e/1hac7IsEChF0iCmLAxQ2BUNJKKHAcNDZVbGMCUNYZNThFqEiWEwQER1B1tKy+N/vvOd5
	3o+852As3gjKx3LVBkanppUEGsLuvhQTG//lCq4QHK3dTi4srbDJenM3IFsnq1Bywn4BIVta
	+xHynnGYTfavzaPkScd1QP54tYlF2lyvkw3Nbg5ZOd6DkuedTxDy99p6zjth1IXaSQ41NlRA
	dZiPopT13NdU70QxSi24XWzqm04zoKy/fU4tdrwsCT6Qn5LD0HJGF8WoZRp5rlqRSryfIU2X
	JooFwnhhEvkmEaWmVUwqsXOPJP7dXKW3cyKqkFYWeEMSWq8ntr2VotMUGJioHI3ekEowWrlS
	K9Im6GmVvkCtSFAzhmShQLA90SvMzs+Z+vevIO0f2GfTt4qKwRlOBQjGIC6CptEFVgUIwXh4
	H4DNnnm2/3AfwNmy9sDNQwCtTivYsNQNlARUNgAXBx8FVLcBvFbZg/hUbHwrHKxeQ32M4tHw
	8oxx3R2BE9A9NwR8BhY+gkDH2Oq6KBzPhH1zNetmLh4HG+aPoX7eBH/9bprt42Bv3GRsCPJx
	JP4KtHc7EV8iiA9gcGW8FfX3txO2NI2z/RwO55ydgVH5cLaqLMAK+GjMjfhZC0uu/ByY7W1o
	HKxi+ZiF58BfTM5AzpdgzWAb4o+HweMr0wEvF/ac2WAClrfUBxhC23BxgCm48u2p9Tw8/G8A
	yzxhJ8Dm2qdmq32qnJ/jYGPvfS9jXn4Rnn+C+TEGWn7a1giCzIDPaPUqBSNL1Arj1czh/1cu
	06g6wPrTjpX0gNb21QQHQDDgABBjERHckxVcBY8rp48UMTqNVFegZPQOkOjdVjWLHynTeP+G
	2iAVipIEIrFYLEp6QywkXuDeNZ6W83AFbWDyGUbL6DZ8CBbML0bS3DdGtzwU4SpldGzzs7se
	V0Y+KF0r7OXtIiLkeTFms+p2kemAxHnQyusKu7c39MaEzOVKeXXP0nKPRWkqjSavjpRkwU+S
	D9n/bKqWXvzoh/3yxazoO5rQTOQgXzO7+hxtzsxL89jPyqg77f3ldXuvcB6MXRxPu24rJTfd
	/d4VxPB1uV91qr7YZ+1qUU1PPl/TdO5UYVV2zD/lRcnpu/fxLg2dXpr5eH/oNdHocN9Qlq5r
	2uOwcGYz2j5YPoSZl+02icCyO6XiU1sZd2vbkaln5JIPW0/YV481Hr61ZUf25vSznrjkx5ft
	AyEZMzNT771GGndURFjWlHk3XXWTx28uhRNsfQ4tjGXp9PR/ao0oamMEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42LZdlhJXnffG4F0g6tdZhYfv/5msZizahuj
	xeq7/WwWNw/sZLJYufook8W71nMsFkf/v2WzmHToGqPF9jNLmS323tK2mL/sKbtF9/UdbBbL
	j/9jsjg/aw67A5/Hzll32T0uny312LSqk81j85J6j903G9g8Pj69xeLRt2UVo8fm09UenzfJ
	BXBGcdmkpOZklqUW6dslcGVce9bNVDCFreLqWb0Gxu8sXYycHBICJhKzTzSD2UICuxkl2ufk
	QsQlJE69XMYIYQtLrPz3nB2i5gmjxNENtiA2i4CqxKmJ/9lAbDYBdYkjz1vB6kUElCSevjoL
	ZHNxMAtcYJLYtuQNM0hCWCBCYs+rqUwgNq+AjsT8tz1sIEVCAvcZJVY8egCVEJQ4OfMJ2EXM
	AloSN/69BIpzANnSEsv/cYCEOYF6p7TOZwWxRQWUJQ5sO840gVFwFpLuWUi6ZyF0L2BkXsUo
	mVpQnJuem2xYYJiXWq5XnJhbXJqXrpecn7uJERxnWho7GO/N/6d3iJGJg/EQowQHs5II76Qu
	3nQh3pTEyqrUovz4otKc1OJDjNIcLErivIYzZqcICaQnlqRmp6YWpBbBZJk4OKUamM6UavxM
	LC/o/yt7zCGnXDU+aatGwcuqBbZf5q0KeC0pvPnzsp3PP11bNPuIEPdEs/4NOdF56fev5LVV
	X/gvev2alMrtMxeCrYr+nGXuidhUfuAwY43MFOYvs89dnvRv8s3KvQd+X8rJ3ebiy/L/0EJB
	1tro6YHHLpy2dNuz6q7isaNqTr/LXP72Gzo0re2IUT9Uu+/YvbSqvf+f6j7LbDCx3RZeWFxU
	Km576Kvtq5uNZ8sEs6RCXm2UPPJjn9nqwHVev59wPtwqfOs5576Ev9Znfzm9PDPbuVJHwunk
	eYmFqeY/r1vtudNjteHLwvOOkY0HuX4F3DR6ragScOzNq6zsRV8epcT8XbkjYuXsngUMSizF
	GYmGWsxFxYkAli9waiIDAAA=
X-CMS-MailID: 20241017105350epcas5p2e264a0a661cf4ef7f89a83e1442dfb45
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----Q5hryimWBrG20CTDo2Cycv07rC8cEZ5s1mVzGfufIajJO9l9=_50089_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241016113750epcas5p2089e395ca764de023be64519da9b0982
References: <20241016112912.63542-1-anuj20.g@samsung.com>
	<CGME20241016113750epcas5p2089e395ca764de023be64519da9b0982@epcas5p2.samsung.com>
	<20241016112912.63542-9-anuj20.g@samsung.com>
	<20241017081223.GB27241@lst.de>

------Q5hryimWBrG20CTDo2Cycv07rC8cEZ5s1mVzGfufIajJO9l9=_50089_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Thu, Oct 17, 2024 at 10:12:23AM +0200, Christoph Hellwig wrote:
> On Wed, Oct 16, 2024 at 04:59:09PM +0530, Anuj Gupta wrote:
> > This patch introduces BIP_CHECK_GUARD/REFTAG/APPTAG bip_flags which
> > indicate how the hardware should check the integrity payload. The
> > driver can now just rely on block layer flags, and doesn't need to
> > know the integrity source. Submitter of PI decides which tags to check.
> > This would also give us a unified interface for user and kernel
> > generated integrity.
> 
> The conversion of the existing logic looks good, but the BIP_CHECK_APPTAG
> flag is completely unreferenced.

It's being used by the nvme and scsi patch later. Should I introduce this
flag later in either nvme or scsi patch where we actually use it.
> 
> 

------Q5hryimWBrG20CTDo2Cycv07rC8cEZ5s1mVzGfufIajJO9l9=_50089_
Content-Type: text/plain; charset="utf-8"


------Q5hryimWBrG20CTDo2Cycv07rC8cEZ5s1mVzGfufIajJO9l9=_50089_--

