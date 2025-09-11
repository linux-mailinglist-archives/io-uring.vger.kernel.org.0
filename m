Return-Path: <io-uring+bounces-9758-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B1F50B53CC6
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 21:57:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 020DC1CC63A3
	for <lists+io-uring@lfdr.de>; Thu, 11 Sep 2025 19:57:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6DA822156A;
	Thu, 11 Sep 2025 19:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MQmnlV9Y"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF4C4315F;
	Thu, 11 Sep 2025 19:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757620652; cv=none; b=mLPGKTXWURtz5cID0Svg8snb59JTp7kzdhop8lDH5nY8ivuHZnLim6XKg2bOFICMNhphW9wC6tdq17ec7DudxPKdVanGRzy46eDTzijGQWfFzxfm/zwnSz2LK8E63lYPLsFSebAk3/POWO9XyVtXBaKAZ3ss/KejgQSiN2uiiN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757620652; c=relaxed/simple;
	bh=CDgN5H623d0hg9fcWZA4yJC8NpwZk7KWxKm3tD91rVk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q4umuv143W49q1MbXHdNMbtAGmj5UlhekpwyQUzDcTxekkZcUONWATz4HfCqMomsY6kCeb20XafYFQnIpkAwBHNnynXvqA2++1+auYPYiXS8EcNDFWvZuwsH9iu7rpHODaKKhk1YTHq//QVZliXEMdQtBSX3lXfdcdMAw1FvsKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MQmnlV9Y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE459C4CEF0;
	Thu, 11 Sep 2025 19:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757620652;
	bh=CDgN5H623d0hg9fcWZA4yJC8NpwZk7KWxKm3tD91rVk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MQmnlV9YMOW4cDAEQcyqqSD4W2zNmNRLMuruRxTK1fvOpRaubs1CK9Is6rWFZqfKX
	 xscnKwBgWT7/rhA7ns9zY9fl+2XcrR4a2VZRHhUlNJ8x6Jtyp09gyuwDKb0cWPQJNE
	 Nh8udD7WrZX5CJZ6nVA00XKIf6b1sg00MFvdnbyMbxJUBnpBxk/dZpwRQkPX8vj/AN
	 1+BwXJmKNXNiSFW5XSWJqHYPiYTDJXJXXkbrZHKuHmQn3lviJflofF8nIZDUIYVQ+L
	 aY2z1Sa5dUd5vOdtVSMRaSRjU42IjUl45tA2cUtIa9cUu0d/iRGrsQicEd78xlZ830
	 EKTk+7gIXDjCA==
Date: Thu, 11 Sep 2025 15:57:30 -0400
From: Sasha Levin <sashal@kernel.org>
To: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Cc: konstantin@linuxfoundation.org, axboe@kernel.dk,
	csander@purestorage.com, io-uring@vger.kernel.org,
	torvalds@linux-foundation.org, workflows@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC] b4 dig: Add AI-powered email relationship discovery command
Message-ID: <aMMpqojURAZa7cPU@laps>
References: <20250905-sparkling-stalwart-galago-8a87e0@lemur>
 <4764751.e9J7NaK4W3@workhorse>
 <aMLlMz_ujgditm4c@laps>
 <4278380.jE0xQCEvom@workhorse>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <4278380.jE0xQCEvom@workhorse>

