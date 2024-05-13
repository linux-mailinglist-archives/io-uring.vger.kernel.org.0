Return-Path: <io-uring+bounces-1881-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F7728C3A1D
	for <lists+io-uring@lfdr.de>; Mon, 13 May 2024 04:18:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF40D2814EA
	for <lists+io-uring@lfdr.de>; Mon, 13 May 2024 02:18:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DC024C9F;
	Mon, 13 May 2024 02:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="RitjmN3a"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F371F12AAEA
	for <io-uring@vger.kernel.org>; Mon, 13 May 2024 02:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715566699; cv=none; b=Su9QLdDHKaWDelZhpY4x1JgmK759kag3BvddhD53K7PH2Q9+8jY/feCsbXYvnCRuWDaRugRFb+m0YxbHWt8aaS7uDYW3jg0813FI3d6uwrXHpaFQQ7WgrGSBlDB5XieySBMM8P8rHYlAxEuxXFd+FxvdjcFB+bFPfHWgYPMBCcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715566699; c=relaxed/simple;
	bh=ElqeBlTCeudYfyY2cmIk1mK0EWInZmC7r5iBpWtRtho=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=ODA8Dm73LzSgBZTdRjf1IKaASBUJJY/HzHK2/V2h458epNTtPGv3SbuSbZ/VGHOs1oyLAu0j9CX9htKD+JhWMzoxLVFOHTAGPN7CKORYox24jBiS5IteUoWgLEEzGAonwPZzvUEPW/eiAO5b3KZlhDa3sSYmhET7QHzUERKYJYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=RitjmN3a; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240513021809epoutp047c4f49f72521801fa5ab7a718cee36be~O6tB5lsa-0606406064epoutp04o
	for <io-uring@vger.kernel.org>; Mon, 13 May 2024 02:18:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240513021809epoutp047c4f49f72521801fa5ab7a718cee36be~O6tB5lsa-0606406064epoutp04o
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1715566689;
	bh=CifKMQRS01u0BefZaWflQclhplmgFk2RUsD8CH3pVRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RitjmN3a9Ja0bp+6JEFr0Ksa8qJ/PZG0j9/E5Z0vyfj+WqJw3BYfPhf4aBGhhAdpr
	 +1LirGXTz6FudNr5oh4+b0PZk6YIHYbCYPkWWEeGTbfZPRWhLxbE9tAzLPAwAgfePQ
	 EBrKdvv40ggFyIXG+i/ZAITJZ8M5h53QAUE45YT4=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240513021808epcas5p3770c53e70b8340a29d15b911fb93e109~O6tBkPXoi2408224082epcas5p3e;
	Mon, 13 May 2024 02:18:08 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Vd3726s5yz4x9Q1; Mon, 13 May
	2024 02:18:06 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	4E.60.09688.E5871466; Mon, 13 May 2024 11:18:06 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240513021656epcas5p2367b442e02b07e6405b857f98a4eff44~O6r96nx5h1165211652epcas5p2y;
	Mon, 13 May 2024 02:16:56 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240513021656epsmtrp28991b3f5ddcc2f48655ab86bc02d5dd9~O6r958L1Z3206032060epsmtrp2a;
	Mon, 13 May 2024 02:16:56 +0000 (GMT)
