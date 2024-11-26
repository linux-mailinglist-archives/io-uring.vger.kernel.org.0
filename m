Return-Path: <io-uring+bounces-5056-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B8249D9A48
	for <lists+io-uring@lfdr.de>; Tue, 26 Nov 2024 16:17:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF06A282274
	for <lists+io-uring@lfdr.de>; Tue, 26 Nov 2024 15:17:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D70A1D5AD3;
	Tue, 26 Nov 2024 15:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="mw5WKJHV"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3BB54BD4
	for <io-uring@vger.kernel.org>; Tue, 26 Nov 2024 15:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732634273; cv=none; b=MQFlEF87iI2ObK6GvU1Oy6cm29fqPB9hnXlYYaMyrGe6a6DPo/jThfpytWgH4HzBKWWA9Ls3UZUdTOa92fGqKlcEEMVtWgaP/S+dHp2bgrTFm4eqmVNeK85P6hoW5NHN9UWLlHIs4Mtb0c2NCv1ualUgm0rwsyESLWh3BneA3x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732634273; c=relaxed/simple;
	bh=conzAXGFvCGlWB7Nt2Vmh3ysp/HzyC+sAlJERllPc00=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=IfGAqDVKvrIOim4awrAK4HA3ShHCtQ8HHOamfc8hq1oGe/GtmNG/xJKmSCCNyDOlVHkDUfKaunHODDAIUeZN3Oam/4UTO0PSCjZEMwhP6Ud8/BGvYsZR/3EpRjl8cAbW0WGjiI8MIcjrwygQi2SlpfmiO2PWGmzL2eMoqJGqqm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=mw5WKJHV; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20241126151745epoutp04b0e32cb4d80717ab211b2edf208be52a~Lja9OtNRg1897318973epoutp04k
	for <io-uring@vger.kernel.org>; Tue, 26 Nov 2024 15:17:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20241126151745epoutp04b0e32cb4d80717ab211b2edf208be52a~Lja9OtNRg1897318973epoutp04k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1732634265;
	bh=iWfRC+PQ9KIwj5n4FH55KQet8oTgZcDhDUi2rwxK0qc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=mw5WKJHVgZAGfs/ooJp9TJQO1AW76ypQ1bv+08MV5Jyrw91ctv5/wdFN9TLeyLi/e
	 vQnQ+ixr1mJnTbY3mfkirdou+JmSziPKQYLitxQG06aa8lr9X6iedvYQ+3fuOe1LhC
	 aoXZAgIUNQya76ASJudTq4bZrDh8mLnKbqQ8Ahn4=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20241126151744epcas5p1a5994cb5ff9ac2b171b37311e8bfd9ba~Lja8IfcVq0152001520epcas5p1N;
	Tue, 26 Nov 2024 15:17:44 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4XyR5f5mX5z4x9Pt; Tue, 26 Nov
	2024 15:17:42 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	70.F9.29212.696E5476; Wed, 27 Nov 2024 00:17:42 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241126140212epcas5p2dd99d32c1b3ce9c4b45692e185b9daa9~LiY-P1dsx1356413564epcas5p2o;
	Tue, 26 Nov 2024 14:02:12 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241126140212epsmtrp128ad1c77f1334fcf367a628ad7f326d4~LiY-OvIH12045120451epsmtrp1i;
	Tue, 26 Nov 2024 14:02:12 +0000 (GMT)
X-AuditID: b6c32a50-801fa7000000721c-fb-6745e696aeac
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	44.8C.18949.4E4D5476; Tue, 26 Nov 2024 23:02:12 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20241126140209epsmtip181b3a32d97164eaecf95f9e1d6448f7a~LiY85tUSC2763027630epsmtip1w;
	Tue, 26 Nov 2024 14:02:09 +0000 (GMT)
Date: Tue, 26 Nov 2024 19:24:23 +0530
From: Anuj Gupta <anuj20.g@samsung.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, anuj1072538@gmail.com, brauner@kernel.org,
	jack@suse.cz, viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org, vishak.g@samsung.com,
	linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v10 06/10] io_uring: introduce attributes for read/write
 and PI support
