Return-Path: <io-uring+bounces-13845-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id s7RHMKKjPmrEJQkAu9opvQ
	(envelope-from <io-uring+bounces-13845-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 26 Jun 2026 18:06:58 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B6DA46CEC57
	for <lists+io-uring@lfdr.de>; Fri, 26 Jun 2026 18:06:57 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=0H8YGkRQ;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13845-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c15:e001:75::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13845-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id CA9FA3001CE2
	for <lists+io-uring@lfdr.de>; Fri, 26 Jun 2026 16:06:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCD793BD241;
	Fri, 26 Jun 2026 16:06:53 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D803812EB
	for <io-uring@vger.kernel.org>; Fri, 26 Jun 2026 16:06:51 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782490013; cv=none; b=Ey9xfP5OULe6ocM2YBy9xqTu+m4Le4SP0AqA8Otk9i4DobTAu2Y/mf0WNdEODZ8iIsVU7C0lF8HhPsPfhBg8TPz8WQ37VNFR5l3/9la7Z+Mofmd5h331AlT/itbsZnQNqn9iwnmo9mJJh2gavij6kTIsKMRNv1TIpmcXUky/Juw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782490013; c=relaxed/simple;
	bh=bVOuF33R62ZX1QAOrKpmStdEbSXJZuULIN38SLmlRg8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FeNXLwhJu9tkd3Z00/E0qvSrdek9kd9WS/RMtPdCETqzGa/QouqiHCbk/3Yr6JCKrqUEHBC3d1AfuVmrIUZtyxGmrz1N3PIehk4R9lbZqSSfB5pJPaJvdfc9n66a/JuKXJH0vSB7C0MQzVmlNTWJ6fTpEaCEDH1tYLCx/x+vKig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=0H8YGkRQ; arc=none smtp.client-ip=209.85.160.47
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-44192448b56so426567fac.2
        for <io-uring@vger.kernel.org>; Fri, 26 Jun 2026 09:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1782490011; x=1783094811; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GhJCeELsWcn0eKRZfQrcdhIMF5uPEapjOAil2qd1l+0=;
        b=0H8YGkRQVSAQzgT55ZEGIO2yA6BhqEYDfbCnj5iugWjK6+zEWqIfyF5vnG/O59DG5U
         b9LEEEhoHwh8Dryt0WHrOJpFjEkI6K6aPq/vMK89RyW6NVD2/J2j2rVPl5m0JdhD7wW4
         fIAnfC5+KD/HwPC8fS7Jxh5ZF4dfaOENmBpHN8P3Zmax9TcW3hHMcUTho/qosopzATuA
         qwQeyXU2uYRtDwEwl+w89Bo+z1RcolWuUct1NSwKhEE161yV5DciDNlygtwCSbxIgoup
         48k7Ov75cUCnOM7h3RKnArDOe38FGHkuua7muhs9Rz8ZJ+sIuE828AejrkBFGY1pncyj
         HrhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782490011; x=1783094811;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GhJCeELsWcn0eKRZfQrcdhIMF5uPEapjOAil2qd1l+0=;
        b=pwpKSGZO54b9HG3MvLbvrfOtrL6/+4UnMKtL+Y8ra5Oc0No6OaD2E39/GonIBq3vEe
         DR6E3qI2uZgfRQM0j2sPVJcGmd64lhKQib40dblbAu1rnSJNrNnHLOzAOehlNjumdymv
         CTnZD/gWOrwOVYbhgECuviGCfWKJGrF9hUGtjaLMiq/MGwgUaAfmwbo95PI2is/iyO/y
         c4Tr/OzR4lL+8LBZ8NK2TQ3R5fhfpCwcE4c72H5i/uXodB+LMP7CJOuxzQFAAdWcmI6k
         +arLZutcrHDrxzHNZGWckQlH4JkksDed+hGoNPMKjTrnOMqhwH/749AMytm89G56fYWL
         dlRg==
X-Forwarded-Encrypted: i=1; AHgh+RpLua5NiJ3iKy2DQIqkOFv7FlfNDGw0YW1x0tVitVJnyXR+zoMAR2UkRSBQX0VnJSIoFYOYWBFW3g==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywwa6NGpdXCc4cJRkhEKVw/PWJUCeg9s634OybQUNHKHndH/0DH
	2uoHYJFsMNI/NjPQxHkACPqHEXGDKQ1pBD6ussThgDC9/GM0lYFnv6uBnsm+4IEjM0U=
X-Gm-Gg: AfdE7clgqsn1DNP2B2P2pKiit8/vUHvvNnb+Ndb102tg1q+1iHIpcqn+8MoPEswl0iP
	Sv8Vs59O+gS8bEaAg4EIrkf9YtG2jM4oo/gJTqecNMoMLWGc2xp54w90yalSzcbiTHaLVjhKOyi
	1qtBYox9Xd9u3dU2XLcO/AugfkZhfFAwZMZAcfc+zzlMiPeLAmSsmMDcn+KyEAxQdaZ90Z1NEwq
	Kxg9HzizGX9YLpdlDeizJ06X6SVYz3vjmyzZ2sh2uf2Twelj+uw/yhKnWimzLo+D9B3fVNjXYbU
	hRVD8SH2HMRvbo28IM1Kdd67Ktq0Mq+hwdoqGEkBl0qxXEq2GHdOsG9+onUVZx27MHRnEDQYO6q
	KxjpPqbF9tfgnQ3lt5GdrUFDCithe0/kvUFjOwAIdUMh5OC30rI05JkUhXBrPo7ZnFLdKw8RoU7
	BcHPtvXkb5DjeA1LIeR8IpBVHDeTKUujGsb3ggqXSHJZdZTrwS0a1x2yvfrw1ar7heO3R77g==
X-Received: by 2002:a05:6870:4692:b0:441:33a9:b8da with SMTP id 586e51a60fabf-44811cf8b03mr5792844fac.18.1782490010903;
        Fri, 26 Jun 2026 09:06:50 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-448478f0d15sm770119fac.18.2026.06.26.09.06.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jun 2026 09:06:50 -0700 (PDT)
Message-ID: <1932a509-4e27-485e-8e09-1da67e0082c8@kernel.dk>
Date: Fri, 26 Jun 2026 10:06:49 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] RCU hang with io_uring nvme polling
To: Keith Busch <kbusch@kernel.org>
Cc: Ben Carey <benjamin.james.carey3@gmail.com>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260626150946.287781-1-benjamin.james.carey3@gmail.com>
 <85d1f999-7778-4c74-9d72-b8ac8500de31@kernel.dk>
 <aj6jQyJd3zmZFcwx@kbusch-mbp>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aj6jQyJd3zmZFcwx@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13845-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:kbusch@kernel.org,m:benjamin.james.carey3@gmail.com,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:benjaminjamescarey3@gmail.com,s:lists@lfdr.de];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,kernel.dk:mid,kernel.dk:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: B6DA46CEC57

