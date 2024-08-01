Return-Path: <io-uring+bounces-2629-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79CDA943FE5
	for <lists+io-uring@lfdr.de>; Thu,  1 Aug 2024 03:55:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9CFB31C2130B
	for <lists+io-uring@lfdr.de>; Thu,  1 Aug 2024 01:55:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 398321487F1;
	Thu,  1 Aug 2024 01:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ugukrtAp"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839D914884F
	for <io-uring@vger.kernel.org>; Thu,  1 Aug 2024 01:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722474675; cv=none; b=QRVtDog+tgS3vDD0j434qFf5A70y1C44pbiFozNOxa02SAIw1y1Dq5kIG1d0v0Xf7EYAY+9XUaQIpObT0vj4+W0vKtPMl9eZyh5PYUjCyYLOxSNVj457a23S6j+uW+JWWgBdU6Nh8GC8NCgn27og4CRZF8LZeyfBKnuyPXLLC/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722474675; c=relaxed/simple;
	bh=TyviDCoDmQrbxRnU82SeRsiK7TNL6Lycqoxj8pQmVBw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=YRx0J4Rw0HH6IPjoS/bnERgo8+XPmhX9TVbeORn80q6x91TEk5LbbwU6A8tiVu0eq0SCOKOV7zqzg0w2UYKyxkEFb2O6xSYEukMpR5bpRtyXQty5Q4ewbpWBiQT5i1nK6FJo9ES/zZA7s64U9ZJA094mzd9NOwZBYiNk671Y9FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ugukrtAp; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240801011109epoutp048aad838991d78a0aeb2836fff3e31497~ndZXgJlnV2599125991epoutp04e
	for <io-uring@vger.kernel.org>; Thu,  1 Aug 2024 01:11:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240801011109epoutp048aad838991d78a0aeb2836fff3e31497~ndZXgJlnV2599125991epoutp04e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1722474669;
	bh=fvpvWTLW08+zgEGtZJQc6JwmybvRX1ax/2OQ9Mj2N7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ugukrtApgWhqPIjNqnNI4gkWfHmt0qMl7Esfjeqxmd/CQeCdaQ64Y9jsQKBzyTXe6
	 DvoZbfM0+595VEb3QoTDj8daCtaRocnfk0tGryiYG8TGlyfDYrkVUh8NUCbDEoTv6r
	 f97v+0DRwdD9jw3aeCzjWdJTIaiHUG6aeiA+QlCw=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240801011108epcas5p39a3f3a47c835cceb252663a7233191d8~ndZXLB-5M0781407814epcas5p3q;
	Thu,  1 Aug 2024 01:11:08 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4WZ9rp74b5z4x9QC; Thu,  1 Aug
	2024 01:11:06 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	15.66.09743.AA0EAA66; Thu,  1 Aug 2024 10:11:06 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240801010122epcas5p3ea76168da6d5dd9ba6d8fe54537591d8~ndQ1eIx3W2160821608epcas5p3D;
	Thu,  1 Aug 2024 01:01:22 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240801010122epsmtrp2e004998028d64a1fdff73e744f338f62~ndQ1dOeZU1457414574epsmtrp2Z;
	Thu,  1 Aug 2024 01:01:22 +0000 (GMT)
