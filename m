Return-Path: <io-uring+bounces-5837-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 31261A0ABF8
	for <lists+io-uring@lfdr.de>; Sun, 12 Jan 2025 22:15:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F36EF18866AF
	for <lists+io-uring@lfdr.de>; Sun, 12 Jan 2025 21:15:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A78861BE86E;
	Sun, 12 Jan 2025 21:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J3LvWvV8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D895D1B4154;
	Sun, 12 Jan 2025 21:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736716508; cv=none; b=LIWioQ55WokY/nq77qxCZbuJnkr8HnOsxsuaXbdzSp6b0ZGVoDQBm5jqvZ1gGSpAc7WEMDZxmlkih9F6Hv9dwa93FARlPW8/oOnp/eHwFSqZNEp83AP//yvpSKlwSwqizcaHX7vdZWLNk7Ku97KoM72A4LCg5hCoOow95jJtd1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736716508; c=relaxed/simple;
	bh=gOSsIuQSIc8uWSuZHz7bg1G53W2m5ghIPXJ7dg2GHlk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MuCky1gtjeUpNlnX+rjFauX316uTovoV4tztMhD3Rr7wSNFJBmbORRsOetvdvskoJwhYu5ccsgLqjvyu9/FJf/Rjnflzw5gBcylKd/PGGHKcrLzyTSrawKYJ4xdzdalt1PXfy9K0yypZh3RG7SwdPKgsyGKI8FUA/IysyctPE4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J3LvWvV8; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5d3d2a30afcso6197273a12.3;
        Sun, 12 Jan 2025 13:15:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736716505; x=1737321305; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pdAUCp0DZFTOG5m3ONJYym9smVmwlL60yN8EM5RWQIw=;
        b=J3LvWvV8FEWZBsp21kgcUMbSgN3I6rCK7uZwq915r3enCSNmqkE7SSsEEroER8Y1Ov
         C8q+CV+Zbr0TD556kFimAfgETNoodyu2PCCzbyHxnwK0OyoaYlTYggmEAQ4+GM2kXv7u
         NTYOsFSzaMgK6dJs+IVMT6+om/sXIG7q2x9iy25JY+xcO0XH6pMYHqUvfdGTVK4yF4Y5
         Q1beYituSSO61PAJJa+5OaTCmsbRybMMJMUP3/dU/DPVQwgaw8LYzD7bug5mGonXKK3e
         EUifg/3WZ4ncLkc0UE+EuaHraL/kZqpN8OOKWOS+qgsy8Q0hSWq5ghfCqBn3rK+FYtI5
         I5Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736716505; x=1737321305;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pdAUCp0DZFTOG5m3ONJYym9smVmwlL60yN8EM5RWQIw=;
        b=THr2T1BMeiYqojvUPo7TiEiXbAYjUAz01dQ4l1e3MBycBA35Ylc4xa2t1y6NnQhcwU
         zOteX8aHqBd4nZthDiTEhHg5qn8GCk7/3QiEJnLcEjb45dFp7qT/v7puz8JsnY8+Ggzy
         WkINjQC7fvKgBwuPUeDCCI5/wKukei0rucY8X4QcXFlwfsfnokEbNzlWmbticz+MH10Z
         wgMW+JhEOmUrFepd/MiaI2oQyn3LsBAhxnCAIwaziNwISuSY/LEusM180KCU5cf/G799
         urYm1acKL4oHJNkW4dXzUus+D6tG9paGdhEr4QTXv2tAGmym2iHIi52PjM+vAP+FoF06
         q2bQ==
X-Forwarded-Encrypted: i=1; AJvYcCWHCyHJX2ZAfWcsbnECFZJ4a4ycC0TPRRRjZnCECDb9Y/E/3K91bc98R/7Vfce5Rhx80kYTTvaLeBxyB/G+@vger.kernel.org, AJvYcCXzadIAI0AnrE40i1MycD5bOeSitXYwL/mPaIQxPTYE3AsXFRm4pApk3lP4/3vYxGXzLDvixdur1A==@vger.kernel.org
X-Gm-Message-State: AOJu0YzWEH9tAKF+aaE1IS82uuJe8+fEf9rw09ubSBCCT01mEG8+ZOkI
	6mI8tncHCTw+vM6jbEcY7QduAEc1Af7MSW0TmbRi8QEuMFNbDEV6
