Return-Path: <io-uring+bounces-4596-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 80C509C3AE3
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 10:30:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0CEBA1F2291F
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 09:30:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83208143C72;
	Mon, 11 Nov 2024 09:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Tlv3mmc3"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6287D78289
	for <io-uring@vger.kernel.org>; Mon, 11 Nov 2024 09:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731317450; cv=none; b=KwO2QuacewYHEMyu0AIVclUtnMgK6GTIdwxWs34JdjgIDCfXrgZAlUSV2xKtidtdionBx59KIMt0iRsDzXXkz9y9EH6zzJWj98R01QyDFce3Oy7BM6Mi5Z5XBoPJHg1rv3SrrcFEoYttm3zKCapW9HAAlf9FTxQhSC5eLdf+lgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731317450; c=relaxed/simple;
	bh=8qFC7g/PruNX8DgKcmNnk1HY/uoDuRy/cIn1p1cutbI=;
	h=Date:From:To:CC:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:References; b=XT2QdMZSxehtxJXSrQHtJkC+QMcKz7yT8r16V2V8gBpcREvR8WQ4AxNPjbO7+ZxLLEwlAHGHZEqO2DaWKJgLkGjy/G3cnh6GNWN4YSo91zvb4heUf5PuAqteI7Uv5BxdfeVwgoBpln1VCLhZlSHI89STbFxIh5Vx+4yg2EtR5RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Tlv3mmc3; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20241111093041euoutp01fe0cabace3ff3879038fee25f79905da~G4Ao138zQ0953009530euoutp01Z
	for <io-uring@vger.kernel.org>; Mon, 11 Nov 2024 09:30:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20241111093041euoutp01fe0cabace3ff3879038fee25f79905da~G4Ao138zQ0953009530euoutp01Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1731317441;
	bh=I9nCs7tx7WwKl5/GW194EGkK2U+p9XG4IFNN/FpLryE=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=Tlv3mmc3cxU2iuQtnlBwlJJlrALGbmX66ceG07+8nPhg7WwyltmjALLGhk3sEWKs8
	 ocYFrgIM2p4grxaGGL+YDms31iFOI+EgKqy9rbKnRBWiAyvkamHfS9rKkC9PqgrFMk
	 GIGl2tDCFjTfrYzpC5c3eIoeb8GXAkfzF2HGnCzQ=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTP id
	20241111093040eucas1p1edcd59075ba85c834c686381263e7b88~G4Aolil3H2887628876eucas1p1w;
	Mon, 11 Nov 2024 09:30:40 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges1new.samsung.com (EUCPMTA) with SMTP id 30.18.20821.0CEC1376; Mon, 11
	Nov 2024 09:30:40 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20241111093040eucas1p2b3c0bc3b3bec1a8872f581ee07c8f98a~G4AoPwgBe2570825708eucas1p2e;
	Mon, 11 Nov 2024 09:30:40 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241111093040eusmtrp2352fefac658fac5d5a2abe720ad502b6~G4AoPHa1V0777607776eusmtrp2N;
	Mon, 11 Nov 2024 09:30:40 +0000 (GMT)
X-AuditID: cbfec7f2-b09c370000005155-48-6731cec0e17e
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id 27.7B.19654.0CEC1376; Mon, 11
	Nov 2024 09:30:40 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241111093040eusmtip23576ab63631268e2382e87c7155de91b~G4AoFk_Ek0392203922eusmtip2F;
	Mon, 11 Nov 2024 09:30:40 +0000 (GMT)
