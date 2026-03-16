Return-Path: <io-uring+bounces-12712-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oOICIA6RuGkUgAEAu9opvQ
	(envelope-from <io-uring+bounces-12712-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 00:23:58 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 096A82A1ED3
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 00:23:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8472B303AB43
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 23:22:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBF9D379986;
	Mon, 16 Mar 2026 23:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CczJ7RB7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D26737269D
	for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 23:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773703377; cv=none; b=LifQXnH2r29fik29yILJC1dff7GO3PYfXtJb1Ch4LwBEEZOupCyDFVV6gMtqOSM5fAlD5hiz6uANT9/XfkCB9YG9jq1bdPrtt093O+JznS2syi/M82oMMxKZuqk+X0Sq+WcYtqF+VcQcZe2WsjErxK9H/mLoJU9GUHsp1T+zLCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773703377; c=relaxed/simple;
	bh=LAKl72ZmaO6iexowzgNQBKY1zqj80RT76u4H4EhUFWc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PkB0b/ZEmyDAeRq4E8HKiWCbRXr6sp3P2vPDD74rmFgMUUuH1PS4RREx2KUfIZ0XVmJRJXGTU42PMShCeJop0G+exX4+nJZ6yDhSw8O8D7VVW16s+qO3+IS2g4BeILENKPol38jtirpSeNjrX4aSjFNnyFHvNMQtLvST1LLXcUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CczJ7RB7; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4852fdb36a8so60002745e9.2
        for <io-uring@vger.kernel.org>; Mon, 16 Mar 2026 16:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773703375; x=1774308175; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0P6yT4kuIK+aAZf2vpQSGaWL6i0OapbU7Os6PrAW52I=;
        b=CczJ7RB7n4GrAR/cGCzPhtInyovLGg96XaFLUYPqlb7I8E08Li72Kx79mm5IUpuQAi
         fZC1EprbiAhDzYywJ8T/HVkWKyZn/8887viMAR7z2HnGoqtdLpDzATSZYWJPXJG1MqRG
         qPEZAgn7GGhr29n8yz1mnDSlHwfp6+vI62TMXG9SVb40unsxPzUpnYFa+oVJXq07jcSW
         DzkTmxhRapqTvAdLCEo+eZAIqB+SQTUXxirjd2J/ujjzSdGf3R3BpzGvsf07LhdlL4Mh
         2V+1g0R5bveXa/Qnx+U4wrikjgDjdD+L13u7E1vf2q8s3YsKW1Mu5W+RxLNo73cTGGG1
         2uXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773703375; x=1774308175;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0P6yT4kuIK+aAZf2vpQSGaWL6i0OapbU7Os6PrAW52I=;
        b=ik6eUbq9hOqIwP8gbKAlHN1IIM1BrdBD9q3zupQSYh325gW8YEQh0sw0bciPApARDj
         xjwcG5G3xei9+AZMrQiGUspTTBeVodkAR8dIpvR73ssEoaPQ8qeDAHud+S8NKDBv86d/
         k9fS5NRh4+xWdhtzU7UB2M13Lg9lE3b0fcm+U4MlSQSOByRrxk1MZx+eoMxYY1xMeR6D
         65TLjCax3FZ6D184cr4EnQYmqmtYChabH559oQliu/YIKVgO6wBBxRrtkFUdRdKvrp1l
         bSCXsddf8r0zOlU4F4qWxSQ7Uc16UguOVP6UNhA9tfwLLxE7qRYGEmkVjMo1W1xlGm63
         Mzpw==
X-Gm-Message-State: AOJu0YxJXYUtjNbODXI3pmOoVGbDk/FP/B1B6vIfOWO7/ZOhKIpKoOT6
	XMSn1nURwlffOx/5/Mv3KOzBONhGjs7iNJ1lkDxajFxaVPqfUzBE/PLy
X-Gm-Gg: ATEYQzzntBf+PGkbFFiuxYVBqGWGt8Nd957ZU87mpbwzIAjV0aMCj7RJ1NqU/MvsL/K
	+zkNQYVHhG1IHDmsQKTT5Ycb/rLzNZEiV1ZNKkYHXcNwWvg8cfjTCw1+VihmBmo7Di5xQLs/ugl
	8eallW5TiaHmr7G1aA0xWxOIt/V8gmlMSU7iw5Sdm8pv8odI3nwuPWKHviND5X4dx6bbyUPivyL
	LoURZmQ4qWuMDaXJ/GfCpbiOVzzhEkDY7fd8oIMC3JXCvKwnKW8qdiw2f+FiXWC2dmoUnMRK4Kq
	ap+DUiMjO4AEo88pNZiuP3Qt6VitTg3UxaNuyf/LarLEV0e5itoUcVkLq/PKEfc6oy257fa/X/l
	8C72TYEGhrYQZPhBcja77i+h8VouFbOX6WUATQlcP2llSKOzrVUxK+58bDangc48B6yke3I2c95
	qdG4oVgjo8F+DsViGn9zyKA8vxF8e10jPwm+4UUh5Y7jCcqKxg1nXGhoE/P5mz5TcgcCYhkhe9n
	9grwWZoaz643pFEruxDU2a9ieS9Q35bPeUtEvF1vui9bgLXNOYfxkU9Lk1uwgWFjtux/JBhhU5/
X-Received: by 2002:a05:600c:6289:b0:485:3cf3:1010 with SMTP id 5b1f17b1804b1-485566cfa26mr239762865e9.2.1773703374478;
        Mon, 16 Mar 2026 16:22:54 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4856eaa4fb0sm26849855e9.12.2026.03.16.16.22.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2026 16:22:53 -0700 (PDT)
Message-ID: <231361d3-dfaa-422d-a246-03f9a51b89f2@gmail.com>
Date: Mon, 16 Mar 2026 23:22:46 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: cast id to u64 before shifting in
 io_allocate_rbuf_ring()
To: Jens Axboe <axboe@kernel.dk>, Anas Iqbal <mohd.abd.6602@gmail.com>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260316150636.2123-1-mohd.abd.6602@gmail.com>
 <1f79957a-5b23-4bbd-af8d-9d1c86791645@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <1f79957a-5b23-4bbd-af8d-9d1c86791645@kernel.dk>
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
	TAGGED_FROM(0.00)[bounces-12712-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Queue-Id: 096A82A1ED3
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 3/16/26 19:37, Jens Axboe wrote:
> On 3/16/26 9:06 AM, Anas Iqbal wrote:
>> Smatch warns:
>> io_uring/zcrx.c:393 io_allocate_rbuf_ring() warn: should 'id << 16' be a 64 bit type?
>>
>> The expression 'id << IORING_OFF_PBUF_SHIFT' is evaluated using 32-bit
>> arithmetic because id is a u32. This may overflow before being promoted
>> to the 64-bit mmap_offset.
>>
>> Cast id to u64 before shifting to ensure the shift is performed in
>> 64-bit arithmetic.
> 
> I'd be impressed if 'id' could be large enough to cause this to
> overflow. AFAICT, you'd need more than 64K interface queues registered
> to hit this. So I think this should be reframed as a cleanup, to appease
> smatch.

Pretty much so. I'll queue up the patch targeting 7.1, thanks

-- 
Pavel Begunkov


