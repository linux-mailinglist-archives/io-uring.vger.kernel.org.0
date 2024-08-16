Return-Path: <io-uring+bounces-2811-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B67B9553B3
	for <lists+io-uring@lfdr.de>; Sat, 17 Aug 2024 01:13:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0D2C2B20F23
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 23:13:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 480D9145A07;
	Fri, 16 Aug 2024 23:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="IsGO78eS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF40312C46D
	for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 23:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723850004; cv=none; b=a4ICxSQfuffqXe2GPzNfhyrYXn6d6EQqQbMdpQfwFbIw+Y5I9yss0f448i4jkDO9l9BqbH8GdbiFj/eug3WjPlIEryIHJPVn2Zbd+AorqiDAYiqZuAJNtkVRMmHT15gYyME8zqzLhIEUA1r3ynjPmc1CUT10tg505h09bveiKW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723850004; c=relaxed/simple;
	bh=T+7MwuC6l+xFcShomnw7yppjw4LoxpYVMoBpsxvpkrk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OHOqX3MvAHc/zgNo1WoB6DaC5lgol0gOixxmWmOG1k+P+C3sRE89EwE15wDfY5BGVZY/OqrFqZBkRmhVLAbPWa19blmhuK7jZrPIi5Z7cRBqtO9u/AYclc51p8W3aLRJkTgyYfdPurC4cVQI7hdx8EcRRlWbmmazYuHeRYsYncI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=IsGO78eS; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2d3b4238c58so1947718a91.2
        for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 16:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1723850002; x=1724454802; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ENrUSCj/BaPOsyvL24ovto2oj1RkjhRjhpw4s7fky/U=;
        b=IsGO78eSSjT1yjMwMJVIypmzk5PC1EbTaTKTZgNwqO7Pb7LxacEWfmhv2tCdvG0Kkj
         uoMe7SuXw7DOEcqKYcwxMkHihIv9WNmwgiv+tGEw+KPLcvmkaRlJJDv192aBkH3mYKyx
         QU0ZJRA4vU+Sh3d3v3CKGWCGM6zfv3ZQxaglPoTr0Mwyy4aolEBMUiZtS49ZlJbAIlLr
         wYk9zc38e1x0QavdhcGWKFLrQAqj8Cm5/xUOyGIEQaYMWcu+SdoAv1Dypz9R3cqJJIyv
         Mf8vDSu1dUDAqIjcTZoHPXomouE398t9d6ZYXQrFK6wjIZILLoI64MP7GPpNuAjUF6Yo
         SlDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723850002; x=1724454802;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ENrUSCj/BaPOsyvL24ovto2oj1RkjhRjhpw4s7fky/U=;
        b=ECCEh4rPODxQbBIDaLbL4E0CV//RuI7RavdP/g1eIuGv1AHXQjBkAPxgqh33tsiYGb
         CR76J5Tyb5khAzt/n0lbQmc6XkOgZjyVwuZNrehZs9SKZpFq+rxDP5C4WpU1NgYRw2UG
         yVunJWSktdnAlcDETXDa6+xquOu9rxsOG1O/Txm/neYr7NoSTrkGIj4PvYJQukUIRlvO
         m7A+bl+kswGWoa3RJzpFDEvVAXKzBsI5jxV/I5DbDd5o0kKGl1Gg5E7QxWzZEe8gXeLK
         n+Kvww7kYMGXUOapJLtwMtw63vK7i9JnNLxRzf6EB9+fLtjYvHJ1iNU6guyFOxlgbAP3
         Dq9g==
X-Forwarded-Encrypted: i=1; AJvYcCUbTeWhf3WiqA+eyqbi+IPn3B82oPBDV5rJwh3MuyqjdkKWXLUYj2+64l4vvuvJh8SSgTMzgUI6PeoCs/0C15ao8fPV7ZrBdrk=
X-Gm-Message-State: AOJu0YxBcGsN+Cj96zcvbBSTF+N4VvzQKRQg+rCk3JGlmqQf4jYGqKVW
	jmE8tiFxnRHE0OiA0GAo5iLG8peZO4yBsIU+w/ZbcFrW7+ax6HAV6BFynk7OThEV/x2ej85VrVj
	M9Do=
X-Google-Smtp-Source: AGHT+IFuGrKyclnbz57OvtjYO8sigLKOsekI/7UZd9il3hcHYQo1JqbOFepBU+WWP2hVodDU5B3yRA==
X-Received: by 2002:a17:90b:2bd1:b0:2cc:ff56:5be3 with SMTP id 98e67ed59e1d1-2d3dfc77a3cmr4883720a91.19.1723850001875;
        Fri, 16 Aug 2024 16:13:21 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1256:1:80c:c984:f4f1:951f? ([2620:10d:c090:500::5:e041])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d3ac7f294esm6226379a91.34.2024.08.16.16.13.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Aug 2024 16:13:21 -0700 (PDT)
