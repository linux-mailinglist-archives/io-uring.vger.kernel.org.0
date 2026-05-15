Return-Path: <io-uring+bounces-13354-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UODUCRUqB2ppsQIAu9opvQ
	(envelope-from <io-uring+bounces-13354-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 16:13:41 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 96B2F551211
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 16:13:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F32B7302002B
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 14:06:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B88B48B39E;
	Fri, 15 May 2026 14:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="tQuDzPLH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3466331F999
	for <io-uring@vger.kernel.org>; Fri, 15 May 2026 14:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778853979; cv=none; b=UyDJwfhyOcZkMEo/awe/Qde1+MgeZ4YuJ19rS6mVVwfVVWtzMtKAvVyRwfIzdy4DewQhaVFiOwmbw51DBvOnXn1Dj1UKBWBh0ddDWBGgPXBPYiyn9qpktJuuGG4TUIRmMXNNMM/s4lqOAeTnln1e4O5HSNLm7SBMsrO4UZeXSWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778853979; c=relaxed/simple;
	bh=nF+QzbQYy9tegaWBTmYwS04dI3CX2gR6KqOo1BG45Ss=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qaczhZlQdjTEW7o3Vnvruil9NEaNthmDwOI1FLt1Q8q8gwTj/YmPtsN3PVX5QRyTlX4ed/f4y0KNiwDb5eD7pEdq6cwh6RFSQgn4QSsgnEulE4V8QK6YFdYEr+oIbC1qwBVbVMiSu7uwL4QbckuDrfSBHe174v+Ab20UUOaRMNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=tQuDzPLH; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-479d85152c9so3884062b6e.2
        for <io-uring@vger.kernel.org>; Fri, 15 May 2026 07:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778853976; x=1779458776; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=78n6hIIqbrjsCZ5N0mrmRwrAUChmHJKkHuqZGpSbxn0=;
        b=tQuDzPLHPvIS1ld5xF7fY2HlPje+i+JrpKUTYijt2ckzYOT5xRBrTqzpeCjRCys4n+
         Kcg39Kw/5xDW1TH8U4ebrHEYL4e5RkVu8DEuT97jFgJnG9ZvycPu4o1j2oTbC9auEEKp
         JzYlpUoIpCcrpWXTIXPm1lO8JCyx48LAwhwDqibUkuT3qj4YQZ3NFRJn5ZqAdVFyNAVD
         P3DBkKcYhB0NHhVQFnunL8DZaXLp/VU/m9Uzo3YL8vfv0LZr6CIr5GowPoev/WT6H0rX
         ztpCbTdaTQgDQm0tEWMbuBrSklXwTfT/0EKGlmm4x/P0Qe7I7moUC/A/ZTg2U8ejABxQ
         8jSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778853976; x=1779458776;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=78n6hIIqbrjsCZ5N0mrmRwrAUChmHJKkHuqZGpSbxn0=;
        b=ppfq2j5frVQeP1KFJbKbRfO+DvqI3rJqvHEQcTUO3ZnuYLUxeiZ2DklKrKXU3BvxVM
         3GFsTg9TLeHQxelHguXxJwiwYKRoJKwOyqWM3EC5iKMTuXTH4uSxAepfJ0WtNJyF+lBl
         A3ACXRifBUt++vPA359pSUjdFN2NoDaxy9AP4LB0dTPdcGKIMCABSczVfc/NaDmDs43L
         r6mcc9oq8g3R+721VyOVSCfqzFstgtvnTPK5beI4enxIljT5GMtDjoIKQtD59ZxIB5N+
         SJf+InurYxAQz3vP5h5MW/6y6l2Ai4ENKmDen05o6ZArwts3HzinKCWFGeYLiXIMe6rV
         i0KQ==
X-Gm-Message-State: AOJu0YzcCqd1hm3JOreGyNWmPQ01inQbVUsjzritUmlrRjjwzuPEput4
	SyLOjYIJxGmwl30FjQQta/3cgAlZ37Qty0ZPxjxwcmoBhP+Gg6WQJlQWebERx6EoJHE=
X-Gm-Gg: Acq92OEssJCGvTCnjH7ZUDSltjh+uxe9AhRfZnHvM67y9iXgZXzNCaJBpQeyewWpkOb
	Eu2mnfSIIz8cXkmmJMAqy39vggg5hgSZ6baK5L2UYrgVjQe5NCgmVkZBwI1M74GGfH6s+smAmZk
	B1oTQO/rCSoe0Zj2iy4Y8hU5HVOiKQY2PesicoX3dvIkC3u5VsB9iIW6z5qoucvEN3ilYqwq6ii
	l6naXiQw0OpSFbHYWTPlgt0JtaNB0oYnYI5xdfXGJJvBjB4tFmkMaQWVNfJcTZNceyUfM6c0rOU
	AvQXNkiit+CneYGq6zOyQrwtJOJaIO9P1QStH+4pqpF5CpkTuuXokJpD1aPz/sKl7YjWVY9Kv8G
	CNA3l1rhvlGKrQJW3Os2RiYIxTaAlRvBY5tsjp2Z7oBMoRoWFIgXUL6r0Ozi/EK2uxEhr7RaGrB
	0Wlb89c1HXUw6ifGZyMuL/4wG6JSDGeXMr47DnHvRO7segW3OKs/ZuRaMudGnh2cbXgt3Ja5XEf
	mN6fD5h
X-Received: by 2002:a05:6808:6ec5:b0:482:4dbd:4fe2 with SMTP id 5614622812f47-482e56c09e5mr2482778b6e.15.1778853975872;
        Fri, 15 May 2026 07:06:15 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-482ee333d00sm871433b6e.3.2026.05.15.07.06.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2026 07:06:14 -0700 (PDT)
Message-ID: <49e77605-6227-426e-8103-329474bf88f9@kernel.dk>
Date: Fri, 15 May 2026 08:06:13 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/11] io_uring: Use trace_call__##name() at guarded
 tracepoint call sites
To: Steven Rostedt <rostedt@goodmis.org>,
 "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>
Cc: io-uring@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 Peter Zijlstra <peterz@infradead.org>
References: <20260515135903.2238731-1-vineeth@bitbyteword.org>
 <20260515100448.715589f6@gandalf.local.home>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260515100448.715589f6@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 96B2F551211
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-13354-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,bitbyteword.org:email,kernel-dk.20251104.gappssmtp.com:dkim,kernel.dk:mid]
X-Rspamd-Action: no action

On 5/15/26 8:04 AM, Steven Rostedt wrote:
> On Fri, 15 May 2026 09:59:03 -0400
> "Vineeth Pillai (Google)" <vineeth@bitbyteword.org> wrote:
> 
>> From: Vineeth Pillai <vineeth@bitbyteword.org>
>>
> 
> Hi Vineeth,
> 
>> Replace trace_foo() with the new trace_call__foo() at sites already
>> guarded by trace_foo_enabled(), avoiding a redundant
>> static_branch_unlikely() re-evaluation inside the tracepoint.
>> trace_call__foo() calls the tracepoint callbacks directly without
>> utilizing the static branch again.
>>
> 
>> Original v2 series:
>> https://lore.kernel.org/linux-trace-kernel/20260323160052.17528-1-vineeth@bitbyteword.org/
>>
>> Parts of the original v2 series have already been merged in mainline.
>> This patch is being reposted as a follow-up cleanup for the remaining
>> unmerged pieces.
> 
> This part should go below the '---'. There's no reason to add it to the git
> change log.

I pruned it.

> You should probably also state that these can now go in individually as all
> the dependencies are upstream.

I think he did, at least that's how I read it.


-- 
Jens Axboe


