Return-Path: <io-uring+bounces-7954-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EAACAB3A99
	for <lists+io-uring@lfdr.de>; Mon, 12 May 2025 16:28:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B823019E14A6
	for <lists+io-uring@lfdr.de>; Mon, 12 May 2025 14:29:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 185892BCF5;
	Mon, 12 May 2025 14:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RJslSrDV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558694A3C;
	Mon, 12 May 2025 14:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747060131; cv=none; b=One/g09y85eAjugwGDfPWKd8+dbc2uTPFmN8mRk2+Nd7JEZv35Ksgi7EAJFf3rAid87lSx4ohL+Ynv/KczfV4Mqlo2zSnDc/AZeKZ/h9zndaxL125bJOwZIPzl3FgKOrJdEh0nkgMwv6yWKPUGGIg13sdOFeSv+ghjkB3pRmePE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747060131; c=relaxed/simple;
	bh=wAQSCOa8NKq0dKvOJ2tgxBAF7iZnMu3ypPhBo8Jdcuk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=fbUFyi4ZpVmrdHRU0pmOhKgG3Wqoolb7eXr94vLzQP4fCtPaYZI27W1cL+rqHBvAzYxxDW7eOD0gqhGzn8pv938c3F1ptu0dSSL2UGNyCzNBEUOu2kFggYN/u3ntE9wHnTuMapjjFBU+n7wZV7gUlgq3/5L7y4fG5lsp/pELsg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RJslSrDV; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-442ea341570so1174985e9.1;
        Mon, 12 May 2025 07:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747060128; x=1747664928; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8W12PO8Oqlmx8ERZBKdteNxpcbGu3ITArHrHNFvcMcQ=;
        b=RJslSrDVSWOjcCI0eor9fUQkw6fz1VdWdwmY8dvPya8j/QuF2YLOU1PFhbxKni/wrr
         fsgtPuG+OK/OzJMQDngwL8BQ+9ghDhE6RP2LVO6RCsI1RXNKq95FIazxGOhYo+IyREmQ
         HwO3jJ1keZhV4v3DBrBXtN0jW9jsr+mulFhzpcbslI4wzeQ6lp33f3EV97+XNHa3z0P2
         vpSCQz48v6w/WqYla/VeoNKPkP71SVDoMELQE1EjpJIvx7f29+4ALIhv/dR8S2tKmLDe
         pNN4StQmGm81QYaa0LJi97oy/3lhJxvzvT+BnbOhx2AuGqFQN+4wNHVP21KjUJIQjxuq
         8K0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747060128; x=1747664928;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8W12PO8Oqlmx8ERZBKdteNxpcbGu3ITArHrHNFvcMcQ=;
        b=Py4gxnzG3Zv05RgkXeHHZzyYFI0Fb786EI6a+dB6nBErp1rh4VYREF4+AHIOIpoXU6
         3ayXjDBHkhmwNAO6CGBPzOfGuQt2Y34wG9tnNXv2d6mQOHXfcmljZYMbTx7NZDtaYGw6
         1hHaf6chL0GzQYWiuRwzGuQ+drany+g1/4rt3FYukURdXvH0723A1vNB8qrUfiBBRe89
         pgNq/MBrdoWT0t5jyF3N82ctQZXcS2ueJGwI0czrnsD5LyOWJnIhUaK6j9nHuxi7Wk6F
         qXImh+oLhomESVH42h+Ei/Ni/u6AuhM7uo31y7Npa4SD/WxLrUMpHaM1mW2pXtkolBaG
         cQ3g==
