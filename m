Return-Path: <io-uring+bounces-4622-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69DB89C5A55
	for <lists+io-uring@lfdr.de>; Tue, 12 Nov 2024 15:30:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A9130B32064
	for <lists+io-uring@lfdr.de>; Tue, 12 Nov 2024 13:26:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85293150990;
	Tue, 12 Nov 2024 13:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="dMUhLFCp"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1111DFF7
	for <io-uring@vger.kernel.org>; Tue, 12 Nov 2024 13:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731417995; cv=none; b=m6g8h1JiNwWmaL3M0eI92S0QcSzqlwU6E6SkCMfPLefpxjIfnCJwMagp5ZJZufMEIT3Kr4IPG6rCoE+/HVqqA1B+oMlTfyMgSSzJ2MSNEaAvIp3mETaIE0RQyMVN5cWYfmP/WMhDUAmwBtj+zrzuLQ3moG4hToLaKhuQahpKtDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731417995; c=relaxed/simple;
	bh=ECcn1Vt7kh7tx9LcDNSDDOJQmeTJi0LIibgBGaHsvXc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=kiSLcQweVyxG8mjsVSRa2Cuw7JTMoSNsAooBv7TBpv5fQpeKI2+9E3hGGB0uBn7sF+b8Ensa7sFkBRV4E3g3qmShZGo/VThDYh1dIqT3/ZWN0SXqiE08dkFmxQM08TSOEd1n/+KrLV4OpjOz1tJfWFtWlwKOHDE8zFa6rBCCw/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=dMUhLFCp; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20241112132631epoutp024d605c41a55110e35234d2f85eb04567~HO31TG1Bd2357223572epoutp02T
	for <io-uring@vger.kernel.org>; Tue, 12 Nov 2024 13:26:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20241112132631epoutp024d605c41a55110e35234d2f85eb04567~HO31TG1Bd2357223572epoutp02T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1731417991;
	bh=n8xVEIDHv5I8gbDECdxLIBU/WpRStbeReffw7f4ORRs=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=dMUhLFCpnXcMHo8g8p5/1+iRhLWVJLPSWE8fCKTIWK+lbZIVB9UsBFg3jz98kd7R8
	 uKSIcfX9xPDg6IVpPgr0SR/GIVji9xYrJiY9KKKk37IdY/YmrX/n3amm3FfPj908rn
	 q5loYMXBY6kDsn6XF5h8em04vlWLL/vXaXxhRFSs=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20241112132630epcas5p47257cf43edeff21e5e6a23edd8609e51~HO3070SP90804408044epcas5p4v;
	Tue, 12 Nov 2024 13:26:30 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.183]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4XnnHn3DKdz4x9Pw; Tue, 12 Nov
	2024 13:26:29 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	B7.A3.08574.58753376; Tue, 12 Nov 2024 22:26:29 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20241112132628epcas5p33b0b5cbdbb64df77a4305802a3134aa0~HO3zD7y_W0215702157epcas5p30;
	Tue, 12 Nov 2024 13:26:28 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241112132628epsmtrp260cfa063989f3b867679801d56e9e8ad~HO3zDGNcA2083420834epsmtrp2g;
	Tue, 12 Nov 2024 13:26:28 +0000 (GMT)
X-AuditID: b6c32a44-6dbff7000000217e-8c-673357854e30
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	46.12.18937.48753376; Tue, 12 Nov 2024 22:26:28 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241112132626epsmtip1359346d7bbae74d83a7a62ab10e697b9~HO3xXNPF10035500355epsmtip17;
	Tue, 12 Nov 2024 13:26:26 +0000 (GMT)
