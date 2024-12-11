Return-Path: <io-uring+bounces-5430-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80BB59EC69E
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 09:10:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7BB96163011
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 08:10:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2E3F1D31A5;
	Wed, 11 Dec 2024 08:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="p5Jtbx+F"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A771D5CCD
	for <io-uring@vger.kernel.org>; Wed, 11 Dec 2024 08:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733904635; cv=none; b=IXXS8pKS7Gkk969tF9CZ8QuJrSPSWiC88uaIYN1WaStt1koRTPliOp8DjdTJIzBpEgknbB4TjunttyE+lNDZ5V/NGI70oR3bCB7Ymq7lYc9s+k7hp6JtwXr2HNYArzC6mi40sWjzPd01sO0QcZFtFF/0rq15ipryCBPLGHZxUaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733904635; c=relaxed/simple;
	bh=zaI5g3CtACrD6bwTLvA9hMuh01RTj3H+0JHaOSyrIDc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=awjZ88dsjeL2o930+0z1d0AkRfpUbwAhkUVywJfId57vrIXpSm8GwQgJ1Td2ZJ/KttEefeXlC+6XO+B6U0KfPWtJHlE+T9xOvaLGc9T4XWly+W6kIhj2sDHrseLwis6ZuOILYiG5NRfsuJwyAXxp25gisjnnSV38X/pD2BV6UWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=p5Jtbx+F; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20241211081025epoutp029108b2407c1509716a4429c42d29f9dd~QERIEPClU0877508775epoutp02Z
	for <io-uring@vger.kernel.org>; Wed, 11 Dec 2024 08:10:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20241211081025epoutp029108b2407c1509716a4429c42d29f9dd~QERIEPClU0877508775epoutp02Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1733904625;
	bh=K2B9FWo5Kyw4Xk09+eswDesCTEDzuKTmCC+Cik8lONw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=p5Jtbx+Ff+7PQnvuTlMFv8/I8OQCPoIYV5ni/5MnmOzwUOxvA8gD5ziCvAOThJK4a
	 xwlMNFgpBGKPg+R59zzarOCFiAA8LmApvHUJivkR8jtMAIOxz3NKWYSobrfj2rm9Sn
	 UZUtCeOpdZ4gBaEb0ai2/tdbfGgjvT+VXtX4hZLs=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20241211081025epcas5p3b097c796c4b4194276a6ff920b06d465~QERHnMnD_2044020440epcas5p3Z;
	Wed, 11 Dec 2024 08:10:25 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4Y7Svg64nyz4x9Pr; Wed, 11 Dec
	2024 08:10:23 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	4E.41.19933.FE849576; Wed, 11 Dec 2024 17:10:23 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241211065235epcas5p2a233ac902da67bf2d755d21d98e6eb21~QDNKrEmW20963509635epcas5p2H;
	Wed, 11 Dec 2024 06:52:35 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241211065235epsmtrp256481e0528c23f12e2dc28f65ba885e6~QDNKqPjz_1000610006epsmtrp2M;
	Wed, 11 Dec 2024 06:52:35 +0000 (GMT)
X-AuditID: b6c32a4a-b87c770000004ddd-31-675948ef0ca8
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	0E.57.33707.3B639576; Wed, 11 Dec 2024 15:52:35 +0900 (KST)
Received: from ubuntu (unknown [107.99.41.245]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20241211065233epsmtip2d07206f508fd76e0b66edc221deffb9b~QDNIuvIMr0342103421epsmtip2-;
	Wed, 11 Dec 2024 06:52:33 +0000 (GMT)
Date: Wed, 11 Dec 2024 12:14:40 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Keith Busch <kbusch@meta.com>
Cc: axboe@kernel.dk, hch@lst.de, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, sagi@grimberg.me, asml.silence@gmail.com,
	anuj20.g@samsung.com, joshi.k@samsung.com, Keith Busch <kbusch@kernel.org>,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv13 06/11] io_uring: enable per-io write streams
