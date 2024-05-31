Return-Path: <io-uring+bounces-2037-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DE378D6972
	for <lists+io-uring@lfdr.de>; Fri, 31 May 2024 21:11:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 220BE284298
	for <lists+io-uring@lfdr.de>; Fri, 31 May 2024 19:11:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B227C158D9C;
	Fri, 31 May 2024 19:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MS9rPDWx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C62A15AD93
	for <io-uring@vger.kernel.org>; Fri, 31 May 2024 19:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717182655; cv=none; b=RTP0gJVJcdmeRBc3sw3kbRYIvIdZe/Y64XCYdlcSVGaIVwVr+hbkF5i5F55Co1A+/Rd2jKJDFGUFgxMnMN+e2expkmdrJPH4JvdFwYZa0o8P12MKIPuTxEa0RZ+EN3XnQcdhnILxnMEG88IE62IXvIdbyRgZmgO//+w3YzdO3BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717182655; c=relaxed/simple;
	bh=1dudp+Dca+UU1IewyMXGzTACJ0D9g1SIjy9XEflX+ig=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V67YPgtA0pyMNICep4P+RIR1p/zWjrBB0xVG9Mr7iz5DuADfh0R781UWpuKju0Eos/PK9Xkf5JdRnUq96xVALCGEQPmHEWXFM68bgFb8WflSD6kMd+qZGum3ROZrMkXGWs0sRWT5FldCbGeaeyE/5ywgI+I8ZlcWUp+ZkbG3jo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MS9rPDWx; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-64ecc2f111dso270218a12.2
        for <io-uring@vger.kernel.org>; Fri, 31 May 2024 12:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717182651; x=1717787451; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nesPb3ikOdykWdzBTsuyXBWRTSA6l9jG6DEva+E2AsA=;
        b=MS9rPDWxIqvEBJsQPHNcOvKc2kF/nf02yHACyI+CnGmz2ojoEcvpfU7vIgUDg1N168
         THnwhhouvMhnXG3o0fa6DRJcHGaEM8elDz1qPdmqNrSDwTarktTPzSixGp5eMxn4Snsl
         rSQIRlpRAnlJGnvv0YF3Jy6uTiQWseU1R6zvw+oQlRqWDVeAmqUh5T+HMMJf6yJ2MnOU
         QClTB/xAMRsSK/gzAH8LtVMypgAUfoR2XIfZrL7ZpWOz8fPHiVxCPjIUDjjZSf31CLcb
         olbvDkU2rumCK+JO3yWvfgvAI3OKBcyFxnLkRglT9xk21AvPOD5dw/hg6qYSiUVV1gat
         AVrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717182651; x=1717787451;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nesPb3ikOdykWdzBTsuyXBWRTSA6l9jG6DEva+E2AsA=;
        b=RB2otdpe3URB+qRhQDTnnx9E1dUErsDj0X5B6WmB5WdVXYLdox4xK/cJkCffTnJseS
         SGN7v6WAd4A3BGKUdldGqc1vsRtiFfMzLAj2+l+8FBl09MxrYE6OaMPr5Z3l41x+UYsw
         YaiI4pbnc0JzYYaZ0nv11e+NtYppE8ErdlkvAj6L2O47ETVNVc5GLMnEwyqZcIJIqnwY
         DdJkD2uc//2f4Gt9+XT491OpXQqJJSGLgtVUUL1R9xFALNXqmhYFQJVSodE9n0NARNtN
         8L/48fFGMX7bliPyosJ1rBSJK1+9Bv4PgclrnPMML0hBxOCS4jqx+XvugSdbs6rnYL37
         j6Pg==
X-Gm-Message-State: AOJu0YyFwJCurc1pamn4gdPWAWlazroYUNvd/3oBV9DaCma7cZMjD+cG
	iAWGPfjA1x6GM2/E3nJ+ViHQu+M/EgT37WvLDV318qxv6pwMmzy0Wtq9UavjmgE=
X-Google-Smtp-Source: AGHT+IHWFk+srywj1XgbKk4pALN2Vbw6fh0959m0ZBqz29FdQa3ULjNg0yP3f2lWosybEoMXx7h5JA==
X-Received: by 2002:a05:6a00:6585:b0:701:bde7:c857 with SMTP id d2e1a72fcca58-702478c7471mr2802070b3a.3.1717182650720;
        Fri, 31 May 2024 12:10:50 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-702425d8a5fsm1705830b3a.76.2024.05.31.12.10.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 May 2024 12:10:50 -0700 (PDT)
