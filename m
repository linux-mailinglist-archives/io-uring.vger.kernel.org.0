Return-Path: <io-uring+bounces-433-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D100832E90
	for <lists+io-uring@lfdr.de>; Fri, 19 Jan 2024 19:00:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C4DB41F24DCC
	for <lists+io-uring@lfdr.de>; Fri, 19 Jan 2024 18:00:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCD8155E7F;
	Fri, 19 Jan 2024 18:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="12OgKZ5h"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC8155E68
	for <io-uring@vger.kernel.org>; Fri, 19 Jan 2024 18:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705687250; cv=none; b=pME4q2KBD6aIFZLpVpITABIzdzSV+w6MFlEwiybl7mxQBBBEIPmqB6HiDsFXkvLjTI69DJVNs0EBJUaNAadeufbBebjjFLGhWYJD9I1oNOyGyiQ3C8KNLpP6YiNnKduQC6gYQlHMdQFE00N2QcBIyNSqZWsobjbvJumRzOd6D9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705687250; c=relaxed/simple;
	bh=m2hGWUK85EqTZx4B2cZSP9GdkXwmX1B8KkCFPDXfym0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HSEDkRjVXaHluXx95D30XdGwQBBp/9XY6kiuC7kCQlxWsexfjyZeeiBLwRBa0DMxkAwKD/crQtyUYnM28FMfc4xBv+dzF0ePZG6/L3zTiZoxz8iV710UrKVRM7KDzsysHssd/hO+MUxZ90cUqSgsTlSNdZFcll0QF+y9W04+GfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=12OgKZ5h; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-7bed82030faso14903639f.1
        for <io-uring@vger.kernel.org>; Fri, 19 Jan 2024 10:00:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1705687248; x=1706292048; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Gja6vm8AI1lwtvHUS5OLNBI4vAMtOEijM3nQ95ddsvw=;
        b=12OgKZ5h5pdEiI+W97lDearDHRmczducDooHxBOjZXLpzopG7oUC+kTXFh6dHpsSbv
         +OG7dialuxdcnUWgGyBg8NH2da1MVOSTlIaYM3zZqErB103XxsooRi8DiYth6F3AlvwV
         P6gH3AkeYLcjAl4K+UE8YAjvuW0QI9LwYeuSHS+ksAE0YlNgQf05HdSaQaxxzHJjeZSR
         Kj/SXTrrWUdP7ErP25fqU09wHZH/GS5HNXJU1So4yRYfFrT1QKGhRZ1Zf5ZwSNY2UtFe
         SIkdlYZf4i1ldzRXFodjHQk16TybSN+CPWlhxtDZqY4HGPuwcUOnWiSDpFTTZznspP2Z
         KLMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705687248; x=1706292048;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gja6vm8AI1lwtvHUS5OLNBI4vAMtOEijM3nQ95ddsvw=;
        b=EjqIvc06SfDNfhJASqlTsQWopwddVcDCTfESeEpQGnuyZSvVc3/Gl1A9SZPeAlDU6P
         SV+t/GLa2dx1ar7zeIutU2XZWjUjTU0HUPISJQ54efasRQS4VI4gxesmU9QiwDMfLH15
         xjjwDDM7QeayWIqUJQUnQuM7PYKmOtJU6tB4as4Hz18iPF8Pvy3Gu1DRKxuIuGpxLtTQ
         npEyL8ftU25gr53tdD0sGyvSYwIX6iSKAhyN1lEZv5z1exxp/eqsJyQBGWz9dOp777FY
         E1KnLs9aWL/opIvKNSa+5BhvVzDMqWOJLGPxDpXKrZjiJML1ctdEBr4t8QrMB3nOXv7t
         xbvw==
X-Gm-Message-State: AOJu0YwiZH4AJZIrc0I67ywqXDdfk71n7u/xWxKxga+MO65Lc+QrNMcR
	HPtjdVsPrrlrmegUwgJJSU92u26qQVk29/bNXeNgOSYAGlTsSzWY5HAn+x1fB00=
X-Google-Smtp-Source: AGHT+IHobiRenokZkDLDbBdoaWKvKBP1nUEcNp8Xs74UrNwujg29ABGmLrOl5LpWjL6jCycxL6uN+g==
X-Received: by 2002:a5d:8e0b:0:b0:7bf:4758:2a12 with SMTP id e11-20020a5d8e0b000000b007bf47582a12mr186301iod.0.1705687247676;
        Fri, 19 Jan 2024 10:00:47 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id h6-20020a056602130600b007bf84450287sm190440iov.21.2024.01.19.10.00.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jan 2024 10:00:47 -0800 (PST)
Message-ID: <71740ac0-5c4a-4d09-9ce1-9ef6182db1b1@kernel.dk>
Date: Fri, 19 Jan 2024 11:00:46 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: IORING_OP_FIXED_FD_INSTALL and audit/LSM interactions
Content-Language: en-US
To: Paul Moore <paul@paul-moore.com>
Cc: Christian Brauner <brauner@kernel.org>, io-uring@vger.kernel.org,
 linux-security-module@vger.kernel.org, audit@vger.kernel.org,
 selinux@vger.kernel.org
