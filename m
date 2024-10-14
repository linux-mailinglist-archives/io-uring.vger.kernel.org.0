Return-Path: <io-uring+bounces-3652-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F1A199C4EF
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 11:11:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 61BEF1C22354
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 09:11:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B866819D8A0;
	Mon, 14 Oct 2024 09:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="qOdKVBJC"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DEF19D07D
	for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 09:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.118.77.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728896911; cv=none; b=EhddQX77HHK/9GYECf1H6udibbCA9rZGiRimx9nrj9qzLpOxDS8zQC2btGD8CCkUXCjPGsvX/L3k5ZU+3zH27sSwrSFnto9vL7j5WkafhUh9GGUHYu+iMlxllDM5F+h20QOZUkQP80K4wlh3EBgRMeS4GB0ifs5puJrng2cHfC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728896911; c=relaxed/simple;
	bh=I7k382vBQLqWgAZva9nJuw/OydYDSBL+SsP2DwlHAKM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:Content-Type:
	 MIME-Version:References; b=sBwg2ILzdtG8zK1uYT/60TV/7xCzmyXMMOIDqA/BPMr7uigl2ry7PAlSq9S8tS3NiYf3VuYS+lOe5Qp55u7E1InCFPawq++e6IBxC1Am12vgigPH2EaCXGhvCDo+88y4Aj+eQNzoCauj6ho3pVe06XgAaWWdjU2I+WlFatZMUoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=qOdKVBJC; arc=none smtp.client-ip=210.118.77.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20241014090827euoutp014759cd2171362997073055eed3afb4b8~_RpOwcZ3F2915629156euoutp01T
	for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 09:08:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20241014090827euoutp014759cd2171362997073055eed3afb4b8~_RpOwcZ3F2915629156euoutp01T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1728896907;
	bh=z3B/ennZQ25BkssBjHXIYaI5QeMwto4rU9yLnRu2n6E=;
	h=From:To:CC:Subject:Date:In-Reply-To:References:From;
	b=qOdKVBJCKFK4ROrAIb9NjIlAtiBWfL/MZNnLD1URm00M9GCbx97/qxcpBXhg3gt1q
	 qfKVRjEuPAYb1wQdWEsWn6aMB2HsabfeULcYlHDVYdGTn/m1xt0Q2srA5lQOY4FVmt
	 3fL0BzvFIg1mdB4AzHmD6fVJqsVVQbaYmTutiTBg=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTP id
	20241014090826eucas1p1122e756848ed71ce9e01d7e4de9033a7~_RpOPwIyc0836108361eucas1p1m;
	Mon, 14 Oct 2024 09:08:26 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
	eusmges3new.samsung.com (EUCPMTA) with SMTP id 70.B8.09620.A8FDC076; Mon, 14
	Oct 2024 10:08:26 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20241014090826eucas1p20a1b983ba65066f2970d11ae6e5518c5~_RpNzgGIy1059610596eucas1p2Z;
	Mon, 14 Oct 2024 09:08:26 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241014090826eusmtrp1637a132b47c5a85d29f95a5a6d9140c0~_RpNyq1AR1839218392eusmtrp1J;
	Mon, 14 Oct 2024 09:08:26 +0000 (GMT)
X-AuditID: cbfec7f5-d1bff70000002594-8f-670cdf8a7777
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id 19.1D.19096.98FDC076; Mon, 14
	Oct 2024 10:08:25 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20241014090825eusmtip1835d4a520fbab01b407256736ee0de53~_RpNm0_zd1645016450eusmtip1X;
	Mon, 14 Oct 2024 09:08:25 +0000 (GMT)
Received: from CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348) by
	CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) with Microsoft SMTP
	Server (TLS) id 15.0.1497.2; Mon, 14 Oct 2024 10:08:25 +0100
Received: from CAMSVWEXC02.scsc.local ([::1]) by CAMSVWEXC02.scsc.local
	([fe80::3c08:6c51:fa0a:6384%13]) with mapi id 15.00.1497.012; Mon, 14 Oct
	2024 10:08:24 +0100
