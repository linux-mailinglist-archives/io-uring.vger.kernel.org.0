Return-Path: <io-uring+bounces-4567-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B4D09C2438
	for <lists+io-uring@lfdr.de>; Fri,  8 Nov 2024 18:53:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7EF951C25620
	for <lists+io-uring@lfdr.de>; Fri,  8 Nov 2024 17:53:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B48FD1F26E6;
	Fri,  8 Nov 2024 17:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="u52AAiKs"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470C718DF86
	for <io-uring@vger.kernel.org>; Fri,  8 Nov 2024 17:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731087831; cv=none; b=a6r6bmPvzaFsH5WBxPASLpfy+bctzJWeIHMIDkcyj1BERo1NjstJbmiFN5pTy7YdccFW0xF2tigH9lBgDFxQdJ6YIaeS6qBFfObujT/hBz7HaX8uKMH0lOmgdcPjv5f1bacbvAG2IJC+0MUWhFJnJsFqbiUtLLbfQwHYhNiRJKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731087831; c=relaxed/simple;
	bh=nhGTjOAplgs5NW5Teuk0sGfJuFrDBwu7/AGfG8FlmTo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:Content-Type:
	 MIME-Version:References; b=FWse8JLYIfgkwaV0m1JkMxMjkFTdHNxzbG3QVk0tCexTqreErGyrOhG5ZVgNJxOfD+pTeAd0MFBsba0zF8wzYgYlJztdBssp27Fvc/EvFV8Ds1Tq7VB7nAUAmFWwWr1f49hGkucpFj8kwud1EMX1OEuZv76q+2OhGPE4664Ugw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=u52AAiKs; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20241108174347euoutp010a4d4e6afd2e1d1336c4b38d4178338f~GDzUYvTvs3203632036euoutp01t
	for <io-uring@vger.kernel.org>; Fri,  8 Nov 2024 17:43:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20241108174347euoutp010a4d4e6afd2e1d1336c4b38d4178338f~GDzUYvTvs3203632036euoutp01t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1731087827;
	bh=ToELqOgK8Fl7WyzgQlubQ8qqxlA/GF2c6qYn733st3o=;
	h=From:To:CC:Subject:Date:In-Reply-To:References:From;
	b=u52AAiKsBEAtNN1is3k/+ABJU5jEGRvpF163E1Gzr7EZXl9UZLqkyaBDNQsOLuay3
	 VZR/XGdm7hVYspRo7PxyI693xMhyrq/LNeSlANVucPQ8IiBx5P6HDfqStjONAMXoSz
	 PDX+eFFiZQPYEJWhPLovSW2OS9ddO3uka4m2VAyk=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20241108174347eucas1p2e4ff4507d2ba2c7692d3eb40e1dff5b0~GDzT_kaLp2379723797eucas1p2y;
	Fri,  8 Nov 2024 17:43:47 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
	eusmges2new.samsung.com (EUCPMTA) with SMTP id 75.76.20409.2DD4E276; Fri,  8
	Nov 2024 17:43:46 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20241108174346eucas1p2063f1c6528d6c399a13a7d1ef351931d~GDzToSnod2859328593eucas1p2e;
	Fri,  8 Nov 2024 17:43:46 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
	eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241108174346eusmtrp20b041cef8d5ac1b5b615d317b93e19f5~GDzTnvxhK0919109191eusmtrp2E;
	Fri,  8 Nov 2024 17:43:46 +0000 (GMT)
X-AuditID: cbfec7f4-c0df970000004fb9-63-672e4dd2bfed
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
	eusmgms1.samsung.com (EUCPMTA) with SMTP id 90.5E.19920.2DD4E276; Fri,  8
	Nov 2024 17:43:46 +0000 (GMT)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241108174346eusmtip2abf966de362f7009f8a57951f83f683b~GDzTaqMPi0139401394eusmtip2t;
	Fri,  8 Nov 2024 17:43:46 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348) by
	CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) with Microsoft SMTP
	Server (TLS) id 15.0.1497.2; Fri, 8 Nov 2024 17:43:45 +0000
Received: from CAMSVWEXC02.scsc.local ([::1]) by CAMSVWEXC02.scsc.local
	([fe80::3c08:6c51:fa0a:6384%13]) with mapi id 15.00.1497.012; Fri, 8 Nov
	2024 17:43:45 +0000
