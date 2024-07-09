Return-Path: <io-uring+bounces-2471-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E3E092BC72
	for <lists+io-uring@lfdr.de>; Tue,  9 Jul 2024 16:05:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 15BB11C21010
	for <lists+io-uring@lfdr.de>; Tue,  9 Jul 2024 14:05:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7934E19B5B7;
	Tue,  9 Jul 2024 14:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i/p/WvO/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5E5154BF0;
	Tue,  9 Jul 2024 14:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720533916; cv=none; b=TgVvIGwf1D4aKRonnsivVrV/jXkKQJNO7xgSoxsifNMVZ2jpIeMo2xOeADr0bclnLFJNZF/d1wXzsU27NFqBLIm6I/lH/ayUw86g5O0gNaLm2TECF6jgd5yvHY2T/Blu0IHlLi3o64Jb99t3TwqQrwN7nqimdWz4W9uONIZOURU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720533916; c=relaxed/simple;
	bh=oqvO4keAigILRKoADfBFYu3hAGj3/wdIa/oLCwjA/9s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ge/9MyV0m+4gR5o0fi+YCVM6P6B74D2nvGIhe7n540l3sdGIa9sChh1mGbmA6o8V/naeEpOX8tw+ZWQtG9zTmTbkJjijMpBW1Let7xU9pimqs+a3DhWZo4Aq+o2sdGNBiw6dcby5fZTXHInCGIBPXWc32NPCjzg8fObde57rgPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i/p/WvO/; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-58b447c511eso6467947a12.2;
        Tue, 09 Jul 2024 07:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720533913; x=1721138713; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kMRvSct0lY9z/NoSUo1v54IeShU8S8Pa37iemae3ynQ=;
        b=i/p/WvO/sLgHTiX9nXKQth9O9Y8NQPWTGctNOqvWf2+3LQ6rJCr3ySaV+NLbHkTghc
         OHk9/VOzSvg4wdOwBcXGHX5HyRLz6OlTz7zBtekCFLJPmMxpHISBjKGFIA86e9KQkNfE
         qEr8C8bNsIuqdDpELoyzQx6WenNvuf15VZWr1RttMHEphZEqcHgMZBm/dhG4d2ucuwU8
         a0iN7CIJLddLSLm9QZmZkssH+kqyXAjsF8YI572kIJWQBN1RmBLYSB4u00+JNSpxr/RB
         ZTNWMuAAi/hE/KvO/drHS6j1vH2rJ740YQ7Q96k0eltbrzje+S1yrB0nv+yM/7aWCPrJ
         DkbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720533913; x=1721138713;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kMRvSct0lY9z/NoSUo1v54IeShU8S8Pa37iemae3ynQ=;
        b=SG5UGmCiMAwUkFYygNAbvu9gB4TgLtra/radwzFD588v6Fw5Qg7e20uwAvGCI1xV1G
         LlZbRhXMR44VM0bpZh85/z1ipGFrXjGcf3wzQD/5ASHtp72i7hpKkrOYVE3C5YSOuxrq
         tpS5R4uMJLpvXLjUECrczH4jYdnPvFIWf0JuP8N5Up7HP+O68MdqAeEsLuDrGWcBO+nC
         6mRhaCT0WXSVGBIResnfi8+B2La0G5U1fJfgPCA2MxqRsJklxbIFCCAjL7h8j0Wtj0tD
         MONoxPZVqvBOuOMxwJ3wWDVgkAHOY7YHoJzxMepQsWjahkqhpfywP1OtFwjYsRpQ4RMO
         bJAw==
X-Forwarded-Encrypted: i=1; AJvYcCXbpSWxD7TNEp8Q2E8PB3DtliUV8C1EjQ/AYZSPPOZGe36nvIk3LTYXnoD4dDQw8TC22E8swyKWn3HGya4iYhg0avsXB+gXSGdNt4b2
X-Gm-Message-State: AOJu0YyAab/0O7Hr6/4TStD/e4Oz4rvdSlVNfg3jYPZeBRKwfSN/F/dg
	ZmDbeCKa+JxreL93pO6vVFl0lM4tXwgXYm6ryz42GCQSswau3kOD
X-Google-Smtp-Source: AGHT+IG3BjNIVmMYpuvl3fYCgUGix6nCBcluBpFeqb72PFJUpbosIet4/3KiWZHgriXRnsmdz6d0Mg==
X-Received: by 2002:a17:906:68c9:b0:a77:e48d:bb2 with SMTP id a640c23a62f3a-a780b6b17cfmr211654866b.17.1720533912844;
        Tue, 09 Jul 2024 07:05:12 -0700 (PDT)
