Return-Path: <io-uring+bounces-1441-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D2D089B4A7
	for <lists+io-uring@lfdr.de>; Mon,  8 Apr 2024 01:46:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E91D1F2123E
	for <lists+io-uring@lfdr.de>; Sun,  7 Apr 2024 23:46:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 924143BBFE;
	Sun,  7 Apr 2024 23:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BG5HEtDN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2BAE47F48;
	Sun,  7 Apr 2024 23:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712533610; cv=none; b=naQWoHdRLrwbg3pqJlLOVjDYfrfTSa5rMs3ilEYui2yHaA3hwZsDemfp+aBsVx9Kq1QfBeS2IjE63U8TEPdl2lPvPHXsU4caqS+kZV2rz1arau+dToPk8nWU8w2l0OHlugOMIPE/9BH81kK0gjIVPtIbaLaT4lwckN6nUUmGges=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712533610; c=relaxed/simple;
	bh=IGsTUZ2yVms9I0iyqQsYWf4iC+FSnHAR1pKHuXtkhA0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OsOk2BEeUFip8/hp4IjZ883JlWaPa4O4Tc4OFSJxwXzsw4j3oYcXbaYMf8+HiK0iYV6sk6VZa88CTwL+hu7yoKWQjCQHDcrJcP/8Mpk3rL6ShZxT2RK4OjPBVSrDVg2PtomFCN88sNOaT4wGQm/93Iu/HB4XpLlbtn/r1DQVGf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BG5HEtDN; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-343c7fae6e4so2567433f8f.1;
        Sun, 07 Apr 2024 16:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712533607; x=1713138407; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1aCu+fVrPuUWtldkGC+iCGr5hauMtng6T63RCtW8kqE=;
        b=BG5HEtDNySJlTyr3epgnm3Yv1z+YOLsw4r5m6lcIXFPpxs3oTFCmLIluwTPek5OXWa
         Tc+igMO9gWnZsA8vGjoNgssR02bn4FCmqIxwN/wDWwKUdwvxOBHQg75QtJfAnGNGYg0v
         iyIauki2FJX2/V9TmcGt9xiQMNLvKa/EOdh9hMWHIVmFqAaBTC1sCZ/SZEtKy+sXsmyI
         IgMMuXorZ0wt0+s4unEkj8PhNK8xvtzZI5svDgZWjvsuOCTu+flXzy1O1l+at4BuFodC
         GuZsbhfFH6ROs4To9TXYIqk3XPidWSbv2RNDeLUMJqBtV6SZGLCrxar/jDVYN+DhvBW0
         Nm2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712533607; x=1713138407;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1aCu+fVrPuUWtldkGC+iCGr5hauMtng6T63RCtW8kqE=;
        b=WfQqtSFb5z5fxsg6noICqb3PiJRaOW3T0xd8EX+SFiZ65m7hvkqkeWqa/EovDG6YSS
         bE5o98vs0kOUtXexDIApJM1QAeGqCs3SDuH01n09LAvBKe4kXJd8ncdc3Vr8SOU43N71
         oy4pJH3Tavjgep/r0Et+QmL9LjLgbEcctjpWUIEq6aO/0SvYQGTolJ0tfQ77UoQl1l2T
         mTc5U2h/GDZzDirV4DW3tDvng/6xLBK0A7QKDIRJxy7NPJwbpSJqPw5WN3/kpjGOmqyy
         BtAJ68YqG64uaP/tCMRoTdKby0psH9eF8Dv43+1NJwrXyD+h3IDeuPnpf/h6nb3gLKxK
         VM/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXLYpYbSAFxVgP8qLnlU4XqBDxuOdGj/DoIdmJrFC761iV9lGZRA/MRNfCfEhPHVb8HxIenf6rIb/c1HXzutxNBzAUTh/HF0Wom0I+q
X-Gm-Message-State: AOJu0YwRGAk4cKWSpW0s4474dqPf0Co+hQPTfyIOcxaj5leYNXI8MF0O
	eFfca4kta2mH5eO7MGQlD7YdKFI/OkFhqjXJezSSfC1oR2MbbX5w
X-Google-Smtp-Source: AGHT+IE3Vmc4B1x1TnCrZc2/mzpvJdpQ2dwaNXMjWNcuVYk6jefJGq3qhxqPX1WAZ25xAb+sHubDQA==
X-Received: by 2002:a5d:64e9:0:b0:343:8b9e:be4a with SMTP id g9-20020a5d64e9000000b003438b9ebe4amr5448144wri.71.1712533606912;
        Sun, 07 Apr 2024 16:46:46 -0700 (PDT)
