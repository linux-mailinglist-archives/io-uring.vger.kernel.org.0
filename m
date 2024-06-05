Return-Path: <io-uring+bounces-2125-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B96B08FD2F5
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 18:31:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B48831C21093
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 16:31:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F8513BBEF;
	Wed,  5 Jun 2024 16:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IRmiYIPG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA88D4597F
	for <io-uring@vger.kernel.org>; Wed,  5 Jun 2024 16:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717605073; cv=none; b=S1+9YQpGOzNcf2pa4JA43diRTAVidxZZLHI+hTe0Pq3faeVsq6sI/DmEvVvWPI5UahC5Lsu0ZG3HlPGpChAWdS5GlYtirH+xgt+/Ft7Dha2HF+BJkKLIDQEcl2WfElpFKgPJGK3KlUak4ueZc8853LCgkmYXVbnuRyXCCzxhQn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717605073; c=relaxed/simple;
	bh=WJQqxL4xJ8UAVBmO1BuCLA3ccUJAIDeouW89WlcLFrA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=iTZzGGXjDbWdhqvnAeNTHX+/q0XHc1a1j9SvVRyC3mHfQL+sSJgyWCAwgh0LXLun11fskPXDD5YIOCq8geh3yYgmZt3BSRjqKVqmexSK7DpNBQ/ptoa06G/kuKkJVQn9zMiES9xOD5JiKC1mqD25Jy7njrd99sRBN9XTK1X+iQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IRmiYIPG; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-421208c97a2so371175e9.1
        for <io-uring@vger.kernel.org>; Wed, 05 Jun 2024 09:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717605070; x=1718209870; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QKux8vt69Mm3lUhJfO37F8zUNH6CQ4FtRmtJUQIUPKI=;
        b=IRmiYIPG1GuJjQGCX3SzsyYNQDDwpsMh+FegmvwVoLbPemsq7RIqxBp5S7YCAefvH9
         JOKOIqE1SaoSeY70v+51BbsGvmcCE2oWt/1lYl1LYwIAwFYokIluOuJO7qTAYEwC5fgq
         BAN8pUJZAsLQMcV+0PUDk7iFhNGwrGRZRCDiLNcmvPUbl0g66/N1Y87mXGEgj6LWnOTD
         pdmUZwAp1HEaoSzemwY4yKwwgKWfLhwZM2d/Rf2H6nN6USoiNErvJ7jiqkmd3Jo/gcp1
         S9uBRY1s5LYj+JE5YPRadpsG8m+uozCMYCOuYPedqhZbGLpRSh1VurhAlQa2Q311BNxh
         CaDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717605070; x=1718209870;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QKux8vt69Mm3lUhJfO37F8zUNH6CQ4FtRmtJUQIUPKI=;
        b=JGS2DWTlPNaB8ruqfn3T6sCc2pKR8xlRYxWX7u6SoujnSRfoYusnpqqq9eGEYb7NOI
         q+g1Gvger1TyJugYUPn3rURkhcbJijOU7Vx51rKW8M0t8jGZyCZe82FDbw8809o4sx0M
         d1BrI0QJvd6pAeI+DZ4JGfNzq7j8bPjj7I3DPhK9GSe4MA3V2d07Bff/0cwgKpqoR4oa
         r8yaVcdlQwLctHxz9zfgVDEYwfJlv+L7RlS8IU7M36GuYn67bQcfVEEcDfhkVahXWhTN
         b3P3rxgLlG3f3AVJ+ymtJUAizTCZeAqAQv3R2VhX4D/BSLfDhLgcBPqwG1tiVRftLwkq
         y7NA==
X-Forwarded-Encrypted: i=1; AJvYcCVglQHJjUSevkhaQgPIX7JrYgPpxCGCFOPlArUFBbjPokmSLnFwGhdehK36hi5CfeBwXTZuYY/jngAZJdZCxcQXBD9jPvHdbM0=
X-Gm-Message-State: AOJu0Yx8y5yTcfU6nFCv5KYTMwp/eB/n9gRy77iS+o+odfzp2BPdHpgj
	eygE3ZZNuQL3XdRmWTrjtpOW9+swTRMMGc4/2TSQxrT0cqgoxv/jfVi1KQ==
X-Google-Smtp-Source: AGHT+IF7jub4emCGxKwQtABxg3v4vlDDZ33TwMO+AoIzCIWVo4YFns97YC3O/xGj+2fybfOcutsTZA==
X-Received: by 2002:a05:600c:4f84:b0:420:1fd2:e611 with SMTP id 5b1f17b1804b1-421563380bamr20259665e9.27.1717605069860;
        Wed, 05 Jun 2024 09:31:09 -0700 (PDT)
Received: from [192.168.42.227] (82-132-227-73.dab.02.net. [82.132.227.73])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35eb6fd4695sm2897510f8f.117.2024.06.05.09.31.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jun 2024 09:31:09 -0700 (PDT)
Message-ID: <7ac50791-031d-453f-9722-8c7235573a21@gmail.com>
Date: Wed, 5 Jun 2024 17:31:12 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] io_uring: move to using private ring references
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240604191314.454554-1-axboe@kernel.dk>
 <20240604191314.454554-4-axboe@kernel.dk>
 <138bf208-dbfa-4d56-b3fe-ff23c59af294@gmail.com>
Content-Language: en-US
In-Reply-To: <138bf208-dbfa-4d56-b3fe-ff23c59af294@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/5/24 16:11, Pavel Begunkov wrote:
> On 6/4/24 20:01, Jens Axboe wrote:
>> io_uring currently uses percpu refcounts for the ring reference. This
>> works fine, but exiting a ring requires an RCU grace period to lapse
>> and this slows down ring exit quite a lot.
>>
>> Add a basic per-cpu counter for our references instead, and use that.
> 
> All the synchronisation heavy lifting is done by RCU, what
> makes it safe to read other CPUs counters in
> io_ring_ref_maybe_done()?

Other options are expedited RCU (Paul saying it's an order of
magnitude faster), or to switch to plain atomics since it's cached,
but it's only good if submitter and waiter are the same task. Paul
also mentioned more elaborate approaches like percpu (to reduce
contention) atomics.

> Let's say you have 1 ref, then:
> 
> CPU1: fallback: get_ref();
> CPU2: put_ref(); io_ring_ref_maybe_done();
> 
> There should be 1 ref left but without extra sync
> io_ring_ref_maybe_done() can read the old value from CPU1
> before the get => UAF.
> 

-- 
Pavel Begunkov

