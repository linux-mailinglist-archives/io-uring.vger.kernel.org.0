Return-Path: <io-uring+bounces-12679-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uOpDAGSWtWnL2AAAu9opvQ
	(envelope-from <io-uring+bounces-12679-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 14 Mar 2026 18:09:56 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id F126F28E1BE
	for <lists+io-uring@lfdr.de>; Sat, 14 Mar 2026 18:09:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0ED15300A5AE
	for <lists+io-uring@lfdr.de>; Sat, 14 Mar 2026 17:09:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD0DF2777FC;
	Sat, 14 Mar 2026 17:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="P1GEqLKP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B14E326938
	for <io-uring@vger.kernel.org>; Sat, 14 Mar 2026 17:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773508188; cv=none; b=qQTnsR0o0U6C4QeEAUvwAvCNWBg9q0+I7F7G61TcI7Fd4tK5/ZnZCfpCs1QVR9yegWYteEoiy7kAlzKXg4Fp0DVpdf2AKgZ8l3h53hBpBjRlOF1+cS0egA0GIHYuHmjWZC8tkQn7d3VyqU7EeMtZksuuh3/2oQymtsyA16nCahY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773508188; c=relaxed/simple;
	bh=KbDbq8LzhtyLbhc/41b7hMLVj+GOORJR4RcSsu++yKg=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=ISqW5zOlr8+Oys9dAg/qNZZkD/oLXd/KvyHMYUgwF8zsYTLowgno1A/SDDwCFz1CeJ3CE5nGPOXWCdRceaUSZL3iE+BhfPQIvlE9YGy9pBuzc9Cr/+75KI8eA9NJ5UEcLnBXJn1Puz0Z9HIS0NBnu6avHLlvXWxG2Veq93FgtU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=P1GEqLKP; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-467166cb638so1241912b6e.2
        for <io-uring@vger.kernel.org>; Sat, 14 Mar 2026 10:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773508184; x=1774112984; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NOcx55gTKm3Y3vuikiSQ8RmjqcTa3AOJczNzUcSvRd4=;
        b=P1GEqLKPJoePgbCO1hK3zioLC1hHg9WDZOKk+tN2uYN9PvmKg+78HMsSfv0EXHt3o4
         T9nmNErSRidfMuffxvEzTYiuc2zccNIG6mXD1WqSGgjcxw6Zm0B4IDoHmOZ1yXMoOz6O
         5G68OhzX/h0HZ50mPeb39IpSxSA9z8pjTMUafjWo8zCDOJ4NS6z4DYgs6Ei/HyPigcrh
         boN+0Q4+ksKXW/eU5nR6BlrVInZ4d1C5G6XSGx81z1L2wklCTqlTP886O3hhWNY3CULB
         9MisVX3LX4Y2L18ShKgqyqaKHPSGdAHPBqCOEo9Sp9UCaUK++sI31G7G3tNw9+rhJiAd
         ZbPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773508184; x=1774112984;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NOcx55gTKm3Y3vuikiSQ8RmjqcTa3AOJczNzUcSvRd4=;
        b=sM7N9IkwfUpMf+3v/vrKGks4AXDE7CY6wll/Au72JnsXaMpAHBFYCQTKv2OcA0/o0k
         yGW4DZ+v4gUNcRoHHQ+79feb9GSnklOCG8945G3GYWoY6UeUre8koheMyHMvO2xDT7xy
         Ehakyou2FnUc8b7/GNiO/gnQZZwrsJDHqzPM34xKgnnzctPDe5xZDrRo/klj9FTod982
         imq2H2lUJr8DE2hphd8MslltiYH2IEZmgjKlC5CK6+/U8XBqNZ26gce14xE+oQzk5cfE
         kWcPMBJgiePDudk6cu27FxMHT7nTnNjh2KGOq7zPiaY6fqAFqIkKfKjYpJzajJkrFVuK
         PBfQ==
X-Forwarded-Encrypted: i=1; AJvYcCWmyYnVQQ1uQt5F9eiKUJobepSVBNvgyWH3W6lJhLw82wBiZ8VKYGyUL4Cxbo34SkCzXmXKoPmEUA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwgJwmOrZsIyx8F732VAwbSctVzHloiJUHZsiF3X1ZwSmxlS89N
	txSDsHzd4jPNdmQ+7YwLxvb1Qp4LeZ/5SyXp59yQJSa3zxo1ridA7jqyb3/ifDxeCqo=
X-Gm-Gg: ATEYQzzuaGmIhu8x1mmDl4IYElvt+H5n5ZQUmUQBnZJ+pygWXJj74nOy8hAbVoJt/Gf
	oATHgqJTVx11krpWk+pt5jN/WqTwoGZd4u18tv1DAvZpuJsjEY1eW2+y4qbVKE5dJ+qbqiMU3do
	UWRNRhsXl6iU46HqOd5dOpoD2ECCk3iZNyVAp2WjYiaCwk68IrjaTFWwM6LQu0zN+Dwdjsv/FAk
	lzjZi2wOKeqOCQ4P9zz058ZDiwUtaalR0afSYUDq2n2OlVMp5NdLmTdL6ZxxFOf8EnTZuRYmwcl
	I4UVWQZCpxOeOxT6fZT/HKexfh7qQ3IYUOvgGoVS9UVHhMVM0FTF1iD6y+I3KzgNgdIiRo48nEO
	NBhqTMKFJFHo8NAbbF5CF4b3lPejCvzutd87TLUdgx3SGeBmEB18VpKZ1gVO2XiawpTGokNqjfc
	KoVesXKEFn1QA2jsLGcTthqq1roLLnVpJn6wUsdPA1PQU2WYGOtsdR3LHClGPXrIGXcve/fIUYN
	5Y48CluzQ==
X-Received: by 2002:a05:6808:2218:b0:467:143c:7733 with SMTP id 5614622812f47-46757436877mr3747308b6e.46.1773508184405;
        Sat, 14 Mar 2026 10:09:44 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-417a2372b13sm8112343fac.10.2026.03.14.10.09.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Mar 2026 10:09:42 -0700 (PDT)
Message-ID: <0c0806d0-3fe1-4602-abe1-921b0ba0a853@kernel.dk>
Date: Sat, 14 Mar 2026 11:09:41 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] io_uring: add IPC channel infrastructure
From: Jens Axboe <axboe@kernel.dk>
To: Daniel Hodges <git@danielhodges.dev>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260313130739.23265-1-git@danielhodges.dev>
 <20260314135053.3334-1-git@danielhodges.dev>
 <873d56d8-6c1c-447f-ae70-870417c6de5a@kernel.dk>
