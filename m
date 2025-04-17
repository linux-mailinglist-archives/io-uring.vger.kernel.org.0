Return-Path: <io-uring+bounces-7513-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AE737A91972
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 12:33:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2322E19E19FE
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 10:33:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2AD01E521A;
	Thu, 17 Apr 2025 10:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="gcqJZ2q6"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF7526289
	for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 10:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744885993; cv=none; b=iaWMJdJyxrZugiyhJ5fWT61HMmKQlDRsO7fjayjjHQJ8Q0qecALRMsCt3LOl+DOXCxh04mkXFopsn2BvR+LQHpSMOhqozY7goh+S4JT405sZiXesMkgNFTebG9H6JzQqb3Z20RHh/Z6YKw9eY007UNhVFXiJltMAMvRaANC0LS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744885993; c=relaxed/simple;
	bh=UDZpkSxcNQYtO+PEFP48DdCsAz78TBxcKUZZsvMUMRY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=fN7kDup3+7qr8MdEUs0Fc/7c+vKiZSbqSZ7TFMV5CN5xJKel5P/OKS+vaOVqLFRZ4Ald6qKApGflHHY1bwzn5lbpBqDLENaa5slqlR+8DpWGaSDNJ9ZWF6N6uov+neGUMDXIiRjsElRT7bu3ad+CUno/f+25DsSokim10FeVd3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=gcqJZ2q6; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250417103308epoutp04d8648e36ca78a4050b2a46f4e567b126~3FI-DS6Ik0086100861epoutp04T
	for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 10:33:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250417103308epoutp04d8648e36ca78a4050b2a46f4e567b126~3FI-DS6Ik0086100861epoutp04T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1744885988;
	bh=KZOS9l/u+V98QLEBGIJO/GPx5c6ZJJaNURdo7OTR1Zg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=gcqJZ2q6VtTKL3ys966RmRD9LiIp9+Ik5qtVLw4YJyNtl6/iMJoZ5Y0DSr+CzIlDz
	 WEAVehrpCRXIJ3A4OqknOKCwMpZ7ZSA8LsYZScsYFckveaDcae9iM+pDWKK10gnZEF
	 fMK9Yr4lrEkqW1EsC7ftbpAr6IUARIGg9BYsSodU=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250417103307epcas5p3887f54b897d3f333c3f41fe5f4769e8f~3FI_rHVuQ3172831728epcas5p3T;
	Thu, 17 Apr 2025 10:33:07 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.183]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4ZdZ3k4hTVz6B9m9; Thu, 17 Apr
	2025 10:33:06 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	9A.7B.10144.2E8D0086; Thu, 17 Apr 2025 19:33:06 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250417103133epcas5p32c1e004e7f8a5135c4c7e3662b087470~3FHmfg2lK0553105531epcas5p3E;
	Thu, 17 Apr 2025 10:31:33 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250417103133epsmtrp131c5922fb9ddfc5158fb83fdc50d282c~3FHme_-lj1434414344epsmtrp16;
	Thu, 17 Apr 2025 10:31:33 +0000 (GMT)
