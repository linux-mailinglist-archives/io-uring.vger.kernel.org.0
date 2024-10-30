Return-Path: <io-uring+bounces-4196-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E7EE49B613A
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 12:17:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A499E2842EC
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 11:17:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 303D81CF7DE;
	Wed, 30 Oct 2024 11:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ZlYbgbWI"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53151E3DF7
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 11:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730287048; cv=none; b=tv1NZGdjAvKyc8KSFTsdKQonD45I5JnMYj+RKspi+YHfdeEAvxMAXW9C3iEI3Vb9uLSVi4NHdj+SyqMjs1OXXz/nXQNg/RnYGQioVtHarg8Q51PwMhhFtsdmbgIcIjhaowJI2Q8cfO08gnV0j+sZni3UZ7lJFOJPJrIF4+ZnuK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730287048; c=relaxed/simple;
	bh=LEiuK3PXV7/9ll9DLAh0obqeJBco8ngklVptQpr21ZU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=M0E6GRt6S2efIactdseyBdJNPu1w/SI8xKedmvXSHPQNwIOl+1FqCiYWqGDnR2kAI5K287eXD4ArilDRUroekUIF0VFY6bSXA7L04xZZvBQynm5b4pH2DqSEf8iFC7fb6HzwwZxUnQGdz4Xfjt0v8OI1CY7bjRlFT8zMpnnbvf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ZlYbgbWI; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20241030111717epoutp025890266783ac5a5006e1f5febb716b91~DNuSwrF_o0758307583epoutp02U
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 11:17:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20241030111717epoutp025890266783ac5a5006e1f5febb716b91~DNuSwrF_o0758307583epoutp02U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730287037;
	bh=OzObsVJKazVgcN/sx4nDHJ63Yo33iupzEMEKYB9KAo8=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=ZlYbgbWIFcDAS1lhBQZkC3kI49kLlv8+s8ulBNrNrt3Kg4GXRvATsZreTbyLOZbez
	 ww2gLN7jum2vjjKy+PC35HKlrYfDnRCmRolVnB6eWAPxevjpeDjGXCINoF1rfuhLfE
	 UhpLuJ731723XJDZZa6dpmw6cUnxP6VW7wVnu22c=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20241030111716epcas5p3a994daa648427069bbd00eb1f4650c90~DNuR0GVe80206702067epcas5p3k;
	Wed, 30 Oct 2024 11:17:16 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Xdl2g3ykXz4x9Pw; Wed, 30 Oct
	2024 11:17:15 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	A5.E1.18935.BB512276; Wed, 30 Oct 2024 20:17:15 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20241030111714epcas5p43427b28045729bf2a3e8b5f8eb89721a~DNuPyYXi50427004270epcas5p4u;
	Wed, 30 Oct 2024 11:17:14 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241030111714epsmtrp2bd805bfc1033e94261a0f82b9b75f1a6~DNuPxiVnR2729027290epsmtrp2v;
	Wed, 30 Oct 2024 11:17:14 +0000 (GMT)
X-AuditID: b6c32a50-a99ff700000049f7-45-672215bb2293
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	27.46.18937.AB512276; Wed, 30 Oct 2024 20:17:14 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241030111712epsmtip2062d4a5833ae6808d34c5cd6b34aedde~DNuNfow6l1561015610epsmtip2I;
	Wed, 30 Oct 2024 11:17:11 +0000 (GMT)
