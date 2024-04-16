Return-Path: <io-uring+bounces-1572-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C17D8A6AD8
	for <lists+io-uring@lfdr.de>; Tue, 16 Apr 2024 14:24:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F3591C21006
	for <lists+io-uring@lfdr.de>; Tue, 16 Apr 2024 12:24:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9408F12AAC5;
	Tue, 16 Apr 2024 12:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="rL+JhP/Y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CD812882C
	for <io-uring@vger.kernel.org>; Tue, 16 Apr 2024 12:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713270268; cv=none; b=twLktf69HmORlXq+ttasX4SYUxpJV6T1jXKCbyhYRS00Z9ZpfrJJUBWS1nrP8F20FrctQKNMYfz5D4LhewoqQljpxWZGIr1Uj9IA4/sq0OP4EdpA78hmX58dtTDjWghcouGYp/pjgxPbvEP31QIxXQqrzNwyrRd+maIjJ556lD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713270268; c=relaxed/simple;
	bh=JHmQWtliapR73c2isL5syFN0KpY1JYfjAntD0OnQfJ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=owgWjf06k41ycuNxrPdCRD6CR0OGNZNx+CyryhuRYf8rfGYggJRXZnoqU77g5KfPXm5OOV1jLxWPxgQahai39e2OoDREui8xbzBfzxYbTf/sz/VX9APHNk81VaV2TzXQnsXlyfqFKso2AcepeUiLVnBiD59TdYI5U2OhFeauNSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=rL+JhP/Y; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1e2a1654e6cso9865795ad.1
        for <io-uring@vger.kernel.org>; Tue, 16 Apr 2024 05:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1713270266; x=1713875066; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EyPcXToXo9DelQ/q921/3NLHfEPtUQCQAx9Aed7N8wQ=;
        b=rL+JhP/YfGLtFj+R0U+4miO210l1P0nhCwJ6Zh9Fe+R4bQOkiVa2mIox26JRmA8ZSj
         tkJVCacISnYFhVhMCnVUHZc9PiaNOuSL7PqXEkSlkyrKPcmRPhaeXcsyTeGDyBGhwcLB
         QItuJoKOHriZwRL1JVeSy3sQ64kHBS4P1hblHDWKgaPvCK7xGcLctTak/i6tKrZ+f6qi
         n9+nJS8Qqb6jicAPWiICiFCVWVwEZCmTfyyQmRevlPDqIcjfl/VWnQYE4pO/gt6oIwsq
         DE6TUiABJk1VNq07/QA44QO69M4HmfCk7ahhmFYA01sBMRVv9oKsibkloEXICWaC5Wgy
         PjJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713270266; x=1713875066;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EyPcXToXo9DelQ/q921/3NLHfEPtUQCQAx9Aed7N8wQ=;
        b=TLL+YiO2GSdS/13Ws2J178o5HnoKG2SX2NMPX/t7s0eDsEuqY6V+qY7NY2rtd3sv3E
         12Ej1y6u1fROxUDBbMuhbA9OOXrEAEK0N/0/vNuap4SxJpMjgRUAPBYjgHeYe2wYHFl7
         OLi6qzCh+qxcUw/gU9eFC4fGxlEBOk9GoOsbuQitVVfEmulIKi6YJiEc4I6IbPcbjupx
         7hiSBurWjkhH/CbJPLtKr1Jv9Mbr+gyupoaUZWOZmpPqdh8JSoREUGLtjua/1xLukT7D
         u5J9vm3uPe1hzOMnsiprLcWbFAu/ZtHneCczGABwqRAL6BccaGNrmK3FuGRBPvlD+IXb
         5tPA==
X-Forwarded-Encrypted: i=1; AJvYcCXo4IjpiinjCfsGZ9GrFnXtf1yAsFkAqpWVnjtIbc8NL6r2bSygWsK1oUbuwRvsMLbGcVs9MfO4Lm9HYo/dsvlTR4EzAlkrmrE=
X-Gm-Message-State: AOJu0YxRSk+WCTKUVD0XfajxKUAQV3EZ9WEW0psuZWk7SPEvlQybd9oS
	kb6/L5CwFO2QweQ3avSI5FxbsvTbaxyQy+BYYoi9zt1swNF0m7ctjypxb59tjz5Kw3/cMdeaiWw
	F
