Return-Path: <io-uring+bounces-2233-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 31D1790A2CF
	for <lists+io-uring@lfdr.de>; Mon, 17 Jun 2024 05:16:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AC6C01F2115F
	for <lists+io-uring@lfdr.de>; Mon, 17 Jun 2024 03:16:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06632525D;
	Mon, 17 Jun 2024 03:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="oERNdLdZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B78256A
	for <io-uring@vger.kernel.org>; Mon, 17 Jun 2024 03:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718594196; cv=none; b=je3RGYChvfXboK4YyJUYj22oaSyG4A741ecK5N4mc9lXI8HdilCZcOzmGX1Y5QaXn+KWvY3LYKj/OuWXbldbZbPptdgdGFdQX1RtpP9CGNMugTWDnc+D04E2h/I0+WH4g1Pddj0izL8DU//N3QoZjkz6BT6BXMkLc+hKhJ0+qt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718594196; c=relaxed/simple;
	bh=g9zaBj2zhQik/5yzLI8Jyr+VmfqBAKY47xR9q0d1lsw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=iovxloWLwgU5eE8l8DjmGXCihvPrmkJJ+7aWGvelGQWht+J4J6+ctZZCRpf6PnPLgSNbx0jHoJdYRTtPOldjQpc7jClCeFJwUxcEExYH2yzEKA3MPrO13p14z0Za2u4vieHBdI31UA9bY4iCtcXCYEJ+42XcnLJEVmFtNYTTze4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=oERNdLdZ; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240617031625epoutp03fafc749afe1e06425e4dacc0f390e96c~ZrE523tW32826528265epoutp03b
	for <io-uring@vger.kernel.org>; Mon, 17 Jun 2024 03:16:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240617031625epoutp03fafc749afe1e06425e4dacc0f390e96c~ZrE523tW32826528265epoutp03b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1718594185;
	bh=h9ljNTblHVXKnGQV83m4IXZJazINXn2mD2pXdxXrtDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oERNdLdZM2VoKaUXxc4gK5Dhd1XhfSq52Wt97qg8yuVdgG7MVCWYIl/2/+wPvWGqx
	 O+m9NnVL1v9ilPKWtxJooW3zSSrJZBZe5Xt2m8k/zMR0jWqAzZ9BuFBn9xOuBwXx56
	 R2YDGrW54hgD2NsR0dZOUhI2ESt3g5H76jWRuqOI=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240617031625epcas5p346f3c67c481a954e2e669b4748c47e60~ZrE5UsqA-2285622856epcas5p3-;
	Mon, 17 Jun 2024 03:16:25 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.178]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4W2Zm71qR4z4x9Pv; Mon, 17 Jun
	2024 03:16:23 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	87.4E.06857.78AAF666; Mon, 17 Jun 2024 12:16:23 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240617031218epcas5p4f706f53094ed8650a2b59b2006120956~ZrBTwFgGT0238802388epcas5p4V;
	Mon, 17 Jun 2024 03:12:18 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240617031218epsmtrp1d8cdd2c8dab8e9baa67c064dfd1c8dc2~ZrBTvNros3263832638epsmtrp1a;
	Mon, 17 Jun 2024 03:12:18 +0000 (GMT)
