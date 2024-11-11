Return-Path: <io-uring+bounces-4605-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CF1749C3C78
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 11:54:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 60A731F21B91
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 10:54:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA9EE17BECA;
	Mon, 11 Nov 2024 10:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="QYYZBskt"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F70716F85E
	for <io-uring@vger.kernel.org>; Mon, 11 Nov 2024 10:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731322459; cv=none; b=VkqXPRImwGyMyYI5yBcjnxFTwjOF6C6xYNfmvrwgVSi8RXVCE/FSyX6kmKwsHxYFg7ekT1a/9EKH+yxfTHiLOpTf4hkrQ8G+xJS8MVVTjzSm4tOeHiOQXBlRq5rpiQUpp7sUFUgTDL32I4/eFL8HufbkFP4RhDOwgcO6A4e3ldc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731322459; c=relaxed/simple;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=j1oRXgTdD4qMuDkmYNm70P/Gp8SG3RoUa1tKkMmdvz98HcVb3NHfLp/q1Vp2ViLupMVAkZyDVa29HOvwoYKO1Wu9IUcUxTV8hHjwCAPpdEmQ1IS1r9dtWilH5zar338QcIB/22+5SPwKvAfcg1OLCegURgD7lJ+6Ci+LJeiO4Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=QYYZBskt; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20241111105414epoutp045ba57383b88f69b06a3591fb57c7a89d~G5JlYNAXm1467414674epoutp04N
	for <io-uring@vger.kernel.org>; Mon, 11 Nov 2024 10:54:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20241111105414epoutp045ba57383b88f69b06a3591fb57c7a89d~G5JlYNAXm1467414674epoutp04N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1731322454;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=QYYZBsktv+FFHFO7nRxEX+M7vh4spdOnG2stfCC73noJyBB8HsM6YkK9ZEl51cZbk
	 g1wNQTlUeC+xuLy8A6yQn33TsCGipUCZBdmyT5tVnnjb+PUfSQ8T206THymp2yDveE
	 5WuEFcNJOH7op8zAGpYrjGebHCF2+ahuna4yY1u0=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20241111105413epcas5p40ac0c0b4294c656e9f6b9e5edbc32fbe~G5JlBPAJY0296302963epcas5p4p;
	Mon, 11 Nov 2024 10:54:13 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.178]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Xn5yX5ltFz4x9Pv; Mon, 11 Nov
	2024 10:54:12 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	63.DB.09770.452E1376; Mon, 11 Nov 2024 19:54:12 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20241111105411epcas5p33c0c3b2b5da9f4f99a9a1d7e380f19c4~G5JjOzfVq1534015340epcas5p3d;
	Mon, 11 Nov 2024 10:54:11 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241111105411epsmtrp25b20e0a7577eee93b1463d3c605992c3~G5JjOJLCF2714727147epsmtrp2A;
	Mon, 11 Nov 2024 10:54:11 +0000 (GMT)
X-AuditID: b6c32a4a-bbfff7000000262a-f5-6731e2540ab9
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	66.C3.18937.352E1376; Mon, 11 Nov 2024 19:54:11 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241111105410epsmtip29be05bad76cb60251375689263e2df20~G5JiPkZt22580325803epsmtip2h;
	Mon, 11 Nov 2024 10:54:10 +0000 (GMT)
