Return-Path: <io-uring+bounces-7117-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BEE55A67DB4
	for <lists+io-uring@lfdr.de>; Tue, 18 Mar 2025 21:07:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 163A816F444
	for <lists+io-uring@lfdr.de>; Tue, 18 Mar 2025 20:07:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D10201F09AA;
	Tue, 18 Mar 2025 20:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XEyPoY+M"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4104F1DC9BA
	for <io-uring@vger.kernel.org>; Tue, 18 Mar 2025 20:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742328424; cv=none; b=Y+4zk+qmRCH6hGssihi9y1Is5Omj+X78Jc/FC+BjMfEFXPZQTyRg8RpwD4Jfpn1nLLaOKMviOVL/FrZuGFdyJt1fxopjf/oEqOeQq4w5BDbDbpyVSA34lKstbM6gOYUQHrz/eAo7psFWw95OlEFMc2tPn4fDdDthSwKfya5Y/tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742328424; c=relaxed/simple;
	bh=9/xGt8VcJXOWy/FBUY5FpAY4aqIGZ4WwDFQWjwYGLF0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=TS/ziWWYPYjTTyrKHgD9vaSWXrdxl9MJY1vEXjqMWnJDr+u5skQC6j+wm0wkamyXl5R7ej8pHT71KKkA45EfQmarhbnpYb0mTJw4OJ2+mL/BsSWdrCLf2mxP07kkcfm1zIdhDOO7a2VQdiDL0slZcHYFV+YiEsR3wbIQSMSJTKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XEyPoY+M; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4394a0c65fcso34604655e9.1
        for <io-uring@vger.kernel.org>; Tue, 18 Mar 2025 13:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742328417; x=1742933217; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6Tms3c6BEm3HAgd3qu9tG4fPns84C/qzS9pg0bDpRiQ=;
        b=XEyPoY+MshbSnTBzBccovvfSUrza+Roi/3BqZsc7fI3rR905MSHMYtMmJUDXR4i+wG
         xCFKLUVvQo+HyjBBPkvTP505Igkix0ApUIM2UNL2nYKw9Y3Y5J+4+P4Uae+WlKML42tR
         2SIICq6l0qfWMOtzPhTWxFEI5Oka9FaY4D+PzM7Tn4DfYzmMZ9IF1JZsEAFc9rgqFOoE
         yCjTycNg+Ctz2AeT65bGwokumgmUXWrYVZgziEmw7sLTD6nRwgyZ0A9scOxehkBakZyy
         zwl+8RTtaK2s4va47jHuOeSJeBOXdrgWngW8Q26fTgphuaeE6ob3fszUXtFFxBXP1nOV
         +N6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742328417; x=1742933217;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6Tms3c6BEm3HAgd3qu9tG4fPns84C/qzS9pg0bDpRiQ=;
        b=G87rO3gT+m561LvH4qqg5L1N77aI6PgfmLipbVCOyxv6sXp8W3E7GhVYHMRdsOYcjo
         Ib8O9ngII+2k8fm6hv8aCR2m0EEUI8Xrk7v7QQmDS9GgR+h2q3HWv+Sn41unM/wF7L9j
         8bYjlFrEL3xaEclbmT3kn78Ab73NdtjJRf9P48J+cp5ryn3gW1D5TRxTrWq3Kw7jWU1f
         9r5pS2Uo/EtQdk8GhreGdvt5h6p2GMXPLSAvodOJKg3NzCJqWOn1Ip8845pl/gZXqcZP
         VO43+7s+moQry2uT9XEY+38Woaqp5P5FHYw1IWcSUivchd1p81Fi6lAdSOfdbo8E4Dgt
         FXVg==
X-Forwarded-Encrypted: i=1; AJvYcCVB4AgwxWk8N1Kc3an2gLL0/EQl2WTX+0ypBV/oa27Yyw3t6kU/qnOtJjtBoiH6iM9VtzT8MUH0MA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwdffEJYzu3E0vSD+DRAwSFr0E/PmFQlcxOJajGnGskhdiIAvbi
	gz3CiWrNBfeZUpi48kBC/FTVwmz/LWy6KJ5FwSbCK0v+9P7J95u1GRpO2W9D
X-Gm-Gg: ASbGncsclCbEvF+/olwmupHFp+qNE2Tg79T4x7uohla7NDCMehGnzgrueaTsBInx+wT
	j83fC4mABplysxMyqX+CmzWjCbrFob2PQIfzUlkLccmbfQGdIPaK49/YGS4sXULhIyMJe+pTVNm
	tJt622c9dkMou5zlOOphxRPajWxm/6TPfFLADpsem2HoK0xogWPBk1zmlGHHPKn69Cudwwss3Lt
	nBoEFqjhfUOYLGSBgumSB4DxqyzWCgjmjgokvzZbeRy8xY68ekPHZ02IL7YYsJbw6juIPuKbwS+
	VAE4Mg9i3O4kyGppJWXmmWi36zR/9dVKYPwvHi52qtItrp8XxDWP6hEn0S7Upf5lBxVc8fvBlg=
	=
X-Google-Smtp-Source: AGHT+IFS7DfJDNUPFWE9mK2+5Y479mtfzv+6vJF4Z62JWBZQ407YugWHY3HGuTkj0cWa6h9ikNxhWg==
X-Received: by 2002:a05:600c:19d2:b0:439:9a40:aa0b with SMTP id 5b1f17b1804b1-43d41b5150amr2332835e9.25.1742328417126;
        Tue, 18 Mar 2025 13:06:57 -0700 (PDT)
