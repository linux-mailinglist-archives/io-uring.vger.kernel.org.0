Return-Path: <io-uring+bounces-3646-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 21DC199C09A
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 09:02:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5860282947
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 07:02:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3492136353;
	Mon, 14 Oct 2024 07:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="tIRxUoQw"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7D61304AB
	for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 07:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728889344; cv=none; b=KDS0GFnsDd75G88jY/nlvOfuLfaJ6MKqk6OaX7Z9p3dKKo5VCyzCoFbNlN5ZiiAWpcWJwJPz+xVdKXsQCWQxLk/J78HHQmME28ZYCA0CS4m1EttEPAVFCP/C9on0cNTEwgFLvX2sXPpihFH6MzB7FcpiFjSjBpz/g+TbUmGeXZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728889344; c=relaxed/simple;
	bh=SmROGCa4ODfMNM06U1XIp0xcwdm/2fwKv1cq9rxYAdM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:Content-Type:
	 MIME-Version:References; b=NWApdyrtcIGlAbxH2BCDGz54aGX7RSOdnUprlSx3xVL+uoNe67ZjykinSy9p4PdwDkJZJNDgNVn6jZCxz086KeoklEla8R3fCxvIeq2AvwW+cXpWPMydLUgNPqWGqqNiUg6k3LJMKAVwstU0sVmOgkJmBxIzRVKJ6xrfu7SKvb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=tIRxUoQw; arc=none smtp.client-ip=210.118.77.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20241014070214euoutp026a16f98844eb2d84909a1bc01a5a5a1a~_P7CsF6iD2619026190euoutp02_
	for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 07:02:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20241014070214euoutp026a16f98844eb2d84909a1bc01a5a5a1a~_P7CsF6iD2619026190euoutp02_
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1728889335;
	bh=sunEOuEjHhNMgJphtcwxnab8BPFnOqcscTv1UUEzpCQ=;
	h=From:To:CC:Subject:Date:In-Reply-To:References:From;
	b=tIRxUoQwdjLi2sKdpnpsInQ1Wks94YXQ5FGkQcAmDu7F2Fx1hz5b3SSBnWRGwkmIk
	 Haep0mOZ7DJz9O9Q/9ozppwx4IvNRc0DwhscDvWbEviLvw9Ax376FN1MW+S7S1ZAK3
	 GP99m/l9WNc6CGZDA1U8RTHOPJQG8h7vLBnZatHs=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20241014070214eucas1p2e260aee82bbc2fe7c63b492d41d59f0c~_P7CMDN832659426594eucas1p2Y;
	Mon, 14 Oct 2024 07:02:14 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges2new.samsung.com (EUCPMTA) with SMTP id 4F.C1.09875.6F1CC076; Mon, 14
	Oct 2024 08:02:14 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20241014070214eucas1p190fe5b4e645abd0198787349ba61f845~_P7BxlZ-92283422834eucas1p1Z;
	Mon, 14 Oct 2024 07:02:14 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241014070213eusmtrp201aecd3d92d4fe6034c8f2b5c42be2a3~_P7Bwzivu2164021640eusmtrp2W;
	Mon, 14 Oct 2024 07:02:13 +0000 (GMT)
X-AuditID: cbfec7f4-131ff70000002693-cb-670cc1f69da7
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id 89.92.19096.5F1CC076; Mon, 14
	Oct 2024 08:02:13 +0100 (BST)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241014070213eusmtip1c2a05b35489ff0f9da38e9ac1c867b72~_P7BjkM-Z2718327183eusmtip1h;
	Mon, 14 Oct 2024 07:02:13 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348) by
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348) with Microsoft SMTP
	Server (TLS) id 15.0.1497.2; Mon, 14 Oct 2024 08:02:12 +0100
Received: from CAMSVWEXC02.scsc.local ([::1]) by CAMSVWEXC02.scsc.local
	([fe80::3c08:6c51:fa0a:6384%13]) with mapi id 15.00.1497.012; Mon, 14 Oct
	2024 08:02:12 +0100
From: Javier Gonzalez <javier.gonz@samsung.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC: Keith Busch <kbusch@kernel.org>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Kanchan Joshi <joshi.k@samsung.com>,
	"hare@suse.de" <hare@suse.de>, "sagi@grimberg.me" <sagi@grimberg.me>,
	"brauner@kernel.org" <brauner@kernel.org>, "viro@zeniv.linux.org.uk"
	<viro@zeniv.linux.org.uk>, "jack@suse.cz" <jack@suse.cz>,
	"jaegeuk@kernel.org" <jaegeuk@kernel.org>, "bcrl@kvack.org"
	<bcrl@kvack.org>, "dhowells@redhat.com" <dhowells@redhat.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "asml.silence@gmail.com"
	<asml.silence@gmail.com>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-aio@kvack.org" <linux-aio@kvack.org>,
	"gost.dev@samsung.com" <gost.dev@samsung.com>, "vishak.g@samsung.com"
	<vishak.g@samsung.com>