Message-ID: <75a9ed93-5a05-4135-a223-5779fd4b190d@samsung.com>
Date: Mon, 11 Nov 2024 16:24:09 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/uring_cmd: fix buffer index retrieval
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc: Guangwu Zhang <guazhang@redhat.com>, Jeff Moyer <jmoyer@redhat.com>
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20241111101318.1387557-1-ming.lei@redhat.com>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmk+LIzCtJLcpLzFFi42LZdlhTSzfkkWG6wdTHuhZzVm1jtFh9t5/N
	YsmV3SwW71rPsVic/XWVxeLQ5GYmBzaPnbPusntcPlvq8X7fVTaPz5vkAliism0yUhNTUosU
	UvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgHYrKZQl5pQChQISi4uV
	9O1sivJLS1IVMvKLS2yVUgtScgpMCvSKE3OLS/PS9fJSS6wMDQyMTIEKE7IzTu1YylRgVHFt
	bh9TA6NuFyMnh4SAicT8pysZuxi5OIQEdjNKXPi+kgnC+cQoMWn5CxY4Z/e6KUwwLZfWbQaz
	hQR2Mkrcf+0OUfSWUWLHotOsIAleATuJpw17wGwWAVWJzifTGSHighInZz5hAbFFBeQl7t+a
	wQ5iCws4S+ye2AFWIyLQyigx9YtcFyMHB7OAu8TDp1kgYWYBcYlbT+YzgYTZBDQlLkwuBQlz
	ClhLrFzbzAZRIi+x/e0cZpBzJAS+sku8fPyKDeJmF4llm3+xQ9jCEq+Ob4GypSQ+v9sLVZMt
	8eDRAxYIu0Zix+Y+VgjbXqLhzw1WiHM0Jdbv0ofYxSfR+/sJ2DkSArwSHW1CENWKEvcmPYXq
	FJd4OGMJK0SJh8S3vgpIQPUxSjxru8gygVFhFlKYzELy5Cwk38xCWLyAkWUVo2RqQXFuemqx
	aYFRXmo5PK6T83M3MYJTpZbXDsaHDz7oHWJk4mA8xCjBwawkwqvhr58uxJuSWFmVWpQfX1Sa
	k1p8iNEUGDkTmaVEk/OByTqvJN7QxNLAxMzMzMTS2MxQSZz3devcFCGB9MSS1OzU1ILUIpg+
	Jg5OqQamvI/SK87d1Fgi31ZzYfNM7XksC1f++WQmUvxj0VvjlyuLZKcfnBWV1WfvtJ0/wTCs
	+OP3YOUdj6p2uaTumzBppXZ4Ey/H0hz2xYkbnc5dduRIutJ5p+O4zLadQe3/rZlWiq7+t+jN
	z1sbOLOWtFYsuP0o72lFSZrrgr2x882i2N2KWOXnuno+//U6yzxP7bvGLeb6mKdPzlgoR2Sx
	tf2YqnfmdMPTxg/POlrS7L2ZPnRcXDDz77FfKntz3jBGrlxcK8Ucbyjpb5u/8a31lA7bl39c
	M574qrRWByYI2TW76Fmqb+M2OhVx8tPl1k3BKb/nbizdX8XEJVk005z3xv1KDm3ea3u+C7s3
	bGxtNluqxFKckWioxVxUnAgAu3MXXx4EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsWy7bCSvG7wI8N0gylH1SzmrNrGaLH6bj+b
	xZIru1ks3rWeY7E4++sqi8Whyc1MDmweO2fdZfe4fLbU4/2+q2wenzfJBbBEcdmkpOZklqUW
	6dslcGWc2rGUqcCo4trcPqYGRt0uRk4OCQETiUvrNjN1MXJxCAlsZ5TYf/YRC0RCXKL52g92
	CFtYYuW/5+wQRa8ZJXqOPwUr4hWwk3jasIcVxGYRUJXofDKdESIuKHFy5hOwGlEBeYn7t2aA
	DRIWcJbYPbGDEWSQiEAro8SxFReAmjk4mAXcJR4+zYJY0McoMbX3PBNIAzPQFbeezGcCqWET
	0JS4MLkUJMwpYC2xcm0zG0SJmUTX1i5GCFteYvvbOcwTGIVmITljFpJJs5C0zELSsoCRZRWj
	aGpBcW56bnKBoV5xYm5xaV66XnJ+7iZGcFRoBe1gXLb+r94hRiYOxkOMEhzMSiK8Gv766UK8
	KYmVValF+fFFpTmpxYcYpTlYlMR5lXM6U4QE0hNLUrNTUwtSi2CyTBycUg1Mu7w1WdW9FkqF
	7TvSdjT90Uum0z+9pzQIrn++JmGV+Ic3ZVO6lxXMSVOdP5Wd5cv+SeFcK/gntMzdPbew727S
	50at11MV2YSO7zzq9+v0/OU6d9qn2cyRrUtUKFMpEtO3Xdh1i+3nlwMT5SbpnA449nfXEW8j
	A5WMhZGHff9IHpJ5efdIqNG889qHev7kfrZNuHrveJiWU3SvFi/XpIdGr61mbazrbPOpZ1AW
	Cq96dPSs9Ty9DZmRublZkcW3f3++x5nl8veNd8xihv680MkrtY3L7mtITXlwjfPt10stpWGL
	+X1YA+enlG79a3RRZOGvaz9fxt+vWr/1+YmJRp5d6pY+i//KXOeNz/aWd190RomlOCPRUIu5
	qDgRAAdmXDf5AgAA
X-CMS-MailID: 20241111105411epcas5p33c0c3b2b5da9f4f99a9a1d7e380f19c4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241111101340epcas5p1a52121e40ddaa3377201ed3727f0e0fc
References: <CGME20241111101340epcas5p1a52121e40ddaa3377201ed3727f0e0fc@epcas5p1.samsung.com>
	<20241111101318.1387557-1-ming.lei@redhat.com>

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>

