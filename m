Return-Path: <io-uring+bounces-2852-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93596959014
	for <lists+io-uring@lfdr.de>; Tue, 20 Aug 2024 23:59:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D3391B22951
	for <lists+io-uring@lfdr.de>; Tue, 20 Aug 2024 21:59:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 634F9189BB6;
	Tue, 20 Aug 2024 21:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="I8TShtul"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50CC14B097
	for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 21:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724191154; cv=none; b=jo3gSqDV/lwAcCBZAPcl5H8e1fT8tIx21SShf/b927pvTn9J3WnXabOEudJzkM99i3OOz5G1ddp8wWNb5UqqlRw6auLv8+nR3YE8DJR0K1Sdv7jIkhW0RtIPlVUAZmkmXS3jN+yx98SX9+uhg6pBwPIFrh1qZdpdStVsA1ySuQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724191154; c=relaxed/simple;
	bh=x/tFcwDyrYIyU7EpbAl94VXOeYXm4O6RzyyqRUYM6EI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Mv7mC0/YXzkzZ+su0l2NxUp3d318m0t+DAHhxxkVDHCLa+uxTGcruTwQd5y8LnKASWKBlbyEBk3MiOwzWpmP+ZJ9cgSVlkKWORJNqXYgGdvpDhO4QFbWxlaPcM2ru1u8w+XhCHA/QeGt6djCOmLD28NJlKzbbM/6t0+cd9vsof0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=I8TShtul; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-714186ce2f2so731659b3a.0
        for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 14:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1724191152; x=1724795952; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cSDJfCJY3EDQqLptxtg7/xLs5jo1xfj3BbLv4r/wkq0=;
        b=I8TShtul79T1b/qsN7K/6tOGOHnIPr4N7g/QQcDR6/HLSLBGkv+FvxQ43EzZ/c9vgT
         5/kfB8sg9fsICUAohZLS7qk30il99F/TBzTlSj5kCJtsrmXwcKqaiGEexEt5c9Hfjs1K
         VcDQiAEVkX0KrZ63fV5Gy9ZPY4gtmPnqFomBubJJZzT6bIn5BxodxEcFXNO0PGFUBLZv
         Gsk5C485VXc/nhCNJsue/jfVLChntYQ/NnS+cimI8sioQt8QfNVX4ekSC/wdbAvDUfwj
         yo74C9JgOiw53sgUtCEirBBXYpX4sYVfaHAI7kqa2Y2XwiyV0RYIO1y9Yfyi4ER/TOqZ
         qcnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724191152; x=1724795952;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cSDJfCJY3EDQqLptxtg7/xLs5jo1xfj3BbLv4r/wkq0=;
        b=i5g3tSCe2nCFEksdxLdfUhE3jmJP49hEMu6PZrvmGfgaLqZpo6/KmMCpwfiMlG0N0Q
         VMSlv+DaPQ5LWewxMsJF4xPlPMAk8bb58Z3dFYgvdBFeBSo3Yzybo4yHrwcVg9l5gsbR
         pgkDO85C+eC8IDbrm3FguymOg0WCK7zoB2kJnlkDcbru8Ii56Qze2AK4FndGj4TYRaWU
         0WK+Y1Qja/tu0L54YaYb12KQ1KFvBQE+6sPJpGQOgx1hEwfJlOMY9lEaUDqj5JECbqxq
         aTteSRdL0tv/FlaaEbAaoTa/qnhxjqTMPwa21LKTQR+7zdu3M/9zottZTq7XbfRM46+h
         xkUQ==
X-Forwarded-Encrypted: i=1; AJvYcCXO49J+pFf5KUBZ4Bug1j/C2X9SEEt8WoywIr5OI+fbe0+Sf0TYaWYkhKzh9/RMkcFQ8oNNdHwRAA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yynyf5vnGB2kcwVJ9a0+8zkEDJY44SLwJbDMd87ujs8RvowyV9R
	5irsdOEPliDOjdabRgjsVsFL+WqQyYdaldxQ2xU9DlYfx2Jwm1W12ceSGuENzEE=
