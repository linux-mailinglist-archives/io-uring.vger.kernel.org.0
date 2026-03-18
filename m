Return-Path: <io-uring+bounces-12748-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UEHqKUMSu2nGegIAu9opvQ
	(envelope-from <io-uring+bounces-12748-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 21:59:47 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 136302C2C76
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 21:59:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 56BEA30A1734
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 20:57:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE1ED36F42B;
	Wed, 18 Mar 2026 20:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IC2kP4F7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832A836AB50
	for <io-uring@vger.kernel.org>; Wed, 18 Mar 2026 20:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773867431; cv=none; b=JaHEgkJVH7HRR/9N5RofcVyIR/gW4yY7qd/RsEHuSAwZA+Ij4xYKWHoSBG5CgRWBMgJ8IiF2CvKhdBD3mGlCHDeMLBkJ40ugAPYPTuOPjcj/ZgON8r6ObwyfMzXHE6wNgsnLy7aT/6tjtm5FmXDtxD7WMbKcqnM6DFxGyKtW284=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773867431; c=relaxed/simple;
	bh=9BOj4B3BJn6RvrR2EUaO9bMmHwZybGM/+dcXHFRB2AM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=pLPxnfX6usko1+sKSHkhdujGUqUxRaaPY3h0Ki0fAXhzjl4kaZquvgvHmUZfJSCBe74SQ5UXCO0gam4RbEbh7QUd/1eG9R6QSKRPL/6cqJVleSy9IV8bFHjoXN1TMu35TfoODaGQQKLJ9UzxIYJZDVpESANmBOy44WsfY4OmBfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IC2kP4F7; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4852fdb36a8so2982295e9.2
        for <io-uring@vger.kernel.org>; Wed, 18 Mar 2026 13:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773867429; x=1774472229; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=96oMzm9ntAQADrP1ug7rRdmxOQbWP3/pWQ1KD1TbzJ8=;
        b=IC2kP4F7blxkX7g7mOlwnFxmCTwrdZ2hO5abPoSEnoYcwKoEUPSDAWHYbCaf4rxmEC
         PN8M4ym3IaJkdsBdP4PtsMTxDQsQPudH7toXq4oNeWTW1GNzm/tZvDnkcw1W9y4KdsP6
         Jb10nF6AUSolBOHrR+T3ramWe/z6t6JKG6dOLVPaz6273FUqhH6jMMwsMhUrfm80Txpb
         TBqQT6TSmPM58QInmV2avwDtyTqKOyoeRta6/rHeKgwWMR6hmBgLb+DgE+R0oEMazn5c
         lB4f3xvDFaVPshe1gRCazN2cK51sxsDH193D6Td/K5nNPAN8dVN58nknF1mbw1BkhpiV
         2VeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773867429; x=1774472229;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=96oMzm9ntAQADrP1ug7rRdmxOQbWP3/pWQ1KD1TbzJ8=;
        b=mdSR8kLLFXBk8bANb8CPhTJ7gm3gkpS5GA/Y2bQP5Ep5ygguAypc3HqgQ/iL1qSDJ9
         S2VOaqUDPgToNaOYLmc/xCajnL0DJPeCEvAa2wzxxq8nYA+syUUZVdMGUU1m5i/i1Xax
         qJTsDqErJuSNFEwW50yX6OvaLefWB5Sqfdh8Z0wo1UH4i+En5RIwjN1Xw3Pcw6gqroVE
         iX9BY+rRXm+WBAUUMPAMmfMxq+unPSYX+XTauY02F9qXf7LFUZj48FO5BDzBrho29w2u
         rev6JAgG4AcvdYFZny6Dd1ucWnp2r5I1okaBYEwdFTajZwgJutkKtq74753G5LYHDuIM
         d+cQ==
X-Forwarded-Encrypted: i=1; AJvYcCUjKHH6WDPabgZPMynCZV22dFp8FJiuo3MDMHax54H7MlLc7Smn/jm1fDvdZ6FA5NQpKM9baEp9Kg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/0mF1Sq2njnSEUSXx5TrDmQx9AABNHkRr7Ik1nvKGD4z26P2f
	ZvZCwvK8eYAdSCS5G1YH90oy46M8s0vn1RQo4i4GScUuK3jYZTzxboh3mlbtBA==
X-Gm-Gg: ATEYQzxH4R0K8rKffxawlxWOiwptiMKOvQCI6NP1T3eksmrDvOwE+GIEK1+TLQHhOnA
	WRW4epT5Zye+zbELXmQ7tRDl+JdkPv6+9m3sqEb/MQFJmsxWVuEgxu+385tSkpoet5NRuUhODqG
	UeqyffCwfLMIBbfXeI3Qy8MW2do4WIAawpgkbTLfVOVgW6K//H21i2bBdmTsF4pMHHV7i8skr/n
	BPtrYvbmk9wT5ciD8d/t5U+4uqK7BfKFjhzxREzE4S8X5OFLzym/IuxZqoAEJgvUfH4BwBWGSIh
	nTf8bAZXMA5dFMH3hJbHnkM7/W5a4rNIjuVHP/s6P9nY4LlfR44maQ54eRFQDwUH3bB5QyH0/r1
	90NK+Z+NFJiuQ6ZxCk//18NbfLsucsKAWiuBJMx7m2NCcqn7vqO6jdn8c9cNx+9msXSVDmHeWo5
	y4tAQlterHdvyOvrJKi1xOnE+21QQRLPlCxtBIdGaMPNeSRyJeI8PSDWwVMixF19havNC/NVXQ+
	o5oGg7ZW8l9CkTt6+4LNTS34FJdPcW/UX6ofwvpnXWCHVNkHSdvWpLI6RfHuyxz41fYp3fwbxNP
	YA==
X-Received: by 2002:a05:600c:8b45:b0:485:3ff1:d5c3 with SMTP id 5b1f17b1804b1-486f442e5fbmr77709825e9.5.1773867428531;
        Wed, 18 Mar 2026 13:57:08 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-486f8b1fe65sm17790455e9.5.2026.03.18.13.57.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2026 13:57:08 -0700 (PDT)
Message-ID: <c3443f66-5de5-4004-9de4-06ef9d1aa146@gmail.com>
Date: Wed, 18 Mar 2026 20:57:15 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v3 1/1] tests: test io_uring bpf ops
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <8c9cb9cf824e09271df9c6d6d4398e514d9c5733.1773855222.git.asml.silence@gmail.com>
 <6b9ef71d-118c-46c1-8f33-56145ddd8664@gmail.com>
 <3c00370f-81b0-41d1-8deb-beb1781a75bd@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <3c00370f-81b0-41d1-8deb-beb1781a75bd@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12748-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-0.996];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,m2max:email]
