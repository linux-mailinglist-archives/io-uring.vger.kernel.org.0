Return-Path: <io-uring+bounces-3591-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A1C899A3C8
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 14:21:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1C35E1F269CB
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 12:21:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEAF421731B;
	Fri, 11 Oct 2024 12:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="LS1hQtyf"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50ECB20CCC5
	for <io-uring@vger.kernel.org>; Fri, 11 Oct 2024 12:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728649275; cv=none; b=X3U2TsJSLAfLgUzXlPiQ4S+oSlcubUvsSQCvNPz9dZkjBihDWkXE5aLrOOIVoyow8jDm/npVGdG1wKdYhJih6AwT6b7IWQYDj0cQ8DQeqLu+3cJQfQDuD+vGRTeqSv1c+DI2JbiInN7GUHCo9/sJXAhkvtxKzT5SXh2UEFVFPeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728649275; c=relaxed/simple;
	bh=UNYK9KIqo8UAE1kFipvlWrPRtyaFhx6K8hW4uJoytaw=;
	h=Date:From:To:CC:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:References; b=I+yNeT8u6hD2pDYJ2vg99ZAjyXQkHiXoueGc62Nehwe4Q+0Rt/nVA9iw/c35vYPzt3P6JPE9vTLOa7cwzggNRKcpcJIx9vfrvjSLACjKN8MkI4KvJK3IQPsGpF/MM0d5ZeGVB4A7DISJHwXUlY9bRiLxOPtknZB1LVMPA9WkoyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=LS1hQtyf; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20241011122105euoutp027dcfbe69bf09a4692940fd739c87cd4d~9ZVkg0AqV0773707737euoutp02B
	for <io-uring@vger.kernel.org>; Fri, 11 Oct 2024 12:21:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20241011122105euoutp027dcfbe69bf09a4692940fd739c87cd4d~9ZVkg0AqV0773707737euoutp02B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1728649265;
	bh=FT7MJh5JI+H2sqgHyHILJBUQ7TL2PzQgzLPaiYaOkYk=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=LS1hQtyfOXfWlzkpxK39EzraCHNKXhnQi0O55u2Vfbtawv08T9W48xC/FxlBV5Jsf
	 6Ol/jBLDLBTjzusIXJFt+INff76v7gdSCZFHJnfWggELkSID73OvZXIajvDVDGVdZE
	 ug4i00RmElKU3nEXKvkaat5YzavhGoNJ/SMCbWb0=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20241011122104eucas1p2fd9851ae922e96d808441e75bfe5050c~9ZVkDZ1y32333823338eucas1p2o;
	Fri, 11 Oct 2024 12:21:04 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
	eusmges1new.samsung.com (EUCPMTA) with SMTP id E7.AE.09624.03819076; Fri, 11
	Oct 2024 13:21:04 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20241011122104eucas1p2f5cdb80296ef765dd2e4fda6797017de~9ZVjbzcc12333823338eucas1p2n;
	Fri, 11 Oct 2024 12:21:04 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241011122104eusmtrp18312c6654091b567517730a0cc89784f~9ZVjahTqf2348623486eusmtrp1x;
	Fri, 11 Oct 2024 12:21:04 +0000 (GMT)
X-AuditID: cbfec7f2-c11ff70000002598-66-67091830b407
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id 3D.0E.19096.03819076; Fri, 11
	Oct 2024 13:21:04 +0100 (BST)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241011122104eusmtip269afd5e016719b370f634fa96a64864f~9ZVjOp9Zp1387013870eusmtip2x;
	Fri, 11 Oct 2024 12:21:04 +0000 (GMT)
