Return-Path: <io-uring+bounces-11909-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OK15MnHhdGmv+gAAu9opvQ
	(envelope-from <io-uring+bounces-11909-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 24 Jan 2026 16:12:49 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CCF67E035
	for <lists+io-uring@lfdr.de>; Sat, 24 Jan 2026 16:12:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 259AB301A2A8
	for <lists+io-uring@lfdr.de>; Sat, 24 Jan 2026 15:12:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2DE223F424;
	Sat, 24 Jan 2026 15:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mvzT/h/8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CCBCE55C
	for <io-uring@vger.kernel.org>; Sat, 24 Jan 2026 15:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769267565; cv=none; b=RudzcB68qLIk9mZHL2UqYgUAIU2+PuYJs6mk3dg+Ntq2Lp9ZZ1YiNMZwVinIodZ9WIDvb/aYKVrEMEUu2Z34NQgend3UPLn3SMj/ZDDBItqZSUxjUJR4E9IFbUWMKLIjGX9NuGxNVMKda4Y9g3F/YtnZdK/o3oKpt5jikz1cxAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769267565; c=relaxed/simple;
	bh=SfLYbK4qwgzMLEps2m9yiBpRchxa/dLatZcSZyvvCSk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=lwHlsOzrnr4yjn8YOK3xHSte/361Cq5YxOopT3q3cKz4987YbhqICgP8Mztf3TihWq06ojkaklBpujz5WKo+cdaxrAYpyMkMQdUhz4jbh1AgNqvq+akShzWdgT5/L7hZEGiDoi26/d97dKH6XvxA39C+tVb5CFmLuUG8NEFtgeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mvzT/h/8; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-40421de595fso2430476fac.3
        for <io-uring@vger.kernel.org>; Sat, 24 Jan 2026 07:12:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769267562; x=1769872362; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YqcprYZO2UOYJSbopZn8EqEc3e6W/5vS7pHhEadrWvk=;
        b=mvzT/h/8ACf9BSnaklP7CilL0Hzn5jf+vi0qflZa0Hm55B4goP92Xx0pPaWgd5N1V4
         EllHOpDWuTCRtZn/7V66eL+p7ODzyEA/7MFQS23ivWPNiHFAxoaLMWKWXmYCKBhZup1x
         0aT5oSME4M01RaEHn7DWhbiWxfSSd2D4IiWq93eT3j+isvWhbBAaZGiecGkNlB63Sdp3
         T5qYnh+6O/0sMZ5d09qWqN8f9o3CVSKjcu78RDram5vEV545jEY5YGF0bd4243vjVUGV
         Og7LNSfihrc/im2+bS7gpqHugJyHauTYDN8WU1099l1klQY3zws4ID8w5n05O5dDptzd
         ll4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769267562; x=1769872362;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YqcprYZO2UOYJSbopZn8EqEc3e6W/5vS7pHhEadrWvk=;
        b=wbpHokir0RwrmVXYjpA/M/qBhXsUl/dHyJSLvuR4hiu8mNoMvdCoalv8Zj7icM8q+l
         qI/R2w41eCebXVNFAMb0tQ3utl9+LzFX1WHO75yV7YnES5kFg7vN5yEruRe6IRb42GIO
         Jwke7Gwx5hhbvQIqrz768nM5rn7lqOyuxq0oSdm3/An22OMlfXzpSY8p7t1g4josuSKY
         NqEwJNVdSOXD7xargOr7l7KIJEcPJ5jdYq9NEbc22ySF4+VQKFGOltYD8TlULjX0R3hV
         sJP9Qid4spVy2C7xASvbvIm3aUPfar6MA57Nmv6i6lBKGo3/zSc5Fz5k9yp0IFE58Q1G
         2siw==
X-Forwarded-Encrypted: i=1; AJvYcCWxhde/QpjxpkmfwXd3rXfZv2QElJTWzBOoGnmfQkKJWVLbpaP1JD7h92pTDvbU2IohEtUFKtanXQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyCACrq/a/JD2EAiWfNiVQFwX/BO7WuyfzRNuB4zyABQb3gJCNX
	IONcaQE1jKPJ1wAjPvG4nNA6tYecu2EG/EqEzTMCPydSAy3/hXX2brZUdmTW3WVXZC4=
X-Gm-Gg: AZuq6aLwczuytYwRPtdmB/u82AW7Nnv9PcNUxv2fLTd/sgOiRta2c61FU96LhY5K+Lw
	ZKuWDN+NvwZ8pMhNySqStqLErN2/yZTLoTa/XzA6G9BQgTrj3h1CPkuuZoyGQFOdWbUcLanOzcX
	FCOxoggBNOd+cc13ilnx8B5QUCv/PCBmb5Idvoe7jYPZvulATzkKtLc0VESYDXYq0Uki+/b0+uu
	MecCS/Yfhoi3k4/UzwzRUIFCDJjXO8NUhGhZH2LDJ23MRQPr3fPq6teAdX0VgvK2jEwTN9UC8v7
	sUeMKXhZZ8tvdLkNLyqI2hk1Y2B26WEozs8Ag37C5w0CfYGLFylenQecMUGsQxQGbskA1BUKdRN
	nhIHglK5E+45GzO9Xb3I7WlWP6Ij5CQAhu02WCiDOmTBSZ4TiOT+W/fJnMFVfUiw+0wkGywZaqp
	hq4kyutQaPH7Wn7qjMOBCdkq6eausigTaNQYngvsWBzDoUU/XH4rDt5HHxIhNatoikBb4bnQ==
X-Received: by 2002:a05:6820:f0a:b0:65f:1770:de44 with SMTP id 006d021491bc7-662cab7f53dmr3105800eaf.63.1769267561431;
        Sat, 24 Jan 2026 07:12:41 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-662cb4f24fdsm2648779eaf.5.2026.01.24.07.12.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Jan 2026 07:12:39 -0800 (PST)
Message-ID: <30ee2371-f82f-4b29-9276-71b8cc12b87d@kernel.dk>
Date: Sat, 24 Jan 2026 08:12:38 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing 0/2] Add support for IORING_SETUP_SQ_REWIND
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1769034107.git.asml.silence@gmail.com>
 <176912275112.522897.5400530813917730862.b4-ty@kernel.dk>
 <517fc5f0-5e6d-46ef-800d-9ef4428278a1@kernel.dk>
 <d106a68d-e981-4239-b0db-21a311ec03a3@gmail.com>
 <2d2da3b2-74c6-4605-8d13-3f0cdc67191e@kernel.dk>
 <9c10b8e7-d64c-491a-96b3-fc26863e0dbf@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <9c10b8e7-d64c-491a-96b3-fc26863e0dbf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-11909-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_TWO(0.00)[2];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel.dk:mid,kernel.dk:email]