Subject: RE: [PATCH v7 0/3] FDP and per-io hints
Thread-Topic: [PATCH v7 0/3] FDP and per-io hints
Thread-Index: AQHbG7xJFahlOOmkRUWBz3B/P2gFpLKBuCIAgAQCOYCAABtsUA==
Date: Mon, 14 Oct 2024 07:02:11 +0000
Message-ID: <34d3ad68068f4f87bf0a61ea8fb8f217@CAMSVWEXC02.scsc.local>
In-Reply-To: <20241014062125.GA21033@lst.de>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjk+LIzCtJLcpLzFFi42LZduznOd1vB3nSDW6cE7OYs2obo8Xqu/1s
	Fl3/trBYvD78idFi2oefzBbvmn6zWOxZNInJYuXqo0wW71rPsVjMnt7MZPFk/Sxmi0mHrjFa
	TJnWxGix95a2xZ69J1ks5i97ym6x/Pg/Jot1r9+zWJz/e5zVQdjj8hVvj52z7rJ7nL+3kcXj
	8tlSj02rOtk8Nn2axO6xeUm9x+6bDWweH5/eYvF4v+8qm8eZBUeA4qerPT5vkvPY9OQtUwBf
	FJdNSmpOZllqkb5dAlfGvzcT2AsaeCt2zV/K1sD4jKuLkZNDQsBE4t+X76xdjFwcQgIrGCV2
	/rzHAuF8YZS4+LAbKvOZUaJj+UZGmJb3q98xQSSWM0o8eX8DoWrRxn6ozBlGid0nFrKAtAgJ
	rGSU+HTFF8RmE9CXWLX9FNgoEQEHidkblrKBNDAL7GCX6DnTxw6SEBYwkGhesg+qyFDi3bKF
	ULaTxL7+N6wgNouAqsTL6yuA6jk4eAVcJdZ1G4KEOQV0JD7PewA2hlFAVuLRyl9gNrOAuMSt
	J/OZIF4QlFg0ew8zhC0m8W/XQzYI20Bi69J9LBC2okTf/PcsEL06Egt2f2KDsLUlli18DdbL
	CzTn5Mwn4ACTEDjLJTHv+AeoBS4SG8/0QcNLWOLV8S3sELaMxP+dMEdUSzScPME0gVFrFpL7
	ZiHZNwvJvllI9i1gZFnFKJ5aWpybnlpslJdarlecmFtcmpeul5yfu4kRmFRP/zv+ZQfj8lcf
	9Q4xMnEwHmKU4GBWEuF9P5UzXYg3JbGyKrUoP76oNCe1+BCjNAeLkjivaop8qpBAemJJanZq
	akFqEUyWiYNTqoEpo+/Kbpa34VpFG6SXB80P2rLapOtFz/6/0rGpxpbzxBcG6u9LMbQwlXV+
	2dB0pzxj/rvi1Fbe6BvBy7oLNaKyXxndm7KLiePDg4kh1rPNZp/r5Wbbw7k4zS5uaTtvV0vj
	kRsJK9//P6zNHax+6JnTOuVDr5tOvW1omyDa8WyF9qZyxTfyMnbKMlMsq42+W3y952XlpT/n
	aMUkjaSn7+9c5k2o/H28dVPsdO1s/8i+Fd6XvOoOS3/pWKhamfCqR6nu7CrZOibFY/+3vbHo
	Oy4R9O+4lnb1/0VtVxu/Lr80p0pCueW46a6dvLnxzTFOVzjkV6V9sKpuXPJmg2ekrfOqZ225
	X1YXHJT+8NvB7YcSS3FGoqEWc1FxIgC8zrr0GQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUxbZRSH9957ub3FdblrmXslarSTmFC8tIXWl212xLjlZrhpon8oTmYz
	LgXlY/aDOc2wwky2buFrCNoRaJUPgYijw26z0IUO6ZBthLExx1YlWAwb2K6MacpGJ/Riwn/P
	ec958st5cyhc/G9MPJVXaOT0hdp8KRlLDEW8vpce9K3Vyc9MqVF9uxOgDl8FiSyRbgLNXJgD
	qPZeGEeB0ocE6vm2GkNtHb9gKPDlFQKdrCvDkP9HK46qPWMA1dSWAtQ7LkM9vYMEamyZEqBW
	bwRDnTNBAg0vemPSJezotQz2nNUnYId/7yLY0csm1tF+lGQdc9UC9nTT56zrpplkQ1PjBBt0
	XyfZS7b+pfehz9j7jmdZh/9v7M11mcxWfZHJyD2XW2QwviJ9T4GUjCINMcrUNEaR8vL7m5Uq
	abJmazaXn1fM6ZM1HzC5kdlKwX6z6JOfG5tJM/gr1gKEFKRTYbAjgFlALCWmmwGMWKpIvvE0
	7Jq/HsOzBD4as5D8UAjA0JEKwBeXAPTUHSf4og1A29wFbFkh6WTYfuZXsMxxdDo8eao5quO0
	UwDPPezHlxsSWg7LmtwrQwoYaLGv8KvQXTEbzSboBHjnxvcCC6AoEb0ddh5T8GG3cXjq2I1o
	mJBOgvcbJgTLDOhn4GTbQpRxeiMc9zdi/A40bOoZxnneAO/8GVnZTQ5/anYTPD8PyxuDBO8m
	QZtrjuRZBlvsM1FXRK+Hg9/4iUoQb10VYV2lWFcp1lWKDRDtII4zGQp0BQYlY9AWGEyFOmZf
	UYEDLF2gcyDcfRa03Q0xHoBRwAMghUvjRMGvhDqxKFt78FNOX7RXb8rnDB6gWvqXKjx+w76i
	pRMuNO5VqOUqRao6Ta5KU6dIN4rIa8M5YlqnNXIfcdx+Tv+/h1HCeDPmFC/c3NmP1fR2Hqp9
	/EPOeXdpuiZlh2x2zbbdhrreVs2OI4tZb+mwzp3Zki31551XWrftqaghLnY37JYNPqVZHCh5
	bd5boyzdXDzt87rWqS3Gw70zfZuq8v1fh7JCvrGJQ3ZYcvnuLfHg/ERZpnO6WM1lvejMrEQJ
	73z37mR4/IDthfLHXkrfZf6tT0AUJ/qnmSb3vdOyg7jNXh4rORtwJO4iwwsNa9d/nPFIbcp4
	g2h9u3n0ySz70ETHouR1/KpmYI9K4vJ/iBXnza+5qDu65Z+r2w8E60fEqhNPlHRpLHXhL04I
	byclCEfInMqGySEXg4iRasAcRvbjf8hvPZAShlytIhHXG7T/AfIBTv4KBAAA
