Return-Path: <io-uring+bounces-8465-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 13209AE63E8
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 13:53:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E7D8E7A974D
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 11:51:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A920921A42F;
	Tue, 24 Jun 2025 11:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jNUcvvpX"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E9A28C864
	for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 11:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750765990; cv=none; b=FKVJvjake6g3seIAi0u9pGrO9CHuIYIHF4CZzGSzrQ8a4a2GaFK2YJbWtJ7BiyrfJgEXQ+arLPU0xaL49Zl/c9TtOPBQESNw/3P/XIgM8hkmYUHDp2zE8owgvB5lzAxo+gMnvxXf06K8L4C424sTQ3U1M1SpNPGYIR0fyDJooVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750765990; c=relaxed/simple;
	bh=k4QTziNw/yLw2IGFn9Oi9LcO/6OT0NHW/Ee7DABG6oM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Q8NQlwr3aflyXCirAupTzFC9Ly28ymD5eLvCF1sMKOIActVXorLHEBE8tMf4zLAd7IqIKUec86eNuhY5psfZ9FUoiEr7hCbzzuNZdCo3fpXFQEzlZSJvQydsiZcvxeFkTUmI2vhkhX5yq/+eQs5SFFMv0Ip4ohj92wJUuxrtxH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jNUcvvpX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750765987;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4fHIO/pCpcv4cnf0qkZ0isdrYJvWHg9BVm6xplAgUCw=;
	b=jNUcvvpXtrVZM+Yc+qoguLqcbdaKWqZ+q8iOfVeAsOBGmuLZg9oq9oI84O3WoumxmXKBvi
	M+MZsUyeJIEu9xuj8FK1qZbQX5e0K1nAV2yFWiP8769A+W4sYUak8PyHqNBIZogEL5DM9H
	8OvUQxXdE5nYjK6ay9ciGyCSCobDfPQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-304-RYy-mn1lPJalq5ZcgwL5nQ-1; Tue, 24 Jun 2025 07:53:06 -0400
X-MC-Unique: RYy-mn1lPJalq5ZcgwL5nQ-1
X-Mimecast-MFC-AGG-ID: RYy-mn1lPJalq5ZcgwL5nQ_1750765985
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a4f858bc5eso3042113f8f.0
        for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 04:53:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750765985; x=1751370785;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4fHIO/pCpcv4cnf0qkZ0isdrYJvWHg9BVm6xplAgUCw=;
        b=fnkqKo9oRyfWROaaQ1uq+tnNhldl79PPQj+JRK0DAAmB73vw0sv1pXBd6UZ3DiFxdv
         n0PQlMRH9jlX+BJsC8pJky2ynX9gSEJ/+CAXM2mdcD06I+4RvhFleO336S3mqYsYKvLT
         JEg4OWerl6JvhVUdjtpQBImJnY3LY5TkjB36FXX+G4m/Zm6wlodlthajhTzVK6eji+ZW
         6bA0nW+b+9PEsUYLiIRo0bjKMnC3tvKu4Ewuy9NdgfN31QpgpBnuix9WL0gc55DIjDwT
         zcRC7XrDeGgB0YPHua4HU/GRAt0MBnm00geZaErwjMcxSQcT83ycWTlSCtj4TPN9KStP
         /5xw==
X-Forwarded-Encrypted: i=1; AJvYcCX0R9JEojY0rbvawWRj4j7cEtheX3+bVAo5fDm4dWWHqvVNAYGxaJ6fbQ6/lq2lBOFnKdmObhdvpw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0hpLaLisfIuJutir1MCsOJm9UhVmVYXkWX+QIjevKMW28I1Ei
	9nZ7v2pyZ/mxmLZtQGArqr8WR4dphhRBZXzNY62BjFw/YlUloS43p67cZ8/4PGevoKLmjuHuBqg
	GYTMzv+ErwgXmKUEAKBgCEMmMyONZXlv9eA3DERi4dqQhYgMHuLorxy20Uyli/JrCh8kBa3g=
X-Gm-Gg: ASbGncsuk3SYx2k3NL3z/xjNKPYMHfKEGBk5iZK/kcY0SZ2SQmy//6n5SNgAfCi5DEu
	zhvZF1N7NNC+qpjz6P/m146TXr7cTDsM070Khe4IFJ4nAq1EJ68X57dYfMZBSAgytwPJjV1k1/F
	GZ8ix9fPTddKa8HpOgZMpyIl7tyhLrYHb/s8z9P7Vb9yavJdmH0tWhPByrz3h0/np66rLL+rn19
	j7Ve9sC8pfHh2EviRaXeGemASCg6S1pxUocmSjWzeAOjqfE9Ym65v1q2q0Mf4PTum0CQ5a7ZobY
	Tyl5b5zZhZG7TKl1fhbg9WFGXKa94rs41tZzWCAUGpQC9wa2oQpVtW0=
X-Received: by 2002:adf:9dd1:0:b0:3a4:f655:8c4d with SMTP id ffacd0b85a97d-3a6d131787bmr11516680f8f.27.1750765985041;
        Tue, 24 Jun 2025 04:53:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFMunSMQCPebSHjk6E16xbcHpI4NVeq1bdixSul+GCXMHPQzMKERKienasLSIDnN5UveE/Rcw==
X-Received: by 2002:adf:9dd1:0:b0:3a4:f655:8c4d with SMTP id ffacd0b85a97d-3a6d131787bmr11516661f8f.27.1750765984645;
        Tue, 24 Jun 2025 04:53:04 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6e81105f0sm1797112f8f.90.2025.06.24.04.53.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jun 2025 04:53:04 -0700 (PDT)
Message-ID: <e013216a-c0bb-4ea9-84ee-d3771beaa733@redhat.com>
Date: Tue, 24 Jun 2025 13:53:03 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/3] io_uring/rsrc: don't rely on user vaddr alignment
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1750760501.git.asml.silence@gmail.com>
 <6a34d1600f48ece651ac7f240cb81166670da23d.1750760501.git.asml.silence@gmail.com>
Content-Language: en-US
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <6a34d1600f48ece651ac7f240cb81166670da23d.1750760501.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24.06.25 12:35, Pavel Begunkov wrote:
> There is no guaranteed alignment for user pointers, however the
> calculation of an offset of the first page into a folio after
> coalescing uses some weird bit mask logic, get rid of it.
> 
> Cc: stable@vger.kernel.org
> Reported-by: David Hildenbrand <david@redhat.com>
> Fixes: a8edbb424b139 ("io_uring/rsrc: enable multi-hugepage buffer coalescing")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   io_uring/rsrc.c | 8 +++++++-
>   io_uring/rsrc.h | 1 +
>   2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index e83a294c718b..5132f8df600f 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -734,6 +734,8 @@ bool io_check_coalesce_buffer(struct page **page_array, int nr_pages,
>   
>   	data->nr_pages_mid = folio_nr_pages(folio);
>   	data->folio_shift = folio_shift(folio);
> +	data->first_page_offset = page_array[0] - compound_head(page_array[0]);
> +	data->first_page_offset <<= PAGE_SHIFT;

Would that also cover when we have something like

nr_pages = 4
pages[0] = folio_page(folio, 1);
pages[1] = folio_page(folio, 2);
pages[2] = folio_page(folio2, 1);
pages[3] = folio_page(folio2, 2);

Note that we can create all kinds of crazy partially-mapped THP layouts 
using VMAs.

-- 
Cheers,

David / dhildenb


