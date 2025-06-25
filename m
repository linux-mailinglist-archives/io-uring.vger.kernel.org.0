Return-Path: <io-uring+bounces-8482-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 18ACAAE791A
	for <lists+io-uring@lfdr.de>; Wed, 25 Jun 2025 09:54:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BCD523BE9FA
	for <lists+io-uring@lfdr.de>; Wed, 25 Jun 2025 07:53:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24370204098;
	Wed, 25 Jun 2025 07:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ASJzTIKU"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D733522083
	for <io-uring@vger.kernel.org>; Wed, 25 Jun 2025 07:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750838044; cv=none; b=oZRnxqxIv8qe4pymEjjUprS9XogM9HcyGAub1zdR+Z7EDYlToDiukoy4tPeFWX6EroZEYmCDA9BcTNiMPMiyI9LVvC1PXZ3lJOt3qJJ5KrBDokqoudLVSy2LRxa5bdClIJrpglRYQtrPmHzgnx8x7hczHf6aBgU/xHedliKvHZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750838044; c=relaxed/simple;
	bh=n0Rp6T33SKBTL2MyT948eHeduwGD8vwh3ioXDQv4EhI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=dOyB8rYslvK1UKv/Yegvkpbubog6iizwnv3LjA+H3u6O9GbmJr/sYL8+iHo/UHjwP29rTQDodWy6tB3rjySS2kPrsoFlsmJhXYfGesXRfjyX4KzjP87AijNCwuU+FlJMepIPBd8VHoq0udLnhLcqCnOSSbgtJqBJbQ2fGW36ZjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ASJzTIKU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750838040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7p1xU/E4QQqBy7jaT8Slen4f/hKLr4kWOVP8WDMJT9E=;
	b=ASJzTIKUVuHULOov55d9fBpuUn9QkJFTqQzr2f0LW27v0wRIJv5oWKLDDihJzo0wnNn233
	vpgqG95hjM0nqQnZoSp6CA7/b84BbVozqQa6TLpPrc9fiCxMQN39z/grzOZsMYuyJACIGu
	JC7jV/bXfRn9ic1EJiVhnNBILTPHM6o=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-500-8YMGAKMhP9amSP9sMp33wQ-1; Wed, 25 Jun 2025 03:53:59 -0400
X-MC-Unique: 8YMGAKMhP9amSP9sMp33wQ-1
X-Mimecast-MFC-AGG-ID: 8YMGAKMhP9amSP9sMp33wQ_1750838038
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a4f65a705dso3386876f8f.2
        for <io-uring@vger.kernel.org>; Wed, 25 Jun 2025 00:53:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750838038; x=1751442838;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7p1xU/E4QQqBy7jaT8Slen4f/hKLr4kWOVP8WDMJT9E=;
        b=ivgM8D7ne5Ek/AMLET7OTg45U69PyffKHwyMGkrkxi7ygx1R4b7XR4MR4ZfIUlj32i
         +4sgsQutyGamq0OWYKWMFIwpcPWPSQPx+qqoFvKkiL219K1+tBw1G1l41kkoDCWk2D+P
         jfYSEeRPWASweM+9qfvWE73a4CkGqO12twwo4g4SRgKxwGwTsMsGWwkuMbzEsIg0g1or
         kMNkXoOYl2KqD8tyK2akBABxhi5znRNCdAfSwBxjpTt+s1TeC6AClo1NIza66eFxBuKm
         0VmFU58JEaHbqru3s9GfOMtsKNK5oENmFd8Js8b5hgBrOO1lBbVIa0u3s3sZAWvKjsRr
         R0pA==
X-Forwarded-Encrypted: i=1; AJvYcCUJgTldNnni79epUnpADTTfCyUipnBg58BOnT/s7vqZbLcCC4+LKbkdnScQgrliPm32NqS0Tq1nJA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxy8Zcm8qmkYimCb7bJYwAP+bDau6c+DdL2XzjQ9FgLnjnkGUO/
	ZcPnGyL/xAcnBbgknr+iI7m5eAnMMmUprPjHb5FrkUd4AMOm8I2sA6QjIxSWH9AcZnetNB6AVcC
	+kem4gn6ci86yJlNKbciyuI5COqx3jyelwfdipOZNZXgpW3T5om1efIoynpLc3qhD1Gcg
X-Gm-Gg: ASbGncupobIHJyzC8JvLU013KqVUydOIRjXJ0WnnwvjL7ttv0rmDg6W5OiWaVeDe9ac
	dbJQgkah08QNz0kNoe7aVCUDSj8qyNJSohnxkXeDB+90zv+4HXrjM2DR9zvR5ot9UhLkeV8wlvm
	F6WWxaGEkV3Pt9i+EZMM5L/PlBqShAj1Srg3dq5L270lArlpJIkHl97Nibs9eDmsKqSVaG3nqQd
	T1EIsAUVbitSi7fj4nWJQd5340S+NexygNu6oGkhBxJD4zuZzl78MGPNRVn06Za2bA4AZgga5IV
	PUNq5aHcoUNzWR/c+QWlxp0tWxpCQIoP/1s5aiEF8syTrgizdGdCueXBFQaiKMMabyxcEgO3nyF
	O2smfXf4bI/CjKA7SdMgkTdZvvco7m49mjXplktiV1N99
