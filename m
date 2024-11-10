Return-Path: <io-uring+bounces-4585-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BD749C3435
	for <lists+io-uring@lfdr.de>; Sun, 10 Nov 2024 19:37:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 65023B20D28
	for <lists+io-uring@lfdr.de>; Sun, 10 Nov 2024 18:37:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 060D11386BF;
	Sun, 10 Nov 2024 18:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="NI9It1uM"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF47200A0
	for <io-uring@vger.kernel.org>; Sun, 10 Nov 2024 18:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731263828; cv=none; b=DRAa18QQZ7GmrNrLx76N/n0fJm8SjYiVQ1DFpdjJYF5aPEIgAh2FkvJ0ju+zNakcZTrNufpqpOcYKVNQ2TdcQR3zHyVDd88PCYBpIHFh0ai8kWKSIvLs17dxmRdtTEidmyngYdjZk8wj1gdgzqRGa/lsArrEokF3HFWrDbKkbSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731263828; c=relaxed/simple;
	bh=uatXUvsm+NqdY3fiWCUh/0IHKRWy7DYCbjQM9+wjHo8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=JouAsNHtOlRUYVq6dL7HXXTYpsR6zUnvQXUoSxaVFDYdtN1810Rt9AGIRcutaCyOsyej3bKBfAAzYbt8j5byl2SNtJtAXJ4q+sXuL2baDvClT1pYxynlzA/p26/UcyvYa0A96/WC9Dd3yVNfPHI1RgGU5b9LzLagUwOrC7NQhms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=NI9It1uM; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241110183704epoutp010157e14b7a056d201c98e56fb19c2d99~Gr0aPRNvw0634506345epoutp01K
	for <io-uring@vger.kernel.org>; Sun, 10 Nov 2024 18:37:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241110183704epoutp010157e14b7a056d201c98e56fb19c2d99~Gr0aPRNvw0634506345epoutp01K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1731263824;
	bh=pdAt2GXf2py/vwJ3camC2iNZF/tifIiDjXJpm6Oy578=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=NI9It1uM14dxeyRTri9WznEJTEljSEyMlOlIKGz9iDqu8NAgbBqrGG9h4QGKfLO23
	 pR9ErRBOlfVysCTXGMJ1rbekzL7mTrWgUba86TUE3qbdo3kQ4PDW1SuFAidtm5dSYD
	 MPdJHf9Bkguq768/ZNs9TpkDdQf/DEkKClViixU0=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20241110183703epcas5p43efe21e451d839c461bf68ee96e3e71f~Gr0ZRQgZi2222922229epcas5p4t;
	Sun, 10 Nov 2024 18:37:03 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.180]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4XmhH21dPPz4x9Pr; Sun, 10 Nov
	2024 18:37:02 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	FE.1F.09800.E4DF0376; Mon, 11 Nov 2024 03:37:02 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20241110183701epcas5p35d18e3fbacec42a26300680113e5a883~Gr0XY3jeF0075600756epcas5p3C;
	Sun, 10 Nov 2024 18:37:01 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241110183701epsmtrp17b2fa33e1c07dc0df678f229659bec2c~Gr0XX8zU23257432574epsmtrp1c;
	Sun, 10 Nov 2024 18:37:01 +0000 (GMT)
X-AuditID: b6c32a4b-23fff70000002648-82-6730fd4ed301
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	9A.A5.07371.D4DF0376; Mon, 11 Nov 2024 03:37:01 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241110183658epsmtip22452c1a1300548c189c7b1498511ca43~Gr0U_v41V1569415694epsmtip2C;
	Sun, 10 Nov 2024 18:36:58 +0000 (GMT)
Message-ID: <6bca474e-361d-40a3-b28b-93f561dbdd85@samsung.com>
Date: Mon, 11 Nov 2024 00:06:57 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 06/10] io_uring/rw: add support to send metadata
 along with read/write
