Return-Path: <io-uring+bounces-5471-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 40D8B9F0481
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 07:01:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A5A00188B171
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 06:01:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E42E24A21;
	Fri, 13 Dec 2024 06:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="agigrxIn"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927B01547CC
	for <io-uring@vger.kernel.org>; Fri, 13 Dec 2024 06:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734069698; cv=none; b=p5BcmmWK9rS7Wt94cOrpQtBWpTZFVy8eOkEGhhLaFQFrJaqs1BATNg+PKZixPd0KsHRSNbWCcbu03B5PLgIZwFiYpJSjMar7eNV6Ty45iXApA0/PW0LAklYPwUdsUzqEQUpIYxj9IwHzYAfNLisQvn0s/WyMIvYjxnR0o3xErrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734069698; c=relaxed/simple;
	bh=Gc3Jt8blBw7jT0/gisSOyP9+e9/2TScJtmc2wxbTh64=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=MIpTPwzvWdagjHOsDMWwzF92Aj5rHIHD33OuvP6HmOwC9ELGBjtv+WaIsZ2BKlxDuXOcDLTt69BXISSg0GvhZ8EaFpElWy49LONBBb6hL14MLVOgJqCWzFEDXRGvJ2VPEWIXPLJOxiwYEYlpquuyqvtUChudg4rCek3Lu5IVbNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=agigrxIn; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20241213060129epoutp04b640c31bbe9cd2d30301f1c5aac735c7~QpzHbMQ8I1351913519epoutp04_
	for <io-uring@vger.kernel.org>; Fri, 13 Dec 2024 06:01:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20241213060129epoutp04b640c31bbe9cd2d30301f1c5aac735c7~QpzHbMQ8I1351913519epoutp04_
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1734069689;
	bh=Gc3Jt8blBw7jT0/gisSOyP9+e9/2TScJtmc2wxbTh64=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=agigrxInquIQZrTdhkRMRkqOGXx/4s/QFzpHTRsh7kS7CqbhB7hdEbJGAkjFf6A3u
	 0boOSjWgPD8ApQ+3v+IZfV0DbT8P1Gh/WGHGxuDGSPkBibRwpdaP2k4GaPFDtl1jHQ
	 swEfaLTEOnb9V26Z2gcSQ29lfXaUCK56nXykN9Eg=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20241213060128epcas5p14ff115b9b8eb9a4ad609393dabc21f08~QpzHIUKrT1879718797epcas5p1J;
	Fri, 13 Dec 2024 06:01:28 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.183]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4Y8dxz08p9z4x9QB; Fri, 13 Dec
	2024 06:01:27 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	D6.8F.19933.5BDCB576; Fri, 13 Dec 2024 15:01:25 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20241213060117epcas5p33e93030b04f8d51f0367d375faa2adaf~Qpy871bXn1217912179epcas5p3q;
	Fri, 13 Dec 2024 06:01:17 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241213060117epsmtrp16131439c5b74bccf83c6d6a2b4a078b4~Qpy84dGvw1127611276epsmtrp1l;
	Fri, 13 Dec 2024 06:01:17 +0000 (GMT)
X-AuditID: b6c32a4a-b87c770000004ddd-80-675bcdb5a785
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	ED.91.18729.DADCB576; Fri, 13 Dec 2024 15:01:17 +0900 (KST)
Received: from ubuntu (unknown [107.99.41.245]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20241213060115epsmtip1db0b0c6b8b3b9dd4cfe4ed6ce87873c1~Qpy7HlTGq1086010860epsmtip1m;
	Fri, 13 Dec 2024 06:01:15 +0000 (GMT)
Date: Fri, 13 Dec 2024 11:23:21 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Keith Busch <kbusch@meta.com>
Cc: axboe@kernel.dk, hch@lst.de, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, sagi@grimberg.me, asml.silence@gmail.com,
	anuj20.g@samsung.com, joshi.k@samsung.com, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv14 10/11] nvme: register fdp parameters with the block
 layer
