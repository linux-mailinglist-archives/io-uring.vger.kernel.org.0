Return-Path: <io-uring+bounces-5197-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E77399E359D
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 09:40:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6EF43B22995
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 08:21:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E442192B69;
	Wed,  4 Dec 2024 08:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="KaDd1ZGj"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48D47442F
	for <io-uring@vger.kernel.org>; Wed,  4 Dec 2024 08:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733300460; cv=none; b=R/CfNFwfLdUCPUgm+B2zYFdcbOGPa60d+L3qCofXk/q0cfq/BXwHS7W99V8uOngIl/bj8AEt2pSYSLJftOyqZNIKxryJH8t/P+oH1I+1Pb4+jEJmbWWAfF2VOWgO6/zd1RZMSoUKl4q8WfU8TDlmPHy/FJJXB2C8ptooKXLyh1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733300460; c=relaxed/simple;
	bh=O13DDcLQ25KD340z4Z5Yyhmco6vbF1qHXsYOqTV1yBE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=VTDwjmP2QOqH+btCCj1JVWGfG9aOF1ugCH3cJfXQjTmbPHDk9NLoHFtOob+XiAXviKCR9DBL/RPnBeCMCV/7WQAwJ2HcL8ZJ+FwiTQp5VWdTkFveCN9OnRU9wfPp0X1o6jmS3hjkpIEuODNugAesWD3CAV5RzXX+SBtiQKEdfeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=KaDd1ZGj; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20241204082050epoutp028efadda783dae4667d5311f9aebbb35c~N65N3sjWn2449724497epoutp02w
	for <io-uring@vger.kernel.org>; Wed,  4 Dec 2024 08:20:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20241204082050epoutp028efadda783dae4667d5311f9aebbb35c~N65N3sjWn2449724497epoutp02w
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1733300450;
	bh=ijTn2RZpszgvF0yCphU0nJ2OjpujKXhxXXTisuwagvk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=KaDd1ZGj49Fjeg/Fa2m4PtI0DfEES9tYH8rcgKS6uPAnGv1QDMJqJNh97AyGgRMVf
	 zhNbOBG/bo0B73kD3c+UF284DIVK+dmuXOhOwRDuElyzTFOFzpeUtI67zZS6Oebx4i
	 ChVV5sRBoEDBsIzLwwXEuZ2cgiJA5XbO1p0SVs1Y=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20241204082049epcas5p231edcf7fc51b73b40ceca6afe8b6667d~N65NKIjfV2555925559epcas5p2m;
	Wed,  4 Dec 2024 08:20:49 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.178]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4Y39Sw14YQz4x9Q1; Wed,  4 Dec
	2024 08:20:48 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	C6.75.19710.FD010576; Wed,  4 Dec 2024 17:20:48 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20241204081706epcas5p40981cc87d05ff313b42b8a11e28deafb~N619v5uft1247712477epcas5p4P;
	Wed,  4 Dec 2024 08:17:06 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241204081706epsmtrp282362d787953a8683ebae90061f2fc31~N619t515O2674426744epsmtrp2V;
	Wed,  4 Dec 2024 08:17:06 +0000 (GMT)
X-AuditID: b6c32a44-36bdd70000004cfe-84-675010df9bff
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	4A.92.18729.20010576; Wed,  4 Dec 2024 17:17:06 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20241204081704epsmtip231987e4d4f9c94a17b31717e6e6df6e0~N617YUVNO3208632086epsmtip21;
	Wed,  4 Dec 2024 08:17:04 +0000 (GMT)
Date: Wed, 4 Dec 2024 13:39:03 +0530
From: Anuj Gupta <anuj20.g@samsung.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, axboe@kernel.dk,
	hch@lst.de, kbusch@kernel.org, anuj1072538@gmail.com, brauner@kernel.org,
	jack@suse.cz, viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v11 06/10] io_uring: introduce attributes for read/write
 and PI support
