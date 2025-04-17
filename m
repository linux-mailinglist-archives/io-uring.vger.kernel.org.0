Return-Path: <io-uring+bounces-7516-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C71BDA91C65
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 14:36:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D656E1693AE
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 12:36:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C548A1E49F;
	Thu, 17 Apr 2025 12:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="j3Eq/VKb"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE9D156CA
	for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 12:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744893369; cv=none; b=peQ0MJAP+3BPs99rjTRgPf6SU2DE0Z+4aYq1hwUBoEHnOIz07qKO2NmmdYbIfL6s22i0PWCnQa6P8IxOKaUmT3keL8VpORWMfl0jvWjNZfU2RJvBdS2adRIo4ShIixdpOeB1t2TGf4t6FFiwzuJJJw2CKOKBNcZf/FoP9yr3UI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744893369; c=relaxed/simple;
	bh=IAiucThut58RDk8ZhhimqED1zyoLwVw90iq0QCwQpPs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=UbDTPpISoMgtgr1tOWVeHT9R0jGQuzdAC3g3MkR6+eYSJWXNt2eQ26y6vey1zIzwiWqyjIuuWisxV2BdS8tsEOxjfx6uloLeIonhrjCM+X2veAHi4vsMEv/83bvbWS66t0NKnZsAPIqbGUgcFSQn3vbDYRf/mNDSBl+TClgAH6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=j3Eq/VKb; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250417123603epoutp02aa9ad1993de5f65edc0a6a32e7513884~3G0T3RdN10278302783epoutp02S
	for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 12:36:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250417123603epoutp02aa9ad1993de5f65edc0a6a32e7513884~3G0T3RdN10278302783epoutp02S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1744893363;
	bh=dbM7SFnXuTW60BkIOGq/jdvJYedD/gfHBLOZQiDITLY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=j3Eq/VKbnBfIfz3CgTcuFPqCys1hVj281oyUl3FmHQIYSTZj9UkJ5YBWG6NsRxuh+
	 Ozhgj/xibk5AbVJ82lk/y/8akkxLhsBriCqiLbZ2kvAh4tHBAQjmjzgLl0KfAy5FeO
	 Qxj1jJw8K+2oZx4Em1peV80ZQ499WPZgfNwUaq2o=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250417123603epcas5p1f09e87644d5784e08c37874b40b1b637~3G0TV8AzH1441114411epcas5p1Z;
	Thu, 17 Apr 2025 12:36:03 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.177]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4ZdcnY5x5Rz3hhT4; Thu, 17 Apr
	2025 12:36:01 +0000 (GMT)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250417115843epcas5p2e2586ad60698927d9f200cd05871996e~3GTtWoMdm2941029410epcas5p2M;
	Thu, 17 Apr 2025 11:58:43 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250417115843epsmtrp1d5e1ae85e50d0a75fdd449fd8555d9a3~3GTtWEa2D3244832448epsmtrp1x;
	Thu, 17 Apr 2025 11:58:43 +0000 (GMT)
X-AuditID: b6c32a52-41dfa70000004c16-c7-6800ecf3a055
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	B2.90.19478.3FCE0086; Thu, 17 Apr 2025 20:58:43 +0900 (KST)
Received: from ubuntu (unknown [107.99.41.245]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20250417115842epsmtip1927666472c859f3ff11ad5a846dd9e15~3GTstPlXd2540025400epsmtip1q;
	Thu, 17 Apr 2025 11:58:42 +0000 (GMT)
Date: Thu, 17 Apr 2025 17:20:16 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH 4/4] io_uring/rsrc: send exact nr_segs for fixed buffer
Message-ID: <20250417115016.d7kw4gch7mig6bje@ubuntu>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250417102307.y2f6ac2cfw5uxfpk@ubuntu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKLMWRmVeSWpSXmKPExsWy7bCSnO7nNwwZBn8WcljMWbWN0eJd6zkW
	ByaPnbPusnt83iQXwBTFZZOSmpNZllqkb5fAlfFu1mmmgneCFdvatzA3MK7n62Lk5JAQMJH4
	9vw9WxcjF4eQwHZGiW2fJrBAJCQllv09wgxhC0us/PecHaLoEaNE76HHbCAJFgFViRudU4Ea
	ODjYBLQlTv/nAAmLAJmvrx9iB7GZBWQkJs+5DGYLC3hLLDx/BKyVF2jxlWfnmCFm7mOS+HWy
	CSohKHFy5hMWiGYziXmbHzKDzGcWkJZY/g9sPqeAqcT39r9MExgFZiHpmIWkYxZCxwJG5lWM
	oqkFxbnpuckFhnrFibnFpXnpesn5uZsYwSGpFbSDcdn6v3qHGJk4GA8xSnAwK4nwnjP/ly7E
	m5JYWZValB9fVJqTWnyIUZqDRUmcVzmnM0VIID2xJDU7NbUgtQgmy8TBKdXAtNnxzDXpamuZ
	Qp+jD1ZXx65i4hDNeiuQ5d+hLNG5fdW855eELQ81Ty6dNiElMn7XxmtOb6eE2Puzsa76YLHi
	Swtr7YLdIQd0WZ+IpbtMuV/jYCm6temKIl9Yz3n9X7FdS8tl737fv0l+qVvlJn8mFw6jxGTl
	sL2HLT5eq3pTPVHTbr/C3TZ3Jmdm6T9yOaax+nLa7QV1U57MVG/pUox9wmn84FbZNSdhu61t
	HqYaF5XYmHanuB9i/s1tIXVetZohvudCtuqGjFP+Ef4T5TUdL3yrWOtyO8r89NYIPXnJ04/2
	5M+5Krim9ODnlvcPEvQd8/LfPREILMtXYJaYuqN95rziV9WCPYtTDi/MWqnEUpyRaKjFXFSc
	CAB5CsTxuAIAAA==