Message-ID: <457b635b-a3b5-48bb-b2ac-b129c5d3d30d@samsung.com>
Date: Wed, 30 Oct 2024 16:47:11 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/10] fs, iov_iter: define meta io descriptor
To: Christoph Hellwig <hch@lst.de>, Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, kbusch@kernel.org, martin.petersen@oracle.com,
	asml.silence@gmail.com, anuj1072538@gmail.com, brauner@kernel.org,
	jack@suse.cz, viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20241030050355.GA32598@lst.de>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCJsWRmVeSWpSXmKPExsWy7bCmhu5uUaV0g7t3pS0+fv3NYtE04S+z
	xZxV2xgtVt/tZ7N4ffgTo8XNAzuZLFauPspk8a71HIvF7OnNTBaTDl1jtNh7S9tiz96TLBbz
	lz1lt+i+voPNYvnxf0wW5/8eZ7U4P2sOu4Ogx85Zd9k9Lp8t9di0qpPNY/OSeo/dNxvYPD4+
	vcXi0bdlFaPHmQVH2D0+b5Lz2PTkLVMAV1S2TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGh
	rqGlhbmSQl5ibqqtkotPgK5bZg7QO0oKZYk5pUChgMTiYiV9O5ui/NKSVIWM/OISW6XUgpSc
	ApMCveLE3OLSvHS9vNQSK0MDAyNToMKE7IzeaY3sBR+YKh7PfsDYwLiKqYuRk0NCwETixftd
	jF2MXBxCAnsYJaZvvsMC4XxilFh66yMrnDP/wAMWmJbV706wQyR2MkrcPjmdCcJ5yygx+fp3
	sCpeATuJ7f9/gS1hEVCVePzrKDtEXFDi5MwnYDWiAvIS92/NAIsLC7hKtHw8zwhiiwDZpx5c
	ZAYZyizwhUni8N1WsCJmAXGJW0/mAw3l4GAT0JS4MLkUJMwpoCPxfstqRogSeYntb+eA9UoI
	vOGQuPvwJSvE2S4Sh5omMULYwhKvjm9hh7ClJD6/28sGYWdLPHgE82aNxI7NfVC99hINf26w
	guxlBtq7fpc+xC4+id7fT8DOkRDglehoE4KoVpS4N+kpVKe4xMMZS6BsD4mH+++CbRISuM8o
	0fXQegKjwiykUJmF5MlZSL6ZhbB4ASPLKkap1ILi3PTUZNMCQ9281HJ4jCfn525iBCd3rYAd
	jKs3/NU7xMjEwXiIUYKDWUmE1zJIMV2INyWxsiq1KD++qDQntfgQoykwfiYyS4km5wPzS15J
	vKGJpYGJmZmZiaWxmaGSOO/r1rkpQgLpiSWp2ampBalFMH1MHJxSDUwRt9qXHYoPOcigFOlg
	/DLkW8KiuYtMbM7lhrDfym1ynF7bXvaH/9HTjUWCExvKXa5eEueeycPJ6alSxPCL5WScYe+G
	Jwu8E+rEKh5cZntW4l/XpXrjkt71ssVR0f//SmXoPmToPrX6NUtStPee01nb3ttH3nipKO5R
	zv5Thcfz4ZwutrOz+X/mKTmu+uVqxs4+4dKnFVwZrGlFYba5rrvTLlzYubO8cv0N048/dFyL
	fswK6ZLbVH5xxaepfl2rJt/dEPdwO/PG3tmbAg+6Ha8ValPyeuPyoMtmRqn2x+WHru95/+6g
	7O2HVXqK804z35viuZJj3w6hteUC67ZPVfKVFN+47ddGtUWhB7ZeZGJSYinOSDTUYi4qTgQA
	erqqjncEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsWy7bCSvO4uUaV0g+f3JSw+fv3NYtE04S+z
	xZxV2xgtVt/tZ7N4ffgTo8XNAzuZLFauPspk8a71HIvF7OnNTBaTDl1jtNh7S9tiz96TLBbz
	lz1lt+i+voPNYvnxf0wW5/8eZ7U4P2sOu4Ogx85Zd9k9Lp8t9di0qpPNY/OSeo/dNxvYPD4+
	vcXi0bdlFaPHmQVH2D0+b5Lz2PTkLVMAVxSXTUpqTmZZapG+XQJXRu+0RvaCD0wVj2c/YGxg
	XMXUxcjJISFgIrH63Qn2LkYuDiGB7YwSq9c0skEkxCWar/1gh7CFJVb+ew5V9JpRYvfrHSwg
	CV4BO4nt/3+BTWIRUJV4/OsoO0RcUOLkzCdgNaIC8hL3b80AiwsLuEq0fDzPCGKLANmnHlxk
	BhnKLPCFSWLlw1nMEBvuMkqcOPIZ7AxmoDNuPZkPtIGDg01AU+LC5FKQMKeAjsT7LasZIUrM
	JLq2dkHZ8hLb385hnsAoNAvJHbOQTJqFpGUWkpYFjCyrGEVTC4pz03OTCwz1ihNzi0vz0vWS
	83M3MYIjWCtoB+Oy9X/1DjEycTAeYpTgYFYS4bUMUkwX4k1JrKxKLcqPLyrNSS0+xCjNwaIk
	zquc05kiJJCeWJKanZpakFoEk2Xi4JRqYHJW2FSz7yzz7ba52RtkT/SvFc+OWyv6+6rVm6c3
	D72PP3Iy0ELoyrUdS7OsuTSWu/Yt0dh50oU3ZVlrrvweeXd/7UmhZ+/4hfMn7v6s4Drv79eJ
	TA4v5m39OqXBeWejg9q9V7MvfRGX9+AIs2vmexD5UfG5pNsCrqw8G7tlb5cvYAgp63N/mXqi
	2Tj4brS/CIdhn5Ypg6jk4cd6MiV7mblY3PQiLiWdfvRlx4opVa7vM6Ot5jFkds6SfPJP2vzf
	3diok8lVXGH2bgzKs6ITVVv2Nxt/YL99yEdWPKexeO1FMxmLdepWn8JzyzUqncr+PQ9cxFUo
	LKSw2NFQ8UKAyNU/DwO/vPv7uWy75o7FSizFGYmGWsxFxYkASVkO2U8DAAA=
X-CMS-MailID: 20241030111714epcas5p43427b28045729bf2a3e8b5f8eb89721a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241029163220epcas5p2207d4c54b8c4811e973fca601fd7e3f5
References: <20241029162402.21400-1-anuj20.g@samsung.com>
	<CGME20241029163220epcas5p2207d4c54b8c4811e973fca601fd7e3f5@epcas5p2.samsung.com>
	<20241029162402.21400-5-anuj20.g@samsung.com>
	<20241030050355.GA32598@lst.de>

On 10/30/2024 10:33 AM, Christoph Hellwig wrote:
> .. but these aren't.  Leading to warnings like:
> 
>   CHECK   block/bio-integrity.c
> block/bio-integrity.c:371:17: warning: restricted uio_meta_flags_t degrades to integer

For some reasons this does not show up in my setup.
But that only means setup needs to be fixed. Apart from dropping the 
__bitwise.

