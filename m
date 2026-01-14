Return-Path: <io-uring+bounces-11717-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CADCD2087A
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 18:24:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 625673011183
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 17:23:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AADAF9D9;
	Wed, 14 Jan 2026 17:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="KRHvOLLS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A8F2FFDD5
	for <io-uring@vger.kernel.org>; Wed, 14 Jan 2026 17:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768411431; cv=none; b=Oy7/ef3u6/Tm0KbZh1W0vcyfSngujrSjg3HMAmdbFfwyF2Qf/qL5s914HmQFywNZrPPh3Odq4szvokmYkraLVF6IZiFw4LfvnsQMK6poJJFdzDAAvAe/WJEpBV7CIKO//p/tKfUnECuPAUD0Mo28iHqtYPA7S0RugQzwZGakU+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768411431; c=relaxed/simple;
	bh=RQgeo425Yk/mExRE0Ca/MnCga1gOPIwcDNg+kHaQAog=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k0vhvRrEplqIXevmXe1yl89AvRm+snCdnDfIEcqNbh3DL/wfZEoEmShYON+z8KaHj0ACvtnH50j54NrFo1j60jaBm117XuC5Nb8gPQgVlTRHabeZtl/H97wkg6Bu2OIRyW75nRxXfw+PSlsp/ZynaxfOgJ0IX2IvWLps6TXN+kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=KRHvOLLS; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-4040882bca9so523fac.0
        for <io-uring@vger.kernel.org>; Wed, 14 Jan 2026 09:23:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768411428; x=1769016228; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WP3H4Z3Lw65mgMD0z4dYsr8eekOJVT9bfzbZwd1F2e0=;
        b=KRHvOLLSgeMs7YuXh85NPjMHsBH52x8KhGOwSX3ME8kZBRT0oNfo7GqQeWq8i5dNwz
         EreU827u8svue/W3UBSS6aOXFZXg+P2aofp7YlbjRLC+ju+oXYFCTsaKSOX1UyazfTxN
         JIaPzmxaN4rm2t7KlE59LPass4NtHewT8C2ejXxyQlrdeL/BkHxGJQZpswMvXh6MlZT9
         CaTf7DLBW6RC/xamdXAkHiYeKg4RxcWmM0iDW7MKtL2so/vPQjvho5WJ4e9Ea1fdWe+y
         CGYxK+uczodVKrrtDAhVZgSR6fAxXlNL9DXWCFAiZ8egZ3IO8x06NWsR3Id/CxljqVsd
         yPBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768411428; x=1769016228;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WP3H4Z3Lw65mgMD0z4dYsr8eekOJVT9bfzbZwd1F2e0=;
        b=WNi+Gje+Duy1ZQsGURnkDHr1B3cODZue3Afe7sN9pj/UQN5k4/L1f8jF3qnqGRgyAc
         7MBbT+JXA6paO99tpuV/JV1lMFWb4Lfw2pYig0TYI6TZOc1Qji8CaYcvL1Fs+kLla+TY
         mAiZYqeOuGlFYdjPtSxnyW4d6Y4MJI4pcf4eCoRcxRYniL9w6U1VvXVS9DsFS3QHiS7I
         BlMLAmjdSmV7+sR9NHXQSp/sXLZxTf5iDZP2UMad3JvhSC2PMl7WqswrcxRSbUTv2raC
         P753bITrIeIfX+Ykp0hg71OIca6rs5Q85UwAXtmhNdIsm2DObmubCn8760llrrQjK1h3
         T0zQ==
X-Gm-Message-State: AOJu0Yz8pizPv23/PyXRFFF9xh/6nkTEe2oJzFm08F4IVLVsNoT2Dgpd
	Ye/k+wVbTKE7OfgFVZRiP72LORp6KrsiTEQDTIAydrs30ILIVeWMDic+/nMaEBv/2w4=