References: <CAHC9VhRBkW4bH0K_-PeQ5HA=5yMHSimFboiQgG9iDcwYVZcSFQ@mail.gmail.com>
 <80b76dac-6406-48c5-aa31-87a2595a023f@kernel.dk>
 <CAHC9VhQuM1+oYm-Y9ehfb6d7Yz2++pughEkUFNfFpsvinTGTpg@mail.gmail.com>
 <610f91a7-9b5a-4a07-9912-e336896fff0c@kernel.dk>
 <CAHC9VhSJn6Kd=M8N-pLgJMvo9bhtdB6bX_xK=8aPYj5qQ8aTvQ@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHC9VhSJn6Kd=M8N-pLgJMvo9bhtdB6bX_xK=8aPYj5qQ8aTvQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/19/24 10:54 AM, Paul Moore wrote:
> On Fri, Jan 19, 2024 at 12:41?PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 1/19/24 10:20 AM, Paul Moore wrote:
>>> On Fri, Jan 19, 2024 at 12:02?PM Jens Axboe <axboe@kernel.dk> wrote:
>>>> On 1/19/24 9:33 AM, Paul Moore wrote:
>>>>> Hello all,
>>>>>
>>>>> I just noticed the recent addition of IORING_OP_FIXED_FD_INSTALL and I
>>>>> see that it is currently written to skip the io_uring auditing.
>>>>> Assuming I'm understanding the patch correctly, and I'll admit that
>>>>> I've only looked at it for a short time today, my gut feeling is that
>>>>> we want to audit the FIXED_FD_INSTALL opcode as it could make a
>>>>> previously io_uring-only fd generally accessible to userspace.
>>>>
>>>> We can certainly remove the audit skip, it was mostly done as we're
>>>> calling into the security parts anyway later on. But it's not like doing
>>>> the extra audit here would cause any concerns on the io_uring front.
>>>
>>> Great.  Do you want to put a patch together for that, or should I?
>>
>> Either way - I'd say if you have time to do it, please do!
> 
> Okay, will do.  Just a heads up that due to personal commitments this
> weekend a proper, tested fix may not come until early next week.  With
> this only appearing in Linus' tree during this merge window we've got
> plenty of time to fix this before v6.8 is tagged.

No worries on that, there's no rush as we are early in the cycle.

>> FWIW, I'd add that in
>> io_uring/openclose.c:io_install_fixed_fd_prep() - just check for
>> REQ_F_CREDS in there and return -EPERM (I think that would be
>> appropriate?) and that should disallow any IORING_OP_FIXED_FD_INSTALL if
>> creds have been reassigned.
> 
> Yeah, easy enough.  I was originally thinking of masking out
> REQ_F_CREDS there, but if you are okay with simply rejecting the
> operation in this case it makes everything much easier (and more
> predictable from a userspace perspective).

It'd be too late to mask it out, as it may already have been assigned.
And on top of that, it would introduce a weird scenario where the
application thinks that creds have been assigned and it completes
successfully, but in reality it didn't use the specified creds. For
those cases we absolutely must fail the request, as it didn't do exactly
what it was asked to.

>>>>> I'm also trying to determine how worried we should be about
>>>>> io_install_fixed_fd() potentially happening with the current task's
>>>>> credentials overridden by the io_uring's personality.  Given that this
>>>>> io_uring operation inserts a fd into the current process, I believe
>>>>> that we should be checking to see if the current task's credentials,
>>>>> and not the io_uring's credentials/personality, are allowed to receive
>>>>> the fd in receive_fd()/security_file_receive().  I don't see an
>>>>> obvious way to filter/block credential overrides on a per-opcode
>>>>> basis, but if we don't want to add a mask for io_kiocb::flags in
>>>>> io_issue_defs (or something similar), perhaps we can forcibly mask out
>>>>> REQ_F_CREDS in io_install_fixed_fd_prep()?  I'm very interested to
>>>>> hear what others think about this.
>>>>>
>>>>> Of course if I'm reading the commit or misunderstanding the
>>>>> IORING_OP_FIXED_FD_INSTALL operation, corrections are welcome :)
>>>>
>>>> I think if there are concerns for that, the easiest solution would be to
>>>> just fail IORING_OP_FIXED_INSTALL if REQ_F_CREDS is set. I don't really
>>>> see a good way to have the security side know about the old creds, as
>>>> the task itself is running with the assigned creds.
>>>
>>> The more I've been thinking about it, yes, I believe there are
>>> concerns around FIXED_FD_INSTALL and io_uring personalities for LSMs.
>>> Assuming an io_uring with stored credentials for task A, yet
>>> accessible via task B, task B could submit an IORING_OP_OPENAT command
>>> to open a file using task A's creds and then FIXED_FD_INSTALL that fd
>>> into its own (task B's) file descriptor table without a problem as the
>>> installer's creds (the io_uring creds, or task A) match the file's
>>> creds (also task A since the io_uring opened the file).  Following
>>> code paths in task B that end up going through
>>> security_file_permission() and similar hooks may very well end up
>>> catching the mismatch between the file's creds and task B (depending
>>> on the LSM), but arguably it is something that should have been caught
>>> at receive_fd() time.
>>
>> If there are any concerns, then I say let's just explicitly disable it
>> rather than rely on maybe something in the security checking catching
>> it. Especially because I don't think there's a valid use case for doing
>> this, other than perhaps trying to bypass checks you'd normally hit.
>> Better to err on the side of caution then.
> 
> Agreed.  I'll go ahead and make the change.  Thanks for the quick
> responses and understanding of a very security-biased perspective :)

It's always better to catch weirdness or ambiguities like this early, so
much appreciated!

-- 
Jens Axboe