From: Javier Gonzalez <javier.gonz@samsung.com>
To: Christoph Hellwig <hch@lst.de>
CC: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, "Martin
 K. Petersen" <martin.petersen@oracle.com>, Kanchan Joshi
	<joshi.k@samsung.com>, "hare@suse.de" <hare@suse.de>, "sagi@grimberg.me"
	<sagi@grimberg.me>, "brauner@kernel.org" <brauner@kernel.org>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "jack@suse.cz"
	<jack@suse.cz>, "jaegeuk@kernel.org" <jaegeuk@kernel.org>, "bcrl@kvack.org"
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
Thread-Index: AQHbG7xJFahlOOmkRUWBz3B/P2gFpLKBuCIAgAQCOYCAABtsUP///IcAgAAiAcA=
Date: Mon, 14 Oct 2024 09:08:24 +0000
Message-ID: <9e3792eebf7f427db7c466374972fb99@CAMSVWEXC02.scsc.local>
In-Reply-To: <20241014074708.GA22575@lst.de>
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
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgk+LIzCtJLcpLzFFi42LZduzned2u+zzpBp++SFvMWbWN0WL13X42
	i65/W1gsXh/+xGgx7cNPZot3Tb9ZLPYsmsRksXL1USaLd63nWCxmT29msniyfhazxaRD1xgt
	pkxrYrTYe0vbYs/ekywW85c9ZbdYfvwfk8W61+9ZLM7/Pc7qIOxx+Yq3x85Zd9k9zt/byOJx
	+Wypx6ZVnWwemz5NYvfYvKTeY/fNBjaPj09vsXi833eVzePMgiNA8dPVHp83yXlsevKWKYAv
	issmJTUnsyy1SN8ugStj4dKPLAUPVCp2rPnG3sC4SLaLkZNDQsBE4sfDJcxdjFwcQgIrGCXe
	TZnGBuF8YZSY/+YiVOYzo8S8NwtYYFqWnnnCCJFYDlR1ZwoLXNXiSb1QmTOMEgtWnYHqX8ko
	8elrFxtIP5uAvsSq7acYQWwRASWJp6/OgnUwC1xjlzjYc4YJJCEsYCDRvGQfVJGhxLtlC6Fs
	P4mf336BHcIioCrxZu4UdhCbV8BVouXMN7A4p4COxLIFJ8HmMArISjxa+QushllAXOLWk/lM
	EE8ISiyavYcZwhaT+LfrIRuEbSCxdek+qEcVJfrmv2eB6NWRWLD7ExuErS2xbOFrZoi9ghIn
	Zz4B+19C4CSXxJf5j9ghml0kZv67DmULS7w6vgXKlpE4PbkHakG1RMPJE0wTGLVmIblvFpJ9
	s5Dsm4Vk3wJGllWM4qmlxbnpqcXGeanlesWJucWleel6yfm5mxiBifX0v+NfdzCuePVR7xAj
	EwfjIUYJDmYlEd73UznThXhTEiurUovy44tKc1KLDzFKc7AoifOqpsinCgmkJ5akZqemFqQW
	wWSZODilGphqQ1Q+LPbgq+m7KHbI4Vv3+YR17W6Mp6z3rhQJPP7Haf+kk5rHHsYtkQpdoJiQ
	PlP48VbzqmX6666tbXpZ0P/kYfujDdE7Ugtmhv/co/KJudt3q/PZuhet5e9Zbe63vIzW1frM
	fcbW23DNHolDe6ayMMpdFZTRnKvRxz8l80+597aecuVlUmXRB90V+RwOsx0/Lp57VqJedu9L
	NrWr6fqbfTbN1+GXvCPJUXjZnvtrTw5vbmCX0M1tfSovNs1+xDj3s4bD1a7fafaHecrn77ao
	kf92c1XVgyVLT6woe72hTonf6J5v0oXHifF8844lHVCsNRM8pcrW+3T6X4Ui9h6O1HCjnAL7
	S3w3dl09kaXEUpyRaKjFXFScCACFqAVQGwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOKsWRmVeSWpSXmKPExsVy+t/xu7qd93nSDR5Os7GYs2obo8Xqu/1s
	Fl3/trBYvD78idFi2oefzBbvmn6zWOxZNInJYuXqo0wW71rPsVjMnt7MZPFk/Sxmi0mHrjFa
	TJnWxGix95a2xZ69J1ks5i97ym6x/Pg/Jot1r9+zWJz/e5zVQdjj8hVvj52z7rJ7nL+3kcXj
	8tlSj02rOtk8Nn2axO6xeUm9x+6bDWweH5/eYvF4v+8qm8eZBUeA4qerPT5vkvPY9OQtUwBf
	lJ5NUX5pSapCRn5xia1StKGFkZ6hpYWekYmlnqGxeayVkamSvp1NSmpOZllqkb5dgl7GwqUf
	WQoeqFTsWPONvYFxkWwXIyeHhICJxNIzTxi7GLk4hASWMkr8+drCBJGQkdj45SorhC0s8eda
	FxtE0UdGidPHLzKCJIQEzjBKbL0TApFYySix+McDNpAEm4C+xKrtp8CKRASUJJ6+Ogu2glng
	CrtE86LnYAlhAQOJ5iX7oIoMJd4tWwhl+0n8/PaLBcRmEVCVeDN3CjuIzSvgKtFy5hsLxLZf
	zBIb1lwGa+AU0JFYtuAk2N2MArISj1b+AmtgFhCXuPVkPtQ/AhJL9pxnhrBFJV4+/gf1m4HE
	1qX7WCBsRYm++e9ZIHp1JBbs/sQGYWtLLFv4mhniCEGJkzOfsExglJqFZMUsJC2zkLTMQtKy
	gJFlFaNIamlxbnpusZFecWJucWleul5yfu4mRmAK3Hbs55YdjCtffdQ7xMjEwXiIUYKDWUmE
	9/1UznQh3pTEyqrUovz4otKc1OJDjKbAgJnILCWanA9Mwnkl8YZmBqaGJmaWBqaWZsZK4rxs
	V86nCQmkJ5akZqemFqQWwfQxcXBKNTD5HcjP5Z8t3Ten+GZ9vAWD98qcjtdRaYGJJttEDxx9
	cvL0lfnMhe4Bv4JCG4sK46wOXuaaHtqisUp3w0vBKof5Ze28K9LmH2T70CbaN1PYq7tLvHZn
	xtXsp1Fx1dv8ZcWdlV5eWtIo9ma9/aRPzhmtKuvDuJ9NOThb72J1x/a7Ow0D0v98X/0gxd2o
	c/+PYtuHC1j3RRRMT96b/9rjyW7HHUKnlniGumuz3vp2PimpI3/25ORq6QfNB+SOLJvVt2qD
	jmPJn8ZIP4PksnMcMdtvGjr8UfnPsrb5cLPUWTch7VZuNhlTf/WJ4fWs2foSYosu80pIztn+
	RXLTrdmXchet7V7qo5LJ/kBp907d9UosxRmJhlrMRcWJAMKylzUKBAAA
