Return-Path: <io-uring+bounces-2237-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE69A90AE19
	for <lists+io-uring@lfdr.de>; Mon, 17 Jun 2024 14:39:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BB22A1C230D5
	for <lists+io-uring@lfdr.de>; Mon, 17 Jun 2024 12:39:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58087195F34;
	Mon, 17 Jun 2024 12:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j6+/14ln"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747B2195F20
	for <io-uring@vger.kernel.org>; Mon, 17 Jun 2024 12:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718627941; cv=none; b=Rcn1bIHXW5HkO+a1bdOhqx+D0fTIqTPmzFmotebwMk/3DfXxl1M0JtYjHk8upJmkdXSJCk3IeIcDXuEjaQBEEnhJ8M2aS9KocDGF2iYWOFhLeP3rFtHchHH5TW1tEKLpZImBdyO4ddIeoPeHXtyVe3WJSCz6wxU6WjenGET4cxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718627941; c=relaxed/simple;
	bh=abFkrrRC7LdI/xseTvhdTtfn9BEgsxvgGEwIVl6b+dc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kIZMcKwDq0wV/G10WvP45j9QggQStmKagM1FUE4vPEEvwz9yDQBB9tFyS+UWgTyzlOI6xYM+g+y30d6UXCqFil0QkUxq7l5dKYdzsQBiXadaEe8aU6eTiQ+XNSUsqOQrPF+GDhuI578eNzLE7OcjyM8jhgg9MQw8Ozdz5FcPYzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j6+/14ln; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-57cc1c00b97so3081205a12.0
        for <io-uring@vger.kernel.org>; Mon, 17 Jun 2024 05:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718627938; x=1719232738; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+kg/vjS07fsNZEad4dHBL7mX1wMjMivx+/qUCqiuzXY=;
        b=j6+/14lnsaUoXi4gogcWuWpGrIE+mkQlgIf1p1i/cjQrpIrPHl2ASccabczUjd+XVT
         y5fbYog6y2/VLHAvO2t4i5kz/pV5thG2dncPEz6Zn9ghZbAnDzwAWQfredmvXybJUXXP
         8u/XLAuZY7o6NYTQSKAtlUA9+pAtdU4IxaQKrsh8dfY+l1pEiXV/Q4HPvp/YsjbyzAo2
         WpG1Hh/GgO8fFGD1nnOBnqtD+QKLsI5Pjikc636efuEEXFZ2JEKVe70G9sSFVsjruXKr
         /ktQV2e+Osl79bJZre0vYEckm9aZ+9tGBMVNQVnQIMYaGEYEaPaXfnyTUt9Xmjv8cjWt
         cqxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718627938; x=1719232738;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+kg/vjS07fsNZEad4dHBL7mX1wMjMivx+/qUCqiuzXY=;
        b=Hdco3jqUusIT9OfH+0+vbLhDZ5vMJv14ABtUbWGPkIPD46UIJ2p35npBIncjGhxRR/
         79XozIcGhxuk6j0ULMMvht7xrdhQqrnGcdlkX/dFvPJmwIyRuGq8qYL59Hi5zr8nyd9c
         pag227R2eN0IoIql0pYjGnGfrGJfh3K4UdGHhB3MU5UMbCi8r7BHT9ZBdn7cplERg/vV
         I0c5DIHIagmtVjpwFiOohTHDVeXZBzb2rrKFI4eTY0vkSAoP/84ZDyj5T8pRHlA4pERd
         eSld9OPW+DS+UoU2NSSbBolBqzZRaCgMnqriBmZl7lhog6Qlez6QWiCb0wPlkqMvQo61
         Ue4w==
X-Forwarded-Encrypted: i=1; AJvYcCWw3qObMj+pxfJr80jwEbgLoLM0ZQKEp2/6VMubd5nklA8yyOkjvUu16H4oR7G5cG5aYVvx/bVP5xLk4pEo7qIEYS3Y/BxADHI=
X-Gm-Message-State: AOJu0YxRNy0N0oVBl9dps4krZ888J5Q2VjgZFuBWFy+eYBELcMfBRJOS
	eOrvy+yfBuvLaajlqBjN29N1SGOK8sbSEY+j+nRmwDBexsgqiSjO
X-Google-Smtp-Source: AGHT+IFWD2b3dCob0VMO8bSbfWZpDrmhoyrVqriQJIXSInzOJlutudrJydoxBI2tcqWBiF5dL//mbQ==
X-Received: by 2002:a50:d594:0:b0:57c:7dee:52e4 with SMTP id 4fb4d7f45d1cf-57cbd67f878mr5586886a12.25.1718627937437;
        Mon, 17 Jun 2024 05:38:57 -0700 (PDT)
Received: from [192.168.42.82] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57ccc173673sm3695789a12.44.2024.06.17.05.38.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jun 2024 05:38:57 -0700 (PDT)
Message-ID: <9021b668-cb6d-4077-a470-70c5984e46e5@gmail.com>
Date: Mon, 17 Jun 2024 13:38:59 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] io_uring/rsrc: coalescing multi-hugepage
 registered buffers
