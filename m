Return-Path: <io-uring+bounces-7596-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF990A95084
	for <lists+io-uring@lfdr.de>; Mon, 21 Apr 2025 14:00:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED3223B1121
	for <lists+io-uring@lfdr.de>; Mon, 21 Apr 2025 12:00:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66F0925A34D;
	Mon, 21 Apr 2025 12:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="p2sm4FEj"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E6928F1
	for <io-uring@vger.kernel.org>; Mon, 21 Apr 2025 12:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745236844; cv=none; b=LV/H+etcOkx5EvlHtSIhQCzkuADpU17q4pADYxxeNYDsZ14c6JExX8c1Il7n5yhV4/0dq11wMEAcCprQ8qr/HsnmgEPLd5yNgBT0HvrTjU5vWrnxPS7pUYZ6Hh2YjrENvVB2l6isCqaN5kue6TQZhLDPIjwzo1i+uZQ0zrA2K1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745236844; c=relaxed/simple;
	bh=WAPpkUEKeseXIIwC+M338vqaf7IY0f61ovVVqkNJ5O4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=cOv+6Ndv+83CKxe79TLd2PtV3uMuUm0IUjXbTQv5vG5Zkm8tcF+XbKc9mLxEY4v8DrW9+iDCnJnzyZSrHHU3iyHW5YXfv1wPg3yKoF4RccDSpucozaRjVX62MkC0RyHPuyIin/x6MDYmz0JtLecS83+ueuQYnm5qqxikhQK3aK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=p2sm4FEj; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250421120032epoutp014055801f23a96dbebf6333453e6513d5~4U6ce965C0765407654epoutp01D
	for <io-uring@vger.kernel.org>; Mon, 21 Apr 2025 12:00:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250421120032epoutp014055801f23a96dbebf6333453e6513d5~4U6ce965C0765407654epoutp01D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1745236832;
	bh=EXMKWx2RqKLjAaNdE8FYsXihFbGFJ58KcHds6ndMRjE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=p2sm4FEjAkFKbPhrKItxb+MbPTpVcjJeezpWusGop2rLuJ258pQI9++OiehAhio0V
	 hTjEl546Zn3Cyi6y2z8fhz6QbuX0Sad0j6oAI9neMtzw2LKqHaPX1BMYPEtgb2KNP5
	 hmH0wiNUmBi5ev0aPyi14vaIq7A6ncGGuU+ygaqs=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250421120032epcas5p2eb30a781b081f459b9f19fe3cd36e81c~4U6cO_v_f0601906019epcas5p2v;
	Mon, 21 Apr 2025 12:00:32 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.178]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4Zh3pl2WQ1z6B9m4; Mon, 21 Apr
	2025 12:00:31 +0000 (GMT)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250421115925epcas5p18c9a46be72b98c089dc1833befc4d06d~4U5dtoIC51568015680epcas5p1K;
	Mon, 21 Apr 2025 11:59:25 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250421115925epsmtrp2bd3cd3c3282a3221b4df19df63b2bc49~4U5dtI8yz3197131971epsmtrp2j;
	Mon, 21 Apr 2025 11:59:25 +0000 (GMT)