On Thu, Sep 11, 2025 at 09:13:28PM +0200, Nicolas Frattaroli wrote:
>On Thursday, 11 September 2025 17:05:23 Central European Summer Time Sasha Levin wrote:
>> On Thu, Sep 11, 2025 at 04:48:03PM +0200, Nicolas Frattaroli wrote:
>> >On Tuesday, 9 September 2025 18:32:14 Central European Summer Time Sasha Levin wrote:
>> >it doesn't seem like Assisted-by is the right terminology here, as
>> >the code itself makes me believe it was written wholesale by your
>> >preferred LLM with minimal oversight, and then posted to the list.
>> >
>> >A non-exhaustive code review inline, as it quickly became clear
>> >this wasn't worth further time invested in reviewing.
>>
>> Thanks for the review!
>>
>> Indeed, Python isn't my language of choice: this script was a difficult (for
>> me) attempt at translating an equivalent bash based script that I already had
>> into python so it could fit into b4.
>
>There's something to be said about these tools' habit of empowering
>people to think they can judge the output adequately, but I don't
>want to detract from the other point I'll try to make in this reply.
>
>> My intent was for this to start a discussion about this approach rather than
>> actually be merged into b4.
>
>I know that, and you did get feedback on this approach already from
>others, specifically that it did not solve the core issue that is
>poorly utilised metadata and instead applies hammer to vaguely nail
>shaped thing.
>
>And your reaction was to call them personally biased against this
>approach, and to loudly announce you would ignore any further
>e-mails from them.
>
>Now while I won't claim Laurent Pinchart isn't one of the louder
>critics of your recent LLM evangelism, I can't really see a fault
>in his reasoning: your insistence on finding an LLM solution to
>every and any problem is papering over the real pain point,
>which is that Link: should contain useful information, so that
>you can click on the link and get the information and not have
>to do a search (LLM assisted or not) for said information.
>
>So the responses you expect to this patch should seemingly meet the
>following two criteria:
>1. we're not supposed to critique the implementation, as it's an RFC
>   and therefore should not get comments on anything but the general
>   approach,
>2. we're not supposed to critique the general approach, because saying
>   that this solution is neither reliable nor efficient is a result
>   of personal bias against the underlying technology.
>
>I don't condone the arguments based on energy usage because any use
>of electricity in a grid that's not decarbonised will be open to
>value judgements. For example, my personal non-workplace-endorsed
>opinion is that electricity used on growing zucchini is wasted,
>as they are low-nutrient snot pumpkins masquerading as cucumbers.
>
>My main criticism on the approach end of things, if I am allowed
>an opinion, is that this does not make Link: tags more meaningful,
>nor does it solve the problem of automated tools adding sometimes
>useless noise to something humans are supposed to be reading (which,
>some may point out, your tool makes even worse.)
>
>While bisecting, I often come across things where I'd love to be
>able to immediately see what discussion preceded the problematic
>patch with just one click and pageload between. Shoveling GPUs
>into Sam Altman's gaping cheeks does not allow me to do that,
>or at least not any better than a search on lore with dfn: would
>already allow me to do.

I very much agree with your general observation:

1. I don't think that this script solves the underlying Link: issue.

2. It papers over the real problem

3. I don't think that today's LLMs can solve any fundamental issue we're facing
in kernel-land.

4. I am really happy (as Laurent said) to apply my big hammer to anything that
looks like a nail.


We've started[1] the workflows@ list (which is how I stumbled on this thread)
about 5-6 years ago when the concern from multiple maintainers was that we all
have our magical scripts, they are seriously ugly, and everyone are ashamed of
sharing them. So this list was an effort to get the ball rolling on folks
sharing some of those ugly workflows and scripts in an attempt to standardize
and improve our processes.

I've shared this very hacky b4-dig script as exactly that: I have a very ugly
bash script that addresses some of the issues Linus brought up around being
able to find more context for a given patch/mail.  I use that script often, it
helps me spend less time on browsing lore (no, dfn: won't find you syzbot
reports or CI failures), and it just "works for me".

I'd love if we end up with a great solution for Link:, I'm not asking anyone to
stop working on that, nor am I claiming that this is a good long-term solution
for the problem. All this is is a utility script that fits my needs *TODAY*.

So no, I wasn't looking for criticism on workflows@ (this isn't even on lkml,
ksummit-discuss, or anything like that).  I was looking to share a workflow
that I have and see if folks have any ideas, suggestions, or would potentially
want to do something like this on their own.  I wasn't looking for an almost
religious "vim vs. emacs"-esque choire of "LLMS SUCK" or comments about Sam
Altman's rear end.

Maybe this is why folks are reluctant to share their ugly scripts?



[1] https://lwn.net/Articles/799134/ - "The session closed with the creation of
a new "workflows" mailing list on vger.kernel.org where developers can discuss
how they work and share their scripts".

-- 
Thanks,
Sasha

