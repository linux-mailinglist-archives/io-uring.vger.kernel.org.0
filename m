Return-Path: <io-uring+bounces-5270-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CC6BB9E6EA0
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 13:55:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ACE5B1884522
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 12:53:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 105F8202C25;
	Fri,  6 Dec 2024 12:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="APm+a/HL"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A032201116
	for <io-uring@vger.kernel.org>; Fri,  6 Dec 2024 12:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733489585; cv=none; b=UcUGulx/zyvD9Rawsa1j17KDtesSDwiAKGiKprkAl0/K+HTUmRRTcKjrtdI4udyYMLV0L8tgTL3LsMZmTdLj3SLlDYMSMv5QtwCR+5o4s8mufpKgZ1t8rZUkyKOMTMWWsAYEiZi9GRhZIGMnZ/LtUO9tnuvTqS958YsSnaqnUAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733489585; c=relaxed/simple;
	bh=y0VIUwCi8/N4ph10yDOD/b8sjOJPAahtMDBwy8x/ljI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=hfAGPKd5IMu+n3I8pvaayx43gIHB+RP2IdSmUldErwdfYDtIDUWnPMJKkr2JaRmgYd4sa5YUPX5BMf5O8yXsGOx6qN56CW2innbgx0FPLVi7KbYfo4bifnFdEQc4Xzz9GUeWJw0lI5u6tXx1UTAJ8SUg7wFPiaXApNZOvdW/MCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=APm+a/HL; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20241206125300epoutp034205c3b21451518cfb990ebbe9aee370~Ol5a0TkRf2595325953epoutp03m
	for <io-uring@vger.kernel.org>; Fri,  6 Dec 2024 12:53:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20241206125300epoutp034205c3b21451518cfb990ebbe9aee370~Ol5a0TkRf2595325953epoutp03m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1733489580;
	bh=4OJNnJBnwH5AjkM8+6MaCQIawqKuE3Tt2t5ExJemeYU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=APm+a/HLcxur9e0N1hOPpn/p+A6jCuAAPpdBGOrvzplDFWqZPQOKqTlFg06GNBXwE
	 fUrD1QJLPfjk7MwbRdvWB9eLf1w5kGeKYu1T+kBQ7RsN/rPHJ2SLzKx8c+P3JM6Qsl
	 4IfEUN7CzJilfmPah57wp3ytjImObHibre5Zkx44=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20241206125259epcas5p38639ea186fdca74c41747a056eb5474f~Ol5aJWY6e3108231082epcas5p3h;
	Fri,  6 Dec 2024 12:52:59 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4Y4WQ14zLWz4x9Pt; Fri,  6 Dec
	2024 12:52:57 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	D1.92.29212.9A3F2576; Fri,  6 Dec 2024 21:52:57 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20241206091949epcas5p14a01e4cfe614ddd04e23b84f8f1036d5~Oi-S5sHXU0626906269epcas5p1c;
	Fri,  6 Dec 2024 09:19:49 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241206091949epsmtrp1f1c692623e4680623a5ad602cea05e40~Oi-S4rbEU0642506425epsmtrp1b;
	Fri,  6 Dec 2024 09:19:49 +0000 (GMT)
