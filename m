Return-Path: <io-uring+bounces-9610-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A58E2B464E8
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 22:47:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 74F9E16A5B6
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 20:47:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94878283FFB;
	Fri,  5 Sep 2025 20:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mk2crzxX"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A74919343B;
	Fri,  5 Sep 2025 20:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757105251; cv=none; b=kcptwtu0aNXp03D/KFJryobkwocJJZZE36uSfCIfjvMpdcskx1YTMbmRoBx/vGQp5z8xHK6lgOOPW9ZklDciJX7BiUVCi114LNbLvXZLkH2O0noBmUtXXjZg5cRl8LAGEI9An22ICJl+C14SsKgZrjlQXYS+ObCpVa5SgunynwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757105251; c=relaxed/simple;
	bh=X9QO4Gd/KqsySLQrKkXq9tZI7F0AC52LeY/MRkJxu6E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J6zqrKj6iF0h1uSFGjZjFTb+jYBtsPHqY4YWauL0dxwAyFrwWWDKbGjGHghHZGefULk1xxHthCqxr7wMJCPxTb+jFKFUXRYOZ0h6jT45TNWyhC8Rq2RCL3iiPThyc1eGqIim1yeQ2aC/gPEOsnTcGVBNJ/UetqvwjtCRoYeUPp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mk2crzxX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF75C4CEF1;
	Fri,  5 Sep 2025 20:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757105250;
	bh=X9QO4Gd/KqsySLQrKkXq9tZI7F0AC52LeY/MRkJxu6E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Mk2crzxXJO6xwOHACqeatVuXJffjBBH0YwOsdPk8EVKc9VGKpHLyrX5M9pczlRGqO
	 msM7QuzgaM39hz09UJCRs9KhT/6XMehjMS5e/SvT87cnQivh2kuZiRT0TwrDzKYEe/
	 rdHkmXHIgQ7JlXtLctCX9pwWBcQEsfIDurmeDHfKg2yjlK+UoM41tn3td+WY3YeKJx
	 0KqDmUX8ISTwyY/P+iRZpYfoycevNHnYXXlOnQFk5bzQyBhG8HCTdw9PgKkRLwMImO
	 Rk7+lMJKctwGj4xLH/L0VGBT2A/Mq6C2UsX1if8FUYfv5w7FPSKx4xLRL+E7J2K4z0
	 QbVvRqIkuLJ0A==
Date: Fri, 5 Sep 2025 16:47:29 -0400
From: Sasha Levin <sashal@kernel.org>
To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	Caleb Sander Mateos <csander@purestorage.com>,
	io-uring <io-uring@vger.kernel.org>, workflows@vger.kernel.org
Subject: Re: Link trailers revisited (was Re: [GIT PULL] io_uring fix for
 6.17-rc5)
Message-ID: <aLtMYVY_jD_HrTgg@laps>
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
 <CAHk-=wjamixjqNwrr4+UEAwitMOd6Y8-_9p4oUZdcjrv7fsayQ@mail.gmail.com>
 <20250905-lovely-prehistoric-goldfish-04e1c3@lemur>
 <CAHk-=wg30HTF+zWrh7xP1yFRsRQW-ptiJ+U4+ABHpJORQw=Mug@mail.gmail.com>
 <20250905-sparkling-stalwart-galago-8a87e0@lemur>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250905-sparkling-stalwart-galago-8a87e0@lemur>

