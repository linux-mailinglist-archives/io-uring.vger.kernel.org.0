Return-Path: <io-uring+bounces-1573-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 020778A6B4F
	for <lists+io-uring@lfdr.de>; Tue, 16 Apr 2024 14:40:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B320D281CBC
	for <lists+io-uring@lfdr.de>; Tue, 16 Apr 2024 12:40:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCF26129A7C;
	Tue, 16 Apr 2024 12:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RDzv6W0m"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD381292D7;
	Tue, 16 Apr 2024 12:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713271241; cv=none; b=uWyxAFkSlmYL+2sgCLH/iBGQL7U7f0e1pSKl5zBAYYDX4OboZ5EE5TGmoP9t8k+E3YX+qYQI8Y3EgONvRXjAR6HacfvTH1xJa3clKS+mmmY2MV7IB/wlZSqmH32yu2cIa0Z255+SYWiZ1KhIZaR2PtHcv8U4jIQpgxy3GsDn0xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713271241; c=relaxed/simple;
	bh=RcNagG6FBOnSKf2vVTezivYHtUNxHZaVMMPw6J9zGRE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EUxcXy9qb2l0AHjVsMS4KgCprhHmyA9YeJvkgC9GajhoE/vExoKl1aN9EpkPJraXPmrnG7t46HxrTPwDrxkqvPsq3fgzW66OBwsY80cxA6WXh6Kpe8oqGiIQ8RfjN8GlH0Bs0xaoj2Yq/v8MjUW6LwGA0cA5dkniC0PUGWKNv3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RDzv6W0m; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-57030fa7381so1962256a12.2;
        Tue, 16 Apr 2024 05:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713271238; x=1713876038; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hTGQToqzh18LbWQwv0jPtXlFkdtoT6P13qBFdlCy2hg=;
        b=RDzv6W0mb8NTAC+DWQ35eHUQaZm2mn3faoxyteys9s9rGS//XppKMmb8/iEVxxqFe7
         uC8n0tV49SwHvs0XMXjfG2FCB96fEELTiuHCu3nAnMKo2+xVjDn83VA9GzWtB0BH+n6g
         MTk4+LFP/UkzPoJZEbxh7qDnSKzVxCe9NMN19nGiBc2B8ic0QcW5cyZkpFnzL2A1KOdq
         T22fG6QtIYMaaiO1beJ/rbPlLY8ai8IJZzdSuJEo2pLOg3ARBh6REM7mhcB0HG9rYftx
         8HilHmJm7lSBeJ53/30CIGuke308OcGNMdXsToupYxOwdNBI62RLSUkNctbKJF7ZLSDg
         CvEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713271238; x=1713876038;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hTGQToqzh18LbWQwv0jPtXlFkdtoT6P13qBFdlCy2hg=;
        b=X/E8PwPRGZ6BOOEPu66oZM0drhA+9W9omYci9E6NNoTRismc67Fuk24pA3WIMj4ity
         MAmlpZR0QkUpXaS4Eer5S4Q5hcUR5U6MnyG9udUHeMLP28uqVRcYo9EcSeHYDa0Zo7A2
         as1W3GXNSnIsdD7tQoVn2VpJA9ZiDQ5ROLmmDn62gb88WROJUcsjJ52aNhRCEevwuw7N
         kWUhLQ+OyQP80UmZN/0HubOkPI5SVpOAmf1szV9ARtmzw5NFeA7sriQR5hAwZvlrYH33
         hUuyQC5ZwkJ3EVKH70AK9I6E/eN7PH06QF5sdNvbGs8ZnbnP82+tLYUZQNGA9Ya2Pk0u
         ZkQQ==
X-Forwarded-Encrypted: i=1; AJvYcCUM66XJckqqk+cIQSli2OzFvkZYaSFD0btCxlUBBdjDGui2EALd/z21jnYRulCntxtdiYI8St4sXbeeChlSv4c4zC6nQMvO7Kk=
X-Gm-Message-State: AOJu0YypG7fbXVPjcoF58dyGD5j/YqrujlBptj29xDhkCBWq66WfFZ7V
	2kMCR4rePHtvFhVCYwjpA/9i3ushPNoWHWZIF0Wcgjcx85vbqu0vIsV7Nw==