X-Received: by 2002:a05:6000:25e8:b0:3a6:d7e9:4309 with SMTP id ffacd0b85a97d-3a6ed6425bdmr1130925f8f.29.1750838037582;
        Wed, 25 Jun 2025 00:53:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHycx1fOOnb1kL4RFGKuc1H2MRFPP3JDdCMRnKFRJOD1GUYXh9QKNIs46C+2rZKWmV26SMV1g==
X-Received: by 2002:a05:6000:25e8:b0:3a6:d7e9:4309 with SMTP id ffacd0b85a97d-3a6ed6425bdmr1130914f8f.29.1750838037141;
        Wed, 25 Jun 2025 00:53:57 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f12:1b00:5d6b:db26:e2b7:12? (p200300d82f121b005d6bdb26e2b70012.dip0.t-ipconnect.de. [2003:d8:2f12:1b00:5d6b:db26:e2b7:12])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-453847ec763sm3612385e9.36.2025.06.25.00.53.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Jun 2025 00:53:56 -0700 (PDT)
Message-ID: <d51f982c-f487-491e-b105-cd858f39e6e3@redhat.com>
Date: Wed, 25 Jun 2025 09:53:55 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] io_uring/rsrc: fix folio unpinning
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1750771718.git.asml.silence@gmail.com>
 <a28b0f87339ac2acf14a645dad1e95bbcbf18acd.1750771718.git.asml.silence@gmail.com>
Content-Language: en-US
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <a28b0f87339ac2acf14a645dad1e95bbcbf18acd.1750771718.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24.06.25 15:40, Pavel Begunkov wrote:
> [  108.070381][   T14] kernel BUG at mm/gup.c:71!
> [  108.070502][   T14] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
> [  108.123672][   T14] Hardware name: QEMU KVM Virtual Machine, BIOS edk2-20250221-8.fc42 02/21/2025
> [  108.127458][   T14] Workqueue: iou_exit io_ring_exit_work
> [  108.174205][   T14] Call trace:
> [  108.175649][   T14]  sanity_check_pinned_pages+0x7cc/0x7d0 (P)
> [  108.178138][   T14]  unpin_user_page+0x80/0x10c
> [  108.180189][   T14]  io_release_ubuf+0x84/0xf8
> [  108.182196][   T14]  io_free_rsrc_node+0x250/0x57c
> [  108.184345][   T14]  io_rsrc_data_free+0x148/0x298
> [  108.186493][   T14]  io_sqe_buffers_unregister+0x84/0xa0
> [  108.188991][   T14]  io_ring_ctx_free+0x48/0x480
> [  108.191057][   T14]  io_ring_exit_work+0x764/0x7d8
> [  108.193207][   T14]  process_one_work+0x7e8/0x155c
> [  108.195431][   T14]  worker_thread+0x958/0xed8
> [  108.197561][   T14]  kthread+0x5fc/0x75c
> [  108.199362][   T14]  ret_from_fork+0x10/0x20
> 
> We can pin a tail page of a folio, but then io_uring will try to unpin
> the the head page of the folio. While it should be fine in terms of
> keeping the page actually alive, but mm folks say it's wrong and
> triggers a debug warning. Use unpin_user_folio() instead of
> unpin_user_page*.
> 
> Cc: stable@vger.kernel.org
> Debugged-by: David Hildenbrand <david@redhat.com>
> Reported-by: syzbot+1d335893772467199ab6@syzkaller.appspotmail.com
> Closes: https://lkml.kernel.org/r/683f1551.050a0220.55ceb.0017.GAE@google.com
> Fixes: a8edbb424b139 ("io_uring/rsrc: enable multi-hugepage buffer coalescing")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   io_uring/rsrc.c | 10 +++++++---
>   1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index c592ceace97d..e83a294c718b 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -112,8 +112,11 @@ static void io_release_ubuf(void *priv)
>   	struct io_mapped_ubuf *imu = priv;
>   	unsigned int i;
>   
> -	for (i = 0; i < imu->nr_bvecs; i++)
> -		unpin_user_page(imu->bvec[i].bv_page);
> +	for (i = 0; i < imu->nr_bvecs; i++) {
> +		struct folio *folio = page_folio(imu->bvec[i].bv_page);
> +
> +		unpin_user_folio(folio, 1);
> +	}
>   }
>   
>   static struct io_mapped_ubuf *io_alloc_imu(struct io_ring_ctx *ctx,
> @@ -810,7 +813,8 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
>   	imu->nr_bvecs = nr_pages;
>   	ret = io_buffer_account_pin(ctx, pages, nr_pages, imu, last_hpage);
>   	if (ret) {
> -		unpin_user_pages(pages, nr_pages);
> +		for (i = 0; i < nr_pages; i++)
> +			unpin_user_folio(page_folio(pages[i]), 1);
>   		goto done;
>   	}
>   

It should fix the issue, but it's a bit suboptimal in the case where we 
didn't coalesc, but there are folio ranges to coalesc:

unpin_user_pages() does a per-folio coalescing.

So in an ideal world, we would cleanly split both paths, and work with 
folios after we coalesced to use folios, and work with pages, when we 
didn't coalesc to use folios.

Then, we can just use unpin_folios() after we coalesced.

In any case, for a fix this is good enough, but probably we can do 
better later.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


