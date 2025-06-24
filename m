Return-Path: <io-uring+bounces-8472-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8EBAAE6547
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 14:42:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 73B764C005E
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 12:42:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 154DC291C01;
	Tue, 24 Jun 2025 12:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WlgRsVsn"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AED5222571
	for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 12:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750768968; cv=none; b=em+i8MDbLD0WGnC2jxJOG9JxGxgcZTPXfvgQF+R+CxvD0Ed3Ndl2RJPwcZJaol6ETA9CsVtlJJRyjmPTBfyi2PHXcYxOAbdZecWhCNVbiH3bCh9JvaMhNWsx671Is2fQYMCRYpgQcUAh+bLJKd1FoGFzSwRn3h3eBXV/tvl2ejg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750768968; c=relaxed/simple;
	bh=AU94SolidIhbQn3JssXHF5h+AudhsGepO8zuHXuX+jI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=MBH1ULxvD3TLD7ve1r4AZlt/Xu0UTaZT+2NQs6a2+jXLTdlHR/SF3wISA29km4jNWjyiu3OQEEMWdMhZsHFWBBtIo01cPJyR13oRoTI2A7X5VK8N7kHeG76/IkSd6qfdId4dmlcaLOR3338XnWNOfg+F1TQUzqiaiqZgdXwf+Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WlgRsVsn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750768965;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/V+1Ukzfu7QBOF9YMHl6ZoKuy1zO+CeWPXbenzzC88s=;
	b=WlgRsVsnekbHpZi+VzXsAaoW3clFkO00ZEHe9h/0qlssgh6Lub3G8zqopgI16TD1uovAef
	uKVfRsvt8DEDY8VLM8I0mgNOqcLf9tr8wsLCeIXDUdzwdn91fROBAYieCfCickf4rG6iWQ
	+e0Nhjp01TmnXgVN2SF0MKxUpvAwf/k=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-689-rJv1EY5BN_2bvj9KQyheMA-1; Tue, 24 Jun 2025 08:42:43 -0400
X-MC-Unique: rJv1EY5BN_2bvj9KQyheMA-1
X-Mimecast-MFC-AGG-ID: rJv1EY5BN_2bvj9KQyheMA_1750768963
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a50049f8eeso236625f8f.3
        for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 05:42:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750768963; x=1751373763;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/V+1Ukzfu7QBOF9YMHl6ZoKuy1zO+CeWPXbenzzC88s=;
        b=dK5SufaEFQjPjgWteD/fzAw7E2q+de4ZuWOyzp6fYqOjsCDcLAXdC8+2clKjs1ad4a
         FvTcuWu3X8WBWMT0EeZjK9qX0RPuHfyzOgZzfNRr2IwlaROCkde/RYUu8HjLspEyxw6G
         iTfWuk/Rrp3NyFhlp+dhEokp8yuRQilw3ecr1oxkx4pxgOE6S2D2obI/8d2Ju125godX
         XLM/7etuwhDvqd/WSFuXlp9P8mESI9o8HIQld8T/5SrGOfpvX/AI3ukHV8iGP6iqK4+f
         ktiD35Ewxpm5FR3vjyHYjGmL6zdcj+v9j3BRWYtEZb9lvK1xGly+cIHcSPkP2/gBxQkj
         pgcQ==
X-Forwarded-Encrypted: i=1; AJvYcCXBAga7nBsnSyZLoCJTXMHDOZKaOqnae/qwASSPNr6kYvDD5ZeXFWJlJnB5SMPGg3c1jfDyjrCtjg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+m5LB70F4lHHgLxllSR7bPiflKTLpfjLe7h1LY5DLVgX+2Axs
	M3dDG+DZwujQjUsTBTChy7Nu4qVj8b0SmsUpd7HQLykSEB0FGSnvH+gbdH3n6Z0qss3oXqOcn6G
	DEy4MYv0x327TtcBg7vYVQt0KSSp6fLpyMCA3lNP95K40i8vbJX9ecris97+QV3xmIL0D9L8=
X-Gm-Gg: ASbGncu4ApRdR2v373ITUi8DEFSglOGhGW5UIKxTLdJ0MFueS2syqNnfxhQ8FXNj+9k
	BHJtZgoteTV3+sxUCgsYQ5DEhtH9r4bkwosauKQ77+v2oB5PID3C6vTyse9NVDXY98uOn0k6BkL
	TedHICnT2aMkuIjrgKxl4oVgm25nJy8vkh64//QNRk008GkFUtd5t3tof5S0oRZk+4Oy1KtJgwp
	73fTMH5cI1BTbe15/GFql30IvqSPrVoCxH0rAp8K5MmebZUP9uzq+WKkIps5A1f30N0w4LOG/pJ
	+yp6Ku81P6X6o5Hc/FCKdG9e6Nxw5gfuzIq7MiX+2oP3APJDdiP7PZE=
X-Received: by 2002:a05:6000:18a8:b0:391:3aaf:1d5f with SMTP id ffacd0b85a97d-3a6d12eb61amr15288043f8f.52.1750768962640;
        Tue, 24 Jun 2025 05:42:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFgV1SXn9n0UzZKx5CrhzvqcOax2e15W4SX4yceLCxLsRem0L0XHvJmSZDm3rqYvRzrOQrUIQ==
X-Received: by 2002:a05:6000:18a8:b0:391:3aaf:1d5f with SMTP id ffacd0b85a97d-3a6d12eb61amr15288010f8f.52.1750768962247;
        Tue, 24 Jun 2025 05:42:42 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6e8064c61sm1927446f8f.36.2025.06.24.05.42.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jun 2025 05:42:40 -0700 (PDT)
Message-ID: <8d33d9b2-d0c5-4c71-8381-c70a0a4bb712@redhat.com>
Date: Tue, 24 Jun 2025 14:42:39 +0200
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

Note: pointer arithmetic on "struct page" does not work reliably for 
very large folios (eg., 1 GiB hugetlb) in all configs 
(!CONFIG_SPARSEMEM_VMEMMAP)

I assume this can be

data->first_page_offset = folio_page_idx(folio, page_array[0]);


> +	data->first_page_offset <<= PAGE_SHIFT;
>   
>   	/*
>   	 * Check if pages are contiguous inside a folio, and all folios have
> @@ -830,7 +832,11 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
>   	if (coalesced)
>   		imu->folio_shift = data.folio_shift;
>   	refcount_set(&imu->refs, 1);
> -	off = (unsigned long) iov->iov_base & ((1UL << imu->folio_shift) - 1);
> +
> +	off = (unsigned long)iov->iov_base & ~PAGE_MASK;
> +	if (coalesced)
> +		off += data.first_page_offset;
> +
>   	node->buf = imu;
>   	ret = 0;
>   
> diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
> index 0d2138f16322..d823554a8817 100644
> --- a/io_uring/rsrc.h
> +++ b/io_uring/rsrc.h
> @@ -49,6 +49,7 @@ struct io_imu_folio_data {
>   	unsigned int	nr_pages_mid;
>   	unsigned int	folio_shift;
>   	unsigned int	nr_folios;
> +	unsigned long	first_page_offset;

Heh, is it actually "first_folio_offset" ?

Alternatively, call it "first_folio_page_idx" or sth like that and leave 
the shift to the user.

-- 
Cheers,

David / dhildenb


