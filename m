Return-Path: <io-uring+bounces-11545-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4ADB0D06939
	for <lists+io-uring@lfdr.de>; Fri, 09 Jan 2026 00:54:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 73EF9301E167
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 23:54:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14738333451;
	Thu,  8 Jan 2026 23:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="bRhBbdqE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1C21A23A4
	for <io-uring@vger.kernel.org>; Thu,  8 Jan 2026 23:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767916452; cv=none; b=eDJ8ZSnbMItK1x1LB1Fd5dOBQOw/9WcYF6tX486o4ycy9AM599YREKm88iTadPmBc0onZfdiBpBg9HT3Pe/4vRgRsdXeQHqE0rUKqEJpXvikE+Nl0oVke6ElK6ENlL+hf0EvTJuwsSC367gzVc7znkCGzspYvJoAvXcjz90hVoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767916452; c=relaxed/simple;
	bh=0sCldnrLx9ralD2X9Ueafr3kmU+xKLU4rTnRrHPhxBQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=efgKIJPCxphzTTEdD/U3mX5kkvPu+tik/Od8KfMgW8S8bvRYWBps0npPr4h3rtGRmpyPiy3LnQntND0PVqUBVDg20imdiVLLAYBPuuN6/XCQUhaq9TEmrtfFYssea9IqRc6TwdT22GRQ4Yk5g/B7Dsu29ryCU7/yHcBEcAftxus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=bRhBbdqE; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7c75178c05fso1500601a34.0
        for <io-uring@vger.kernel.org>; Thu, 08 Jan 2026 15:54:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1767916448; x=1768521248; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8guKUXJ16AY1UP0Z+aQkb3So1uzLZKqQ2GlZcS2dHA0=;
        b=bRhBbdqEVqZKSPr/w7v8rNkTdz3LA/Nw8odUjvicjY0sk+L7LetioqdSiX/7pSXlVm
         gnv9CHSrfvRbOY/B4IEzUd4QC2YRRy53h+mgf8Da56yPuu3xckkBEg+02W5JEOpBcNik
         8SSz3HpB8cJuBUe6BGm319jq5qEnEmryeFO9jntHsoeJseXfgJpi7AMog1flb6VvlupA
         TBZXI3KxaTQp7Ad7UPcPe4DbIIkVeZfRUaFZhASc8fP1mfCa/5/MW5NtMQeibzfEgPNH
         gwL0BA1OUiHJFs+Be4EKCswDKhGqNzkXqjPghRDKtZUgDNbOExTkq6yy3TVmVF/JpiKj
         xgxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767916448; x=1768521248;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8guKUXJ16AY1UP0Z+aQkb3So1uzLZKqQ2GlZcS2dHA0=;
        b=nR6yDgShCVoxY9Ipw2r00C5HMaYY8zzZNK0H0lNSLQdKdUzSdhP7+zN20D7LCeHjP9
         5tKsytKNnnfQSAT337G/RPExL44vtVHxW0Kd+OGM3EGqvbWqSkJwFkrCIBNF24o7pbEH
         nwdRAyFtpgIlZsXC9Otxylv0SAMP4rUhKC4s1m5OIruY31dtFkF+E867OQuittDK2OK8
         dv0RXre/EhW3I3yndxpChLRZoAjL5TMSz+ayF5O/gWM4/K0Y1NO9VIA/eJ9OpVYQg9tD
         Z8ZVN1RchTltJZk9jaM+v6IHZMhPjcRv3rZfnA7LZwL9EI6pHI/oz/8xfx+L3P9CZhd5
         XQIQ==
X-Gm-Message-State: AOJu0Yw2fqO0r2KNQh/svSKjREBa/9xX4XdIkOxJepJyWD6Sho8TfI7N
	u/HEHpMKGAESsKgtKDbZ2yxLFpit5wZ+WPB5Wt15br1TTe9DOZ53rYAX8MBQw+J6jh4=
