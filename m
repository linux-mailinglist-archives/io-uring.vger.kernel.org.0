Return-Path: <io-uring+bounces-3758-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 70C659A1A4C
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 07:59:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CC82EB24C74
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 05:59:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFCC016BE2A;
	Thu, 17 Oct 2024 05:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="mm6UqU8q"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F24616E892
	for <io-uring@vger.kernel.org>; Thu, 17 Oct 2024 05:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729144776; cv=none; b=ZrniAMl6TMHb2SEEvzFigQcVzndWIclRRY2EFAR2/ewCLtvXd4TIVVPuTzEmTTihlzm9L6xi76YGj8QkwGeFdrKnBkDqrwzg2B04hSx0tq7M5+oKWTWzhi9bCaHEwENMsLqToDRmKrJlPvKF49G+U5NhHXk33mT9zEyZinPbWWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729144776; c=relaxed/simple;
	bh=nZi3N87Fn7GyL3h5GSDsr0TyuokvD5sBHPSu2+vgW08=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=Joh7t7qZ8Tku25ec67mes4svtRwMBp+qVoENC+9MHAUfP4POGfZszzvzjlpC8ibrz5vUuNUgP9+qJ6JL0sh/E7I4Tb5Ed/w9mxP0am7zi4svEMh8OfAnjLNY0hy4D7yrgxGenEQmaEaG22M8s1hweGU71mEmohCqbSxsm6HP7GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=mm6UqU8q; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241017055932epoutp015903e086189dff389be20f0118c29285~-KAJQCn2l1839518395epoutp01X
	for <io-uring@vger.kernel.org>; Thu, 17 Oct 2024 05:59:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241017055932epoutp015903e086189dff389be20f0118c29285~-KAJQCn2l1839518395epoutp01X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1729144772;
	bh=rl4urkME/xxgsKsWdB43j5AWH/MmKc4JwHpXxRIbew4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=mm6UqU8qlxepvJDRG7jVJIKoW7elohNkfIQyLOIzCMfAiyYZm946SA6KV2ybfpdpp
	 MhutC/pTS5ouILO30r+cHo5bEuO0DOIviem3ljmd+L0BHuTJNdh+Xman+TVB7h9jgq
	 nU3D5BF74ckGEYRBPsI7Qcmn7BWnu38td3MgQC+Q=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20241017055931epcas5p2a67fb46e7e19b82a81ade31e60aeda88~-KAIp2HuV2775827758epcas5p2J;
	Thu, 17 Oct 2024 05:59:31 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4XTcc00Cqtz4x9Pt; Thu, 17 Oct
	2024 05:59:28 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	54.BD.09770.FB7A0176; Thu, 17 Oct 2024 14:59:27 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20241017055641epcas5p48ca0552614a6056d4a11ded041fb4e28~-J9qfSEwB1644216442epcas5p4m;
	Thu, 17 Oct 2024 05:56:41 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241017055641epsmtrp2af3196895d0402ffdce5e2fe9f3223a0~-J9qeNQb31041410414epsmtrp2_;
	Thu, 17 Oct 2024 05:56:41 +0000 (GMT)
X-AuditID: b6c32a4a-44cd5a800000262a-b2-6710a7bf983a
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	A4.B5.08227.917A0176; Thu, 17 Oct 2024 14:56:41 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20241017055639epsmtip2c1fdc0bb6dff263556b25947391e3414~-J9oiDPV90559305593epsmtip2i;
	Thu, 17 Oct 2024 05:56:39 +0000 (GMT)
Date: Thu, 17 Oct 2024 11:19:00 +0530
From: Anuj Gupta <anuj20.g@samsung.com>
To: Keith Busch <kbusch@kernel.org>
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
	asml.silence@gmail.com, anuj1072538@gmail.com, krisman@suse.de,
	io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com,
	linux-scsi@vger.kernel.org, vishak.g@samsung.com, Kanchan Joshi
	<joshi.k@samsung.com>