X-Rspamd-Queue-Id: 136302C2C76
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/18/26 18:24, Jens Axboe wrote:
> On 3/18/26 11:43 AM, Pavel Begunkov wrote:
>> On 3/18/26 17:36, Pavel Begunkov wrote:
...
> axboe@m2max ~/gi/liburing (master)> make                                        6.490s
> make[1]: Entering directory '/home/axboe/git/liburing/src'
> make[1]: Nothing to be done for 'all'.
> make[1]: Leaving directory '/home/axboe/git/liburing/src'
> make[1]: Entering directory '/home/axboe/git/liburing/test'
> mkdir -p output/bpf
>       CC output/bpf/nops.bpf.o
> In file included from bpf-progs/nops.bpf.c:3:
> /usr/include/bpf/bpf_helpers.h:318:12: error: conflicting types

I assume it's an outdated libbpf causing issues. I'll kill
vmlinux.h, should be easier this way.

>        for 'bpf_stream_vprintk'
>    318 | extern int bpf_stream_vprintk(int stream_id, const char *fmt__str, const void *args,
>        |            ^
> output/bpf/vmlinux.h:170697:12: note: previous declaration is
>        here
>   170697 | extern int bpf_stream_vprintk(int stream_id, const char *fmt__str, const void ...
>          |            ^
> 1 error generated.
> make[1]: *** [Makefile:379: output/bpf/nops.bpf.o] Error 1
> make[1]: Leaving directory '/home/axboe/git/liburing/test'
> make: *** [Makefile:11: all] Error 2
> 
> 

-- 
Pavel Begunkov