Content-Language: en-US
In-Reply-To: <873d56d8-6c1c-447f-ae70-870417c6de5a@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-12679-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20230601.gappssmtp.com:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,kernel.dk:mid]
X-Rspamd-Queue-Id: F126F28E1BE
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/14/26 10:54 AM, Jens Axboe wrote:
> On 3/14/26 7:50 AM, Daniel Hodges wrote:
>> On Thu, Mar 13, 2026 at 01:07:37PM +0000, Daniel Hodges wrote:
>>> Performance (virtme-ng VM, single-socket, msg_size sweep 64B-32KB):
>>>
>>>   Point-to-point latency (64B-32KB messages):
>>>     io_uring unicast: 597-3,185 ns/msg (within 1.5-2.5x of pipe for small msgs)
>>
>> Benchmark sources used to generate the numbers in the cover letter:
>>
>>   io_uring IPC modes (broadcast, multicast, unicast):
>>     https://gist.github.com/hodgesds/fbcd8bb8497bc0ec2bf1f95244a984fe#file-io_uring_ipc_bench-c
>>
>>   IPC comparison (pipes, unix sockets, shm+eventfd):
>>     https://gist.github.com/hodgesds/fbcd8bb8497bc0ec2bf1f95244a984fe#file-ipc_comparison_bench-c
> 
> Thanks for sending these, was going to ask you about them. I'll take a
> look at your patches Monday.

Just a side note since I peeked at a bit - this is using the raw
interface? But more importantly, you'd definitely want
IORING_SETUP_DEFER_TASKRUN and IORING_SETUP_SINGLE_ISSUER set in those
init flags.

-- 
Jens Axboe