X-Google-Smtp-Source: AGHT+IHtgK203aiATar2gXSR984ukNcgvQ5VHqGXlFJDGVRpC+W4WKFZV2juhKS+5mZvChzPGba6Vg==
X-Received: by 2002:a05:6a20:d707:b0:1c6:fb0b:51d8 with SMTP id adf61e73a8af0-1cada03ebcfmr568944637.9.1724191152058;
        Tue, 20 Aug 2024 14:59:12 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1256:1:80c:c984:f4f1:951f? ([2620:10d:c090:500::5:2f5b])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7c6b61ce869sm8483371a12.24.2024.08.20.14.59.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Aug 2024 14:59:11 -0700 (PDT)
Message-ID: <4a69da59-7708-4f53-b906-6708414d6a22@davidwei.uk>
Date: Tue, 20 Aug 2024 14:59:10 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] io_uring: add support for batch wait timeout
Content-Language: en-GB
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240819233042.230956-1-axboe@kernel.dk>
 <20240819233042.230956-5-axboe@kernel.dk>
 <c9d18b99-96a8-4c86-abe0-0535f395ccc6@davidwei.uk>
 <8e089d10-15e0-4dcb-ae64-c18cc29e8d86@kernel.dk>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <8e089d10-15e0-4dcb-ae64-c18cc29e8d86@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024-08-20 14:31, Jens Axboe wrote:
> On 8/20/24 3:10 PM, David Wei wrote:
>> On 2024-08-19 16:28, Jens Axboe wrote:
>>> Waiting for events with io_uring has two knobs that can be set:
>>>
>>> 1) The number of events to wake for
>>> 2) The timeout associated with the event
>>>
>>> Waiting will abort when either of those conditions are met, as expected.
>>>
>>> This adds support for a third event, which is associated with the number
>>> of events to wait for. Applications generally like to handle batches of
>>> completions, and right now they'd set a number of events to wait for and
>>> the timeout for that. If no events have been received but the timeout
>>> triggers, control is returned to the application and it can wait again.
>>> However, if the application doesn't have anything to do until events are
>>> reaped, then it's possible to make this waiting more efficient.
>>>
>>> For example, the application may have a latency time of 50 usecs and
>>> wanting to handle a batch of 8 requests at the time. If it uses 50 usecs
>>> as the timeout, then it'll be doing 20K context switches per second even
>>> if nothing is happening.
>>>
>>> This introduces the notion of min batch wait time. If the min batch wait
>>> time expires, then we'll return to userspace if we have any events at all.
>>> If none are available, the general wait time is applied. Any request
>>> arriving after the min batch wait time will cause waiting to stop and
>>> return control to the application.
>>
>> I think the batch request count should be applied to the min_timeout,
>> such that:
>>
>> start_time          min_timeout            timeout
>>     |--------------------|--------------------|
>>
>> Return to user between [start_time, min_timeout) if there are wait_nr
>> number of completions, checked by io_req_local_work_add(), or is it
>> io_wake_function()?
> 
> Right, if we get the batch fulfilled, we should ALWAYS return.
> 
> If we have any events and min_timeout expires, return.
> 
> If not, sleep the full timeout.
> 
>> Return to user between [min_timeout, timeout) if there are at least one
>> completion.
> 
> Yes
> 
>> Return to user at timeout always.
> 
> Yes
> 
> This should be how it works, and how I described it in the commit
> message.
> 

You're right, thanks. With DEFER_TASKRUN, the wakeup either happens in
the timer expired callback io_cqring_min_timer_wakeup(), or in
io_req_local_work_add().

In both cases control returns to after schedule() in
io_cqring_schedule_timeout() and the timer is cancelled.

Is it possible for the two to race at all?

