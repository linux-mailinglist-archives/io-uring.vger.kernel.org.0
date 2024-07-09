Return-Path: <io-uring+bounces-2478-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DBED592C3E1
	for <lists+io-uring@lfdr.de>; Tue,  9 Jul 2024 21:26:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 29D7F283C5C
	for <lists+io-uring@lfdr.de>; Tue,  9 Jul 2024 19:26:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A09E3144D29;
	Tue,  9 Jul 2024 19:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="acmoILYP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4001B86C9;
	Tue,  9 Jul 2024 19:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720553212; cv=none; b=ajKF8f+T2dHFLpm1df1pFsu0aTEkDSpNhu4Xcws/XEfr6pOi4y9sfhUU0WHAcjcb7a0u0M5YYUq+vBnZs1Reg0WzUKucgJ/Ao23mgOnFPJrCa3WuAgPQuhh92XzbHxi9W74ZeBtHDY5PxHjFynQBbiEBSssg9attQsgPVDQxxgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720553212; c=relaxed/simple;
	bh=1Rep24U8JtuvtSnlbLq8XyraNP75pXoMYlPXmPJORgM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tpqNkEV2eKqCnnAr8Lu0yXZ5i/gEmorakUvRo935yI6Zg9FK3mMaI/CXaH2wjs9vZcpF1MFxpzPF+2Vc9JmmF3JtZZVB7TI6L69MGL1rLi4CjElazChTFhGGwtb29z6VWxHu5xtYPrPRXljPPXsJ4hytcvXVqdyu8geshTuBBYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=acmoILYP; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2ee9b098bd5so49786711fa.0;
        Tue, 09 Jul 2024 12:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720553209; x=1721158009; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VlzucciAEK5IyU0Y2LaBT/n/FoJVAJOkfoOJxJ3dyIM=;
        b=acmoILYPhUhXA+D9UiTARqo2s1DAG3wvVhVfFVRsLarZ/e61ZG3Pu8KU/TQBOtvs5p
         wo8DW2k48en1XLSk9dVmTJDJxWhgPkcDMHmHaf2XlPrMxDLgTgCG2sXlOy/MOarylSKc
         ay55rfc3PNtDToALY8/NtIvw/0B8iFFjUJonVlxZbB/dvgS5yptTAvDWxrPDBBuDiJtp
         9OOpqlHm+u1hEdeyPJe3PGRzhQWonQumO+Q+CumZxUy7u85ZiGjNYwhk3HGNmPDxxdjm
         2RkAaZp2VvVzTowiDKsgvGYtzoRu6EniJbvEJnE6GW20PFrnXdl2U6TNaHbW1RuVyoMw
         B4/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720553209; x=1721158009;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VlzucciAEK5IyU0Y2LaBT/n/FoJVAJOkfoOJxJ3dyIM=;
        b=GJlJzFLnRagCdeiIEplwDQzsd/1qlB+A0y/ucQ7yGRuQZpSRCAIAF464n7lL2wnQXC
         NPusnq1HzegpnS173YrKG6NVt8TZiJ4fbL9hcuot4Y1wbew8tPfjMhTlGmirqJmilfQ8
         0Kvq9mxeF6NDO7eIW5pr5ie14eSQRI8d4We2pNHhlAG7OYvoCDgnwxDd8Ag1cZ2ypqpd
         yAvGmDZ4KovA49B+pIZ/14BJxpcKNuPb9p8XM/FEj/LDhecLIz6CvPwshQ33VxaP9nk9
         zCU4pYn8FOYSr91JcXEHx5ZtP4rl2MC4qZQi1lzQ3r+R8fef3qIZZBgsjo2wXF75cldh
         6oqQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJ9WCsBOCJzy1DA5aorsjj8ti5GhWsCMGnv3DEaLa8lFQnQz3oU9Tfznm5UI1N+ygkEJCExfc4fPkyWswD6Nl8S6Le/iqGsi3F43rB