X-Gm-Gg: ASbGnct7LepcEqGGluRk9IIFoII2zgJOxLmwv/FnHCHVK3TVPul019fxr5A9k2D5PJS
	ZwAJLQxWUuwY7xrq6IcWj4i5iNwXKhWqOjydjoSvldX9PCX6ihR9kGC4kiQLuK3snActs9ItbAj
	pGcHKh2SyXLhOGcnlp+USBREPt2uW/Qo16WFu0Z/iyWqvapU9Opfp4XkN6Rch+6l+3McMEZXa8G
	i8gZ7XLFgIb6vDyfDa4zKB5dkWI7MfJwh276asa7nbIA71C0KpvTQ46ep0TwcBAsDA=
X-Google-Smtp-Source: AGHT+IGvFBDg5CmY8LdKKEuk1KHTGsSxfxJhLKFYSBX/F6XQJrzKuwfyJ+im7TCsiuszMccRufMT7Q==
X-Received: by 2002:a05:6402:280e:b0:5d3:e9fd:9a15 with SMTP id 4fb4d7f45d1cf-5d972e6f473mr18011895a12.32.1736716504759;
        Sun, 12 Jan 2025 13:15:04 -0800 (PST)
Received: from [192.168.8.100] ([148.252.140.152])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d9903c309asm4259637a12.42.2025.01.12.13.15.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jan 2025 13:15:04 -0800 (PST)
Message-ID: <75e12d85-9c2e-4b06-99d1-bc29c5422b69@gmail.com>
Date: Sun, 12 Jan 2025 21:15:55 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: simplify the SQPOLL thread check when
 cancelling requests
To: Bui Quang Minh <minhquangbui99@gmail.com>, lizetao <lizetao1@huawei.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 "syzbot+3c750be01dab672c513d@syzkaller.appspotmail.com"
 <syzbot+3c750be01dab672c513d@syzkaller.appspotmail.com>
References: <20250112143358.49671-1-minhquangbui99@gmail.com>
 <aff011219272498a900f052d0142978c@huawei.com>
 <3cab5ad8-3089-46c7-868e-38bd3c250b26@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <3cab5ad8-3089-46c7-868e-38bd3c250b26@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/12/25 16:14, Bui Quang Minh wrote:
...
>>> @@ -2898,7 +2899,12 @@ static __cold void io_ring_exit_work(struct
>>> work_struct *work)
>>>           if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
>>>               io_move_task_work_from_local(ctx);
>>>
>>> -        while (io_uring_try_cancel_requests(ctx, NULL, true))
>>> +        /*
>>> +         * Even if SQPOLL thread reaches this path, don't force
>>> +         * iopoll here, let the io_uring_cancel_generic handle
>>> +         * it.
>>
>> Just curious, will sq_thread enter this io_ring_exit_work path?
> 
> AFAIK, yes. The SQPOLL thread is created with create_io_thread, this function creates a new task with CLONE_FILES. So all the open files is shared. There will be case that the parent closes its io_uring file and SQPOLL thread become the only owner of that file. So it can reach this path when terminating.

The function is run by a separate kthread, the sqpoll task doesn't
call it directly.

[...]
>>>> io_uring,
>>> -                                     cancel_all);
>>> +                                     cancel_all,
>>> +                                     true);
>>>           }
>>>
>>>           if (loop) {
>>> -- 
>>> 2.43.0
>>>
>>
>> Maybe you miss something, just like Begunkov mentioned in your last version patch:
>>
>>    io_uring_cancel_generic
>>      WARN_ON_ONCE(sqd && sqd->thread != current);
>>
>> This WARN_ON_ONCE will never be triggered, so you could remove it.
> 
> He meant that we don't need to annotate sqd->thread access in this debug check. The io_uring_cancel_generic function has assumption that the sgd is not NULL only when it's called by a SQPOLL thread. So the check means to ensure this assumption. A data race happens only when this function is called by other tasks than the SQPOLL thread, so it can race with the SQPOLL termination. However, the sgd is not NULL only when this function is called by SQPOLL thread. In normal situation following the io_uring_cancel_generic's assumption, the data race cannot happen. And in case the assumption is broken, the warning almost always is triggered even if data race happens. So we can ignore the race here.

Right. And that's the point of warnings, they're supposed to be
untriggerable, otherwise there is a problem with the code that
needs to be fixed.

-- 
Pavel Begunkov