X-Forwarded-Encrypted: i=1; AJvYcCVHi5jalfkKZxTm5kHUszfKU/J5YR9jTbqbRqZAlpw13Lj3ICA6x78ZbKOB790Xx2FwpmDZ7ppkVw==@vger.kernel.org, AJvYcCVzxwncshesynZWWIlagdox6t5NCCwmyNRrckoYEX12xTpEwqJ8bKIMkbXI+vw8tCkZdalxs43hNA9ku7c2@vger.kernel.org
X-Gm-Message-State: AOJu0YwnWNq8cXZbxShirX703nD9K+X4zpePW0pe7NJP1rkSwND4nQhQ
	mZD4A7GQzyJ0Q/Qb3uXYhnrfzSxPrL75v43DtuLJRQmIk60behQX
X-Gm-Gg: ASbGncvOamPb4Wg2YDHlNp7+IxfC30dGqVEkyrjctVWc9uv4OqMpMaUxANOZYhO+uD5
	CpEsc6g+oA+Qlp49VhupkRRNO+177WIHtoMX8za/aFR7x5Xdf8HyTGBGPyLeLDjfmWyvuS0MQP/
	mAWaQ74EgIKUYpr3eNPo0v08PoKVMKdRyr1uIiwwoQv47/E7B8px4lldvbiOY2oxcdHVUoEgeeF
	0Mb1O6yX9T8bWFKLl1ZCZjdoNtdv7kD9XFtEWUemA4U9/hzz4llyHHAvOgez0ylDKfReJaPPDTT
	f2sxOoHOg94GOwX3eNdP5Ob5txeurxScCdCxWzcV9G91lM3xBOQYcwns3tGLYA==
X-Google-Smtp-Source: AGHT+IE6Wl+pveujM6GjzrwRxgKqs4ai1C1+lBCqx+xXwjYNytZITfy6+2iQ9TX1sdtY4qOihXJz9w==
X-Received: by 2002:a05:600c:4694:b0:440:94a2:95b8 with SMTP id 5b1f17b1804b1-442d6d6b65fmr123365435e9.16.1747060127359;
        Mon, 12 May 2025 07:28:47 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.146.237])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442cd32f238sm168113455e9.11.2025.05.12.07.28.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 May 2025 07:28:46 -0700 (PDT)
Message-ID: <1cfb5382-8d1e-4c35-b8b1-fdfc69a831fd@gmail.com>
Date: Mon, 12 May 2025 15:29:56 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] BUG: unable to handle kernel NULL pointer
 dereference in io_buffer_select
To: Jens Axboe <axboe@kernel.dk>,
 syzbot <syzbot+6456a99dfdc2e78c4feb@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <681fed0a.050a0220.f2294.001c.GAE@google.com>
 <3460e09f-fafd-4d59-829a-341fa47d9652@gmail.com>
 <a132579a-b97c-4653-9ede-6fb25a6eb20c@kernel.dk>
 <991ce8af-860b-41ec-9347-b5733d8259fe@gmail.com>
 <69ae835b-89b2-44bf-b51c-c365d89dbb45@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <69ae835b-89b2-44bf-b51c-c365d89dbb45@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/12/25 15:19, Jens Axboe wrote:
> On 5/12/25 8:19 AM, Pavel Begunkov wrote:
>> On 5/12/25 14:56, Jens Axboe wrote:
>> ...>> this line:
>>>>
>>>> tail = smp_load_acquire(&br->tail);
>>>>
>>>> The offset of the tail field is 0xe so bl->buf_ring should be 0. That's
>>>> while it has IOBL_BUF_RING flag set. Same goes for the other report. Also,
>>>> since it's off io_buffer_select(), which looks up the list every time we
>>>> can exclude the req having a dangling pointer.
>>>
>>> It's funky for sure, the other one is regular classic provided buffers.
>>> Interestingly, both reports are for arm32...
>>
>> The other is ring pbuf as well
> 
> True yes, both are pbuf. I can't hit any of this on arm64 or x86-64, fwiw.
> Which is why I thought the arm32 connection might be interesting. Not that
> the arch should matter at all here, but...

Yep, there is a suspicion there might be something on the
mm / allocation side, need to find a good way to narrow it down.
At least we can make syz test patches for us.

-- 
Pavel Begunkov


