Return-Path: <io-uring+bounces-90-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EFDCF7EBCF8
	for <lists+io-uring@lfdr.de>; Wed, 15 Nov 2023 07:18:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 54BDA28122E
	for <lists+io-uring@lfdr.de>; Wed, 15 Nov 2023 06:18:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85F202E852;
	Wed, 15 Nov 2023 06:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="aChfjniE"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E127E
	for <io-uring@vger.kernel.org>; Wed, 15 Nov 2023 06:18:32 +0000 (UTC)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D11F691
	for <io-uring@vger.kernel.org>; Tue, 14 Nov 2023 22:18:30 -0800 (PST)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20231115061827epoutp043ea11931d4a4b7cb9975a840dd8d04e0~Xt3c3wYWg3036330363epoutp04W
	for <io-uring@vger.kernel.org>; Wed, 15 Nov 2023 06:18:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20231115061827epoutp043ea11931d4a4b7cb9975a840dd8d04e0~Xt3c3wYWg3036330363epoutp04W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1700029107;
	bh=YGxpvlBqNQM9MsqJVYi3A3c96snWF3Vr/cT5kcqMZds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aChfjniE1cNYwEbyF9dP8nvwkdq/WvfEkrx5OoQaxF42b56uc79x758StxgOYlACv
	 saG5ZN0NHvfz/HOd4HbAMgM6Ol/q64cIUXMZdishTRk8igcolz22uNd/JXHOYMrjVT
	 IF8IdkrSVsvjRQF/T9N0jHVIwLR3GklnvmHoNKzA=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20231115061826epcas5p20ea1c14640f892d2f4234c76d639bebe~Xt3cjEAT91683316833epcas5p23;
	Wed, 15 Nov 2023 06:18:26 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4SVXzN3MVqz4x9Pr; Wed, 15 Nov
	2023 06:18:24 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	2C.12.10009.0B264556; Wed, 15 Nov 2023 15:18:24 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20231115061813epcas5p2bb6bebb451c6e2c65a5e9ec9ffac5f46~Xt3QehV4x1683316833epcas5p26;
	Wed, 15 Nov 2023 06:18:13 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20231115061813epsmtrp13aa58f2ba87b4d1c294f2d9d15845f97~Xt3QdsMiP0042000420epsmtrp1k;
	Wed, 15 Nov 2023 06:18:13 +0000 (GMT)