X-AuditID: b6c32a4a-5dbff700000025d8-d4-6641785ea531
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	3F.61.19234.81871466; Mon, 13 May 2024 11:16:56 +0900 (KST)
Received: from testpc118124.samsungds.net (unknown [109.105.118.124]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240513021654epsmtip2d22623dd635f1e0161a9835a094ebf7c~O6r8scz7m1748517485epsmtip2e;
	Mon, 13 May 2024 02:16:54 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, cliang01.li@samsung.com, gost.dev@samsung.com,
	io-uring@vger.kernel.org, joshi.k@samsung.com, kundan.kumar@samsung.com,
	peiwei.li@samsung.com
Subject: Re: [PATCH v2 3/4] io_uring/rsrc: add init and account functions
 for coalesced imus
Date: Mon, 13 May 2024 10:16:50 +0800
Message-Id: <20240513021650.493228-1-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <212f0080-beea-4671-8ce8-8662c155317b@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBJsWRmVeSWpSXmKPExsWy7bCmum5chWOawbuXZhZzVm1jtFh9t5/N
	4vTfxywWNw/sZLJ413qOxeLo/7dsFr+67zJabP3yldXi2V5Oi7MTPrA6cHnsnHWX3ePy2VKP
	vi2rGD0+b5ILYInKtslITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLx
	CdB1y8wBOkdJoSwxpxQoFJBYXKykb2dTlF9akqqQkV9cYquUWpCSU2BSoFecmFtcmpeul5da
	YmVoYGBkClSYkJ0x79MnxoJt/BVvlm1gaWA8xN3FyMkhIWAisXPPFtYuRi4OIYHdjBJ7F+5i
	hnA+MUrc2LWKHaQKzDm7WwimY+GShewQRTuBitrvQzm/GCV+rTjDBlLFJqAj8XvFLxYQW0RA
	WGJ/RysLSBGzwFpGiZUTZwEt5OAQFoiTeL4a7A4WAVWJN5N2gm3jFbCVeLt3FjvENnmJ/QfP
	MoPYnEDx/4cXMUHUCEqcnPkEbD4zUE3z1tlgZ0sIvGSXaFjcyQLR7CLxsesSlC0s8er4Fqih
	UhKf3+1lA7lBQqBYYtk6OYjeFkaJ9+/mMELUWEv8u7KHBaSGWUBTYv0ufYiwrMTUU+uYIPby
	SfT+fsIEEeeV2DEPxlaVuHBwG9QqaYm1E7YyQ9geEtv3voIG7wRGiZ3L5rJPYFSYheSfWUj+
	mYWwegEj8ypGydSC4tz01GLTAqO81HJ4LCfn525iBCdRLa8djA8ffNA7xMjEwXiIUYKDWUmE
	16HQPk2INyWxsiq1KD++qDQntfgQoykwwCcyS4km5wPTeF5JvKGJpYGJmZmZiaWxmaGSOO/r
	1rkpQgLpiSWp2ampBalFMH1MHJxSDUzzgzbqcvTX6WQeZ6347GC3KSehn4/zOy9DydX3M0zT
	Fxq0/Fz6fubXn55loXe+1JZdTQi+Wnn51MQfbxYfFjbs3OS/zUr6FL9Nh6L6+r/PjtYt2370
	xII4Pb0ZS66IOH4P7pJeskr/5etp28vktTpbl4pwG2bMf1oQx+lXUhtgVnjeb+4iz5Lwx2Xp
	FaEpOja7OPNTbu40sSsOaGA3MFZu7rHdfsIm371rT8OUyhPe8/vK+m81ZCVzCD44rFhh+cuI
	S0nx4tTI52lxGx6lVV+++KS03NdeMZSnzz8w7fZXsdlBqeXcv3b8eeOY+On+Sv0/jN+O2vHW
	bi/g3/ihg/P92VNhth94rzIF1jk/UGIpzkg01GIuKk4EAJ/vrhwrBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsWy7bCSvK5EhWOawYXjrBZzVm1jtFh9t5/N
	4vTfxywWNw/sZLJ413qOxeLo/7dsFr+67zJabP3yldXi2V5Oi7MTPrA6cHnsnHWX3ePy2VKP
	vi2rGD0+b5ILYInisklJzcksSy3St0vgypj36RNjwTb+ijfLNrA0MB7i7mLk5JAQMJFYuGQh
	excjF4eQwHZGiUXv9zFDJKQlOg61skPYwhIr/z0Hs4UEfjBKPD4VAmKzCehI/F7xiwXEFgGq
	2d/RygIyiFlgK6NE25SzYIOEBWIkbi8+DmazCKhKvJm0E2wQr4CtxNu9s6AWyEvsPwhRzwkU
	/394ERPEMhuJtVea2CDqBSVOznwCtowZqL5562zmCYwCs5CkZiFJLWBkWsUomlpQnJuem1xg
	qFecmFtcmpeul5yfu4kRHN5aQTsYl63/q3eIkYmD8RCjBAezkgivQ6F9mhBvSmJlVWpRfnxR
	aU5q8SFGaQ4WJXFe5ZzOFCGB9MSS1OzU1ILUIpgsEwenVANTZn/+5JTuDYsnlph0PGMymOl2
	b7nRu5qZL+aZfoxbGh297gnnSn+rR2mX3NqOzChVfiJxXKvpyoV9/zY1m0ZqL96e9k3uhNbd
	FWW+F105f9tvcd9bqxt1KHLf0/WbTmp+uXyl3I4xy+Ebf6bMc+sQFuGyTb+7bjqr53fm3Dhk
	JPF475aZN6sYGLYe146fqH1tZfzKZxsXO8pPij37YsciBZblr85qBXm9zOH8Y/Nw4bTC/bX7
	L6+OOqHjrmSRaND/JP0U9yOPfZbnYkwzGw+cVjjI7bX4y1vRdfwO85L0H6j2eLnPjv5WFHeV
	jSmLvX79xFWV36vrfsqlvg/7dTRlbfmRqRd0jE/t+Vl9zHblPyWW4oxEQy3mouJEAIxJ7wXe
	AgAA
X-CMS-MailID: 20240513021656epcas5p2367b442e02b07e6405b857f98a4eff44
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240513021656epcas5p2367b442e02b07e6405b857f98a4eff44
References: <212f0080-beea-4671-8ce8-8662c155317b@kernel.dk>
	<CGME20240513021656epcas5p2367b442e02b07e6405b857f98a4eff44@epcas5p2.samsung.com>

On Sat, 11 May 2024 10:48:18 -0600 Jens Axboe wrote:
> On 5/10/24 11:52 PM, Chenliang Li wrote:
>> This patch depends on patch 1 and 2.

> What does "patch 1 and 2" mean here, once it's in the git log? It
> doesn't really mean anything. It's quite natural for patches in a series
> to have dependencies on each other, eg patch 3 requirest 1 and 2.
> Highlighting it doesn't really add anything, so just get rid of that.

will delete that in V3.

>> +static int io_coalesced_buffer_account_pin(struct io_ring_ctx *ctx,
>> +					   struct page **pages,
>> +					   struct io_mapped_ubuf *imu,
>> +					   struct page **last_hpage,
>> +					   struct io_imu_folio_data *data)
>> +{
>> +	int i, j, ret;
>> +
>> +	imu->acct_pages = 0;
>> +	j = 0;
>> +	for (i = 0; i < data->nr_folios; i++) {
>> +		struct page *hpage = pages[j];
>> +
>> +		if (hpage == *last_hpage)
>> +			continue;
>> +		*last_hpage = hpage;
>> +		/*
>> +		 * Already checked the page array in try coalesce,
>> +		 * so pass in nr_pages=0 here to waive that.
>> +		 */
>> +		if (headpage_already_acct(ctx, pages, 0, hpage))
>> +			continue;
>> +		imu->acct_pages += data->nr_pages_mid;
>> +		j += (i == 0) ?
>> +			data->nr_pages_head : data->nr_pages_mid;
>
> Can we just initialize 'j' to data->nr_pages_head and change this to be:
>
>	if (i)
>		j += data->nr_pages_mid;

Yes, will change it in V3.

>> +	if (!imu->acct_pages)
>> +		return 0;
>> +
>> +	ret = io_account_mem(ctx, imu->acct_pages);
>> +	if (ret)
>> +		imu->acct_pages = 0;
>> +	return ret;
>> +}
>
>	ret = io_account_mem(ctx, imu->acct_pages);
>	if (!ret)
>		return 0;
>	imu->acct_pages = 0;
>	return ret;

Will change it.

>> +	if (ret) {
>> +		j = 0;
>> +		for (i = 0; i < data->nr_folios; i++) {
>> +			unpin_user_page(pages[j]);
>> +			j += (i == 0) ?
>> +				data->nr_pages_head : data->nr_pages_mid;
>> +		}
>> +		return ret;

> Same comment here.

Will change it.

