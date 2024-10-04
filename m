Return-Path: <io-uring+bounces-3419-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BD6F99070F
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 17:04:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C9271C20915
	for <lists+io-uring@lfdr.de>; Fri,  4 Oct 2024 15:04:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03E801AA7B5;
	Fri,  4 Oct 2024 15:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jBTvuKl/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A791487F6
	for <io-uring@vger.kernel.org>; Fri,  4 Oct 2024 15:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728054213; cv=none; b=Be8ELAsL9npPJ8zEOSpIidFDi0yEHRhDzdW1OfMMsjAGwHcEitjimshbC/LszViL3n8oiKqn3GRsMACcJGmgjLnlMfZOMh4dzAAmhDq7aGaaj7c/JC8TGc91yBDIWTCMFmAhJNJw+YzNLEmOZscB5R7OXZnnquXJTvkmIFrKiGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728054213; c=relaxed/simple;
	bh=JMqPhI/K0Ry9q7RsMeXFr639XaGct8w5+z86+Bpkx0w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ppa+jyUI20N8BRSh0JyTnq/D1O8G5AvGXH+LyKBcSHFzE5hprD1S4bStun/ANUJBGS0hxKOYn5K0tlNyYOJrsOtIz0xG4oBcsUt85rUf/MXfEfmS8l/tqOO91DRimikf/pwstM3xvJY0jP8LUZfXLCBO1/gcele1zrNEMH8W4uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=jBTvuKl/; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-82cd869453eso84496039f.0
        for <io-uring@vger.kernel.org>; Fri, 04 Oct 2024 08:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728054208; x=1728659008; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R8HGMO3emcFD7BPnlWbfGRsKbUCUD/JRmxFsGv7B5Y8=;
        b=jBTvuKl/JfrfCv+zdXjhSwXihKsbyKVcPZajLgo7ynlGp5FPvKmUwK6M7FW7hDnf9t
         ekXl266oTBcX2++xnfiBC5i6N1kIqyTEbk74AsX3wo/synL5w0ncgibRQqonMzb1WWfu
         u+XujNUmDLHzK2otIbThj4oiQEmLXkZmWaE30BmBaqWXyWHP5gKczhUK46WYsJ79u4qR
         oDKRZSf8SqAF356CfK/ysWuggKd07fF4yWN9odnvvz6Mr/Rvej9BjGTOBeFyklDmEZPo
         BvrlIr4YDQGWZFjU8r97CoyscBdVut/BjyojIQy273ZIzbMD70LHrIIUoeIH07H1KSvp
         q7gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728054208; x=1728659008;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R8HGMO3emcFD7BPnlWbfGRsKbUCUD/JRmxFsGv7B5Y8=;
        b=bcs8T1LvJ9ysYVbr5QLnJMENzLKJeuWYGtf3NDmYu9PNVLOojFBEbrSXicQjJeH65u
         KoalSvR8soE3vLigYXR2oVpzE+ksE1EKA3suYp1+WLIz86Vc4fohHOJZF37XLnvx79Kc
         URgLGrKpa6GiJ6lV2e+dgyhePG99qbvJLnUIYQ9Kn8ZDOikvhOzekQulLqlAVFWtrqfX
         RvwKWPhKNNWe4YF4d+8beDupSs/SrronJanU/MsKY8m5d88wXcffOgOkOmrw7zaJDYzB
         RWu/fRO2KpSsX1+DlBjZLT2Bt8K2qIqAV3Tk1QoWuFyUfVXP861VsrqTcecQ6JkarPPi
         vNlw==
X-Gm-Message-State: AOJu0Yw9Vz/LFMCxrXIHwDwhwGSlQs+aAC0Ro0y2wj3fZdvLKcoQYyW6
	GXVauKBX/2r14vQWDt8yySGlQLFHPsv9jUV05ENKn0A5wSq9aEBWJ3inG6doCwIl80mbePTdx/V
	1UqE=