X-AuditID: b6c32a4b-88bff70000021ac9-b9-666faa87ec98
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	1D.44.07412.299AF666; Mon, 17 Jun 2024 12:12:18 +0900 (KST)
Received: from lcl-Standard-PC-i440FX-PIIX-1996.. (unknown
	[109.105.118.124]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240617031217epsmtip1a47fe3b351b70da0fe059aa884e6c93b~ZrBSmXBGm2392423924epsmtip1t;
	Mon, 17 Jun 2024 03:12:17 +0000 (GMT)
From: Chenliang Li <cliang01.li@samsung.com>
To: asml.silence@gmail.com
Cc: anuj20.g@samsung.com, axboe@kernel.dk, cliang01.li@samsung.com,
	gost.dev@samsung.com, io-uring@vger.kernel.org, joshi.k@samsung.com,
	kundan.kumar@samsung.com, peiwei.li@samsung.com
Subject: Re: [PATCH v2 0/4] io_uring/rsrc: coalescing multi-hugepage
 registered buffers
Date: Mon, 17 Jun 2024 11:12:10 +0800
Message-Id: <20240617031210.2325-1-cliang01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <1233b470-c190-4b8f-873d-dfbf31b6874d@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDJsWRmVeSWpSXmKPExsWy7bCmpm77qvw0gxnNHBZNE/4yW8xZtY3R
	YvXdfjaL038fs1jcPLCTyeJd6zkWi6P/37JZ/Oq+y2ix9ctXVotnezktzk74wOrA7bFz1l12
	j8tnSz36tqxi9Pi8SS6AJSrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8x
	N9VWycUnQNctMwfoJiWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJrVJqQUpOgUmBXnFibnFp
	XrpeXmqJlaGBgZEpUGFCdsarli7GgmfiFTuvzmFqYGwX7mLk5JAQMJE4fuo1axcjF4eQwG5G
	idkXO9kgnE+MEpOnrmGEcL4xSpz6/I4ZpuXqv8VQLXsZJc5Ne8YE4TQxSdz+NYsNpIpNQEfi
	94pfLF2MHBwiAlISv+9ygNQwC+xhlNi4eBEbSFxYIFLi3dk8kHIWAVWJPW0rmUDCvALWEtNf
	ikPskpfYf/As2F5OAVuJN5vnM4HYvAKCEidnPmEBsZmBapq3zmYGGS8h0MghcWvFaSaIZheJ
	s3N2skHYwhKvjm9hh7ClJF72t7GD7JIQKJZYtk4OoreFUeL9uzmMEDXWEv+u7AE7n1lAU2L9
	Ln2IsKzE1FPrmCD28kn0/n4CtYpXYsc8GFtV4sLBbVCrpCXWTtgKDTcPiQXPrkEDdAKjRPvl
	ZsYJjAqzkPwzC8k/sxBWL2BkXsUomVpQnJueWmxaYJyXWg6P5OT83E2M4GSq5b2D8dGDD3qH
	GJk4GA8xSnAwK4nwOk3LSxPiTUmsrEotyo8vKs1JLT7EaAoM74nMUqLJ+cB0nlcSb2hiaWBi
	ZmZmYmlsZqgkzvu6dW6KkEB6YklqdmpqQWoRTB8TB6dUA9OLg3NKWOvEMuwqpRxVXs8OC2lf
	P21vVc6f45VrZfdv2cbxvzTbSMlhA8/sOW/y7T/YVNjlKiRzb+1Mm7jo/NWSjBVFWSbBDXfX
	z8iaqWTVPXPPFb0928u3Nbj190VuTFxbb+Xz9Rlj3YmDcprHyzWFe9dFcIm0v70qy3nO3ujN
	0fzygwvOX0nf6Zv33cbnxKbZtu+fz4rkC7OaPrl44hcGhROHCxU3ZDGvM5tX/kV+/YOVcimH
	WncmyvdxfwmomX5SZM628vk1fnEsU4sFhQX1H7HF2YZkFXodvXZpxSoJ04jDs0zaUwRbHq//
	GXJ2ffGdSsO9s00qWPbMvsyw2uf0g6Z9m+QjYqfnHz4lUKnEUpyRaKjFXFScCAC3UCHuLwQA
	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsWy7bCSnO6klflpBpvOq1g0TfjLbDFn1TZG
	i9V3+9ksTv99zGJx88BOJot3redYLI7+f8tm8av7LqPF1i9fWS2e7eW0ODvhA6sDt8fOWXfZ
	PS6fLfXo27KK0ePzJrkAligum5TUnMyy1CJ9uwSujFctXYwFz8Qrdl6dw9TA2C7cxcjJISFg
	InH132LWLkYuDiGB3YwSjxaeZ4NISEt0HGplh7CFJVb+e84OUdTAJPHjwHQmkASbgI7E7xW/
	WLoYOThEBKQkft/lAKlhFjjGKDHj210WkBphgXCJPSuegdWzCKhK7GlbyQRSzytgLTH9pTjE
	fHmJ/QfPMoPYnAK2Em82zwcrFxKwkTjw8jyYzSsgKHFy5hOwkcxA9c1bZzNPYBSYhSQ1C0lq
	ASPTKkbJ1ILi3PTcZMMCw7zUcr3ixNzi0rx0veT83E2M4HDX0tjBeG/+P71DjEwcjIcYJTiY
	lUR4nablpQnxpiRWVqUW5ccXleakFh9ilOZgURLnNZwxO0VIID2xJDU7NbUgtQgmy8TBKdXA
	pCcoLL84dNKb73G1S5+zlFw80FjZfM9V5sMvBUmWHd+ySlWX1xX8W7bjUdOXLB9njRAXWwWX
	HLnV7s5T1n44envLo8oVzZ+dpy17KthTcL//h2W0xvMfx/ts1aLXCR/cKuh49VJ7hmZ3yQHj
	L+XBnzeKWLWl/wl5K2av3Cd5+svzNu9pNUfdJbcc3iL4+fBEW6kbH//GzlhtsPaCy+HPx+c6
	ruQ8kNDfoDH7+zbbjU3KzJW1hdfVnq+Isnku1HHcsPNzzfqMJN6QC3tD/3XVrXubX1906v+5
	86+PVb0+IXx3b+uBJx3Ja44pdntKTeA5I3Xypp43b2ealm+Mp+PEFMHuh3ts9wg6XeKZV62X
	pcRSnJFoqMVcVJwIADWE0z7mAgAA
X-CMS-MailID: 20240617031218epcas5p4f706f53094ed8650a2b59b2006120956
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240617031218epcas5p4f706f53094ed8650a2b59b2006120956
References: <1233b470-c190-4b8f-873d-dfbf31b6874d@gmail.com>
	<CGME20240617031218epcas5p4f706f53094ed8650a2b59b2006120956@epcas5p4.samsung.com>

On Sun, 16 Jun 2024 19:04:38 +0100, Pavel Begunkov wrote:
> On 5/14/24 08:54, Chenliang Li wrote:
>> Introduce helper functions to check whether a buffer can
>> be coalesced or not, and gather folio data for later use.
>> 
>> The coalescing optimizes time and space consumption caused
>> by mapping and storing multi-hugepage fixed buffers.
>> 
>> A coalescable multi-hugepage buffer should fully cover its folios
>> (except potentially the first and last one), and these folios should
>> have the same size. These requirements are for easier later process,
>> also we need same size'd chunks in io_import_fixed for fast iov_iter
>> adjust.
>> 
>> Signed-off-by: Chenliang Li <cliang01.li@samsung.com>
>> ---
>>   io_uring/rsrc.c | 78 +++++++++++++++++++++++++++++++++++++++++++++++++
>>   io_uring/rsrc.h | 10 +++++++
>>   2 files changed, 88 insertions(+)
>> 
>> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
>> index 65417c9553b1..d08224c0c5b0 100644
>> --- a/io_uring/rsrc.c
>> +++ b/io_uring/rsrc.c
>> @@ -871,6 +871,84 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
>>   	return ret;
>>   }
>>   
>> +static bool __io_sqe_buffer_try_coalesce(struct page **pages, int nr_pages,
>> +					 struct io_imu_folio_data *data)
> io_can_coalesce_buffer(), you're not actually trying to
> do it here.

