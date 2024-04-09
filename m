Return-Path: <io-uring+bounces-1469-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EF8D89CFDC
	for <lists+io-uring@lfdr.de>; Tue,  9 Apr 2024 03:34:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 027AF1F22509
	for <lists+io-uring@lfdr.de>; Tue,  9 Apr 2024 01:34:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D509E79F6;
	Tue,  9 Apr 2024 01:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YwYdHQJ6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F369063B9;
	Tue,  9 Apr 2024 01:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712626441; cv=none; b=hxfXYrtVp4+j6T6Nxu7NUOUWH/b0g+q2whdIDjXAVTm6xPgBNkj0HshDakBv9t2df3/7oPzz4yOtB1MTDsuaSxGx2rNLF0btDeMZSXoLSrTQJkJxviBCDV3j0yi9aDQmBX16oTCffwSIEMDrZPRRY7tCasLMC9h19dHsTH9wyUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712626441; c=relaxed/simple;
	bh=PPxo80tMq48XusKoYr/9kv1dS8U/O01FuT389qNTZXk=;
	h=From:In-Reply-To:References:Mime-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CP3cZVZotlPghs1PVOZ6Zkk5dWHWWNQI1VRHJdLcAUr85tgBx7y6RapZbZMEmeAH8cL0hhUb4m9ZQuGwE4HoR0Hib3RPm9mciizIF2FuwpaUCkHWb/45TZnMPPkc9wrjws4h5lftTkVMObS+okeYnrJiFbhz62/daOz4cnv4xGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YwYdHQJ6; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-343c891bca5so3257614f8f.2;
        Mon, 08 Apr 2024 18:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712626438; x=1713231238; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=PPxo80tMq48XusKoYr/9kv1dS8U/O01FuT389qNTZXk=;
        b=YwYdHQJ61I8pRCUyB3C1XyellJ8JYekMLfgoMsIxBhsYqLHtkKig9lNaFlSfLd9LOz
         uGOxolACzTstL3eivIOyWOTRWK43l3PYaU0/n3PWXGTIJMgPsBvbjw/sT7NyHca9V3l6
         JciZvAllX2xIOYf9Uaz5t9qOk1aPedDPFZbUb6tdGEBM+bZqZQ0gML+jFMieDfYYzO2L
         oUGQI+wFlLPcHGAA53ct3DyCHly7wYnlj0qmLzGGK4BOxSO24g51K1tc+z19Co9MuzDW
         CRKlH6dliiBIBXLYbF8sglAIuQV2tcNQfmKhnxoaVPAz+94GEyOPRXBhrWv6uyLMO6yb
         w1dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712626438; x=1713231238;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PPxo80tMq48XusKoYr/9kv1dS8U/O01FuT389qNTZXk=;
        b=eTJABH0ltDubOzG3ceufw9i8erJVrjh7GptMXJjQnBv4X31ay9FDwEYSHV8YZrBw0a
         pQIY4icmc1f3XCWnZduLDrogXTfDYvSIJ0RfsC7UFR0owc/Doc1+vjPsgcgVIYp9zZFJ
         wmkq6g1sOjZE1pO1sz+548/crc72NG0+Hwrk09vQS980yXykb2RmR5JijhtXGkGxIVrO
         PooBtlNhlwM5mpaH+U1pvtaWQO3js+vBDBCLAEuyTj6UcP6veCSMmKG1Bi5g6LcyIZe5
         mWHyoSoD9h9Ut3SiT1uh20iG3zmt+BpporeJPIQ+uww1aIAwBa2ReaCEJR4tnh1DrQd9
         WPUw==
X-Forwarded-Encrypted: i=1; AJvYcCUM6dn6grciiFEnso7IDZ8HdF9L//n0jxmQ9AZHFddBKzKZAf1NlLGZJKlnskjRhr8seNarSkcdaXVST5Sltwd8Kva53LZbGnsPT9Dz
X-Gm-Message-State: AOJu0YxeWyQ9lcuuVhtactIlgeRxKXY2kDTUe6zDn6Jy5ZVTKUGP3G+y
	YjhPdcWO+3+knH2CywIjFisk5e2LVYy63gysZmGcN+GrfVZlfSGYvAAHNK4jS1Ec57GZJuZFQNK
	SuFX6+6oWb62rFoiMxCnmwy/LZ43mJKYU
X-Google-Smtp-Source: AGHT+IEucF8z+p4Sz7cDqqb4vdKDhos/5GxTXMNJiXE0CjpEQsFfVP1Vgb+FSX7dZvoSIX0P5q79g+tCa7n6zNjvFzk=
X-Received: by 2002:a5d:64ec:0:b0:343:8026:1180 with SMTP id
 g12-20020a5d64ec000000b0034380261180mr11642902wri.4.1712626438104; Mon, 08
 Apr 2024 18:33:58 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 8 Apr 2024 18:33:57 -0700