Received: from [192.168.42.197] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a780a7ff7c7sm79796666b.100.2024.07.09.07.05.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 07:05:12 -0700 (PDT)
Message-ID: <658da3fe-fa02-423b-aff0-52f54e1332ee@gmail.com>
Date: Tue, 9 Jul 2024 15:05:21 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] kernel: rerun task_work while freezing in
 get_signal()
To: Oleg Nesterov <oleg@redhat.com>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Andrew Morton <akpm@linux-foundation.org>,
 Christian Brauner <brauner@kernel.org>,
 Tycho Andersen <tandersen@netflix.com>, Thomas Gleixner
 <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
 Julian Orth <ju.orth@gmail.com>, Tejun Heo <tj@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>
References: <cover.1720368770.git.asml.silence@gmail.com>
 <1d935e9d87fd8672ef3e8a9a0db340d355ea08b4.1720368770.git.asml.silence@gmail.com>
 <20240708104221.GA18761@redhat.com>
 <62c11b59-c909-4c60-8370-77729544ec0a@gmail.com>
 <20240709103617.GB28495@redhat.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240709103617.GB28495@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/9/24 11:36, Oleg Nesterov wrote:
> On 07/08, Pavel Begunkov wrote:
>>
>> On 7/8/24 11:42, Oleg Nesterov wrote:
>>> I don't think we should blame io_uring even if so far it is the only user
>>> of TWA_SIGNAL.
>>
>> And it's not entirely correct even for backporting purposes,
>> I'll pin it to when freezing was introduced then.
> 
> This is another problem introduced by 12db8b690010 ("entry: Add support for
> TIF_NOTIFY_SIGNAL")

Ah, yes, I forgot NOTIFY_SIGNAL was split out of SIGPENDING

> We need much more changes. Say, zap_threads() does the same and assumes
> that only SIGKILL or freezeing can make dump_interrupted() true.
> 
> There are more similar problems. I'll try to think, so far I do not see
> a simple solution...

Thanks. And there was some patching done before against dumping
being interrupted by task_work, indeed a reoccurring issue.


> As for this particular problem, I agree it needs a simple/backportable fix.
> 
>>>>   relock:
>>>> +	clear_notify_signal();
>>>> +	if (unlikely(task_work_pending(current)))
>>>> +		task_work_run();
>>>> +
>>>>   	spin_lock_irq(&sighand->siglock);
>>>
>>> Well, but can't we kill the same code at the start of get_signal() then?
>>> Of course, in this case get_signal() should check signal_pending(), not
>>> task_sigpending().
>>
>> Should be fine,
> 
> Well, not really at least performance-wise... get_signal() should return
> asap if TIF_NOTIFY_SIGNAL was the only reason to call get_signal().
> 
>> but I didn't want to change the
>> try_to_freeze() -> __refrigerator() path, which also reschedules.
> 
> Could you spell please?

Let's say it calls get_signal() for freezing with a task_work pending.
Currently, it executes task_work and calls try_to_freeze(), which
puts the task to sleep. If we remove that task_work_run() before
try_to_freeze(), it would not be able to sleep. Sounds like it should
be fine, it races anyway, but I'm trying to avoid side effect for fixes.

>>> Or perhaps something like the patch below makes more sense? I dunno...
>>
>> It needs a far backporting, I'd really prefer to keep it
>> lean and without more side effects if possible, unless
>> there is a strong opinion on that.
> 
> Well, I don't think my patch is really worse in this sense. Just it
> is buggy ;) it needs another recalc_sigpending() before goto start,
> so lets forget it.
> 
> So I am starting to agree with your change as a workaround until we
> find a clean solution (if ever ;).
> 
> But can I ask you to add this additional clear_notify_signal() +
> task_work_run() to the end of do_freezer_trap() ? get_signal() is
> already a mess...

Will change

> -----------------------------------------------------------------------
> Either way I have no idea whether a cgroup_task_frozen() task should
> react to task_work_add(TWA_SIGNAL) or not.
> 
> Documentation/admin-guide/cgroup-v2.rst says
> 
> 	Writing "1" to the file causes freezing of the cgroup and all
> 	descendant cgroups. This means that all belonging processes will
> 	be stopped and will not run until the cgroup will be explicitly
> 	unfrozen.
> 
> AFAICS this is not accurate, they can run but can't return to user-mode.
> So I guess task_work_run() is fine.

IIUC it's a user facing doc, so maybe it's accurate enough from that
perspective. But I do agree that the semantics around task_work is
not exactly clear.

-- 
Pavel Begunkov

