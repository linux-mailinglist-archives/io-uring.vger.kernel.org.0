Return-Path: <io-uring+bounces-8480-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AA946AE74F4
	for <lists+io-uring@lfdr.de>; Wed, 25 Jun 2025 04:52:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 85CCA19214F9
	for <lists+io-uring@lfdr.de>; Wed, 25 Jun 2025 02:52:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22F8A1448E3;
	Wed, 25 Jun 2025 02:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="W749QW3F"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBAF810942
	for <io-uring@vger.kernel.org>; Wed, 25 Jun 2025 02:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750819957; cv=none; b=WDIUUCaVpM5cZtyVDm8gQE4jRGqHRziQT9JhOBucVdFRuX1d8Cba7oxZYgZUyRJFcfXGZ0k1BqOgLYOQuI2ah9rG2xVJnRZ3L1aFZSQVp0vgTlCB0NTs9eBQ/OcKjAIeKHClHzd7IQHILsb5UmtrcptN+jaVOmTebRrLmqAGJVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750819957; c=relaxed/simple;
	bh=scjquq6wttO9oXi1bdFZeHDgPB8E68ChTH1MB/3V8CI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gdFZ6lb/+xs5vdWXOrT/yU0A9gcOzTaZxwrAFLVS7t801tpRfjgyazp6U45BPkjCDhEAYuluke0G9Pklbi7QybslO+MOfKXvELeV1BXr4+FhAVpWD6DDscc6qpJKyNrCYhJ8Mzi10V9RAPsaJAp3/EVdhdTMR0vmLfkOTubI1BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=W749QW3F; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2349f096605so95903695ad.3
        for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 19:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1750819952; x=1751424752; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eUGRbUIGqocS5Cf44+e6Hc/QREYX/Rx/zcwbogUXZ0M=;
        b=W749QW3FnPQuMRq8kqoIaN3F7AqrKVI8cDddo4FbzAwk35OLiug9wvZJAAeOUQ2MAt
         1d787h3eN24f0TnUENsuv2qaYfRM+wHN/JlYRa9nGwuduAU3Y9GpQLS+PX2rpSMGWHCW
         4hM8WbzJJLcffxK3JIdpS23gPQEVgCmcgQS4608yQcI1Lff19tB3XFzW7MLRi+lMCGq7
         8HpOdKprovxlJkVOwi24DWn+Sl7+KtJ16vcdaI/IXDhLunCh4H43qyVcCdSjvPfryvKf
         PkKl6eN2Ad9O+iOb8yR0sIF39Z+lLzfDfAy7yVrPLGgiGQwBioZpB++4elV20vq8HRuD
         hz7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750819952; x=1751424752;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eUGRbUIGqocS5Cf44+e6Hc/QREYX/Rx/zcwbogUXZ0M=;
        b=qLVtrMXvItPR/15CaXebmJf2hdqfN10mw8DkT0LRJI5kf5CgnuXkYBsa8b0qMYCZeo
         itRrCMHBIyJ6oubMbNqAaQwt15EtCCW7/Z24Eq2LHyHDAjZAGhXCJIVfYPZ8jzVwvPuL
         CsKbjM8855M59iBUk/dKEJhwf6WpIiNyj2Km3f6eSkl+7Yod+6wyG+3PJEmiTvIyiV8s
         Sq/BPmWlGI7SXY0G/2ndC+sPNOJ3jp1yjRK/hQgmFcCZoZ9hHJ1ItdvvyIg6RdxXAKlD
         l9JkijdVUo28NfWnBM3RP1WzOaFQVjiWodTRgcJmDc9nGHOxWk2DwuWcUuqN9n4jX5Tm
         e7bA==
X-Forwarded-Encrypted: i=1; AJvYcCU8sWZiM8Fv7l7RZQx+R09Xsw370qVF3fLrXldbdp1xMlVb7XxS6N2FBLkA0J8SJakz+HcEto4cqQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy39DqN2Ngkcc/1UDGU6xZv6B6o5SJAbv76XOy65vj0BuLjbaax
	cX2x2wVnwS3diPP1b6O6hlUkJpj7XcAWlwKtUzgO2Y+rcvWric2p/ta9IJFAK0UWFPY=
X-Gm-Gg: ASbGncv4EqHXyfkCtHMD+TOMQwG9AOrHsYR+dNpXYmvpQ1ldu2o48Vv2+fLa7Cs4saa
	humWs6CbRsEY3P+4Ggr6kPQYNCzhWbbTd+wvKcNApM3bWNjKtR9LLmQ45TeSLbKBMzCHcYugUYA
	X9W2e/dJ8Pxus4nrARpyrI103opfrg3lHeD61cpy4JG3hhC8aMac1zfbrDnsFblgRDurpyLgr2p
	qr6OcsGXcAH2oybmVuCAZjECC1EJrZwptASG4DXBMdi/sUle9E0yf08uEstWc+Wjot0awMrNSkV
	lBqfPSta/KvP7+YDju9HoP3znHNdQY/2WJo4p0mNOeD0RLqTD8RaWO2t6g==
X-Google-Smtp-Source: AGHT+IForrnjkyCNr2lCWtmQYmo0KeD5UPTCMahGoOUThglE5SglsNaEQznEtnm9if5Eos48xokSVg==
X-Received: by 2002:a17:902:ea12:b0:234:986c:66d5 with SMTP id d9443c01a7336-23823f98057mr28670475ad.5.1750819952025;
        Tue, 24 Jun 2025 19:52:32 -0700 (PDT)
Received: from [172.20.0.228] ([12.48.65.201])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237d860a8a8sm117728855ad.132.2025.06.24.19.52.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jun 2025 19:52:31 -0700 (PDT)
Message-ID: <d0929e59-ffe1-4de8-ad3b-2f81d6f24f3b@kernel.dk>
Date: Tue, 24 Jun 2025 20:52:30 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] io_uring mm related abuses
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>
References: <cover.1750771718.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1750771718.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/24/25 7:40 AM, Pavel Begunkov wrote:
> Patch 1 uses unpin_user_folio instead of the page variant.
> Patches 2-3 make sure io_uring doesn't make any assumptions
> about user pointer alignments.
> 
> v2: change patch 1 tags
>     use folio_page_idx()
> 
> Pavel Begunkov (3):
>   io_uring/rsrc: fix folio unpinning
>   io_uring/rsrc: don't rely on user vaddr alignment
>   io_uring: don't assume uaddr alignment in io_vec_fill_bvec
> 
>  io_uring/rsrc.c | 27 ++++++++++++++++++++-------
>  io_uring/rsrc.h |  1 +
>  2 files changed, 21 insertions(+), 7 deletions(-)

Hand applied, as this is against an older tree. Please check patch 1
in the current tree. Thanks!

-- 
Jens Axboe


