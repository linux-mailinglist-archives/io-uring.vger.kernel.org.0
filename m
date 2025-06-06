Return-Path: <io-uring+bounces-8245-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1149EACFED3
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 11:07:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3968C189B929
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 09:08:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7350F286410;
	Fri,  6 Jun 2025 09:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AQDIpVou"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB079286401;
	Fri,  6 Jun 2025 09:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749200853; cv=none; b=gexBrZNY4llyG10G57gpoo49ddpxvNi/M4bdSBNnasgzh+XJoZJzgMnTDMvLDnlmNHLFyPeweQtBAXgEf8lDGAbdnvDLTz8+SQOZLI4OF1DSILsP34AS27dfgV4T+K7HEUIS+tExNWWewS6DPB8R4cSI5GxH0WfybrmeZhSEzcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749200853; c=relaxed/simple;
	bh=RJu79twLB3zVVtqnqzGeaw0GNltlwqHSRHsrd28ZsYw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HG11aWkJWIjY2SdVNZZ0jJP+oOs6jKAMT8bctMWUlyhz07MRFFwvqVaqB40HpvHQWHekKe/Y/KqAaiDL+XNuwvyit7eNwylhgS4m08aTDSRohSAbLwWQh7/YyLstAfeUpKDNVzCWDT7x2wynE3M/e2LHWrw8gZH9H93S/xpb9ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AQDIpVou; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-addfe17ec0bso504192266b.1;
        Fri, 06 Jun 2025 02:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749200850; x=1749805650; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kuV+kYBStTw/9/uemryg5vRxLdplx0SsotM5yK3QdO0=;
        b=AQDIpVouuJ82OB91WAWXzSIi3DAC+XiLhAQiG+jSS7ojWwd3/lZORKq7q72Hdu4rl3
         QoJhQnVQyQ0DJVwWjDH08k/1aHvw2RHX2HfoA6H6krGE5kCckAeiDSmGnwv1HNeuN84e
         Iy1QZwjRJ4zeI4/QdT3u+hykAYqPUGC6ecyZJTBA3IG0kfqJyUbMWl/LGqWfxwv/nzfz
         eM5KDHKENJ5LkT+sgR6Be1RECrggKIJGPE1GMO0becdYG+njFjjEO9tB/5kxPho4g4Fo
         OoGafzNSlxqXI7PSkfy5z0JvLdRBSfsb9mTN5nsU0wPWC6F0joW7jjWylxzyEhPB5kjZ
         xlZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749200850; x=1749805650;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kuV+kYBStTw/9/uemryg5vRxLdplx0SsotM5yK3QdO0=;
        b=p7NaCngJwadTCKXbxq6X2uZTb1sCfIjbnLzWE95B/u+LlM6ILWlUbt2XoeVoIuYdLz
         1Kuhcn86gBs6fCx8rBTjXmK7VQ2QN5g2olCZO+s+EbXPz+Clxve7xvc/+KZtPm6ZrvPy
         6g7DV/gV7lrjVjPKbXbb5jYvupMguA4NvgLJzQ4zG+pUJu8cYJJkjR0M2QPZ1NH5VG4z
         sXCLvKST3Ptv54waTYYeJXcfCITyKCPYHeQ+KEm199OHIPi0aRJQCA0Q5XgEuZTVY8XN
         oFvijiX2xdS8vsCUZu1fVFqeQfpwbkcuWKbVYavRFZXmiAmTGnwT16VwI1welV/yEWQl
         pANA==
X-Forwarded-Encrypted: i=1; AJvYcCVznH39Fqm1Lg2Pm0zF8nPxmoTx6kQFjabXFkuCLn8/lC1ClZTQyA8+Y3jQZILuu9INWp1OP/mf@vger.kernel.org, AJvYcCXQAByt8YPstCAJs5CF8YV9CaTpLoR5lbrTFxzhcIM5L1gLvC/ZA2LIJw8UexQgNG+L2GNgvapIVA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzf6RqO+/1DWy8i3kYlbDc7pemXFCEv9V8/Q6Ev0cina6ooxCJX
	uzUFNkIPf0w6/AhkbKF2eqS53xBK/nzMnwSLSAB+6cEdDyOff+g3pyLi