From: Oliver Crumrine <ozlinuxc@gmail.com>
In-Reply-To: <09f1a8e9-d9ad-4b40-885b-21e1c2ba147b@gmail.com>
References: <cover.1712268605.git.ozlinuxc@gmail.com> <b1a047a1b2d55c1c245a78ca9772c31a9b3ceb12.1712268605.git.ozlinuxc@gmail.com>
 <6850f08d-0e89-4eb3-bbfb-bdcc5d4e1b78@gmail.com> <CAK1VsR17Ea6cmks7BcdvS4ZHQMRz_kWd1NhPh8J1fUpsgC7WFg@mail.gmail.com>
 <c2e63753-5901-47b2-8def-1a98d8fcdd41@gmail.com> <CAK1VsR210nrqtxWaVbQh00t_=7rhq9bwucFygGZaT=7N-t7E5Q@mail.gmail.com>
 <CAK1VsR1b-dbAa8pMqGvfcAAcVP3ZkTYZdyqcaK4wJdbuAZtJsA@mail.gmail.com> <09f1a8e9-d9ad-4b40-885b-21e1c2ba147b@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Date: Mon, 8 Apr 2024 18:33:57 -0700
Message-ID: <CAK1VsR3QDh3WiR+r=30f0YQkiYN3hw071Hi9=dkd_xLQ2itdvw@mail.gmail.com>
Subject: Re: [PATCH 1/3] io_uring: Add REQ_F_CQE_SKIP support for io_uring zerocopy
To: Pavel Begunkov <asml.silence@gmail.com>, Oliver Crumrine <ozlinuxc@gmail.com>, axboe@kernel.dk
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Pavel Begunkov wrote:
> On 4/7/24 20:14, Oliver Crumrine wrote:
> > Oliver Crumrine wrote:
> >> Pavel Begunkov wrote:
> >>> On 4/5/24 21:04, Oliver Crumrine wrote:
> >>>> Pavel Begunkov wrote:
> >>>>> On 4/4/24 23:17, Oliver Crumrine wrote:
> >>>>>> In his patch to enable zerocopy networking for io_uring, Pavel Begunkov
> >>>>>> specifically disabled REQ_F_CQE_SKIP, as (at least from my
> >>>>>> understanding) the userspace program wouldn't receive the
> >>>>>> IORING_CQE_F_MORE flag in the result value.
> >>>>>
> >>>>> No. IORING_CQE_F_MORE means there will be another CQE from this
> >>>>> request, so a single CQE without IORING_CQE_F_MORE is trivially
> >>>>> fine.
> >>>>>
> >>>>> The problem is the semantics, because by suppressing the first
> >>>>> CQE you're loosing the result value. You might rely on WAITALL
> >>>> That's already happening with io_send.
> >>>
> >>> Right, and it's still annoying and hard to use
> >> Another solution might be something where there is a counter that stores
> >> how many CQEs with REQ_F_CQE_SKIP have been processed. Before exiting,
> >> userspace could call a function like: io_wait_completions(int completions)
> >> which would wait until everything is done, and then userspace could peek
> >> the completion ring.
> >>>
> >>>>> as other sends and "fail" (in terms of io_uring) the request
> >>>>> in case of a partial send posting 2 CQEs, but that's not a great
> >>>>> way and it's getting userspace complicated pretty easily.
> >>>>>
> >>>>> In short, it was left out for later because there is a
> >>>>> better way to implement it, but it should be done carefully
> >>>> Maybe we could put the return values in the notifs? That would be a
> >>>> discrepancy between io_send and io_send_zc, though.
> >>>
> >>> Yes. And yes, having a custom flavour is not good. It'd only
> >>> be well usable if apart from returning the actual result
> >>> it also guarantees there will be one and only one CQE, then
> >>> the userspace doesn't have to do the dancing with counting
> >>> and checking F_MORE. In fact, I outlined before how a generic
> >>> solution may looks like:
> >>>
> >>> https://github.com/axboe/liburing/issues/824
> >>>
> >>> The only interesting part, IMHO, is to be able to merge the
> >>> main completion with its notification. Below is an old stash
> >>> rebased onto for-6.10. The only thing missing is relinking,
> >>> but maybe we don't even care about it. I need to cover it
> >>> well with tests.
> >> The patch looks pretty good. The only potential issue is that you store
> >> the res of the normal CQE into the notif CQE. This overwrites the
> >> IORING_CQE_F_NOTIF with IORING_CQE_F_MORE. This means that the notif would
> >> indicate to userspace that there will be another CQE, of which there
> >> won't.
> > I was wrong here; Mixed up flags and result value.
>
> Right, it's fine. And it's synchronised by the ubuf refcounting,
> though it might get more complicated if I'd try out some counting
> optimisations.
>
> FWIW, it shouldn't give any performance wins. The heavy stuff is
> notifications waking the task, which is still there. I can even
> imagine that having separate CQEs might be more flexible and would
> allow more efficient CQ batching.
I've actaully been working on this issue for a little while now. My current
idea is that an id is put into the optval section of the SQE, and then it
can be used to tag that req with a certain group. When a req has a flag
set on it, it can request for all of group's notifs to be "flushed" in one
notif that encompasses that entire group. If the id is zero, it won't be
associated with a group and will generate a notif. LMK if you see anything
in here that could overcomplicate userspace. I think it's pretty simple,
but you've had a crack at this before so I'd like to hear your opinion.
>
> --
> Pavel Begunkov

