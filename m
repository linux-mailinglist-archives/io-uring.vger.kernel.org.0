Return-Path: <io-uring+bounces-5050-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A45779D95E1
	for <lists+io-uring@lfdr.de>; Tue, 26 Nov 2024 11:56:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1A260B24C6B
	for <lists+io-uring@lfdr.de>; Tue, 26 Nov 2024 10:55:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90B881CB518;
	Tue, 26 Nov 2024 10:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="r5YzjVUn"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841E9195390
	for <io-uring@vger.kernel.org>; Tue, 26 Nov 2024 10:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732618499; cv=none; b=nkpDmJcB3RuzJHutuSssNdsBVTDkvXDSehqC89T/tHG7mzEMkkTU/70D+G6TL6B3MZ09ClxkX5bs/X6tAFYVpiiWmC7sUkRkAPvBR5k1YwFXj6D39SMTyO6I7vbBImKZRNu2yxDJ005DbW4ZIXRHi2M1Ma+140W4xvg6+2SiaiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732618499; c=relaxed/simple;
	bh=tZ974RW9AUv+NuVLNE+vVbBMYcQ2vSB5JDeMR0yl8cQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=lG9Jt/Ff42YZodNCejPq3CKKJceIwh/1b3qarpTAQL18JoRJFRC5toQnbD+4jV1oIMmv0m9LxZf/HUVmU80bewR1BzZmKXa3KgyqXgyzxBMgGAYAfe4KOZVdKd3kQMVmMLVKDWyET5i7MCIO1jhfqcYtzmTerTEwxAeFaFVBGOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=r5YzjVUn; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20241126105450epoutp047272f361f508b9d9d13f4cdfae767325~Lf1ZCm0rd2845828458epoutp04X
	for <io-uring@vger.kernel.org>; Tue, 26 Nov 2024 10:54:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20241126105450epoutp047272f361f508b9d9d13f4cdfae767325~Lf1ZCm0rd2845828458epoutp04X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1732618490;
	bh=k+0BqZF1ChaDe8890ovcJaZ1K9CV9Mo6R5Hpp1BGuOQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=r5YzjVUnQY0LD2jnUvbhdskcxB2kEjebQI9Ubx8mUudOKMfVQORMlWvMVwtNbuldW
	 tjUH8W4G+kaJFieeytFwvIUFSDRxbPAdrGmJDaDa/3+MTwqiMKm0qZWEdgX7C8VsmI
	 uJfjBHKWsYVrbMh5A8L5k53NUYvVqvueRr2t5VwU=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20241126105449epcas5p21cc42b22d52099f70f408e93d9aa7daa~Lf1YdQRAz0284302843epcas5p2m;
	Tue, 26 Nov 2024 10:54:49 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4XyKGH5SfCz4x9Pq; Tue, 26 Nov
	2024 10:54:47 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	FA.16.19956.7F8A5476; Tue, 26 Nov 2024 19:54:47 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20241126104844epcas5p32e5daec6d0ea68da92a2700c0b0227d2~LfwE5JIZG0979309793epcas5p3l;
	Tue, 26 Nov 2024 10:48:44 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241126104844epsmtrp2a2753bac8d9c3138192609efedb80f1d~LfwE3pIgX0346103461epsmtrp2V;
	Tue, 26 Nov 2024 10:48:44 +0000 (GMT)
X-AuditID: b6c32a4b-fd1f170000004df4-79-6745a8f7e207
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	3D.05.19220.C87A5476; Tue, 26 Nov 2024 19:48:44 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20241126104841epsmtip164d5a7e57201074fb4fc09633e5aa812~LfwCDBKRu0773507735epsmtip1T;
	Tue, 26 Nov 2024 10:48:41 +0000 (GMT)