Message-ID: <20241126135423.GB22537@green245>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <2cbbe4eb-6969-499e-87b5-02d19f53258f@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA03Tf0wbZRgHcN+76/Uggxy/5BUCI6dktgi0QPE6x+bcWM5ptMa4ONSwS3tp
	kdLWXituc7E6OjImY1uGbpUNpm5IcRt2iEXoJAXG+DEamUo2M5e5FocIEeYmgoAtV8z++7zv
	Pd+793nf9wg0dgxPIkoMFs5sYPUUHom1dUskmR+NFWplTdVSevrePEbXOdsA3XyjBqcnumcA
	fa2rHaGbmnsReso+jNGffLwXoXuXJnH6iPcnQHuuZ9Cdnn6Mrj8TENMHRt043di3iNC+hT4R
	7XPUiZ+OYdodN8TM1StWxuXcjzMXPn+P6bhmw5npwHWMOdjqBMxQQ4+YuetKZVz+SUQVWVS6
	TsexGs6cxhnURk2JQVtAPfdy8aZiRb5MnilX0k9SaQa2jCugNj+vytxSog+2Q6W9zeqtwSkV
	y/NU9vp1ZqPVwqXpjLylgOJMGr0pz5TFs2W81aDNMnCWtXKZLEcRLNxRqps6V4OZBiPeqfba
	xDYwK64CEQQk8+BXfUtIFYgkYslOAF1fHMWFwQyA3ywdx0NVseR9AG8OvLaSOHz6r3DCA2CT
	u1UkDMYAPHVpbDmBkemwouWOKGScXAN7frODkOPJDDgx6hWHAihZjcILsx8ioQdx5BvwzP3A
	clEUmQnrh8cRwTGw/7gfCzmCLICVny4uO4F8FHa19S0vA5J+Avoq/CJhfZvhxfpZXHAc/L2v
	NdxpEhyv2Re2Fs5eDSCCTXDvpYtA8AZoH6hBQ0ZJHfzefzT8nhRYO3AOEeajYfW8P5yNgu6T
	K6ZgZVNd2BB6hm1hM/ByYycmbNEUgPYr9dghsNrxQHOOB74n+AnY0DETNBF0MmxcJARK4Plv
	sxuAyAmSOBNfpuXUCpM808CV/3/mamOZCyxfeKnKDZpbFrK8ACGAF0ACpeKjohM3aWOjNOzO
	XZzZWGy26jneCxTB4zqMJiWojcE/xmAplucpZXn5+fl5ytx8OZUYNWE/oYkltayFK+U4E2de
	ySFERJINkaajR/w/S4b0v5SIXXZWWQbLndWbpKPO734sRf/cod69zZZ4S/Fu9EnRK8yG6R55
	oLYlcMC8cXBgV2PusYe9HSecnpg6x8RSSspD7FaVTf2lJ73i7/mcVYfmirf9m10RndA6517v
	jX/W/nrJ7YV/zkpQVenoi3Pl2z1/rBkqGnkrayG98amR3obdcS/sS22+81Kt8taqQC6RG299
	pMg32G109L5Z19WCZysGCn3PqHc+lvXqCFDye27eq/e1r9ak8vGS/Vsq3c6Dp5J7yj/7YJxP
	qWrumZo/u2e77bJaUvi+ujbj8a0/GJN143d/zcmVZR8bkfb77RPk7bWO85MjX59GN1IYr2Pl
	UtTMs/8BGq1QRnkEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02RfyyUcRzH933ucffczdXjZL5Ytu5q2YlCf3xbodXaHmaF/mlW8pSnY865
	3XVEzY8ki0mMWUfOrpCzVU4zcsaOGOMwIqRs3YV0KaEUVzm1+u+9z/v1+nz++BAsQS3uTsTL
	LjMKGS0Vsnl4U6fQ08c8ekJyQNO/HX1e+YGjCl0TQPXThWy00LkE0ERHC4bq6p9j6GOOCUfl
	ZdkYev7TykbFxjGA2ia9kaGtF0eaGgsH5Y83s1Ftjw1Dgxs9DmhQXcE56kS1qKc51MiAitLr
	brGpxgcZVOtEJpv6bJnEqdtPdYDqr+riUF/0npTebMXCeVG8I7GMND6ZUewPiuHFLVUN4vJ8
	zpWStQFOJhh2yANcApIHYVH1MpYHeISAbAWw8P4UtlVA2DdfA7ayM6yzzXK2IDOA2tI19maB
	k3vgjSdz9k1sci/sms2xCztIb7gwbrQLLLKQBdtW39i3OpPnYM2qxQ7xSR+oMc3/Of0RwKzr
	U/hW4QR775rtmUWK4UvbJkT8zh6w1kZsjrlkIMzV2uyICymCHU092B3gpP7PVv9nq//ZVYCl
	A26MXJkoSVT6yf1lTIqvkk5UqmQS34tJiXpg/6VY3AwMuk++RoARwAggwRLu4G9zPS4R8GPp
	1DRGkXReoZIySiPwIHChK391oSBWQEroy0wCw8gZxd8WI7jumRjXenOFqRQEi4eiz+SVdofE
	pHCSTobp0lURnesm7SD/1BNty7cGGEVT4aOuCSbR0u606SHbsLb1+6vXTFf740v72uecmkMf
	WardHilEuvmGsvHXgXTGQ9YHw7rV2+hTw3977A5plk6Hi/Lqmvb46DNCRvxHIl8Ex05WaCL2
	roWd/joZxF2sCtjlVVl4u3N40Zg2BAyhh/tKz0YDWblKNNM4FqJfdaEnNBujBWvZvnhkQHHv
	oYjIWrd05F9CVaSKC2ZsfnG5pgJ5wM977xcXLV1Byfi7JXWDqXoMm03x6n627IEbroqbqZzM
	4ZIo2Xico+6xTV507dzOC45ZQlwZR/uJWQol/QsBgZ5yOgMAAA==
