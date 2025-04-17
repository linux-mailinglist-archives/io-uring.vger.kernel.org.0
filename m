Return-Path: <io-uring+bounces-7506-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C2073A9175D
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 11:11:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 419301906251
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 09:11:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7C10226527;
	Thu, 17 Apr 2025 09:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RL1UkUBR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C16C225A48;
	Thu, 17 Apr 2025 09:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744881066; cv=none; b=mRC2GBhy7IXk4i6caWhq5CvWpriEHmFNX4ltNh3Zj37gWDODzrZmYT9veV/cWXQns8qCDRoLZaBf65KpeV0rqqJv50dGuc4khQMSuo8Njm5BimvT0bznpUxyX8hHAF4Tqwa5XQh115nm/eENOjbQe8vyukwo/c/SEUTJzBLZlv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744881066; c=relaxed/simple;
	bh=g6qWYF9fRCguGYNnvuNycVi9fJqLV8ieZ9+PXG727ds=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=my/6BVkJV/2Z392tWn+DJvruWuGVaViTxm1SzBcGhOLpIicoB8EIaSk4DhcFXwWF3UvgtKGNmhTZERrYaq4ReOqlmH9JfupKK0s1dxYJQo9yB/9iPosj6orH2C4Yi8DmtyO/9kAmqChgkzWkVPjhCIT6MhSkxP//fc0ikI1Skyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RL1UkUBR; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-ac2bdea5a38so77998766b.0;
        Thu, 17 Apr 2025 02:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744881063; x=1745485863; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tlw8IubkA1Fytzto3zBIrK47zrZk5iptIwAZJpMwpqM=;
        b=RL1UkUBRiydApGD8JNckyMcsc1bFiT1emUVuOc2DWILBfTiARL3HJ56ar4hwAXbRSQ
         c5qizg9nKC7n59lxKmoje6NXaaLPcw04qvLFnCKlrckX5SmmSylFuCnTmasYFY0Rocs3
         6jCjQ7SYOPphegqYDdC2EyQ0BulAVNnGjnv0HZQfjzSWXv4gISQ2Wni6df12DFoNtRPW
         TLUrlRps/2/97isXVZ5itOD3u+gI50hLiqarCrKiCNp3q0pDczcZHBscg8vnHcTmW4Z8
         ohtOuvkx7wtgQ3ycgnB9F6wjuxzZuN0I9F27gj84A1tpwKO6i6qgeXZ4jXBra00uSIWu
         x1qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744881063; x=1745485863;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tlw8IubkA1Fytzto3zBIrK47zrZk5iptIwAZJpMwpqM=;
        b=bWV0Xtfr0qrNsDvCpvXXouXEGRuwjik6c44TwTX6ghs5d0gLD9yk2GlTLban68z8Rg
         ktixZWhd4eVMAq5u/b7yNugjeRoUgURopGik3+M2aOe1DaeSxQZV39DNs9ZApHqAPVcx
         1bR8OkksqeKwvKdeR6kDPG5cysoNDYV4/Y9Mm5S2yNru8bXHtHQnr1S9img0dLakjOeP
         PprC0b5MEMa7F3QiuxTvF5dy8mKPu3/8ZGob/12B0r/X50PFAyS2zR+jUCuokJrvanu/
         xr9MDz7lxUn0667TjKy0mecEyadV9tiybTEQCaaCKOm+dhglKbpYHqYLPDWTG2rwNFGz
         5ZwA==
X-Forwarded-Encrypted: i=1; AJvYcCW4VxT15wo2n2LBcByL0o1WsHC1k7DazBn48uQ5AkKadMxE9tg3yeDKwnJsf290CWhmV1b7n3nMxWCFo16p@vger.kernel.org, AJvYcCWcz/kGoOJVK5km5rbcF5ncm01PbuWokLGOcKmnxsmhjgqOpUd2Uu0KnmUU5sODo6AGEUFnP+g1ZA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxJm5io7f8dvfIz2GGJMmdK/5xMh1yiUCvIHj+3AWPNdxw42wWY
	oCgtFFlbwRYYZln2iNHgbCQG1iwkbLTCo2RwK7SKmWiMIHIkBpvJ