To: Chenliang Li <cliang01.li@samsung.com>
Cc: anuj20.g@samsung.com, axboe@kernel.dk, gost.dev@samsung.com,
 io-uring@vger.kernel.org, joshi.k@samsung.com, kundan.kumar@samsung.com,
 peiwei.li@samsung.com
References: <1233b470-c190-4b8f-873d-dfbf31b6874d@gmail.com>
 <CGME20240617031218epcas5p4f706f53094ed8650a2b59b2006120956@epcas5p4.samsung.com>
 <20240617031210.2325-1-cliang01.li@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240617031210.2325-1-cliang01.li@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/17/24 04:12, Chenliang Li wrote:
> On Sun, 16 Jun 2024 19:04:38 +0100, Pavel Begunkov wrote:
>> On 5/14/24 08:54, Chenliang Li wrote:
>>> Introduce helper functions to check whether a buffer can
>>> be coalesced or not, and gather folio data for later use.
>>>
>>> The coalescing optimizes time and space consumption caused
>>> by mapping and storing multi-hugepage fixed buffers.
>>>
>>> A coalescable multi-hugepage buffer should fully cover its folios
>>> (except potentially the first and last one), and these folios should
>>> have the same size. These requirements are for easier later process,
>>> also we need same size'd chunks in io_import_fixed for fast iov_iter
>>> adjust.
>>>
>>> Signed-off-by: Chenliang Li <cliang01.li@samsung.com>
>>> ---
>>>    io_uring/rsrc.c | 78 +++++++++++++++++++++++++++++++++++++++++++++++++
>>>    io_uring/rsrc.h | 10 +++++++
>>>    2 files changed, 88 insertions(+)
>>>
>>> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
>>> index 65417c9553b1..d08224c0c5b0 100644
>>> --- a/io_uring/rsrc.c
>>> +++ b/io_uring/rsrc.c
>>> @@ -871,6 +871,84 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
>>>    	return ret;
>>>    }
>>>    
>>> +static bool __io_sqe_buffer_try_coalesce(struct page **pages, int nr_pages,
>>> +					 struct io_imu_folio_data *data)
>> io_can_coalesce_buffer(), you're not actually trying to
>> do it here.
> 
> Will change it.
> 
>>> +static bool io_sqe_buffer_try_coalesce(struct page **pages, int nr_pages,
>>> +				       struct io_imu_folio_data *data)
>>> +{
>>> +	int i, j;
>>> +
>>> +	if (nr_pages <= 1 ||
>>> +		!__io_sqe_buffer_try_coalesce(pages, nr_pages, data))
>>> +		return false;
>>> +
>>> +	/*
>>> +	 * The pages are bound to the folio, it doesn't
>>> +	 * actually unpin them but drops all but one reference,
>>> +	 * which is usually put down by io_buffer_unmap().
>>> +	 * Note, needs a better helper.
>>> +	 */
>>> +	if (data->nr_pages_head > 1)
>>> +		unpin_user_pages(&pages[1], data->nr_pages_head - 1);
>> Should be pages[0]. page[1] can be in another folio, and even
>> though data->nr_pages_head > 1 protects against touching it,
>> it's still flimsy.
> 
> But here it is unpinning the tail pages inside those coalesceable folios,
> I think we only unpin pages[0] when failure, am I right? And in
> __io_sqe_buffer_try_coalesce we have ensured that pages[1:nr_head_pages] are
> in same folio and contiguous.

We want the entire folio to still be pinned, but don't want to
leave just one reference and not care down the line how many
refcounts / etc. you have to put down.

void unpin_user_page(struct page *page)
{
	sanity_check_pinned_pages(&page, 1);
	gup_put_folio(page_folio(page), 1, FOLL_PIN);
}

And all that goes to the folio as a single object, so doesn't
really matter which page you pass. Anyway, let's then leave it
as is then, I wish there would be unpin_folio_nr(), but there
is unpin_user_page_range_dirty_lock() resembling it.

>>> +
>>> +	j = data->nr_pages_head;
>>> +	nr_pages -= data->nr_pages_head;
>>> +	for (i = 1; i < data->nr_folios; i++) {
>>> +		unsigned int nr_unpin;
>>> +
>>> +		nr_unpin = min_t(unsigned int, nr_pages - 1,
>>> +					data->nr_pages_mid - 1);
>>> +		if (nr_unpin == 0)
>>> +			break;
>>> +		unpin_user_pages(&pages[j+1], nr_unpin);
>> same
>>> +		j += data->nr_pages_mid;
>> And instead of duplicating this voodoo iteration later,
>> please just assemble a new compacted ->nr_folios sized
>> page array.
> 
> Indeed, a new page array would make things a lot easier.
> If alloc overhead is not a concern here, then yeah I'll change it.

It's not, and the upside is reducing memory footprint,
which would be noticeable with huge pages. It's also
kvmalloc'ed, so compacting also improves the TLB situation.

-- 
Pavel Begunkov

