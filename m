Return-Path: <io-uring+bounces-2242-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6285C90C285
	for <lists+io-uring@lfdr.de>; Tue, 18 Jun 2024 05:39:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE9A41F2351A
	for <lists+io-uring@lfdr.de>; Tue, 18 Jun 2024 03:39:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 378A51F608;
	Tue, 18 Jun 2024 03:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Q1LEPxJA"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065AB33C9
	for <io-uring@vger.kernel.org>; Tue, 18 Jun 2024 03:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718681964; cv=none; b=pey359kOHkmjO69sBudfWSXMDOJLz9RzCbrYpBWAsKEjACLA1GnJXoCFZhJJILmZE/cCMDP12f5rhTnl++Q05teOe+dND5V1DGsvFyYRRGakPVFYzHsDzSuvX/KBD8fIuTnKgVSAOv+ToHFXPas9/0+V+qdLteS1u0cPUoWrxzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718681964; c=relaxed/simple;
	bh=ksu5l3FKNd6hzrVu+hzwqO/GFKJv9oG9PY8ISdMriow=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=tuoO0eoiok6NI7SRwg2eXNqJkIs1+qu0FUkehFPZVDabwPM5CuEyG9Oqqezv21XzZdVo7THbn1NCsvcyFs4Lw9mwFZcRK7Kv3hSThljSPQwBWW5aILp53oN9Svz6Ndm+fssoiKTuNgPmdFFjN49JEe4TM/7q5SsBqQRH7EkwiEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Q1LEPxJA; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240618033913epoutp04d2d845c91c6e2a6f1eb6bef22236033f~Z-CFpLdqO0657906579epoutp04y
	for <io-uring@vger.kernel.org>; Tue, 18 Jun 2024 03:39:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240618033913epoutp04d2d845c91c6e2a6f1eb6bef22236033f~Z-CFpLdqO0657906579epoutp04y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1718681953;
	bh=mPsxo0OxMW7UuHp8yzwOFvKWjlqTotXP3AIM4hIU6zE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q1LEPxJAzkaYeeAXHJnUsy4jTWTYy13gQr8b1U0L1KnWRmTIhhTL86GjeVGAxxGY7
	 MQbRj1HBxUPVPL+K4bbxBUPPqV9njOphUBCE5PguqF8eYj49ScpVXgi0upMuRkD0+A
	 qmVADmKClvm0WfR3niigXzD7p92Tu2MBwDi93jGw=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240618033912epcas5p168635d136dcffe9bfbd690d2df4be62c~Z-CFS_5ff1514415144epcas5p1K;
	Tue, 18 Jun 2024 03:39:12 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4W3CCz1KQtz4x9Px; Tue, 18 Jun
	2024 03:39:11 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	48.5A.06857.F5101766; Tue, 18 Jun 2024 12:39:11 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240618031115epcas5p25e2275b5e73f974f13aa5ba060979973~Z_pq06HeG1739817398epcas5p2A;
	Tue, 18 Jun 2024 03:11:15 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240618031115epsmtrp1c790064c924d08357c87be6758a03525~Z_pq0BWgI0981409814epsmtrp16;
	Tue, 18 Jun 2024 03:11:15 +0000 (GMT)