X-Google-Smtp-Source: AGHT+IE8/7bSBz77fVQbzSw/3CpWGR1txbJpwAWt2+KBytS5ZC7yA2gh33jGIPTjPi86zf9W9dyuGA==
X-Received: by 2002:a17:903:41cf:b0:1dd:85eb:b11 with SMTP id u15-20020a17090341cf00b001dd85eb0b11mr16047163ple.1.1713270266511;
        Tue, 16 Apr 2024 05:24:26 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id ja10-20020a170902efca00b001e2a42a2e34sm9663994plb.65.2024.04.16.05.24.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Apr 2024 05:24:25 -0700 (PDT)
Message-ID: <34d7e331-e258-4dda-a21b-5327664d0d04@kernel.dk>
Date: Tue, 16 Apr 2024 06:24:24 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] WARNING: CPU: 5 PID: 679 at io_uring/io_uring.c:2835
 io_ring_exit_work+0x2b6/0x2e0
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, Ming Lei <ming.lei@redhat.com>,
 Changhui Zhong <czhong@redhat.com>
Cc: Linux Block Devices <linux-block@vger.kernel.org>,
 io-uring <io-uring@vger.kernel.org>
References: <CAGVVp+WzC1yKiLHf8z0PnNWutse7BgY9HuwgQwwsvT4UYbUZXQ@mail.gmail.com>
 <06b1c052-cbd4-4b8c-bc58-175fe6d41d72@kernel.dk> <Zh3TjqD1763LzXUj@fedora>
 <CAGVVp+X81FhOHH0E3BwcsVBYsAAOoAPXpTX5D_BbRH4jqjeTJg@mail.gmail.com>
 <Zh5MSQVk54tN7Xx4@fedora> <28cc0bbb-fa85-48f1-9c8a-38d7ecf6c67e@kernel.dk>
 <d56d21d5-f8c2-435e-84ca-946927a32197@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <d56d21d5-f8c2-435e-84ca-946927a32197@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/16/24 6:14 AM, Pavel Begunkov wrote:
> On 4/16/24 12:38, Jens Axboe wrote:
>> On 4/16/24 4:00 AM, Ming Lei wrote:
>>> On Tue, Apr 16, 2024 at 10:26:16AM +0800, Changhui Zhong wrote:
>>>>>>
>>>>>> I can't reproduce this here, fwiw. Ming, something you've seen?
>>>>>
>>>>> I just test against the latest for-next/block(-rc4 based), and still can't
>>>>> reproduce it. There was such RH internal report before, and maybe not
>>>>> ublk related.
>>>>>
>>>>> Changhui, if the issue can be reproduced in your machine, care to share
>>>>> your machine for me to investigate a bit?
>>>>>
>>>>> Thanks,
>>>>> Ming
>>>>>
>>>>
>>>> I still can reproduce this issue on my machine?
>>>> and I shared machine to Ming?he can do more investigation for this issue?
>>>>
>>>> [ 1244.207092] running generic/006
>>>> [ 1246.456896] blk_print_req_error: 77 callbacks suppressed
>>>> [ 1246.456907] I/O error, dev ublkb1, sector 2395864 op 0x1:(WRITE)
>>>> flags 0x8800 phys_seg 1 prio class 0
>>>
>>> The failure is actually triggered in recovering qcow2 target in generic/005,
>>> since ublkb0 isn't removed successfully in generic/005.
>>>
>>> git-bisect shows that the 1st bad commit is cca6571381a0 ("io_uring/rw:
>>> cleanup retry path").
>>>
>>> And not see any issue in uring command side, so the trouble seems
>>> in normal io_uring rw side over XFS file, and not related with block
>>> device.
>>
>> Indeed, I can reproduce it on XFS as well. I'll take a look.
> 
> Looking at this patch, that io_rw_should_reissue() path is for when
> we failed via the kiocb callback but came there off of the submission
> path, so when we unwind back it finds the flag, preps and resubmits
> the req. If it's not the case but we still return "true", it'd leaks
> the request, which would explains why exit_work gets stuck.

Yep, this is what happens. I have a test patch that just punts any
reissue to task_work, it'll insert to iowq from there. Before we would
fail it, even though we didn't have to, but that check was killed and
then it just lingers for this case and it's lost.

-- 
Jens Axboe


