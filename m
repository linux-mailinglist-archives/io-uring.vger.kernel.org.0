Return-Path: <io-uring+bounces-3968-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A82D19AE938
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 16:44:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B59E282B1F
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 14:44:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28A871AF0D0;
	Thu, 24 Oct 2024 14:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RiHr+wfs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13011D2B21
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 14:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729781047; cv=none; b=Z+I1kVKz7LbipmgHowshIZj2ub+R3atyB0DQU3u6RhgqNyTjIzutBfp5tYCPchrcWVNUQgei12UvhCIgWdtIldexMLhOxI89YAgyhZZBei3uCL8SCG53lTCndLCLR6QzAuJY8+ugQNUpP7Yyp/pjfH2+sWAAPswfm5Do2lESsj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729781047; c=relaxed/simple;
	bh=cHlpaiLMH8vBYtIjGMmQtERymv0+yLf/eqK2oDkMefo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=rjAc95iTRuVQD/CJLg5adWHQAIr1wPtNsso6jrSVdBQJWLyNCmpPBSzccrmvg9ekAoKCzXatGbgv/NgAEqlLd7PQhUW6xUwjo8Cgb0N5LwXjjD0yNGRKOLaGHlIZnN/HoKbpqYgwea2MW3o8q8hj3AQnNBdybl/7HfdWLG/Zx9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RiHr+wfs; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2fb498a92f6so10052721fa.1
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 07:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729781042; x=1730385842; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4sHobO1sOLSEmvNtOwlpvb2s0VDNgZwn5fJeOf3SrNQ=;
        b=RiHr+wfszV3dqZt7AbZJ/Nq6WCQ3WgjbzccAy+EBTulOO8x8xv5eN0Mac3LsvBG8Lf
         qiLLo5Pj6Tl3HHwIxAqyMXJx1UYOQN64G1vGmC3sA8msTB5v3DlokLY0geU9jV0QWDFD
         NOdSJflq2RRgkRFcWtm7Vkjxplciseh972y1IngeUSyRnZeDdr0SMIwF2l4u1VDQYEBl
         x4ShdJpYF/UHfhxmAIG/3pqaOe/B8hJGUXhYy1m0CtkzjqrDpTmkkwKqfuutEmNi4eL2
         NFa57VImgvERTZ5wwqtXmqK+RQWTvooxR1Mig32rQAtqaFwbdgLMsMk/DXI4Q3pJdZBi
         JOFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729781042; x=1730385842;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4sHobO1sOLSEmvNtOwlpvb2s0VDNgZwn5fJeOf3SrNQ=;
        b=cpjGbep/eaDVgGy+tq/6l1OrNDeSS60NhMSL37Nc4s9r6SWI+Re5C+xR4nAaXrJlMw
         /CDsPODynbBnDMsNH3HDmwknhUMOP6bL1qKPNjF/S4XoxCh+ylmnO0D5A/VQW5jYaY2o
         Z+7P5OKEXos9OqD7kDAZFB544rFxv3aaKRXfYxtCTHXo43fB5kHkSR+Vp2YDQQbVNELW
         jkVERZ7vfDAqCocw4XHt3DdMYuICG7KFQK43NQOzHUKLcIxfdHaIF6kSkRR2WDcEnqPU
         T4RDFriHO4SOCzlEqnwycBowWW/qKt9oJBBUS6UF0YJA8O9f+d9ak4uwgL6wlgkdqPQK
         ph3A==
X-Forwarded-Encrypted: i=1; AJvYcCUxZxdjyrdmveK3dUK47DN23IElYhKXNn2FsgsafK8X3UrsETRni/wrksT4Eyj2k20bf1JcucwBDg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxWvphySj2N/JjLy81wkr5cx5aFHtYb5zQPAWnD+99hOBrqqLOL
	mq6un0hJxTvy33IYwIWCrC25R+KkYV9jPs3txL6uh/JAg9cryUIAQcRkCw==
X-Google-Smtp-Source: AGHT+IFtK8+DRR0jFaGS+1HNZcOY5JPTM8hmZ9oUttutYE53XTZhBn2ZBU7v5hqdirXmCj+kynnI2g==
X-Received: by 2002:a2e:884e:0:b0:2f6:57b1:98b0 with SMTP id 38308e7fff4ca-2fca828ce20mr14464831fa.42.1729781041586;
        Thu, 24 Oct 2024 07:44:01 -0700 (PDT)
Received: from [192.168.42.27] ([85.255.233.224])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cb6696b668sm5755445a12.11.2024.10.24.07.44.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 07:44:01 -0700 (PDT)
Message-ID: <b826ce35-98b2-4639-9d39-d798e3b08d89@gmail.com>
Date: Thu, 24 Oct 2024 15:44:36 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] io_uring/net: add provided buffer and bundle support
 to send zc
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20241023161522.1126423-1-axboe@kernel.dk>
 <20241023161522.1126423-8-axboe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241023161522.1126423-8-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/23/24 17:07, Jens Axboe wrote:
> Provided buffers inform the kernel which buffer group ID to pick a
> buffer from for transfer. Normally that buffer contains the usual
> addr + length information, as well as a buffer ID that is passed back
> at completion time to inform the application of which buffer was used
> for the transfer.
> 
> However, if registered and provided buffers are combined, then the
> provided buffer must instead tell the kernel which registered buffer
> index should be used, and the length/offset within that buffer. Rather
> than store the addr + length, the application must instead store this
> information instead.
> 
> If provided buffers are used with send zc, then those buffers must be
> an index into a registered buffer. Change the mapping type to use
> KBUF_MODE_BVEC, which tells the kbuf handlers to turn the mappings
> into bio_vecs rather than iovecs. Then all that is needed is to
> setup our iov_iterator to use iov_iter_bvec().
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
...
> diff --git a/io_uring/net.h b/io_uring/net.h
> index 52bfee05f06a..e052762cf85d 100644
> --- a/io_uring/net.h
> +++ b/io_uring/net.h
> @@ -5,9 +5,15 @@
>   
>   struct io_async_msghdr {
>   #if defined(CONFIG_NET)
> -	struct iovec			fast_iov;
> +	union {
> +		struct iovec		fast_iov;
> +		struct bio_vec		fast_bvec;
> +	};
>   	/* points to an allocated iov, if NULL we use fast_iov instead */
> -	struct iovec			*free_iov;
> +	union {
> +		struct iovec		*free_iov;
> +		struct bio_vec		*free_bvec;

I'd rather not do it like that, aliasing with reusing memory and
counting the number is a recipe for disaster when scattered across
code. E.g. seems you change all(?) iovec allocations to allocate
based on the size of the larger structure.

Counting bytes as in my series is less fragile, otherwise it needs
a new structure and a set of helpers that can be kept together.


-- 
Pavel Begunkov

