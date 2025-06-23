Return-Path: <io-uring+bounces-8448-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6616DAE38D6
	for <lists+io-uring@lfdr.de>; Mon, 23 Jun 2025 10:46:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0489C1717D4
	for <lists+io-uring@lfdr.de>; Mon, 23 Jun 2025 08:46:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28152156236;
	Mon, 23 Jun 2025 08:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Ti897vSR"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8FEC1E0E1A
	for <io-uring@vger.kernel.org>; Mon, 23 Jun 2025 08:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750668401; cv=none; b=jsp0P11L6B2UTNppbYwEVH+sXhIOpXDL7FST4sIaVb/y8wb1pswqoUF8fPGcfSKcFtKVh2u7BJLz8UeeFQPb+iTVKipVcYxHF/6s50v0HCalk9OQlt39M8tDVxwNPi1Oy5lUTiry9dLSS1pyio6IIv4F0T4Ym7y+D97WB0f8RSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750668401; c=relaxed/simple;
	bh=p3ooWrtd74XweD38edeRuLzXlNCyv9cH2Jx/v1NmqNk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=Kf7Qwh11mww273oPzRLlciZEYNcrmF3kmijENW/BGMCCy1EVGTYsndsmknruZJ5rm/ZgyoM0TGSfp2gQCk2+wo/fe/py06FJJseeJk+RH8mybzza3YRAfq8UzfWBg7Lg1qpCYo3ccUrLPvH1+z/gNSys7YOiwWiWnVbxczHUeCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Ti897vSR; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250623084636epoutp023b9dc70aa8d60c31db772bccecc4e1a8~Ln6GcO8Wc0593405934epoutp02p
	for <io-uring@vger.kernel.org>; Mon, 23 Jun 2025 08:46:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250623084636epoutp023b9dc70aa8d60c31db772bccecc4e1a8~Ln6GcO8Wc0593405934epoutp02p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1750668396;
	bh=Ej5r4+iW7MlQeTUaUnhlBJoCynReztz31GW7uiq9cQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ti897vSRU34GsjkgVp3G5g8ZcaNRpbzqZi3xJmg+/bfuMI5jcobicH9KC14Y7+HEg
	 GyHGL4pxAKZzMmXtFN/ef5fojeVtI5Kwryquf3h2R2f9xgLzy/aigWE5Ik0UvJNqx3
	 DWNyayXYnos/HylImiin29IdF3tysad724kUYU4Q=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250623084636epcas5p20f1ff4324ba7d40500f89fbe68a88d13~Ln6F6gRf00753007530epcas5p2H;
	Mon, 23 Jun 2025 08:46:36 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.179]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4bQhWt18fSz3hhTG; Mon, 23 Jun
	2025 08:46:34 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250623083812epcas5p2f7487b16f6a354b42e47b15d874bfbea~LnyxFnCOP1422814228epcas5p2Z;
	Mon, 23 Jun 2025 08:38:12 +0000 (GMT)
Received: from node122.. (unknown [109.105.118.122]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20250623083810epsmtip1bb4addeeaa32e347295146f12a47b77d~LnyvcBlWp2289822898epsmtip1X;
	Mon, 23 Jun 2025 08:38:10 +0000 (GMT)
From: "xiaobing.li" <xiaobing.li@samsung.com>
To: kbusch@kernel.org
Cc: bschubert@ddn.com, amir73il@gmail.com, asml.silence@gmail.com,
	axboe@kernel.dk, io-uring@vger.kernel.org, joannelkoong@gmail.com,
	josef@toxicpanda.com, linux-fsdevel@vger.kernel.org, miklos@szeredi.hu,
	tom.leiming@gmail.com, dw@davidwei.uk, kun.dou@samsung.com,
	peiwei.li@samsung.com, xue01.he@samsung.com, cliang01.li@samsung.com,
	joshi.k@samsung.com
Subject: Re: [PATCH v9 00/17] fuse: fuse-over-io-uring.
Date: Mon, 23 Jun 2025 08:33:25 +0000
Message-Id: <20250623083325.1044846-1-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <aFLbq5zYU6_qu_Yk@kbusch-mbp>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250623083812epcas5p2f7487b16f6a354b42e47b15d874bfbea
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-505,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250623083812epcas5p2f7487b16f6a354b42e47b15d874bfbea
References: <aFLbq5zYU6_qu_Yk@kbusch-mbp>
	<CGME20250623083812epcas5p2f7487b16f6a354b42e47b15d874bfbea@epcas5p2.samsung.com>

On Wed, Jun 18, 2025 at 09:30:51PM -0600, Keith Busch wrote:
>On Wed, Jun 18, 2025 at 03:13:41PM +0200, Bernd Schubert wrote:
>> On 6/18/25 12:54, xiaobing.li wrote:
>> > 
>> > Hi Bernd,
>> > 
>> > Do you have any plans to add zero copy solution? We are interested in
>> > FUSE's zero copy solution and conducting research in code.
>> > If you have no plans in this regard for the time being, we intend to
>> >  submit our solution.
>> 
>> Hi Xiobing,
>> 
>> Keith (add to CC) did some work for that in ublk and also planned to
>> work on that for fuse (or a colleague). Maybe Keith could
>> give an update.
>
>I was initially asked to implement a similar solution that ublk uses for
>zero-copy, but the requirements changed such that it won't work. The
>ublk server can't directly access the zero-copy buffers. It can only
>indirectly refer to it with an io_ring registered buffer index, which is
>fine my ublk use case, but the fuse server that I was trying to
>enable does in fact need to directly access that data.
>

Hi Keith,

If it's convenient, could you tell us what your current application 
scenarios are and why you need to directly share memory between the 
application and fuse?
We are also currently thinking about implementing zero-copy in the 
direction of directly sharing memory. Can you share your current ideas?
 
Best regards
--
Xiaobing Li