X-Google-Smtp-Source: AGHT+IGk2U5tYoxQ7B9l4t4m7Q1EbxIhv2SheuXJetjJvUWcz/sTYOjT2DnODzp7fVFzJ/DGAe0agw==
X-Received: by 2002:a50:931b:0:b0:570:4ade:c54b with SMTP id m27-20020a50931b000000b005704adec54bmr313764eda.25.1713271238342;
        Tue, 16 Apr 2024 05:40:38 -0700 (PDT)
Received: from [192.168.42.211] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id cb12-20020a0564020b6c00b0056e67aa7118sm6103230edb.52.2024.04.16.05.40.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Apr 2024 05:40:38 -0700 (PDT)
Message-ID: <2836d7dc-4afd-49d8-8405-d888f2b3fc95@gmail.com>
Date: Tue, 16 Apr 2024 13:40:45 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] WARNING: CPU: 5 PID: 679 at io_uring/io_uring.c:2835
 io_ring_exit_work+0x2b6/0x2e0
To: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
 Changhui Zhong <czhong@redhat.com>
Cc: Linux Block Devices <linux-block@vger.kernel.org>,
 io-uring <io-uring@vger.kernel.org>
References: <CAGVVp+WzC1yKiLHf8z0PnNWutse7BgY9HuwgQwwsvT4UYbUZXQ@mail.gmail.com>
 <06b1c052-cbd4-4b8c-bc58-175fe6d41d72@kernel.dk> <Zh3TjqD1763LzXUj@fedora>
 <CAGVVp+X81FhOHH0E3BwcsVBYsAAOoAPXpTX5D_BbRH4jqjeTJg@mail.gmail.com>
 <Zh5MSQVk54tN7Xx4@fedora> <28cc0bbb-fa85-48f1-9c8a-38d7ecf6c67e@kernel.dk>
 <d56d21d5-f8c2-435e-84ca-946927a32197@gmail.com>
 <34d7e331-e258-4dda-a21b-5327664d0d04@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <34d7e331-e258-4dda-a21b-5327664d0d04@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/24 13:24, Jens Axboe wrote:
> On 4/16/24 6:14 AM, Pavel Begunkov wrote:
>> On 4/16/24 12:38, Jens Axboe wrote:
>>> On 4/16/24 4:00 AM, Ming Lei wrote:
>>>> On Tue, Apr 16, 2024 at 10:26:16AM +0800, Changhui Zhong wrote:
>>>>>>>
>>>>>>> I can't reproduce this here, fwiw. Ming, something you've seen?
>>>>>>
>>>>>> I just test against the latest for-next/block(-rc4 based), and still can't
>>>>>> reproduce it. There was such RH internal report before, and maybe not
>>>>>> ublk related.
>>>>>>
>>>>>> Changhui, if the issue can be reproduced in your machine, care to share
>>>>>> your machine for me to investigate a bit?
>>>>>>
>>>>>> Thanks,
>>>>>> Ming
>>>>>>
>>>>>
>>>>> I still can reproduce this issue on my machine?
>>>>> and I shared machine to Ming?he can do more investigation for this issue?
>>>>>
>>>>> [ 1244.207092] running generic/006
>>>>> [ 1246.456896] blk_print_req_error: 77 callbacks suppressed
>>>>> [ 1246.456907] I/O error, dev ublkb1, sector 2395864 op 0x1:(WRITE)
>>>>> flags 0x8800 phys_seg 1 prio class 0
>>>>
>>>> The failure is actually triggered in recovering qcow2 target in generic/005,
>>>> since ublkb0 isn't removed successfully in generic/005.
>>>>
>>>> git-bisect shows that the 1st bad commit is cca6571381a0 ("io_uring/rw:
>>>> cleanup retry path").
>>>>
>>>> And not see any issue in uring command side, so the trouble seems
>>>> in normal io_uring rw side over XFS file, and not related with block
>>>> device.
>>>
>>> Indeed, I can reproduce it on XFS as well. I'll take a look.
>>
>> Looking at this patch, that io_rw_should_reissue() path is for when
>> we failed via the kiocb callback but came there off of the submission
>> path, so when we unwind back it finds the flag, preps and resubmits
>> the req. If it's not the case but we still return "true", it'd leaks
>> the request, which would explains why exit_work gets stuck.
> 
> Yep, this is what happens. I have a test patch that just punts any
> reissue to task_work, it'll insert to iowq from there. Before we would
> fail it, even though we didn't have to, but that check was killed and
> then it just lingers for this case and it's lost.

Sounds good, but let me note that while unwinding, block/fs/etc
could try to revert the iter, so it might not be safe to initiate
async IO from the callback as is

-- 
Pavel Begunkov

