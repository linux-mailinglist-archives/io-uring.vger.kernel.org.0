Return-Path: <io-uring+bounces-10926-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id B6186C9D983
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 03:50:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 6AF3534A17E
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 02:50:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2BD119F40A;
	Wed,  3 Dec 2025 02:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="TB9aVId7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA0A1F78E6
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 02:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764730197; cv=none; b=Hk62UhFiAi8yDMxXG050D4rvwe++gm+xcN8cU3JNmiQ8+Zm0I8ykQEPd2VdygpQelZV5cSqzjMXAM2x/xl5/MrTs0xNnRlZ8Ls++ZlOhvXf+DEWuQBFy3JAWtXjp2jtGVTdHUFwV7pCNbGLoFu/wJazwLrPSdj8l0S6RPjGKDd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764730197; c=relaxed/simple;
	bh=+SMUFTqSfSupSY315YkTU6knxzgNSVCGMK2J1YGklM8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OadXmXPAex/dysPwBWYnMZeuoRzU7iRqHJzi+3XxsjBvuvEQqG9Iuc+THbwtxe8NkUu9iWYnzTq6liFOx7b6c+MkN7RSZjmCQ7PDLCTjD90n67QDxf5wvEbrhbiWx12R/Wz+/1NKRxzEYDoXLXNUYwY4ikHBDEoCLltTwEa5FWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=TB9aVId7; arc=none smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-65745a436f7so2766830eaf.3
        for <io-uring@vger.kernel.org>; Tue, 02 Dec 2025 18:49:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1764730193; x=1765334993; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zWurfHVhbSZHk9QLaaCbFGrEdLwAA2WH7JL/j4Pv9S4=;
        b=TB9aVId7L/4ijw7DKyqtBaDkd7LAvNWI67Mc0+Pbgx6JE6RzqQD7223yB2TJ7GBZi9
         jo7I18AlUgKDhDli/c4UjlSum/va1s46t70vaAk7gLrFdA7t/HNLWXwPQzcxG9i0Rxyi
         ETyBwx9LQg1khlgCCqumR4XQiDxYDTKnz/xMiLlBf8mokkToP65aP+cCbfodwJaHsZCs
         C4AVC6bUv5TJku3gOs6QZiNgehotiT4GlbkKlS73470pE2jeUf2fNoPYCh6iYN1pjAj9
         /0WRJ4hK/LShQZO8ZlJ9Qj8LBAWNwcU6TVKUzDQRVkvzRatv0AphaEzq6lqWuG5dMbdL
         U5fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764730193; x=1765334993;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zWurfHVhbSZHk9QLaaCbFGrEdLwAA2WH7JL/j4Pv9S4=;
        b=WPy+Rb1Mcpqgdokwqf82vYLRQOey8BqUaCzbK65hmKz9H9txcK4DUHaH3bVG9VUsn2
         ltbwWo44NtFrvUcvbuRrU5wEIfEPbGEsj924LU5BPc9a9rciWAeErLxLZo5FmuoE9o24
         MExEnCsgKZuVGPunY2/uPW5EZ3LNVNs4Qzr1mTueSUgCdZc+IpA0OtBOIvm12eN7ZkIE
         Fv7+NgePBj0kGjVj9IxP65faIl8G6HnZxu2LPH/hJYqAIRfpYW4FvGcsKvn0SCxhxbpW
         HjQ5lvlTjOaQBuwPJLAlehsf8MjIGs9B0RNfBExaCsXxg11FKtoPXAGK+jYnFE5cHqc7
         g4Kg==
X-Gm-Message-State: AOJu0YzcZgFRGFx6tjudBuoMPIhkaSmA4Lez6wOeTtgqkd7x77hR6WBP
	sAYkLM3TdqqzEzKQ7fC/9GWvb/TBd/qNaId8f1n6vCGrGWWCl5o48Y46Zg47+DIrphGrlUphGaA
	md7SFNpk=
X-Gm-Gg: ASbGnctJIKMihowdn/h8o2/JmQNPpkt1tPBUxezFIZjaBIFPZ7ZnDxDWZKYbW2Qa+wr
	8vFxtrd7Kvi+m66o/hvxImUGHALczA9EqT5Awsu4w/+shPG4OQt69yay7gwmw+PKI/tWGtrGd5I
	h2qoc3UBoYijxoIi32AhRLbYTplw+zwcsa99mbKK3h7oLvRYhDaxEhgFo1IRzsDwr0kJUqrMTvX
	YG9XOMGcYVSdNCENYSSGbiAwiv15dk0YpC+fqaIOYrjo2MojQsNbX6iiV3qxQpmUjTieuLES4j5
	apWHDboTrpMz0NwMMQhLD2g5fxFdZJIjeeYnnA8Fyo0rQhn8mnNEcXDVuYenMnNT0kB0h0Uk3v+
	W3MUERlajqY95Fgu9QbYktHgjO0uJgCWsvB90eUF4hvMiWVunUQUCV+8wR58mqDYxQQ2ilY/hou
	wCTrUqzTQF3V/ZniFkZ5I=
X-Google-Smtp-Source: AGHT+IEOF3iWXSsUpf2Y/kZkaR8eGIQ0dAm1OHKoAGNsA2c+EBt7Ip09He2whZpRbsLABoVGhbLlmw==
X-Received: by 2002:a05:6820:f016:b0:654:f77a:1a5c with SMTP id 006d021491bc7-65972713912mr525929eaf.3.1764730192835;
        Tue, 02 Dec 2025 18:49:52 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-659332e0031sm5053211eaf.5.2025.12.02.18.49.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Dec 2025 18:49:52 -0800 (PST)
Message-ID: <b774faf6-d6e2-4828-8b1e-2ae440cb1cf7@kernel.dk>
Date: Tue, 2 Dec 2025 19:49:51 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v2 2/4] test/bind-listen.t: Use ephemeral port
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org, csander@purestorage.com
References: <20251125212715.2679630-1-krisman@suse.de>
 <20251125212715.2679630-3-krisman@suse.de>
 <b8d9117f-7875-4b12-a747-5ee80eb5e1e3@kernel.dk>
 <87sedsh2vh.fsf@mailhost.krisman.be>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87sedsh2vh.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/2/25 4:37 PM, Gabriel Krisman Bertazi wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> On 11/25/25 2:27 PM, Gabriel Krisman Bertazi wrote:
>>> This test fails if port 8000 is already in use by something else.  Now
>>> that we have getsockname with direct file descriptors, use an ephemeral
>>> port instead.
>>
>> How is this going to work on older kernels? Probably retain the old
>> behavior, even if kind of shitty, on old kernels. Otherwise anything
>> pre 6.19 will now not run the bind-listen test at all.
> 
> Do you have a suggestion on how to check getsockname without doing the
> whole socket setup just to probe, considering this is a uring_cmd?
> Perhaps checking a feature that was merged at the same time?

I think just retain the old code - do the getsockname via io_uring, and
if it fails, then fall back to the old code. Then it'll both exercise
the new code, when available, yet still work on older kernels still.

-- 
Jens Axboe