X-Gm-Gg: AY/fxX4/SOzpAXPt8DaqZqRnKnytLjyf5vy8LfUi2MN8AFlFOrAVYlo7cwWKbj1Tjrm
	POUMzNQsMIOvaTm/6ciY11TZF4h2Rv2KY6Kd7LgMYBugM0t4tdMDNx7GFmyrDK3BVo2UDq7itb9
	lltSBZB2y1MDP72maWSpO3v9CoigJaqjIQUtdRfGSn98j6O4CO4OWuLKblMldam/crZnaHAJvSG
	TveKjFWjWo0T4fe6xdjKEQYbT2spy0rnX421Pn/OK2ZxoWJfz9eLr/3YzFNrc2N11AmqZKw10gT
	x2mgHdLebFEAWID6BP/OuLtWbzJmpHm1dK1Qo0u2m+x5AM//9ZKNmJ4nO4VfkJ9vawOaDpV293c
	yPSHOqbm18B/AO03pzNJyXH3Yv9YriiQhVFE+RmP8SF33CD7faGtZlsFXLwLO2TBmwkqSSAx39H
	jf5h24C0M=
X-Received: by 2002:a05:6871:e7c3:b0:404:352:72c1 with SMTP id 586e51a60fabf-40406fb89b5mr2250286fac.20.1768411427952;
        Wed, 14 Jan 2026 09:23:47 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3ffa50e1e29sm17272629fac.19.2026.01.14.09.23.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jan 2026 09:23:47 -0800 (PST)
Message-ID: <adda36d5-0fe0-466c-a339-7bd9ffec1e23@kernel.dk>
Date: Wed, 14 Jan 2026 10:23:46 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing 1/1] man: add io_uring_register_region.3
To: Pavel Begunkov <asml.silence@gmail.com>,
 Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
References: <6ba5f1669bfe047ed790ee47c37ca63fd65b05de.1768334542.git.asml.silence@gmail.com>
 <87ldi12o91.fsf@mailhost.krisman.be>
 <d3a4a02e-0bcc-41fd-994e-1b109f99eeaa@kernel.dk>
 <9f032fbc-f461-4243-9561-2ce7407041f1@gmail.com>
 <5f026b78-870f-4cfd-b78b-a805ca48264b@gmail.com>
 <c805f085-2e13-40ee-a615-e002165996c6@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c805f085-2e13-40ee-a615-e002165996c6@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/14/26 9:04 AM, Pavel Begunkov wrote:
> On 1/14/26 14:54, Pavel Begunkov wrote:
>> On 1/14/26 14:42, Pavel Begunkov wrote:
>>> On 1/13/26 22:37, Jens Axboe wrote:
>>>> On 1/13/26 2:31 PM, Gabriel Krisman Bertazi wrote:
>>>>> Pavel Begunkov <asml.silence@gmail.com> writes:
>>>>>
>>>>>> Describe the region API. As it was created for a bunch of ideas in mind,
>>>>>> it doesn't go into details about wait argument passing, which I assume
>>>>>> will be a separate page the region description can refer to.
>>>>>>
>>>>>
>>>>> Hey, Pavel.
>>>>
>>>> I did a bunch of spelling and phrasing fixups when applying, can you
>>>> take a look at the repo and send a patch for the others? Thanks!
>>>
>>> "Upon successful completion, the memory region may then be used, for
>>> example, to pass waiting parameters to the io_uring_enter(2) system
>>> call in a more efficient manner as it avoids copying wait related data
>>> for each wait event."
>>>
>>> Doesn't matter much, but this change is somewhat misleading. Both copy
>>> args same number of times (i.e. unsafe_get_user() instead of
>>> copy_from_user()), which is why I was a bit vague with that
>>> "in an efficient manner".
>>
>> Hmm, actually the normal / non-registered way does make an extra
>> copy, even though it doesn't have to.
> 
> And the compiler is smart enough to optimise it out since
> it's all on stack.

Not sure I follow these emails. For the normal case,
io_validate_ext_arg() copies in the args via a normal user copy, which
depending on options and the arch (or even sub-arch, amd more expensive)
is more or less expensive. For the registered case, it's a simple memory
dereference. Doesn't cover the signal parts as I believe those are way
less commonly used.

-- 
Jens Axboe