Received: from localhost (106.110.32.122) by CAMSVWEXC02.scsc.local
	(2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Fri, 11 Oct 2024 13:21:03 +0100
Date: Fri, 11 Oct 2024 14:21:02 +0200
From: Javier Gonzalez <javier.gonz@samsung.com>
To: Christoph Hellwig <hch@lst.de>
CC: Hans Holmberg <hans@owltronix.com>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Keith Busch <kbusch@kernel.org>, Kanchan Joshi
	<joshi.k@samsung.com>, "hare@suse.de" <hare@suse.de>, "sagi@grimberg.me"
	<sagi@grimberg.me>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"jack@suse.cz" <jack@suse.cz>, "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
	"bcrl@kvack.org" <bcrl@kvack.org>, "dhowells@redhat.com"
	<dhowells@redhat.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"asml.silence@gmail.com" <asml.silence@gmail.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-aio@kvack.org" <linux-aio@kvack.org>, "gost.dev@samsung.com"
	<gost.dev@samsung.com>, "vishak.g@samsung.com" <vishak.g@samsung.com>
Subject: Re: [PATCH v7 0/3] FDP and per-io hints
Message-ID: <20241011122102.znguf6kpmbbsa42t@ArmHalley.local>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline
In-Reply-To: <20241011085631.GA4039@lst.de>
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUxbZRTG9957e3vbpN2lQHhD51fJjBkDuujm6/dm1FzndHNZMCiJq3JX
	lpWWtAOdlawWKqNO3AoOYW5jZLGsMAilgs6yjcJGO2gJFBAwJYS1qLCOrynOBZD2ou6/3znP
	c3LO8+alcMkKL5E6qD7MatUKlYwUEi037vWmyKFAKTeObkPf2loAqgt8RSLzsoNA0x3zAJ2a
	vYejO8b7BDrzdR0POWssGLpYdx1Dd0w+Ap2uKMRQsLEKRxbXEEDlp4wAtY0mI2ebh0Dnvgvx
	kbVrGUMN0zME6l3q4m2PY/wDbzA/VgX4TO9YE8H4vXmM3VZCMvZ5C59pvnCU+WnEQDJzoVGC
	6bDX8JiZK4Mk01PduSp265kF+8OMPRjG9qx/V/h8Fqs6mM9q017cL8wePLdC5o4LPr5i0BnA
	DN8MBBSkn4LO+lbCDISUhK4F8JqtGeOKuwCuXL8LuGIBwDF3xaqNio7ccOZxfSuAxbNu/D9T
	2FrK4woHgJaTRjyyhKA3wrbTfxMRJuk0aGu9CSIcR8tgaMobXYHTi3xYNuyOCrG0HM4sfklG
	WES/ACsbagiOY6CnMhhlnH4WlswaeZGTcFoKrctUpC2gk2FgYmotnAze+i0MOC6ANx2j0WyQ
	NgvhyIkBjBNegQvfzJEcx8KpLsfa8AbYXXac4FgPDR732nARgKZj3/O4t3gOlvaoOM8OeLy/
	H3BtMRwOx3BniqGlpQLn2iJ47HMJ534c1o3dJk6ApKoHglU9EKzq/2DVALeBBDZPl6NkdVvU
	7EepOkWOLk+tTP1Qk2MHq3+0e7lr/gdwZmou1QUwCrgApHBZnCjlPE8pEWUpjnzCajXva/NU
	rM4FpBQhSxBtzHqEldBKxWH2EMvmstp/VYwSJBqwlIfGl1/ajJIU+fmH3I3C7Jb1fUuu2pH6
	+J7ffZ9Ovm5vh5VDv2x4R9XgN43Vtb/9RUdwn9RTXL7Jf1/fmZGl3rlbf4E8MNSePp0RDoc1
	617d1R7sCLvGPb8uvlXw2R/O6glN3zO+yc6rl+VNxeXUQO2lwKP5wmuZwlBqbFNCStPts0/o
	JxP7rAm+0mGdeN/Mm5eIo2e3qj8oZL2x6UZ/Qn3By+/deu1q0YBc6ujfsa5M0ZyStL/IV7rL
	PGE0l4Q8Jlmmx4al/ZU7eN57IP5ngbIwXex3WUYzTd6lnY+17g0ELz9ZfHFk959YTEYPLeUL
	NcmCzSD+yB7nVvHT27ftbZQRumzFlk24Vqf4B86lIfESBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t/xe7oGEpzpBrNfcVvMWbWN0WL13X42
	i65/W1gsXh/+xGgx7cNPZot3Tb9ZLOZOXc1qsWfRJCaLlauPMlm8az3HYjF7ejOTxZP1s5gt
	Jh26xmgxZVoTo8XeW9oWe/aeZLGYv+wpu8Xy4/+YLNa9fs9icf7vcVYHEY/LV7w9ds66y+5x
	/t5GFo/LZ0s9Nq3qZPPY9GkSu8fmJfUeu282sHl8fHqLxePwpkWsHu/3XWXzOLPgCFDydLXH
	501yHpuevGUK4I/SsynKLy1JVcjILy6xVYo2tDDSM7S00DMysdQzNDaPtTIyVdK3s0lJzcks
	Sy3St0vQy7g6/z9bwQPOin0NxQ2M79m7GDk4JARMJI7tKe1i5OIQEljKKDF7z1rGLkZOoLiM
	xMYvV1khbGGJP9e62CCKPjJKfOrayASSEBLYwihx5a4XiM0ioCqxd/YvFhCbTUBfYtX2U2CD
	RASUJJ6+OssI0sws8J1dYvKNE2AJYQEDifffe9lAbF4BW4mZ6xaxQAxdziLR2msEEReUODnz
	CVicWcBCYub884wgVzMLSEss/8cBEuYU0Ja4++gVO8ShShKPX7yFeqBW4vPfZ4wTGIVnIZk0
	C8mkWQiTFjAyr2IUSS0tzk3PLTbSK07MLS7NS9dLzs/dxAhMJduO/dyyg3Hlq496hxiZOBgP
	MUpwMCuJ8OouZE0X4k1JrKxKLcqPLyrNSS0+xGgKDIqJzFKiyfnAZJZXEm9oZmBqaGJmaWBq
	aWasJM7LduV8mpBAemJJanZqakFqEUwfEwenVANTWURI47xy3SfyZyU/JXxsrD4kc9h3l5DR
	8wW17XNXXbc53LJzWcO03Dfv6vcIuH1ymxmzeMaKL23HfRgqpDUu9hw/f9aL+9m9LWsNvY0v
	L43jWHR40kbB42wX6t+ce7BgUc68miveObM/BOzwOxfkOYmvU11acbora9id8OvRpkV7ev/t
	uJ7vu1Gp97nC/t8cSWfmxfV6f3jy9p95fEzwlzt3Z7GVHO/ZE8I3e8fB/t/O8e7XLuzKbeSv
	Fpvz6sfGy/5OpQ36c5Rl1u4yPLHvRtLDE39/tLy7+8d/n5Qf216bhYFtN0Jfiv2ptA2R4FD9
	r7tTWW3u5iVz+KR5OlbfdZWbssfhE0N6KrfE5dWyHEosxRmJhlrMRcWJAGrl7aGuAwAA
X-CMS-MailID: 20241011122104eucas1p2f5cdb80296ef765dd2e4fda6797017de
X-Msg-Generator: CA
X-RootMTR: 20241010092019eucas1p157b87b63e91cd2294df4a8f8e2de4cdf
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20241010092019eucas1p157b87b63e91cd2294df4a8f8e2de4cdf
References: <20241004123027.GA19168@lst.de>
	<20241007101011.boufh3tipewgvuao@ArmHalley.local>
	<CANr-nt3TA75MSvTNWP3SwBh60dBwJYztHJL5LZvROa-j9Lov7g@mail.gmail.com>
	<97bd78a896b748b18e21e14511e8e0f4@CAMSVWEXC02.scsc.local>
	<CANr-nt11OJfLRFr=rzH0LyRUzVD9ZFLKsgree=Xqv__nWerVkg@mail.gmail.com>
	<20241010071327.rnh2wsuqdvcu2tx4@ArmHalley.local>
	<CGME20241010092019eucas1p157b87b63e91cd2294df4a8f8e2de4cdf@eucas1p1.samsung.com>
	<20241010092010.GC9287@lst.de>
	<20241010122232.r2omntepzkmtmx7p@ArmHalley.local>
	<20241011085631.GA4039@lst.de>

On 11.10.2024 10:56, Christoph Hellwig wrote:
>On Thu, Oct 10, 2024 at 02:22:32PM +0200, Javier Gonzalez wrote:
>> Passthru is great for prototyping and getting insights on end-to-end
>> applicability. We see though that it is difficult to get a full solution
>> based on it, unless people implement a use-space layer tailored to their
>> use-case (e.g., a version SPDK's bdev). After the POC phase, most folks
>> that can use passthru prefer to move to block - with a validated
>> use-case it should be easier to get things upstream.
>>
>> This is exactly where we are now.
>
>That's a lot of marketing babble :)    What exact thing is missing
>from the passthrough interface when using say spdx over io_uring?

The block layer provides a lot of functionality that passthru cannot
provide. A simple example would be splits. You know this :)

I am sure Jens and Keith can give you more specifics on their particular
reasons.

>
>> If you saw the comments from Christian on the inode space, there are a
>> few plumbing challenges. Do you have any patches we could look at?
>
>I'm not sure what you refer to here.

This from Christian:
   https://lore.kernel.org/all/20240903-erfassen-bandmitglieder-32dfaeee66b2@brauner/

