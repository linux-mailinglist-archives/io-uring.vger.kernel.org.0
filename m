Return-Path: <io-uring+bounces-5400-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BEE039EAA20
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 08:58:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 37B8C18889D1
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 07:58:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF2E222B8D3;
	Tue, 10 Dec 2024 07:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="QzqM/2jI"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8B522D4CB
	for <io-uring@vger.kernel.org>; Tue, 10 Dec 2024 07:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733817509; cv=none; b=tkBQPS1Tfxb7qmc1TO7/d/Ii48J5Eb5O3xB0/7uGjUYQJOdMbSpLWEF/FFohfFHcUdYm2Ibn7VHFV+l2+9TVrMFfCHgOqpeuNOkX4FeFXFyw7N0vWREcC9xG3qSEX//xgrw/UtbEujeNTGyE1SL1v3aDy8HpD17Lp3eJ3zqxEsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733817509; c=relaxed/simple;
	bh=dHTTaNqe21VtNPH74YqYd1a8niTDUivSqhobDQZS/jA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=Bu2OabpYg1ATOBWLl9TIlAYhjNKc67N4a1CwMu/SE0vlt0/z3e2Er1aQnAR13/2eDyvyF/p95uBj4dlF+omA5oX+5KtpUPdVbPNgtbrAOUm0kKXby2OPLJITGGKvSDxJafak1ZaE/1jzT9hmFXLuw56HB+SOMVCF62pqnH2aUa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=QzqM/2jI; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20241210075826epoutp04cc14023c4c4bb9c1ed3b8ea52e61e6e8~PwdYQpZhb0189901899epoutp04h
	for <io-uring@vger.kernel.org>; Tue, 10 Dec 2024 07:58:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20241210075826epoutp04cc14023c4c4bb9c1ed3b8ea52e61e6e8~PwdYQpZhb0189901899epoutp04h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1733817506;
	bh=dHTTaNqe21VtNPH74YqYd1a8niTDUivSqhobDQZS/jA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QzqM/2jI/BfOTWPMnWRyB72+2neOclZccFGzMw5FzWucG381KAzwJ07CuDI4RlUCc
	 Nol+BTd9yvotQpvfpuovWw+wO8y6ZikTIQhOrmmS/9BEbqhYYUc7tu08f4lV3iMCOE
	 AeF246kacqgueHSP2j7Ksc+NqXj2jIDYZGWmqa3Q=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20241210075826epcas5p34f73c038cd2b7ea1360fea788a78b216~PwdXzMiwX1842118421epcas5p3B;
	Tue, 10 Dec 2024 07:58:26 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4Y6rhJ2q7Lz4x9Py; Tue, 10 Dec
	2024 07:58:24 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	8B.BF.20052.0A4F7576; Tue, 10 Dec 2024 16:58:24 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20241210074628epcas5p3e36c7615cf2a5160d7fe169774fd30db~PwS7Zomdy2564525645epcas5p3Q;
	Tue, 10 Dec 2024 07:46:28 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241210074628epsmtrp2087e8fd450d39c45399d7f95f346e14e~PwS7YjiLm3247632476epsmtrp2q;
	Tue, 10 Dec 2024 07:46:28 +0000 (GMT)
X-AuditID: b6c32a49-3fffd70000004e54-40-6757f4a0668b
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	0E.29.18949.4D1F7576; Tue, 10 Dec 2024 16:46:28 +0900 (KST)
Received: from ubuntu (unknown [107.99.41.245]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20241210074626epsmtip1f5fff72dad1d778aff74d8a2d7d08d87~PwS5kEALJ1394313943epsmtip1R;
	Tue, 10 Dec 2024 07:46:26 +0000 (GMT)
Date: Tue, 10 Dec 2024 13:08:33 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Keith Busch <kbusch@meta.com>
Cc: axboe@kernel.dk, hch@lst.de, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, sagi@grimberg.me, asml.silence@gmail.com,
	anuj20.g@samsung.com, joshi.k@samsung.com, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv12 04/12] block: introduce max_write_streams queue limit
