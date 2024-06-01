Return-Path: <io-uring+bounces-2058-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 464DE8D7123
	for <lists+io-uring@lfdr.de>; Sat,  1 Jun 2024 18:37:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B40681F21108
	for <lists+io-uring@lfdr.de>; Sat,  1 Jun 2024 16:37:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB5461534F9;
	Sat,  1 Jun 2024 16:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b="OdBmf0bE";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="XDhKGhNH"
X-Original-To: io-uring@vger.kernel.org
Received: from wfhigh5-smtp.messagingengine.com (wfhigh5-smtp.messagingengine.com [64.147.123.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3DDA1527A0;
	Sat,  1 Jun 2024 16:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=64.147.123.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717259827; cv=none; b=JszTZMuUfccblbPa7s5pkEqT5hVd1fyLsY+RHX0FE3CiHAkkP9lmBI9p7LeQq55oZslqL0/DYPgjprZqn7xCePvsNwYYSlELxAP83hDlVQ7uMRZm0ZgyU6qvvTwmTqVYgwBkd+LRkxg3WwRli1KwthuQk+iCIepeKS8n7zY1Mps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717259827; c=relaxed/simple;
	bh=oPjEGtuCnl3oOkJ8SYZPw38/qjvrGbG5My4Ptz2AsQU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p+vc8ZiylwIajsMa1vEp1U/N+3IZFHkZiQ6S3immNhS6GVab+rmkbOO76KhIwVGXXHV2CjDjEGqD6OjtqH5QLdCKCgfbTlh51VHrzZCq7ilyh+kjaOqrkKRaLMreBLNvK5fA82lyMLRCQFOWHevvvxUoqjMFRzK0VQ+ixgOCdlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm; spf=pass smtp.mailfrom=fastmail.fm; dkim=pass (2048-bit key) header.d=fastmail.fm header.i=@fastmail.fm header.b=OdBmf0bE; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=XDhKGhNH; arc=none smtp.client-ip=64.147.123.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.fm
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailfhigh.west.internal (Postfix) with ESMTP id 9F24D18000BE;
	Sat,  1 Jun 2024 12:37:04 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sat, 01 Jun 2024 12:37:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1717259824;
	 x=1717346224; bh=/WTJVG/atiInOMnbemzoIZEREJMQF4GBHpdxb8pWuwI=; b=
	OdBmf0bEx3XWop5sjrA1t30qfkR6iKogkY0plxm6z+9JSKei+XXiMqsbxOeaIKyQ
	DmrLs7200BzuarNWwvT7ORflZegtr/+Ovwk/3QK/Re9BPGzZFiXKe8DLZGDpo/8w
	Xo62rWrrM32kQriekKaBvkgFFmeZVx5D4JkBOMBLoeS5BS1rNbFEwVzeLqfEKTiT
	ErA2WPyTW2/PCxyg3b4UH8EQWzHtJJhEKRd2AI/9dguxtnPl4qmGxsDTqFMVSpLq
	mfB0W7B8gptwJNBWG3ikKlKaf+uGt0ZkBfmE71/0R6T/xjBAXpwTPZZ3WTLFTH7F
	htzyHfg+38XQJ17ru/Q+ww==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1717259824; x=
	1717346224; bh=/WTJVG/atiInOMnbemzoIZEREJMQF4GBHpdxb8pWuwI=; b=X
	DhKGhNHLA3EgXzHD+UoCV0v40c05KDobEshEuVmROI86O557T0UD4gELz/ApXKBD
	skZHpIvNLSh22et1qBo54/LmDA8fiDE+m3XhDXwDg/CyuFE+gx97X9u+PHPWeV3X
	mo7Do18NStokiROYJ8GMvzFhVKXbQCvHNOA+5IN9uscwBMZjSNwTGy4LO/C9Ldy4
	RDVsFYfUiW3A+/ot5egZoLZuMT98Fd7PPt0KBQjtdKvCufqrAukB3na38+FqTG+H
	W38bPmE21PZRbumF+Aj/gBZKp5Nd3u4waMae0KRBBaohnl5u5icHF4aZVVJrJ41y
	DH7wR+A3c6LaQafSbWyKQ==
X-ME-Sender: <xms:L05bZkI5ZunA-rdk2m0mTmalbZdfEIXLfnbBQ6Z780pCs-8rpLpWXA>
    <xme:L05bZkLJxYTlfnjpG9UjmXqmq7zHUgE1kO0n3WBhHaYqrz8uv2JWIre2sg5KKdhGs
    1dflfBzYqOeCXNc>
X-ME-Received: <xmr:L05bZktVQPeknp7p8GXSJCDmSZKSAD6Dl61-t8aUiLW4LzRgMzcq2fN5Qbh5ppa7w6v_twBYAE9WhFI3EIEo6nUi-zveDqFDcRaaotcCwcfqTNRrnaMW>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrvdekkedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttddvjeenucfhrhhomhepuegv
    rhhnugcuufgthhhusggvrhhtuceosggvrhhnugdrshgthhhusggvrhhtsehfrghsthhmrg
    hilhdrfhhmqeenucggtffrrghtthgvrhhnpeevhffgvdeltddugfdtgfegleefvdehfeei
    veejieefveeiteeggffggfeulefgjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpegsvghrnhgurdhstghhuhgsvghrthesfhgrshhtmhgrihhl
    rdhfmh
X-ME-Proxy: <xmx:L05bZhYfDQMZ6l2ScRBedtgye8j19NbLuDA9v7yjv4jPvDvkVqNk8g>
    <xmx:L05bZrbEDw8C7gxtXpZhYDrjA8KZn11xvyv-lMu0hfudHPiV_FPegQ>
    <xmx:L05bZtDhIEGkFbSfCmgZwSdlI5SsDHI8zIvKBNNfv35xtpFBaw8j1A>
    <xmx:L05bZhaXPkQzZJuOrH5ejiadV6205tyxwkdVJCwoylvu-ZY94ismgA>
    <xmx:ME5bZgNzvGxnEtNsJOycKku2eahw63ejfxIDCBiPfY5bh65NKnrhS3y9>
Feedback-ID: id8a24192:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 1 Jun 2024 12:37:02 -0400 (EDT)
Message-ID: <7cdf0cd9-e078-410b-9762-f29b2f140176@fastmail.fm>
Date: Sat, 1 Jun 2024 18:37:01 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 19/19] fuse: {uring} Optimize async sends
To: Jens Axboe <axboe@kernel.dk>, Bernd Schubert <bschubert@ddn.com>,
 Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Cc: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
 <20240529-fuse-uring-for-6-9-rfc2-out-v1-19-d149476b1d65@ddn.com>
 <ee075116-5ed0-4ad7-9db2-048b14655d42@kernel.dk>
 <870c28bd-1921-4e00-9898-1d93b031c465@ddn.com>
 <30513e0e-6af5-4b1a-9963-f6e1ae20a2ea@kernel.dk>
From: Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Language: en-US, de-DE, fr
In-Reply-To: <30513e0e-6af5-4b1a-9963-f6e1ae20a2ea@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/31/24 21:10, Jens Axboe wrote:
> On 5/31/24 11:36 AM, Bernd Schubert wrote:
>> On 5/31/24 18:24, Jens Axboe wrote:
>>> On 5/29/24 12:00 PM, Bernd Schubert wrote:
>>>> This is to avoid using async completion tasks
>>>> (i.e. context switches) when not needed.
>>>>
>>>> Cc: io-uring@vger.kernel.org
>>>> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
>>>
>>> This patch is very confusing, even after having pulled the other
>>> changes. In general, would be great if the io_uring list was CC'ed on
>>
>> Hmm, let me try to explain. And yes, I definitely need to add these details 
>> to the commit message
>>
>> Without the patch:
>>
>> <sending a struct fuse_req> 
>>
>> fuse_uring_queue_fuse_req
>>     fuse_uring_send_to_ring
>>         io_uring_cmd_complete_in_task
>>         
>> <async task runs>
>>     io_uring_cmd_done()
> 
> And this is a worthwhile optimization, you always want to complete it
> line if at all possible. But none of this logic or code belongs in fuse,
> it really should be provided by io_uring helpers.
> 
> I would just drop this patch for now and focus on the core
> functionality. Send out a version with that, and then we'll be happy to
> help this as performant as it can be. This is where the ask on "how to
> reproduce your numbers" comes from - with that, it's usually trivial to
> spot areas where things could be improved. And I strongly suspect that
> will involve providing you with the right API to use here, and perhaps
> refactoring a bit on the fuse side. Making up issue_flags is _really_
> not something a user should do.

Great that you agree, I don't like the issue_flag handling in fuse code either. 
I will also follow your suggestion to drop this patch. 


> 
>> 1) (current == queue->server_task)
>> fuse_uring_cmd (IORING_OP_URING_CMD) received a completion for a 
>> previous fuse_req, after completion it fetched the next fuse_req and 
>> wants to send it - for 'current == queue->server_task' issue flags
>> got stored in struct fuse_ring_queue::uring_cmd_issue_flags
> 
> And queue->server_task is the owner of the ring? Then yes that is safe

