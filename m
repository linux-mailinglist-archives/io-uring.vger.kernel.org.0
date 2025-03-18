Return-Path: <io-uring+bounces-7114-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22888A67C21
	for <lists+io-uring@lfdr.de>; Tue, 18 Mar 2025 19:38:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E92C423139
	for <lists+io-uring@lfdr.de>; Tue, 18 Mar 2025 18:38:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92706212F89;
	Tue, 18 Mar 2025 18:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="k0rs8Jw3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F02212F8A
	for <io-uring@vger.kernel.org>; Tue, 18 Mar 2025 18:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742323009; cv=none; b=iW2EGMgZo+atsE+KIaN9lia/1bz+CLInfAuCP8hr/FIuUsCWy4Uy3j8wDspO5+rN8DYcvsjPqvDEo4R2wRigzzKEy1RyJBFgh1suNTR0YyaBBPf1Vd9XX9jjxwWmPsNbkX5qYJVyqnV5OQVhOFR+HCRFBPsDJlag61jGmuFzmFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742323009; c=relaxed/simple;
	bh=cdFIUaawRHrVqODJu9mryHifOCp591TGYlRcQT/5/Ls=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=BJQ7XTc16sYx9j4Wp6r+o+lkeyIT9gij2VBERLQAYagvhM9ch8gD5iIJbbpF7BdIONxs1cdDOZsSPfJ2G2oNEp+gEzLo4giUPmnYdnT5N8XTBKwRQaH6FzXapAJCgDQU0x2Jq1AgVLjBm8GiqkRQVWadTfzo7UjEttwPNshA5Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=k0rs8Jw3; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3cfce97a3d9so25546225ab.2
        for <io-uring@vger.kernel.org>; Tue, 18 Mar 2025 11:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1742323007; x=1742927807; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jR9Nz23KfP2e3vwm7HtdNHq06KZ0uasQNq2p5dlTlOY=;
        b=k0rs8Jw3ditwQ0VIJ62/Apt9ErsCOtrW3RzlP6TIRZ4g+syP4b9oPgrpOujrbT/dFN
         V9WXvUJeRPzS33KdZVGVSY2Mrf8sYjInWzwGW9JZ1EKddzTgKQLDbjxufrj7pv5YfIVK
         eFTsFoPcaFBJMbjyOfM5aV0oD+18TBz9rbMD0hu56lkUIwJB9EhmwOty/Wh+DY5W8n41
         oq+y2MR0FJtwEQebUlS1UXpKyot/+ZH79rpLdBwNtmwQf2nYvsdiEpMHILir/tkEgbhc
         0+ANv04siWWaeDn32tTuNA64n1jgo0BISq/UDpVHiRsSI4bWwQZLAOPPcR2iMYFodgMV
         ko9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742323007; x=1742927807;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jR9Nz23KfP2e3vwm7HtdNHq06KZ0uasQNq2p5dlTlOY=;
        b=fYujnJBJNGk5V+VsMU3BGzkYUThlIOHMU6gtlt1/RPMWxpGJiGSLUGPiWbBnW8Tg8F
         eR4iUnr4L1/Ls81mju1HCaGuf4jlRrkh511OGuCw7/T/Yzu9c5N7nN7r6L6BirjzDBh7
         njVNbZqG9L45KNqFeyladaPEjt1OeCKdtbXQiV/l4xRrSASz2efYWl32E/1UMusijreQ
         VWG+nD9YQF7Db92f2IdFROfjKDTpveF686uTMf1Y/d8F/datG6r8gSHxGB4Ijnyi9VeH
         hb0thpGLUTkct0EtSYtiWQuknoEusFyUelVmq13SzAMJyJevwt4SwoqLvwsjhRnMovOH
         WhcQ==
X-Forwarded-Encrypted: i=1; AJvYcCVICh6H/rAh8F+120u7VZxol64LJ8PvrH5VGsrp3rZeSN8ONUlEVsvX4YN6LFNlxtOc1KpjYVTvXQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzrv+qIW/KE7LDVOUSru4V7WfJiGgRM9GrSPGUU7DkVUammlsnU
	4GgaQQT1SMlbxZ2DmqSkMjz3F0wCeOiYYp1ZPdftGIqhHsdQqLFmL2DwfMT0x+U=
