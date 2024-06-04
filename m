Return-Path: <io-uring+bounces-2095-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 82F038FBBF6
	for <lists+io-uring@lfdr.de>; Tue,  4 Jun 2024 20:58:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3571D1F26A2B
	for <lists+io-uring@lfdr.de>; Tue,  4 Jun 2024 18:58:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9B9614A4F4;
	Tue,  4 Jun 2024 18:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="I4UKb4W/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04BF266A7
	for <io-uring@vger.kernel.org>; Tue,  4 Jun 2024 18:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717527477; cv=none; b=IuBBon/bch/KtjrEC9YobjMQYj3U3HNQtstf1eX57sul4lUzTaD9k9WPU9wuQ02TG5OEM9FrWbB78Bj9GACN4boZve5q7pSvEbguPXRFagl5uhCnjFpoZMvghclRWd+kEkQxGjhfQ05KKvT5ZguTRZBlYKJqWS+UjLYqhJIB2fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717527477; c=relaxed/simple;
	bh=Ma19/zcwp4taOoFqnGcf5nDFn1PyUNQYp4OhyjbDV+8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ROpANjej78tiiLLKdMudjGu1gYQsJbtFUffjRlg2wBmvvU8p8IDY672lez9TrREDxiL4QfTPNdWyiaQOFEXbJU//3qGMMAtMbm/ACeb92qPmoFd2nttPCZLAlBzG2UtFU1Yvl0NBJZdrWqUBYqYvYicEwCXklR2Jr8vzDbq6MwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=I4UKb4W/; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-3d1b8bacf67so562973b6e.2
        for <io-uring@vger.kernel.org>; Tue, 04 Jun 2024 11:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717527473; x=1718132273; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AjdwdMLKrt7EcxufNppQlronHVg+Q8Rr6Os7m5A4RS0=;
        b=I4UKb4W/BD2o68kwyRj0E7AMw0fOETkJcXF248UXSHKHQgXmebOJMOMukywaDwZ2EZ
         aFxgWi3ETZ5ejJB6lejohQ6rn562Y4uvJcFx9NsifZF16BWqsKmPPezjxsgeW3Uk+GIU
         AbyrDfbRfJYHkkJXG07WhQLSuAqpaKzRMk9CReuE5lVsPxiv+yOQEVIDKLSkna/zUC8p
         XNHB3TPuiK2d+3Ti7srboGx4yKXuj8NfAGhxVFvG4Hao4hhwl+bYjHcBmTQgvXSqIYQu
         cEEOs82Dn8v6XSQJfAEqIerT9/gkoNjomVFlfAJKxi+n4IAKOV503Zfv/ICcil9gSwgi
         3aoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717527473; x=1718132273;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AjdwdMLKrt7EcxufNppQlronHVg+Q8Rr6Os7m5A4RS0=;
        b=jEjwoRdzGhkGyLNJL3TvBapPFBVzBij90VMYKflseB/Zh85bAQYzPey020VdWlwCyi
         V5tPgH2oaVfsKmpe6R0ItJXcjiTShhEqV+WWKJt2pY/SeypWq/VHaqduJP6Fwr+PNtV2
         SgXDX7bFweCXVvmsGeh9qEUOgXjZIdNcE/XlD0TYM7w8N/D2kmMKVbqm+ztYSCQzWFH3
         TI5UD6dqsynln27KHbm9OGimEzLmIMXymUEoGQuJr2+TRfpFjxFgOQoS5T4c0GDLy5r7
         B1hc+9++AKfNY1jRwHsdks+Ad2AASRfszNZrTfSmyW4XQg6SCUKKenl0TPIxJYh7NCwV
         LqNQ==
X-Forwarded-Encrypted: i=1; AJvYcCVU5XTPtsTFdE9iaVUKGc7CNAGdGIV8ZNTowexkZ59FENW9wa+xpoyustZ8AaCBEX0UF2WNS5pCR97HBW9G9mxwEZeFniU+zEI=
X-Gm-Message-State: AOJu0YwVJBC/adL4njMZ/47xP4tGQC8oTkvrTY4ph2EE0oqtufXyPF8a
	UFtyLRB85F2IJRG/o50hDBA9sKN2E6yTtKHxE7mVPLlq1uFzpsyQKyA0WL0u3SU=
X-Google-Smtp-Source: AGHT+IHWV2JYRzDMcryUWy8SVqq2ydcrwHoOivnx7UEgNLikzxxzFxk4uyYS6UQBuFWuYuVF45XC7A==
X-Received: by 2002:a05:6359:4c89:b0:199:432b:8216 with SMTP id e5c5f4694b2df-19c66a16e20mr34353555d.0.1717527473259;
        Tue, 04 Jun 2024 11:57:53 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-6c359848a32sm7215388a12.69.2024.06.04.11.57.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jun 2024 11:57:52 -0700 (PDT)
Message-ID: <656d487c-f0d8-401e-9154-4d01ef34356c@kernel.dk>
Date: Tue, 4 Jun 2024 12:57:51 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET v2 0/7] Improve MSG_RING DEFER_TASKRUN performance
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20240530152822.535791-2-axboe@kernel.dk>
 <32ee0379-b8c7-4c34-8c3a-7901e5a78aa2@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <32ee0379-b8c7-4c34-8c3a-7901e5a78aa2@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/3/24 7:53 AM, Pavel Begunkov wrote:
> On 5/30/24 16:23, Jens Axboe wrote:
>> Hi,
>>
>> For v1 and replies to that and tons of perf measurements, go here:
> 
> I'd really prefer the task_work version rather than carving
> yet another path specific to msg_ring. Perf might sounds better,
> but it's duplicating wake up paths, not integrated with batch
> waiting, not clear how affects different workloads with target
> locking and would work weird in terms of ordering.

The duplication is really minor, basically non-existent imho. It's a
wakeup call, it's literally 2 lines of code. I do agree on the batching,
though I don't think that's really a big concern as most usage I'd
expect from this would be sending single messages. You're not batch
waiting on those. But there could obviously be cases where you have a
lot of mixed traffic, and for those it would make sense to have the
batch wakeups.

What I do like with this version is that we end up with just one method
for delivering the CQE, rather than needing to split it into two. And it
gets rid of the uring_lock double locking for non-SINGLE_ISSUER. I know
we always try and push people towards DEFER_TASKRUN|SINGLE_ISSUER, but
that doesn't mean we should just ignore the cases where that isn't true.
Unifying that code and making it faster all around is a worthy goal in
and of itself. The code is CERTAINLY a lot cleaner after the change than
all the IOPOLL etc.

> If the swing back is that expensive, another option is to
> allocate a new request and let the target ring to deallocate
> it once the message is delivered (similar to that overflow
> entry).

I can give it a shot, and then run some testing. If we get close enough
with the latencies and performance, then I'd certainly be more amenable
to going either route.

We'd definitely need to pass in the required memory and avoid the return
round trip, as that basically doubles the cost (and latency) of sending
a message. The downside of what you suggest here is that while that
should integrate nicely with existing local task_work, it'll also mean
that we'll need hot path checks for treating that request type as a
special thing. Things like req->ctx being not local, freeing the request
rather than recycling, etc. And that'll need to happen in multiple
spots.

-- 
Jens Axboe


