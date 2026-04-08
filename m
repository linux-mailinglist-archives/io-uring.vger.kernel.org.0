Return-Path: <io-uring+bounces-12978-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CHw5HzgT1mngAwgAu9opvQ
	(envelope-from <io-uring+bounces-12978-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 10:35:04 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 221093B91E9
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 10:35:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 083883009881
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2026 08:35:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 440F73A6B9B;
	Wed,  8 Apr 2026 08:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dFm4+muh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4363A6B6A
	for <io-uring@vger.kernel.org>; Wed,  8 Apr 2026 08:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775637301; cv=none; b=MFVn/7s7M8Uk0vWThoCcJuv477Kk/HBAkNn6aqha9UZnDoi7iQXOflvxbkQ0Oncr1YCJDzlBDfcsFRnN4Ik/cLHIpOnHP0HBZeuGVi2AXLxbChKI/SRR3hjGVAj6mTh9jKfui5tOcRxvFb+WInnLmM18Qntoi20s+FTR19TZgOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775637301; c=relaxed/simple;
	bh=Yv9rp1wgQY/Ainn0b6NPeknaayPrGIJ+iW91Cs0GLmM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I6LW+hu2Mp9Msf/rSnhfqAWY639QF4GJ4VK5+DWERTPziJGcn5a56jkVHTt23hJLvkpkLZjqCQSnXDdKyoYYYITdT7P9HD8iBqWxSKH1Pe0AWABrbETNqTh1hdO8VUEHml+LEJj5Q8O9lmAbWGFR7O9xL/Uzac7upOABU730mXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dFm4+muh; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4887eca00c4so40053415e9.2
        for <io-uring@vger.kernel.org>; Wed, 08 Apr 2026 01:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775637298; x=1776242098; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CQaeOFXbxNsQ6d5NOWsIIq7eCw+qyUnj2mDKEGGArjM=;
        b=dFm4+muhY1VOt4KhNS/fpE6DxxIAiZmKWKsbfOUKFcQu+QN5tpQVIx/knA6AVLNlka
         9eHJ1XcKmaI2HLjwsWjSCydCdv6I/cX2Nu/gq/Zqa1P8NXmZYcB4JHAO8lEjoLd20K7F
         +pGQ3BNA8QLQzXQ/FKWCWwGljV6JBrIaQ7A2UmXb57sLD8PO1h1Dqf0hlrOEie/im4As
         7gQTNafumAD6d+bGeBBdsx1TAsmfdYwIzJGJWgmhEM2x0rRsc9g5lElgbVfOOVkt8qIX
         xACWKhAg7msuQUDUNWDhEKyzCs6gUppyeD+OJfUI602Qw46LmTb7BlwJgHI45S5AIAXs
         iwlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775637298; x=1776242098;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CQaeOFXbxNsQ6d5NOWsIIq7eCw+qyUnj2mDKEGGArjM=;
        b=crUCn5lpGcLmzizqQ4mZSoof+oJdmOQgkSoD/fvXC/GKM20wnBAHcb+hi1fZKYuru1
         xKSsmhRwb5kMR/KA2F7lYJNjPXtWV8q0qSzecLAL44vYwg8CSBHorAXjUqP6jTSCgFHb
         v4IPQXKbkTQ8MWe30aZGTRzCJ0pfChOeJ6gHmzW8T6kZBPBHYGFMZxhstks/ubDE+hJw
         pS2O+mR9S9KW+orME35y2Pt2y00ehep06cNCKxANmRRF56NCP5l0ljwQQQzNBkqcYWio
         DqcsHiSM06tiQg6RAaiQRsLHZ8F+nOHKHem+kDh+snGOQDNiW1i6jTgtG5SASN9YLPGl
         PFlQ==
X-Forwarded-Encrypted: i=1; AJvYcCXM2/jVb1U6jUVZ9Vtzfi+8f3Q6oqnHOEKC6BtBkvB9nMxW1lZ9z41UnGfgo5sGg5X0hWZXX5DV+g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6hvBJlUr6HXxMGO3mE4K9Qt4PHDz9SpFqZet8yiDev/XAr90S
	4KfKP/74SR91EYbwTumRew4o+hOZZNlXrGN0aAFI+JbSSxWtm0tTDhhV
X-Gm-Gg: AeBDieul78GhhlUutQRgBJCYoDXGPFahzmza/hN0zC5NfMFNedjhFCwfuBlVHb9Y8xt
	mhSVrKC6LTauNdpLhN2wbwuQxo2YIF/zzIxfEDQ+IpQpKXW+twV0lYtJOh3pxmlkxJwSLCiX6R1
	FVH51zVbUnYtk7/iiRREKRl3a1xJMh5tqhgIqsILRGTCG8AV7MGKrueS0IAE/CjSrfmUTYb/J7F
	POZtgCG2kfhp/vBLdYrnTarVAOS2TyNJmIYrRAPhrRre6Z/4OqDDsD9GvaTwTs42Jh/R+lCh5PA
	COD3b65VdwdnDGvtaeiZkNozMUpij0gqK2Yz+i1s+wqR9iilYEpa6MHip66ga3rHMY+Wv4iv/0/
	2T5mMgwQNQSIjCOFjjpzB28ZdDuwQ2QAt+mFoxaaA53K6WEqc9OBO49wgsCEmplFoa+9i7S7GXZ
	bfOwi4lLNb/5TFo9E6x8FYM+bvviWqQ/myi/GWopMYXeAECfitPRjW6oAPqTImZTcGLcfjC5V42
	9mTIWaN+CLo3255uRz8zp04EAV9xDr2wYsLlgGMHQmJhbTLmWrIqfXlSaw=
X-Received: by 2002:a05:600c:1f96:b0:487:4eb:d125 with SMTP id 5b1f17b1804b1-48899753e5fmr279347815e9.9.1775637297978;
        Wed, 08 Apr 2026 01:34:57 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:eaba])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488c1c5291esm150797065e9.15.2026.04.08.01.34.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2026 01:34:56 -0700 (PDT)