X-AuditID: b6c32a4a-3b1fa7000000260f-77-66aae0aa725d
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	43.D4.19367.26EDAA66; Thu,  1 Aug 2024 10:01:22 +0900 (KST)
Received: from lcl-Standard-PC-i440FX-PIIX-1996.. (unknown
	[109.105.118.124]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240801010121epsmtip277503a37d087c1125e79d8eff1d101b9~ndQ0J6n4t2122721227epsmtip2B;
	Thu,  1 Aug 2024 01:01:21 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: asml.silence@gmail.com
Cc: anuj20.g@samsung.com, axboe@kernel.dk, cliang01.li@samsung.com,
	gost.dev@samsung.com, io-uring@vger.kernel.org, joshi.k@samsung.com,
	kundan.kumar@samsung.com, peiwei.li@samsung.com
Subject: Re: [PATCH liburing v3] test: add test cases for hugepage
 registered buffers
Date: Thu,  1 Aug 2024 09:01:15 +0800
Message-Id: <20240801010115.4936-1-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <2b0e7ae1-ac02-4661-b362-8229cc68abb8@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNJsWRmVeSWpSXmKPExsWy7bCmpu6qB6vSDJa+N7domvCX2WLOqm2M
	Fqvv9rNZnP77mMXi5oGdTBbvWs+xWBz9/5bN4lf3XUaLrV++slo828tpcXbCB1YHbo+ds+6y
	e1w+W+rRt2UVo8fnTXIBLFHZNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJ
	uam2Si4+AbpumTlANykplCXmlAKFAhKLi5X07WyK8ktLUhUy8otLbJVSC1JyCkwK9IoTc4tL
	89L18lJLrAwNDIxMgQoTsjMuNl5mKljKWnFr5mG2Bsb5LF2MnBwSAiYSN05vZASxhQR2M0rc
	X2PZxcgFZH9ilJi7+igznPNz2yFGmI79f06xQSR2MkpsXNXKDuE0MUlc+nqcFaSKTUBH4veK
	X0A7ODhEBKQkft/lAKlhFtgD1LB4ERtIjbBAuERXz04mEJtFQFViXtclsA28AtYSp/ueQW2T
	l9h/8CwzyBxOAVuJL8fYIEoEJU7OfAL2AjNQSfPW2cwQ5T/ZJX5OT4KwXSTmf9nJBmELS7w6
	voUdwpaS+PxuLxvISAmBYoll6+RATpMQaGGUeP9uDtRaa4l/V/aAnc8soCmxfpc+RFhWYuqp
	dUwQa/kken8/YYKI80rsmAdjq0pcOLgNapW0xNoJW6FO85B4//0QNEAnAO36s5FxAqPCLCTv
	zELyziyE1QsYmVcxSqYWFOempxabFhjlpZbD4zg5P3cTIziVanntYHz44IPeIUYmDsZDjBIc
	zEoivEInV6YJ8aYkVlalFuXHF5XmpBYfYjQFBvdEZinR5HxgMs8riTc0sTQwMTMzM7E0NjNU
	Eud93To3RUggPbEkNTs1tSC1CKaPiYNTqoGJv0/4mIYFQ9nf4NbrJ+at+8SyQSXggQ2bwPuF
	2ivM/vd+vsHyt1bstX7e7dSlNeu1Vu4JcuBlPsmjk37Syjv6WfOdS4s2KslwW05pZtdx0K93
	+LTufHW8dfNG5aATvam5VsIabxL/1jwrjF/R8bLSq1ojd63lkyYe/WzZ5w1ndx9etT7lcrqg
	wASF3Ybs2idOfbvNU21ruHjSek670KuulX1Lu4Sn/l58Qqz00PFUnxtc16N4RKySAldauDva
	G3rH7w4yL3s/b8rTl48ZWFmYQv+G8h9of/roBdsT9Rurosr/6R/Pcf+7ZIWxzffAaXX8H2Ny
	TpaddJf2eNNtN3HVjJOyHkmb5jysXnq06a4SS3FGoqEWc1FxIgBhCaTrLgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsWy7bCSvG7SvVVpBmc61S2aJvxltpizahuj
	xeq7/WwWp/8+ZrG4eWAnk8W71nMsFkf/v2Wz+NV9l9Fi65evrBbP9nJanJ3wgdWB22PnrLvs
	HpfPlnr0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxsXGy0wFS1krbs08zNbAOJ+li5GTQ0LA
	RGL/n1NsXYxcHEIC2xkl/i7ZxAiRkJboONTKDmELS6z895wdoqiBSeLvtBtgCTYBHYnfK34B
	TeLgEBGQkvh9lwOkhlngGKPEjG93wTYIC4RKfFm/jAnEZhFQlZjXdQlsAa+AtcTpvmdQy+Ql
	9h88ywwyh1PAVuLLMTaQsJCAjcScSx/ZIcoFJU7OfAI2khmovHnrbOYJjAKzkKRmIUktYGRa
	xSiaWlCcm56bXGCoV5yYW1yal66XnJ+7iREc5lpBOxiXrf+rd4iRiYPxEKMEB7OSCK/QyZVp
	QrwpiZVVqUX58UWlOanFhxilOViUxHmVczpThATSE0tSs1NTC1KLYLJMHJxSDUzC6/dNePmv
	LDA5neGxhuxWAaa17ntvnFjdUG5iYvFbNmtr9X/54Bf3nB/LuelWvnyRNbvw8ynfqNOLXp3I
	4OVZuc1Z3Mn+4yvuHxNPz7gYZroiT36SraaJEIPARrXUM86XbYT2X7qqsumZWfA7LiudF/M2
	hXZsiVNUDRScwSEWtKmycskl48VzdSRP9rlE7lKJceK7Jtj345TGKxPlveLrZL63FM+//OmE
	oYbe/D/bMv1EBJgXzfzs7ffZU3bv3vylfvX7jzFuKX33VI9ZgFHj94lPSd/ShUo5f8TvU1PR
	Clv43Vr21Nek80meroKbmy7F3b95ecYzt//73yrU7la9URH4k2epSFrvwvhA9SdKLMUZiYZa
	zEXFiQAYFCcz4gIAAA==
X-CMS-MailID: 20240801010122epcas5p3ea76168da6d5dd9ba6d8fe54537591d8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240801010122epcas5p3ea76168da6d5dd9ba6d8fe54537591d8
References: <2b0e7ae1-ac02-4661-b362-8229cc68abb8@gmail.com>
	<CGME20240801010122epcas5p3ea76168da6d5dd9ba6d8fe54537591d8@epcas5p3.samsung.com>

On Thu, 1 Aug 2024 00:13:10 +0100, Pavel Begunkov wrote:
> On 5/31/24 06:20, Chenliang Li wrote:
>> Add a test file for hugepage registered buffers, to make sure the
>> fixed buffer coalescing feature works safe and soundly.
>> 
>> Testcases include read/write with single/multiple/unaligned/non-2MB
>> hugepage fixed buffers, and also a should-not coalesce case where
>> buffer is a mixture of different size'd pages.
>
> lgtm, would be even better if you can add another patch
> testing adding a small buffer on the left size of a hugepage,
> i.e. like mmap_mixutre() but the small buffer is on the other
> side.

Sure, will add that.

Thanks,
Chenliang Li