X-CMS-MailID: 20250417115843epcas5p2e2586ad60698927d9f200cd05871996e
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----BT9WqRiWUEIwQLQqwzcffU0e5sYl32tGYDBltTglx_TmJHNe=_2f7_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250417103133epcas5p32c1e004e7f8a5135c4c7e3662b087470
References: <cover.1744882081.git.asml.silence@gmail.com>
	<7a1a49a8d053bd617c244291d63dbfbc07afde36.1744882081.git.asml.silence@gmail.com>
	<d699cc5b-acc9-4e47-90a4-2a36dc047dc5@gmail.com>
	<CGME20250417103133epcas5p32c1e004e7f8a5135c4c7e3662b087470@epcas5p3.samsung.com>
	<20250417102307.y2f6ac2cfw5uxfpk@ubuntu>

------BT9WqRiWUEIwQLQqwzcffU0e5sYl32tGYDBltTglx_TmJHNe=_2f7_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 17/04/25 03:53PM, Nitesh Shetty wrote:
>On 17/04/25 10:34AM, Pavel Begunkov wrote:
>>On 4/17/25 10:32, Pavel Begunkov wrote:
>>>From: Nitesh Shetty <nj.shetty@samsung.com>
>>...
>>>diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
>>>index 5cf854318b1d..4099b8225670 100644
>>>--- a/io_uring/rsrc.c
>>>+++ b/io_uring/rsrc.c
>>>@@ -1037,6 +1037,7 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
>>> 			   u64 buf_addr, size_t len)
>>> {
>>> 	const struct bio_vec *bvec;
>>>+	size_t folio_mask;
>>> 	unsigned nr_segs;
>>> 	size_t offset;
>>> 	int ret;
>>>@@ -1067,6 +1068,7 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
>>> 	 * 2) all bvecs are the same in size, except potentially the
>>> 	 *    first and last bvec
>>> 	 */
>>>+	folio_mask = (1UL << imu->folio_shift) - 1;
>>> 	bvec = imu->bvec;
>>> 	if (offset >= bvec->bv_len) {
>>> 		unsigned long seg_skip;
>>>@@ -1075,10 +1077,10 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
>>> 		offset -= bvec->bv_len;
>>> 		seg_skip = 1 + (offset >> imu->folio_shift);
>>> 		bvec += seg_skip;
>>>-		offset &= (1UL << imu->folio_shift) - 1;
>>>+		offset &= folio_mask;
>>> 	}
>>>-	nr_segs = imu->nr_bvecs - (bvec - imu->bvec);
>>>+	nr_segs = (offset + len + folio_mask) >> imu->folio_shift;
>>
>>Nitesh, let me know if you're happy with this version.
>>
>This looks great to me, I tested this series and see the
>improvement in IOPS from 7.15 to 7.65M here.
>

There is corner case where this might not work,
This happens when there is a first bvec has non zero offset.
Let's say bv_offset = 256, len = 512, iov_offset = 3584 (512*7, 8th IO),
here we expect IO to have 2 segments with present codebase, but this
patch set produces 1 segment.

So having a fix like this solves the issue,
+	nr_segs = (offset + len + bvec->bv_offset + folio_mask) >> imu->folio_shift;

Note:
I am investigating whether this is a valid case or not, because having a
512 byte IO with 256 byte alignment feel odd. So have sent one patch for
that as well[1]. If that patch[1] is upstreamed then above case is taken
care of, so we can use this series as it is.

Thanks,
Nitesh

[1]
https://lore.kernel.org/all/20250415181419.16305-1-nj.shetty@samsung.com/


------BT9WqRiWUEIwQLQqwzcffU0e5sYl32tGYDBltTglx_TmJHNe=_2f7_
Content-Type: text/plain; charset="utf-8"


------BT9WqRiWUEIwQLQqwzcffU0e5sYl32tGYDBltTglx_TmJHNe=_2f7_--

