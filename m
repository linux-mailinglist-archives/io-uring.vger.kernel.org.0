Return-Path: <io-uring+bounces-6668-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BC2E8A41FF7
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 14:10:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6AE521897EA5
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 13:10:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 517CD23BCEE;
	Mon, 24 Feb 2025 13:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j3HkVXnM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914B9802
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 13:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740402608; cv=none; b=gq2cGQ3FCSc0fKQWJSVBZg87Pu57ZIwD5vRuWPZDh8lx+Bj+Dhi7C2a1M+1kZ9FYuz4tm4EBbmwERfPswNuguWjMt3rI4JkkUdhntG4NVXaLsj9or1Mf20KtRSnywi7gwimtZKPqfPKx5il45ohtZlpkxvfeDhfNj/4z3EpSYm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740402608; c=relaxed/simple;
	bh=hScX9D2hjtOSpSxkHSyeYhVNomVqT7lVtRE57uB0V1E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UnDOjB0qZwidOWNNInhBkvoKLtJHrlEDyk/WoQ1WUCbBM6HRqCQAm58Hd9BT8yA0v1JOwHxkM86J2XCK7ueFdigjSP82a/9YELUGKFasK1DQZ7XShAzL31Q3xZQ3dUuwjSB8dLm5Qxf6tGYEUVOZULOFzFK44Ox8qiuHIXiFfwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j3HkVXnM; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5dedae49c63so7917133a12.0
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 05:10:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740402605; x=1741007405; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pTakcGA9XB4FaHMoR5iS82Kx3M7aDhNX3hj9FQaEaws=;
        b=j3HkVXnMRZEy5tiRTT+8Q1LQg0/UkgT7/nYBO2dKf8TpNWaNONhvIdkZ3AT5HYq1p3
         0+MjJzxyrpbh8yTWcr4j6SX8ZUCBXM4Kmk5lhjmRL7pde9jw+ul14+qK/+NrNmS48B6J
         uiaWm3aIJZLy9NEUQdSONUh6VNnul5wR2EayvPrL+Cp0D3bOGjwHqLqnDnDbDH6cVGIy
         ljMGdZ6Tt8ZZ4eqfLbvka9dJ4MINn7qv1MqCtO7L0QqR7n6RXA+za054d+cD0LMgjQXG
         IFRRQ6e1Jz/98AX8gpYIezfc58e6brhbFt3t/smvr//U++lSHaf/iUh/CMMisCMWRw18
         2DUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740402605; x=1741007405;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pTakcGA9XB4FaHMoR5iS82Kx3M7aDhNX3hj9FQaEaws=;
        b=hnbm/qrTAHnUv8N4VSqOkp/b4wZVd/XmI05NW2/SlzGXfS0AtBhT9Qh7pMe4ytdnTO
         Fw4eCK8tUbv4p99z6aK8oLxvbeB+8ub35+mbBTuhtM0H71zjDojDudIBFVWhN2eFnPNJ
         aIwLpaJoE3ProBiLOj5V71q77nv4TGXGXzKf4aB38Ds2BmDkca/W+LtOSt/UWrWwI7zN
         g1L3F2wdVmV2NH5V5DVQyWVKulim/9bB0oS5xfFF+3DlQhyrdu7tR8Yq8pKFMjtVjYwh
         801AGVpYoR6+A4nYStJJL5337EGu7k6Wuo6RKx/NTUV4Y/zyU4KgN+sWAGiJDbJQedhn
         d62w==
X-Forwarded-Encrypted: i=1; AJvYcCUgrJaDItX0yJlxtmONep/pjuK9auVCMS/wxSOOJFRGhbCgHRATfI8GScWTH0iVDwTVGtnhc1JD9g==@vger.kernel.org
X-Gm-Message-State: AOJu0YzG/Pi0EpLu4y0sNjC4/vDuoJLMoUC8iL83WkhqMvclPXsYBDVj
	tRSARSGwVKazzqQMMnXxzJ6r7p3lNYdSXAGWkrwHYRBnkSJZNHYZ
