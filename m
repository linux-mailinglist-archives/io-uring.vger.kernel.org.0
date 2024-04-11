Return-Path: <io-uring+bounces-1517-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 567958A2265
	for <lists+io-uring@lfdr.de>; Fri, 12 Apr 2024 01:40:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9DE10B21B31
	for <lists+io-uring@lfdr.de>; Thu, 11 Apr 2024 23:40:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CF86481D5;
	Thu, 11 Apr 2024 23:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ho5r0dZg"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D64C481CD;
	Thu, 11 Apr 2024 23:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.189.100.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712878829; cv=none; b=HL0V46fCzXNLJMpFdQwjtUkj+EIZHeQ5a/+7ELR7zqvmxzh0xcfRIDB+7/LNkAmQYltcc6kDPT/2KF2536W3upCoecy2rxYbeW1/uMS47abqmRkQkBxbw8SqIb0BxU1G/ywp25Te+Rc71TTx7Df3QgEuXIbZC0c9D7/AHp+ecAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712878829; c=relaxed/simple;
	bh=c2lrykSDYsNgHFapiDKwlkU8iy8lTbib/ksJGkCNj+8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:Content-Type:
	 MIME-Version:References; b=R5eSohWENp2GjZotiidq7Jl8mP8s0iXOKjB9JBDa0JTyOVKYNKgzQfVR6nqUeI3OEfXRR2JEbOp7oCufl/WIJhXUR9jYgono2VRPteybq1+5H0QnqZTvAWZYxH+4Byu/6nV6MOho/d/uK32ozSQxjRO4eqeJPjK7nOxt76EM74k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ho5r0dZg; arc=none smtp.client-ip=211.189.100.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
	by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20240411233246usoutp028a5b02b4dcbfb3d683dab6b51f675731~FXcyhy2t_2005920059usoutp02Z;
	Thu, 11 Apr 2024 23:32:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20240411233246usoutp028a5b02b4dcbfb3d683dab6b51f675731~FXcyhy2t_2005920059usoutp02Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1712878366;
	bh=c2lrykSDYsNgHFapiDKwlkU8iy8lTbib/ksJGkCNj+8=;
	h=From:To:CC:Subject:Date:In-Reply-To:References:From;
	b=ho5r0dZgzRL8Hjg61uiu/IGgA+rJ9hnLy8csN32/Al6sM6TLx6HjcXDogz8hM8da1
	 fRZ3B2v5hoA0w4ZG/cBapJdXeeE3GcPTwziXYnOL5ltDijHwKvG3D0wzCLUdKos/u5
	 VZWd9XqkLSyjl6vRjQLxOEnimI2DpL2VKw9wW7Qk=
