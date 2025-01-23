Return-Path: <io-uring+bounces-6064-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 864E4A1A5BE
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 15:27:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 793991885977
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 14:27:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A790820F96B;
	Thu, 23 Jan 2025 14:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e8020InO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A8B13212A
	for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 14:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737642440; cv=none; b=FE9lo72yl/TFZTcQ97SebW0zC0CgNtD9dfsZzzZrtpRds7w6urF/mGnanaVJoN6nfG9O5MHPpFHjxKgrd0y/fHQ+qOMLL+md+lNsSXzDGv8V18wmzSLKkB7gGF7nxKLEP/fUoxfvBnQlvMxsJhH4GH3CDZbtFSvnrj7fruNotgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737642440; c=relaxed/simple;
	bh=sEjQcmFqc50S7iyxTs6ogYpBblvCWxTrLfGBIGPhA3I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JjavbH1m8lat1nh9CsVMDwR97FMOyrKXqVAVyiXDgmLn8TJAFKSgJ6rmB/QExnM0/cyhNg0c2tPFqLgtt5qWL0JnOBpFHVD0UTnGaWPmVYucxJU2rYSWKx83PYAIm8bFW/0gOSczdeRLcthFfVwkXwbcUhqrLM+9zr7wO7TicYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e8020InO; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-ab65fca99b6so197097366b.0
        for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 06:27:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737642437; x=1738247237; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8QHQe0x19ndbXCgNY7Q7cLQTZemJgw+ee8lTobHyu54=;
        b=e8020InOK1RKnfXdER4miB+cgfkjsj3vJPfmmC5lnirbAaVmRm0GotTIzZ97uOwinu
         rcy4+rtChc0dLMBYxcMoo2eN6KM+BcQJQL4mHnP7Oh92RYkiiG0im++WmGaLS3Q6zCv3
         EIQx088ZaBWr5hUoGKl7MjYsyqjjoJHjKPUUL4OBZDBxdd/C1dOClTZfljuTvVskDQfm
         bQ7fl02n3N909RSUSZt6H+BUVZ367C7qocjRuwt6N09ex6eCcm8R9zG2Vaj5pVKft8Bi
         2+QYxhCiNt2/XvaZLjQvNFac9AFKdbAGVNcWJw20W5Q0UXbablXufrywsBa9JR5L0UVP
         W6bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737642437; x=1738247237;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8QHQe0x19ndbXCgNY7Q7cLQTZemJgw+ee8lTobHyu54=;
        b=VAIRkbl9maQyd1VDYhlXGvZvIGVw9vyPbBeB5NtSSl4++eZAZnVomIwwSIJlxY44kh
         +gosKHrrMcaNngVndB69J7p/XF++65iOUdkqq+kV2AJjETRWWhfgganEG3NC3uvkCuBP
         5zqsDo4Y873u0bt7PNBeoNaqf1vPXxiIFRTocbOVvwgxDKp9SpOdhsUpubjhHXscLFdZ
         usVMt4zUb1vRR+VR3Xwqn/A9Ou6rEz4OIYG6urhGDag4wUVE1bl5AYuSAvE94ibMwp0e
         z9JlZTSVA2ap2p1uO7cj9i15x5g5xHJn2jE371GPsfMw9vNjWYJ/ACVRVC+p/Zj2LUp6
         aGzg==
X-Forwarded-Encrypted: i=1; AJvYcCUr1Y4YQkf2TObsGnahoz0ET0wxk5RfhaMvuH76BxcLLddnaYa9Rd9AGJAHjsIi3S5K/yS1eC0MEg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxrP31rng6QAwueLeRqCPeFRqCyiYV8azLqQ+hi6i6ps6IKDheg
	GfB/Nn0x5pzvAE85xsco0mwCMLXziyO7EH/9z3T/GJpz4S78txVi
X-Gm-Gg: ASbGncvED7DxqkG+Cj1h0znWdAame943Qoai4qUON0QUcWwGORs0RRhvD2Aa8UVBzvo
	koKnc34dI/a/27G7WQ3sPGZGQ79IWb+xnTpYKkGopwxmYsiA1wuyVycDyuvNL7tWNFObmateiTm
	diTQHEUdHaYg/jS0LJfqbeNJsQx+TQ7NI5S3WNzefnzMpAdzv9V2K40usZQuhLJIip+SU9Q8z30
	3l+T7fJwVzb1WbIjou5kj6IGB3TOgEtCEy3kM7tGJjluhyEtvFnm17Aw3gYAPtJ02UXEP5m+Uq5
	Bm0TkLX63tae6/iqhAulUfdTf33N9pw5r/pKaw==
X-Google-Smtp-Source: AGHT+IHovDpgSi8PHKBbnzHJMtVAzvEiXZTk0XTN1KGkLBjuyXj6VefN2XBAwqY/qLvC+YlZT5ptRw==
X-Received: by 2002:a17:907:94cc:b0:aa6:85a4:31f8 with SMTP id a640c23a62f3a-ab38b32ad1fmr2352777766b.33.1737642436937;
        Thu, 23 Jan 2025 06:27:16 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:7d36])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab384d2d3dcsm1061427566b.81.2025.01.23.06.27.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2025 06:27:16 -0800 (PST)
Message-ID: <cebeb4b6-0604-43cb-b916-e03ee79cf713@gmail.com>
Date: Thu, 23 Jan 2025 14:27:49 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] io_uring: get rid of alloc cache init_once handling
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: krisman@suse.de
References: <20250123142301.409846-1-axboe@kernel.dk>
 <20250123142301.409846-3-axboe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250123142301.409846-3-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/23/25 14:21, Jens Axboe wrote:
> init_once is called when an object doesn't come from the cache, and
> hence needs initial clearing of certain members. While the whole
> struct could get cleared by memset() in that case, a few of the cache
> members are large enough that this may cause unnecessary overhead if
> the caches used aren't large enough to satisfy the workload. For those
> cases, some churn of kmalloc+kfree is to be expected.
> 
> Ensure that the 3 users that need clearing put the members they need
> cleared at the start of the struct, and place an empty placeholder
> 'init' member so that the cache initialization knows how much to
> clear.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   include/linux/io_uring/cmd.h   |  3 ++-
>   include/linux/io_uring_types.h |  3 ++-
>   io_uring/alloc_cache.h         | 30 +++++++++++++++++++++---------
>   io_uring/futex.c               |  4 ++--
>   io_uring/io_uring.c            | 13 ++++++++-----
>   io_uring/io_uring.h            |  5 ++---
>   io_uring/net.c                 | 11 +----------
>   io_uring/net.h                 |  7 +++++--
>   io_uring/poll.c                |  2 +-
>   io_uring/rw.c                  | 10 +---------
>   io_uring/rw.h                  |  5 ++++-
>   io_uring/uring_cmd.c           | 10 +---------
>   12 files changed, 50 insertions(+), 53 deletions(-)
> 
> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> index a3ce553413de..8d7746d9fd23 100644
> --- a/include/linux/io_uring/cmd.h
> +++ b/include/linux/io_uring/cmd.h
> @@ -19,8 +19,9 @@ struct io_uring_cmd {
>   };
>   
>   struct io_uring_cmd_data {
> -	struct io_uring_sqe	sqes[2];
>   	void			*op_data;
> +	int			init[0];

What do you think about using struct_group instead?

-- 
Pavel Begunkov