Message-ID: <20241204080903.GA16700@green245>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <b8574010-e2fc-4566-9df8-80046fec2845@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJsWRmVeSWpSXmKPExsWy7bCmuu4DgYB0gydTmCw+fv3NYjFn1TZG
	i9V3+9ksXh/+xGhx88BOJouVq48yWbxrPcdiMXt6M5PF0f9v2SwmHbrGaLH3lrbFnr0nWSzm
	L3vKbtF9fQebxfLj/5gszv89zmpxftYcdgdBj52z7rJ7XD5b6rFpVSebx+Yl9R67bzaweXx8
	eovFo2/LKkaPMwuOsHt83iTnsenJW6YArqhsm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwND
	XUNLC3MlhbzE3FRbJRefAF23zBygd5QUyhJzSoFCAYnFxUr6djZF+aUlqQoZ+cUltkqpBSk5
	BSYFesWJucWleel6eaklVoYGBkamQIUJ2Rnnrx5mLdjGWvH98TuWBsarLF2MnBwSAiYSV7de
	Yu9i5OIQEtjNKHH43T9mkISQwCdGibfPciES3xglLvw8A9cx+0gPI0RiL6PEnp3X2CCcZ4wS
	m/Z8B6tiEVCR+PRuHiOIzSagLnHkeSuYLSKgLfH6+iGwfcwCS5glrrybC7ZPWCBWYufMNWA2
	r4CuxN6Pj1ggbEGJkzOfgNmcArYSG7ctYgexRQWUJQ5sO84EMkhC4AGHxL3vV5gg7nOR6Ola
	zAhhC0u8Or6FHcKWkvj8bi8bhJ0u8ePyU6j6AonmY/ug6u0lWk/1gx3BLJAhcXvjK6heWYmp
	p9YxQcT5JHp/P4Hq5ZXYMQ/GVpJoXzkHypaQ2HuuAcjmALI9JO605EDCdCeTxNQ5xhMY5Wch
	eW0Wkm0Qto7Egt2f2GYBdTMLSEss/8cBYWpKrN+lv4CRdRWjZGpBcW56arJpgWFeajk8wpPz
	czcxglO7lssOxhvz/+kdYmTiYDzEKMHBrCTCG7jEP12INyWxsiq1KD++qDQntfgQoykwriYy
	S4km5wOzS15JvKGJpYGJmZmZiaWxmaGSOO/r1rkpQgLpiSWp2ampBalFMH1MHJxSDUx1xYLp
	T5vzJ9ZO89oQXPJXvVzjy3THq4dL5Ovc2/49+9IWuperwXSDRva0/fKX1WJez18mVv0ogeHi
	P26Zg0yOJwPT12fpdyzw7a9MYegXV84PmaBsPn/z06TFqRl7HlRy8HLX+FyW0b4edP9BV8/r
	25UMucLT3+jdPr15v0aXId9On2OcG603F16VuHbviKBC7yf91OXeDBwaF69f6PWqPPcx4piB
	qdLaeRxLS/1+sYdc+Fym8e7Qys/Nt3MyHlf0rZXd6r4whmsR9w97u58Zq0P4OU1UOSxTKxs9
	VU7LpBc1qG6sPZs0Udcru/aBqM+tdgft/1tnJC1X4jfRcLTbwZb7V3vXyV9teVxhSizFGYmG
	WsxFxYkATdakJnYEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsWy7bCSvC6TQEC6wbH36hYfv/5msZizahuj
	xeq7/WwWrw9/YrS4eWAnk8XK1UeZLN61nmOxmD29mcni6P+3bBaTDl1jtNh7S9tiz96TLBbz
	lz1lt+i+voPNYvnxf0wW5/8eZ7U4P2sOu4Ogx85Zd9k9Lp8t9di0qpPNY/OSeo/dNxvYPD4+
	vcXi0bdlFaPHmQVH2D0+b5Lz2PTkLVMAVxSXTUpqTmZZapG+XQJXxq0ukYJvTBVPjnezNzCu
	Y+pi5OSQEDCRmH2kh7GLkYtDSGA3o8TKu3+YIRISEqdeLmOEsIUlVv57zg5R9IRR4s2CHnaQ
	BIuAisSnd/PAitgE1CWOPG8Fs0UEtCVeXz8E1sAssIxZ4v/TNlaQhLBArMTOmWvANvAK6Ers
	/fiIBWo1k8SFCb0sEAlBiZMzn4DZzAJaEjf+vQS6lQPIlpZY/o8DJMwpYCuxcdsisCNEBZQl
	Dmw7zjSBUXAWku5ZSLpnIXQvYGRexSiZWlCcm55bbFhgmJdarlecmFtcmpeul5yfu4kRHJVa
	mjsYt6/6oHeIkYmD8RCjBAezkghv4BL/dCHelMTKqtSi/Pii0pzU4kOM0hwsSuK84i96U4QE
	0hNLUrNTUwtSi2CyTBycUg1MEtf9c4//n1/x3Dn9W26m0CTj5s4uZv91xbN/+Z80ZrPUqc0N
	PR72ncWYVXCivuKyx7o6cWeYdsfXvnGxyDbibueVCjmybOdHsdS1c5LZfjR2LtC4JSp0uzB0
	bU+RxkaL513a0UtjRGa4GZzjtp/+wyo0a33IUrvaD1IfBJOjag8tmxpcWzE/fdnjd6c5Xb1+
	Zp+TkVt5u19XfbKDWLgc7xmW3SLW0vk7JgnN2fCy+1RjbWy/5ES/Q/JHlipxT6gO7oyIkgta
	PcVK8I5aemr5nSJJWw+d9XbaLgwF5413nzk1r9VU1fXby3evuK7OPipcbd/8THGK5+ETv8IZ
	DBq3RX64L6EU3j31nN3TEiWW4oxEQy3mouJEAFYvDgw5AwAA
X-CMS-MailID: 20241204081706epcas5p40981cc87d05ff313b42b8a11e28deafb
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----QQbx9Hk6-Xl4D1oMwM2uYkP7uAkYtjoi7zPie6od2LiHNIsi=_57c7d_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241128113109epcas5p46022c85174da65853c85a8848b32f164
References: <20241128112240.8867-1-anuj20.g@samsung.com>
	<CGME20241128113109epcas5p46022c85174da65853c85a8848b32f164@epcas5p4.samsung.com>
	<20241128112240.8867-7-anuj20.g@samsung.com>
	<yq1r06psey3.fsf@ca-mkp.ca.oracle.com> <20241203065645.GA19359@green245>
	<b8574010-e2fc-4566-9df8-80046fec2845@gmail.com>

------QQbx9Hk6-Xl4D1oMwM2uYkP7uAkYtjoi7zPie6od2LiHNIsi=_57c7d_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Tue, Dec 03, 2024 at 12:00:41PM +0000, Pavel Begunkov wrote:
> On 12/3/24 06:56, Anuj Gupta wrote:
> > On Mon, Dec 02, 2024 at 09:13:14PM -0500, Martin K. Petersen wrote:
> An IORING_FEAT_ flag might be simpler for now. Or is it in plans to
> somehow support IORING_OP_READ_MULTISHOT as well?
> 
No, multishot doesn't fit wel. Will add a IORING_FEAT_RW_ATTR flag.

------QQbx9Hk6-Xl4D1oMwM2uYkP7uAkYtjoi7zPie6od2LiHNIsi=_57c7d_
Content-Type: text/plain; charset="utf-8"


------QQbx9Hk6-Xl4D1oMwM2uYkP7uAkYtjoi7zPie6od2LiHNIsi=_57c7d_--