X-Gm-Gg: ASbGncsNhLp1FjU01p27kbfFldux/a6tZ/SeOpV1mAuWkN5eBol3EPbsRAUEBoHTIT9
	Zft1+lndOY1oJkj4hGx1rbatDJsAuVBgavcf+txxveFURU1vZ4wvNJghggFJMGnBwmNIq2f1JeT
	qoOEOvZXXwB0wXt3gqQZDDodjZnIZpzmrXyytatg14Gnqb4upIa7RelmsbdhHhB59sYagF03bwZ
	2o0GiVDVWwXMTqMXbaDbD64PiWK+NV4ml5XFktyEQ+Ihvf2CstY3Z/20fmruyavq5P5z83eJPUX
	x1DuKexj+NF7hU5k88VInsIdLnmbajUO5m7MEYmToQ==
X-Google-Smtp-Source: AGHT+IFzfhqM8+DnYZN0WOxfwxRGgsRv/ULoIXT7rRUH5xuKjxbH5D6eKa+BpAu619uvazpw2cYB/Q==
X-Received: by 2002:a05:6e02:b41:b0:3d4:4134:521a with SMTP id e9e14a558f8ab-3d483a2b1ecmr168111735ab.12.1742323006944;
        Tue, 18 Mar 2025 11:36:46 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d47a666ddcsm33314995ab.18.2025.03.18.11.36.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 11:36:45 -0700 (PDT)
Message-ID: <5be69fe9-4de4-49d6-a457-9720e50c92d9@kernel.dk>
Date: Tue, 18 Mar 2025 12:36:45 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring: enable toggle of iowait usage when waiting
 on CQEs
To: Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>
References: <f548f142-d6f3-46d8-9c58-6cf595c968fb@kernel.dk>
 <c8e9602a-a510-4e7a-b4e9-1234e7e17ca9@gmail.com>
 <37fcb9fb-a396-477e-9fe5-ab530c5c26b5@kernel.dk>
 <42d8e234-21b0-49d9-b048-421f4d4a30b6@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <42d8e234-21b0-49d9-b048-421f4d4a30b6@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/18/25 12:39 AM, Pavel Begunkov wrote:
> On 3/17/25 14:07, Jens Axboe wrote:
>> On 3/16/25 12:57 AM, Pavel Begunkov wrote:
>>> On 3/14/25 18:48, Jens Axboe wrote:
>>>> By default, io_uring marks a waiting task as being in iowait, if it's
>>>> sleeping waiting on events and there are pending requests. This isn't
>>>> necessarily always useful, and may be confusing on non-storage setups
>>>> where iowait isn't expected. It can also cause extra power usage, by
>>>
>>> I think this passage hints on controlling iowait stats, and in my opinion
>>> we shouldn't conflate stats and optimisations. Global iowait stats
>>> is there to stay, but ideally we want to never account io_uring as iowait.
>>> That's while there were talks about removing optimisation toggle at all
>>> (and do it as internal cpufreq magic, I suppose).
>>>
>>> How about posing it as an optimisation option only and that iowait stat
>>> is a side effect that can change. Explicitly spelling that in the commit
>>> message and in a comment on top of the flag in an attempt to avoid the
>>> uapi regression trap. We'd also need it in the option's man when it's
>>> written. And I'd also add "hint" to the flag name, like
>>> IORING_ENTER_HINT_NO_IOWAIT, as we might need to nop it if anything
>>> changes on the cpufreq side.
>>
>> Having potentially the control of both would be useful, the stat
> 
> It's not the right place to control the stat accounting though,
> apps don't care about iowait, it's usually monitored by a different
> entity / person from outside the app, so responsibilities don't
> match. It's fine if you fully control the stack, but just imagine

Sometimes those are one and the same thing, though - there's just the
one application running. That's not uncommon in data centers.

> a bunch of apps using different frameworks with io_uring inside
> that make different choices about it. The final iowait reading
> would be just a mess. With this patch at least we can say it's
> an unfortunate side effect.
> If we can separately control the accounting, a sysctl knob would
> probably be better, i.e. to be set globally from outside of an
> app, but I don't think we care enough to add extra logic / overhead
> for handling it.

That's not a bad idea, maybe we just do that for starters? We can always
introduce per-enter flags for managing boost and/or stats, at least it
provides a system wide setting that can just get overridden by flags,
should we need it.

>> accounting and the cpufreq boosting. I do think the current name is
>> better, though, the hint doesn't really add anything. I think we'd want
> 
> "Hint" tells the user that it's legit for the kernel to ignore
> it, including the iowait stat differences the user may see. And
> we may actually need to drop the flag if task->iowait knob will
> get hidden from io_uring in the future. The main benefit here
> is for it to be in the name, because there are always those who
> don't read comments.

But that's the part I have a problem with - sometimes you'd need to know
if it's honored or not.

-- 
Jens Axboe