Message-ID: <20241210073833.rx4a3lu7icjy43po@ubuntu>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241206221801.790690-5-kbusch@meta.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFJsWRmVeSWpSXmKPExsWy7bCmpu6CL+HpButviVg0TfjLbDFn1TZG
	i9V3+9ksVq4+ymTxrvUci8XR/2/ZLCYdusZocebqQhaLvbe0LfbsPcliMX/ZU3aLda/fszjw
	eOycdZfd4/y9jSwel8+Wemxa1cnmsXlJvcfumw1sHucuVnj0bVnF6PF5k1wAZ1S2TUZqYkpq
	kUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QvUoKZYk5pUChgMTi
	YiV9O5ui/NKSVIWM/OISW6XUgpScApMCveLE3OLSvHS9vNQSK0MDAyNToMKE7Iy1yxewFjSy
	VZz88p65gXEZaxcjJ4eEgIlE06HJbF2MXBxCArsZJZ41L2GGcD4xSmz6uIQRwvnGKPFu/SQ2
	mJaHlw8wgthCAnsZJVo2CUIUPWGU2P9gCQtIgkVAVaKh6SbQDg4ONgFtidP/OUDCIgKKEueB
	IQFSzywwkUni96EmdpCEsICPxPOLq5lAbF6gBbNvbmeEsAUlTs58AjaTU8BMYuqRgywgzRIC
	Kzkklh0/xQhxkYtE4/lmZghbWOLV8S3sELaUxOd3e6GuLpdYOWUFG0RzC6PErOuzoJrtJVpP
	9YM1MwtkSCya2AoVl5WYemodE0ScT6L39xMmiDivxI55MLayxJr1C6AWSEpc+94IZXtIbOia
	ywIJlq2MEr2vVrFOYJSbheSjWUj2QdhWEp0fmlhnAUOMWUBaYvk/DghTU2L9Lv0FjKyrGCVT
	C4pz01OLTQsM81LL4dGcnJ+7iRGciLU8dzDeffBB7xAjEwfjIUYJDmYlEV4O79B0Id6UxMqq
	1KL8+KLSnNTiQ4ymwBiayCwlmpwPzAV5JfGGJpYGJmZmZiaWxmaGSuK8r1vnpggJpCeWpGan
	phakFsH0MXFwSjUwqf1geTfj4ZN3Eav33LinmHDI9cmzV7WSX7h+T76xO/1Ai5zi5E8e+07O
	/WT0/XOsiFm84imf98Ffp3zQM1O9luW7IjB+hv/WpP6ynG8zne2fTV9/bYHDswlHN//bvPf1
	pVPn3vbyWGru7rl5v7x5q6ZNjtHHpyzzJjZe4LBTqvW593RR1JVJR+fFcXtz8E3zmbvP8UDw
	iQ8TTjVGLpoYLL1fpMVfSvT28ttd6yafbfK9+VSQ19h6ztKF+pKi91M3GpiyXvD8d+2YqVNu
	yeINbzsXRtm9f3+G+2rl6Yb3fX/N5yVK3z/sWZ2u7DNFTG9z1up/phGregv43dk+tfNuucir
	vbhRR9ylck74ipyGic+VWIozEg21mIuKEwFASRPVTQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsWy7bCSnO6Vj+HpBveeS1o0TfjLbDFn1TZG
	i9V3+9ksVq4+ymTxrvUci8XR/2/ZLCYdusZocebqQhaLvbe0LfbsPcliMX/ZU3aLda/fszjw
	eOycdZfd4/y9jSwel8+Wemxa1cnmsXlJvcfumw1sHucuVnj0bVnF6PF5k1wAZxSXTUpqTmZZ
	apG+XQJXxofdTxgLNjNXrFjRw9rA+Impi5GTQ0LAROLh5QOMXYxcHEICuxklZn7rZYNISEos
	+3uEGcIWllj57zk7RNEjRokbG+6zgiRYBFQlGppuAtkcHGwC2hKn/3OAhEUEFCXOA50DUs8s
	MJlJ4vnMYywgCWEBH4nnF1eDbeYF2jz75nZGkF4hgUSJX5vSIcKCEidnPgErZxYwk5i3+SEz
	SAmzgLTE8n9g4zmBwlOPHGSZwCgwC0nHLCQdsxA6FjAyr2KUTC0ozk3PLTYsMMpLLdcrTswt
	Ls1L10vOz93ECI4dLa0djHtWfdA7xMjEwXiIUYKDWUmEl8M7NF2INyWxsiq1KD++qDQntfgQ
	ozQHi5I477fXvSlCAumJJanZqakFqUUwWSYOTqkGpqAPId2GwclLD4uw+exKu6IStThloaPm
	5P2xjQ3FIXXzjBJONTAp1e299omvtNciwZbf51Tjz+1Hc+8cq2j/2J8oUXtpefd+vo6AbC6+
	4HWzbxvb9T1fOOWo/j7bzEiJ2ZptgQc/2jnf9Zp1dOI5j1O33xxsjm9I5l3wmm2p07OEyRaS
	8Qv77Uwe+jjVPE2unlFU2RJ7n7PzRK1VTcWSm8Kxv99cWz+NJ/av1kuV3EdL3Y55L/v9O85h
	SfUpF79dq8wLTYUSdbPtdbjmMK0Vjsqsebb1OsuR9stTZ1yO/iogfyHi6WwWT06HiezCTCsb
	zj3QThMWmlCVvG1m8NbN6gIC0/UcfB62tc+aVduvxFKckWioxVxUnAgAI/vjGgwDAAA=
X-CMS-MailID: 20241210074628epcas5p3e36c7615cf2a5160d7fe169774fd30db
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----K2gkAqOuxZFCoC8EFRwgD_6KeXKZsv69xmv6PgBjcdVDR2et=_71435_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241210074628epcas5p3e36c7615cf2a5160d7fe169774fd30db
References: <20241206221801.790690-1-kbusch@meta.com>
	<20241206221801.790690-5-kbusch@meta.com>
	<CGME20241210074628epcas5p3e36c7615cf2a5160d7fe169774fd30db@epcas5p3.samsung.com>

------K2gkAqOuxZFCoC8EFRwgD_6KeXKZsv69xmv6PgBjcdVDR2et=_71435_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 06/12/24 02:17PM, Keith Busch wrote:
>From: Keith Busch <kbusch@kernel.org>
>
>Drivers with hardware that support write streams need a way to export how
>many are available so applications can generically query this.
>
>Signed-off-by: Keith Busch <kbusch@kernel.org>
>[hch: renamed hints to streams, removed stacking]
>Signed-off-by: Christoph Hellwig <hch@lst.de>
>---
Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>

------K2gkAqOuxZFCoC8EFRwgD_6KeXKZsv69xmv6PgBjcdVDR2et=_71435_
Content-Type: text/plain; charset="utf-8"


------K2gkAqOuxZFCoC8EFRwgD_6KeXKZsv69xmv6PgBjcdVDR2et=_71435_--