Received: from localhost (106.110.32.122) by CAMSVWEXC02.scsc.local
	(2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Mon, 11 Nov 2024 09:30:39 +0000
Date: Mon, 11 Nov 2024 10:30:38 +0100
From: Javier Gonzalez <javier.gonz@samsung.com>
To: Christoph Hellwig <hch@lst.de>
CC: Matthew Wilcox <willy@infradead.org>, Keith Busch <kbusch@kernel.org>,
	Keith Busch <kbusch@meta.com>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "joshi.k@samsung.com"
	<joshi.k@samsung.com>, "bvanassche@acm.org" <bvanassche@acm.org>
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
Message-ID: <20241111093038.zk4e7nhpd7ifl7ap@ArmHalley.local>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline
In-Reply-To: <20241111065148.GC24107@lst.de>
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsWy7djPc7oHzhmmGzxaYmYx7cNPZouVq48y
	WbxrPcdiMenQNUaLM1cXsljsvaVtsWfvSRaL+cueslt0X9/BZvH7xxw2By6Py1e8PTav0PLY
	tKqTzWPzknqP3Tcb2DzOXazw+LxJLoA9issmJTUnsyy1SN8ugSvj8Y5rTAUNHBULX29ma2Bc
	w9bFyMkhIWAiMfXPWuYuRi4OIYEVjBIzJyxnhXC+MEq8WnaVCcL5zCgx98wcRpiW7mlX2SES
	yxkl7h4+zgZX9XHeP6j+LYwSjR2XmEBaWARUJfr3XwNrZxPQl1i1/RSYLSKgJPH01VlGkAZm
	gUYWifm7H4KdJSzgLNEz9y5YEa+ArcSf9R/YIGxBiZMzn7CA2MwCVhKdH5qAtnEA2dISy/9x
	gIQ5BXQkvjz8wwJxqpLE4xdvoc6ulTi15RbYPxICzZwSyxq/MIP0Sgi4SHzpDoSoEZZ4dXwL
	O4QtI/F/53wmCLtaouHkCajeFkaJ1o6trBC91hJ9Z3Igahwl7r+byAIR5pO48VYQ4ko+iUnb
	pkNt4pXoaBOCqFaTWH3vDcsERuVZSP6aheSvWQh/LWBkXsUonlpanJueWmyYl1quV5yYW1ya
	l66XnJ+7iRGYlE7/O/5pB+PcVx/1DjEycTAeYpTgYFYS4dXw108X4k1JrKxKLcqPLyrNSS0+
	xCjNwaIkzquaIp8qJJCeWJKanZpakFoEk2Xi4JRqYGJ+a9T8yGyrpZ9PZbGyZ/+/sC3RrTO5
	3WbudxVjUX4b/fKE+/I9zq6S2/WC5kr84/5lbXKVS3JO1oGV11f9bz28xf9bwqSslS+D00Kz
	ErY8XC/iPE/CSPuOPdfrpVoSD3d+KXF/6SyRdXZ2kt8f1d2lsWduxwkK1P2X3PxWwqSgIGbZ
	3DQGtioLB4b2yhd81VP3ztPdbX3AfMZRWf6auUFGbzi3Srh4PgnwFH1yb8XG0kv3bGWe7WMU
	Zp4TWPjhV2gDw+n/LUwTj9yb1TW1z4XvwfNg+b5ud73nzw8n1kiu1nedVrWvOegY85ct2+bN
	Fm55ds56hcDRR3Z571advXEh5cnWf3v8v11Yd4RdN0eJpTgj0VCLuag4EQAL9INNuQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t/xe7oHzhmmG/z9Im8x7cNPZouVq48y
	WbxrPcdiMenQNUaLM1cXsljsvaVtsWfvSRaL+cueslt0X9/BZvH7xxw2By6Py1e8PTav0PLY
	tKqTzWPzknqP3Tcb2DzOXazw+LxJLoA9Ss+mKL+0JFUhI7+4xFYp2tDCSM/Q0kLPyMRSz9DY
	PNbKyFRJ384mJTUnsyy1SN8uQS/j8Y5rTAUNHBULX29ma2Bcw9bFyMkhIWAi0T3tKnsXIxeH
	kMBSRonLL7vZIRIyEhu/XGWFsIUl/lzrYoMo+sgocevPc1YIZwujxP3Tp8GqWARUJfr3X2ME
	sdkE9CVWbT8FZosIKEk8fXWWEaSBWaCRRWLjgyVgDcICzhI9c++CFfEK2Er8Wf8BasVkZonP
	S7tZIBKCEidnPgGzmQUsJGbOPw/UwAFkS0ss/8cBEuYU0JH48vAPC8SpShKPX7xlhLBrJT7/
	fcY4gVF4FpJJs5BMmoUwaQEj8ypGkdTS4tz03GIjveLE3OLSvHS95PzcTYzA+Nx27OeWHYwr
	X33UO8TIxMF4iFGCg1lJhFfDXz9diDclsbIqtSg/vqg0J7X4EKMpMCwmMkuJJucDE0ReSbyh
	mYGpoYmZpYGppZmxkjgv25XzaUIC6YklqdmpqQWpRTB9TBycUg1M6S8vebfcNAl6WfFX8V+q
	ipO/96XtvsqZLmZKk2p/bqgSkY7ZZqG8sM2Caar2pzP1xzL63GYILOY4a2d7ZXdfZWLZx90e
	N73P5XwJ+nvn3aV6tU9Pcg3t5680rS05JsvYel4x1PNw3a9Va+4uC3Mu+zShmP/vM5336YyF
	vevbeExEtG98CmZRTmI499BPSWDb3V/MSumZa3sVpt7RW169+eClwLy8liffHbpurO3q6Kwr
	7NgR80R9Yyjz0ak/Yko+lRxd/lf3gKLmC6ZNOrfa+QQv51eEOZhcVpIX2CuTZ3qm7NO9aa2N
	chPl9v9M0FTtWfrrnFBviP5a/1R99o9lUWoR11sUlkje0i+YrKXEUpyRaKjFXFScCACTGJqQ
	WAMAAA==
X-CMS-MailID: 20241111093040eucas1p2b3c0bc3b3bec1a8872f581ee07c8f98a
X-Msg-Generator: CA
X-RootMTR: 20241108165444eucas1p183f631e2710142fbbc7dee9300baf77a
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20241108165444eucas1p183f631e2710142fbbc7dee9300baf77a
References: <20241029151922.459139-1-kbusch@meta.com>
	<20241105155014.GA7310@lst.de> <Zy0k06wK0ymPm4BV@kbusch-mbp>
	<20241108141852.GA6578@lst.de> <Zy4zgwYKB1f6McTH@kbusch-mbp>
	<CGME20241108165444eucas1p183f631e2710142fbbc7dee9300baf77a@eucas1p1.samsung.com>
	<Zy5CSgNJtgUgBH3H@casper.infradead.org>
	<d7b7a759dd9a45a7845e95e693ec29d7@CAMSVWEXC02.scsc.local>
	<20241111065148.GC24107@lst.de>

On 11.11.2024 07:51, Christoph Hellwig wrote:
>On Fri, Nov 08, 2024 at 05:43:44PM +0000, Javier Gonzalez wrote:
>> We have been iterating in the patches for years, but it is unfortunately
>> one of these series that go in circles forever. I don't think it is due
>> to any specific problem, but mostly due to unaligned requests form
>> different folks reviewing. Last time I talked to Damien he asked me to
>> send the patches again; we have not followed through due to bandwidth.
>
>A big problem is that it actually lacks a killer use case.  If you'd
>actually manage to plug it into an in-kernel user and show a real
>speedup people might actually be interested in it and help optimizing
>for it.
>

Agree. Initially it was all about ZNS. Seems ZUFS can use it.

Then we saw good results in offload to target on NVMe-OF, similar to
copy_file_range, but that does not seem to be enough. You seem to
indicacte too that XFS can use it for GC.

We can try putting a new series out to see where we are...

