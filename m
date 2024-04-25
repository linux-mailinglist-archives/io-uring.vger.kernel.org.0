Return-Path: <io-uring+bounces-1625-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DEEC48B24C7
	for <lists+io-uring@lfdr.de>; Thu, 25 Apr 2024 17:12:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 21F2EB213CE
	for <lists+io-uring@lfdr.de>; Thu, 25 Apr 2024 15:11:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 110135B1F8;
	Thu, 25 Apr 2024 15:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Jc1MrOqg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B37C14A087
	for <io-uring@vger.kernel.org>; Thu, 25 Apr 2024 15:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714057888; cv=none; b=CGLK2oJkGc0tOkOm2T1KoXbNfNH4YgccmFR1xkV4+lpY/AzKAweMByfWMJCwCnfriVciaUeR21EUUehnti4vNBl125FTEoLsP8hYbg5uJ3KxPMjzIBvMiOK7021i+NZ47CrYwSn3etIKbyAgU5zZKSy+vgGWFVQkv0VGn61dTBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714057888; c=relaxed/simple;
	bh=VHuF70KDq4vgc+rN8ST8mOaZZMsiX21Go5t0IuusDeY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X7sUypP2KFuvAy6y2f1eT2u0ZsmoVghdg4XJDbcrxt4bQWJVdRwJOxVsDkt7m0z1A5C/hbQUynSMUJrNvi25PJS0mwJMiGnW0wnO5UIDxrjebpTP6uoSaIx5EKKh4VEEG/vmwcG/SIfemgL5Qq94iQAN37WIc7SgCl+og/gurIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Jc1MrOqg; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-7d9c78cf6c8so8746639f.2
        for <io-uring@vger.kernel.org>; Thu, 25 Apr 2024 08:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1714057883; x=1714662683; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RTcmPBMUcKSkSzLeogS82UcOj8cMYmCXux3+fi5byDc=;
        b=Jc1MrOqgyRTs9PLzf2BBAaRO0TakuadSxZV6whoTfFxXgLTcmUrZs0rYRn83191MO6
         ZU325EBlLgxz8SQXKzUmmtMPnQJdtUQ5T5escsuDk5PPJlTwRe1Pk3YdxwNrPAGOArYi
         yNAJMVZj0NFMqy8YfdvmV6QwCIZ/RR6XrJHHWXdHR/bE5GA8epwvZT7FgBEF3hoEQWGA
         VlGvxzlw+l6guVWnmIj0Z+UF0LTZxZLe2W8zPa3sWe3AMW0WiRzl4ngpoysltWZjSlv/
         v0I4ymxwZEt56Smvpjng82fd1D/uktY5ZncYcgY5VDv4U7KS/G2rD//8w6DtSgFq8ctD
         WGjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714057883; x=1714662683;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RTcmPBMUcKSkSzLeogS82UcOj8cMYmCXux3+fi5byDc=;
        b=ebSV0v13NuPfKZfVmpp5kp0Km60NHyEtCJOCCI2LwFJv9zkUvXU5Qfl5XgsVoWZX/o
         WWJfji4CCWGIrC0/567YoAN6ULWNji028UOWchsLvL7yOqA6xYYVjjGjsffJar2881AH
         IOQpl4RuIv2bTlk1f2KBOedgdr2aIxzKAh+WnTkwVdkLhl4ZErkmvhwCXdP7vfWUshX2
         PBE4xzwpLVNopl1cCZUy/QdYxMeqCz8XIT5LFuXtlovpWsYJj3KItA9O6nh9pxwfnkBf
         eAcSfcJFwXtoGw0pPaWkLAe/f992LYhjspoRDvo3u02OwPcuZ9xFBioLLM+QYtA1D3l2
         WSnQ==
X-Gm-Message-State: AOJu0YwOdqV5e6MjDBgFcb5ojK+O46jExbyWmVazvqFP4LaDR9eijpy9
	E+sz3K9Oo2zPajZZwnltotRu+Vs13F66smefVz9+sNba7e/bhJeFwj7Y+XbPprq6nijEaVxyk2n
	P
