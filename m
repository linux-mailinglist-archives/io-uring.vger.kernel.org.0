Return-Path: <io-uring+bounces-1664-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FBCC8B568E
	for <lists+io-uring@lfdr.de>; Mon, 29 Apr 2024 13:28:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6A0CDB24F04
	for <lists+io-uring@lfdr.de>; Mon, 29 Apr 2024 11:28:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDF743FE28;
	Mon, 29 Apr 2024 11:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="EH3sYA15"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6088223772
	for <io-uring@vger.kernel.org>; Mon, 29 Apr 2024 11:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714390127; cv=none; b=e/AYAw03Ximn500IsPyTEZlE7pSkoKLNaem4PY5o6l6+Hbna4Bwm/HKWWSer26vE/TbXBVYWfP9gbKoDh+YLZegFJUkqxyc5MQTFQImZsdnmsD1HZaJrXof02n6t7g0ut9afEspyJxMcjtLhf306+Zhg00rytSJeBd1+g3Tm5wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714390127; c=relaxed/simple;
	bh=9+iIDIGeBrqPHa7IENzBUl64vkmGoImZHllaGSOcTTI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=vFGLrUT0CEC1suEkcLDhCwk8gxBE6rwpONTZBxVG0fnSFwuryMYZ+olsJRM7Xx6euIzMqznEtKNpI4G0ZofiljPNIfikVVQoPT4DwvfcnhLZMTL/T/1HQsc0KjrCTTUumhrAs3w4XpYIsXIgK3mVNZJt3ITimoY9rj+frra2Ol0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=EH3sYA15; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240429112842epoutp0345908c35d0820269ae000211b6055a12~KvLvGJ6pI0522605226epoutp035
	for <io-uring@vger.kernel.org>; Mon, 29 Apr 2024 11:28:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240429112842epoutp0345908c35d0820269ae000211b6055a12~KvLvGJ6pI0522605226epoutp035
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1714390122;
	bh=qql6H84yrAVcpCA1EqC2oiYtThMBtmV/sd5WrSawJ9I=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=EH3sYA15o0O8qZy0q/WHV48FiAx4OpUFFDtZ9TsHhaUJzASUo3CbUItJZe2tvt4tI
	 GWBDFQdtR4n2M2mbpVAwbUS7U3hhwI30wO4sI9zd+815+D48VeuQjDZir9NYm8m7F5
	 6W63vQ/19DwKZ654lVFXVs6LmeEPsQb8A/mJHBYM=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240429112842epcas5p1b13daeffb2c8379c9a7893e7d5363a7f~KvLuqDBoD0922009220epcas5p1R;
	Mon, 29 Apr 2024 11:28:42 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4VSh0m4gQLz4x9Py; Mon, 29 Apr
	2024 11:28:40 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	2F.9C.19431.8648F266; Mon, 29 Apr 2024 20:28:40 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240429112840epcas5p3c1e0fa5d887cb99e34beaf752c6079d1~KvLso-4-o2717727177epcas5p37;
	Mon, 29 Apr 2024 11:28:40 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240429112840epsmtrp264f517a3660175e6a3f54f47a2b90028~KvLsoSqAA2874128741epsmtrp2H;
	Mon, 29 Apr 2024 11:28:40 +0000 (GMT)
X-AuditID: b6c32a50-f57ff70000004be7-05-662f8468829a
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	99.F7.19234.8648F266; Mon, 29 Apr 2024 20:28:40 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240429112838epsmtip281332baf2962d0db426883b1de052ce3~KvLq5utYd1326113261epsmtip2k;
	Mon, 29 Apr 2024 11:28:38 +0000 (GMT)
