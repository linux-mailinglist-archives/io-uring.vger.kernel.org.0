Return-Path: <io-uring+bounces-6250-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CE5A2A26F9A
	for <lists+io-uring@lfdr.de>; Tue,  4 Feb 2025 11:53:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 694A21886DC3
	for <lists+io-uring@lfdr.de>; Tue,  4 Feb 2025 10:54:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FDE420B7F3;
	Tue,  4 Feb 2025 10:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Cilpea9s"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AD82036FB
	for <io-uring@vger.kernel.org>; Tue,  4 Feb 2025 10:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738666429; cv=none; b=g+uK5h0mGl/IDMKOiu291GHopGo+HvT4cxnsec+T9Xtoo9V1uuA0n/gAty8AwPXyxTpUD7T8v7q410S0SN5bUubCJ5xRJJFarHykgdT3S2SNswvnn3Xn70pFukOr2C1UNybBN48wshNZBc5quMCXSCLv20fAWurD42VWe71zLVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738666429; c=relaxed/simple;
	bh=5IY+P5cvvOpmoevl77jfAm+Tjt6iQdqDrk+JprcVQc0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=bTNNWKqmH1L2qU513m8SKW+mAskxbETqCErZg0ejqFsfq4+7weus7YtQGLr38ffCXV5G1D/gInRdsdNMIjZ1OyCa14XuNK6gcszfI56pRX0quOIPnxUWZKIazlDaR2/vPzZxTiXR1SHyJGPUwJoH4Ft7YxAdsSXkUTKDOiUfMgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Cilpea9s; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250204105343epoutp0183908c4ff2c4b8a437377158817d8005~g__aS2AyG0602806028epoutp01k
	for <io-uring@vger.kernel.org>; Tue,  4 Feb 2025 10:53:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250204105343epoutp0183908c4ff2c4b8a437377158817d8005~g__aS2AyG0602806028epoutp01k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1738666423;
	bh=5IY+P5cvvOpmoevl77jfAm+Tjt6iQdqDrk+JprcVQc0=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=Cilpea9sF1PlRXlcCfvvkHw/HsIREfS18FMxMMu3PVHH3HpT+MmKZJb4W+Wkae3Fb
	 SKatJaTVQjexZUtVFbcYUDSw9AjVxhQkAKNEWthKtXXKBGhiRzMoRnN64QN8vJQZbi
	 KhsBzvvhWXI0nLHzptNnTXYssEELQUDM55trVsEA=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20250204105343epcas5p22c70911c1350040eb7811b81f28b2eb7~g__Z7Nm_j1951519515epcas5p2C;
	Tue,  4 Feb 2025 10:53:43 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4YnKwj0vQLz4x9QC; Tue,  4 Feb
	2025 10:53:41 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	7F.FF.19956.4B1F1A76; Tue,  4 Feb 2025 19:53:40 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250204105340epcas5p2d1e3cdd81a6a7f8d1f6b024c8e6f5cc0~g__XYZzOx1263412634epcas5p2b;
	Tue,  4 Feb 2025 10:53:40 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250204105340epsmtrp1e06af5afd505e400e0e2fe38febe3194~g__XXuceC0308503085epsmtrp1r;
	Tue,  4 Feb 2025 10:53:40 +0000 (GMT)
X-AuditID: b6c32a4b-fd1f170000004df4-5b-67a1f1b421bb
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	C0.CC.18729.4B1F1A76; Tue,  4 Feb 2025 19:53:40 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250204105333epsmtip1faa77cbe5a0c3ca9bcaf28eba0c6db82~g__QfsJCz0166901669epsmtip1T;
	Tue,  4 Feb 2025 10:53:32 +0000 (GMT)
