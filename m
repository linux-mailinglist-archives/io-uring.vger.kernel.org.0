Return-Path: <io-uring+bounces-1494-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AB9589F1A7
	for <lists+io-uring@lfdr.de>; Wed, 10 Apr 2024 14:05:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F8CC28188F
	for <lists+io-uring@lfdr.de>; Wed, 10 Apr 2024 12:05:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB63215B0EC;
	Wed, 10 Apr 2024 12:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HqqMgBR1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C105A159212;
	Wed, 10 Apr 2024 12:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712750727; cv=none; b=X8Adfmj5vyXTi4zMXiZa8uoUZcNFJitxeQXVxBrokwmkngDM130NhyQ+jDZbL36oQd0KjzHWJXUIJ4mv+kBXAVZs7TE8d50YjqekbUh+hedzucdwm11CAbsXHTWpvnzGUcr2saM5/Fy/x18+38La2Omj2OTOar7rvx387ibTmdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712750727; c=relaxed/simple;
	bh=6UIvE1vJ9dY5K/ZKwsDosbMPf9oc8CxaWo6AitfqY2s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DoKvrro5TH6mMahQGdcb3iO3aBR7DrsVKNQzotzasARzwDJSSLprJW4+3ip0P6W+C0hk81ldhVrwCkpy5IxVdbFnJe2F0fqRwso3+tuCGEWoam6Vp0o1e7tn8JXqN5z/tkz2/PW6bL4bviHud0jd++0dau5NG//RopkgmH7Y5pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HqqMgBR1; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a51ddc783e3so390249366b.0;
        Wed, 10 Apr 2024 05:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712750724; x=1713355524; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v0aRCEy+AeR0j13+VeOvZ523IAIwGMuni9MFBE/6V3A=;
        b=HqqMgBR1qrTCX6hRiDGXXKgtxdOemI/x9IY/inxuhb/LPXlitWYCWznwub2Or/OlU5
         oGbUZko/20R62+wRQwUITaOyHQXi+HiPhNVZrKLdYJPaP1knSf2YIDssO9VjaK8AlQw6
         ZEWjz/gUSkaK+Eehm7ufs5QstAwVqomwSyvr6SRbsjUtMy/KXR4/aNXF0nUOCmmFe/gk
         qyu3lp8CqR42xesApj2mDaxbSOyJzAdFxTGig9IsH0h4ofGJ4hEVV3/oCpJuVfP+tLtx
         moE4Ipeh9W7oHUkO6IYCayZP6PPfZ2GKh6zRAzbBcIKblHK3h6gejuZgTl7QzD5sLvEj
         kfxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712750724; x=1713355524;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v0aRCEy+AeR0j13+VeOvZ523IAIwGMuni9MFBE/6V3A=;
        b=nyoxNRClU5XLx4ngzMArDQU4NglKg7qm7B5i1F/d7m+B2FtW0yPo3Xm1GughUCjIqb
         gwsbE5I0khjCSNxLH0X2UKwgoZEbv3321VcqT7kspQIZUEhjX0kFHgDpTyM2214iRpsg
         ZZUNa4guHuy+GcC9epLtrYZ/vSX2PleBoNE8ZMToll0iRaHHY+rAOxORtzMBr4Yn6FDZ
         cx5NPJFdad6WrBYTqOvW0EOdVAs0aAwo4yd+1RLJGIGLcEBqhK9nwSrDDBcuFgcztCGH
         SEtJnZ2GQG81DqY/6OLzSrKKwj65+5YpxnsF8sNmA1d27YsMmzd6ar5S/Y3FfWatfbHh
         HkDg==
X-Forwarded-Encrypted: i=1; AJvYcCWkLCDhjz/dL1gpw1OdnE275LEnPtwcHEwOWcn70o6AaEMlSqg0V6Dfs/+XGlMX+Yq5mdRB55bI3Q+edcr43tIxNlwNkRLwOFk61SCS
X-Gm-Message-State: AOJu0Yz0gJDS9tq0unH5HmkBFy9TGV1bi+30thbnIkaZdIcPGuQXcVtm
	CQ6xPudlfq8ccg8cCZMA+wxRTanLsSkDzGhviyrMRrtCCtmicosX
X-Google-Smtp-Source: AGHT+IF/j0sWb/aMptVEJgkOiQNVrgnm5tFsy/qtZ6IYvYL6aXnAg5DbExaSAl8EFtjcp0n2/Cok4Q==
X-Received: by 2002:a17:906:4159:b0:a51:cbbf:5214 with SMTP id l25-20020a170906415900b00a51cbbf5214mr1522609ejk.33.1712750723783;
        Wed, 10 Apr 2024 05:05:23 -0700 (PDT)
Received: from [192.168.42.195] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id gt17-20020a1709072d9100b00a51b3d4bb39sm5844229ejc.59.2024.04.10.05.05.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Apr 2024 05:05:23 -0700 (PDT)
Message-ID: <8666ff9d-1cb6-4e92-a1b3-4f3b1fb0ac79@gmail.com>
Date: Wed, 10 Apr 2024 13:05:22 +0100
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
 <09f1a8e9-d9ad-4b40-885b-21e1c2ba147b@gmail.com>
 <CAK1VsR3QDh3WiR+r=30f0YQkiYN3hw071Hi9=dkd_xLQ2itdvw@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAK1VsR3QDh3WiR+r=30f0YQkiYN3hw071Hi9=dkd_xLQ2itdvw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/9/24 02:33, Oliver Crumrine wrote:
> Pavel Begunkov wrote:
>> On 4/7/24 20:14, Oliver Crumrine wrote:
>>> Oliver Crumrine wrote:
>>>> Pavel Begunkov wrote:
>>>>> On 4/5/24 21:04, Oliver Crumrine wrote:
>>>>>> Pavel Begunkov wrote:
>>>>>>> On 4/4/24 23:17, Oliver Crumrine wrote:
>>>>>>>> In his patch to enable zerocopy networking for io_uring, Pavel Begunkov
>>>>>>>> specifically disabled REQ_F_CQE_SKIP, as (at least from my
>>>>>>>> understanding) the userspace program wouldn't receive the
>>>>>>>> IORING_CQE_F_MORE flag in the result value.
>>>>>>>
>>>>>>> No. IORING_CQE_F_MORE means there will be another CQE from this
>>>>>>> request, so a single CQE without IORING_CQE_F_MORE is trivially
>>>>>>> fine.
>>>>>>>
>>>>>>> The problem is the semantics, because by suppressing the first
>>>>>>> CQE you're loosing the result value. You might rely on WAITALL
>>>>>> That's already happening with io_send.
>>>>>
>>>>> Right, and it's still annoying and hard to use
>>>> Another solution might be something where there is a counter that stores
>>>> how many CQEs with REQ_F_CQE_SKIP have been processed. Before exiting,
>>>> userspace could call a function like: io_wait_completions(int completions)
>>>> which would wait until everything is done, and then userspace could peek
>>>> the completion ring.
>>>>>
>>>>>>> as other sends and "fail" (in terms of io_uring) the request
>>>>>>> in case of a partial send posting 2 CQEs, but that's not a great
>>>>>>> way and it's getting userspace complicated pretty easily.
>>>>>>>
>>>>>>> In short, it was left out for later because there is a
>>>>>>> better way to implement it, but it should be done carefully
>>>>>> Maybe we could put the return values in the notifs? That would be a
>>>>>> discrepancy between io_send and io_send_zc, though.
>>>>>
>>>>> Yes. And yes, having a custom flavour is not good. It'd only
>>>>> be well usable if apart from returning the actual result
>>>>> it also guarantees there will be one and only one CQE, then
>>>>> the userspace doesn't have to do the dancing with counting
>>>>> and checking F_MORE. In fact, I outlined before how a generic
>>>>> solution may looks like:
>>>>>
>>>>> https://github.com/axboe/liburing/issues/824
>>>>>
>>>>> The only interesting part, IMHO, is to be able to merge the
>>>>> main completion with its notification. Below is an old stash
>>>>> rebased onto for-6.10. The only thing missing is relinking,
>>>>> but maybe we don't even care about it. I need to cover it
>>>>> well with tests.
>>>> The patch looks pretty good. The only potential issue is that you store
>>>> the res of the normal CQE into the notif CQE. This overwrites the
>>>> IORING_CQE_F_NOTIF with IORING_CQE_F_MORE. This means that the notif would
>>>> indicate to userspace that there will be another CQE, of which there
>>>> won't.
>>> I was wrong here; Mixed up flags and result value.
>>
>> Right, it's fine. And it's synchronised by the ubuf refcounting,
>> though it might get more complicated if I'd try out some counting
>> optimisations.
>>
>> FWIW, it shouldn't give any performance wins. The heavy stuff is
>> notifications waking the task, which is still there. I can even
>> imagine that having separate CQEs might be more flexible and would
>> allow more efficient CQ batching.
> I've actaully been working on this issue for a little while now. My current
> idea is that an id is put into the optval section of the SQE, and then it
> can be used to tag that req with a certain group. When a req has a flag
> set on it, it can request for all of group's notifs to be "flushed" in one
> notif that encompasses that entire group. If the id is zero, it won't be
> associated with a group and will generate a notif. LMK if you see anything
> in here that could overcomplicate userspace. I think it's pretty simple,
> but you've had a crack at this before so I'd like to hear your opinion.

You can take a look at early versions of the IORING_OP_SEND_ZC, e.g.
patchset v1, probably even later ones. It was basically doing what
you've described with minor uapi changes, like you had to declare groups
(slots) in advance, i.e. register them.

More flexible and so performant in some circumstances, but the overall
feedback from people trying it is that it's complicated. The user should
allocate group ids, track bound requests / buffers, do other management.
The next question is how the user should decide what bind to what. There
is some nastiness in using the same group for multiple sockets, and then
what's the cut line to flush the previous notif? I probably forgot a
couple more complaints.

TL;DR;

The performance is a bit of a longer story, problems are mostly coming
from the async nature of io_uring, and it'd be nice to solve at least a
part of it generically, not only for sendzc. The expensive stuff is
waking up the task, it's not unique to notifications, recv will trigger
it with polling as well as other opcodes. Then the key is completion
batching.

What's interesting, take for example some tx only toy benchmark with
DEFER_TASKRUN (recommended to use in any case). If you always wait for
sends without notifications and add eventual *_get_events(), that would
completely avoid the wake up overhead if there are enough buffers,
and if it's not it can 1:1 replace tx polling.

Try groups, see if numbers are good. And a heads up, I'm looking at
improving it a little bit for TCP because of a report, not changing
uapi but might change performance math.

-- 
Pavel Begunkov