Message-ID: <73cc82c3-fbf6-ea3e-94ec-3bdce55af541@samsung.com>
Date: Mon, 29 Apr 2024 16:58:37 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
	Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH 02/10] block: copy bip_max_vcnt vecs instead of bip_vcnt
 during clone
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, martin.petersen@oracle.com, kbusch@kernel.org,
	brauner@kernel.org, asml.silence@gmail.com, dw@davidwei.uk,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com, Anuj Gupta
	<anuj20.g@samsung.com>
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20240427070331.GB3873@lst.de>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMJsWRmVeSWpSXmKPExsWy7bCmhm5Gi36awdstihZNE/4yW8xZtY3R
	YvXdfjaL14c/MVq8mrGWzeLmgZ1MFitXH2WyeNd6jsVi0qFrjBZ7b2lbzF/2lN1i+fF/TA48
	HtdmTGTx2DnrLrvH5bOlHptWdbJ5bF5S77H7ZgObx8ent1g8+rasYvT4vEkugDMq2yYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6GAlhbLEnFKgUEBi
	cbGSvp1NUX5pSapCRn5xia1SakFKToFJgV5xYm5xaV66Xl5qiZWhgYGRKVBhQnbG0U9bmQoO
	s1X8XfaMvYFxBmsXIyeHhICJxIbrrUA2F4eQwB5GiZX79zNBOJ8YJebMvcAM52xd3scC07J6
	Si8LRGIno8TtrmYo5y2Q8/Y0UD8HB6+AncTltZkgDSwCqhIrp3eANfMKCEqcnPkEzBYVSJb4
	2XWADaRcWCBaYu1SF5Aws4C4xK0n85lAbBEBJYmnr84ygoxnFpjGJLG2ZyoLSD2bgKbEhcml
	IDWcAtoSHxb2M0L0yktsfzsH7GgJgRMcErOPd4CdIyHgItF/XB7ifmGJV8e3sEPYUhKf3+1l
	g7CTJS7NPMcEYZdIPN5zEMq2l2g91c8MMoYZaO36XfoQq/gken8/gZrOK9HRJgRRrShxb9JT
	aOCKSzycsYQVosRD4vCGOkg43WCUOHptM8sERoVZSGEyC8nzs5A8Mwth8QJGllWMUqkFxbnp
	qcmmBYa6eanl8OhOzs/dxAhOzVoBOxhXb/ird4iRiYPxEKMEB7OSCO+mOdppQrwpiZVVqUX5
	8UWlOanFhxhNgbEzkVlKNDkfmB3ySuINTSwNTMzMzEwsjc0MlcR5X7fOTRESSE8sSc1OTS1I
	LYLpY+LglGpg6mx4IxB1hMt4wp7g5FpJVgmGxYJXzzlIXSkIcDt4YvVa/sa2d5ctMtO2NExo
	qVNcEZrgkmLxLVTxqanfeuVj66Yl3xQIP97pX2JtwmSe++f1OvWfVqqavKtepGx78WzHn5Ua
	ijo8TXrJ/w+9zZBIMvVRSHl+Qu9S/NJlN9o9CoWVw5Oz77/Y9NNIVd7zS4aQvrPJ0VYrboE4
	n0lR+zQufUs5elgkpLWio/mK2rvDu6bO/L5G/Igth2jM3p0RFjpuuntfrfaecuXEwlYvsVsB
	izR+T5wpKrg39dR2nkjbnFV2DflHVk783mH1dfPepKSXvIvU9oVe6dW/qfxtJ1/rbNaDSfER
	+ZcX/M1t3VqtxFKckWioxVxUnAgAuUZZH1YEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsWy7bCSvG5Gi36awdEvzBZNE/4yW8xZtY3R
	YvXdfjaL14c/MVq8mrGWzeLmgZ1MFitXH2WyeNd6jsVi0qFrjBZ7b2lbzF/2lN1i+fF/TA48
	HtdmTGTx2DnrLrvH5bOlHptWdbJ5bF5S77H7ZgObx8ent1g8+rasYvT4vEkugDOKyyYlNSez
	LLVI3y6BK+Pop61MBYfZKv4ue8bewDiDtYuRk0NCwERi9ZReli5GLg4hge2MEqtazrFBJMQl
	mq/9YIewhSVW/nsOZgsJvGaU2HShuouRg4NXwE7i8tpMkDCLgKrEyukdLCA2r4CgxMmZT8Bs
	UYFkiZd/JrKDlAsLREusXeoCEmYGmn7ryXwmEFtEQEni6auzjCAnMAtMY5Lo/7mZFWLVDUaJ
	7ZdtQHrZBDQlLkwuBQlzCmhLfFjYzwgxx0yia2sXlC0vsf3tHOYJjEKzkFwxC8m6WUhaZiFp
	WcDIsopRNLWgODc9N7nAUK84Mbe4NC9dLzk/dxMjOPq0gnYwLlv/V+8QIxMH4yFGCQ5mJRHe
	TXO004R4UxIrq1KL8uOLSnNSiw8xSnOwKInzKud0pggJpCeWpGanphakFsFkmTg4pRqY+hdn
	2Be+vJzxYIow98zZb3OW//ffX/Ohf99lppqE14f4Jhiu/lat6bhLR4Th347XrczRAUnbXQy5
	rkq1zJa0k1E78LDZmvPthiPhRpyPPXK2mj9fyvAncpKgTTPDic8OXq8CdDa6r//8vTN4c7Z6
	5T3HOU6HLZULd5a1Nm48L8MS0jorx6DqqcueaMNXM2Vy3k413zFPydzMUqQzeO05tnfbH9z5
	wrBja6jcnOmXXY+fPKy74n6Ri+aZvw4LOY97VzccOJpg98b/u09Mu2+h+GRbsRiJhqUbL780
	6JOdfqvWTGifaEDdD8PvX6ZPNQr/7CH7QYJ7VoTzp+q6c2vffkhdrfGUge3pZ+Pw3xu3KrEU
	ZyQaajEXFScCACypC4otAwAA
X-CMS-MailID: 20240429112840epcas5p3c1e0fa5d887cb99e34beaf752c6079d1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240425184653epcas5p28de1473090e0141ae74f8b0a6eb921a7
References: <20240425183943.6319-1-joshi.k@samsung.com>
	<CGME20240425184653epcas5p28de1473090e0141ae74f8b0a6eb921a7@epcas5p2.samsung.com>
	<20240425183943.6319-3-joshi.k@samsung.com> <20240427070331.GB3873@lst.de>

On 4/27/2024 12:33 PM, Christoph Hellwig wrote:
>> If bio_integrity_copy_user is used to process the meta buffer, bip_max_vcnt
>> is one greater than bip_vcnt. In this case bip_max_vcnt vecs needs to be
>> copied to cloned bip.
> Can you explain this a bit more?  The clone should only allocate what
> is actually used, so this leaves be a bit confused.
> 

Will expand the commit description.

Usually the meta buffer is pinned and used directly (say N bio vecs).
In case kernel has to make a copy (in bio_integrity_copy_user), it 
factors these N vecs in, and one extra for the bounce buffer.
So for read IO, bip_max_vcnt is N+1, while bip_vcnt is N.

The clone bio also needs to be aware of all N+1 vecs, so that we can 
copy the data from the bounce buffer to pinned user pages correctly 
during read-completion.

