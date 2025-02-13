Return-Path: <io-uring+bounces-6406-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E1CDCA343D5
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 15:58:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE70E1889158
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 14:52:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7C3B24503E;
	Thu, 13 Feb 2025 14:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gk4Xe4vs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD8F241693;
	Thu, 13 Feb 2025 14:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458044; cv=none; b=QdSOHbqO/bHhVUSmy4cTPlVaAlph6n0+rkPHEUK72kmUSIgQAQugQk6sZAlvL7A9R0Qm3L81VL00SZYkDIckY2Tw41EbNAhobdlaZKDXRu2MD0Ivh73BRpMqdfPkGCtwdF9o67VuvgUQrgDO/Q5gycDWTW9HRBZVVNOvJ+Kv67Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458044; c=relaxed/simple;
	bh=I3jFuvHS8o4agGi7brMj/lvLVs781SP/e6tBVZBxD7Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tOA5ESgSxDagDgmIJPo+y77yg1vBQEzJ3An8N981CGvuDlv0++XdQC9yiURmsqqnL7mQgsvn9slVmmxocOpDoO7PH/DVQy4LiHZlsrH5lIJMLHvFsPVe7br/FL1KcoVSbnuiZlh665iNn4NOc10w9cb/sSAKoztH8bPpwUSq27Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gk4Xe4vs; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ab7d451f7c4so148157766b.0;
        Thu, 13 Feb 2025 06:47:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739458041; x=1740062841; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=06OYv2TswrzKR1suFIolZWczB03Gq9L+IFYKoiouClM=;
        b=Gk4Xe4vsLntXmeiIh0yrnhbAgP3GZB/xuk7qrbHh2nRWwKrEj0gMzbdEoOC5G/03dK
         ew97tpml7YIYKyDquRPsAlBci5Ge41mp3nhEwGnMj+BGPTQqQFnk6L+7IxiLeer9EAnV
         4jOPHvUtgFUe15Xf6LhgUFuJTb6QfyOPbkWm8Y03U/lV40UudU5WoB+tiHU8GkTG5R7l
         fhK3YaIPZMmBOSl7kDX70RwQL+CkLCTtB4xbwtcKHUNRFXekf7Xhd0/wLWVPIqwYBEiA
         NK/naRvyJko9ig4ECgbls6rOQ85S6Oyqn72q0khINqiqd42aXWE/TZGIx+ScVUPw7wMP
         nmKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739458041; x=1740062841;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=06OYv2TswrzKR1suFIolZWczB03Gq9L+IFYKoiouClM=;
        b=xKfdloMSXbIBtHtt4gzfVorziigBgOjJGSyijxUlBVKzCtL7a3/srhil/BMHST5QcE
         WXDoyga1/VfvgSFG1q0xpjFwNPOv9VPergSPv6a771SlT5Pa1urPTihZoUUd8aMdkDMN
         AHVqRtgEYBNnEAOPOKua1fGVc9S3K1ujl7RMANaKkXQBM3b6fbAa/R527+BOu1/vJw3x
         IFOwxRceHFVs05u4r9OUxhcUq2Yw20uQEUH7dmVC5pZdp5721SMVYj98BABUIa7+laVo
         0iTV+YhrLarNS+aqULrKGAUmndG+38KAbDL/nr2R++oqSe/ix2I5akiyGsLmEXy2CiZZ
         HeLQ==
X-Forwarded-Encrypted: i=1; AJvYcCVLL1cpE0NN62lUXf1i9UTB7YBQjzAy0poqs06oR8ao18tAi2xqFEvI0xunZAFssXftP8xhggygdp07cOD/@vger.kernel.org, AJvYcCVjbknwekLJYk/tAbuwvX/G6ZjsgwdPlCmsoNU/BoZZV+M9D+ofrlSnxhgYij7LCPF3oUkc51B63Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YwwHuK/f3hBQg1m+lwhaT91wtDMB3gbV0QnVPgO5IrMJBwft8T0
	jsNZ9Y3f4cwPPpZbXLDoDgeYxdmG9BT0rRkb/t09Zw6Eoku7SD2Q
X-Gm-Gg: ASbGnctQxBQby8QS4BrEZEkyd08oh6HZ9wAg6bW/Xbmwex21Mxw2WwYwRy8YD/xxTj/
	vvZ4Wg9TRZ4QSzhbFO+OCJGul8ncLbzUp8vd2pZOSRBgw3t1FoqmlYFPwDn7aGgEN6GDe3T4+5m
	IxkoIu8L83TEDm6EYKioQJh24f7lcKE0n0A8tmip6ctb54tUlmi6yoT8uBQQURi491nYhsRf/9G
	UyGhMFvR8sLzdtvwJUXfFbmYJID8MZCaPhZ5GqZzp/Ss0E5Du6X7eAnxO/ssKgTWe+iHRWUNIjc
	ejUJmm6dRvCs57S4IlZJvF6Ok4XulcDANYs00T18qTvN3bvI
X-Google-Smtp-Source: AGHT+IEitT4dyOw7PhDa6cc/O9Vw8vdiY1AHe/URB28OVtMRKKGyh0KUaTeNhJOT9eQLnFtj5scH4Q==
X-Received: by 2002:a17:907:7ea8:b0:ab7:10e1:8779 with SMTP id a640c23a62f3a-ab7f33d24e4mr804277566b.27.1739458040964;
        Thu, 13 Feb 2025 06:47:20 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:1cb7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aba5a4f4cb4sm65403866b.118.2025.02.13.06.47.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2025 06:47:20 -0800 (PST)
Message-ID: <5a8d2867-68fe-4c73-bf5f-dcecb6501fb6@gmail.com>
Date: Thu, 13 Feb 2025 14:48:19 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] uring_cmd SQE corruptions
To: Jens Axboe <axboe@kernel.dk>,
 Caleb Sander Mateos <csander@purestorage.com>
Cc: Riley Thomasson <riley@purestorage.com>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250212204546.3751645-1-csander@purestorage.com>
 <401f9f7a-b813-43b0-b97f-0165072e2758@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <401f9f7a-b813-43b0-b97f-0165072e2758@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/12/25 20:55, Jens Axboe wrote:
> On 2/12/25 1:45 PM, Caleb Sander Mateos wrote:
...
>> However, uring_cmd's can be issued async in other cases not enumerated
>> by 5eff57fa9f3a, also leading to SQE corruption. These include requests
>> besides the first in a linked chain, which are only issued once prior
>> requests complete. Requests waiting for a drain to complete would also
>> be initially issued async.
>>
>> While it's probably possible for io_uring_cmd_prep_setup() to check for
>> each of these cases and avoid deferring the SQE memcpy(), we feel it
>> might be safer to revert 5eff57fa9f3a to avoid the corruption risk.
>> As discussed recently in regard to the ublk zero-copy patches[1], new
>> async paths added in the future could break these delicate assumptions.
> 
> I don't think it's particularly delicate - did you manage to catch the
> case queueing a request for async execution where the sqe wasn't already
> copied? I did take a quick look after our out-of-band conversation, and
> the only missing bit I immediately spotted is using SQPOLL. But I don't
> think you're using that, right? And in any case, lifetime of SQEs with
> SQPOLL is the duration of the request anyway, so should not pose any

Not really, it's not bound to the syscall, but the user could always
check or wait (i.e. IORING_ENTER_SQ_WAIT) for empty sqes and reuse
them before completion.

-- 
Pavel Begunkov