Date: Tue, 26 Nov 2024 16:10:50 +0530
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
Message-ID: <20241126104050.GA22537@green245>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <a28b46a0-9eb5-45db-80ec-93fdc0eec35e@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xTdxTH87stt7dkxcsr/ugisjuNooLtaLtbHkImmLuBGQvL2JwKN/Su
	ZUDb9THcyBiOsCGoTBZ0PHSMOCtlwwQEUaiPglZFIKyZChF04yUwiNTBusBgLbcs/vc553y/
	+f3OOb8fxvEbRYVYptrA6NR0NoF6c1s7Q7eG/X0+QSmacoaSc/OLXLLG3ArIhqEylJzudABy
	4PplhKxvuImQs0W9XLL6VCFC3lyZQcly631AWga3kx2WO1zyh3NjPLL0QRtKmmzLCNn3r82L
	7Kuq4cX5UperhniUvcdINZmPoFTz2S+p9oEClJobG+RSxy+aAXWvtotHPW8KpppGZ5Bk731Z
	0SqGVjC6EEadoVFkqpUxRGJK2u40qUwkDhPLydeJEDWdw8QQ8UnJYXsys13tECGf0tlGVyqZ
	1uuJnbuidRqjgQlRafSGGILRKrK1Em24ns7RG9XKcDVjiBSLRK9JXcL0LFX5tQGgHV53qObH
	Ra8CcFhQAvgYxCXQVjHPLQHemB/eDuDCXK8XGzgAnOyeAGywAGBHwSPOmsUx14myBQuA5Y02
	TzAO4KC9DCkBGMbFN8OVyWS3AcW3wK6JIuDmAHw7nH5g5bn1HPwYBzY7jyLugj9+AJ5bGFsV
	CfAw+GfpcYRlX3incpTrZj4eAy/M/4O6ORB/FV5vtSHsjZ5i8K/6LSzHw6n+Sk/eH07ZLvJY
	FsLnsxaUZSV02sc8Gi0svHUVsBwLi+6WrXbJwVWwvKWdy+Y3wIq7jQib94HHFkc9XgFsO7PG
	BPymvsbDEFp6CzxMwdumDs+AZwE88X0X8i3YWPVCb1UvnMfyDljb7kCrXHPk4C9D0zLGYii8
	cGVnLfAygyBGq89RMnqpNkLN5P6/8QxNThNYfe7bEtvAH0+ehVsBggErgBiHCBD4rN+t9BMo
	6M8+Z3SaNJ0xm9FbgdS1qxMcYWCGxvVf1IY0sUQukshkMok8QiYm1gumi04r/HAlbWCyGEbL
	6NZ8CMYXFiB5qY8TSvc5vxAebN5QF8VvWbwxld9TvLHGxzR8/qHJXP9wbDJa2uOIjdw83j6d
	sNeUWj8S8UnwaLFPTFnv8Mmg9+I2vTt8SbJE2GuvpgSs636y41Tkz9aovIxGKFmIHfldGnVm
	1/umFO2zXNycXzfz9V7Zx1lf9Xph/vmFcYj81+8OjPOFZb7vVMS/be/rVlT3VWNLy3mV6dWL
	H6UkP06nD791JDHvBpXbOSL3abHXpjY2CvcnDXxweqL72qU3fzFvfUV2T+scCko6mFjE2VOZ
	Gwhvt4oUlvvKEhy7Qr50trx/MmdJVXdo4tajN4p/6pBHGxv4sYVPV5z9pg8NGZbfgkv3E1y9
	ihZv4+j09H/a1ImmdwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsWy7bCSnG7Pctd0gz9X9Sw+fv3NYjFn1TZG
	i9V3+9ksXh/+xGhx88BOJouVq48yWbxrPcdiMXt6M5PF0f9v2SwmHbrGaLH3lrbFnr0nWSzm
	L3vKbtF9fQebxfLj/5gszv89zmpxftYcdgdBj52z7rJ7XD5b6rFpVSebx+Yl9R67bzaweXx8
	eovFo2/LKkaPMwuOsHt83iTnsenJW6YArigum5TUnMyy1CJ9uwSujF3PD7EXzOOtWDz9KVsD
	4y2uLkZODgkBE4lPHw+zdTFycQgJ7GaU6Fp5iQ0iISFx6uUyRghbWGLlv+fsEEVPGCUu7P4C
	VMTBwSKgKvH/ZQBIDZuAusSR561g9SIC2hKvrx8Cq2cW6GeW2PvtPhNIQlggVmLZt6dgRbwC
	uhJvuvuYIIa+Y5T4uuwUK0RCUOLkzCcsIDazgJbEjX8vmUCWMQtISyz/xwES5hSwlVj/9SfY
	oaICyhIHth1nmsAoOAtJ9ywk3bMQuhcwMq9ilEwtKM5Nzy02LDDKSy3XK07MLS7NS9dLzs/d
	xAiOSi2tHYx7Vn3QO8TIxMF4iFGCg1lJhJdP3DldiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+3
	170pQgLpiSWp2ampBalFMFkmDk6pBqaNkR1enlVaO/1tbp1eF7Y/d+m+Uy0pzJVvNy90OGZc
	q5P7ZI71XccvCzvcZ/c8+Fa6mYXfNrmfeZrLzZlJawR4ex+sZnvNFWSyqWKp2TWlVxyPPiZZ
	qc583cJb1DlzyfYexfdBn93y54RufhKZyWKzfwOHJL+bQ7n7zwP9ly5rlf+YwzyxIbI4+51I
	i1lfiLJiq6StZs72CdEeM6yrdxruDQg8YjGDQ2Dz7ln/J8msKNTIcZ4TE7oq7G5FzZryxm+p
	ORJuD/3iWaez7F+g3O9bbyFS81PnxM6c1oJJDxz5Tk/SXKVRUBe09XnQ7SitvaLZB/3O9d6X
	NK9a6H5JUcnqo/ZD8dWPTqr8Tc/QVWIpzkg01GIuKk4EAJwwAuE5AwAA
