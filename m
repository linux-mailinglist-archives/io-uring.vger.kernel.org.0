Return-Path: <io-uring+bounces-4604-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F9CD9C3C2B
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 11:38:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D2A882811A3
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 10:38:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E832158D8B;
	Mon, 11 Nov 2024 10:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ZCg34Tcy"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D1C1586C8
	for <io-uring@vger.kernel.org>; Mon, 11 Nov 2024 10:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731321481; cv=none; b=c5r3YYPLdMq+TsXhNOybwIv5WnC/14AGPosqWfCxAKD9Jt+G/Mke07oTxJh5gwcHSVUWE2yf6+HQZsfw8IQH40JDaEv3P8EwtWPUHwQhgiEMlq+F6TO9fANo8HrL2lN2sfCHTuM17u7LajBEXX6+vbUIYNxzW1HF3LHdSxcbOUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731321481; c=relaxed/simple;
	bh=tw4NX/EYhraO6d9PUd0oHembUQ1fI4Om2cJDMPrLXY0=;
	h=Date:From:To:CC:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:References; b=mYcYxM8YhhSu1tE7Rl8rp4HR3OFyUxUmD2aG3zCGMqtw5YePwj8XoAvR93uPTDObFMe+rbFt0IwwtShs/A3bMux1D/i+is+hyWNu3w6OTadgpAHcjHAuyrvH791J0oeSeqtDrzu15Dew7DzzNZ0miausMkWFVbrKgbJtZv975f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ZCg34Tcy; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20241111103757euoutp02bce5e37e96addb4236b443f1c40a7b95~G47XhpfJv2914829148euoutp020
	for <io-uring@vger.kernel.org>; Mon, 11 Nov 2024 10:37:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20241111103757euoutp02bce5e37e96addb4236b443f1c40a7b95~G47XhpfJv2914829148euoutp020
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1731321477;
	bh=emaLJNOCF8BJgeBPtXE9n72IBzIV+Bpme9/exLdR0/M=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=ZCg34TcySRBwb5fKz19BOZXfk+Bu83fO2QiDOuEsJZU/KA2WvI3R8owIhkrvoy9rb
	 ZlBbE4rofVoT6gWxV/+oujQlnng2qCr3GJTpLtMcORerMX3UZRRIsIOIV1FtHrkDCF
	 YLiccStJjtsELhOlN99dDeuigr1eKCin0MQgYe+Q=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTP id
	20241111103756eucas1p1c53e9213128827d22eab05514570e829~G47XPL8CY1502715027eucas1p1f;
	Mon, 11 Nov 2024 10:37:56 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
	eusmges1new.samsung.com (EUCPMTA) with SMTP id 54.A6.20821.48ED1376; Mon, 11
	Nov 2024 10:37:56 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20241111103756eucas1p2453f80b2a83fab2bf4fb0b2cdcbfa853~G47W0H30Z3257332573eucas1p2W;
	Mon, 11 Nov 2024 10:37:56 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
	eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241111103756eusmtrp2b92102c77a99a65f4f5373dac26288ba~G47WziHmJ1531515315eusmtrp29;
	Mon, 11 Nov 2024 10:37:56 +0000 (GMT)
X-AuditID: cbfec7f2-b09c370000005155-64-6731de84cb7b
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
	eusmgms1.samsung.com (EUCPMTA) with SMTP id 1E.6D.19920.48ED1376; Mon, 11
	Nov 2024 10:37:56 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241111103755eusmtip2c02e1c4bef250012e8effd29d7b115b8~G47V9xEPK3022530225eusmtip2k;
	Mon, 11 Nov 2024 10:37:55 +0000 (GMT)