Message-ID: <7a2f6231-bb35-4438-ba50-3f9c4cc9789a@samsung.com>
Date: Tue, 12 Nov 2024 18:56:25 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv11 0/9] write hints with nvme fdp and scsi streams
To: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, axboe@kernel.dk, martin.petersen@oracle.com,
	asml.silence@gmail.com, javier.gonz@samsung.com, Keith Busch
	<kbusch@kernel.org>
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20241111102914.GA27870@lst.de>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAJsWRmVeSWpSXmKPExsWy7bCmhm5ruHG6QdscYYs5q7YxWqy+289m
	sXL1USaLd63nWCwe3/nMbjHp0DVGizNXF7JY7L2lbbFn70kWi/nLnrJbdF/fwWax/Pg/Jgce
	j52z7rJ7XD5b6rFpVSebx+Yl9R67bzaweZy7WOHx8ektFo++LasYPT5vkgvgjMq2yUhNTEkt
	UkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6V0mhLDGnFCgUkFhc
	rKRvZ1OUX1qSqpCRX1xiq5RakJJTYFKgV5yYW1yal66Xl1piZWhgYGQKVJiQnXF/eVjBHJ6K
	XbeXMDUw3uDsYuTkkBAwkZjS95IJxBYS2M0o0fjQq4uRC8j+xCixsO0wK5wz5c1Lli5GDrCO
	6b3iEPGdjBL9MzczQThvGSXeH1/PAjKKV8BOYs+m+4wgNouAqsSsF49ZIeKCEidnPgGrERWQ
	l7h/awY7iC0s4CbRcPUuWL2IgKPE1w1LwGxmgdlMEidW8kPY4hK3nsxnAjmCTUBT4sLkUpAw
	p4COxLWuKcwQJfIS29/OYQa5R0LgBIfE6dVHWSHedJH4vm4pC4QtLPHq+BZ2CFtK4vO7vWwQ
	drbEg0cPoGpqJHZs7oPqtZdo+HODFWQvM9De9bv0IXbxSfT+fsIECRNeiY42IYhqRYl7k55C
	dYpLPJyxBMr2kJi1ew4jJKDXMEr03kmdwKgwCylQZiF5chaSb2YhLF7AyLKKUTK1oDg3PTXZ
	tMAwL7UcHtnJ+bmbGMFJWctlB+ON+f/0DjEycTAeYpTgYFYS4T3lbJwuxJuSWFmVWpQfX1Sa
	k1p8iNEUGDsTmaVEk/OBeSGvJN7QxNLAxMzMzMTS2MxQSZz3devcFCGB9MSS1OzU1ILUIpg+
	Jg5OqQam+rPPp875si7367xZta07vqQ02/7gF79x1pJJ+NCCm6mqM7dbt551t7Nn+xjAutXs
	ul2py5/M6wtKjpQmr1j0xrXeRUDjya6nX8tuKzRcWXy9TPfIA3nbU2kMRz4Xy/bN6mi89qNc
	rC5472rJZ7M6MuZvzmFkMpHWuJQte93tZLjWQ/Mb23TSuT/7zdm/nPmeVrJQWtHa0zd5l1nu
	tz4SczTnWWRVrNK3vCNRtzwTGGOTf+vpfnOeni7b+3gK29NX3Gf3pm5smXn4zoyVG79/vXaX
	L5lJWf6yecisHWnH9n5ZnDQ/VdFSjOF28pGidK3VzdfOfuTyN1twwjZQrngZs+geW+nvDxb4
	x/Jc1ql8q8RSnJFoqMVcVJwIAB1r+zJTBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRmVeSWpSXmKPExsWy7bCSnG5LuHG6waRTOhZzVm1jtFh9t5/N
	YuXqo0wW71rPsVg8vvOZ3WLSoWuMFmeuLmSx2HtL22LP3pMsFvOXPWW36L6+g81i+fF/TA48
	Hjtn3WX3uHy21GPTqk42j81L6j1232xg8zh3scLj49NbLB59W1YxenzeJBfAGcVlk5Kak1mW
	WqRvl8CVcX95WMEcnopdt5cwNTDe4Oxi5OCQEDCRmN4r3sXIxSEksJ1RoqdpFWsXIydQXFyi
	+doPdghbWGLlv+fsEEWvGSW2vdkHluAVsJPYs+k+I4jNIqAqMevFY1aIuKDEyZlPWEBsUQF5
	ifu3ZoDVCwu4STRcvQtWLyLgKPF1wxJGkKHMArOZJFp2N7JBbFjDKPFvwX6wScxAZ9x6Mp8J
	5FQ2AU2JC5NLQcKcAjoS17qmMEOUmEl0be1ihLDlJba/ncM8gVFoFpI7ZiGZNAtJyywkLQsY
	WVYxiqYWFOem5yYXGOoVJ+YWl+al6yXn525iBMefVtAOxmXr/+odYmTiYDzEKMHBrCTCe8rZ
	OF2INyWxsiq1KD++qDQntfgQozQHi5I4r3JOZ4qQQHpiSWp2ampBahFMlomDU6qBabr/qsvM
	V7Lv37w6s8WMi8st3clvwyK3dxHdYdO5J3XarzsgnTDVL+CowuGO3bL/yy3ln/09WCD77535
	rlJWl50cMZskTeVenWF/tLhY+6aD6QYWA7/rN7nD872+FHfuXTZFzntK7wPduqu/W/K3ngja
	XvHv89l7E39aMIp1My0Rvnol2fXkLR02Q+d4n4MfW2/M+n5NVeXFvn0K4jctJl2w6xFj3Fmk
	FMrDe196/um3r4+Y3DvB+s3tW4Qqw7Yn6cyLivUPemj/rpplcs7g5sYpf2onBj5X3ZtR7T/n
	ztz01zdrpWr32XNe0peQvhH68EaB5LOV8lJf3y89Gd1R/W5Nocni3uBli2dc6tp7qVKJpTgj
	0VCLuag4EQCBFqrVLgMAAA==
X-CMS-MailID: 20241112132628epcas5p33b0b5cbdbb64df77a4305802a3134aa0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241111103051epcas5p341a23ed677f2dfd6bc6d4e5c4826327b
References: <20241108193629.3817619-1-kbusch@meta.com>
	<CGME20241111103051epcas5p341a23ed677f2dfd6bc6d4e5c4826327b@epcas5p3.samsung.com>
	<20241111102914.GA27870@lst.de>

On 11/11/2024 3:59 PM, Christoph Hellwig wrote:
>   - there is a separate write_stream value now instead of overloading
>     the write hint.  For now it is an 8-bit field for the internal
>     data structures so that we don't have to grow the bio, but all the
>     user interfaces are kept at 16 bits (or in case of statx reduced to
>     it).  If this becomes now enough because we need to support devices
>     with multiple reclaim groups we'll have to find some space by using
>     unions or growing structures

>   - block/fops.c is the place to map the existing write hints into
>     the write streams instead of the driver


Last time when I attempted this separation between temperature and 
placement hints, it required adding a new fcntl[*] too because 
per-inode/file hints continues to be useful even when they are treated 
as passthrough by FS.

Applications are able to use temperature hints to group multiple files 
on device regardless of the logical placement made by FS.
The same ability is useful for write-streams/placement-hints too. But 
these patches reduce the scope to only block device.

IMO, passthrough propagation of hints/streams should continue to remain 
the default behavior as it applies on multiple filesystems. And more 
active placement by FS should rather be enabled by some opt in (e.g., 
mount option). Such opt in will anyway be needed for other reasons (like 
regression avoidance on a broken device).

[*] 
https://lore.kernel.org/linux-nvme/20240910150200.6589-4-joshi.k@samsung.com/

