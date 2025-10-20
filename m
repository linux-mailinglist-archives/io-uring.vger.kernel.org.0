Return-Path: <io-uring+bounces-10070-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7A2CBF2C4D
	for <lists+io-uring@lfdr.de>; Mon, 20 Oct 2025 19:43:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65BE2464AD2
	for <lists+io-uring@lfdr.de>; Mon, 20 Oct 2025 17:40:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1599D331A7E;
	Mon, 20 Oct 2025 17:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bUUbT3oN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA7E330312
	for <io-uring@vger.kernel.org>; Mon, 20 Oct 2025 17:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760982007; cv=none; b=RMVc65Ft7X3ZrAO5a9Bsibz92mJCByoshMSymk5BVIXmkdl+c11/pMnGRi6LXJzgPnUz1U/snWhmN3bdBThNKD7JpfR5LdceuscbSNcTfhwhxkmqC3WaUDUAGjKOFhi/x24YqD2/ugJ/ygkGg/boob0lzp9mILYy0g0KfWKB5UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760982007; c=relaxed/simple;
	bh=Dcw7SAlaW5UdhuxNOD6aK5/Jx6Zrl74qiUAwOQf7kFE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=TxZaHvV0clRR1tCrdht5ASpNYPrW8K3nDGE7QFoz2nVhqGmEBFOSU2srxSbvga/Mr/5r7k1STu9v50kF29Z8dFTirhDs+NQ00fJ9WPv1OUOqCPh8Rke0XvNiVuUv6pf7lmxttHioZuh/IWtiqTJoI+WokuhQljacsvUBH3uh/ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bUUbT3oN; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-46e6a6a5e42so25255105e9.0
        for <io-uring@vger.kernel.org>; Mon, 20 Oct 2025 10:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760982004; x=1761586804; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=igw8cLz8c1HuBQXXHCGSKZ7jzKwWwteTSZeSSYasaJo=;
        b=bUUbT3oN9ctjEWL15sPUd8c4/udzz/jhHD1h5vzo01HnGAQePG8uvV/MQJ0bqkizMb
         sFh8L1an0OPEjHsU5S75H94AFwFnGGm/yvbWPYYUvvDsJUohRbSeGt1cW0MVHWmb78tr
         dmNgfd3tVswpjzknyasC2TK5TImqniK4FAbkKQzN9+oaMKzk+uq16Dxfdh0FBhgXqc7R
         xOAHvfo1AGN+eV/AYPHx09PbrLbPOHchqf/SUOaIV+M1xYhpWsac39DxzTTc5ocnigse
         V1NlJTFoZQS2wSB7RqnSuZsNg7q+3AV9k6oLrQ51Q62KSgnrS9ngXpOKHcFd3szR23/G
         6afQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760982004; x=1761586804;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=igw8cLz8c1HuBQXXHCGSKZ7jzKwWwteTSZeSSYasaJo=;
        b=VKRkRfP/CGcbAkzwKj5e7PTZPmdokiWH6Wwz6D4TEhQ3DirrGDlmW5UkVAwgQorSGt
         kLNyiB+Djrz/WtWVghgDowvw83BArr63o1PHlVH7Y0w1TnhbKzFN0Rqh4dMw26+TGqu5
         A1TdmDa96CS4pUzzUHqe0KcgzRpU/x742nW3VJzEo4ipwf/IPKDN+F+m1bquRQsiEJYi
         jtulurVrjLkf1qL7rwYOqluAMTwTcpqX0BHPwjYEUK4Lg736ZO6pF1jWpBZDzfiQ4V36
         cCiTLdtftsahbVB2hbiA7R28BXMDB5iNPaD3TLWWNcl2rQWmMmvhpZL5wLV1uvE0vaYl
         0nBA==
