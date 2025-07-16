Return-Path: <io-uring+bounces-8695-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C382B075F0
	for <lists+io-uring@lfdr.de>; Wed, 16 Jul 2025 14:42:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 801547A9EBB
	for <lists+io-uring@lfdr.de>; Wed, 16 Jul 2025 12:40:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 477092F50A9;
	Wed, 16 Jul 2025 12:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="uxbc5z6d"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A0C2F546D
	for <io-uring@vger.kernel.org>; Wed, 16 Jul 2025 12:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752669675; cv=none; b=qgLY7o0icCBsEgbAiEvoPQuyNnd7nzFGeC8sZFRRiXK+NtGNW6UWT7Q0djDkl4L5EDaQiDewBGugCWwNFxfM2D4OcVHqJp4Bt620Xjmr0xWS+0qEBfBKtSunXS20FOZ/oXkQKNth4jZsx8eRbnfyvX1YJItc+E+hQkvV9GxZFkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752669675; c=relaxed/simple;
	bh=cga2vmTkzUhL4ZVMLscasBhMNW0iy5jkUZxhXYAfMeA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E94kSvq8atfTVVhxUOc4+HKTIbtsnd8OP4UjxtlYu1rjx+9hgYY8iNgt6HXdjABDmlOQ9Xu6HzrargRp8/IeDlPqDcC4Iv8IQJh1/Xp3hLIpnhShXxdY4dm09AbGRaV7ND3+RkghT7qc4t3o/l5Q/RQ/mYM6rvTkPcsji4oVsFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=uxbc5z6d; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-87653e3adc6so34099539f.3
        for <io-uring@vger.kernel.org>; Wed, 16 Jul 2025 05:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752669672; x=1753274472; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5IyO6wUl//owvi+Xi5g+hOG+WKmfJL+fQ0DzM68WhPQ=;
        b=uxbc5z6d1D1qLOq+D/kU7ZCHjjiSgy+EdypBiqrxs7UbkxwqqH1Rkja/WX+hyyaMVe
         nHxYAivWhIhmh0qRG9Yl8kkUF9jNznWTTXDpvPrBU7Ww0NgLtzNwRsIbhdBT5oF0FOoh
         k/3G1OrrIgrukfTIfo2nd+JWhI+t71rMKj8NgscCi6/j9I2kl2J1KbeQ8FldZHymHOfo
         vZ9YGG5ezLzH0EcLDP0a3Ko2kNmj21exmDKIRsbQx8W3xE8SeaXncamaJzcDv/u7jHUH
         hvbZ0lx+POXSBX1Ocm+6PCeJQQ4AqhORLmERrQc9y3cdnA+q+MIcNMNvvYZgY/2rLWJ2
         wLqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752669672; x=1753274472;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5IyO6wUl//owvi+Xi5g+hOG+WKmfJL+fQ0DzM68WhPQ=;
        b=BxJfHpRuDKrjbCz9EARpCigG6qfBM9HhlC9SUViTvVqBDkmmnPQ7Ic85Pds/DMG8sx
         IVS/UFu3lVeuGFAOySQBtMuqsTUxqCIa45IbI5KAtdrc5qcRc6eKwGRATQzpldOnnSPG
         8ZnMeK35iqXJIlxwFjHfqbbfN++6dKbJacGlBG4Iu4cJcwfWYqmYHWQO9A+7VgArIcl7
         B/cP9p191Iq4XgtYiioNbp9ymsAQQBWqpnVa4f/uxeQVU8T/X+PSbpTQ7/QsooPmS7Es
         N1hZhx1x91eLhHJnFDs13hvycrdXP0AB2Eh47lMznn12AIw2w9RFVAfoAtg6SJWqevlJ
         9T0g==
X-Forwarded-Encrypted: i=1; AJvYcCXjdxekV39fuzU+D/knrnnpB1pOuXsKukV1B1DlXyRuWLlQHWxWQ1IP1cUb7qZahlXVm1nmjJaNmA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwV3lde8F3zsI8n+PgzluPyaB1jRqig22bw13J973Z6Ty6Diqa1
	c+v8k5shbkxDE7MScBVQQyRevtqkteaHHV4KHRVOum7KOi7RxBkmBZqCp0jgKVGswmE=
X-Gm-Gg: ASbGncvOI4cNVSrVaUOeCHShV8+uQ5Mcsdv/R6KdZ0+UbSxOVs3nAg5psjIJZRRk0xB
	53Iw2tNpnKA9JWaK7eAZIOR39H6Xokws1EBve7CG9XPPCmEUhN7QHhKgAo+5xF4RHjv/31xaXmI
	0vG3mAsawya14ZGKC/tK1pWw9PbD/pW31QE+Coj8U9gGCLRPsLuDS6iFMnh9q8/e+DoN/+0Jxx4
	cFRtoMF4AO39IKcZrb6nhbkGW5uL0Bp9JshftcPJAdG2EdDKPkU2ChKHBX4o7Vl0f/xg2qLW0iy
	OlxdZI+cBY4kM8SRzPMbm064NW1fK+OGl4sc94g7Vdu6QO6/mZO72Ng9a1WXElm4KoGbW7iiJMN
	LcuWNfgILP2Rn/8uvIIM=
X-Google-Smtp-Source: AGHT+IEaXkz1qDW6FctDCit+gCLbqFb/TZneYPdal+/fxuNQLUjjm3E8xB2iDIfQRJdJclhXIeMwNw==
X-Received: by 2002:a05:6602:641e:b0:861:d71f:33e3 with SMTP id ca18e2360f4ac-879c2877178mr253394639f.5.1752669672141;
        Wed, 16 Jul 2025 05:41:12 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50556973045sm3044134173.83.2025.07.16.05.41.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jul 2025 05:41:11 -0700 (PDT)
Message-ID: <3b28fddb-2171-4f2f-9729-0c0ed14d20cc@kernel.dk>
Date: Wed, 16 Jul 2025 06:41:10 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v2 0/3] Bring back `CONFIG_HAVE_MEMFD_CREATE` to
 fix Android build error
To: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>,
 GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 io-uring Mailing List <io-uring@vger.kernel.org>
References: <20250716004402.3902648-1-alviro.iskandar@gnuweeb.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250716004402.3902648-1-alviro.iskandar@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/15/25 6:43 PM, Alviro Iskandar Setiawan wrote:
> Hello,
> 
> This is the v2 revision of the patch series to address the Android
> build error related to `memfd_create()`. The series consists of three
> patches:

Took a closer look at this. A few comments:

For patch 1, maybe just bring back the configure test and not bother
with a revert style commit? There is nothing in test/ that uses
memfd_create, so there's no point bringing it back in there.

IOW, patch 2 can be dropped, as it's really just dropping bits
that patch 1 re-added for some reason.

All that's needed is to add it to the examples/ helpers. If it's
needed for test/ later, then it can get added at that time.

All of that to say, I'd just add the configure bit and the examples/
helper in a single patch and not worry about test/ at all.

-- 
Jens Axboe