X-AuditID: b6c32a52-41dfa70000004c16-50-6806331df1dd
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	88.08.19478.D1336086; Mon, 21 Apr 2025 20:59:25 +0900 (KST)
Received: from ubuntu (unknown [107.99.41.245]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20250421115924epsmtip1bd716f65c82dbcce017ad438e2225106~4U5dFQKO-2935629356epsmtip1q;
	Mon, 21 Apr 2025 11:59:24 +0000 (GMT)
Date: Mon, 21 Apr 2025 17:20:57 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH 2/3] io_uring/rsrc: clean up io_coalesce_buffer()
Message-ID: <20250421115057.mr43ociu7erpohhj@ubuntu>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <ad698cddc1eadb3d92a7515e95bb13f79420323d.1745083025.git.asml.silence@gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKLMWRmVeSWpSXmKPExsWy7bCSnK6sMVuGwbGTwhZzVm1jtHjXeo7F
	gclj56y77B6fN8kFMEVx2aSk5mSWpRbp2yVwZbyYuZOl4B5nxb+rl5gbGKdwdDFyckgImEi0
	rOhj72Lk4hAS2M4oMeHXNkaIhKTEsr9HmCFsYYmV/55DFT1ilLi89xcLSIJFQFViz8rXrF2M
	HBxsAtoSp/+DDRUBMl9fP8QOYjMLyEhMnnMZzBYWcJWYdBnC5gVafPnLf0aImT2MEgcfdLJA
	JAQlTs58wgLRbCYxb/NDZpD5zALSEsv/gc3nFIiVmLniPOsERoFZSDpmIemYhdCxgJF5FaNo
	akFxbnpucoGhXnFibnFpXrpecn7uJkZwSGoF7WBctv6v3iFGJg7GQ4wSHMxKIrzmQcwZQrwp
	iZVVqUX58UWlOanFhxilOViUxHmVczpThATSE0tSs1NTC1KLYLJMHJxSDUxrcw6H357PIXeH
	MfnX7K/v/0m4X79/wfjaAz7ndS+sd/Q2la9iTdjftFs8Rdxd+3O8mx6HQ+Phx08eTHq/L6H3
	u05wSN80Ywem7xmZ3/eKRzsH3M0sONY//8Ua6QLHC7w2rd6mIY/t4i9fivhzuPOHt3NjTGJ9
	5M/W+yx66gdca/Y+FHm08APHGocXn3RyNz82FT1qX54jHe4eqtMfsbbrJe9Jjstl5dr84itX
	Sa7cdO1H6O+fm2dd73soYCg5ia/6Sdy5dennrzR+PbRl6+bDTx3W9bcVmbHt+rU+xOq20vZA
	82x+3eSZ92p2RN35+WL/2wOsz4sXiScV7MlUfOS1+F3e/x3VcSJG/vayH82UWIozEg21mIuK
	EwHSTBaOuAIAAA==
X-CMS-MailID: 20250421115925epcas5p18c9a46be72b98c089dc1833befc4d06d
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----Yg3Iyp5n5B4jRFJeDaOo4Y_wVT_fanZ5F2PatVzytDSjhAyU=_deda_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250421115925epcas5p18c9a46be72b98c089dc1833befc4d06d
References: <cover.1745083025.git.asml.silence@gmail.com>
	<ad698cddc1eadb3d92a7515e95bb13f79420323d.1745083025.git.asml.silence@gmail.com>
	<CGME20250421115925epcas5p18c9a46be72b98c089dc1833befc4d06d@epcas5p1.samsung.com>

------Yg3Iyp5n5B4jRFJeDaOo4Y_wVT_fanZ5F2PatVzytDSjhAyU=_deda_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 19/04/25 06:47PM, Pavel Begunkov wrote:
>We don't need special handling for the first page in
>io_coalesce_buffer(), move it inside the loop.
>
>Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>---
> io_uring/rsrc.c | 47 ++++++++++++++++++++++-------------------------
> 1 file changed, 22 insertions(+), 25 deletions(-)
>
>diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
>index 40061a31cc1f..21613e6074d4 100644
>--- a/io_uring/rsrc.c
>+++ b/io_uring/rsrc.c
>@@ -685,37 +685,34 @@ static bool io_coalesce_buffer(struct page ***pages, int *nr_pages,
> 				struct io_imu_folio_data *data)
> {
> 	struct page **page_array = *pages, **new_array = NULL;
>-	int nr_pages_left = *nr_pages, i, j;
>-	int nr_folios = data->nr_folios;
>+	unsigned nr_pages_left = *nr_pages;
>+	unsigned nr_folios = data->nr_folios;
>+	unsigned i, j;
checkpatch.pl complains about just "unsigned", "unsigned int" is preferred.

>
> 	/* Store head pages only*/
>-	new_array = kvmalloc_array(nr_folios, sizeof(struct page *),
>-					GFP_KERNEL);
>+	new_array = kvmalloc_array(nr_folios, sizeof(struct page *), GFP_KERNEL);
Not sure whether 80 line length is preferred in uring subsystem, if yes
then this breaks it.

--Nitesh Shetty

------Yg3Iyp5n5B4jRFJeDaOo4Y_wVT_fanZ5F2PatVzytDSjhAyU=_deda_
Content-Type: text/plain; charset="utf-8"


------Yg3Iyp5n5B4jRFJeDaOo4Y_wVT_fanZ5F2PatVzytDSjhAyU=_deda_--