Message-ID: <6f46b22b-cc1a-420a-a41e-40fa5af2f0ac@davidwei.uk>
Date: Fri, 16 Aug 2024 16:13:19 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v1] Add io_uring_iowait_toggle()
Content-Language: en-GB
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
References: <20240816224015.1154816-1-dw@davidwei.uk>
 <0c15e397-766f-4da7-a851-bb776ca25ab8@kernel.dk>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <0c15e397-766f-4da7-a851-bb776ca25ab8@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024-08-16 15:49, Jens Axboe wrote:
> On 8/16/24 4:40 PM, David Wei wrote:
>> diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
>> index 5e4121b..c06050a 100644
>> --- a/man/io_uring_enter.2
>> +++ b/man/io_uring_enter.2
>> @@ -104,6 +104,11 @@ If the ring file descriptor has been registered through use of
>>  then setting this flag will tell the kernel that the
>>  .I ring_fd
>>  passed in is the registered ring offset rather than a normal file descriptor.
>> +.TP
>> +.B IORING_ENTER_NO_IOWAIT
>> +If this flag is set, then in_iowait will not be set for the current task if
>> +.BR io_uring_enter (2)
>> +results in waiting.
> 
> I'd probably would say something ala:
> 
> If this flag is set, then waiting on events will not be accounted as
> iowait for the task if
> .BR io_uring_enter (2)
> results in waiting.
> 
> or something like that. io_iowait is an in-kernel thing, iowait is what
> application writers will know about.
> 
>> +.B #include <liburing.h>
>> +.PP
>> +.BI "int io_uring_iowait_toggle(struct io_uring *" ring ",
>> +.BI "                            bool " enabled ");"
>> +.BI "
>> +.fi
>> +.SH DESCRIPTION
>> +.PP
>> +The
>> +.BR io_uring_iowait_toggle (3)
>> +function toggles for a given
>> +.I ring
>> +whether in_iowait is set for the current task while waiting for completions.
>> +When in_iowait is set, time spent waiting is accounted as iowait time;
>> +otherwise, it is accounted as idle time. The default behavior is to always set
>> +in_iowait to true.
> 
> And ditto here
> 
>> +Setting in_iowait achieves two things:
>> +
>> +1. Account time spent waiting as iowait time
>> +
>> +2. Enable cpufreq optimisations, setting SCHED_CPUFREQ_IOWAIT on the rq
> 
> This should probably be something ala:
> 
> Setting in_iowait achieves two things:
> .TP
> .B Account time spent waiting as iowait time
> .TP
> .B Enable cpufreq optimisations, setting SCHED_CPUFREQ_IOWAIT on the rq
> .PP
> 
> to make that format like a man page.
> 
>> +Some user tooling attributes iowait time as CPU utilization time, so high
>> +iowait time can look like apparent high CPU utilization, even though the task
>> +is not scheduled and the CPU is free to run other tasks.  This function
>> +provides a way to disable this behavior where it makes sense to do so.
> 
> And here. Since this is the main man page, maybe also add something
> about how iowait is a relic from the old days of only having one CPU,
> and it indicates that the task is block uninterruptibly waiting for IO
> and hence cannot do other things. These days it's mostly a bogus
> accounting value, but it does help with the cpufreq boost for certain
> high frequency waits. Rephrase as needed :-)
> 
>> diff --git a/src/queue.c b/src/queue.c
>> index c436061..bd2e6af 100644
>> --- a/src/queue.c
>> +++ b/src/queue.c
>> @@ -110,6 +110,8 @@ static int _io_uring_get_cqe(struct io_uring *ring,
>>  
>>  		if (ring->int_flags & INT_FLAG_REG_RING)
>>  			flags |= IORING_ENTER_REGISTERED_RING;
>> +		if (ring->int_flags & INT_FLAG_NO_IOWAIT)
>> +			flags |= IORING_ENTER_NO_IOWAIT;
>>  		ret = __sys_io_uring_enter2(ring->enter_ring_fd, data->submit,
>>  					    data->wait_nr, flags, data->arg,
>>  					    data->sz);
> 
> Not strictly related, and we can always do that after, but now we have
> two branches here. Since the INT flags are purely internal, we can
> renumber them so that INT_FLAG_REG_RING matches
> IORING_ENTER_REGISTERED_RING and INT_FLAG_NO_IOWAIT matches
> IORING_ENTER_NO_IOWAIT. With that, you could kill the above two branches
> and simply do:
> 
> 	flags |= (ring->int_flags & INT_TO_ENTER_MASK);
> 
> which I think would be a nice thing to do.

SG, I'll do this in a follow up.

> 
> Rest looks good, no further comments.
> 

