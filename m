Return-Path: <io-uring+bounces-8227-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 57A5BACEE3F
	for <lists+io-uring@lfdr.de>; Thu,  5 Jun 2025 13:00:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 210547A7919
	for <lists+io-uring@lfdr.de>; Thu,  5 Jun 2025 10:58:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93F63219319;
	Thu,  5 Jun 2025 11:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MxDOuHFT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15F3218858;
	Thu,  5 Jun 2025 11:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749121209; cv=none; b=kw09TSxX2yH2Vn2D3c1jojK4pUNBlZhGVirF37fTFseKEc4SZ02L8lKpiai69+7UMurlXAQXHBzvj1nH8XzTxgWMpMozSPT/9Qgl0v2n8RaK2QCk0Ia+E1YGFjMM0RQO1grDJz6Hh7ko/EaTeP5qhh++KQS+2b/sgcOolfAyYSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749121209; c=relaxed/simple;
	bh=gy0PlaWJMpFUhNzdqSMMjrBgYzG0qVD4uK2KE+RdU6I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jZ2jOM1keo6xMzsucByG2zs1jjQrBGOOAyrE+3YS4VU6VTy/TtWu6JrXA1aCn0VyxMDpoFqcyWc4R3dxVcsQORHmu8/7ZddGJ7YVY6EesOPw5G94aXtsz+UcCJq+NZrb7fITdhKfkv7Lcv+GQLgia8avtG+Z4mQOPtcP6ss+hZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MxDOuHFT; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-602039559d8so1717983a12.1;
        Thu, 05 Jun 2025 04:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749121206; x=1749726006; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WUmFockmtpKkDAq6L0xHuFskCQH95SHxZOP8X9Fm76c=;
        b=MxDOuHFTrImD0N1qwEz7fw+aQmS/RD6g2rIeG0vQ4zILqUau5iPMG09rTSH/SKab9K
         zWpb1PkMaZfiG+GkCZ8ZSBZbxnh9Yr7yZS0aBVQU7GZZSWaN4E0pIoec6A+VNEauoI7f
         oorT2KdYX4Kr3SAPYFG+cm4V+mPLcnUwoEJ4Ybkm92UUVAl0xdhGPkrVLbhsGDfannoa
         AMUm+7OqRolWOqwAK8yt2x9rd36xLh8yiCVyeJMIs0Tolwqew0PfBy67+qhZDIIVmq6y
         lHdU9byUsR3ydpY+nK3+AwJV+FOnmXYfl80cXWU1hehNA79z7C8bMFnJr1NBMHmGMUk7
         I2wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749121206; x=1749726006;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WUmFockmtpKkDAq6L0xHuFskCQH95SHxZOP8X9Fm76c=;
        b=q4qkLpxoyNmJB+UtEswZrfs+XVKTqXUTMc/sWpGy690lv7+VvfoonkUN3tbWcVQJmM
         h5CBIme0VV43qFTG+jF/BHjgHseE2r+N/YaaIF0o8n3OsnsFNhRR59S27xBxMcuMc0MY
         u+7CSyXkF1cwR9LWGegkteV91LVURexgw9UUEf4B5n6h1+53vb7i2hj6KN5CNZijn7jw
         DA/mLxKGYmLYcwqXYC/TETrcg7rsn+56uidUlEuxAJH6RONGxYLb6bD9hgkZOdldqrti
         OeYNdM454WyBGv1FZtfOmWN5cB+cKDZI0q2LcqTdDFUfYsBNfuoeUIEMNHteekg3LD/Q
         yPuw==
X-Forwarded-Encrypted: i=1; AJvYcCURtxBPFbZFE5e1Rb3t4rtmp2mWw9S0Ojh88yr5nM/hB2l51UFF4s4W3HVbaa0i7r7h+RQ6CKtkiA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+UHRWJdaW211z+qHaD02l9t0tUgprwjkr+hvVlz4I4MHY6Ckj
	hLlvLYlwEiAONC660SnCeFz7DyWu68Tx3lAvyVR7/pss7YJRKzTIS0WX