Will change it.

>> +static bool io_sqe_buffer_try_coalesce(struct page **pages, int nr_pages,
>> +				       struct io_imu_folio_data *data)
>> +{
>> +	int i, j;
>> +
>> +	if (nr_pages <= 1 ||
>> +		!__io_sqe_buffer_try_coalesce(pages, nr_pages, data))
>> +		return false;
>> +
>> +	/*
>> +	 * The pages are bound to the folio, it doesn't
>> +	 * actually unpin them but drops all but one reference,
>> +	 * which is usually put down by io_buffer_unmap().
>> +	 * Note, needs a better helper.
>> +	 */
>> +	if (data->nr_pages_head > 1)
>> +		unpin_user_pages(&pages[1], data->nr_pages_head - 1);
> Should be pages[0]. page[1] can be in another folio, and even
> though data->nr_pages_head > 1 protects against touching it,
> it's still flimsy.

But here it is unpinning the tail pages inside those coalesceable folios,
I think we only unpin pages[0] when failure, am I right? And in
__io_sqe_buffer_try_coalesce we have ensured that pages[1:nr_head_pages] are
in same folio and contiguous.

>> +
>> +	j = data->nr_pages_head;
>> +	nr_pages -= data->nr_pages_head;
>> +	for (i = 1; i < data->nr_folios; i++) {
>> +		unsigned int nr_unpin;
>> +
>> +		nr_unpin = min_t(unsigned int, nr_pages - 1,
>> +					data->nr_pages_mid - 1);
>> +		if (nr_unpin == 0)
>> +			break;
>> +		unpin_user_pages(&pages[j+1], nr_unpin);
> same
>> +		j += data->nr_pages_mid;
> And instead of duplicating this voodoo iteration later,
> please just assemble a new compacted ->nr_folios sized
> page array.

Indeed, a new page array would make things a lot easier.
If alloc overhead is not a concern here, then yeah I'll change it.

Thanks,
Chenliang Li