X-Gm-Gg: ASbGncsEk2RpsV4aYOTA5WQZMT4/sDrPorVHM+Ox09r+tYj2hR1VNh5eg7Z4A1OWAHv
	esPTS9kjlLQy+NbbYjVGP6cicrrcU/Ntt96ErjodUsXtn27JnZ5iFIwhz2AV9mGxpTjkf5qR5wH
	FVewcOXotGkhT4cLiyOGQyR6zuDu0KGngVBV+wwzh2baE/LU/p6W1qMZNbozLguOEZr/I/RUKEF
	NHqy4+UCAI0sKyvtYVk6U71pd3fdMpra4n6Ns4+ppt4uQYagTVASZqpTac8Gn6YpjJ3j4emLGb+
	EXPyqaiJeHYUc0FUK1K5wvVetJxg5tIOjmTHf6iYa626hBqhG5wbE5K/UeE=
X-Google-Smtp-Source: AGHT+IGb47y35CCbgtnZGFxRstYmbr2rn6A0CPdqEruS3N67vqYL50mtc5Tl62UZYfON0KT5Cn3gGw==
X-Received: by 2002:a17:907:8688:b0:ab7:84bc:3233 with SMTP id a640c23a62f3a-abc0da3b026mr1323051866b.28.1740402604684;
        Mon, 24 Feb 2025 05:10:04 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:bd30])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abbf178e81csm911126066b.58.2025.02.24.05.10.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2025 05:10:03 -0800 (PST)
Message-ID: <e8cc3c07-6aa5-4aa0-bd6f-5b054f10287b@gmail.com>
Date: Mon, 24 Feb 2025 13:11:05 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] io_uring/zcrx: add a read limit to recvzc requests
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, lizetao <lizetao1@huawei.com>
References: <20250224041319.2389785-1-dw@davidwei.uk>
 <20250224041319.2389785-2-dw@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250224041319.2389785-2-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/24/25 04:13, David Wei wrote:
> Currently multishot recvzc requests have no read limit and will remain
> active so as long as the socket remains open. But, there are sometimes a
> need to do a fixed length read e.g. peeking at some data in the socket.
> 
> Add a length limit to recvzc requests `len`. A value of 0 means no limit
> which is the previous behaviour. A positive value N specifies how many
> bytes to read from the socket.
> 
> Data will still be posted in aux completions, as before. This could be
> split across multiple frags. But the primary recvzc request will now
> complete once N bytes have been read. The completion of the recvzc
> request will have res and cflags both set to 0.

Looks fine, can be improved later.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>


> Signed-off-by: David Wei <dw@davidwei.uk>
> ---
>   io_uring/net.c  | 16 +++++++++++++---
>   io_uring/zcrx.c | 13 +++++++++----
>   io_uring/zcrx.h |  2 +-
>   3 files changed, 23 insertions(+), 8 deletions(-)
...
> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> index f2d326e18e67..9c95b5b6ec4e 100644
> --- a/io_uring/zcrx.c
> +++ b/io_uring/zcrx.c
> @@ -817,6 +817,7 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
...
>   static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
>   				struct sock *sk, int flags,
> -				unsigned issue_flags)
> +				unsigned issue_flags, unsigned int *outlen)
>   {
> +	unsigned int len = *outlen;
>   	struct io_zcrx_args args = {
>   		.req = req,
>   		.ifq = ifq,
>   		.sock = sk->sk_socket,
>   	};
>   	read_descriptor_t rd_desc = {
> -		.count = 1,
> +		.count = len ? len : UINT_MAX,

typedef struct {
	...
	size_t count;
} read_descriptor_t;

Should be SIZE_MAX, but it's not worth of respinning.

-- 
Pavel Begunkov


