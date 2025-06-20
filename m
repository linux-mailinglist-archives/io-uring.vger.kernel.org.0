Return-Path: <io-uring+bounces-8436-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 58BC4AE10DB
	for <lists+io-uring@lfdr.de>; Fri, 20 Jun 2025 03:54:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F15851794FB
	for <lists+io-uring@lfdr.de>; Fri, 20 Jun 2025 01:54:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A5EB1B960;
	Fri, 20 Jun 2025 01:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="hyiOTE7S"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B206472630
	for <io-uring@vger.kernel.org>; Fri, 20 Jun 2025 01:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750384491; cv=none; b=q1zyiH6XWf7NoZ+FfHyaOReGyYaw+TIE3yYoI4NNi8BekgcI7EtcsXZGwf/LZXw3KsCRNSuGIbOxMypTbXC01b/UrBVBMv00hqrw5MOrk2kjZLGNMy+ZQR6XsOiYCt+hx66J23Lb2ZxduDccGuFpCUudevysBwtpQR0J3b8plRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750384491; c=relaxed/simple;
	bh=JbnSw/H2IdHpaHZrHy6py5LreaGE9YTr8EvWoCBbQC0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=qnZu7O4AoIxL3CbpaHU5YAncTWhVSlfB5ME7Vucgjm9zXYLMK4LsSrOBxaTiULsqHyFPWOT9MPMjq+DuWadZOa2KLRUtM0JPpom7yjzL/qiowztGuVVhB9EN3ixPMZMkhwAh614UrBex/Abj0xJME8GSVnVL/E2sutsL5NQFoI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=hyiOTE7S; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250620015441epoutp020f3f6ea60cddadc4abdcd7756f67fc52~KnWlfN5qH2061520615epoutp02Q
	for <io-uring@vger.kernel.org>; Fri, 20 Jun 2025 01:54:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250620015441epoutp020f3f6ea60cddadc4abdcd7756f67fc52~KnWlfN5qH2061520615epoutp02Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1750384481;
	bh=7CpBoDbnVgKioVLs4/elGJm4zLE2j7fCzzRluJ8dOZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hyiOTE7Soy40HhUD3hmUyBKS3oZ9HffoPtFu7L8kfcGQR3QfLKgHHnTYllj6LJOYn
	 lPLKTnt1G3qPIJlGRr45DI9g0+1tJFNVmXHdCckMrQC+HAOgHGKd/8ODIQ4oau6Uf5
	 +DTSIqSNwPhUC17IU3na52XMCAxGw5mwE43cJIdY=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250620015439epcas5p24452bd4fe1e94359a439ff0605be6417~KnWj_CRxX1179411794epcas5p2u;
	Fri, 20 Jun 2025 01:54:39 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.176]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4bNgWx387Pz2SSKh; Fri, 20 Jun
	2025 01:54:37 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250620014432epcas5p30841af52f56e49e557caef01f9e29e52~KnNu91ySD1216312163epcas5p3o;
	Fri, 20 Jun 2025 01:44:32 +0000 (GMT)
Received: from node122.. (unknown [109.105.118.122]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20250620014431epsmtip2ce769c2530bfe200f8add65365519976~KnNtWcDEi0863208632epsmtip2P;
	Fri, 20 Jun 2025 01:44:30 +0000 (GMT)
From: "xiaobing.li" <xiaobing.li@samsung.com>
To: bschubert@ddn.com, kbusch@kernel.org
Cc: amir73il@gmail.com, asml.silence@gmail.com, axboe@kernel.dk,
	io-uring@vger.kernel.org, joannelkoong@gmail.com, josef@toxicpanda.com,
	linux-fsdevel@vger.kernel.org, miklos@szeredi.hu, tom.leiming@gmail.com,
	dw@davidwei.uk, kun.dou@samsung.com, peiwei.li@samsung.com,
	xue01.he@samsung.com, cliang01.li@samsung.com, joshi.k@samsung.com
Subject: Re: [PATCH v9 00/17] fuse: fuse-over-io-uring.
Date: Fri, 20 Jun 2025 01:39:48 +0000
Message-Id: <20250620013948.901965-1-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <aFLbq5zYU6_qu_Yk@kbusch-mbp>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250620014432epcas5p30841af52f56e49e557caef01f9e29e52
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-505,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250620014432epcas5p30841af52f56e49e557caef01f9e29e52
References: <aFLbq5zYU6_qu_Yk@kbusch-mbp>
	<CGME20250620014432epcas5p30841af52f56e49e557caef01f9e29e52@epcas5p3.samsung.com>

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
>My colleauge had been working a solution, but it required shared memory
>between the application and the fuse server, and therefore cooperation
>between them, which is rather limiting. It's still on his to-do list,
>but I don't think it's a high priority at the moment. If you have
>something in the works, please feel free to share it when you're ready,
>and I would be interested to review.

Hi Bernd and Keith,

In fact, our current idea is to implement a similar solution that ublk uses 
for zero-copy. If this can really further improve the performance of FUSE, 
then I think it is worth trying.
By the way, if it is convenient, could you tell me what was the original 
motivation for adding io_uring, or why you want to improve the performance 
of FUSE and what you want to apply it to?
 
Best regards
--
Xiaobing Li