X-AuditID: b6c32a49-b61ff700000027a0-02-6800d8e27b5a
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	AB.CA.08766.588D0086; Thu, 17 Apr 2025 19:31:33 +0900 (KST)
Received: from ubuntu (unknown [107.99.41.245]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20250417103132epsmtip160e876697731363f36678989b54f161c~3FHl7oCkz0551205512epsmtip1m;
	Thu, 17 Apr 2025 10:31:32 +0000 (GMT)
Date: Thu, 17 Apr 2025 15:53:07 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH 4/4] io_uring/rsrc: send exact nr_segs for fixed buffer
Message-ID: <20250417102307.y2f6ac2cfw5uxfpk@ubuntu>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <d699cc5b-acc9-4e47-90a4-2a36dc047dc5@gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBKsWRmVeSWpSXmKPExsWy7bCmpu6jGwwZBktPqFjMWbWN0eJd6zkW
	ByaPnbPusnt83iQXwBSVbZORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtq
	q+TiE6DrlpkDNF5JoSwxpxQoFJBYXKykb2dTlF9akqqQkV9cYquUWpCSU2BSoFecmFtcmpeu
	l5daYmVoYGBkClSYkJ0xfdZTxoLvvBVX7z9ia2DcwN3FyMkhIWAi8avnElMXIxeHkMBuRokV
	Cz+wQjifGCXePj/ICOF8Y5TYvbqZBaal/fIkqMReRok9qy4yQzhPGCXmrupkBKliEVCVmLhm
	DlAHBwebgLbE6f8cIGERIPP19UPsIDazgIzE5DmXwWxhAW+JheePsIHYvEALDpw5ywxhC0qc
	nPkEbDGngK3Ep5Y2FpBdEgKb2CXO7H/EBnGRi8TdtT+gbGGJV8e3sEPYUhIv+9ug7HKJlVNW
	QNWUSDz/0wtl20u0nupnhjgoQ+LL9F1QX8pKTD21jgkizifR+/sJE0ScV2LHPBhbWWLN+gVQ
	cyQlrn1vhLI9JCbv6IGG0GQmiZsz3zJNYJSbheShWUj2QdhWEp0fmlhnAcOLWUBaYvk/DghT
	U2L9Lv0FjKyrGCVTC4pz01OLTQsM81LL4bGcnJ+7iRGc5LQ8dzDeffBB7xAjEwfjIUYJDmYl
	Ed5z5v/ShXhTEiurUovy44tKc1KLDzGaAuNnIrOUaHI+MM3mlcQbmlgamJiZmZlYGpsZKonz
	Nu9sSRcSSE8sSc1OTS1ILYLpY+LglGpgqjjezLZBWVmE8fP5/dI5ZneyMq41H1j7pU9j/R87
	saJ1G2u5+K4tMi0sV2awjby9b5FFxT/Xj9NPd1pFbUljfHZY88G594XGnRceBYq+1lvQd56p
	5N45028HckWfng/k2hf1kH8556rp0dri81l/TeKX0LvE19TN31zR17AzXv+oTfI65c6E/rtH
	8hgm8krODDSovmWl0F8u16K561o273/ZJ9yX6udnfft2gOmCsODv02367NWHDpt8/K9cUP/k
	JmPG0upq17W+ihJsO5WeWW25fv3Frdm8Fg73vPffnFk+63vovR+yu3ZL5x1+NE1GR2bFXwH2
	6Z2OSisN38XeyZX5e/Vtl8aZj7+bMrytlFiKMxINtZiLihMBRlVvB/sDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsWy7bCSnG7rDYYMg2ufuSzmrNrGaPGu9RyL
	A5PHzll32T0+b5ILYIrisklJzcksSy3St0vgyji9/SxjwUruihmtd5kaGP9wdDFyckgImEi0
	X57E2MXIxSEksJtRYtWCtWwQCUmJZX+PMEPYwhIr/z1nhyh6xCixYvVXVpAEi4CqxMQ1c1i6
	GDk42AS0JU7/BxsqAmS+vn6IHcRmFpCRmDznMpgtLOAtsfD8EbD5vECLD5w5ywwxcz+jxN0F
	O5ghEoISJ2c+YYFoNpOYt/khM8h8ZgFpieX/wOZzCthKfGppY5nAKDALSccsJB2zEDoWMDKv
	YpRMLSjOTc8tNiwwzEst1ytOzC0uzUvXS87P3cQIDk0tzR2M21d90DvEyMTBeIhRgoNZSYT3
	nPm/dCHelMTKqtSi/Pii0pzU4kOM0hwsSuK84i96U4QE0hNLUrNTUwtSi2CyTBycUg1MC+ZV
	HHrAd9s1bLrV0hNzPJY42zy6m7docydfhP+OeQ1cwhMepH66tosx6b/mmVkaq5fND/dR1gpf
	tXrDPhPeDxOTwtoPHVzyYN55xY4k/lfO2T9nSV/UtQiaFn20scfZRX2Hs1aHYdnZc0rPdwVV
	aVyPPfBwyrna8n3NyzcdXZ7D923Rv0ttC9ISGDR+Vot+P39SJc0/YIFGrGwnl2D3xtADS6XW
	2Pf8NFsqkfDe8cHKk6+8G39cfL/ywEd+n9Vd3YG9tt3OGSmcF/RtDv49adWxTVGrak1ulXNZ
	U/Xpbwc+CWpUC9/8s+BZyXX14xkcIeplkTcb1gb+Wylb8+lq7ofmvspd79zCfz4+vN3PQoml
	OCPRUIu5qDgRAEFlrYe8AgAA