X-CMS-MailID: 20241014070214eucas1p190fe5b4e645abd0198787349ba61f845
X-Msg-Generator: CA
X-RootMTR: 20241010070738eucas1p2057209e5f669f37ca586ad4a619289ed
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20241010070738eucas1p2057209e5f669f37ca586ad4a619289ed
References: <20241008122535.GA29639@lst.de> <ZwVFTHMjrI4MaPtj@kbusch-mbp>
	<20241009092828.GA18118@lst.de> <Zwab8WDgdqwhadlE@kbusch-mbp>
	<CGME20241010070738eucas1p2057209e5f669f37ca586ad4a619289ed@eucas1p2.samsung.com>
	<20241010070736.de32zgad4qmfohhe@ArmHalley.local>
	<20241010091333.GB9287@lst.de>
	<20241010115914.eokdnq2cmcvwoeis@ArmHalley.local>
	<20241011090224.GC4039@lst.de>
	<5e9f7f1c-48fd-477f-b4ba-c94e6b50b56f@kernel.dk>
	<20241014062125.GA21033@lst.de>

> -----Original Message-----
> From: Christoph Hellwig <hch@lst.de>
> Sent: Monday, October 14, 2024 8:21 AM
> To: Jens Axboe <axboe@kernel.dk>
> Cc: Christoph Hellwig <hch@lst.de>; Javier Gonzalez <javier.gonz@samsung.=
com>;
> Keith Busch <kbusch@kernel.org>; Martin K. Petersen
> <martin.petersen@oracle.com>; Kanchan Joshi <joshi.k@samsung.com>;
> hare@suse.de; sagi@grimberg.me; brauner@kernel.org; viro@zeniv.linux.org.=
uk;
> jack@suse.cz; jaegeuk@kernel.org; bcrl@kvack.org; dhowells@redhat.com;
> bvanassche@acm.org; asml.silence@gmail.com; linux-nvme@lists.infradead.or=
g;
> linux-fsdevel@vger.kernel.org; io-uring@vger.kernel.org; linux-
> block@vger.kernel.org; linux-aio@kvack.org; gost.dev@samsung.com;
> vishak.g@samsung.com
> Subject: Re: [PATCH v7 0/3] FDP and per-io hints
>=20
> On Fri, Oct 11, 2024 at 11:08:26AM -0600, Jens Axboe wrote:
> >
> > I think that last argument is a straw man - for any kind of interface
> > like this, we've ALWAYS just had the rule that any per-whatever
> > overrides the generic setting.
>=20
> And exactly that is the problem.  For file systems we can't support
> that sanely.  So IFF you absolutely want the per-I/O hints we need
> an opt in by the file operations.  I've said that at least twice
> in this discussion before, but as everyone likes to have political
> discussions instead of technical ones no one replied to that.

Is it a way forward to add this in a new spin of the series - keeping the=20
temperature mapping on the NVMe side?

If not, what would be acceptable for a first version, before getting into a=
dding
a new interface to expose agnostic hints?