X-CMS-MailID: 20241014090826eucas1p20a1b983ba65066f2970d11ae6e5518c5
X-Msg-Generator: CA
X-RootMTR: 20241010070738eucas1p2057209e5f669f37ca586ad4a619289ed
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20241010070738eucas1p2057209e5f669f37ca586ad4a619289ed
References: <20241009092828.GA18118@lst.de> <Zwab8WDgdqwhadlE@kbusch-mbp>
	<CGME20241010070738eucas1p2057209e5f669f37ca586ad4a619289ed@eucas1p2.samsung.com>
	<20241010070736.de32zgad4qmfohhe@ArmHalley.local>
	<20241010091333.GB9287@lst.de>
	<20241010115914.eokdnq2cmcvwoeis@ArmHalley.local>
	<20241011090224.GC4039@lst.de>
	<5e9f7f1c-48fd-477f-b4ba-c94e6b50b56f@kernel.dk>
	<20241014062125.GA21033@lst.de>
	<34d3ad68068f4f87bf0a61ea8fb8f217@CAMSVWEXC02.scsc.local>
	<20241014074708.GA22575@lst.de>

> -----Original Message-----
> From: Christoph Hellwig <hch@lst.de>
> Sent: Monday, October 14, 2024 9:47 AM
> To: Javier Gonzalez <javier.gonz@samsung.com>
> Cc: Christoph Hellwig <hch@lst.de>; Jens Axboe <axboe@kernel.dk>; Keith B=
usch
> <kbusch@kernel.org>; Martin K. Petersen <martin.petersen@oracle.com>; Kan=
chan
> Joshi <joshi.k@samsung.com>; hare@suse.de; sagi@grimberg.me;
> brauner@kernel.org; viro@zeniv.linux.org.uk; jack@suse.cz; jaegeuk@kernel=
.org;
> bcrl@kvack.org; dhowells@redhat.com; bvanassche@acm.org;
> asml.silence@gmail.com; linux-nvme@lists.infradead.org; linux-
> fsdevel@vger.kernel.org; io-uring@vger.kernel.org; linux-block@vger.kerne=
l.org;
> linux-aio@kvack.org; gost.dev@samsung.com; vishak.g@samsung.com
> Subject: Re: [PATCH v7 0/3] FDP and per-io hints
>=20
> On Mon, Oct 14, 2024 at 07:02:11AM +0000, Javier Gonzalez wrote:
> > > And exactly that is the problem.  For file systems we can't support
> > > that sanely.  So IFF you absolutely want the per-I/O hints we need
> > > an opt in by the file operations.  I've said that at least twice
> > > in this discussion before, but as everyone likes to have political
> > > discussions instead of technical ones no one replied to that.
> >
> > Is it a way forward to add this in a new spin of the series - keeping t=
he
> > temperature mapping on the NVMe side?
>=20
> What do you gain from that?  NVMe does not understand data temperatures,
> so why make up that claim? =20