Message-ID: <20241211064440.uscdxxydkbh7ddne@ubuntu>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241210194722.1905732-7-kbusch@meta.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEJsWRmVeSWpSXmKPExsWy7bCmpu57j8h0g8OT9SyaJvxltpizahuj
	xeq7/WwWexZNYrJYufook8W71nMsFkf/v2WzmHToGqPFmasLWSz23tK22LP3JIvF/GVP2S3W
	vX7P4sDrsXPWXXaP8/c2snhcPlvqsWlVJ5vH5iX1HrtvNrB5nLtY4dG3ZRWjx+bT1R6fN8kF
	cEVl22SkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHa6k
	UJaYUwoUCkgsLlbSt7Mpyi8tSVXIyC8usVVKLUjJKTAp0CtOzC0uzUvXy0stsTI0MDAyBSpM
	yM5Y9Xg5S8E51opNf9eyNTC+Zuli5OSQEDCROPP/JROILSSwm1Hi+DPhLkYuIPsTo0T728Xs
	cM6/JcvZYTqOP5/PDJHYySgxa8NdKOcJo8ST41vB5rIIqEqcff+LrYuRg4NNQFvi9H8OkLCI
	gKLEeWBogNQzC2xmkpizbwMrSEJYwFniYG8zmM0LtKH/+EZGCFtQ4uTMJywgczgFzCV+7pYG
	6ZUQ2MEhMX39ZqiLXCT2f+5jgrCFJV4d3wIVl5L4/G4vG4RdLrFyygo2iOYWoKuvz2KESNhL
	tJ7qZwaxmQUyJHrf/mWFiMtKTD21jgkizifR+/sJ1AJeiR3zYGxliTXrF0AtkJS49r0RyvaQ
	OH32LiMkVLYzSrw9dop5AqPcLCQPzUKyD8K2kuj80ARkcwDZ0hLL/3FAmJoS63fpL2BkXcUo
	mVpQnJueWmxaYJSXWg6P5eT83E2M4MSs5bWD8eGDD3qHGJk4GA8xSnAwK4nw3rCPTBfiTUms
	rEotyo8vKs1JLT7EaAqMoInMUqLJ+cDckFcSb2hiaWBiZmZmYmlsZqgkzvu6dW6KkEB6Yklq
	dmpqQWoRTB8TB6dUA1OY67YoxgM+r3Y8Nrxl3iJq2qMQc3StpVi3bfU7i77ASc5RMw7lqjlJ
	/hdzC9+21fmjZObyw+e2zXD+p5ezdqpb2wKFh7ed476+lDD51+swi3/Z7asJ8tmXpiSkWPy0
	2Ciz9cNkdiOP7vq1Ank7fjyY9Ke2UWdikw1r8TE/F3vhB0/PnHogl3znCLdNwAN9BR42U/2V
	MvN3qh01Z1WW41/YqbpNisnHUj0q77rwxMXf7s7fLbtk2Q2uNrfP+in/+H+27TOIdLoU4V9R
	5GazvfBMTnaj+93n+hL+iR/fnft7LqPofNMip/elvcd2T2ku53ji+1FF44hHmSzLBtMfzuE3
	ZG5vuTy5aWW4sKjaLSWW4oxEQy3mouJEANsEBh9VBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsWy7bCSvO5ms8h0gzfLxCyaJvxltpizahuj
	xeq7/WwWexZNYrJYufook8W71nMsFkf/v2WzmHToGqPFmasLWSz23tK22LP3JIvF/GVP2S3W
	vX7P4sDrsXPWXXaP8/c2snhcPlvqsWlVJ5vH5iX1HrtvNrB5nLtY4dG3ZRWjx+bT1R6fN8kF
	cEVx2aSk5mSWpRbp2yVwZUxdtZ6poIG54s7DzywNjNuZuhg5OSQETCSOP5/P3MXIxSEksJ1R
	ouPzbHaIhKTEsr9HmCFsYYmV/56zQxQ9YpSYfnM/WIJFQFXi7PtfbF2MHBxsAtoSp/9zgIRF
	BBQlzgOdBFLPLLCZSWL5hy4WkISwgLPEwd5mVhCbF2hz//GNjCC2kECyxN3ee0wQcUGJkzOf
	gNUzC5hJzNv8kBlkPrOAtMTyfxwgJqeAucTP3dITGAVmIWmYhaRhFkLDAkbmVYyiqQXFuem5
	yQWGesWJucWleel6yfm5mxjBUaQVtINx2fq/eocYmTgYDzFKcDArifByeIemC/GmJFZWpRbl
	xxeV5qQWH2KU5mBREudVzulMERJITyxJzU5NLUgtgskycXBKNTDpvFBK/vXkkRvDwjWsaU9f
	VvSqOJfviKxduyj1UfWJ8OaHy58EVO9y8ncuOO+6xPlm+kanTQ7nLDwuhtx8/NJQW+S3kn+f
	QHiCLIePxeWa4mvtW5x9hRbGrVZbVOpR1LhkZXz4gxB9o6l/N+xamJZTtHstd/+cSalzHgm/
	udSiyrmdfZ51F2eTyufF7/9oeFo4yFht7D/fLXYkRnpv0e8N9iGzuRY2TghcevWY3twfzBbP
	BB8/4am42Bdgofl0msB5qSr9bRb+a/QfOwROZD317Nlcdp+tP9Z6Nc9at+s7x1nTW29uXu69
	82rPq8PR7xlYzQ68/t350SzC08zj3G8N8RoZO5esVGmNP9qCivVKLMUZiYZazEXFiQD0Qlh1
	EQMAAA==
X-CMS-MailID: 20241211065235epcas5p2a233ac902da67bf2d755d21d98e6eb21
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----syFHuyivwrsgIW8y2bU-AmBmzS5V9dEENjkeRCLm2dEK6Ofb=_76639_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241211065235epcas5p2a233ac902da67bf2d755d21d98e6eb21
References: <20241210194722.1905732-1-kbusch@meta.com>
	<20241210194722.1905732-7-kbusch@meta.com>
	<CGME20241211065235epcas5p2a233ac902da67bf2d755d21d98e6eb21@epcas5p2.samsung.com>

------syFHuyivwrsgIW8y2bU-AmBmzS5V9dEENjkeRCLm2dEK6Ofb=_76639_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 10/12/24 11:47AM, Keith Busch wrote:
>From: Keith Busch <kbusch@kernel.org>
>
>Allow userspace to pass a per-I/O write stream in the SQE:
>
>      __u8 write_stream;
>
>The __u8 type matches the size the filesystems and block layer support.
>
>Application can query the supported values from the statx
s/statx/sysfs

Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>

------syFHuyivwrsgIW8y2bU-AmBmzS5V9dEENjkeRCLm2dEK6Ofb=_76639_
Content-Type: text/plain; charset="utf-8"


------syFHuyivwrsgIW8y2bU-AmBmzS5V9dEENjkeRCLm2dEK6Ofb=_76639_--