X-Google-Smtp-Source: AGHT+IFNBxudl29R4ZpW9psKJ9Sh7eYMie8mIkAe9rOhXgFuBqYCrq/EvNZLoSwW+tVfCSH9Jy3F5A==
X-Received: by 2002:a05:6e02:1fe5:b0:36b:2a68:d7ee with SMTP id dt5-20020a056e021fe500b0036b2a68d7eemr25780ilb.1.1714057883465;
        Thu, 25 Apr 2024 08:11:23 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id v14-20020a056638250e00b004849340e49csm4800315jat.178.2024.04.25.08.11.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Apr 2024 08:11:22 -0700 (PDT)
Message-ID: <20557585-cd75-4202-b0e5-eabf774ece8e@kernel.dk>
Date: Thu, 25 Apr 2024 09:11:22 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] io_uring/net: add provided buffer support for
 IORING_OP_SEND
Content-Language: en-US
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
References: <20240420133233.500590-2-axboe@kernel.dk>
 <20240420133233.500590-4-axboe@kernel.dk>
 <878r11zmdj.fsf@mailhost.krisman.be>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <878r11zmdj.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/25/24 5:56 AM, Gabriel Krisman Bertazi wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> It's pretty trivial to wire up provided buffer support for the send
>> side, just like how it's done the receive side. This enables setting up
>> a buffer ring that an application can use to push pending sends to,
>> and then have a send pick a buffer from that ring.
>>
>> One of the challenges with async IO and networking sends is that you
>> can get into reordering conditions if you have more than one inflight
>> at the same time. Consider the following scenario where everything is
>> fine:
>>
>> 1) App queues sendA for socket1
>> 2) App queues sendB for socket1
>> 3) App does io_uring_submit()
>> 4) sendA is issued, completes successfully, posts CQE
>> 5) sendB is issued, completes successfully, posts CQE
>>
>> All is fine. Requests are always issued in-order, and both complete
>> inline as most sends do.
> 
> 
> 
> 
> 
> 
>>
>> However, if we're flooding socket1 with sends, the following could
>> also result from the same sequence:
>>
>> 1) App queues sendA for socket1
>> 2) App queues sendB for socket1
>> 3) App does io_uring_submit()
>> 4) sendA is issued, socket1 is full, poll is armed for retry
>> 5) Space frees up in socket1, this triggers sendA retry via task_work
>> 6) sendB is issued, completes successfully, posts CQE
>> 7) sendA is retried, completes successfully, posts CQE
>>
>> Now we've sent sendB before sendA, which can make things unhappy. If
>> both sendA and sendB had been using provided buffers, then it would look
>> as follows instead:
>>
>> 1) App queues dataA for sendA, queues sendA for socket1
>> 2) App queues dataB for sendB queues sendB for socket1
>> 3) App does io_uring_submit()
>> 4) sendA is issued, socket1 is full, poll is armed for retry
>> 5) Space frees up in socket1, this triggers sendA retry via task_work
>> 6) sendB is issued, picks first buffer (dataA), completes successfully,
>>    posts CQE (which says "I sent dataA")
>> 7) sendA is retried, picks first buffer (dataB), completes successfully,
>>    posts CQE (which says "I sent dataB")
> 
> Hi Jens,
> 
> If I understand correctly, when sending a buffer, we set sr->len to be
> the smallest between the buffer size and what was requested in sqe->len.
> But, when we disconnect the buffer from the request, we can get in a
> situation where the buffers and requests mismatch,  and only one buffer
> gets sent.
> 
> Say we are sending two buffers through non-bundle sends with different
> sizes to the same socket in this order:
> 
>  buff[1]->len = 128
>  buff[2]->len = 256
> 
> And SQEs like this:
> 
>  sqe[1]->len = 128
>  sqe[2]->len = 256
> 
> If sqe1 picks buff1 it is all good. But, if sqe[2] runs first, then
> sqe[1] picks buff2, and it will only send the first 128, won't it?
> Looking at the patch I don't see how you avoid this condition, but
> perhaps I'm missing something?
> 
> One suggestion would be requiring sqe->len to be 0 when using send with
> provided buffers, so we simply use the entire buffer in
> the ring.  wdyt?

It might not hurt to just enforce it to be 0, in fact I think any sane
use case would do that and I don't think the above use case is a very
valid one. It's a bit of "you get to keep both pieces when it breaks".

Do you want to send a patch that just enforces it to be 0? We do have
that requirement in other spots for provided buffers and multishot, so I
think it'll make sense to do here too regardless of the sanity of the
use case.

-- 
Jens Axboe