Received: from [172.17.3.89] (philhot.static.otenet.gr. [79.129.48.248])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d3ba44e63sm19625865e9.1.2025.03.18.13.06.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 13:06:56 -0700 (PDT)
Message-ID: <807d665f-2b3c-418b-b13f-2c757fc0c762@gmail.com>
Date: Tue, 18 Mar 2025 20:07:53 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring: enable toggle of iowait usage when waiting
 on CQEs
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <f548f142-d6f3-46d8-9c58-6cf595c968fb@kernel.dk>
 <c8e9602a-a510-4e7a-b4e9-1234e7e17ca9@gmail.com>
 <37fcb9fb-a396-477e-9fe5-ab530c5c26b5@kernel.dk>
 <42d8e234-21b0-49d9-b048-421f4d4a30b6@gmail.com>
 <5be69fe9-4de4-49d6-a457-9720e50c92d9@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <5be69fe9-4de4-49d6-a457-9720e50c92d9@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/18/25 18:36, Jens Axboe wrote:
> On 3/18/25 12:39 AM, Pavel Begunkov wrote:
>> On 3/17/25 14:07, Jens Axboe wrote:
>>> On 3/16/25 12:57 AM, Pavel Begunkov wrote:
>>>> On 3/14/25 18:48, Jens Axboe wrote:
>>>>> By default, io_uring marks a waiting task as being in iowait, if it's
>>>>> sleeping waiting on events and there are pending requests. This isn't
>>>>> necessarily always useful, and may be confusing on non-storage setups
>>>>> where iowait isn't expected. It can also cause extra power usage, by
>>>>
>>>> I think this passage hints on controlling iowait stats, and in my opinion
>>>> we shouldn't conflate stats and optimisations. Global iowait stats
>>>> is there to stay, but ideally we want to never account io_uring as iowait.
>>>> That's while there were talks about removing optimisation toggle at all
>>>> (and do it as internal cpufreq magic, I suppose).
>>>>
>>>> How about posing it as an optimisation option only and that iowait stat
>>>> is a side effect that can change. Explicitly spelling that in the commit
>>>> message and in a comment on top of the flag in an attempt to avoid the
>>>> uapi regression trap. We'd also need it in the option's man when it's
>>>> written. And I'd also add "hint" to the flag name, like
>>>> IORING_ENTER_HINT_NO_IOWAIT, as we might need to nop it if anything
>>>> changes on the cpufreq side.
>>>
>>> Having potentially the control of both would be useful, the stat
>>
>> It's not the right place to control the stat accounting though,
>> apps don't care about iowait, it's usually monitored by a different
>> entity / person from outside the app, so responsibilities don't
>> match. It's fine if you fully control the stack, but just imagine
> 
> Sometimes those are one and the same thing, though - there's just the
> one application running. That's not uncommon in data centers.

Yep, but that's only a subset, and for others the very fact of the
feature existence creates a mess, which might be fine or not.

>> a bunch of apps using different frameworks with io_uring inside
>> that make different choices about it. The final iowait reading
>> would be just a mess. With this patch at least we can say it's
>> an unfortunate side effect.
>> If we can separately control the accounting, a sysctl knob would
>> probably be better, i.e. to be set globally from outside of an
>> app, but I don't think we care enough to add extra logic / overhead
>> for handling it.
> 
> That's not a bad idea, maybe we just do that for starters? We can always

Do we really want it though? What are you trying to achieve, fixing
the iowait stat problem or providing an optimisation option? Because
as I see it, what's good for one is bad for the other, unfortunately.
A sysctl is not a great option as an optimisation, because with that
all apps in the system has either to be storage or net to be optimal
in relation to iowait / power consumption. That one you won't even
be able to use in a good number of server setups while getting
optimal power consumption, even if you own the entire stack.

It sounds to me like the best option is to choose which one we want
to solve at the moment. Global / sysctl option for the stat, but I'm
not sure it's that important atm, people complain less nowadays
as well. Enter flag goes fine for the iowait optimisation, but
messes with the stat. IMHO, that should be fine if we're clear
about it and that the stat part of it can change. That's what
I'd suggest doing.

The third option is to try to solve them both, but seems your
patches got buried in a discussion, and working it around at
io_uring side doesn't sound pretty, like two flags you
mentioned.

Another option is to just have v2 and tell that the optimisation
and the accounting is the same, having some mess on the stat
side, and deal with the consequences when the in-kernel semantics
changes.

> introduce per-enter flags for managing boost and/or stats, at least it
> provides a system wide setting that can just get overridden by flags,
> should we need it.
> 
>>> accounting and the cpufreq boosting. I do think the current name is
>>> better, though, the hint doesn't really add anything. I think we'd want
>>
>> "Hint" tells the user that it's legit for the kernel to ignore
>> it, including the iowait stat differences the user may see. And
>> we may actually need to drop the flag if task->iowait knob will
>> get hidden from io_uring in the future. The main benefit here
>> is for it to be in the name, because there are always those who
>> don't read comments.
> 
> But that's the part I have a problem with - sometimes you'd need to know
> if it's honored or not.

If the flag implements optimisation only part of iowait, I don't think
it's so necessary, but we can add some slow path for querying if it has
the iowait stat "side effect". If it's about the stat, yeah, probably
we can't just ignore it and "hint" is not a good idea.

-- 
Pavel Begunkov