Received: from localhost (106.110.32.122) by CAMSVWEXC02.scsc.local
	(2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
	Mon, 11 Nov 2024 10:37:50 +0000
Date: Mon, 11 Nov 2024 11:37:50 +0100
From: Javier Gonzalez <javier.gonz@samsung.com>
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
CC: hch <hch@lst.de>, Matthew Wilcox <willy@infradead.org>, Keith Busch
	<kbusch@kernel.org>, Keith Busch <kbusch@meta.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"joshi.k@samsung.com" <joshi.k@samsung.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>
Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
Message-ID: <20241111103750.aeqlvfqymdmzigq2@ArmHalley.local>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline
In-Reply-To: <5e29b698-e09e-4819-8be4-04ac1bd94142@wdc.com>
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHKsWRmVeSWpSXmKPExsWy7djP87ot9wzTDZb90LSY9uEns8XK1UeZ
	LN61nmOx+Nt1j8li0qFrjBZnri5ksdh7S9tiz96TLBbzlz1lt+i+voPN4vePOWwO3B6Xr3h7
	bF6h5bFpVSebx+Yl9R67bzaweZy7WOHxeZOcR/uBbqYAjigum5TUnMyy1CJ9uwSujFsTfrAX
	/BKqWHD7K0sD41T+LkZODgkBE4l3d1eydTFycQgJrGCU+DJ3PStIQkjgC6PE0hfmEPZnRomL
	9/xhGlr73jFDNCxnlJj96gM7hANUtPxHG1RmC6PE5k+bmEBaWARUJe50r2UBsdkE9CVWbT/F
	2MXIwSEiYCzxc501SD2zwFQWieuv1jCC1AgLOEv0zL0LZvMK2Eos6DvLBGELSpyc+QRsDrOA
	lUTnhyZWkDnMAtISy/9xgIQ5Bawlpu28wARxqZLE4xdvGSHsWolTW24xgeySEJjMKfH9x052
	iISLxPr1f1khbGGJV8e3QMVlJP7vnA81qFqi4eQJqOYWRonWjq1giyWAtvWdyYGocZS4/24i
	C0SYT+LGW0GIM/kkJm2bzgwR5pXoaBOCqFaTWH3vDcsERuVZSB6bheSxWQiPLWBkXsUonlpa
	nJueWmyYl1quV5yYW1yal66XnJ+7iRGYpE7/O/5pB+PcVx/1DjEycTAeYpTgYFYS4dXw108X
	4k1JrKxKLcqPLyrNSS0+xCjNwaIkzquaIp8qJJCeWJKanZpakFoEk2Xi4JRqYCpmMjjrkFq5
	N4H54v3NAdF7Ghrnnom+6n+2uCVXoth9W/3eH/Xav4/FMT6aZX4o6Pq/nU68wUffPa3z5ba4
	O2O+cdlZbaFSoVVHIzZkeiWc5H/rEOR1LEFK4f5DlXO+HueUFi0IldVIanHMaL9ZmsqWWX3r
	QWTCnQnec7ZufOm0WSb0VerRyE2KcQqHW1QfzP9iPvm6xMZFd1q8dlw0epLntt4w8bNAMl/v
	h0zmyOJ//LPuhr+alyF9zqem+6GD1caK2ktqjC83bxBm6zu+ISI4w7NcweuB07tvm3aEa3od
	t397kb93Z8qRY0dW7nFfdip89S8n5pVsv5ZJ12zZVh0afGDH5VYRlzVnP6moGymxFGckGmox
	FxUnAgDuhEOFwQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t/xe7ot9wzTDX7u4LWY9uEns8XK1UeZ
	LN61nmOx+Nt1j8li0qFrjBZnri5ksdh7S9tiz96TLBbzlz1lt+i+voPN4vePOWwO3B6Xr3h7
	bF6h5bFpVSebx+Yl9R67bzaweZy7WOHxeZOcR/uBbqYAjig9m6L80pJUhYz84hJbpWhDCyM9
	Q0sLPSMTSz1DY/NYKyNTJX07m5TUnMyy1CJ9uwS9jFsTfrAX/BKqWHD7K0sD41T+LkZODgkB
	E4nWvnfMXYxcHEICSxklnmw7wAqRkJHY+OUqlC0s8edaFxtE0UdGiW9zVkF1bGGUWLJyGgtI
	FYuAqsSd7rVgNpuAvsSq7acYuxg5OEQEjCV+rrMGqWcWmMoicf3VGkaQGmEBZ4meuXfBbF4B
	W4kFfWeZIIZ+YJb4fuI7VEJQ4uTMJ2BDmQUsJGbOPw82lFlAWmL5Pw6QMKeAtcS0nReYIC5V
	knj84i0jhF0r8fnvM8YJjMKzkEyahWTSLIRJCxiZVzGKpJYW56bnFhvqFSfmFpfmpesl5+du
	YgRG7LZjPzfvYJz36qPeIUYmDsZDjBIczEoivBr++ulCvCmJlVWpRfnxRaU5qcWHGE2BQTGR
	WUo0OR+YMvJK4g3NDEwNTcwsDUwtzYyVxHndLp9PExJITyxJzU5NLUgtgulj4uCUamDaMI2/
	n2vGFoFvXDWxQdc8d1exfp2x3Ob5t0kuRXzuDUHuybeN59z4kivyhdN88hfFiDKTlYsuKbrN
	7j+09NT5hSJq25/8ENhjnvvr+pslnc5KT9nd+33DCn7KLbzweIEZ7yU+9qkz1zY8NWHmKY7U
	ftTXaT7vtUhs4kH+3+tdrpoIrlk7+2Vk/2uZvScCPhzfdzvkZplOc5x1rsmdFbxv89fOOvNk
	2ron3s8vPHqzZrGhQv7RieG8h8q3nVnxZeUqiYrUU7OSrZ/cKN7Wv+gbU8zlK6/jtBe4alyw
	5V++x874rfqMqPbUK51vS4Q3H9AVUhJTV7NjMU16scZS7mjImkWa3G+3GKXw8G6vqvh9T4ml
	OCPRUIu5qDgRANHby5xhAwAA
X-CMS-MailID: 20241111103756eucas1p2453f80b2a83fab2bf4fb0b2cdcbfa853
X-Msg-Generator: CA
X-RootMTR: 20241108165444eucas1p183f631e2710142fbbc7dee9300baf77a
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20241108165444eucas1p183f631e2710142fbbc7dee9300baf77a
References: <20241108141852.GA6578@lst.de> <Zy4zgwYKB1f6McTH@kbusch-mbp>
	<CGME20241108165444eucas1p183f631e2710142fbbc7dee9300baf77a@eucas1p1.samsung.com>
	<Zy5CSgNJtgUgBH3H@casper.infradead.org>
	<d7b7a759dd9a45a7845e95e693ec29d7@CAMSVWEXC02.scsc.local>
	<20241111065148.GC24107@lst.de>
	<20241111093038.zk4e7nhpd7ifl7ap@ArmHalley.local>
	<81a00117-f2bd-401c-b71e-1c35a4459f9a@wdc.com>
	<20241111094133.5qvumcbquxzv7bzu@ArmHalley.local>
	<5e29b698-e09e-4819-8be4-04ac1bd94142@wdc.com>

On 11.11.2024 09:43, Johannes Thumshirn wrote:
>On 11.11.24 10:41, Javier Gonzalez wrote:
>> On 11.11.2024 09:37, Johannes Thumshirn wrote:
>>> On 11.11.24 10:31, Javier Gonzalez wrote:
>>>> On 11.11.2024 07:51, Christoph Hellwig wrote:
>>>>> On Fri, Nov 08, 2024 at 05:43:44PM +0000, Javier Gonzalez wrote:
>>>>>> We have been iterating in the patches for years, but it is unfortunately
>>>>>> one of these series that go in circles forever. I don't think it is due
>>>>>> to any specific problem, but mostly due to unaligned requests form
>>>>>> different folks reviewing. Last time I talked to Damien he asked me to
>>>>>> send the patches again; we have not followed through due to bandwidth.
>>>>>
>>>>> A big problem is that it actually lacks a killer use case.  If you'd
>>>>> actually manage to plug it into an in-kernel user and show a real
>>>>> speedup people might actually be interested in it and help optimizing
>>>>> for it.
>>>>>
>>>>
>>>> Agree. Initially it was all about ZNS. Seems ZUFS can use it.
>>>>
>>>> Then we saw good results in offload to target on NVMe-OF, similar to
>>>> copy_file_range, but that does not seem to be enough. You seem to
>>>> indicacte too that XFS can use it for GC.
>>>>
>>>> We can try putting a new series out to see where we are...
>>>
>>> I don't want to sound like a broken record, but I've said more than
>>> once, that btrfs (regardless of zoned or non-zoned) would be very
>>> interested in that as well and I'd be willing to help with the code or
>>> even do it myself once the block bits are in.
>>>
>>> But apparently my voice doesn't count here
>>
>> You are right. Sorry I forgot.
>>
>> Would this be through copy_file_range or something different?
>>
>
>Unfortunately not, brtfs' reclaim/balance path is a wrapper on top of
>buffered read and write (plus some extra things). _BUT_ this makes it
>possible to switch the read/write part and do copy offload (where possible).

On 11.11.2024 10:42, hch wrote:
>On Mon, Nov 11, 2024 at 10:41:33AM +0100, Javier Gonzalez wrote:
>> You are right. Sorry I forgot.
>>
>> Would this be through copy_file_range or something different?
>
>Just like for f2fs, nilfs2, or the upcoming zoned xfs the prime user
>would be the file system GC code.

Replying to both.

Thanks. Makes sense. Now that we can talke a look at your branch, we can
think how this would look like.


