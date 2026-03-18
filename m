Return-Path: <io-uring+bounces-12744-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qDyoJ5bruml0dAIAu9opvQ
	(envelope-from <io-uring+bounces-12744-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 19:14:46 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FB3F2C114F
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 19:14:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DFD7B33B128E
	for <lists+io-uring@lfdr.de>; Wed, 18 Mar 2026 17:43:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E28031B839;
	Wed, 18 Mar 2026 17:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iOSC1xTs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0153451B3
	for <io-uring@vger.kernel.org>; Wed, 18 Mar 2026 17:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773855797; cv=none; b=JnREmwyne8/S4Y30/vuciYJz2J+foRJjBJWvokgQggr40GpfZ32cc7UICabN92vfotRQbAiC0Q6U2z4YdMhqGD6fTm/mA+yIs3ETspB1tZBi8SffAnYzwmwVuQ6zHV/1mDmvra3RxoMAD8B6IhoEHZMZVkVk6OrbCzhNUF7EmUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773855797; c=relaxed/simple;
	bh=gCUWMgCmISucznEKZgqGmDScW9+Q3HPH9ggae12wBNE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cDWQhFlHNmlOnwvw1QMLz/WDh/hS/NeuCwdvrjogEXMcpkXOxEbj3wOo0+m4hqn0xq7TxQZhbSN/RGhrwdPu4LfDtQiYATqPU+rE0DCUsMk2iZ/vMr4kp/aNesVE3SMqy74wBAJrZtfXxYd+8SCJSfnGcyjb/cjTy01bV5C45Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iOSC1xTs; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4853c3c2fe7so714105e9.0
        for <io-uring@vger.kernel.org>; Wed, 18 Mar 2026 10:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773855793; x=1774460593; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RtLQ0iiUPVfJBg3XUkfxfZWub6Bp+WL1236Cgy4rp1c=;
        b=iOSC1xTs3eBQuwLosAlNV53SiXhIpFqIPhjYpcteVF+r1sva9V6xCHqjiV5Vu29Mm0
         57j8f5/gCK3/OdJmJyMUVXikFl4Fv0Ip32GCUbFXSPcnnAQSMeQ2VqTmIZj0jpqZs/jx
         qyzqCaxAo8tpUMQ59XOja+jj7BmMQ1bSC09cDLI8/rI9UKlyJk/Y4zHhRLeQI3lfkL/T
         TxIvV9KAGn0ua9WEjeGiOgUGbFgtC3AV15KOQHzoCMQNiGmhjySRNknH9N1BgcaUyDyD
         y5oxmc9+AERzn3MiA0ctZW7wZbXVVbLPsOAOzUa92xW+hD0b+LaNju9Ru79OCbc90cdr
         BZww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773855793; x=1774460593;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RtLQ0iiUPVfJBg3XUkfxfZWub6Bp+WL1236Cgy4rp1c=;
        b=KYxy465vSozGkZNIoRh04GLQBklIzWFiRuvnMLaXr29ps6x83NcEhBbyB0bYGuvA9g
         tZ8VGenHMeRbtezV0kk+j+sI7iJLL5FHvhH+ltYzLAdqi7rFRYNOaJTbJHCMho03jE3O
         o+rgzGns8LA5NfB5rKyaKPsXuYRfhfQefaXFlPmgJWqSXPbEGIksFtfgLRv8RoodR2fF
         4rYAL4+WlfHfQbItqT1lqdppS4BE51ahRGeg81tp5OqrV/VZmR4pxc8vwF78PNc6Name
         2wO70KN2fSlHet/yQVCcml/5cJ8d/l5En+zJaFBkrVBkRUKYZ+1GEriBUP0p/9/V6vwn
         riOg==
X-Gm-Message-State: AOJu0YzO01sDI8MNC93x0L47JoWOQJhxxKWUQyE35XQ3qiif5kqcHpTb
	0F57S+6WCN8xHwTkefNNWOkr9BKF2/jUdcx2lYc7RN0yuQrQnmDd00jie1UZSw==
X-Gm-Gg: ATEYQzwryX+h730XdWOrhv1aWBn8M1qu58TY9EWslBRyD9HRPiglCOocrFp2rtZfJOq
	fXbn4/Nf1f1bSLZ7eFQcRKBDydpNnY5Mh2hRGtNVWdafq1DI8xxAa6/HWQmYKfWDfiWrwMJ6Ri1
	1cTE8yRWXkSYYVBcTwIwcjHPzXEWcHCETTfqpLX/tH4rV+hbmRHpkruAPxtTd3SS6Rr7OPsCooS
	CPjnRxauO3yLiCciotXiaPufVuIUsGtSmIc8PvEaDskGfLfP1A9WG8ltUJ9nbVr0GagfN6Ts1R4
	pM04ExiJtvT44bXVT6lwyoS0xfqs/oP1tuYUwGIA5hv/sbhMQu18sqD8Zd0lwANL+J3gKqkp+Am
	AzG2/3GWNj4GGrE7CDjLxEBpibfPVh8A8jFc8eDhCTQob/sPHkXJU9P7jEWBgSdiTDA68H/V4sz
	VubFIVc+BvLfmviHl26HSN9+vp8DTwxdr2CI6QkLo6Z6/SWMAazuh+R6FFXtihLh+8YIvr2pCLb
	8mDpofnmr71lo8CTIYPhrpzIG/Di4epT09ViMM=
X-Received: by 2002:a05:600c:3f14:b0:486:f8d6:5dea with SMTP id 5b1f17b1804b1-486f8d65df5mr3517745e9.19.1773855793360;
        Wed, 18 Mar 2026 10:43:13 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::18e? ([2620:10d:c092:600::1:ef29])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b518a3d78sm10312719f8f.34.2026.03.18.10.43.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2026 10:43:12 -0700 (PDT)
Message-ID: <6b9ef71d-118c-46c1-8f33-56145ddd8664@gmail.com>
Date: Wed, 18 Mar 2026 17:43:20 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v3 1/1] tests: test io_uring bpf ops
To: io-uring@vger.kernel.org
Cc: axboe@kernel.dk
References: <8c9cb9cf824e09271df9c6d6d4398e514d9c5733.1773855222.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <8c9cb9cf824e09271df9c6d6d4398e514d9c5733.1773855222.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12744-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_NONE(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.997];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0FB3F2C114F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/18/26 17:36, Pavel Begunkov wrote:
> Add some BPF struct ops io_uring tests/examples, one is issuing nops in
> a loop, the other copies a file.

I needed to conditionally compile based on whether vmlinux.h contains
io_uring BPF definitions, so now configure probes it by generating a
temp vmlinux.h. And since I want to be able to pass a path to the
target vmlinux, it also became a configure parameter. Not sure if there
is a better way to handle that.

-- 
Pavel Begunkov