X-Gm-Gg: ASbGncvIF21/2k49wIXsguKox/nY4nvWhA0AR/llywaKml4RlwtWMclOlP/5ApwXD7P
	O8Y1QeGE1ef2r25tWFgDmXHGN3Oaj1wuMCw4+HGY8RtxfFU992E99f+19d8K+hAHQvYwq/ophAP
	Wv/7/tGV7eI7SjHfptjFAzYxCYhNrr7SpvZETIzIrHW0enH1ylNfEgTU2qs5ZgSyE97Y1ztiA9g
	SXa7SzqDksfYj7FN9rNi44fhRp8LJwmSZJtBXUUyUOV7jVYX/jsUNmeIyYkoRv3deKAKbNwIpjF
	uC+nMNFxoZ53UEevwggAPEo+MCCrlEZ6OHFciiAqlDZdVns6Gzg4lyGNtcHYEKqu17m5XdPRW3U
	=
X-Google-Smtp-Source: AGHT+IGMzR0cpb4Wu2xPjQVHJtZ27A85YcDXUvB4wm9ZFHBl4LigF58XXU+YaCZM+PpLruo+JUgkrg==
X-Received: by 2002:a05:6402:26c3:b0:5fe:7b09:9e27 with SMTP id 4fb4d7f45d1cf-606ea165cdcmr5820576a12.12.1749121205910;
        Thu, 05 Jun 2025 04:00:05 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::22f? ([2620:10d:c092:600::1:d66f])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-607290dbea7sm862419a12.51.2025.06.05.04.00.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Jun 2025 04:00:05 -0700 (PDT)
Message-ID: <71075232-3d1a-4c0b-b4c2-ef426bb923eb@gmail.com>
Date: Thu, 5 Jun 2025 12:01:24 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/5] io_uring/netcmd: add tx timestamping cmd support
To: Vadim Fedorenko <vadim.fedorenko@linux.dev>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>, io-uring@vger.kernel.org
Cc: netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Kuniyuki Iwashima <kuniyu@amazon.com>, Paolo Abeni <pabeni@redhat.com>,
 Willem de Bruijn <willemb@google.com>, "David S . Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Richard Cochran <richardcochran@gmail.com>
References: <cover.1749026421.git.asml.silence@gmail.com>
 <7b81bb73e639ecfadc1300264eb75e12c925ad76.1749026421.git.asml.silence@gmail.com>
 <6840ec0b351ee_1af4929492@willemb.c.googlers.com.notmuch>
 <584526c3-79f3-42f2-9c6e-4e55ad81b90c@linux.dev>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <584526c3-79f3-42f2-9c6e-4e55ad81b90c@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/5/25 11:25, Vadim Fedorenko wrote:
> On 05/06/2025 01:59, Willem de Bruijn wrote:
>> Pavel Begunkov wrote:
...>>> +
>>> +    tskey = serr->ee.ee_data;
>>> +
>>> +    cqe->user_data = 0;
>>> +    cqe->res = tskey;
>>> +    cqe->flags = IORING_CQE_F_MORE;
>>> +    cqe->flags |= (u32)serr->ee.ee_info << IORING_CQE_BUFFER_SHIFT;
>>> +
>>> +    iots = (struct io_timespec *)&cqe[1];
>>> +    iots->tv_sec = ts.tv_sec;
>>> +    iots->tv_nsec = ts.tv_nsec;
>>
>> skb_get_tx_timestamp loses the information whether this is a
>> software or a hardware timestamp. Is that loss problematic?
>>
>> If a process only requests one type of timestamp, it will not be.
>>
>> But when requesting both (SOF_TIMESTAMPING_OPT_TX_SWHW) this per cqe
>> annotation may be necessary.
> 
> skb_has_tx_timestamp() helper has clear priority of software timestamp,
> if enabled for the socket. Looks like SOF_TIMESTAMPING_OPT_TX_SWHW case
> won't produce both timestamps with the current implementation. Am I
> missing something?

I'll let Vadim handle the question as I hardly know anything about
the timestamping needs, but just wanted to add that it wouldn't be
a problem to pass a flag to the user for distinguishing sw vs hw if
needed.

-- 
Pavel Begunkov