I expressed this a couple of times in this thread. It is no problem to map =
temperatures
to a protocol that does not understand the semantics. It is not perfect, an=
d in time
I agree that we would benefit from exposing the raw hints without semantics=
 from
Block layer upwards.

But the temperatures are already there. We are not adding anything new. And=
 thanks
to this, we can enable existing users with _minimal_ changes to user-space.=
 As pointed
on the XFS zoned discussions, this is very similar to what you guys are doi=
ng (exactly to
re-use what it is already there), and it works. On top of this,  applicatio=
ns that already
understand temperatures (e.g., RocksDB) will be able to leverage FDP SSDs w=
ithout changes.

> Especially as it directly undermindes any file system work to actually ma=
ke use of it.

I do not think it does. If a FS wants to use the temperatures, then they wo=
uld be able to leverage
FDP besides SCSI. And if we come up with a better interface later on, we ca=
n make the changes then.
I really do not see the issue. If we were adding a temperature abstraction =
now, I would agree with
You that we would need to cover the use-case you mention for FSs from the b=
eginning, but this
Is already here. Seems like a fair compromise to support current users.


>=20
> > If not, what would be acceptable for a first version, before getting in=
to adding
> > a new interface to expose agnostic hints?
>=20
> Just iterate on Kanchan's series for a block layer (and possible user lev=
el,
> but that's less urgent) interface for stream separation?

We can work on this later, but it is not that easy. Look at the mail I forw=
arded=20
Form Christian. We now can store hints in the same structure as the tempera=
tures.=20
I believe that we would be able to support 128 hints. If we are serious abo=
ut supporting=20
hints as a general interface, 128 hints is not nearly enough. Moreover:

  - How do we convince VFS folks to give us more space for hints at this po=
int?
  - How do we make agnostic hints and temperature co-exist? Do we use a bit=
 to select=20
     and create a protocol? This seems over-complicated
  - When we are exposing general hints to the block layer, how do we suppor=
t N:N=20
     FS:Block_Devices? and DMs? This is not obvious, and it goes well beyon=
d what we
     need today, but we probably need to think about it.
=20
And these are just questions that we know. You see that this is a big lift =
(which we=20
can work together on!), but will delay current users by months. And honestl=
y, I do
not feel comfortable doing this alone; we need application and  FS folks li=
ke you to=20
help guide this so that it is really usable.

I say it again: Your idea about properly supporting hints in FS is good, an=
d I think we should
work on it. But I do not believe that the current patches (with added thing=
s like opt in file ops)=20
get in the way of this.  So if the disagreement is if these patches are har=
mful, let's talk about=20
this explicitly and try to agree; we do not need to go over the need for a =
new hint interface.=20
We already agree on this.