On 6/26/26 10:05 AM, Keith Busch wrote:
> On Fri, Jun 26, 2026 at 09:17:35AM -0600, Jens Axboe wrote:
>> On 6/26/26 9:09 AM, Ben Carey wrote:
>>> From a running QEMU image with the latest kernel:
>>> 1. Attach GDB to the running instance.
>>> 2. Enable io polling via sysfs (echo 1 > /sys/block/nvme0n1/queue/io_poll).
>>
>> That's not how that works at all. You need to setup poll queues on the
>> nvme driver side, using the nvme.poll_queues=XX kernel parameter, or if
>> using nvme as a module, load the module with poll_queues=XX where XX is
>> the number of poll queues. You're not doing any polled IO as-is, and the
>> above should also have dumped a dmesg message about how that does
>> absolutely nothing.
>>
>> That said, it should still work, just not doing polled IO. I'll take a
>> look sometime next week, OOO right now.
> 
> Yeah, the sysfs attribute does nothing, but Ben mentioned they had the
> correct kernel command line:
> 
>   BOOT_IMAGE=/vmlinuz-7.1.0-g3996771b8f75 root=/dev/mapper/ubuntu--vg-ubuntu--lv \
>     ro nvme.poll_queues=1 nokaslr
> 
> So they did enable polling, but the "echo" step is just confusing and
> unnecessary.
> 
> I tried out the test, and there does appear to be a problem here, so I'm
> looking into it.

Ah good catch, I missed that. Should've grepped! In general, IO should
either get polled, or if the device is misbehaving, then timeouts will
catch it. That said, haven't looked at the actual report yet, will do
so next week (unless you beat me to it...?)

-- 
Jens Axboe


