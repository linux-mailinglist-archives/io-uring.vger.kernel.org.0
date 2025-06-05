Return-Path: <io-uring+bounces-8232-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1841CACF4FE
	for <lists+io-uring@lfdr.de>; Thu,  5 Jun 2025 19:07:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8F4C1188472C
	for <lists+io-uring@lfdr.de>; Thu,  5 Jun 2025 17:07:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88E312750E3;
	Thu,  5 Jun 2025 17:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lPnnVdRe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E8C13B2A4
	for <io-uring@vger.kernel.org>; Thu,  5 Jun 2025 17:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749143226; cv=none; b=XWyol/iPgJF5SXUkSfMI7wMkiUXYFHfbyC9bF7bSw4yA94bUkkOEMDExC5uuihtq+whHM5uyItmuLLfKO4mewRJVR0WD/BnNzl28sgyWKRm51TkSBKVHcT5Ouz3sjbInebxxlnJeWz2+QLFSX1R0PPebApXOfo46qSjgDFxc5lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749143226; c=relaxed/simple;
	bh=ThdvkVBkarJOSLXeXNLzPurdp4nSanwJywDHhIhDPZk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B6WNrfbz20eDd3kAmO0/Y3noHXxrKs0Ial9kEWYw55n3admn5MWFmjM6L096aftLieKEYrDXegbdr8rvSO+3B8eWJldrSWF7/pimJppXVKk36L9kpMn53Hi4W2bg/OTeaVHJqw4oie6Qc3snvlSn6abMHzKarGn2cdXZkaYb5Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lPnnVdRe; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3d817bc6eb0so5860625ab.1
        for <io-uring@vger.kernel.org>; Thu, 05 Jun 2025 10:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749143220; x=1749748020; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LakYrBkUrOsx+NjcMgZUWUvGGB0HMcjuPQ9We7oj7/o=;
        b=lPnnVdRehvymTtXTrHwDuMiA17zkpKYKZe84KOCXE8B3EAen2M2gl+5PsXXCRXw5HJ
         nXl3AZWtu9Q47iX35JUPBiFnk3YlLs22sZ9ot/YMcXI/Ib9CUjmy6OsFGWiEQPjoDdfz
         YMZZdn7BseopiPoyUYgDeHpFH+ewv0ExQRBkWKzBk7siISXm098OSvimpnKoG1kZeMEV
         HU3qJVxpbmp7OUWMVcnHdpzzO+eKt/nbyRz96X0fZRH9FzmjB83IFbPT8PAK9CYV6QS4
         IUkGohSnfuK6ArKTjzBS5ulaWHo2TYRyD8CMx0IIkj+6JIbPpD9X19B8VH/qYJtxvafT
         lGEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749143220; x=1749748020;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LakYrBkUrOsx+NjcMgZUWUvGGB0HMcjuPQ9We7oj7/o=;
        b=sXiQuKix/5Kc89UhxPBCaSAFtu8qPvFgSZT4d7VKvjdI4iSRkRb/pMg0Wh63SVjozH
         Ms8HKG73E1jGOSggv6kAjlDMDL8ZrHEtyizkmwASVkPWaKRzlwpvcvp90D3SBzgGRvZ2
         TbpDaF9e5k06GzUN6lXr8HeJPvPgOb1rQ+9aPv5OXnzF0Fra39uaRhbOZ+uRLlrGX7ny
         9tlCLE/rKIUOzEs+UkPVd6QSfc6YIUdLOpVCbV1AxyxNTC3+zWVM9zYaUG/heIQxA8+e
         GKkiXfadhb+/Ctlfsbtt6e31W2U+9OqahNefNw1fhHSfqzOcf09bzDS5Mp54Kbg1ORCJ
         ujMQ==
X-Gm-Message-State: AOJu0YxtsuI5jI1Pay9j5YwoxpzKvLnsLydtcilc0Iad9FkBYuXQ1rsV
	2OottNWQVCi/GFa0nJetzKmM9nNdIqf0x2qcBntTbRBmoAxdSj4S/tAgfjtr3t5aFf6+SK7oRSC
	JaIgi
X-Gm-Gg: ASbGncs2b3F7HjLV+SY9H3amBoSbVxei6zivwuLhP6xOYPsYpTCWtjNme6oBP7heXLD
	Ur6M32jIRjbW2HMH+zRIZLxnOZ0Deku8SWQJUaMgoFRTlV+TJSsp1N84FW5dzPbYWJVJXRN6t5n
	xxaDGE5kedx27gtk2kkfKRLdxQX8uIV4KHukTPFivh0nBONHqgi+C65YrDNb00DE3wuBGaoM3eo
	dKlZ92uE7fM9GCDuf3m1mcGpPSe3VupJsoky04N2ML0blKp5OgrTOw2LxyimQhFUNdM+C9OAlmD
	/ywft2vDSS3NPhxJbDcThpUTwKmw0mR5LmBCi7CNgm0rk+g=
X-Google-Smtp-Source: AGHT+IGyHmaBnrfgQSEhvZdODoyoHpWnuSdmE70Z7EiX9jtN65LlFfU6jK1niaNHpOqglylWhpdADw==
X-Received: by 2002:a05:6e02:158b:b0:3dc:8b29:30bc with SMTP id e9e14a558f8ab-3ddce496f67mr1243475ab.21.1749143220090;
        Thu, 05 Jun 2025 10:07:00 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ddc2b4bff6sm8045655ab.55.2025.06.05.10.06.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Jun 2025 10:06:59 -0700 (PDT)
Message-ID: <cf562005-7d10-441e-8a37-c2008af20646@kernel.dk>
Date: Thu, 5 Jun 2025 11:06:58 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] io_uring: mark requests that will go async with
 REQ_F_ASYNC_ISSUE
To: io-uring@vger.kernel.org
Cc: csander@purestorage.com
References: <20250605163626.97871-1-axboe@kernel.dk>
 <20250605163626.97871-3-axboe@kernel.dk>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <20250605163626.97871-3-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/5/25 10:30 AM, Jens Axboe wrote:
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index cf759c172083..8f431a9a7812 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -2197,6 +2197,7 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>  		trace_io_uring_link(req, link->last);
>  		link->last->link = req;
>  		link->last = req;
> +		req->flags |= REQ_F_ASYNC_ISSUE;
>  
>  		if (req->flags & IO_REQ_LINK_FLAGS)
>  			return 0;

This is set too late, must obviously be set before ->prep()...

-- 
Jens Axboe

