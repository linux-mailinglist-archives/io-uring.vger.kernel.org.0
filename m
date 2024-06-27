Return-Path: <io-uring+bounces-2374-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B992991AF82
	for <lists+io-uring@lfdr.de>; Thu, 27 Jun 2024 21:13:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5AE88B22697
	for <lists+io-uring@lfdr.de>; Thu, 27 Jun 2024 19:13:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16D8E19D06D;
	Thu, 27 Jun 2024 19:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="WRe2XyF/"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E808C19B5AB
	for <io-uring@vger.kernel.org>; Thu, 27 Jun 2024 19:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719515571; cv=none; b=itDwwxG+uQXcE0Mqempm0vRZ5jY87ZEGM4XhZKsqxj9+t2ea7vwB+bT32jaTE6KAAZvDlmdy/yYp/Se4iMCJPLGxnC9TF0KhgUoIl/n0z53OCQS4nKhCJpjosBn/vsL2ou3PVgEPpH3VsujDUdaQtxS/Fq7px4UTkHcT9CpaMkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719515571; c=relaxed/simple;
	bh=7947z4N3Xt6MPRRyYa0MU/Z+XbBd5jCQ01H98uUj5nA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=MFPFnKdFXRrlqc4m4pFBXa43azxvpYR+/UXiEHqaEx6UjnsaxcIv21VeSaakkss+O2ZX1XOi44tOBE5MxOqmhwIqWAg2WqL7P0yFgIKDREQtE359QlLVBFrFMQxI3Sirtfq5741Fy0MlmKn0azp1DDtH2nfgaw7UqF/H3nbG9i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=WRe2XyF/; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240627191236epoutp02591d327fd20b71cf0b9c6e53d4339a89~c8knXguz92554925549epoutp02G
	for <io-uring@vger.kernel.org>; Thu, 27 Jun 2024 19:12:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240627191236epoutp02591d327fd20b71cf0b9c6e53d4339a89~c8knXguz92554925549epoutp02G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1719515556;
	bh=VFJ+R0W4VBM/ZPRO2/oEWy6H0wpUpaesLbI39eTznDs=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=WRe2XyF/7Tgu7gnWgllcghdMumCvGGjieBGAQQQlDbDoxhG46Kjl0+AtOk5ufRWsh
	 e7fnQQfxUkaPYBm7jiyjcXnixJdKKiSiqfB+5hZScvaRoDqHXbHTIXmBbi3y0d1gVJ
	 vYGP+RDA5PnJBOuJ3LnZhk2ek29oW13uDdBxS5F8=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240627191236epcas5p3cd1df03377d81b907f9895527a1d766a~c8kmySVQe2544125441epcas5p3Q;
	Thu, 27 Jun 2024 19:12:36 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.178]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4W97Vp1mNSz4x9Pr; Thu, 27 Jun
	2024 19:12:34 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	FA.92.06857.2A9BD766; Fri, 28 Jun 2024 04:12:34 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240627191233epcas5p229cce8f33030fcc4514ea68c81e317f7~c8kkcqO8u0834308343epcas5p2q;
	Thu, 27 Jun 2024 19:12:33 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240627191233epsmtrp14e3ffbcad4219ce52526dda9bc5d2d3a~c8kkcFA6k3020330203epsmtrp1u;
	Thu, 27 Jun 2024 19:12:33 +0000 (GMT)
X-AuditID: b6c32a4b-ae9fa70000021ac9-57-667db9a24ced
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	8A.54.18846.1A9BD766; Fri, 28 Jun 2024 04:12:33 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240627191231epsmtip1ff21b5a86114e5f783ab7db6288e320a~c8kizCYsb0661406614epsmtip1C;
	Thu, 27 Jun 2024 19:12:31 +0000 (GMT)