On Fri, Sep 05, 2025 at 03:33:14PM -0400, Konstantin Ryabitsev wrote:
>On Fri, Sep 05, 2025 at 11:06:01AM -0700, Linus Torvalds wrote:
>> Anyway, the "discourage mindless use" might be as simple as a big
>> warning message that the link may be just adding annoying overhead.
>>
>> In contrast, a "perfect" model might be to actually have some kind of
>> automation of "unless there was actual discussion about it".
>>
>> But I feel such a model might be much too complicated, unless somebody
>> *wants* to explore using AI because their job description says "Look
>> for actual useful AI uses". In today's tech world, I assume such job
>> descriptions do exist. Sigh.
>
>So, I did work on this for a while before running out of credits, and there
>were the following stumbling blocks:
>
>- consuming large threads is expensive; a thread of 20 patches and a bunch of
>  follow-up discussions costs $1 of API credits just to process. I realize
>  it's peanuts for a lot of full-time maintainers who have corporate API
>  contracts, but it's an important consideration
>- the LLMs did get confused about who said what when consuming long threads,
>  at least with the models at the time. Maybe more modern models are better at
>  this than those I tried a year ago. Misattributing things can be *really*
>  bad in the context of decision making, so I found this the most troubling
>  aspect of "have AI analyze this series and tell me if everyone important is
>  okay with it."

Quick note on this: I observed the same thing, but found that using structured
format (i.e. lei q --format json) really helps with this issue.

>- the models I used were proprietary (ChatGPT, Claude, Gemini), because I
>  didn't have access to a good enough system to run ollama with a large enough
>  context window to analyze long email threads. Even ollama is questionably
>  "open source" -- but don't need to get into that aspect of it in this
>  thread.
>
>However, I feel that LLMs can be generally useful here, when handled with
>care and with a good understanding that they do and will get things wrong.

I'm facing a similar challange both for the AUTOSEL and the CVE work: there is
very little historical context in most commits, and the Link: tag is almost
always useless and just points to the final submission of a patch rather than a
relevant discussion around that code.

I ended up creating an AI agent that knows how to dig through both a local git
repo as well as our mailing list using lei-q and knows to search related
dashboards like kernelci, lkft, the syzbot dashboard, etc.

I'm not sure if at it's current form it's useful to anyone else, but here's an
example of what it generates on the patch in question:


Mailing List History for commit 0f51a5c0a89921deca72e42583683e44ff742d06
========================================================================

Author: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu Sep 4 19:25:34 2025 -0600
Subject: io_uring/rsrc: initialize io_rsrc_data nodes array

## Timeline of Events

1. **October 25, 2024**: Jens Axboe commits major refactoring
    - Commit: 7029acd8a950 ("io_uring/rsrc: get rid of per-ring io_rsrc_node list")
    - Major rewrite eliminating per-ring serialization of resource nodes
    - Addressed resource reclaim stalls in networked workloads

2. **April 4, 2025**: Pavel Begunkov fixes related issue
    - Commit: ab6005f3912f ("io_uring: don't post tag CQEs on file/buffer registration failure")
    - Also fixes issues introduced by commit 7029acd8a950
    - Reference: https://lore.kernel.org/r/c514446a8dcb0197cddd5d4ba8f6511da081cf1f.1743777957.git.asml.silence@gmail.com

3. **September 4, 2025, 19:25 MDT**: Caleb submits initialization fix
    - Message-ID: 20250905012535.2806919-1-csander@purestorage.com
    - Sent to: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
    - Direct submission to Jens Axboe

4. **September 4, 2025, 19:50 MDT**: Jens applies the patch
    - Applied within 25 minutes of submission
    - No public review or discussion found

5. **September 5, 2025, 05:14 MDT**: Jens sends acknowledgment
    - Message-ID: 175707084146.356946.8866336484834458029.b4-ty@kernel.dk
    - Simple "Applied, thanks!" with b4 tool
    - Assigned commit: 0f51a5c0a89921deca72e42583683e44ff742d06

## Key Findings from Mailing List Search

### Minimal Public Discussion
- **No pre-submission review**: No RFC or v1 versions found
- **No public bug reports**: No KASAN, syzkaller, or user bug reports found that directly led to this fix
- **No post-submission discussion**: Only Jens' acknowledgment found
- **No testing tags**: No Tested-by or Reviewed-by tags

### Related Activity
- Pavel Begunkov's earlier fix (April 2025) shows the original refactoring had multiple issues
- Both fixes target error paths in the resource registration code
- Pattern suggests issues were found through code review rather than runtime failures


-- 
Thanks,
Sasha