From: Javier Gonzalez <javier.gonz@samsung.com>
To: Matthew Wilcox <willy@infradead.org>, Keith Busch <kbusch@kernel.org>
CC: Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@meta.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"joshi.k@samsung.com" <joshi.k@samsung.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>
Subject: RE: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
Thread-Topic: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
Thread-Index: AQHbMelWveOK6b2iGEK3X1RaPLnLz7KtiFWAgAARngCAAAxgsA==
Date: Fri, 8 Nov 2024 17:43:44 +0000
Message-ID: <d7b7a759dd9a45a7845e95e693ec29d7@CAMSVWEXC02.scsc.local>
In-Reply-To: <Zy5CSgNJtgUgBH3H@casper.infradead.org>
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
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsWy7djPc7qXfPXSDXq/WFtM+/CT2WLl6qNM
	Fu9az7FYTDp0jdHizNWFLBZ7b2lb7Nl7ksVi/rKn7Bbd13ewWfz+MYfNgcvj8hVvj80rtDw2
	repk89i8pN5j980GNo9zFys8Pm+SC2CP4rJJSc3JLEst0rdL4Mp4degVa8F24YqXfXINjLf4
	uxg5OSQETCTeHWxm6mLk4hASWMEocfLUSxYI5wujRGfTczYI5zOjxL+731hgWhbNX8cIkVjO
	KHGpcyMLXNXFNZdZQaqEBE4zSqz9Ugk3+NDi12DtbAL6Equ2nwJq5+AQEfCUuPSoHqSGWeAW
	s8S1K7PBmoUFnCUOXNnPCGKLCLhIHJy7iw3CdpK4cf4fM4jNIqAiMWdnN9hMXgFXiSvL94HV
	cAKd9/XrebAaRgFZiUcrf7GD2MwC4hK3nsxngnhBUGLR7D3MELaYxL9dD9kgbAOJrUv3Qb2p
	KNE3/z0LRK+OxILdn9ggbG2JZQtfM0PsFZQ4OfMJ2PcSAvc4JVb9WsQI0ewisX/bB3YIW1ji
	1fEtULaMxP+dMEdUSzScPME0gVFrFpL7ZiHZNwvJvllI9i1gZFnFKJ5aWpybnlpslJdarlec
	mFtcmpeul5yfu4kRmLJO/zv+ZQfj8lcf9Q4xMnEwHmKU4GBWEuH1j9JOF+JNSaysSi3Kjy8q
	zUktPsQozcGiJM6rmiKfKiSQnliSmp2aWpBaBJNl4uCUamDK+e3qpCLE8rZcaNreQ+5RsV9/
	fLjHYWd5dr/unKoCxrlcFjJqyvU51qVWogduKR7r8LHVakrN/NeyJ+4IswKfxONZbffa5na8
	d13yy//SmTP9dXF387efVWnclLJlzh+PGdePO5p2X4ycsf9K6QsHz09sXxhiHH8LGb/7We80
	p1+uZ2u67qQV868wvJ4Qk/U7efbWsxLMkj6s3idfciZNZUy9npLzd8mNNz95CzW+pVfEXeY7
	OCmP1z5691+jrtMuzwtPbr6Wp/84wXftomruTqeWFw/e/Ixj3H2oV9TiP7uQ3OyS1k1XmDwj
	7RxnXv4vv7/12I5ty/Xse7/WNDBnevXvjN9XKcidecf72hMlluKMREMt5qLiRAC85dF4yAMA
	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsVy+t/xe7qXfPXSDdb+U7SY9uEns8XK1UeZ
	LN61nmOxmHToGqPFmasLWSz23tK22LP3JIvF/GVP2S26r+9gs/j9Yw6bA5fH5SveHptXaHls
	WtXJ5rF5Sb3H7psNbB7nLlZ4fN4kF8AepWdTlF9akqqQkV9cYqsUbWhhpGdoaaFnZGKpZ2hs
	HmtlZKqkb2eTkpqTWZZapG+XoJfx6tAr1oLtwhUv++QaGG/xdzFyckgImEgsmr+OsYuRi0NI
	YCmjxK4Ll1ggEjISG79cZYWwhSX+XOtigyj6yCjx7+FMVgjnNKPE0nubmSCcFYwSjzp+MIK0
	sAnoS6zafgrI5uAQEfCUuPSoHqSGWeAWs8S1K7PBxgoLOEscuLIfrF5EwEXi4NxdbBC2k8SN
	8/+YQWwWARWJOTu7wU7iFXCVuLJ8H1iNkMBGJolJLbIgNifQD1+/ngerZxSQlXi08hc7iM0s
	IC5x68l8JogXBCSW7IGokRAQlXj5+B/UawYSW5fug3pZUaJv/nsWiF4diQW7P7FB2NoSyxa+
	Zoa4QVDi5MwnLBMYpWYhWTELScssJC2zkLQsYGRZxSiSWlqcm55bbKhXnJhbXJqXrpecn7uJ
	EZheth37uXkH47xXH/UOMTJxMB5ilOBgVhLh9Y/SThfiTUmsrEotyo8vKs1JLT7EaAoMl4nM
	UqLJ+cAEl1cSb2hmYGpoYmZpYGppZqwkzut2+XyakEB6YklqdmpqQWoRTB8TB6dUA9Oytbxd
	1ewhAUJPXZUDy+b9yBEru5z1WftZf7eq9XnuaMs3+fIJXxtmMWRvZ2aSsImuzXi8S5XxVpXu
	TvmZQevzDsixr30d9lJKxvnrj8kTLlxkejhrrVnrr4VX9msciWtv3MLHN2GKyrxVD5anMKyx
	l43LPnw02KYh37kl+Mb88CuL2D9pHZXkj3v5NCSHl/mPYqG2yTIOLRHmfXdVHLzzwrpeypVN
	23xu0+UZSWYTCg4vnfLY51sa9/rXm5wnxguESBxSrDH9tMx9xW7Vl7OsVvyfLHfH48d1Dg9p
	g+aNX76cOBu+9UKB8Oxlt+a523fKW0+7LVGZx7306PfT5+NX31w0W35F25euxXfyVjcrsRRn
	JBpqMRcVJwIA7++iPLgDAAA=