X-Google-Smtp-Source: AGHT+IFr3hhbx9rknGHSQVVxW/XZoaNnOSrcG/ZXNP4TibE6zeHe+vF6vsm+hgfCjHgTYRLki2VLSQ==
X-Received: by 2002:a05:6e02:1d0a:b0:3a0:90c7:f1b with SMTP id e9e14a558f8ab-3a375a9dea0mr27631865ab.12.1728054208181;
        Fri, 04 Oct 2024 08:03:28 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a37a7fd5ecsm85365ab.26.2024.10.04.08.03.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Oct 2024 08:03:27 -0700 (PDT)
Message-ID: <1b131703-7224-4a2a-acf6-b367a404305f@kernel.dk>
Date: Fri, 4 Oct 2024 09:03:26 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] io_uring/poll: get rid of unlocked cancel hash
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: io-uring@vger.kernel.org
References: <e6c1c02e-ffe7-4bf0-8ea4-57e6b88d47ce@stanley.mountain>
 <2f2cc702-609b-4e69-be1a-a373e74692f4@kernel.dk>
 <7d658ea9-44be-493c-9d68-957f293883c8@kernel.dk>
 <a1763e60-1561-48a2-babf-07c3c2161ff0@stanley.mountain>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a1763e60-1561-48a2-babf-07c3c2161ff0@stanley.mountain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/4/24 8:54 AM, Dan Carpenter wrote:
> On Fri, Oct 04, 2024 at 07:54:32AM -0600, Jens Axboe wrote:
>> On 10/4/24 7:50 AM, Jens Axboe wrote:
>>> On 10/4/24 3:00 AM, Dan Carpenter wrote:
>>>> Hello Jens Axboe,
>>>>
>>>> Commit 313314db5bcb ("io_uring/poll: get rid of unlocked cancel
>>>> hash") from Sep 30, 2024 (linux-next), leads to the following Smatch
>>>> static checker warning:
>>>>
>>>> 	io_uring/poll.c:932 io_poll_remove()
>>>> 	warn: duplicate check 'ret2' (previous on line 930)
>>>>
>>>> io_uring/poll.c
>>>>     919 int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
>>>>     920 {
>>>>     921         struct io_poll_update *poll_update = io_kiocb_to_cmd(req, struct io_poll_update);
>>>>     922         struct io_ring_ctx *ctx = req->ctx;
>>>>     923         struct io_cancel_data cd = { .ctx = ctx, .data = poll_update->old_user_data, };
>>>>     924         struct io_kiocb *preq;
>>>>     925         int ret2, ret = 0;
>>>>     926 
>>>>     927         io_ring_submit_lock(ctx, issue_flags);
>>>>     928         preq = io_poll_find(ctx, true, &cd);
>>>>     929         ret2 = io_poll_disarm(preq);
>>>>     930         if (!ret2)
>>>>     931                 goto found;
>>>> --> 932         if (ret2) {
>>>>     933                 ret = ret2;
>>>>     934                 goto out;
>>>>     935         }
>>>>
>>>> A lot of the function is dead code now.  ;)
>>>
>>> Thanks, will revisit and fold in a fix!
>>
>> Should just need this incremental. There's no dead code as far as I can
>> see, just a needless found label and jump.
>>
>> diff --git a/io_uring/poll.c b/io_uring/poll.c
>> index 69382da48c00..217d667e0622 100644
>> --- a/io_uring/poll.c
>> +++ b/io_uring/poll.c
>> @@ -940,13 +940,10 @@ int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
>>  	ret2 = io_poll_disarm(preq);
>>  	if (bucket)
>>  		spin_unlock(&bucket->lock);
>> -	if (!ret2)
>> -		goto found;
> 
> Oh.  I thought this was a goto out.  That explains how the code was passing
> tests.  That was an easy fix.

Yeah, that check was just dead code, but the rest was fine. Thanks for
letting me know!

-- 
Jens Axboe