X-AuditID: b6c32a50-7ebff7000000721c-32-6752f3a91565
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	1A.2B.18729.5B1C2576; Fri,  6 Dec 2024 18:19:49 +0900 (KST)
Received: from ubuntu (unknown [107.99.41.245]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20241206091947epsmtip1092b8be5ed88966e574960ec54ce5b15~Oi-Q9uuRY0867508675epsmtip1_;
	Fri,  6 Dec 2024 09:19:47 +0000 (GMT)
Date: Fri, 6 Dec 2024 14:41:55 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Keith Busch <kbusch@meta.com>
Cc: axboe@kernel.dk, hch@lst.de, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, sagi@grimberg.me, asml.silence@gmail.com, Keith
	Busch <kbusch@kernel.org>
Subject: Re: [PATCHv11 07/10] block: expose write streams for block device
 nodes
Message-ID: <20241206091155.lems7wdnc4t5tvlf@ubuntu>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241206015308.3342386-8-kbusch@meta.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFJsWRmVeSWpSXmKPExsWy7bCmlu7Kz0HpBjPnKVnMWbWN0WL13X42
	i5WrjzJZvGs9x2Ix6dA1RoszVxeyWOy9pW2xZ+9JFov5y56yW6x7/Z7Fgctj56y77B7n721k
	8bh8ttRj06pONo/NS+o9dt9sYPM4d7HC4/MmuQCOqGybjNTElNQihdS85PyUzLx0WyXv4Hjn
	eFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKADlRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2
	SqkFKTkFJgV6xYm5xaV56Xp5qSVWhgYGRqZAhQnZGZeu/WMsWM1bcW/tWbYGxnXcXYycHBIC
	JhKrjv5l7mLk4hAS2MMocX7vdDYI5xOjxO2F16Ey3xglfu97zwTTcvBWG1TVXkaJswf6oJwn
	jBJdrzrBqlgEVCR6Jp1g7GLk4GAT0JY4/Z8DJCwioChxHhgKIDazwDNGiYWnYkBsYYEgiZub
	5rOC2LxAC97u+8oCYQtKnJz5BMzmFDCX6G6cyQiyS0JgKofE/q+PweZLCLhIXD1aBHGcsMSr
	41vYIWwpiZf9bVB2ucTKKSvYIHpbGCVmXZ/FCJGwl2g91c8McVCGxMrJt1gg4rISU0+tY4KI
	80n0/n4C9T2vxI55MLayxJr1C9ggbEmJa98b2SDu8ZCY8S0KEibbgcF45wLrBEa5WUj+mYVk
	HYRtJdH5oYl1FlA7s4C0xPJ/HBCmpsT6XfoLGFlXMUqlFhTnpqcmmxYY6uallsNjOTk/dxMj
	ONFqBexgXL3hr94hRiYOxkOMEhzMSiK8lWGB6UK8KYmVValF+fFFpTmpxYcYTYHxM5FZSjQ5
	H5jq80riDU0sDUzMzMxMLI3NDJXEeV+3zk0REkhPLEnNTk0tSC2C6WPi4JRqYOL+IdUT+D3Z
	8ozv7LVaDKGbUrZ/m++uLHMhwbhJ3iC9u7RbY8fXL3+4za7I2e378NSwIP3GqhN5E69tT3bj
	Evn+ff250+kFUVICHofUS0sunkhd0ejG0/j+Zfv88yfnLJxxV2LmMr2J1lF8mpIu17MtPZ49
	Ldgfqy+8Ltvbgk3htdNmoYnP9AwfnP5jfcR+tlFKy/NJ8w/xSKwKbNysdf/Mx+7O3/k+W+vv
	cPS1GH3Ze9hEY0FKbvqSVpeabQJnwsNP3VQ3+VShZNvntEhn44bpS4Xnq5xt4Nk8WyNgeU7W
	w9fxM92+b74tP8fr1IfFsbtXtf5k4JvM5jqh4OI3w9a70r6PmndV7u4q1RTul1RiKc5INNRi
	LipOBABn7+M3PQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsWy7bCSnO7Wg0HpBj8ma1vMWbWN0WL13X42
	i5WrjzJZvGs9x2Ix6dA1RoszVxeyWOy9pW2xZ+9JFov5y56yW6x7/Z7Fgctj56y77B7n721k
	8bh8ttRj06pONo/NS+o9dt9sYPM4d7HC4/MmuQCOKC6blNSczLLUIn27BK6MzunTWAvuclX8
	nn+YtYHxF0cXIyeHhICJxMFbbWxdjFwcQgK7GSWm3v3ACpGQlFj29wgzhC0ssfLfc3aIokeM
	Etsu7GMESbAIqEj0TDoBZHNwsAloS5z+DzZUREBR4jzQJSD1zALPGCV27VkBNkhYIEji5qb5
	YAt4gTa/3feVBcQWEkiWWN17gxEiLihxcuYTsDizgJnEvM0PmUHmMwtISyz/BzafU8Bcortx
	JuMERoFZSDpmIemYhdCxgJF5FaNkakFxbnpusWGBYV5quV5xYm5xaV66XnJ+7iZGcHxoae5g
	3L7qg94hRiYOxkOMEhzMSiK8lWGB6UK8KYmVValF+fFFpTmpxYcYpTlYlMR5xV/0pggJpCeW
	pGanphakFsFkmTg4pRqY6tff+e7Ft0fb/JkuZ4e34Iv0SYt5aj5sLTcp07/89KuFj7V+3B3/
	ZTmaZx2ZNGUKt96PUqvIPlvxTVk+3/rFY8Gv+4+EbL5svPz207dHXr47bSB8vWL/+/AHtz+r
	uGWZP5DVzE/Y1+R6mPXexnTd412LA9d2vn5cqr5EVXuXz2vvHVJnv0hsWl08rzKg5NAO4Yjp
	XK4iFn/kn8xcaCXY5TH/0eyK7B+Pt/z4YJYTFn42Sf7A92Wsmw5Itu8t01tzv9k0/HANs3pz
	65tejZ9xO3jyP3RME5xoH9Jy6/XUuSxBPeJzD+7LZgxt/H364LrTkqWFB2L9i5Pzrp078W/5
	1OwXQmIe4g2V1ZwWdzfwKbEUZyQaajEXFScCABCLxzD+AgAA
X-CMS-MailID: 20241206091949epcas5p14a01e4cfe614ddd04e23b84f8f1036d5
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----x2Ox1x5iNi7PYvDn9sIpGVgpr3_-t8l_a8xeGFysXFeU9Shi=_633c9_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241206091949epcas5p14a01e4cfe614ddd04e23b84f8f1036d5
References: <20241206015308.3342386-1-kbusch@meta.com>
	<20241206015308.3342386-8-kbusch@meta.com>
	<CGME20241206091949epcas5p14a01e4cfe614ddd04e23b84f8f1036d5@epcas5p1.samsung.com>

------x2Ox1x5iNi7PYvDn9sIpGVgpr3_-t8l_a8xeGFysXFeU9Shi=_633c9_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 05/12/24 05:53PM, Keith Busch wrote:
>From: Christoph Hellwig <hch@lst.de>
>
>Export statx information about the number and granularity of write
>streams, use the per-kiocb write hint and map temperature hints to write
>streams (which is a bit questionable, but this shows how it is done).
>
>Signed-off-by: Christoph Hellwig <hch@lst.de>
>Signed-off-by: Keith Busch <kbusch@kernel.org>
>---
> block/bdev.c |  6 ++++++
> block/fops.c | 23 +++++++++++++++++++++++
> 2 files changed, 29 insertions(+)
>
>diff --git a/block/bdev.c b/block/bdev.c
>index 738e3c8457e7f..c23245f1fdfe3 100644
>--- a/block/bdev.c
>+++ b/block/bdev.c
>@@ -1296,6 +1296,12 @@ void bdev_statx(struct path *path, struct kstat *stat,
> 		stat->result_mask |= STATX_DIOALIGN;
> 	}
>
>+	if ((request_mask & STATX_WRITE_STREAM) &&
Need to remove a check for at the start of the function for this to
work,
something like this,
-	if (!(request_mask & (STATX_DIOALIGN | STATX_WRITE_ATOMIC)))
+	if (!(request_mask & (STATX_DIOALIGN | STATX_WRITE_ATOMIC |
+		STATX_WRITE_STREAM)))
		return;


>+	    bdev_max_write_streams(bdev)) {
>+		stat->write_stream_max = bdev_max_write_streams(bdev);
I think write_stream_granularity needs to be added.
stat->write_stream_granularity = bdev_write_stream_granularity(bdev); 

Otherwise, patch looks good to me.

--Nitesh Shetty

------x2Ox1x5iNi7PYvDn9sIpGVgpr3_-t8l_a8xeGFysXFeU9Shi=_633c9_
Content-Type: text/plain; charset="utf-8"


------x2Ox1x5iNi7PYvDn9sIpGVgpr3_-t8l_a8xeGFysXFeU9Shi=_633c9_--