X-Gm-Message-State: AOJu0YwxKPLA1vBhRH6rqOUU9IlHvqMwGYcGKu8Sbn4c0IBway/WgxBz
	lJFNwIyWJGunzPsqMu7e2zYx9ilWNMAtQqxZksnjJDR5U6eTQH/a
X-Google-Smtp-Source: AGHT+IHg783yiXF4Ft+iDt5WqfZaszG2oTjdUJQSGqgm5JMqAKbAIO1TqQqcbm5TBWz6Qs3M1S7qUg==
X-Received: by 2002:a05:651c:201:b0:2ee:7a71:6e2d with SMTP id 38308e7fff4ca-2eeb30fee15mr27794691fa.28.1720553208709;
        Tue, 09 Jul 2024 12:26:48 -0700 (PDT)
Received: from [192.168.42.222] ([148.252.145.239])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4266f6e09e5sm53289275e9.5.2024.07.09.12.26.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 12:26:48 -0700 (PDT)
Message-ID: <d2667002-1631-4f42-8aad-a9ea56c0762b@gmail.com>
Date: Tue, 9 Jul 2024 20:26:56 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] kernel: rerun task_work while freezing in
 get_signal()
To: Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Andrew Morton <akpm@linux-foundation.org>,
 Christian Brauner <brauner@kernel.org>,
 Tycho Andersen <tandersen@netflix.com>, Thomas Gleixner
 <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
 Julian Orth <ju.orth@gmail.com>, Peter Zijlstra <peterz@infradead.org>
References: <cover.1720368770.git.asml.silence@gmail.com>
 <1d935e9d87fd8672ef3e8a9a0db340d355ea08b4.1720368770.git.asml.silence@gmail.com>
 <20240708104221.GA18761@redhat.com>
 <62c11b59-c909-4c60-8370-77729544ec0a@gmail.com>
 <20240709103617.GB28495@redhat.com>
 <658da3fe-fa02-423b-aff0-52f54e1332ee@gmail.com>
 <Zo1ntduTPiF8Gmfl@slm.duckdns.org> <20240709190743.GB3892@redhat.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240709190743.GB3892@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/9/24 20:07, Oleg Nesterov wrote:
> Hi Tejun,
> 
> Thanks for looking at this, can you review this V2 patch from Pavel?
> To me it makes sense even without 1/2 which I didn't even bother to
> read. At least as a simple workaround for now.

They are kind of separate but without 1/2 this patch creates
another infinite loop, even though it's harder to hit and
is io_uring specific.

  
> On 07/09, Tejun Heo wrote:
>>
>> Hello,
>>
>> On Tue, Jul 09, 2024 at 03:05:21PM +0100, Pavel Begunkov wrote:
>>>> -----------------------------------------------------------------------
>>>> Either way I have no idea whether a cgroup_task_frozen() task should
>>>> react to task_work_add(TWA_SIGNAL) or not.
>>>>
>>>> Documentation/admin-guide/cgroup-v2.rst says
>>>>
>>>> 	Writing "1" to the file causes freezing of the cgroup and all
>>>> 	descendant cgroups. This means that all belonging processes will
>>>> 	be stopped and will not run until the cgroup will be explicitly
>>>> 	unfrozen.
>>>>
>>>> AFAICS this is not accurate, they can run but can't return to user-mode.
>>>> So I guess task_work_run() is fine.
>>>
>>> IIUC it's a user facing doc, so maybe it's accurate enough from that
>>> perspective. But I do agree that the semantics around task_work is
>>> not exactly clear.
>>
>> A good correctness test for cgroup freezer is whether it'd be safe to
>> snapshot and restore the tasks in the cgroup while frozen.
> 
> Well, I don't really understand what can snapshot/restore actually mean...

CRIU, I assume. I'll try it ...

> I forgot everything about cgroup freezer and I am already sleeping, but even
> if we forget about task_work_add/TIF_NOTIFY_SIGNAL/etc, afaics ptrace can
> change the state of cgroup_task_frozen() task between snapshot and restore ?

... but I'm inclined to think the patch makes sense regardless,
we're replacing an infinite loop with wait-wake-execute-wait.

-- 
Pavel Begunkov