X-Gm-Gg: AY/fxX4S6PeyRAdg87YoLJEAPBQ9AJXRQKTbXd40JSDm5dhhYZ1KGibsxhj2MCKl6Co
	2dc2YmytXzGqNLmo1TdgcqDwrMVk4XFWvSixyMWRD8wkKw5dGDH50Cu28/1UVVac3GLMYHJpxZ/
	UTAwsUizFaSFTcV63lyZabiIdPUMxyM7sTyEwVkYM3cOrdPF2B3jO19aNzo9j4h7Lc0NyXyVyHU
	C82GRmnjNdkcZXhsIuXtVE8xfdGFPBnJlsvXZef/0f+ngHA5K6X30+aL23kNgdfrM2uK5Pf1pdM
	4p3qmWhwt/P04gj3SabMipgyQ/2CmGRAu8yqlsFm8CfU8iq+EkyZynJpyzaW/HYHhFjgLsC9nr/
	W8PKpRqpUjpHOqq6hz73Rr79HgBurBWvNkO+UEVqOAtH9PtWMzsB+7yhxUwTwl6o76vYB9VOYbM
	mF3kngItQK
X-Google-Smtp-Source: AGHT+IEQIUfFcztZHMvz+Q+nCam63ilId45TFb/rxbKOEFyVcrLxzoS7ffO5aUNfEQCDKqV2xqGNjA==
X-Received: by 2002:a05:6820:60a:b0:65f:668a:4d with SMTP id 006d021491bc7-65f668a03ecmr487004eaf.77.1767916448330;
        Thu, 08 Jan 2026 15:54:08 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-65f48bbc0desm3882470eaf.2.2026.01.08.15.54.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jan 2026 15:54:07 -0800 (PST)
Message-ID: <9f7e8b5f-e89b-4e7e-a520-ae97127b45f7@kernel.dk>
Date: Thu, 8 Jan 2026 16:54:06 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET RFC 0/2] Per-task io_uring opcode restrictions
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
References: <20260108202944.288490-1-axboe@kernel.dk>
 <87pl7j4v8h.fsf@mailhost.krisman.be>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87pl7j4v8h.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/8/26 3:04 PM, Gabriel Krisman Bertazi wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> Hi,
>>
>> One common complaint is that io_uring doesn't work with seccomp. Which
>> is true, as seccomp is entirely designed around a classic sync syscall -
>> if you can filter what you need based on a syscall number and the
>> arguments, then it's fine. But for anything else, it doesn't really
>> work. This means that solutions that rely on syscall filtering, eg
>> docker, there's really not much you can do with seccomp outside of
>> entirely disabling io_uring. That's not ideal.
>>
>> As I do think that's a gap we have that needs closing, here's an RFC
>> attempt at that. Suggestions more than welcome! I want to arrive at
>> something that works for the various use cases.
>>
>> io_uring already has a filtering mechanism for opcodes, however it needs
>> to be done after a ring has been created. The ring is created in a
>> disabled state, and then restrictions are applied, and finally the ring
>> is enabled so it can get used. This is cumbersome and doesn't
>> necessarily fit everybody's needs.
>>
>> This patch adds support for extending that same list of disallowed
>> opcodes and register to something that can be applied to the task as a
>> whole. Once applied, any ring created under that task will have these
>> restrictions applied. Patch 1 adds the basic support for this, and patch
>> 2 adds support for having the restrictions applied at fork or thread
>> create time too, so any task or thread created under the current task
>> will get the same restrictions.
> 
> Hi Jens,
> 
> Considering this is like to seccomp, a security mechanism, I don't see a
> use case for running without IORING_REG_RESTRICTIONS_INHERIT.  Otherwise
> there is a quick way around it by just execve'ing into itself.  IIRC,
> seccomp also doesn't support disabling filters for the same reason.
> So, unless someone has a use case, I'd suggest dropping the flag
> and just making IORING_REG_RESTRICTIONS_INHERIT the default behavior.

Yes good point, and then I can fold these two patches as well. I do
agree that having it be inherited on fork is probably the only way to
go. Not posted with this series, but I did add support for unregistering
a filter, IFF you were the original creator of it. You can either update
it with a new set of restrictions, or simply pass NULL and get the
current set removed.

> Beyond that, adding more restrictions on an already restricted
> application would be a useful use-case, so returning -EBUSY on
> current->io_uring_restrict might not be doable long trem.  But feature
> can be added later.

We could certainly do something like that, where you can "OR" in more
restrictions, you can't just "AND" them. I'll add that.

> Finally, I suspect we will come quickly to the need of more complex
> filtering of arguments, like seccomp.  Again, something that can be
> added later but could be considered now for the interface.

Quite possibly, as it's using the same mechanism we already have, it
just supports filtering opcodes, register opcodes, and flags for either
of those. We do have some vacant fields in io_uring_restriction right
now which could cover more cases, at least.

-- 
Jens Axboe