Message-ID: <336062ec-5fcd-46ad-a839-6ddbff7f9fb9@gmail.com>
Date: Wed, 8 Apr 2026 09:34:59 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] io_uring: fix pinned pages and pages array leak in
 io_region_pin_pages()
To: KobaK <kobak@nvidia.com>, Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <kbusch@kernel.org>, Ming Lei <ming.lei@redhat.com>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260408065408.2017967-1-kobak@nvidia.com>
 <20260408065408.2017967-2-kobak@nvidia.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260408065408.2017967-2-kobak@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12978-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,nvidia.com:email]
X-Rspamd-Queue-Id: 221093B91E9
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 4/8/26 07:54, KobaK wrote:
> From: Koba Ko <kobak@nvidia.com>
> 
> When io_pin_pages() succeeds but the subsequent nr_pages sanity check
> fires (WARN_ON_ONCE), the function returns -EFAULT without unpinning the
> user pages or freeing the kvmalloc'd pages array. The caller's cleanup
> via io_free_region() won't help either, because mr->pages was never
> assigned — so the entire cleanup block is skipped.
> 
> Add unpin_user_pages() and kvfree() before the error return to prevent
> the leak.
> 
> Fixes: a90558b36ccee ("io_uring/memmap: helper for pinning region pages")
> Signed-off-by: Koba Ko <kobak@nvidia.com>

It's a WARN path, it should never happen, but if it does, that means
io_pin_pages() is buggy, and it's better to leak rather than risk
something nastier.

> ---
>   io_uring/memmap.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/io_uring/memmap.c b/io_uring/memmap.c
> index e6958968975a8..9f0d3750ce3bc 100644
> --- a/io_uring/memmap.c
> +++ b/io_uring/memmap.c
> @@ -141,8 +141,11 @@ static int io_region_pin_pages(struct io_mapped_region *mr,
>   	pages = io_pin_pages(reg->user_addr, size, &nr_pages);
>   	if (IS_ERR(pages))
>   		return PTR_ERR(pages);
> -	if (WARN_ON_ONCE(nr_pages != mr->nr_pages))
> +	if (WARN_ON_ONCE(nr_pages != mr->nr_pages)) {
> +		unpin_user_pages(pages, nr_pages);
> +		kvfree(pages);
>   		return -EFAULT;
> +	}
>   
>   	mr->pages = pages;
>   	mr->flags |= IO_REGION_F_USER_PROVIDED;

-- 
Pavel Begunkov


