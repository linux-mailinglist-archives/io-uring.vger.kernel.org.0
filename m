Return-Path: <io-uring+bounces-11010-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 99976CB581A
	for <lists+io-uring@lfdr.de>; Thu, 11 Dec 2025 11:23:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4EB7C300B815
	for <lists+io-uring@lfdr.de>; Thu, 11 Dec 2025 10:22:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48F1230102C;
	Thu, 11 Dec 2025 10:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="duJ0ez4s"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f195.google.com (mail-pg1-f195.google.com [209.85.215.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C8D2F12C5
	for <io-uring@vger.kernel.org>; Thu, 11 Dec 2025 10:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765448578; cv=none; b=AEkIioCJtwHMyRXUc4hhYBDEEiJncX2If4zV4kNEhTFOe7zDxlfFAmZ7zRenfkpxgL7zyoVkXR/VmbYYVTbgVc9Y99sMwrpHg55sndETlw0vv0m5fN3fDYsmkHZGukVCGtNV/+J1WFpKbGkJMZztX/KcAVdPNWISUDgOqxpVH3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765448578; c=relaxed/simple;
	bh=baDSDTMvek8vkcf0Ti8D2ze6XVs1zjIUlmvLctqkwdg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UpG2IxITzlHggAOBAJKAvq4gqrMSnMpjw2HfJO9syM7Ok9Z5SpgxJOEWfC2gzfn27pGLIK07wk5iyTgNVUodV2WKTOT3OqVCbbrappEYGAuaTNj3nP76cciT3L15rnbDOkFTJRaAbdTfA6VAYIy7ssUcI6Ij6aYQ7hCKVyEBjgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=duJ0ez4s; arc=none smtp.client-ip=209.85.215.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f195.google.com with SMTP id 41be03b00d2f7-c03eb31db80so570770a12.2
        for <io-uring@vger.kernel.org>; Thu, 11 Dec 2025 02:22:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1765448572; x=1766053372; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=si7vl7VUK7Lo23hN0BR/dCR9HmeR9y7KfIxeWyd2/u0=;
        b=duJ0ez4s7gLR7fObb5KZVP+lzor+3xke2PVRS0oS2FTuFLRc86XfLBLgXwrsrwa759
         QGSDQakkECQDlBl8XP72gXAEKbp13aE4oHySzQ8vWeoxwSRRhxB7evfwFCaxiVnpdh9r
         F/79bNiO7pZlsSHNJCLRJ6KEnX6M9bsFjCYcX9xdhkLPuKszuww5eoIOxStfZFlCh5xl
         KU2Nng9AKoqaX/oxj7rK838qokoTgDH53jVsprVO4OjITV/olNtOv56p7DIYiBeRri9U
         TG85L/NOQrEfZgwtU9oA5XPc6C8OajJvK06De15ZVBFw5/WpYiJBx9bVV5sNGlxNcP39
         HCqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765448572; x=1766053372;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=si7vl7VUK7Lo23hN0BR/dCR9HmeR9y7KfIxeWyd2/u0=;
        b=bKycQx5H7vpDoy0M+yntrvrE8AJ8UbOxHBhC7zTQUvQ1KRkX6nvqMjU67ycm9YhZtU
         LeIFm61xdhvrP5S8/ikKxuof/s9Rpw93G1oGdB+QElm4OOHXKAEoA0axouOGQcJQfOFF
         7fquucfCqHyMhc/3mHem2XveCk/U+cPt1eqQBspXkBbaZj3vl4ooLgygtcsYdV0Mx420
         yNf2Tgwjudlh0G+T5PZOeopZ5okoaXYgsZCk8p36RdIKNOEWVYZaJRSSWD9UkyunlFwY
         e/MH3d1J/G4ffFwJRzK1LqFaPNmH+kU2Zcz1S240ShTfd1gfSkVZZj1YPwxubyTZZrWV
         sc9A==
X-Forwarded-Encrypted: i=1; AJvYcCXYJ01xqomfUBrc5yyI4guBSYnK5wl+uHWIkKr7N4tD8kONQSt74misKbeG11h2KZzz47IaJgf+wQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4q+ltGsx6nH22Pb7e+EEFirhKjwPleNCFJBxH92JxxrQwyJOe
	t7yNp/5Z4gc2gZ73uKbtUr2T7xOLn9z0/TrGzrY4nMAms2BJ6+exXZb1g2imsPgxlzZFZCcyeZn
	U+uHZPM/kJx7K
X-Gm-Gg: AY/fxX5dfc/VrSWVmZPJdYecGWli8MNF8K3SYBGDQCRrPwqwfp/7NAlK5EAb9rWDdbq
	+pcTDo0+US9kKz94YWjwS9nfdOTav20UwyjQyegPKWi598i8lBbExXE0A1wPAJk1urVpwh9Se03
	nsu3J4sEqXb2t9CIb7Ua535i0WmPurYynGIWK6O9lkp7ArQx0FaxqSOoXhKkTUyszZiHqAh6C/w
	5y60w8TWuuRTQGFcrOWchSkku9sOs/ZB9Yvl5rQSey9tm7A6VyXJj6zhItDlYf+L2TD6ppN/Q1d
	SahHb688FIj5288RcdcJRYd8njiylOeP4ieK6ANIuOBFe5vc3KF6Cj87xRRjdcgUSL6Nookw8Kb
	1AKMbMdA+aw09I8iMb0Uy5xj8D+xmfeNvabIyWJP7DvmPPPw3b9B11/kAvM4aKvhoEuyZAMUi+L
	oI2cQnh+j4PdpkigjrODqZ07Ic6W4y09kf7rvoc99WJYiP2Ephfw60Uib5ikM5
X-Google-Smtp-Source: AGHT+IGoPg+xvCJxOGtqcnCnhHJm4s6wvEg8cscljZdxJ/AEUbcSpD9eY+67N3Cbpf+lSNAC8S4f+A==
X-Received: by 2002:a05:7301:4286:b0:2ac:816:f31e with SMTP id 5a478bee46e88-2ac0816f3afmr2730478eec.29.1765448571919;
        Thu, 11 Dec 2025 02:22:51 -0800 (PST)
Received: from [172.20.4.188] (221x255x142x61.ap221.ftth.ucom.ne.jp. [221.255.142.61])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ac190acd01sm5123044eec.1.2025.12.11.02.22.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Dec 2025 02:22:51 -0800 (PST)
Message-ID: <0654d130-665a-4b1a-b99b-bb80ca06353a@kernel.dk>
Date: Thu, 11 Dec 2025 03:22:49 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] io_uring: fix io may accumulation in poll mode
To: Fengnan <fengnanchang@gmail.com>, asml.silence@gmail.com,
 io-uring@vger.kernel.org
Cc: Fengnan Chang <changfengnan@bytedance.com>,
 Diangang Li <lidiangang@bytedance.com>
References: <20251210085501.84261-1-changfengnan@bytedance.com>
 <20251210085501.84261-3-changfengnan@bytedance.com>
 <ca81eb74-2ded-44dd-8d6b-42a131c89550@kernel.dk>
 <69f81ed8-2b4a-461f-90b8-0b9752140f8d@kernel.dk>
 <0661763c-4f56-4895-afd2-7346bb2452e4@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <0661763c-4f56-4895-afd2-7346bb2452e4@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/11/25 12:38 AM, Fengnan wrote:
> 
> 
> ? 2025/12/11 12:10, Jens Axboe ??:
>> On 12/10/25 7:15 PM, Jens Axboe wrote:
>>> On 12/10/25 1:55 AM, Fengnan Chang wrote:
>>>> In the io_do_iopoll function, when the poll loop of iopoll_list ends, it
>>>> is considered that the current req is the actual completed request.
>>>> This may be reasonable for multi-queue ctx, but is problematic for
>>>> single-queue ctx because the current request may not be done when the
>>>> poll gets to the result. In this case, the completed io needs to wait
>>>> for the first io on the chain to complete before notifying the user,
>>>> which may cause io accumulation in the list.
>>>> Our modification plan is as follows: change io_wq_work_list to normal
>>>> list so that the iopoll_list list in it can be removed and put into the
>>>> comp_reqs list when the request is completed. This way each io is
>>>> handled independently and all gets processed in time.
>>>>
>>>> After modification,  test with:
>>>>
>>>> ./t/io_uring -p1 -d128 -b4096 -s32 -c32 -F1 -B1 -R1 -X1 -n1 -P1
>>>> /dev/nvme6n1
>>>>
>>>> base IOPS is 725K,  patch IOPS is 782K.
>>>>
>>>> ./t/io_uring -p1 -d128 -b4096 -s32 -c1 -F1 -B1 -R1 -X1 -n1 -P1
>>>> /dev/nvme6n1
>>>>
>>>> Base IOPS is 880k, patch IOPS is 895K.
>>> A few notes on this:
>>>
>>> 1) Manipulating the list in io_complete_rw_iopoll() I don't think is
>>>     necessarily safe. Yes generally this is invoked from the
>>>     owning/polling task, but that's not guaranteed.
>>>
>>> 2) The patch doesn't apply to the current tree, must be an older
>>>     version?
>>>
>>> 3) When hand-applied, it still throws a compile warning about an unused
>>>     variable. Please don't send untested stuff...
>>>
>>> 4) Don't just blatantly bloat the io_kiocb. When you change from a
>>>     singly to a doubly linked list, you're growing the io_kiocb size. You
>>>     should be able to use a union with struct io_task_work for example.
>>>     That's already 16b in size - win/win as you don't need to slow down
>>>     the cache management as that can keep using the linkage it currently
>>>     is using, and you're not bloating the io_kiocb.
>>>
>>> 5) The already mentioned point about the cache free list now being
>>>     doubly linked. This is generally a _bad_ idea as removing and adding
>>>     entries now need to touch other entries too. That's not very cache
>>>     friendly.
>>>
>>> #1 is kind of the big one, as it means you'll need to re-think how you
>>> do this. I do agree that the current approach isn't necessarily ideal as
>>> we don't process completions as quickly as we could, so I think there's
>>> merrit in continuing this work.
>> Proof of concept below, entirely untested, at a conference. Basically
>> does what I describe above, and retains the list manipulation logic
>> on the iopoll side, rather than on the completion side. Can you take
>> a look at this? And if it runs, can you do some numbers on that too?
> 
> This patch works, and in my test case, the performance is identical to
> my patch.

Good!

> But there is a small problem, now looking for completed requests,
> always need to traverse the whole iopoll_list. this can be a bit
> inefficient in some cases, for example if the previous sent 128K io ,
> the last io is 4K, the last io will be returned much earlier, this
> kind of scenario can not be verified in the current test. I'm not sure
> if it's a meaningful scenario.

Not sure that's a big problem, you're just spinning to complete anyway.
You could add your iob->nr_reqs or something, and break after finding
those know have completed. That won't necessarily change anything, could
still be the last one that completed. Would probably make more sense to
pass in 'min_events' or similar and stop after that. But I think mostly
tweaks that can be made after the fact. If you want to send out a new
patch based on the one I sent, feel free to.

-- 
Jens Axboe