X-Forwarded-Encrypted: i=1; AJvYcCWcsNqKoKp2t/F+KEpw//GRCaOz9Lo8rlf4a5Bt4cmUqPxVgaf7V+T0/fenUiZagYCRdZoVsdx4pQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzyNo8mPP8qtU6ltZNX6i8YyW/hyUPgK/3Xi9ismWNGqa20AXeS
	0HE3ulG69Rj/dHqr3hCeLXYzkGVoQU5mTuaCpAQ1NNdwo43JbFcprsaIHNoD3w==
X-Gm-Gg: ASbGncs+rydsRfFAFjRg+QvOQi7+OY8jHCJRr8DJQ04y4YkSN6YxlqQXTCjVQx9wGl2
	VNYJrX8YVa+zf54CN3dZotTSp/OT3nXwzzuT9zeOxhabvOf7ZLJeUMY8WOvcgyBW+DegC/uqSxT
	YLBRiNdIu9ZWs0Dk6KTSGRLKESUoH/g1v8LUzAI0tbMnBn0YAzwhN1D6VxZ+/2JsSbC3UfcphUf
	ikS/2bjpxOjjdZif66ihlOlpoPPZuDLGZoXUFHi6dZUICAVfgP+PARBcX58A8HJIKoiKeh8ZG3g
	URg9loKl2RkRarcMAMmw1ovlF09I5hd6GcfGm6dy2hcKq4KvaITfCJthtvW7WYf+xlNj5RdM7u8
	96/Zf0CfQ7GY/OWK+BJ32dT2kf4/C7Cyt1ymelgMIPh9tqhxtlHMXnkZCorC48H/kr3ihdgijyy
	bu52BjtMIgCX+bbl/BAj+hnFn+SufRJ5dGeGfaUX/+yhoV1PzxQUZuQokUuoieGQ==
X-Google-Smtp-Source: AGHT+IFtqFmTnb6hupl78pzO6QGvJRcZGvKLVB5fb7DpfsUh2CauRTccjww1hky5pdP6RGuX8VG0vg==
X-Received: by 2002:a05:6000:2dc7:b0:428:4354:aa43 with SMTP id ffacd0b85a97d-4284354ac33mr3506213f8f.18.1760982003470;
        Mon, 20 Oct 2025 10:40:03 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-474949df22csm997525e9.0.2025.10.20.10.40.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 10:40:02 -0700 (PDT)
Message-ID: <b10cb42e-0fb5-4616-bb44-db3e7172ccdc@gmail.com>
Date: Mon, 20 Oct 2025 18:41:24 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring: move zcrx into a separate branch
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <989528e611b51d71fb712691ebfb76d2059ba561.1755461246.git.asml.silence@gmail.com>
 <175571404643.442349.8062239826788948822.b4-ty@kernel.dk>
 <64a4c560-1f81-49da-8421-7bf64bb367a0@gmail.com>
 <7a8c84a4-5e8f-4f46-a8df-fbc8f8144990@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <7a8c84a4-5e8f-4f46-a8df-fbc8f8144990@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/20/25 18:07, Jens Axboe wrote:
> On 10/17/25 6:37 AM, Pavel Begunkov wrote:
>> On 8/20/25 19:20, Jens Axboe wrote:
>>>
>>> On Sun, 17 Aug 2025 23:43:14 +0100, Pavel Begunkov wrote:
>>>> Keep zcrx next changes in a separate branch. It was more productive this
>>>> way past month and will simplify the workflow for already lined up
>>>> changes requiring cross tree patches, specifically netdev. The current
>>>> changes can still target the generic io_uring tree as there are no
>>>> strong reasons to keep it separate. It'll also be using the io_uring
>>>> mailing list.
>>>>
>>>> [...]
>>>
>>> Applied, thanks!
>>
>> Did it get dropped in the end? For some reason I can't find it.
> 
> A bit hazy, but I probably did with the discussions on the netdev side
> too as they were ongoing.

The ones where my work is maliciously blocked with a good email
trace to prove that? How is that relevant though?

-- 
Pavel Begunkov


