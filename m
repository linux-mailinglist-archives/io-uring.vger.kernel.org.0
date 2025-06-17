Return-Path: <io-uring+bounces-8406-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D419ADDF05
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 00:33:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 68B56189C862
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 22:33:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3F02291873;
	Tue, 17 Jun 2025 22:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="e/eqM891"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215232F5328
	for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 22:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750199605; cv=none; b=jYE0w2pk4L+X/nuA04Ack6gn2/BOhnnsWlrzKnkFiDMWsIe2mjFxNX4aDAsZHY4Hpwes9nDuW4eubhz3f1YMZry+A5F599abnj7MjK61ph3EYk4YkDJYmoY7Zgkd4LUPSdhC6Wb27+STq6Jmsk5Ued0USZBlNW0OI03iIh0vHsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750199605; c=relaxed/simple;
	bh=Y3MwOdUYpwk3tTLc23wnnjl1UZcfd90X9B+cDvo6nAM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P7W2Sk4c06KFIgkhUHX7CoEFmzqrX/rGXhxP8tFZZG29XSv/NPKhqZ/CsT+Ux2gvk8NNCD+i8k3ICTUmuET3xmoISjQY9elRGa1vYA8hTW+EEoUdstJvo9DzlQFAXoO0qGCMQLNaPihOWPWv9yJN1yCMWpj62iRJ5sl5QeMWdK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=e/eqM891; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3de1875bfd4so10501095ab.1
        for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 15:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1750199602; x=1750804402; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2+V07Mi99fepwrQzUpn29u/f6EdNWvUOOx6RPmGncW4=;
        b=e/eqM891z4etRpclCuzLn7sLQidT2Mg78JPCGgx5/Su1IZVwpuUVBrvpEwZNYTxHok
         uJDtwW9SIGrebK1gh732iSeubskp73zh+NPNMiaFg6d64zStKAdcX5/rm97wt+t/i/Tq
         R6MXhHcr23uKPjKSoofZJSZtc4EJZf/wjWZkQ0L0HT1MD9PtkOKwyEq5q65BYL0TlFPg
         jfiuLadznkTMQVS+Vvi8arTYHJE6znzHvwVYdfnhtfrG93vFDxVhRIupJUVDhDz9RThQ
         hndSF2GLXHlN27mBVk2BJrisQCcJS2w/4qUNOB/NA0Sypz5X7iVut5hfrnOe9DG+E3YX
         1ktA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750199602; x=1750804402;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2+V07Mi99fepwrQzUpn29u/f6EdNWvUOOx6RPmGncW4=;
        b=AAKu8Cr/idUUILB24ff+0vSgXmb57viCw4iXGSbTFiNPKNYKV8jMO7UmLTlzTIo2xC
         ee/PF9vwtv67MQbmgFt2ixTkaP6J9FqHuFsiSZjBni0Px3UxLZZDTirje0bztQYiM4iP
         0ySRgfFWsHyoqcX7bkW8NBcIGxN9QE4vtQaN4Q4c5O2N8Zo40lhiFaneLIGFwEAAucPh
         nK/v/wHIck1HD+EFJEjneX0MlfnEEVOpNIjSoXurfhOGdOhxVHfzxG+CDFtbhTxbHV7G
         sGX281ysmo3pjF0ygwmzvKdV+T3n31OQ7EjG2CMRWwyOXLLJIpscVQpnE/LDsTUjH4Il
         ivQg==
X-Forwarded-Encrypted: i=1; AJvYcCUKeBntKtyhWBj8vcLZdOvOJL6HiWI4xZuj/hdsdRqJtUzV+xhjc6GbQStUNG3ZLTTsEjJvfxmqTA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxIoT56q0rAd/juLoiJWz1kSHPo8lS2uuJATe48bzOc5aP+vUL6
	ORcbJGman3FoCYhs45iZYqi41uroBAEyakB6WKus8U4cHo6tu33/mB7bRhgB3k2PDLQ=
X-Gm-Gg: ASbGncunXSbW3QGgyNWWHToklt5qCFM92RFWphzOZDjNO4+LSKVTCDqqDUA2iedXjqU
	Cc066Ywn0xWWAxhFnJpNlFnBcQCSPiYFnTJiEHhB2x1kXQlQwpPuk5UZts1FVCOlYIdK34ugawl
	wI4LeBLozAAzxhp5CacJfFgn+WkH4oukmHqRJi7y6BDIhKnPam8whfN4IIMB1yHRkykb7SvKcIw
	guzmI11shMEtnHrZGDuDEEEn1LGJ5D9VQ59fCnKKX8gKCDxiNCnRjnSXAoZ1AodWT1hHW30DO8g
	zQFMG8DpWmJUxy7Pq7Np4wX9GBYIhfpupQjtN016DPOh7MS2nVmd5E4kbFk=
X-Google-Smtp-Source: AGHT+IFsyg3rsPZHKbkh9W1z44yEj+aXsz4/o0ekC1vERnXxCZ1J1QJAGt/IKkXCw9g5eQ73HZ5RBA==
X-Received: by 2002:a05:6e02:3304:b0:3dd:cc4f:d85a with SMTP id e9e14a558f8ab-3de07d12d0bmr175799775ab.6.1750199602156;
        Tue, 17 Jun 2025 15:33:22 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50149b7ad66sm2411459173.25.2025.06.17.15.33.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 15:33:21 -0700 (PDT)
Message-ID: <520fa72f-1105-42f6-a16f-050873be8742@kernel.dk>
Date: Tue, 17 Jun 2025 16:33:20 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/5] io_uring cmd for tx timestamps
To: Jakub Kicinski <kuba@kernel.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 Vadim Fedorenko <vadim.fedorenko@linux.dev>, netdev@vger.kernel.org,
 Eric Dumazet <edumazet@google.com>, Kuniyuki Iwashima <kuniyu@amazon.com>,
 Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>,
 "David S . Miller" <davem@davemloft.net>,
 Richard Cochran <richardcochran@gmail.com>,
 Stanislav Fomichev <sdf@fomichev.me>, Jason Xing <kerneljasonxing@gmail.com>
References: <cover.1750065793.git.asml.silence@gmail.com>
 <efd53c47-4be9-4a91-aef1-7f0cb8bae750@kernel.dk>
 <20250617152923.01c274a1@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250617152923.01c274a1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/17/25 4:29 PM, Jakub Kicinski wrote:
> On Tue, 17 Jun 2025 08:52:35 -0600 Jens Axboe wrote:
>> On 6/16/25 3:46 AM, Pavel Begunkov wrote:
>>> Vadim Fedorenko suggested to add an alternative API for receiving
>>> tx timestamps through io_uring. The series introduces io_uring socket
>>> cmd for fetching tx timestamps, which is a polled multishot request,
>>> i.e. internally polling the socket for POLLERR and posts timestamps
>>> when they're arrives. For the API description see Patch 5.
>>>
>>> It reuses existing timestamp infra and takes them from the socket's
>>> error queue. For networking people the important parts are Patch 1,
>>> and io_uring_cmd_timestamp() from Patch 5 walking the error queue.
>>>
>>> It should be reasonable to take it through the io_uring tree once
>>> we have consensus, but let me know if there are any concerns.  
>>
>> Sounds like we're good to queue this up for 6.17?
> 
> I think so. Can I apply patch 1 off v6.16-rc1 and merge it in to
> net-next? Hash will be 2410251cde0bac9f6, you can pull that across.
> LMK if that works.

Can we put it in a separate branch and merge it into both? Otherwise
my branch will get a bunch of unrelated commits, and pulling an
unnamed sha is pretty iffy.

-- 
Jens Axboe


