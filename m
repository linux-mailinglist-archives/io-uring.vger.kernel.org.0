Return-Path: <io-uring+bounces-12247-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WL3GGcQ2k2mV2gEAu9opvQ
	(envelope-from <io-uring+bounces-12247-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 16:24:52 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BDF0A1457F5
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 16:24:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BB5C43047052
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 15:18:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94E02320CA9;
	Mon, 16 Feb 2026 15:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ZpyVf+XG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4713218B3
	for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 15:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771255126; cv=none; b=oE+ulmujA1mJCdT3rIuKHOS528FJCN7wRN6mISgxtLJ+ROxzYD89RRaei04EuSwItR2uqUpTAfJ/dQxaY215p+6WFNQ8yOLmXE2akly3N/gdK0CYiTGFXr2HCQZN39XGmQqg9iHDwyN77stj4ElcujSeBTsLvcWwHM/mJ54JzHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771255126; c=relaxed/simple;
	bh=7q0RKV3IdkkhJeFEs3BavJiJ+arthFxw0WLD8uQ1XZ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A6ylsrRwCVYMkj9+nenDPDLW/Dlwb4cbeXyvTcxxz2qjLtn2mmJQD9yjJfudNG4p58QU2t48+wGWprqtNZu1MSIpLJXyXjtXI5QoFhQpokP0GBu/ghcyURP9hvqs1qyLMthdRHNgMURnJTM2ZWTKn3UGVvbpgM/1mXHAjD3v/9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ZpyVf+XG; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7d15b8feca3so3889166a34.3
        for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 07:18:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1771255124; x=1771859924; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tysseZpmf8fckvxYvgGdMxT1h2rzxCV2cwV2N9mdo4o=;
        b=ZpyVf+XGDQwsvM5GLm+x2lwW/Tb+3yop9SR+E6jgWc9mioo5FjeJEc2EbWSo4HajpR
         4WartCGItVe7mN1+E2oSF4Gng8mj8oGvswFWwox086iJea79ZwBv45ISLJrpUrgDqauC
         q/ApaEk6hxDHQV+5Y5XLwTAgpyzkQOOpx2soAbOOxxUVOzvwvD4V4UDFTuzSF83L2e53
         HirtKaGg9zBL2VbpElgF1D4zJe/qzPpPyd3YvGH+bZ1tc04Rnyaw+ue/9SAFT8GhIqjk
         sB5bKaBb90fwWeMt+bbnWhPG1Ug+gfJkDa+9Q0lWMujl0JXq4sG3xB6H/0fJEhcsAKJ8
         l6ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771255124; x=1771859924;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tysseZpmf8fckvxYvgGdMxT1h2rzxCV2cwV2N9mdo4o=;
        b=ckKP0hZKqlmiPLaXQ2op+rr8wEpqC2uPuhQ4wTBZ2T7S/88+eES8W3/GX8g9TqSQ0L
         bHHVfqHrV3ZRXOIEdDGlUQUDQ5GBElhLu7CO0Ccg+gD6lbWqTItLuxn67cfMhef3Yaaz
         NzSPYqNjzC2DqYgkyW3Rn+3JY6CyapUOuD1h1sCjhE3feOnIWh3O/Mo1W+VYv7oAxHn+
         IZzTOfLUIc65fUUjryXC8inqhLtnl5F2RuQaI8HMkmvBeZZZx9pA1rD1sKQgUCNka1dG
         ueaUcX7ouFoy1XEtruJOELKgKHD5csFZqdJ5yT1JsT7MGG2wBWOkeDlx+sLm5WZKpAA7
         x3kQ==
X-Forwarded-Encrypted: i=1; AJvYcCVodH510byExozSwWchodid6xWktaEWGTanAkfthJUi6rb1TteZw7CVAjuEalfK5pKekZAdiQPxHQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxVCT5M90ClSgqkfnFEkeKoo0N0jlhQnuzeyDl9cxvc8ZYwkxt+
	+aLv+3wZgKSYvum2sc9xRh9wYVUfvP8CFVDcUGWnZoVJmePdEXaNnSkEF6spkbe5i48=
X-Gm-Gg: AZuq6aLpUhS/2wKE0HsBCfS3JvH76tF9e4sH488r5BdpxaA7/xjstdeuNbsn9yXF61S
	xpz/Zs8JZ6jF7kzQRLyFolNlFi4t+WcBWUUPi8Btj7NP/aHSEgwOuaM+rN0tnEhfvY48LICXvC6
	LJVYwhwjs81c017WKOICsRSvvKxDus0BpKmqpGzvEbcsAKgTQiINhNBPRLTARPbeI/PI+P7LDBq
	TM3su6Wt1MJhu2W+iQYgEUqOxB2M7ngDNEkMsCUfd2D/FufYnc4swlyPkIsWFXS6lqiz+xIui8z
	1/uRwJm9Mtp4nkJ3LH/d4ZOBDyoV+MnweWMD1Pj7Sarw2ayAHkJr+EyVR0JHzyVxiKwIHW5mWOA
	VLZpK4Q2CSc0X2iCVV2V0m/p2Ddkw+l0Rf/9KPwlkv2YHvyPmjELpOdc4WLfIz9jJa4y/xL5EcH
	aoUF6Iup6iPuxmPUSCd/9YLmkguaBcyKGG0HaS8neuyO+qzKcTdaAS04bE3j+ZdzdMXxjUmV6jy
	kkDEKRKMw==
X-Received: by 2002:a05:6830:f8f:b0:7c7:471:55ff with SMTP id 46e09a7af769-7d4c4a14747mr6077995a34.10.1771255123953;
        Mon, 16 Feb 2026 07:18:43 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d4a76f96b8sm12707223a34.21.2026.02.16.07.18.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Feb 2026 07:18:43 -0800 (PST)
Message-ID: <ab4c6ffd-d7d2-45fc-bbd5-b6663d5c41e2@kernel.dk>
Date: Mon, 16 Feb 2026 08:18:42 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH io_uring-7.1 v6 0/5] BPF controlled io_uring
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: bpf@vger.kernel.org, Alexei Starovoitov <alexei.starovoitov@gmail.com>
References: <cover.1770836401.git.asml.silence@gmail.com>
 <d56b5f70-382e-4017-81f4-c9ae7a6c1b56@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <d56b5f70-382e-4017-81f4-c9ae7a6c1b56@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12247-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel.dk:mid,kernel-dk.20230601.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: BDF0A1457F5
X-Rspamd-Action: no action

On 2/16/26 7:23 AM, Pavel Begunkov wrote:
> On 2/11/26 19:04, Pavel Begunkov wrote:
>> This series introduces a way to override the standard io_uring_enter
>> syscall execution with an extendible event loop, which can be controlled
>> by BPF via new io_uring struct_ops or from within the kernel.
> 
> Let me know if there are any concerns or comments. There are some
> parts that I'll need to add like timeouts for waiting, but those
> will be natural extensions, and this feels like a good base to
> move forward in general.

I don't have any complaints on it, but would be good to hear from the
BPF folks.

-- 
Jens Axboe