To: Pavel Begunkov <asml.silence@gmail.com>, Keith Busch <kbusch@kernel.org>
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
	brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org, gost.dev@samsung.com, vishak.g@samsung.com,
	anuj1072538@gmail.com, Anuj Gupta <anuj20.g@samsung.com>
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <b11cc81d-08b7-437d-85b4-083b84389ff1@gmail.com>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01TfUxTVxT3vj7aB67Lo8i4sszW52YGG9AOKBdClaExj0gm25JtzG3dC30W
	BrTPfky3mNCM4AQU1MahBQIbH1NAyYBIxTERRKbhQyNDBcQOymRKzfiME5jrlxv//e7v/M49
	53fOvQRPNMEPJjI0BlanYbIovh9+viskNOydFala2nyYQDMLSzj65ugKD5XVnQeo/l4xHz3q
	mgXobscFDJ2p78bQ47x+HJWW5GLoeOcQQO3Db6Cf26/hqKJ2UoAKb1v56MeefzA0sNLjgwYs
	ZYIEf/qC5Z6AvtVnpJvq8vl0c3UOffGuiU/PTA7jdFFLHaB7K68I6LmmDXST3YGl+H2cGZ/O
	MipWJ2E1aVpVhkatoHa+r9ymjJZLZWGyWBRDSTRMNqugtienhO3IyHLaoSRfMllGJ5XC6PVU
	xJZ4ndZoYCXpWr1BQbGcKouL4sL1TLbeqFGHa1hDnEwqfSvaKfw8M/3vQ8MCrlayf7lwADcB
	2/oC4EtAMgpOnX3GKwB+hIi8COD89IzAFRCRswBOln7kCSwCONB2x+d5xq2RPNwTaAfQvtjo
	4zk4AOw6fNmdLiS3wG+vXsJdGCdfg+13lvke3h9eO2V384GkGN4fPunWB5BKeH16AbjwOjIZ
	mitmBa5LeeQTDA6eyncHeGQQHLZXYAWAIPhkCLxhNrpoX1IB87tH+R6JGLY6ytx+IDlPwNMP
	ywWetrfDXkeDFwfAhz0tXhwM/yw+6MWZ0DZuwz34ALQ2F3ktb4WmZZd9wlkgBDa2RXhqvQiP
	LNnd7UBSCA8dFHnUG+HY8UlvZhD8/WS1F9OwxWEFnlnl8+BT25jPUSCxrBqLZZVLyyo7lv8r
	VwK8DqxnOX22mtVHc5Eadt9/C0/TZjcB92sP3WkF47a/wjsBRoBOAAketU74+q4ItUioYr76
	mtVplTpjFqvvBNHO/RzjBQemaZ3fRWNQyqJipVFyuTwqNlIuo4KEj/LKVSJSzRjYTJblWN3z
	PIzwDTZh+YH878W7Lc++WHOVO3d784FPC3fZzaPyBxPnEjnpiJDsLbppOFunmXo7+D1UlfNJ
	WmoiHBldG/BbbW2Cslr9nZ36MPbJm46cH5JeiBwDP3XQ86hx/MGZTf29C9obxbZmtKZ5z1xF
	3tq5ms82jA9msNLEV33R9OnKhfjBsmxzGX4kxu9mbkJ7i6n/yv2Xu7rN3ZbLXElva32pXV3U
	qts7kXSiKaSb8M1dMdUENSRt2po699K7MVVTAfUfXG8YKvlVMcAzK+KsgTQ9KtltXUyU6Ybq
	U59iNa/sZR739W3jjl3yT7bG788QF1nEcUu/dEj3mDeG/rHvRNyivK2xanN56xCF69MZWShP
	p2f+BZywWhR2BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsWy7bCSvK7vX4N0g+sz2S0+fv3NYtE04S+z
	xZxV2xgtVt/tZ7N4ffgTo8XNAzuZLFauPspk8a71HIvF7OnNTBaTDl1jtNh7S9tiz96TLBbz
	lz1lt+i+voPNYvnxf0wW5/8eZ7U4P2sOu4Ogx85Zd9k9Lp8t9di0qpPNY/OSeo/dNxvYPD4+
	vcXi0bdlFaPHmQVH2D0+b5Lz2PTkLVMAVxSXTUpqTmZZapG+XQJXxs+OW+wFyxQq/nSfZ2lg
	fCDZxcjJISFgInH5ditLFyMXh5DAbkaJCz0rmSES4hLN136wQ9jCEiv/PWeHKHrNKLH5ymSw
	BK+AnUT7sf0sIDaLgKrE3ht/2CDighInZz4Bi4sKyEvcvzUDqJ6DQ1ggXmLfTB2QsIiAj8Tk
	+Z/AZjIL/GCS2NZzDWpBJ7PEzpmPmUCqmIGuuPVkPhNIM5uApsSFyaUgYU4BW4nOo3fYIErM
	JLq2djFC2PIS29/OYZ7AKDQLyRmzkEyahaRlFpKWBYwsqxglUwuKc9Nzkw0LDPNSy/WKE3OL
	S/PS9ZLzczcxguNYS2MH4735//QOMTJxMB5ilOBgVhLh1fDXTxfiTUmsrEotyo8vKs1JLT7E
	KM3BoiTOazhjdoqQQHpiSWp2ampBahFMlomDU6qBacO7I+KRG9a5Nn38/llKznXx7SV7szbf
	tO/V/tuRoL/WWzpr3t/8LPFZhbMyr3Sficjdafvk63FmTgMx5jJeo2hbli+N1rEnUrtqq510
	uTU9+dI//tq4Mu3c5EkL+veWW+kyalxWXu9ldkiAL0/VLjyAb/P+hasrBC4FTe7nqfpiGKhk
	buNp+1HGvizBfJFRx4SXNzsuNYirGSblT3mUf6rHctWDjmcyOblHFiwJe2I6cxqX1I3Trxzm
	nvpd935a2HrrAqEdK9qiNY3VVd/a3+VImxdxRdzty2+NGOWns8tDVJIKCx9pXDvRKVf0NpTH
	YJcGM8/nBbZ590oec3/6t2lpwgYrlTOiX7ifeG1QYinOSDTUYi4qTgQAXXI5DFIDAAA=