X-AuditID: b6c32a4a-261fd70000002719-c0-655462b08a63
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	C9.23.07368.5A264556; Wed, 15 Nov 2023 15:18:13 +0900 (KST)
Received: from AHRE124.. (unknown [109.105.118.124]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20231115061812epsmtip237bc955a4ddae7d55d2e50354bd31b45~Xt3Pc5rFT2685526855epsmtip2K;
	Wed, 15 Nov 2023 06:18:12 +0000 (GMT)
From: Xiaobing Li <xiaobing.li@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org, kun.dou@samsung.com,
	peiwei.li@samsung.com, joshi.k@samsung.com, kundan.kumar@samsung.com,
	wenwen.chen@samsung.com, ruyi.zhang@samsung.com, xiaobing.li@samsung.com
Subject: Re: [PATCH v3] io_uring/fdinfo: remove need for sqpoll lock for
 thread/pid retrieval
Date: Wed, 15 Nov 2023 14:10:27 +0800
Message-Id: <20231115061027.20214-1-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <ffbbe596-c6a9-42ed-9156-e6d5c21eca9b@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJJsWRmVeSWpSXmKPExsWy7bCmpu6GpJBUg70fpCzmrNrGaLH6bj+b
	xbvWcywWR/+/ZbP41X2X0WLrl6+sFs/2clp8Ofyd3WLqlh1MFh0tlxkduDx2zrrL7nH5bKlH
	35ZVjB6fN8kFsERl22SkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4
	BOi6ZeYAnaOkUJaYUwoUCkgsLlbSt7Mpyi8tSVXIyC8usVVKLUjJKTAp0CtOzC0uzUvXy0st
	sTI0MDAyBSpMyM74NuMRW8Er9oqbi/ezNDBOZOtiZOeQEDCRmKffxcjFISSwm1Fi7/mTTBDO
	J0aJy0tmsEM43xglNv2dBNTACdbw5Ng6NojEXkaJP8tmQ1W9ZJQ43LiSEaSKTUBb4vq6LlYQ
	W0RAWGJ/RysLSBGzwF1GiUcLWsCKhAXiJY7NOQZWxCKgKnFo/Q8WEJtXwEbi6r0FLBDr5CX2
	HzzLDGJzCthK9DZOZoeoEZQ4OfMJWA0zUE3z1tnMIAskBL6yS6ycfBGq2UVi1cYpULawxKvj
	W9ghbCmJl/1tUHaxxJGe76wQzQ2MEtNvX4VKWEv8u7IHqJkDaIOmxPpd+hBhWYmpp9YxQSzm
	k+j9/YQJIs4rsWMejK0qsfrSQ6i90hKvG35DxT0kdt/ZAA27CYwSX7dPZZ/AqDALyUOzkDw0
	C2H1AkbmVYySqQXFuempxaYFRnmp5fBoTs7P3cQITqNaXjsYHz74oHeIkYmD8RCjBAezkgiv
	uVxIqhBvSmJlVWpRfnxRaU5q8SFGU2CIT2SWEk3OBybyvJJ4QxNLAxMzMzMTS2MzQyVx3tet
	c1OEBNITS1KzU1MLUotg+pg4OKUamGSFi3/v5P1VvMdWeX9ivfirlhj+pJ6E37vKud7fKt4n
	ssnpTs1m84eeyozvtwq9j5HaWmGz0I5P4HfBs+5zRisPLWMvtBVmucJzIihS7knogpgvP243
	uGWfYjm04mz5JK8tjlKLHLb2HMx8dc7uaKel7v2o+AMP1xv1vLT50856oOPVdEW/j9bxBxvc
	FvRJp+zyF+lOcl4dnS546cyn2HddjYLzPz9gSUn+aT7dzChlfh6T4t6z7jf5Lnh6NM/JmiYT
	8lzq8kH/I7K+Z7cqFTVb7GCJ3Gh0eJ2To9duN95+O7Xamcoygfcc6md6M7tdnKVnfVCwNfxe
	dj9zklbtlaOyblzxu93vc9hOYy5WYinOSDTUYi4qTgQAiwGI9CwEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsWy7bCSvO7SpJBUg52/VSzmrNrGaLH6bj+b
	xbvWcywWR/+/ZbP41X2X0WLrl6+sFs/2clp8Ofyd3WLqlh1MFh0tlxkduDx2zrrL7nH5bKlH
	35ZVjB6fN8kFsERx2aSk5mSWpRbp2yVwZXyb8Yit4BV7xc3F+1kaGCeydTFyckgImEg8ObYO
	yObiEBLYzShx+O8qxi5GDqCEtMSfP+UQNcISK/89Z4eoec4ocfP0Z3aQBJuAtsT1dV2sILYI
	UNH+jlYWkCJmgZeMEjt/XWcBGSQsECtx+UcpSA2LgKrEofU/WEBsXgEbiav3FrBALJCX2H/w
	LDOIzSlgK9HbOBlsvhBQzYauFVD1ghInZz4Bs5mB6pu3zmaewCgwC0lqFpLUAkamVYySqQXF
	uem5yYYFhnmp5XrFibnFpXnpesn5uZsYwUGupbGD8d78f3qHGJk4GA8xSnAwK4nwmsuFpArx
	piRWVqUW5ccXleakFh9ilOZgURLnNZwxO0VIID2xJDU7NbUgtQgmy8TBKdXAtFJoHpMcpzrv
	wnYDi69SN5Jk0mvDyvU6MtrPKHqGTHExCb1+0PrWQhXzzQ61wdm6517b1ma1yJgtnbntku/S
	Gw8P/pyy+pRmrO/8e+WZ87pThJ1kgrwbP1sceby/1Gz6rL72v1OmxKrbBXV2/nhtvizj2yTV
	y3fjDI+1Hg11jq1I3Dmjs9yaWyuUw//gWqfLjstELnLn/Lgu52u6c5HerIerJzid0mg//zJ4
	UUNSx48D/RMv1Sie+T/Zqnvtx661lk5re+/P3LlAKUN3un1tXPYsY+PT1r8FL9kptnhd/GSX
	G9tu/XPzNsP7DzZfsjc6eD9j75PqbN02nWW2Jb8u/z9eGG5yRGWV1vOCnxMNlViKMxINtZiL
	ihMBWvZF/+ECAAA=
X-CMS-MailID: 20231115061813epcas5p2bb6bebb451c6e2c65a5e9ec9ffac5f46
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20231115061813epcas5p2bb6bebb451c6e2c65a5e9ec9ffac5f46
References: <ffbbe596-c6a9-42ed-9156-e6d5c21eca9b@kernel.dk>
	<CGME20231115061813epcas5p2bb6bebb451c6e2c65a5e9ec9ffac5f46@epcas5p2.samsung.com>

On 11/15/23 2:36 AM, Jens Axboe wrote:
> 	if (has_lock && (ctx->flags & IORING_SETUP_SQPOLL)) {
> 		struct io_sq_data *sq = ctx->sq_data;
> 
>-		if (mutex_trylock(&sq->lock)) {
>-			if (sq->thread) {
>-				sq_pid = task_pid_nr(sq->thread);
>-				sq_cpu = task_cpu(sq->thread);
>-			}
>-			mutex_unlock(&sq->lock);
>-		}
>+		sq_pid = sq->task_pid;
>+		sq_cpu = sq->sq_cpu;
> 	}

There are two problems:
1.The output of SqThread is inaccurate. What is actually recorded is the PID of the parent process.
2. Sometimes it can output, sometimes it outputs -1.

The test results are as follows:
Every 0.5s: cat /proc/9572/fdinfo/6 | grep Sq
SqMask: 0x3
SqHead: 6765744
SqTail: 6765744
CachedSqHead:   6765744
SqThread:       -1
SqThreadCpu:    -1
SqBusy: 0%
-------------------------------------------
Every 0.5s: cat /proc/9572/fdinfo/6 | grep Sq
SqMask: 0x3
SqHead: 7348727
SqTail: 7348728
CachedSqHead:   7348728
SqThread:       9571
SqThreadCpu:    174
SqBusy: 95%