Message-ID: <20241213055321.rh6qdkru53ao5wr4@ubuntu>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241211183514.64070-11-kbusch@meta.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCJsWRmVeSWpSXmKPExsWy7bCmuu7Ws9HpBse36Fk0TfjLbDFn1TZG
	i9V3+9ksVq4+ymTxrvUci8XR/2/ZLCYdusZocebqQhaLvbe0LfbsPcliMX/ZU3aLda/fszjw
	eOycdZfd4/y9jSwel8+Wemxa1cnmsXlJvcfumw1sHucuVnj0bVnF6PF5k1wAZ1S2TUZqYkpq
	kUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QvUoKZYk5pUChgMTi
	YiV9O5ui/NKSVIWM/OISW6XUgpScApMCveLE3OLSvHS9vNQSK0MDAyNToMKE7IxJezrYCi6w
	Vsy8OpetgfEnSxcjB4eEgInEzkflXYycHEICuxklZv5y6mLkArI/MUo8W93IDpH4xiixfzU/
	TP2Pw4IQNXsZJebfuMUI4TwBqrl6nhmkgUVAVeLk7yZmkAY2AW2J0/85QMIiAooS54HBAFLP
	LDCRSeL3oSawBcICQRJ/JjwC6+UFWnB293E2CFtQ4uTMJywgNqeAmURT22owW0JgKYfEqTXR
	EAe5SPRfk4YIC0u8Or6FHcKWknjZ3wZll0usnLICbK+EQAujxKzrsxghEvYSraf6wfYyC2RI
	XLh/CqpBVmLqqXVMEHE+id7fT5gg4rwSO+bB2MoSa9YvYIOwJSWufW+Esj0k5kxdwgoJuC2M
	EodOq09glJuF5J1ZSNZB2FYSnR+aWGcBvcMsIC2x/B8HhKkpsX6X/gJG1lWMkqkFxbnpqcWm
	BUZ5qeXwCE7Oz93ECE6+Wl47GB8++KB3iJGJg/EQowQHs5II7w37yHQh3pTEyqrUovz4otKc
	1OJDjKbA6JnILCWanA9M/3kl8YYmlgYmZmZmJpbGZoZK4ryvW+emCAmkJ5akZqemFqQWwfQx
	cXBKNTD1Hcx598B0zdEfz5XqZ8i/3DbD7LvY/nXqTbMKUxwOt+2bEtX/2cI+zebCgShVjagn
	L9+J3FxiK/zAWqK6oWa++3sju//lRTk2OxdpVq750rrU5Ns7+cuOf35Om//X4tndLxPuBB2S
	jM9ZUj45tcu+eqnDLKXahggO5xdnA59vcTjx9WGh8azPjFc23HN61cW9Y45xefC+x7v7zYK1
	m+5xte6+IFC868H3+ZcqA/YbejtMP/fIvWT2P+UQRrEsLj/BWOkN/7/tEBGPlXXNlmlvVwp8
	NDc/NoTF4XrmDaZqs9kz+LgKfeqCPe6r9ic4+s6JqCrrtL6gc0x50vte1w3/zE5MiakIP7p7
	l1SZiIcSS3FGoqEWc1FxIgD7RCtcRwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsWy7bCSnO7as9HpBk/W6lg0TfjLbDFn1TZG
	i9V3+9ksVq4+ymTxrvUci8XR/2/ZLCYdusZocebqQhaLvbe0LfbsPcliMX/ZU3aLda/fszjw
	eOycdZfd4/y9jSwel8+Wemxa1cnmsXlJvcfumw1sHucuVnj0bVnF6PF5k1wAZxSXTUpqTmZZ
	apG+XQJXxoeVZxgLmpgrml/FNTAeZepi5OCQEDCR+HFYsIuRi0NIYDejxO3DFxm7GDmB4pIS
	y/4eYYawhSVW/nvODlH0iFFi9oMFLCAJFgFViZO/m5hBBrEJaEuc/s8BEhYRUJQ4D3QMSD2z
	wGQmieczj4HVCwsESfyZ8AhsKC/Q4rO7j7OB2EICCRId156wQcQFJU7OfAJWzyxgJjFv80Ow
	+cwC0hLL/4HN5wQKN7WtZpnAKDALSccsJB2zEDoWMDKvYpRMLSjOTc8tNiwwzEst1ytOzC0u
	zUvXS87P3cQIjhwtzR2M21d90DvEyMTBeIhRgoNZSYT3hn1kuhBvSmJlVWpRfnxRaU5q8SFG
	aQ4WJXFe8Re9KUIC6YklqdmpqQWpRTBZJg5OqQam3eL9GxkyHAu4XNMnr19eYFzwc+aG6tml
	bw5PnGTH8F75Z6rc84UeiXYie180d62eYqfccviXsDmDpLdY+ddV18QVJ3e5cQoXHy92jlKy
	Sl/+QSdykVNjwVq1sE4trj0pF+s4n1RO/el2tXVXTUZBm95jkbe5c52OpFU2V+++9KBuhxDL
	vbYEOYOzFX5FTGeM3y9ec13Wz7vznUG/oVD9MTPOXuerx/T3xAQeXvx6W1PKa4P6k1/Ny3uL
	8p5PmtH6uTA7OsP7xtpZy552MW+rO6sv5xNbt0V7Vn4Oz/mQy17Fq231UlTL/jyX//3hzBbH
	NTscJO67Vfud2Hew4uXTRsOEhwZfC936bgETlhJLcUaioRZzUXEiACUZdmcLAwAA
X-CMS-MailID: 20241213060117epcas5p33e93030b04f8d51f0367d375faa2adaf
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----OTMyRIxA-vjvkyMBIEVTa8B.hsA2RhXFaIa_oKBleWSyrD67=_806f4_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241213060117epcas5p33e93030b04f8d51f0367d375faa2adaf
References: <20241211183514.64070-1-kbusch@meta.com>
	<20241211183514.64070-11-kbusch@meta.com>
	<CGME20241213060117epcas5p33e93030b04f8d51f0367d375faa2adaf@epcas5p3.samsung.com>

------OTMyRIxA-vjvkyMBIEVTa8B.hsA2RhXFaIa_oKBleWSyrD67=_806f4_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 11/12/24 10:35AM, Keith Busch wrote:
>From: Keith Busch <kbusch@kernel.org>
>
>Register the device data placement limits if supported. This is just
>registering the limits with the block layer. Nothing beyond reporting
>these attributes is happening in this patch.
>
>Signed-off-by: Keith Busch <kbusch@kernel.org>
>---

Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>

------OTMyRIxA-vjvkyMBIEVTa8B.hsA2RhXFaIa_oKBleWSyrD67=_806f4_
Content-Type: text/plain; charset="utf-8"


------OTMyRIxA-vjvkyMBIEVTa8B.hsA2RhXFaIa_oKBleWSyrD67=_806f4_--