Received: from ussmges2new.samsung.com (u111.gpu85.samsung.co.kr
	[203.254.195.111]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
	20240411233246uscas1p240be41491e39efbc60de2800fc1a7a3b~FXcyWnVzS0520605206uscas1p2r;
	Thu, 11 Apr 2024 23:32:46 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
	ussmges2new.samsung.com (USCPEMTA) with SMTP id 72.98.09760.E1378166; Thu,
	11 Apr 2024 19:32:46 -0400 (EDT)
Received: from ussmgxs1new.samsung.com (u89.gpu85.samsung.co.kr
	[203.254.195.89]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
	20240411233246uscas1p1373da501b9cb88b9c36c3bab0f937e01~FXcx3Gubx1921019210uscas1p1W;
	Thu, 11 Apr 2024 23:32:46 +0000 (GMT)
X-AuditID: cbfec36f-7f9ff70000002620-10-6618731e5dfb
Received: from SSI-EX4.ssi.samsung.com ( [105.128.3.67]) by
	ussmgxs1new.samsung.com (USCPEXMTA) with SMTP id CC.44.50167.D1378166; Thu,
	11 Apr 2024 19:32:45 -0400 (EDT)
Received: from SSI-EX4.ssi.samsung.com (105.128.2.229) by
	SSI-EX4.ssi.samsung.com (105.128.2.229) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
	15.1.2507.35; Thu, 11 Apr 2024 16:32:45 -0700
Received: from SSI-EX4.ssi.samsung.com ([105.128.5.229]) by
	SSI-EX4.ssi.samsung.com ([105.128.5.229]) with mapi id 15.01.2507.035; Thu,
	11 Apr 2024 16:32:45 -0700
From: Dan Helmick <dan.helmick@samsung.com>
To: Luis Chamberlain <mcgrof@kernel.org>, John Garry
	<john.g.garry@oracle.com>
CC: "axboe@kernel.dk" <axboe@kernel.dk>, "kbusch@kernel.org"
	<kbusch@kernel.org>, "hch@lst.de" <hch@lst.de>, "sagi@grimberg.me"
	<sagi@grimberg.me>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"djwong@kernel.org" <djwong@kernel.org>, "viro@zeniv.linux.org.uk"
	<viro@zeniv.linux.org.uk>, "brauner@kernel.org" <brauner@kernel.org>,
	"dchinner@redhat.com" <dchinner@redhat.com>, "jack@suse.cz" <jack@suse.cz>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"tytso@mit.edu" <tytso@mit.edu>, "jbongio@google.com" <jbongio@google.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"ojaswin@linux.ibm.com" <ojaswin@linux.ibm.com>, "linux-aio@kvack.org"
	<linux-aio@kvack.org>, "linux-btrfs@vger.kernel.org"
	<linux-btrfs@vger.kernel.org>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, "nilay@linux.ibm.com" <nilay@linux.ibm.com>,
	"ritesh.list@gmail.com" <ritesh.list@gmail.com>, "willy@infradead.org"
	<willy@infradead.org>, Alan Adamson <alan.adamson@oracle.com>
Subject: RE: [PATCH v6 10/10] nvme: Atomic write support
Thread-Topic: [PATCH v6 10/10] nvme: Atomic write support
Thread-Index: AQHai6dUJXfHcfNow022DRMsKPOIdrFjO0qAgAB7v4D///oTcA==
Date: Thu, 11 Apr 2024 23:32:44 +0000
Message-ID: <8d2b30b76bb94255bc03006a69459b26@samsung.com>
In-Reply-To: <ZhgOW8yBPuuae4ni@bombadil.infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUxTVxjGc26v97bN2lw7BkdL3GBZ3EoGsqA5E2FI3HJJdGkWjWGSuEYv
	H7MU01KZ7o8hDuL4GOA6HAUnRQLlY4i1gbYrAsXOlYqo6IpVGGg7mOgYVcaX7bZyWcZ/v/e8
	z3Oe5ySHyxF1ERu5WYpcRqmQySMJPt7509zQ25tUMH1Lh1mMrOUDGGodLSfQdL8PoMHH50g0
	7BGi5lY7hv4ovIGjmrOnMOTomSFQ/Ugnhm4umQA6Y/sFIE1VAUDd7ih0+5GeRNZuB46GLbUE
	Ot/oJVGJy0SgpmsBDI1UeAEyVv6JoQvN+1DfwGkStU/P4KiwdJFEQ/5r69DyQi2RFE6btaMk
	XWdQ00Njl3D6sl5CDw+qaUPLVwRt8J0h6Yr6XkBfbviC/vFePkEXXLdz6FmvG6dnrtwl6Ot1
	V0n6mWETbfA8xaTUx/wdhxl51jFGGZP4CT9zamiEOFqw87PFL68Q+aDtvWLA40IqDhp7zUQx
	4HNFVDOAA7oBjB0KMRjQ1YBiwF1RzXl3BA0iqg3Ae94sVuMDcKHLhLGLRgArm4RBJqgo6J62
	rAtyCCWFLtc4CBo4lJ8HR5/1rRhephCcve8kWNG7cPnvRYzlZPjXSSMnGIxTb8CZsoTgsYDa
	DjssNhBkHrUNOlutZJABFQrnB9pWrBwqDLo95zH2ZethfY2Vw3IoDFgmCJYj4K/zv5PB6znU
	W/CiJYa1RkBNyQTJRq2HjmoPzso3wD79CB6sD6kf+HBq3L+62AWfvriwmiWGd13fclhRO4C6
	JwsEO3wH4GyRabVFPJy4PbHaVAj9Sw9BBXhdu6a49v9S2jWltGtK1QG8BYSpVarsDEb1joLJ
	i1bJslVqRUb0oZxsA/j3bzsD/Tkm4HLPRtsAxgU2ALmcyBCBWPJKukhwWHb8BKPMOahUyxmV
	DYi5eGSYIDbBcUhEZchymSMMc5RR/rfFuLyN+Zi0u7TOmn/pQXXewW1lb1o8bfl66fyt1/xF
	UkXP2PbcqiifcKI+8YP76rDQ36j3BaXqfkXvgyMlGsnD7i27zkWJ9wrN9vjs+Gge/U2gtjOi
	q+iARJt4rCPhxub6qv3e1qXqi+2twkdCkT1k60upzrhJ3z4qrOvVrw/4MpNjG558ujPFL1fs
	eXFnDD+eFjsSZ/Wc8j9OmkzW61NjGkwbvj+9x/w8NWPc8VGtzXgiL5a/23Lr5xYYvlcj9mrn
	BsuLp7baw3tI3XNnHxbapOn7cHmzKT005qzQiqWMJ6ZNzsl1J/dLK5MCYk2FOfxmWnqK6w7e
	OO4o9Zdd/Txrmtdu1EXiqkxZrISjVMn+AUru8mJKBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sf0wTdxjG87273l1Z0KO29KuMGUlks81wJht8ZfgDlm0ni8ToTLYmpGvg
	RGZpWc862OIElGwWBEQnsaIQbVyhZLqC8mPVQaFj/FCozNmWVVmgywpToMY5xuy2elvGf5/3
	fZ7nff55aVwyIFpF5+v2cwadRptARhH5JfhrL8bzcM9LP9alIEf1IIZs/moSzfSGALoxfZZC
	Y1PLUJPNhaEH5TcJdKbuMIYGvpkl0XnPVQyN/tEBUK3zB4BOnioD6JpPiW5NWinkuDZAoLGu
	ehI1XAxQqOJOB4m+6A9jyFMTAKjt+ByGLjTtRj2Dn1Hoy5lZApVXLlBo5Em/CC3+Xk9ufZbt
	NPspttFuZEfufkWwrVYFO3bDyNqbj5KsPVRLsTXnuwHbajnEfu0tIdmyYRfOzgd8BDt7/TbJ
	Djf2UexD+3Osfeo+toNRRaXlctr8A5xh/eb3ovb+MuIhC8vSixaOXCdLQMsWE6BpyLwMHwXS
	TCCKljDNAH7rbRUJQwjA49Ol/w4XAfS3XSFMQEyTjBL6ZrpEEZYyWfDnxXEyYsKZJ2Lof9iD
	RYQVDILz40OkYNoIF/9awATOgL+VtuGRaoJZC2ePbYqso5lUeLnLCYSy7zFY1RkCEUHMJMMh
	m4OKMGBi4ePBlqd3cEYOfVMNTxkyDLQ4RnCBZTA4GRYJvAbeexykIl04sw5e6lovRNfAkxU/
	UUJvDBw4PUUI9pWwx+ohaoDcvKTB/H/avCRtXpJuBEQzkBt5viCviN+g4z5M4jUFvFGXl5Sj
	L7CDf75tKNz7bgdw+eaTnACjgRNAGk+QRscpZHsk0bma4o84g15tMGo53gniaCJBHu2feIGT
	MHma/dw+jivkDP+pGC1eVYJVnsP6YmW7MuQtKvegO/HWpO+gUmHbVn+Kz16ZnaPJPqTPsCgO
	a5b7huNfOS2RJtfFqbfJ41fQn8Ar6lG3bWt/0qNu7b7cVO/742/dO5LXtvzOzoULMWeU4Sx9
	mj0zYEvXdbre1NnUgROfSiza9k3GZ7rnVQ9Wm4Kyic7Vlkp9+rKqCezj+0rFXFxQNe59o7RY
	Xu8+JgtmZnXM1Sa/2lrYf/NAyt1Jq7Y486r86NspTUXT7HDzLq/L9Wuo7IOhbnMvtfa2+/Xw
	n1hvw8ZEaWza5++M5ag9+nKHKaOi6LtUPrHduj17s27HQeeo+Plq7Trp7hSVs72qNiZXUtq3
	RZpA8Hs1GxS4gdf8DQBFLArcAwAA
X-CMS-MailID: 20240411233246uscas1p1373da501b9cb88b9c36c3bab0f937e01
CMS-TYPE: 301P
X-CMS-RootMailID: 20240411162308uscas1p2a0a08f3fb19af69de911961b03965257
References: <20240326133813.3224593-1-john.g.garry@oracle.com>
	<20240326133813.3224593-11-john.g.garry@oracle.com>
	<Zhcu5m8fmwD1W5bG@bombadil.infradead.org>
	<143e3d55-773f-4fcb-889c-bb24c0acabba@oracle.com>
	<CGME20240411162308uscas1p2a0a08f3fb19af69de911961b03965257@uscas1p2.samsung.com>
	<ZhgOW8yBPuuae4ni@bombadil.infradead.org>

T24gVGh1LCBBcHJpbCAxMSwgMjAyNCAxMDoyMyBBTSwgTHVpcyBDaGFpbWJlcmxhaW4gd3JvdGU6
DQo+IE9uIFRodSwgQXByIDExLCAyMDI0IGF0IDA5OjU5OjU3QU0gKzAxMDAsIEpvaG4gR2Fycnkg
d3JvdGU6DQo+ID4gT24gMTEvMDQvMjAyNCAwMToyOSwgTHVpcyBDaGFtYmVybGFpbiB3cm90ZToN
Cj4gPiA+IE9uIFR1ZSwgTWFyIDI2LCAyMDI0IGF0IDAxOjM4OjEzUE0gKzAwMDAsIEpvaG4gR2Fy
cnkgd3JvdGU6DQo+ID4gPiA+IEZyb206IEFsYW4gQWRhbXNvbiA8YWxhbi5hZGFtc29uQG9yYWNs
ZS5jb20+DQo+ID4gPiA+DQo+ID4gPiA+IEFkZCBzdXBwb3J0IHRvIHNldCBibG9jayBsYXllciBy
ZXF1ZXN0X3F1ZXVlIGF0b21pYyB3cml0ZSBsaW1pdHMuDQo+ID4gPiA+IFRoZSBsaW1pdHMgd2ls
bCBiZSBkZXJpdmVkIGZyb20gZWl0aGVyIHRoZSBuYW1lc3BhY2Ugb3IgY29udHJvbGxlcg0KPiA+
ID4gPiBhdG9taWMgcGFyYW1ldGVycy4NCj4gPiA+ID4NCj4gPiA+ID4gTlZNZSBhdG9taWMtcmVs
YXRlZCBwYXJhbWV0ZXJzIGFyZSBncm91cGVkIGludG8gIm5vcm1hbCIgYW5kICJwb3dlci0NCj4g
ZmFpbCINCj4gPiA+ID4gKG9yIFBGKSBjbGFzcyBvZiBwYXJhbWV0ZXIuIEZvciBhdG9taWMgd3Jp
dGUgc3VwcG9ydCwgb25seSBQRg0KPiA+ID4gPiBwYXJhbWV0ZXJzIGFyZSBvZiBpbnRlcmVzdC4g
VGhlICJub3JtYWwiIHBhcmFtZXRlcnMgYXJlIGNvbmNlcm5lZA0KPiA+ID4gPiB3aXRoIHJhY2lu
ZyByZWFkcyBhbmQgd3JpdGVzICh3aGljaCBhbHNvIGFwcGxpZXMgdG8gUEYpLiBTZWUgTlZNDQo+
ID4gPiA+IENvbW1hbmQgU2V0IFNwZWNpZmljYXRpb24gUmV2aXNpb24gMS4wZCBzZWN0aW9uIDIu
MS40IGZvciByZWZlcmVuY2UuDQo+ID4gPiA+DQo+ID4gPiA+IFdoZXRoZXIgdG8gdXNlIHBlciBu
YW1lc3BhY2Ugb3IgY29udHJvbGxlciBhdG9taWMgcGFyYW1ldGVycyBpcw0KPiA+ID4gPiBkZWNp
ZGVkIGJ5IE5TRkVBVCBiaXQgMSAtIHNlZSBGaWd1cmUgOTc6IElkZW50aWZ5IOKAkyBJZGVudGlm
eQ0KPiA+ID4gPiBOYW1lc3BhY2UgRGF0YSBTdHJ1Y3R1cmUsIE5WTSBDb21tYW5kIFNldC4NCj4g
PiA+ID4NCj4gPiA+ID4gTlZNZSBuYW1lc3BhY2VzIG1heSBkZWZpbmUgYW4gYXRvbWljIGJvdW5k
YXJ5LCB3aGVyZWJ5IG5vIGF0b21pYw0KPiA+ID4gPiBndWFyYW50ZWVzIGFyZSBwcm92aWRlZCBm
b3IgYSB3cml0ZSB3aGljaCBzdHJhZGRsZXMgdGhpcyBwZXItbGJhDQo+ID4gPiA+IHNwYWNlIGJv
dW5kYXJ5LiBUaGUgYmxvY2sgbGF5ZXIgbWVyZ2luZyBwb2xpY3kgaXMgc3VjaCB0aGF0IG5vDQo+
ID4gPiA+IG1lcmdlcyBtYXkgb2NjdXIgaW4gd2hpY2ggdGhlIHJlc3VsdGFudCByZXF1ZXN0IHdv
dWxkIHN0cmFkZGxlIHN1Y2ggYQ0KPiBib3VuZGFyeS4NCj4gPiA+ID4NCj4gPiA+ID4gVW5saWtl
IFNDU0ksIE5WTWUgc3BlY2lmaWVzIG5vIGdyYW51bGFyaXR5IG9yIGFsaWdubWVudCBydWxlcywN
Cj4gPiA+ID4gYXBhcnQgZnJvbSBhdG9taWMgYm91bmRhcnkgcnVsZS4NCj4gPiA+DQo+ID4gPiBM
YXJnZXIgSVUgZHJpdmVzIGEgbGFyZ2VyIGFsaWdubWVudCAqcHJlZmVyZW5jZSosIGFuZCBpdCBj
YW4gYmUNCj4gPiA+IG11bHRpcGxlcyBvZiB0aGUgTEJBIGZvcm1hdCwgaXQncyBjYWxsZWQgTmFt
ZXNwYWNlIFByZWZlcnJlZCBXcml0ZQ0KPiA+ID4gR3JhbnVsYXJpdHkgKE5QV0cpIGFuZCB0aGUg
TlZNZSBkcml2ZXIgYWxyZWFkeSBwYXJzZXMgaXQuIFNvIHNheSB5b3UNCj4gPiA+IGhhdmUgYSA0
ayBMQkEgZm9ybWF0IGJ1dCBhIDE2ayBOUFdHLiBJIHN1c3BlY3QgdGhpcyBtZWFucyB3ZSdkIHdh
bnQNCj4gPiA+IGF0b21pY3Mgd3JpdGVzIHRvIGFsaWduIHRvIDE2ayBidXQgSSBjYW4gbGV0IERh
biBjb25maXJtLg0KDQpBcG9sb2dpZXMgZm9yIG15IGRlbGF5ZWQgcmVwbHkuICBJIGNvbmZpcm0u
ICANCg0KRllJOiBJIGF1dGhvcmVkIHRoZSBmaXJzdCBkcmFmdCBvZiB0aGUgT1BUUEVSRiBzZWN0
aW9uIGFuZCBJIHRyaWVkIGFsc28gYXQgYSBwb2ludCB0byBoZWxwIGNsYXJpZnkgdGhlIGF0b21p
Y3Mgc2VjdGlvbi4gIEFmdGVyIG15IDFzdCBkcmFmdHMgb24gdGhlc2Ugc2VjdGlvbnMsIHRoZXJl
IHdhcyBhIGZhaXIgYW1vdW50IG9mIHRyYW5zbGF0aW9ucyBmcm9tIEVuZ2xpc2ggaW50byBTdGFu
ZGFyZHMgdHlwZSBsYW5ndWFnZS4gIFNvLCBzb21lIGRyaXZlIHNwZWNpZmljcyBnZXQgcmVtb3Zl
ZCB0byBlbmFibGUgb3RoZXIgbWVkaWFzIGFuZCBzby1mb3J0aC4gIA0KDQpOUFdHIGlzIGEgcHJl
ZmVyZW5jZS4gIEl0IGRvZXMgbm90IGRpY3RhdGUgdGhlIGF0b21pYyBiZWhhdmlvciB0aG91Z2gu
ICBTbywgZG9uJ3QgZ28gYXNzdW1pbmcgeW91IGNhbiByZWx5IG9uIHRoYXQgYmVoYXZpb3IuICAN
CiANCg0KPiA+DQo+ID4gSWYgd2UgbmVlZCB0byBiZSBhbGlnbmVkIHRvIE5QV0csIHRoZW4gdGhl
IG1pbiBhdG9taWMgd3JpdGUgdW5pdCB3b3VsZA0KPiA+IGFsc28gbmVlZCB0byBiZSBOUFdHLiBB
bnkgTlBXRyByZWxhdGlvbiB0byBhdG9taWMgd3JpdGVzIGlzIG5vdA0KPiA+IGRlZmluZWQgaW4g
dGhlIHNwZWMsIEFGQUlDUy4NCj4gDQo+IE5QV0cgaXMganVzdCBhIHByZWZlcmVuY2UsIG5vdCBh
IHJlcXVpcmVtZW50LCBzbyBpdCBpcyBkaWZmZXJlbnQgdGhhbiBsb2dpY2FsDQo+IGJsb2NrIHNp
emUuIEFzIGZhciBhcyBJIGNhbiB0ZWxsIHdlIGhhdmUgbm8gYmxvY2sgdG9wb2xvZ3kgaW5mb3Jt
YXRpb24gdG8NCj4gcmVwcmVzZW50IGl0LiBMQlMgd2lsbCBoZWxwIHVzZXJzIG9wdC1pbiB0byBh
bGlnbiB0byB0aGUgTlBXRywgYW5kIGEgcmVzcGVjdGl2ZQ0KPiBOQVdVUEYgd2lsbCBlbnN1cmUg
eW91IGNhbiBhbHNvIGF0b21pY2FsbHkgd3JpdGUgdGhlIHJlc3BlY3RpdmUgc2VjdG9yIHNpemUu
DQo+IA0KPiBGb3IgYXRvbWljcywgTkFCU1BGIGlzIHdoYXQgd2Ugd2FudCB0byB1c2UuDQo+IA0K
PiBUaGUgYWJvdmUgc3RhdGVtZW50IG9uIHRoZSBjb21taXQgbG9nIGp1c3Qgc2VlbXMgYSBiaXQg
bWlzbGVhZGluZyB0aGVuLg0KPiANCj4gPiBXZSBzaW1wbHkgdXNlIHRoZSBMQkEgZGF0YSBzaXpl
IGFzIHRoZSBtaW4gYXRvbWljIHVuaXQgaW4gdGhpcyBwYXRjaC4NCj4gDQo+IEkgdGhvdWdodCBO
QUJTUEYgaXMgdXNlZC4NCg0KWWVzLCB1c2UgTkFCU1BGLiAgQnV0IG1vc3QgU1NEcyBkb24ndCBh
Y3R1YWxseSBoYXZlIGJvdW5kYXJpZXMuICBUaGlzIGlzIG1vcmUgb2YgYSBsZWdhY3kgU1NEIG5l
ZWQuICANCg0KPiANCj4gPiA+ID4gTm90ZSBvbiBOQUJTUEY6DQo+ID4gPiA+IFRoZXJlIHNlZW1z
IHRvIGJlIHNvbWUgdmFndWVuZXNzIGluIHRoZSBzcGVjIGFzIHRvIHdoZXRoZXIgTkFCU1BGDQo+
ID4gPiA+IGFwcGxpZXMgZm9yIE5TRkVBVCBiaXQgMSBiZWluZyB1bnNldC4gRmlndXJlIDk3IGRv
ZXMgbm90DQo+ID4gPiA+IGV4cGxpY2l0bHkgbWVudGlvbiBOQUJTUEYgYW5kIGhvdyBpdCBpcyBh
ZmZlY3RlZCBieSBiaXQgMS4gSG93ZXZlcg0KPiA+ID4gPiBGaWd1cmUgNCBkb2VzIHRlbGwgdG8g
Y2hlY2sgRmlndXJlDQo+ID4gPiA+IDk3IGZvciBpbmZvIGFib3V0IHBlci1uYW1lc3BhY2UgcGFy
YW1ldGVycywgd2hpY2ggTkFCU1BGIGlzLCBzbyBpdA0KPiA+ID4gPiBpcyBpbXBsaWVkLiBIb3dl
dmVyIGN1cnJlbnRseSBudm1lX3VwZGF0ZV9kaXNrX2luZm8oKSBkb2VzIGNoZWNrDQo+ID4gPiA+
IG5hbWVzcGFjZSBwYXJhbWV0ZXIgTkFCTyByZWdhcmRsZXNzIG9mIHRoaXMgYml0Lg0KDQpOQUJP
IGlzIGEgcGFyYW1ldGVyIHRoYXQgd2FzIGNhcnJpZWQgZm9yd2FyZCwgYW5kIGl0IHdhcyBhbHJl
YWR5IGluIHRoZSBzcGVjLiAgSSBkaWRuJ3QgZ2V0IGFuIGFiaWxpdHkgdG8gaW1wYWN0IHRoYXQg
b25lIHdpdGggbXkgY2hhbmdlcy4gIA0KDQpUaGUgc3RvcnkgdGhhdCB3YXMgcmVsYXllZCB0byBt
ZSBzYXlzIHRoaXMgcGFyYW1ldGVyIGZpcnN0IGV4aXN0ZWQgaW4gU0FUQSBhbmQgU0NTSSwgYW5k
IE5WTWUganVzdCBwdWxsZWQgb3ZlciBhbiBlcXVpdmFsZW50IHBhcmFtZXRlciBldmVuIHRob3Vn
aCB0aGUgcHJvYmxlbSB3YXMgcmVzb2x2ZWQgaW4gdGhlIGxhbmRzY2FwZSBOVk1lIFNTRHMgc2hp
cCBpbnRvLiAgSSB3YXMgdG9sZCB0aGF0IE5BQk8gd2FzIGEgcGFyYW1ldGVyIGZyb20gV2luZG93
cyA5NS1pc2ggZGF5cy4gIFNvbWV0aGluZyBhYm91dCB0aGUgQklPUyBiZWluZyB3cml0dGVuIGlu
IDUxMkIgc2VjdG9ycyB3aXRoIGFuIGVuZGluZyB0aGF0IGRpZG4ndCBhbGlnbiB0byA0S0IuICBC
dXQgYWxsIHRoZSBIRERzIHdlcmUgdHJ5aW5nIHRvIG1vdmUgb3ZlciB0byA0S0IgZm9yIGVmZmlj
aWVuY2llcyBvZiB0aGVpciBFQ0NzLiAgU28sIHRoZXJlIHdhcyB0aGlzIE5BQk8gcGFyYW1ldGVy
IGFkZGVkIHRvIGdldCB0aGUgT1MgcG9ydGlvbiBvZiB0aGUgZHJpdmUgdG8gYmUgYWxpZ25lZCBu
aWNlbHkgd2l0aCB0aGUgSEREJ3MgRUNDLiAgDQoNCkFueXdheXM6IGFkZCBpbiB0aGUgb2Zmc2V0
IGFzIHF1ZXJpZWQgZnJvbSB0aGUgZHJpdmUgZXZlbiB0aG91Z2ggaXQgd2lsbCBtb3N0IGxpa2Vs
eSBhbHdheXMgYmUgemVyby4NCg0KPiA+ID4NCj4gPiA+IFllYWggdGhhdCBpdHMgcXVpcmt5Lg0K
PiA+ID4NCj4gPiA+IEFsc28gdG9kYXkgd2Ugc2V0IHRoZSBwaHlzaWNhbCBibG9jayBzaXplIHRv
IG1pbihucHdnLCBhdG9taWMpIGFuZA0KPiA+ID4gdGhhdCBtZWFucyBmb3IgYSB0b2RheSdzIGF2
ZXJhZ2UgNGsgSVUgZHJpdmUgaWYgdGhleSBnZXQgMTZrIGF0b21pYw0KPiA+ID4gdGhlIHBoeXNp
Y2FsIGJsb2NrIHNpemUgd291bGQgc3RpbGwgYmUgNGsuIEFzIHRoZSBwaHlzaWNhbCBibG9jaw0K
PiA+ID4gc2l6ZSBpbiBwcmFjdGljZSBjYW4gYWxzbyBsaWZ0IHRoZSBzZWN0b3Igc2l6ZSBmaWxl
c3lzdGVtcyB1c2VkIGl0DQo+ID4gPiB3b3VsZCBzZWVtIG9kZCBvbmx5IGEgbGFyZ2VyIG5wd2cg
Y291bGQgbGlmdCBpdC4NCj4gPiBJdCBzZWVtcyB0byBtZSB0aGF0IGlmIHlvdSB3YW50IHRvIHBy
b3ZpZGUgYXRvbWljIGd1YXJhbnRlZXMgZm9yIHRoaXMNCj4gPiBsYXJnZSAicGh5c2ljYWwgYmxv
Y2sgc2l6ZSIsIHRoZW4gaXQgbmVlZHMgdG8gYmUgYmFzZWQgb24gKE4pQVdVUEYgYW5kIE5QV0cu
DQo+IA0KPiBGb3IgYXRvbWljaXR5LCBJIHJlYWQgaXQgYXMgbmVlZGluZyB0byB1c2UgTkFCU1BG
LiBBbGlnbmluZyB0byBOUFdHIHdpbGwganVzdA0KPiBoZWxwIHBlcmZvcm1hbmNlLg0KPiANCj4g
VGhlIE5QV0cgY29tZXMgZnJvbSBhbiBpbnRlcm5hbCBtYXBwaW5nIHRhYmxlIGNvbnN0cnVjdGVk
IGFuZCBrZXB0IG9uDQo+IERSQU0gb24gYSBkcml2ZSBpbiB1bml0cyBvZiBhbiBJVSBzaXplIFsw
XSwgYW5kIHNvIG5vdCBhbGlnbmluZyB0byB0aGUgSVUganVzdA0KPiBjYXVzZXMgaGF2aW5nIHRv
IHdvcmsgd2l0aCBlbnRyaWVzIGluIHRoZSBhYmxlIHJhdGhlciB0aGFuIGp1c3Qgb25lLCBhbmQg
YWxzbw0KPiBpbmN1cnMgYSByZWFkLW1vZGlmeS13cml0ZS4gQ29udHJhcnkgdG8gdGhlIGxvZ2lj
YWwgYmxvY2sgc2l6ZSwgYSB3cml0ZSBiZWxvdw0KPiBOUFdHIGJ1dCByZXNwZWN0aW5nIHRoZSBs
b2dpY2FsIGJsb2NrIHNpemUgaXMgYWxsb3dlZCwgaXRzIGp1c3Qgbm90IG9wdGltYWwuDQo+IA0K
PiBbMF0NCj4gaHR0cHM6Ly91cmxkZWZlbnNlLmNvbS92My9fX2h0dHBzOi8vcHJvdGVjdDIuZmly
ZWV5ZS5jb20vdjEvdXJsP2s9ZWFlNDMyOTUtDQo+IGI1N2ZmY2YxLWVhZTViOWRhLTAwMGJhYmRh
MDIwMS0yMWNjYzA1ZTA0YjliZTQwJnE9MSZlPWEyMGQxN2UyLQ0KPiA5ZTU2LTQ3ZTQtYjVlMC0N
Cj4gMDU0OTQyNTRhMjg2JnU9aHR0cHMqM0EqMkYqMkZrZXJuZWxuZXdiaWVzLm9yZyoyRktlcm5l
bFByb2plY3RzKjJGbGFyZw0KPiBlLWJsb2NrLXNpemUqMjNJbmRpcmVjdGlvbl9Vbml0X3NpemVf
aW5jcmVhc2VzX187SlNVbEpTVWwhIUV3VnpxR29US0Jxdi0NCj4gMERXQUpCbSFXa3pkMkJvNU1X
Z1lQWERoZkpZc28ybm9jTzBrQXRLSHZ0WUQxTlQ2cDRRSWtDODQ2VGNsRFJKDQo+IHBQZDY4M1dE
R2VKU1RiUkJMS3E1RnktVjltQmE4JA0KPiANCj4gICBMdWlzDQo=