Message-ID: <94569e4b-f27a-425a-ad63-6a4f5bb4fb7d@samsung.com>
Date: Tue, 4 Feb 2025 16:23:31 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2 00/11] block write streams with nvme fdp
To: Keith Busch <kbusch@meta.com>, linux-nvme@lists.infradead.org,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, asml.silence@gmail.com, axboe@kernel.dk,
	hch@lst.de, sagi@grimberg.me, Keith Busch <kbusch@kernel.org>
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20250203184129.1829324-1-kbusch@meta.com>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMJsWRmVeSWpSXmKPExsWy7bCmlu6WjwvTDX722VjMWbWN0WL13X42
	i5WrjzJZvGs9x2Ix6dA1RoszVxeyWOy9pW2xZ+9JFov5y56yW6x7/Z7Fgctj56y77B7n721k
	8bh8ttRj06pONo/NS+o9dt9sYPM4d7HC4/MmuQCOqGybjNTElNQihdS85PyUzLx0WyXv4Hjn
	eFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKADlRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2
	SqkFKTkFJgV6xYm5xaV56Xp5qSVWhgYGRqZAhQnZGd8XnmQrKKjY9fwbUwNjbBcjJ4eEgInE
	krY7TF2MXBxCArsZJWZf6WKBcD4xSmx9eI8ZwvnGKLGg5wIjTMuGWcugqvYySjw8/QOq/y2j
	xNPzT1lBqngF7CRObDgB1sEioCLx6XU7C0RcUOLkzCdgtqiAvMT9WzPYQWxhoPoDS9Yyg9gi
	AlUSf/pXs4EMZRboZpQ4Mf8qE0iCWUBc4taT+UA2BwebgKbEhcmlIGFOAXOJh0t62CFK5CW2
	v50DdraEwBYOiWU/+5ghznaROLrqLxuELSzx6vgWdghbSuJlfxuUnS3x4NEDFgi7RmLH5j5W
	CNteouHPDVaQvcxAe9fv0ofYxSfR+/sJ2DkSArwSHW1CENWKEvcmPYXqFJd4OGMJK0SJh8T8
	qQmQoOpilLj1cxbbBEaFWUihMgvJk7OQfDMLYfECRpZVjJKpBcW56anFpgXGeanl8OhOzs/d
	xAhOvVreOxgfPfigd4iRiYPxEKMEB7OSCO/p7QvShXhTEiurUovy44tKc1KLDzGaAqNnIrOU
	aHI+MPnnlcQbmlgamJiZmZlYGpsZKonzNu9sSRcSSE8sSc1OTS1ILYLpY+LglGpguuo14f/V
	+ZP8b+59kX+x7Ljr01+df6Zr9y3p6mSdc/L4kcQe9UWm2s9u/GSK6xXoUF0wka9y7TSWQ2mv
	s54aST3Rc3cN5zF6cYX1h6eDc5FBVdYN3YUT7+5S98mKb/isanmhrfdZDcP+3AXHOnvf7roy
	R//g9VmfVVZ27Z5wU9JNKWjl7R/1t3cJyUudrmrKvfElfKusZuQHl85jcleeWbF5LptXuoN/
	UxFvX6pUDu//7Y4dc77U/X9oybWhVWj2Jhev0inb/xbZvF2RJDr1sqn/ihN+8R/5ne04G3qO
	/f+iLpVxd2e8x5387Tm8IZLCl7X2SbNVnQx0y2OV4cvXtP6vUsZuUnV1qvTMc+c1lFiKMxIN
	tZiLihMBnv+K/EYEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsWy7bCSnO6WjwvTDV5PUrWYs2obo8Xqu/1s
	FitXH2WyeNd6jsVi0qFrjBZnri5ksdh7S9tiz96TLBbzlz1lt1j3+j2LA5fHzll32T3O39vI
	4nH5bKnHplWdbB6bl9R77L7ZwOZx7mKFx+dNcgEcUVw2Kak5mWWpRfp2CVwZ3xeeZCsoqNj1
	/BtTA2NsFyMnh4SAicSGWctYuhi5OIQEdjNK7Ll6gAkiIS7RfO0HO4QtLLHy33N2iKLXjBKv
	Hh0DK+IVsJM4seEEI4jNIqAi8el1OwtEXFDi5MwnYLaogLzE/VszwAYJA9UfWLKWGcQWEaiS
	ePn1OxvIUGaBbkaJXW0TmSE2dDFKLD3ZwgZSxQx0xq0n84G2cXCwCWhKXJhcChLmFDCXeLik
	hx2ixEyia2sXI4QtL7H97RzmCYxCs5DcMQvJpFlIWmYhaVnAyLKKUTK1oDg3PbfYsMAwL7Vc
	rzgxt7g0L10vOT93EyM40rQ0dzBuX/VB7xAjEwfjIUYJDmYlEd7T2xekC/GmJFZWpRblxxeV
	5qQWH2KU5mBREucVf9GbIiSQnliSmp2aWpBaBJNl4uCUamCa3i/7oLq60EVt+ZHWKTNEulff
	E11x2UhPR+aY9/aVzwKD4iTyX16Mb9w8fZvsSo6Tfy2DI27sNC2NtllyaFPaamFWbja+vM+X
	Vsws8JiT8f3Z1B3K/HoztNgTPq4yWr1fXrIiNvMEb2Jx755W8752t1u73ARl5T9bHGhje6l5
	SDmq80hGwFW+N5dmvltQyuxV9GKD5WKVh8L8B5Zfn7jwIqtovajQLa+/fIotXdoHF+f9uz8t
	5FBypiRfpfuJSukqyzbLE/s4/vcd01ls63PlYO3PvtteS/4pTP706MDG3TUCZ1eZr3i45Eem
	zeIELT+TtyKsQp6nfaZNeLtpWlDfz8XnzeY7zDQxvFu+tC5ViaU4I9FQi7moOBEAyrv6DyMD
	AAA=
X-CMS-MailID: 20250204105340epcas5p2d1e3cdd81a6a7f8d1f6b024c8e6f5cc0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250203201839epcas5p3b6f5bc0331202b3248431b338267bfb1
References: <CGME20250203201839epcas5p3b6f5bc0331202b3248431b338267bfb1@epcas5p3.samsung.com>
	<20250203184129.1829324-1-kbusch@meta.com>

I remember doing this but maybe twice is better than once:

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>