X-CMS-MailID: 20241108174346eucas1p2063f1c6528d6c399a13a7d1ef351931d
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

> -----Original Message-----
> From: Matthew Wilcox <willy@infradead.org>
> Sent: Friday, November 8, 2024 5:55 PM
> To: Keith Busch <kbusch@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>; Keith Busch <kbusch@meta.com>; linux-
> block@vger.kernel.org; linux-nvme@lists.infradead.org; linux-scsi@vger.ke=
rnel.org;
> io-uring@vger.kernel.org; linux-fsdevel@vger.kernel.org; joshi.k@samsung.=
com;
> Javier Gonzalez <javier.gonz@samsung.com>; bvanassche@acm.org
> Subject: Re: [PATCHv10 0/9] write hints with nvme fdp, scsi streams
>=20
> On Fri, Nov 08, 2024 at 08:51:31AM -0700, Keith Busch wrote:
> > On Fri, Nov 08, 2024 at 03:18:52PM +0100, Christoph Hellwig wrote:
> > > We're not really duplicating much.  Writing sequential is pretty easy=
,
> > > and tracking reclaim units separately means you need another tracking
> > > data structure, and either that or the LBA one is always going to be
> > > badly fragmented if they aren't the same.
> >
> > You're getting fragmentation anyway, which is why you had to implement
> > gc. You're just shifting who gets to deal with it from the controller t=
o
> > the host. The host is further from the media, so you're starting from a
> > disadvantage. The host gc implementation would have to be quite a bit
> > better to justify the link and memory usage necessary for the copies
> > (...queue a copy-offload discussion? oom?).
>=20
> But the filesystem knows which blocks are actually in use.  Sending
> TRIM/DISCARD information to the drive at block-level granularity hasn't
> worked out so well in the past.  So the drive is the one at a disadvantag=
e
> because it has to copy blocks which aren't actually in use.

It is true that trim has not been great. I would say that at least enterpri=
se
SSDs have fixed this in general. For FDP, DSM Deallocate is respected, whic=
h
Provides a good "erase" interface to the host.

It is true though that this is not properly described in the spec and we sh=
ould
fix it.

>=20
> I like the idea of using copy-offload though.

We have been iterating in the patches for years, but it is unfortunately
one of these series that go in circles forever. I don't think it is due
to any specific problem, but mostly due to unaligned requests form
different folks reviewing. Last time I talked to Damien he asked me to=20
send the patches again; we have not followed through due to bandwidth.

If there is an interest, we can re-spin this again...