X-Gm-Gg: ASbGncthA88GBDpS10TTDh+jsQfoSKy1CY3UZ9iP6jO8qDu6z4oGLtc64lagoO+1hLm
	RXgTlpoQWQ484y2SRo+EIG/gEENkqhLMsYT0ecs0UpepU8suGmRvt6sZOMkiPdUlftHhxm//0Ph
	PzGOoKMW8qkglN5V+YwjXoLRiGvkOUKhr+BxkjkpEXvKrhorqnNAgkIjxe3afSkfZ0b2xPC/N/X
	+2xp2q4eYFF/4PZRS6rKpJrjThGiGF6wUHXim0QtoIFprI2YnlRHGBPoPEow3sDe01w0xqdhW+X
	J2eIT1HxuPAVL0qYkE1nQYPlmTGThvPU98WwKn7bqu+J2dGI2xTpvA==
X-Google-Smtp-Source: AGHT+IHXIdxkv/J0ofIt2VqBBFQLmxoeid17ZAV7HbUHjv5Bu87J3Ffr5hMPd5oI21IEC8N1/X0jEA==
X-Received: by 2002:a17:906:9fd2:b0:ac2:a5c7:7fc9 with SMTP id a640c23a62f3a-acb42ba2587mr437054966b.51.1744881063021;
        Thu, 17 Apr 2025 02:11:03 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::1e4? ([2620:10d:c092:600::1:c8e6])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acb3d1c8685sm261725066b.144.2025.04.17.02.11.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Apr 2025 02:11:02 -0700 (PDT)
Message-ID: <87cacc12-03d5-4d9d-a1b1-5a1da231be2d@gmail.com>
Date: Thu, 17 Apr 2025 10:12:18 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rsrc: send exact nr_segs for fixed buffer
To: Jens Axboe <axboe@kernel.dk>, Nitesh Shetty <nitheshshetty@gmail.com>
Cc: Nitesh Shetty <nj.shetty@samsung.com>, gost.dev@samsung.com,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CGME20250416055250epcas5p25fa8223a1bfeea5583ad8ba88c881a05@epcas5p2.samsung.com>
 <20250416054413.10431-1-nj.shetty@samsung.com>
 <98f08b07-c8de-4489-9686-241c0aab6acc@gmail.com>
 <37c982b5-92e1-4253-b8ac-d446a9a7d932@kernel.dk>
 <40a0bbd6-10c7-45bd-9129-51c1ea99a063@kernel.dk>
 <CAOSviJ3MNDOYJzJFjQDCjc04pGsktQ5vjQvDotqYoRwC2Wf=HQ@mail.gmail.com>
 <c9838a68-7443-40d8-a1b7-492a12e6f9dc@kernel.dk>
 <a2e8ba49-7d6f-4619-81a8-5a00b9352e9a@gmail.com>
 <a263d544-f153-4918-acea-5ce9db6d0d60@kernel.dk>
 <951a5f20-2ec4-40c3-8014-69cd6f4b9f0f@gmail.com>
 <fe9043f2-6f80-4dab-aba1-e51577ef2645@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <fe9043f2-6f80-4dab-aba1-e51577ef2645@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 23:23, Jens Axboe wrote:
...
> Theoretically it is, but it always makes me a bit nervous as there are
> some _really_ odd iov_iter use cases out there. And passing down known
> wrong segment counts is pretty wonky.
> 
>> Btw, where exactly does it stumble in there? I'd assume we don't
> 
> Because segments != 1, and then that hits the slower path.

Right, but walking over entire bvec is not fast either. Sounds
like you're saying it's even more expensive and that's slightly
concerning.

>> need to do the segment correction for kbuf as the bio splitting
>> can do it (and probably does) in exactly the same way?
> 
> It doesn't strictly need to, but we should handle that case too. That'd
> basically just be the loop addition I already did, something ala the
> below on top for both of them:
> 
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index d8fa7158e598..767ac89c8426 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -1032,6 +1032,25 @@ static int validate_fixed_range(u64 buf_addr, size_t len,
>   	return 0;
>   }
>   
> +static int io_import_kbuf(int ddir, struct iov_iter *iter,
> +			  struct io_mapped_ubuf *imu, size_t len, size_t offset)
> +{
> +	iov_iter_bvec(iter, ddir, iter->bvec, imu->nr_bvecs, len + offset);
> +	iov_iter_advance(iter, offset);
> +
> +	if (len + offset < imu->len) {

It should always be less or equal, are you trying to handle
the latter?

> +		const struct bio_vec *bvec = iter->bvec;
> +
> +		while (len > bvec->bv_len) {
> +			len -= bvec->bv_len;
> +			bvec++;
> +		}
> +		iter->nr_segs = bvec - iter->bvec;
> +	}
> +
> +	return 0;
> +}
> +

-- 
Pavel Begunkov