Message-ID: <30513e0e-6af5-4b1a-9963-f6e1ae20a2ea@kernel.dk>
Date: Fri, 31 May 2024 13:10:48 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 19/19] fuse: {uring} Optimize async sends
To: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>,
 Amir Goldstein <amir73il@gmail.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "bernd.schubert@fastmail.fm" <bernd.schubert@fastmail.fm>
Cc: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
 <20240529-fuse-uring-for-6-9-rfc2-out-v1-19-d149476b1d65@ddn.com>
 <ee075116-5ed0-4ad7-9db2-048b14655d42@kernel.dk>
 <870c28bd-1921-4e00-9898-1d93b031c465@ddn.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <870c28bd-1921-4e00-9898-1d93b031c465@ddn.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/31/24 11:36 AM, Bernd Schubert wrote:
> On 5/31/24 18:24, Jens Axboe wrote:
>> On 5/29/24 12:00 PM, Bernd Schubert wrote:
>>> This is to avoid using async completion tasks
>>> (i.e. context switches) when not needed.
>>>
>>> Cc: io-uring@vger.kernel.org
>>> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
>>
>> This patch is very confusing, even after having pulled the other
>> changes. In general, would be great if the io_uring list was CC'ed on
> 
> Hmm, let me try to explain. And yes, I definitely need to add these details 
> to the commit message
> 
> Without the patch:
> 
> <sending a struct fuse_req> 
> 
> fuse_uring_queue_fuse_req
>     fuse_uring_send_to_ring
>         io_uring_cmd_complete_in_task
>         
> <async task runs>
>     io_uring_cmd_done()

And this is a worthwhile optimization, you always want to complete it
line if at all possible. But none of this logic or code belongs in fuse,
it really should be provided by io_uring helpers.

I would just drop this patch for now and focus on the core
functionality. Send out a version with that, and then we'll be happy to
help this as performant as it can be. This is where the ask on "how to
reproduce your numbers" comes from - with that, it's usually trivial to
spot areas where things could be improved. And I strongly suspect that
will involve providing you with the right API to use here, and perhaps
refactoring a bit on the fuse side. Making up issue_flags is _really_
not something a user should do.

> 1) (current == queue->server_task)
> fuse_uring_cmd (IORING_OP_URING_CMD) received a completion for a 
> previous fuse_req, after completion it fetched the next fuse_req and 
> wants to send it - for 'current == queue->server_task' issue flags
> got stored in struct fuse_ring_queue::uring_cmd_issue_flags

And queue->server_task is the owner of the ring? Then yes that is safe
> 
> 2) 'else if (current->io_uring)'
> 
> (actually documented in the code)
> 
> 2.1 This might be through IORING_OP_URING_CMD as well, but then server 
> side uses multiple threads to access the same ring - not nice. We only
> store issue_flags into the queue for 'current == queue->server_task', so
> we do not know issue_flags - sending through task is needed.

What's the path leading to you not having the issue_flags?

> 2.2 This might be an application request through the mount point, through
> the io-uring interface. We do know issue flags either.
> (That one was actually a surprise for me, when xfstests caught it.
> Initially I had a condition to send without the extra task then lockdep
> caught that.

In general, if you don't know the context (eg you don't have issue_flags
passed in), you should probably assume the only way is to sanely proceed
is to have it processed by the task itself.

> 
> In both cases it has to use a tasks.
> 
> 
> My question here is if 'current->io_uring' is reliable.

Yes that will be reliable in the sense that it tells you that the
current task has (at least) one io_uring context setup. But it doesn't
tell you anything beyond that, like if it's the owner of this request.

> 3) everything else
> 
> 3.1) For async requests, interesting are cached reads and writes here. At a minimum
> writes a holding a spin lock and that lock conflicts with the mutex io-uring is taking - 
> we need a task as well
> 
> 3.2) sync - no lock being hold, it can send without the extra task.

As mentioned, let's drop this patch 19 for now. Send out what you have
with instructions on how to test it, and I'll give it a spin and see
what we can do about this.

>> Outside of that, would be super useful to include a blurb on how you set
>> things up for testing, and how you run the testing. That would really
>> help in terms of being able to run and test it, and also to propose
>> changes that might make a big difference.
>>
> 
> Will do in the next version. 
> You basically need my libfuse uring branch
> (right now commit history is not cleaned up) and follow
> instructions in <libfuse>/xfstests/README.md how to run xfstests.
> Missing is a slight patch for that dir to set extra daemon parameters,
> like direct-io (fuse' FOPEN_DIRECT_IO) and io-uring. Will add that libfuse
> during the next days.

I'll leave the xfstests to you for now, but running some perf testing
just to verify how it's being used would be useful and help improve it
for sure.

-- 
Jens Axboe