X-CMS-MailID: 20250417103133epcas5p32c1e004e7f8a5135c4c7e3662b087470
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----54d-Hcz48zuXzL7C7XxypJsmJ80qpTDuXRrE20Icz968WfK0=_72a2b_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250417103133epcas5p32c1e004e7f8a5135c4c7e3662b087470
References: <cover.1744882081.git.asml.silence@gmail.com>
	<7a1a49a8d053bd617c244291d63dbfbc07afde36.1744882081.git.asml.silence@gmail.com>
	<d699cc5b-acc9-4e47-90a4-2a36dc047dc5@gmail.com>
	<CGME20250417103133epcas5p32c1e004e7f8a5135c4c7e3662b087470@epcas5p3.samsung.com>

------54d-Hcz48zuXzL7C7XxypJsmJ80qpTDuXRrE20Icz968WfK0=_72a2b_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 17/04/25 10:34AM, Pavel Begunkov wrote:
>On 4/17/25 10:32, Pavel Begunkov wrote:
>>From: Nitesh Shetty <nj.shetty@samsung.com>
>...
>>diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
>>index 5cf854318b1d..4099b8225670 100644
>>--- a/io_uring/rsrc.c
>>+++ b/io_uring/rsrc.c
>>@@ -1037,6 +1037,7 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
>>  			   u64 buf_addr, size_t len)
>>  {
>>  	const struct bio_vec *bvec;
>>+	size_t folio_mask;
>>  	unsigned nr_segs;
>>  	size_t offset;
>>  	int ret;
>>@@ -1067,6 +1068,7 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
>>  	 * 2) all bvecs are the same in size, except potentially the
>>  	 *    first and last bvec
>>  	 */
>>+	folio_mask = (1UL << imu->folio_shift) - 1;
>>  	bvec = imu->bvec;
>>  	if (offset >= bvec->bv_len) {
>>  		unsigned long seg_skip;
>>@@ -1075,10 +1077,10 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
>>  		offset -= bvec->bv_len;
>>  		seg_skip = 1 + (offset >> imu->folio_shift);
>>  		bvec += seg_skip;
>>-		offset &= (1UL << imu->folio_shift) - 1;
>>+		offset &= folio_mask;
>>  	}
>>-	nr_segs = imu->nr_bvecs - (bvec - imu->bvec);
>>+	nr_segs = (offset + len + folio_mask) >> imu->folio_shift;
>
>Nitesh, let me know if you're happy with this version.
>
This looks great to me, I tested this series and see the
improvement in IOPS from 7.15 to 7.65M here.

Thanks,
Nitesh Shetty

------54d-Hcz48zuXzL7C7XxypJsmJ80qpTDuXRrE20Icz968WfK0=_72a2b_
Content-Type: text/plain; charset="utf-8"


------54d-Hcz48zuXzL7C7XxypJsmJ80qpTDuXRrE20Icz968WfK0=_72a2b_--