X-AuditID: b6c32a4b-ae9fa70000021ac9-07-6671015fb508
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	EE.A9.19057.3DAF0766; Tue, 18 Jun 2024 12:11:15 +0900 (KST)
Received: from lcl-Standard-PC-i440FX-PIIX-1996.. (unknown
	[109.105.118.124]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240618031113epsmtip1e9f0df1265c120f2783503ea3b28a074~Z_ppivvNZ3000130001epsmtip1b;
	Tue, 18 Jun 2024 03:11:13 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: asml.silence@gmail.com
Cc: anuj20.g@samsung.com, axboe@kernel.dk, cliang01.li@samsung.com,
	gost.dev@samsung.com, io-uring@vger.kernel.org, joshi.k@samsung.com,
	kundan.kumar@samsung.com, peiwei.li@samsung.com
Subject: Re: [PATCH v4 3/4] io_uring/rsrc: add init and account functions
 for coalesced imus
Date: Tue, 18 Jun 2024 11:11:10 +0800
Message-Id: <20240618031110.2156-1-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <9021b668-cb6d-4077-a470-70c5984e46e5@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDJsWRmVeSWpSXmKPExsWy7bCmum48Y2GawZTJrBZNE/4yW8xZtY3R
	YvXdfjaL038fs1jcPLCTyeJd6zkWi6P/37JZ/Oq+y2ix9ctXVotnezktzk74wOrA7bFz1l12
	j8tnSz36tqxi9Pi8SS6AJSrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8x
	N9VWycUnQNctMwfoJiWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpOgUmBXnFibnFp
	XrpeXmqJlaGBgZEpUGFCdsb2s7sZC7YoVLQ0fmRpYOyW6mLk5JAQMJHo/LqauYuRi0NIYDej
	xPUrK9lBEkICnxglzl8ogUh8Y5SYs+4BE0zH9r3zmSASexklLj66AuU0MUlsPnCCDaSKTUBH
	4veKXyxdjBwcIgJSEr/vcoDUMAvsYZTYuHgRWI2wQJzE7F07wGwWAVWJxyd+soLYvALWEtMX
	v2WF2CYvsf/gWWYQm1PAVuLnu9nsEDWCEidnPmEBsZmBapq3zgb7QULgL7vE7W/f2SCaXSR2
	LN8GdbawxKvjW9ghbCmJl/1t7CDHSQgUSyxbJwfR28Io8f7dHEaIGmuJf1f2gD3ALKApsX6X
	PkRYVmLqqXVMEHv5JHp/P4EazyuxYx6MrSpx4eA2qFXSEmsnbGWGsD0kPs+8wgoJ3gmMEjNm
	F0xgVJiF5J1ZSN6ZhbB5ASPzKkbJ1ILi3PTUYtMC47zUcngkJ+fnbmIEJ1Mt7x2Mjx580DvE
	yMTBeIhRgoNZSYTXaVpemhBvSmJlVWpRfnxRaU5q8SFGU2B4T2SWEk3OB6bzvJJ4QxNLAxMz
	MzMTS2MzQyVx3tetc1OEBNITS1KzU1MLUotg+pg4OKUamCzETyQ885auijp0Lic8VPzrK9nH
	elY7C1LTJ3nNiI7v2Wx2re5ye73WlwX6MrqLdrx7ER39PufzdK1pPqf85jB8/t+ywbdip9QV
	t6wpYl/Lfyby6q94+SlZLPButX3rVf6Ds5Sv2jzeGv2w2t3ivh5L5pf6e1tLNbPrnKWCUg/n
	/TTh/pTdsvS6o+110QNtrJ+/PXY91Cy/PiXU6u2DoLOnz14sKNtX+oH5+pZg84VRgfVOp2cJ
	vvPj2l0h/PsU18/awk0zeiUqdq0M3Pd5dvnF3LszVhZxbPz7REvUpy/oqW5/8rk5BU+L9nrv
	/NvvIx1w+Kjrn5N/Vk/yurfB0kHxRvkpuTj2NI3fCwRfJyqxFGckGmoxFxUnAgCJ5ToKLwQA
	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsWy7bCSnO7lXwVpBnO6WSyaJvxltpizahuj
	xeq7/WwWp/8+ZrG4eWAnk8W71nMsFkf/v2Wz+NV9l9Fi65evrBbP9nJanJ3wgdWB22PnrLvs
	HpfPlnr0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxvazuxkLtihUtDR+ZGlg7JbqYuTkkBAw
	kdi+dz4TiC0ksJtRYspjaYi4tETHoVZ2CFtYYuW/50A2F1BNA5PEvXcPWEASbAI6Er9X/AKy
	OThEBKQkft/lAKlhFjjGKDHj212wGmGBGIkdjQ1sIDaLgKrE4xM/WUFsXgFriemL37JCLJCX
	2H/wLDOIzSlgK/Hz3Wx2kJlCAjYS7z+VQpQLSpyc+QRsJDNQefPW2cwTGAVmIUnNQpJawMi0
	ilEytaA4Nz232LDAKC+1XK84Mbe4NC9dLzk/dxMjONi1tHYw7ln1Qe8QIxMH4yFGCQ5mJRFe
	p2l5aUK8KYmVValF+fFFpTmpxYcYpTlYlMR5v73uTRESSE8sSc1OTS1ILYLJMnFwSjUwyQnw
	Bf37c1vjUXnw/YXC277llWhJ2T+6XKMnmv/y8666DKlkc56U5wzedq0la5cYrsz8UPOu9GJs
	efv1ieKfz4g07X080SAyfm2kNFu3vn2AYl9tzqSpaU/d2yevbs7LvBtjcbN7ul2m5Pedxzy2
	7nT6KKr1ZM/zSMlr5VblaYychZ5Hb67ZNeeOzF+7iOTuDpGjSg8amGvCz0bI2gi/8WudmdgX
	WK502yh59sv8SzxSXJ3WPAW6d/9Y/I6+u7Vq3qEYi9uNhtv2vF1X4fVm8bk5E/gLNlg97rtg
	K5YqM2/u46Q5m/mW3/tt+oDxclO7NVso48cttz7Oqt2rv+XQjwmqk3pkTbadVWS7XftQiaU4
	I9FQi7moOBEAiEkUwuUCAAA=
X-CMS-MailID: 20240618031115epcas5p25e2275b5e73f974f13aa5ba060979973
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240618031115epcas5p25e2275b5e73f974f13aa5ba060979973
References: <9021b668-cb6d-4077-a470-70c5984e46e5@gmail.com>
	<CGME20240618031115epcas5p25e2275b5e73f974f13aa5ba060979973@epcas5p2.samsung.com>

On Sun, 16 Jun 2024 18:43:13 +0100, Pavel Begunkov wrote:
> On 6/17/24 04:12, Chenliang Li wrote:
>> On Sun, 16 Jun 2024 19:04:38 +0100, Pavel Begunkov wrote:
>>> On 5/14/24 08:54, Chenliang Li wrote:
>>>> Introduce helper functions to check whether a buffer can
>>>> be coalesced or not, and gather folio data for later use.
>>>>
>>>> The coalescing optimizes time and space consumption caused
>>>> by mapping and storing multi-hugepage fixed buffers.
>>>>
>>>> A coalescable multi-hugepage buffer should fully cover its folios
>>>> (except potentially the first and last one), and these folios should
>>>> have the same size. These requirements are for easier later process,
>>>> also we need same size'd chunks in io_import_fixed for fast iov_iter
>>>> adjust.
>>>>
>>>> Signed-off-by: Chenliang Li <cliang01.li@samsung.com>
>>>> ---
>>>>    io_uring/rsrc.c | 78 +++++++++++++++++++++++++++++++++++++++++++++++++
>>>>    io_uring/rsrc.h | 10 +++++++
>>>>    2 files changed, 88 insertions(+)
>>>>
>>>> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
>>>> index 65417c9553b1..d08224c0c5b0 100644
>>>> --- a/io_uring/rsrc.c
>>>> +++ b/io_uring/rsrc.c
>>>> @@ -871,6 +871,84 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
>>>>    	return ret;
>>>>    }
>>>>    
>>>> +static bool __io_sqe_buffer_try_coalesce(struct page **pages, int nr_pages,
>>>> +					 struct io_imu_folio_data *data)
>>> io_can_coalesce_buffer(), you're not actually trying to
>>> do it here.
>> 
>> Will change it.
>> 
>>>> +static bool io_sqe_buffer_try_coalesce(struct page **pages, int nr_pages,
>>>> +				       struct io_imu_folio_data *data)
>>>> +{
>>>> +	int i, j;
>>>> +
>>>> +	if (nr_pages <= 1 ||
>>>> +		!__io_sqe_buffer_try_coalesce(pages, nr_pages, data))
>>>> +		return false;
>>>> +
>>>> +	/*
>>>> +	 * The pages are bound to the folio, it doesn't
>>>> +	 * actually unpin them but drops all but one reference,
>>>> +	 * which is usually put down by io_buffer_unmap().
>>>> +	 * Note, needs a better helper.
>>>> +	 */
>>>> +	if (data->nr_pages_head > 1)
>>>> +		unpin_user_pages(&pages[1], data->nr_pages_head - 1);
>>> Should be pages[0]. page[1] can be in another folio, and even
>>> though data->nr_pages_head > 1 protects against touching it,
>>> it's still flimsy.
>> 
>> But here it is unpinning the tail pages inside those coalesceable folios,
>> I think we only unpin pages[0] when failure, am I right? And in
>> __io_sqe_buffer_try_coalesce we have ensured that pages[1:nr_head_pages] are
>> in same folio and contiguous.
>
> We want the entire folio to still be pinned, but don't want to
> leave just one reference and not care down the line how many
> refcounts / etc. you have to put down.
> 
> void unpin_user_page(struct page *page)
> {
> 	sanity_check_pinned_pages(&page, 1);
> 	gup_put_folio(page_folio(page), 1, FOLL_PIN);
> }
>
> And all that goes to the folio as a single object, so doesn't
> really matter which page you pass. Anyway, let's then leave it
> as is then, I wish there would be unpin_folio_nr(), but there
> is unpin_user_page_range_dirty_lock() resembling it.

I see. Thanks for the explanation.

>>>> +
>>>> +	j = data->nr_pages_head;
>>>> +	nr_pages -= data->nr_pages_head;
>>>> +	for (i = 1; i < data->nr_folios; i++) {
>>>> +		unsigned int nr_unpin;
>>>> +
>>>> +		nr_unpin = min_t(unsigned int, nr_pages - 1,
>>>> +					data->nr_pages_mid - 1);
>>>> +		if (nr_unpin == 0)
>>>> +			break;
>>>> +		unpin_user_pages(&pages[j+1], nr_unpin);
>>> same
>>>> +		j += data->nr_pages_mid;
>>> And instead of duplicating this voodoo iteration later,
>>> please just assemble a new compacted ->nr_folios sized
>>> page array.
>> 
>> Indeed, a new page array would make things a lot easier.
>> If alloc overhead is not a concern here, then yeah I'll change it.
>
> It's not, and the upside is reducing memory footprint,
> which would be noticeable with huge pages. It's also
> kvmalloc'ed, so compacting also improves the TLB situation.

OK, will use a new page array.

Thanks,
Chenliang Li