Received: from [192.168.42.234] ([85.255.235.79])
        by smtp.gmail.com with ESMTPSA id t14-20020a5d6a4e000000b0033b48190e5esm7557673wrw.67.2024.04.07.16.46.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Apr 2024 16:46:46 -0700 (PDT)
Message-ID: <09f1a8e9-d9ad-4b40-885b-21e1c2ba147b@gmail.com>
Date: Mon, 8 Apr 2024 00:46:44 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] io_uring: Add REQ_F_CQE_SKIP support for io_uring
 zerocopy
To: Oliver Crumrine <ozlinuxc@gmail.com>, axboe@kernel.dk
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1712268605.git.ozlinuxc@gmail.com>
 <b1a047a1b2d55c1c245a78ca9772c31a9b3ceb12.1712268605.git.ozlinuxc@gmail.com>
 <6850f08d-0e89-4eb3-bbfb-bdcc5d4e1b78@gmail.com>
 <CAK1VsR17Ea6cmks7BcdvS4ZHQMRz_kWd1NhPh8J1fUpsgC7WFg@mail.gmail.com>
 <c2e63753-5901-47b2-8def-1a98d8fcdd41@gmail.com>
 <CAK1VsR210nrqtxWaVbQh00t_=7rhq9bwucFygGZaT=7N-t7E5Q@mail.gmail.com>
 <CAK1VsR1b-dbAa8pMqGvfcAAcVP3ZkTYZdyqcaK4wJdbuAZtJsA@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAK1VsR1b-dbAa8pMqGvfcAAcVP3ZkTYZdyqcaK4wJdbuAZtJsA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/7/24 20:14, Oliver Crumrine wrote:
> Oliver Crumrine wrote:
>> Pavel Begunkov wrote:
>>> On 4/5/24 21:04, Oliver Crumrine wrote:
>>>> Pavel Begunkov wrote:
>>>>> On 4/4/24 23:17, Oliver Crumrine wrote:
>>>>>> In his patch to enable zerocopy networking for io_uring, Pavel Begunkov
>>>>>> specifically disabled REQ_F_CQE_SKIP, as (at least from my
>>>>>> understanding) the userspace program wouldn't receive the
>>>>>> IORING_CQE_F_MORE flag in the result value.
>>>>>
>>>>> No. IORING_CQE_F_MORE means there will be another CQE from this
>>>>> request, so a single CQE without IORING_CQE_F_MORE is trivially
>>>>> fine.
>>>>>
>>>>> The problem is the semantics, because by suppressing the first
>>>>> CQE you're loosing the result value. You might rely on WAITALL
>>>> That's already happening with io_send.
>>>
>>> Right, and it's still annoying and hard to use
>> Another solution might be something where there is a counter that stores
>> how many CQEs with REQ_F_CQE_SKIP have been processed. Before exiting,
>> userspace could call a function like: io_wait_completions(int completions)
>> which would wait until everything is done, and then userspace could peek
>> the completion ring.
>>>
>>>>> as other sends and "fail" (in terms of io_uring) the request
>>>>> in case of a partial send posting 2 CQEs, but that's not a great
>>>>> way and it's getting userspace complicated pretty easily.
>>>>>
>>>>> In short, it was left out for later because there is a
>>>>> better way to implement it, but it should be done carefully
>>>> Maybe we could put the return values in the notifs? That would be a
>>>> discrepancy between io_send and io_send_zc, though.
>>>
>>> Yes. And yes, having a custom flavour is not good. It'd only
>>> be well usable if apart from returning the actual result
>>> it also guarantees there will be one and only one CQE, then
>>> the userspace doesn't have to do the dancing with counting
>>> and checking F_MORE. In fact, I outlined before how a generic
>>> solution may looks like:
>>>
>>> https://github.com/axboe/liburing/issues/824
>>>
>>> The only interesting part, IMHO, is to be able to merge the
>>> main completion with its notification. Below is an old stash
>>> rebased onto for-6.10. The only thing missing is relinking,
>>> but maybe we don't even care about it. I need to cover it
>>> well with tests.
>> The patch looks pretty good. The only potential issue is that you store
>> the res of the normal CQE into the notif CQE. This overwrites the
>> IORING_CQE_F_NOTIF with IORING_CQE_F_MORE. This means that the notif would
>> indicate to userspace that there will be another CQE, of which there
>> won't.
> I was wrong here; Mixed up flags and result value.

Right, it's fine. And it's synchronised by the ubuf refcounting,
though it might get more complicated if I'd try out some counting
optimisations.

FWIW, it shouldn't give any performance wins. The heavy stuff is
notifications waking the task, which is still there. I can even
imagine that having separate CQEs might be more flexible and would
allow more efficient CQ batching.

-- 
Pavel Begunkov