Subject: Re: [PATCH v4 04/11] block: define meta io descriptor
Message-ID: <20241017054900.alfiqn3o37f4kkxb@green245>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <ZxAVlFfF-gjzFLwr@kbusch-mbp.dhcp.thefacebook.com>
User-Agent: NeoMutt/20171215
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPJsWRmVeSWpSXmKPExsWy7bCmuu7+5QLpBvcfWVt8/PqbxWLOqm2M
	Fqvv9rNZ3Dywk8li5eqjTBbvWs+xWBz9/5bNYtKha4wW288sZbbYe0vbYv6yp+wW3dd3sFks
	P/6PyeL8rDnsDnweO2fdZfe4fLbUY9OqTjaPzUvqPXbfbGDz+Pj0FotH35ZVjB6bT1d7fN4k
	F8AZlW2TkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3S5
	kkJZYk4pUCggsbhYSd/Opii/tCRVISO/uMRWKbUgJafApECvODG3uDQvXS8vtcTK0MDAyBSo
	MCE74/Cew4wFp3kqfpzfz9LAeJGri5GTQ0LAROLzo1MsILaQwG5GiaubjbsYuYDsT4wSE/+8
	YoJwvjFKPLrznx2mY/Om24wQib2MEh8f/mOCaH8G1PI7GMRmEVCVOPzzIlgDm4C6xJHnrYwg
	toiAssTd+TNZQZqZBU4ySRw7/RRst7CAnUTPkX1gDbwCZhKfFhxhhLAFJU7OfAJWwylgL/Gr
	q4cNxBYVkJGYsfQrM8ggCYEjHBL79/9jgzjPRaL/6VJmCFtY4tXxLVBnS0l8frcXqiZd4sfl
	p0wQdoFE87F9jBC2vUTrqX6wXmaBDIlz3YugemUlpp5axwQR55Po/f0EqpdXYsc8GFtJon3l
	HChbQmLvuQYo20Oi6UALGyJQv0xkmsAoPwvJc7OQ7IOwrSQ6PzSxzmLkALKlJZb/44AwNSXW
	79JfwMi6ilEytaA4Nz212LTAKC+1HB7jyfm5mxjBKVvLawfjwwcf9A4xMnEwHmKU4GBWEuGd
	1MWbLsSbklhZlVqUH19UmpNafIjRFBhbE5mlRJPzgVkjryTe0MTSwMTMzMzE0tjMUEmc93Xr
	3BQhgfTEktTs1NSC1CKYPiYOTqkGpt0tS6x7av+qN6pw+nhNvrP76CRfu0Pr+e2M/2/U7voj
	/e7CDhvNtv59Jzk9P6z08u9lvZZ32P7/StXkncfOi6y23xrhP1d/9f12rTS9OW+uHO6e9mvK
	v6ypmgp/Ratz7Lq0Ht3T8fvDynhM44zxxD25Rzx1pazl51ecuM21LeeRaMEyIXNBz1Mm8RcX
	7T7wmINv1lm+IyVPb1yr06lYPNXeddt+t/fvnkwRYLnl4X1U0uSO0qU5y9w2BxwTa7vBv/sG
	u6Oz49R1h5a4r9x281FRwO07JooVH2QvlO9/Or0g48s3eVkGZw67sp6a4lnKQTGJazPOm2b7
	L6q21WToyb1jPGVirsAi9dqXwodjdimxFGckGmoxFxUnAgCkk4qFYgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsWy7bCSvK7kcoF0g4l3dCw+fv3NYjFn1TZG
	i9V3+9ksbh7YyWSxcvVRJot3redYLI7+f8tmMenQNUaL7WeWMlvsvaVtMX/ZU3aL7us72CyW
	H//HZHF+1hx2Bz6PnbPusntcPlvqsWlVJ5vH5iX1HrtvNrB5fHx6i8Wjb8sqRo/Np6s9Pm+S
	C+CM4rJJSc3JLEst0rdL4Mp4v28VU8FfzopzfceYGhjncnQxcnJICJhIbN50m7GLkYtDSGA3
	o8SklbMYIRISEqdeLoOyhSVW/nvODlH0hFHi27b7YAkWAVWJwz8vsoPYbALqEkeet4LFRQSU
	Je7On8kKYjMLnGSS+PKAH8QWFrCT6DmyD6yeV8BM4tOCI1CbPzFK7GnqZIJICEqcnPmEBaLZ
	TGLe5ofMXYwcQLa0xPJ/YFdzCthL/OrqYQOxRQVkJGYs/co8gVFwFpLuWUi6ZyF0L2BkXsUo
	mVpQnJueW2xYYJSXWq5XnJhbXJqXrpecn7uJERxrWlo7GPes+qB3iJGJg/EQowQHs5II76Qu
	3nQh3pTEyqrUovz4otKc1OJDjNIcLErivN9e96YICaQnlqRmp6YWpBbBZJk4OKUamNwbHW14
	qvdMN7Paacq4ZXXDr3zTFm01vhe/f3pObhNe8uIo0+IyDsMQhkdPX6x5aa7dc/BOe8pCxqcG
	nz6fX3DSOvrf0RKBUEHmfYkXi92CfvooH3TvFp3p9+jTF5FX91liue/PUxS6zzSrkuHu7mDx
	tvAZ1vxzllTI9k0VTZDQ5T4UWb7vmeNTIwNmsZW9sT9c1Qoqvh/XFY3cvdVaR7bjfVRuu/aU
	Ra2sMUvC/rpu9jYIF9L/MKNGQuvkTQPNv0e/6fMzF9exNGjfPmkhHnfggb3X/adXIg7MysgN
	evCzOK/absv0CTsuc59pv3L8QFgzX/FM18irkt0zL86RPFzLkO9nrZpTc+6/j857JZbijERD
	Leai4kQAqW/9jSQDAAA=