Message-ID: <05eee4ff-c821-f285-ea2f-375c0cf4ac6a@samsung.com>
Date: Fri, 28 Jun 2024 00:42:30 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
	Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH v2 00/10] Read/Write with meta/integrity
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Anuj Gupta <anuj20.g@samsung.com>
Cc: asml.silence@gmail.com, mpatocka@redhat.com, axboe@kernel.dk,
	kbusch@kernel.org, martin.petersen@oracle.com, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20240627060542.GA15865@lst.de>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNJsWRmVeSWpSXmKPExsWy7bCmlu6inbVpBosvcVo0TfjLbDFn1TZG
	i9V3+9ksVq4+ymTxrvUci8WkQ9cYLfbe0raYv+wpu8Xy4/+YLCZ2XGVy4PLYOesuu8fls6Ue
	m1Z1snlsXlLvsftmA5vHx6e3WDze77vK5tG3ZRWjx+dNcgGcUdk2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBnKimUJeaUAoUCEouLlfTtbIryS0tS
	FTLyi0tslVILUnIKTAr0ihNzi0vz0vXyUkusDA0MjEyBChOyM6Zuec9ccIW5Yv3PKSwNjP+Y
	uhg5OSQETCSmPtwLZHNxCAnsZpT4176DGcL5xCjx8dEzRjhnysmb7DAtDzt3s0IkdjJK9K/7
	BNX/llHiy+JrzCBVvAJ2Em0NrUBVHBwsAqoSK54YQIQFJU7OfMICYosKJEv87DrABmILC9hI
	HN52EGwBs4C4xK0n88HuExFwlTj14CLYScwCpxgluvtmsoHMZBPQlLgwuRSkhlNAR6Jrz06o
	XnmJ7W/ngNVLCGzhkHh8cxEbxNUuEldWz2aFsIUlXh3fAvWNlMTL/jYoO1viwaMHLBB2jcSO
	zX1Q9fYSDX9ugP3CDLR3/S59iF18Er2/nzCBhCUEeCU62oQgqhUl7k16CtUpLvFwxhIo20Pi
	8LMn0KBawyhxfMtlxgmMCrOQgmUWkvdnIXlnFsLmBYwsqxglUwuKc9NTi00LjPNSy+ERnpyf
	u4kRnIq1vHcwPnrwQe8QIxMH4yFGCQ5mJRHe0JKqNCHelMTKqtSi/Pii0pzU4kOMpsDomcgs
	JZqcD8wGeSXxhiaWBiZmZmYmlsZmhkrivK9b56YICaQnlqRmp6YWpBbB9DFxcEo1MD2d8fbB
	VI3P7+Il7CUjG3RMZUS+rT98hSPW5CXPF71rbxbNt/lcKnvyW51T2oxpzIev3Pn960LMv16x
	TeEfvsx3WX/i2rJvCpuyme5fc/+z7h//0YUTj67YczXv3ycDM65Hn5bfTFzpcebP2W38KfZM
	/0Xe+v57Zbaqq0B/WY6ckzbrIjvHb7fOfVQJqkmbnubE0/xtRsmRnQ84bqYu2hiRt/r9Hm9z
	vuvRd81DLt165HxrYeBpg7q3j747dt96wxJiO+GYr8XGtoMd7v2z71yPrSyyV7iadewia+IK
	kzmJMuc0srcH39MWmrqiUnB17LXJfifnTAlgiOE5nna1KEL/ZtH25cozlk7dxPV6sfl5OSWW
	4oxEQy3mouJEAGBwSFlOBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsWy7bCSnO7CnbVpBhcmSVk0TfjLbDFn1TZG
	i9V3+9ksVq4+ymTxrvUci8WkQ9cYLfbe0raYv+wpu8Xy4/+YLCZ2XGVy4PLYOesuu8fls6Ue
	m1Z1snlsXlLvsftmA5vHx6e3WDze77vK5tG3ZRWjx+dNcgGcUVw2Kak5mWWpRfp2CVwZU7e8
	Zy64wlyx/ucUlgbGf0xdjJwcEgImEg87d7N2MXJxCAlsZ5T43NHPCpEQl2i+9oMdwhaWWPnv
	OTtE0WtGiWMHz4B18wrYSbQ1tAI1cHCwCKhKrHhiABEWlDg58wkLiC0qkCzx8s9EsDnCAjYS
	h7cdBLOZgebfejIfbIyIgKvEqQcXmUHmMwucYpTY2XCOBWLZGkaJR4vmgS1gE9CUuDC5FKSB
	U0BHomvPTqhBZhJdW7sYIWx5ie1v5zBPYBSaheSOWUj2zULSMgtJywJGllWMoqkFxbnpuckF
	hnrFibnFpXnpesn5uZsYwfGmFbSDcdn6v3qHGJk4GA8xSnAwK4nwhpZUpQnxpiRWVqUW5ccX
	leakFh9ilOZgURLnVc7pTBESSE8sSc1OTS1ILYLJMnFwSjUwrbU/bZNqIvVCeeU9B+/nl4tX
	HdRXsmFN6jzS+vyRTsDpx+qmX3o3yi7uuzG7ddZ2/ifZgU3H5+uIaR6PKd/E4pHo5Fwf0XV5
	UXyU+Nd6/iDFKKMLWx5ucOGz/2xXfNSJpbZg6pW34vXRX3lS6x9Em/uz/PxqdLLrwvLlWWd/
	WayVfmT+y1P6tAoro7i4Ods8uUVRTgrfvhXHzg/NNPoyX+DofOPafX0XwmwWznxoe3RR60Mp
	h50M4mxTfxqu3eh78/TXr6evvT++YvumAxe0Vvddzzrveq7mMqPgNDlXzrrMWS2zJupKO/6+
	vVhu5/89Mb6aB70XylZerwtuqtT7wCQ5rVSX9WL/3371gqtBSizFGYmGWsxFxYkATT7OsSYD
	AAA=
X-CMS-MailID: 20240627191233epcas5p229cce8f33030fcc4514ea68c81e317f7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240626101415epcas5p3b06a963aa0b0196d6599fb86c90bc38c
References: <CGME20240626101415epcas5p3b06a963aa0b0196d6599fb86c90bc38c@epcas5p3.samsung.com>
	<20240626100700.3629-1-anuj20.g@samsung.com> <20240627060542.GA15865@lst.de>

On 6/27/2024 11:35 AM, Christoph Hellwig wrote:
> What tree does this apply to?  There's quite a few rejects vs
> for-6.11/block.
> 

Jens for-next. On top of:

commit f078c063b954085cfa185aea2be6a836529d04fc
Author: Christoph Hellwig <hch@lst.de>
Date:   Mon Jun 24 19:38:35 2024 +0200

     block: fix the blk_queue_nonrot polarity

And as mentioned in cover letter, a tree is available here:
https://github.com/SamsungDS/linux/commits/feat/pi_us_v2/