X-CMS-MailID: 20241126140212epcas5p2dd99d32c1b3ce9c4b45692e185b9daa9
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----QQbx9Hk6-Xl4D1oMwM2uYkP7uAkYtjoi7zPie6od2LiHNIsi=_341a9_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241125071502epcas5p46c373574219a958b565f20732797893f
References: <20241125070633.8042-1-anuj20.g@samsung.com>
	<CGME20241125071502epcas5p46c373574219a958b565f20732797893f@epcas5p4.samsung.com>
	<20241125070633.8042-7-anuj20.g@samsung.com>
	<2cbbe4eb-6969-499e-87b5-02d19f53258f@gmail.com>

------QQbx9Hk6-Xl4D1oMwM2uYkP7uAkYtjoi7zPie6od2LiHNIsi=_341a9_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Tue, Nov 26, 2024 at 01:01:03PM +0000, Pavel Begunkov wrote:
> On 11/25/24 07:06, Anuj Gupta wrote:
> ...
> > +	/* type specific struct here */
> > +	struct io_uring_attr_pi	pi;
> > +};
> 
> This also looks PI specific but with a generic name. Or are
> attribute structures are supposed to be unionised?

Yes, attribute structures would be unionised here. This is done so that
"attr_type" always remains at the top. When there are multiple attributes
this structure would look something like this:

/* attribute information along with type */
struct io_uring_attr {
	enum io_uring_attr_type attr_type;
	/* type specific struct here */
	union {
		struct io_uring_attr_pi	pi;
		struct io_uring_attr_x	x;
		struct io_uring_attr_y	y;
	};
};

And then on the application side for sending attribute x, one would do:

io_uring_attr attr;
attr.type = TYPE_X;
prepare_attr(&attr.x);

------QQbx9Hk6-Xl4D1oMwM2uYkP7uAkYtjoi7zPie6od2LiHNIsi=_341a9_
Content-Type: text/plain; charset="utf-8"


------QQbx9Hk6-Xl4D1oMwM2uYkP7uAkYtjoi7zPie6od2LiHNIsi=_341a9_--