Yeah, it is the thread that submits SQEs - should be the owner of the ring, 
unless daemon side does something wrong (given that there are several
userspace implementation and not a single libfuse only, we need to expect
and handle implementation errors, though).

>>
>> 2) 'else if (current->io_uring)'
>>
>> (actually documented in the code)
>>
>> 2.1 This might be through IORING_OP_URING_CMD as well, but then server 
>> side uses multiple threads to access the same ring - not nice. We only
>> store issue_flags into the queue for 'current == queue->server_task', so
>> we do not know issue_flags - sending through task is needed.
> 
> What's the path leading to you not having the issue_flags?

We get issue flags here, but I want to keep changes to libfuse small and want
to avoid changing non uring related function signatures. Which is the the
why we store issue_flags for the presumed ring owner thread in the queue data
structure, but we don't have it for possible other threads then

Example:

IORING_OP_URING_CMD
   fuse_uring_cmd
       fuse_uring_commit_and_release
           fuse_uring_req_end_and_get_next --> until here issue_flags passed
               fuse_request_end -> generic fuse function,  issue_flags not passed
                   req->args->end() / fuse_writepage_end
                       fuse_simple_background
                           fuse_request_queue_background
                               fuse_request_queue_background_uring
                                   fuse_uring_queue_fuse_req
                                       fuse_uring_send_to_ring
                                           io_uring_cmd_done
                   
      