X-Rspamd-Queue-Id: 3CCF67E035
X-Rspamd-Action: no action

On 1/24/26 3:44 AM, Pavel Begunkov wrote:
> On 1/23/26 19:04, Jens Axboe wrote:
>> On 1/23/26 7:14 AM, Pavel Begunkov wrote:
>>> On 1/22/26 23:05, Jens Axboe wrote:
>>>> On 1/22/26 3:59 PM, Jens Axboe wrote:
>>>>>
>>>>> On Wed, 21 Jan 2026 22:23:20 +0000, Pavel Begunkov wrote:
>>>>>> Add liburing support and tests for IORING_SETUP_SQ_REWIND.
>>>>>>
>>>>>> Pavel Begunkov (2):
>>>>>>     src/queue: Add support for non circular SQ
>>>>>>     tests: add SETUP_SQ_REWIND tests
>>>>>>
>>>>>> src/include/liburing.h          |  5 ++++-
>>>>>>    src/include/liburing/io_uring.h | 12 ++++++++++++
>>>>>>    src/queue.c                     |  5 +++++
>>>>>>    test/test.h                     |  2 ++
>>>>>>    4 files changed, 23 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> [...]
>>>>>
>>>>> Applied, thanks!
>>>>>
>>>>> [1/2] src/queue: Add support for non circular SQ
>>>>>         commit: c22129cf0b8c936eb478d920ef84e53d89c6a5cc
>>>>> [2/2] tests: add SETUP_SQ_REWIND tests
>>>>>         commit: 346c063d16bda52f02d00feb744aafe35b4002a9
>>>>
>>>> Hmm I do think you're missing some spots though, no?
>>>>
>>>> diff --git a/src/include/liburing.h b/src/include/liburing.h
>>>> index 987b28aaf99e..016be1e80ef2 100644
>>>> --- a/src/include/liburing.h
>>>> +++ b/src/include/liburing.h
>>>> @@ -1702,8 +1702,13 @@ IOURINGINLINE unsigned io_uring_load_sq_head(const struct io_uring *ring)
>>>>    IOURINGINLINE unsigned io_uring_sq_ready(const struct io_uring *ring)
>>>>        LIBURING_NOEXCEPT
>>>>    {
>>>> +    unsigned head = 0;
>>>> +
>>>> +    if (!(ring->flags & IORING_SETUP_SQ_REWIND))
>>>> +        head = io_uring_load_sq_head(ring);
>>>
>>> The head should already be zero. Actually, sounds like the get_sqe
>>> hunk from the patch is not needed either.
>>
>> Yeah agree, I think they are both false alarms. Might warrant a comment
>> though. Or maybe we just fold it into io_uring_load_sq_head()?
> 
> What I'm implying is that the
> 
> +    if (!(ring->flags & IORING_SETUP_SQ_REWIND))
> +        head = io_uring_load_sq_head(ring);
> +
> 
> change from the original patch for normal 64B _io_uring_get_sqe()
> doesn't seem to be necessary. I need to take a look, but that's
> a good thing since the function is somewhat frequently called and
> inlined.
> 
> That would leave __io_uring_flush_sq() to be the only place
> checking the flag, so maybe comments would better to be put
> there.

If you have time, would you mind checking the current repo and sending a
patch? Looks like I messed up a bit and committed some of these bits
with:

commit 5d1c94f754f3bca156d84b4ebcaf2f211dcd09f2
Author: Jens Axboe <axboe@kernel.dk>
Date:   Thu Jan 22 17:11:53 2026 -0700

    test/sqe-mixed-noop: add SQ_REWIND testing

inadvertently as I was doing some testing.

-- 
Jens Axboe