X-CMS-MailID: 20241110183701epcas5p35d18e3fbacec42a26300680113e5a883
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241030181013epcas5p2762403c83e29c81ec34b2a7755154245
References: <20241030180112.4635-1-joshi.k@samsung.com>
	<CGME20241030181013epcas5p2762403c83e29c81ec34b2a7755154245@epcas5p2.samsung.com>
	<20241030180112.4635-7-joshi.k@samsung.com>
	<ZyKghoCwbOjAxXMz@kbusch-mbp.dhcp.thefacebook.com>
	<914cd186-8d15-4989-ad4e-f7e268cd3266@gmail.com>
	<ceb58d97-b2e3-4d36-898d-753ba69476be@samsung.com>
	<b11cc81d-08b7-437d-85b4-083b84389ff1@gmail.com>

On 11/7/2024 10:53 PM, Pavel Begunkov wrote:

> Let's say we have 3 different attributes META_TYPE{1,2,3}.
> 
> How are they placed in an SQE?
> 
> meta1 = (void *)get_big_sqe(sqe);
> meta2 = meta1 + sizeof(?); // sizeof(struct meta1_struct)
> meta3 = meta2 + sizeof(struct meta2_struct);

Not necessary to do this kind of additions and think in terms of 
sequential ordering for the extra information placed into 
primary/secondary SQE.

Please see v8:
https://lore.kernel.org/io-uring/20241106121842.5004-7-anuj20.g@samsung.com/

It exposes a distinct flag (sqe->ext_cap) for each attribute/cap, and 
userspace should place the corresponding information where kernel has 
mandated.

If a particular attribute (example write-hint) requires <20b of extra 
information, we should just place that in first SQE. PI requires more so 
we are placing that into second SQE.

When both PI and write-hint flags are specified by user they can get 
processed fine without actually having to care about above 
additions/ordering.

> Structures are likely not fixed size (?). At least the PI looks large
> enough to force everyone to be just aliased to it.
> 
> And can the user pass first meta2 in the sqe and then meta1?

Yes. Just set the ext_cap flags without bothering about first/second.
User can pass either or both, along with the corresponding info. Just 
don't have to assume specific placement into SQE.


> meta2 = (void *)get_big_sqe(sqe);
> meta1 = meta2 + sizeof(?); // sizeof(struct meta2_struct)
> 
> If yes, how parsing should look like? Does the kernel need to read each
> chunk's type and look up its size to iterate to the next one?

We don't need to iterate if we are not assuming any ordering.

> If no, what happens if we want to pass meta2 and meta3, do they start
> from the big_sqe?

The one who adds the support for meta2/meta3 in kernel decides where to 
place them within first/second SQE or get them fetched via a pointer 
from userspace.

> How do we pass how many of such attributes is there for the request?

ext_cap allows to pass 16 cap/attribute flags. Maybe all can or can not 
be passed inline in SQE, but I have no real visibility about the space 
requirement of future users.


> It should support arbitrary number of attributes in the long run, which
> we can't pass in an SQE, bumping the SQE size is not scalable in
> general, so it'd need to support user pointers or sth similar at some
> point. Placing them in an SQE can serve as an optimisation, and a first> step, though it might be easier to start with user pointer instead.
> 
> Also, when we eventually come to user pointers, we want it to be
> performant as well and e.g. get by just one copy_from_user, and the
> api/struct layouts would need to be able to support it. And once it's
> copied we'll want it to be handled uniformly with the SQE variant, that
> requires a common format. For different formats there will be a question
> of perfomance, maintainability, duplicating kernel and userspace code.
> 
> All that doesn't need to be implemented, but we need a clear direction
> for the API. Maybe we can get a simplified user space pseudo code
> showing how the end API is supposed to look like?

Yes. For a large/arbitrary number, we may have to fetch the entire 
attribute list using a user pointer/len combo. And parse it (that's 
where all your previous questions fit).

And that can still be added on top of v8.
For example, adding a flag (in ext_cap) that disables inline-sqe 
processing and switches to external attribute buffer:

/* Second SQE has PI information */
#define EXT_CAP_PI		(1U << 0)
/* First SQE has hint information */
#define EXT_CAP_WRITE_HINT	(1U << 1)	
/* Do not assume CAP presence in SQE, and fetch capability buffer page 
instead */
#define EXT_CAP_INDIRECT 	(1U << 2)

Corresponding pointer (and/or len) can be put into last 16b of SQE.
Use the same flags/structures for the given attributes within this buffer.
That will keep things uniform and will reuse the same handling that we 
add for inline attributes.