X-Gm-Gg: ASbGncv8aVHflUgk7GvxIAhHwB7tN1NWvnyX7wjkKH2EFeCz+DnfxfXPwd5YHOY9usc
	w6A+ar/tia7lkzeBBzAA5+RhRhUOYNzfXHHFKmSxY1DbSm8olYmGTBdmd7qM9ulZdQeppL9fHPh
	gYC9ed2ZMGf3pD8XXfIZ9RvbQW+2s0zaCRoeGXvzK9xWJBfjLM2WtHVzV/1XnUkRZfdZFP+T2dn
	0gNr5hVnseDxA1XTpQzDFIK6FFSkv+D1Bo3Kx7d6CXGeDr0E1f9/J118ArLr9QfjHfgvH4jjSYE
	Vq0CIMitE3dbOJgQ/fs5wXCpvQrtUhYgfTxpkcwziWyuSBN/TJenlYlmCMP1GYlf
X-Google-Smtp-Source: AGHT+IESAWJGrh2yJsoJ2MZfo+rLzy1zNqvjW3l8mW+eA26lrDgDLKTvyvtpcRIntEvMCHY4B3hfcA==
X-Received: by 2002:a17:907:7f94:b0:ad5:2cc5:4496 with SMTP id a640c23a62f3a-ade073229edmr698060566b.0.1749200849617;
        Fri, 06 Jun 2025 02:07:29 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::22f? ([2620:10d:c092:600::1:3eeb])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ade1db55a80sm85125066b.42.2025.06.06.02.07.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jun 2025 02:07:28 -0700 (PDT)
Message-ID: <af5022a3-3104-4b22-b203-d3a086bba2a6@gmail.com>
Date: Fri, 6 Jun 2025 10:08:55 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/5] io_uring/netcmd: add tx timestamping cmd support
To: Jason Xing <kerneljasonxing@gmail.com>
Cc: Vadim Fedorenko <vadim.fedorenko@linux.dev>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Eric Dumazet <edumazet@google.com>, Kuniyuki Iwashima <kuniyu@amazon.com>,
 Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>,
 "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Richard Cochran <richardcochran@gmail.com>
References: <cover.1749026421.git.asml.silence@gmail.com>
 <7b81bb73e639ecfadc1300264eb75e12c925ad76.1749026421.git.asml.silence@gmail.com>
 <6840ec0b351ee_1af4929492@willemb.c.googlers.com.notmuch>
 <584526c3-79f3-42f2-9c6e-4e55ad81b90c@linux.dev>
 <CAL+tcoAPV03jr6p2=XyRhdC1KiZBojtqn-frBdKjh+0=f=G2Qw@mail.gmail.com>
 <449d5c82-7af5-42ce-bd69-00c2bb135a21@gmail.com>
 <CAL+tcoCTpFm+-CVZb-6=70ZCh3ERHrJ19MmL+u56SNFrkd2QCw@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAL+tcoCTpFm+-CVZb-6=70ZCh3ERHrJ19MmL+u56SNFrkd2QCw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/6/25 09:33, Jason Xing wrote:
...>>> Sorry that I don't know how iouring works at a high level, so my
>>> question could be naive and unrelated to what Willem said.
>>>
>>> Is it possible that applications set various tx sw timestamp flags
>>> (like SOF_TIMESTAMPING_TX_SCHED, SOF_TIMESTAMPING_TX_SOFTWARE)? If it
>>
>> io_uring takes timestamps from the error queue, just like the socket
>> api does it. There should be different skbs in the queue for different
>> SCM_TSTAMP_{SND,SCHED,ACK,*} timestamps, io_uring only passes the
>> type it got in an skb's serr->ee.ee_info to user without changes.
>> Hope it answers it
> 
> Sure, thanks, io_uring has no difference from other regular
> applications in this case. Then the question that Willem proposed
> remains because in other applications struct scm_timestamping_internal
> can be used to distinguish sw and hw timestamps (please see
> __sock_recv_timestamp() as an example).

Right, that's exactly where I copied it from ;) I can certainly add
a flag if there is a need to distinguish software vs hardware
timestamps.

-- 
Pavel Begunkov