I.e. we had issue_flags up to fuse_uring_req_end_and_get_next(), but then
call into generic fuse functions and stop passing through issue_flags.
For the ring-owner we take issue flags stored by fuse_uring_cmd()
into struct fuse_ring_queue, but if daemon side uses multiple threads to
access the ring we won't have that. Well, we could allow it and store
it into an array or rb-tree, but I don't like that multiple threads access
something that is optimized to have a thread per core already.

> 
>> 2.2 This might be an application request through the mount point, through
>> the io-uring interface. We do know issue flags either.
>> (That one was actually a surprise for me, when xfstests caught it.
>> Initially I had a condition to send without the extra task then lockdep
>> caught that.
> 
> In general, if you don't know the context (eg you don't have issue_flags
> passed in), you should probably assume the only way is to sanely proceed
> is to have it processed by the task itself.
> 
>>
>> In both cases it has to use a tasks.
>>
>>
>> My question here is if 'current->io_uring' is reliable.
> 
> Yes that will be reliable in the sense that it tells you that the
> current task has (at least) one io_uring context setup. But it doesn't
> tell you anything beyond that, like if it's the owner of this request.

Yeah, you can see that it just checks for current->io_uring and then
uses a task.

> 
>> 3) everything else
>>
>> 3.1) For async requests, interesting are cached reads and writes here. At a minimum
>> writes a holding a spin lock and that lock conflicts with the mutex io-uring is taking - 
>> we need a task as well
>>
>> 3.2) sync - no lock being hold, it can send without the extra task.
> 
> As mentioned, let's drop this patch 19 for now. Send out what you have
> with instructions on how to test it, and I'll give it a spin and see
> what we can do about this.
> 
>>> Outside of that, would be super useful to include a blurb on how you set
>>> things up for testing, and how you run the testing. That would really
>>> help in terms of being able to run and test it, and also to propose
>>> changes that might make a big difference.
>>>
>>
>> Will do in the next version. 
>> You basically need my libfuse uring branch
>> (right now commit history is not cleaned up) and follow
>> instructions in <libfuse>/xfstests/README.md how to run xfstests.
>> Missing is a slight patch for that dir to set extra daemon parameters,
>> like direct-io (fuse' FOPEN_DIRECT_IO) and io-uring. Will add that libfuse
>> during the next days.
> 
> I'll leave the xfstests to you for now, but running some perf testing
> just to verify how it's being used would be useful and help improve it
> for sure.
> 

Ah you meant performance tests. I used libfuse/example/passthrough_hp from
my uring branch and then fio on top of that for reads/writes and mdtest from
the ior repo for metadata. Maybe I should upload my scripts somewhere.


Thanks,
Beernd