X-CMS-MailID: 20241126104844epcas5p32e5daec6d0ea68da92a2700c0b0227d2
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----lzW.cJR_-6sCvQYD.lREqa.H-32Z9TKwpDxBjmCjs3VZTSBT=_33907_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241125071502epcas5p46c373574219a958b565f20732797893f
References: <20241125070633.8042-1-anuj20.g@samsung.com>
	<CGME20241125071502epcas5p46c373574219a958b565f20732797893f@epcas5p4.samsung.com>
	<20241125070633.8042-7-anuj20.g@samsung.com>
	<a28b46a0-9eb5-45db-80ec-93fdc0eec35e@gmail.com>

------lzW.cJR_-6sCvQYD.lREqa.H-32Z9TKwpDxBjmCjs3VZTSBT=_33907_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Mon, Nov 25, 2024 at 02:58:19PM +0000, Pavel Begunkov wrote:
> On 11/25/24 07:06, Anuj Gupta wrote:
> 
> ATTR_TYPE sounds too generic, too easy to get a symbol collision
> including with user space code.
> 
> Some options: IORING_ATTR_TYPE_PI, IORING_RW_ATTR_TYPE_PI.
> If it's not supposed to be io_uring specific can be
> IO_RW_ATTR_TYPE_PI
> 

Sure, will change to a different name in the next iteration.

> > +
> > +/* attribute information along with type */
> > +struct io_uring_attr {
> > +	enum io_uring_attr_type	attr_type;
> 
> I'm not against it, but adding a type field to each attribute is not
> strictly needed, you can already derive where each attr placed purely
> from the mask. Are there some upsides? But again I'm not against it.
> 

The mask indicates what all attributes have been passed. But while
processing we would need to know where exactly the attributes have been
placed, as attributes are of different sizes (each attribute is of
fixed size though) and they could be placed in any order. Processing when
multiple attributes are passed would look something like this:

attr_ptr = READ_ONCE(sqe->attr_ptr);
attr_mask = READ_ONCE(sqe->attr_type_mask);
size = total_size_of_attributes_passed_from_attr_mask;

copy_from_user(attr_buf, attr_ptr, size);

while (size > 0) {
	if (sizeof(io_uring_attr_type) > size)
		break;

	attr_type = get_type(attr_buf);
	attr_size = get_size(attr_type);

	process_attr(attr_type, attr_buf);
	attr_buf += attr_size;
	size -= attr_size;
}

We cannot derive where exactly the attribute information is placed
purely from the mask, so we need the type field. Do you see it
differently?

------lzW.cJR_-6sCvQYD.lREqa.H-32Z9TKwpDxBjmCjs3VZTSBT=_33907_
Content-Type: text/plain; charset="utf-8"


------lzW.cJR_-6sCvQYD.lREqa.H-32Z9TKwpDxBjmCjs3VZTSBT=_33907_--