X-CMS-MailID: 20241017055641epcas5p48ca0552614a6056d4a11ded041fb4e28
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----Q5hryimWBrG20CTDo2Cycv07rC8cEZ5s1mVzGfufIajJO9l9=_4e3b9_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241016113741epcas5p3b90adb3b43b6b443ffd00df29d63d289
References: <20241016112912.63542-1-anuj20.g@samsung.com>
	<CGME20241016113741epcas5p3b90adb3b43b6b443ffd00df29d63d289@epcas5p3.samsung.com>
	<20241016112912.63542-5-anuj20.g@samsung.com>
	<ZxAVlFfF-gjzFLwr@kbusch-mbp.dhcp.thefacebook.com>

------Q5hryimWBrG20CTDo2Cycv07rC8cEZ5s1mVzGfufIajJO9l9=_4e3b9_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 16/10/24 01:35PM, Keith Busch wrote:
>On Wed, Oct 16, 2024 at 04:59:05PM +0530, Anuj Gupta wrote:
>> +struct uio_meta {
>> +	meta_flags_t	flags;
>> +	u16		app_tag;
>> +	u32		seed;
>> +	struct iov_iter iter;
>> +};
>
>Is the seed used for anything other than the kernel's t10 generation and
>verification? It looks like that's all it is for today, and that part is
>skipped for userspace metadata, so I'm not sure we need it.
>
>I know it's been used for passthrough commands since nvme started
>supporitng it, but I don't see why the driver ever bothered. I think it
>wasn't necessary and we've been carrying it forward ever since.

Not for generation/verfication, but seed is used to remap the ref tag when
submitting metadata on a partition (see blk_integrity_prepare/complete).
For cases like partitioning, MD/DM cloning, where virtual start sector is
different from physical sector remapping is required.

It is skipped for passthrough, but we require it for this series where I/O
can be done on partition too. Christoph [1], Martin [2] also expressed
the need for it in the previous version.

[1] https://lore.kernel.org/linux-block/20240824084430.GG8805@lst.de/
[2] https://lore.kernel.org/linux-block/yq17cc0c9p5.fsf@ca-mkp.ca.oracle.com/

------Q5hryimWBrG20CTDo2Cycv07rC8cEZ5s1mVzGfufIajJO9l9=_4e3b9_
Content-Type: text/plain; charset="utf-8"


------Q5hryimWBrG20CTDo2Cycv07rC8cEZ5s1mVzGfufIajJO9l9=_4e3b9_--

