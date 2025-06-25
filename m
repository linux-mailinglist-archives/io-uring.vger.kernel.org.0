Return-Path: <io-uring+bounces-8494-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7536AAE9130
	for <lists+io-uring@lfdr.de>; Thu, 26 Jun 2025 00:41:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9CFE87B1A99
	for <lists+io-uring@lfdr.de>; Wed, 25 Jun 2025 22:40:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C1CE2153F1;
	Wed, 25 Jun 2025 22:41:34 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B688F4C83;
	Wed, 25 Jun 2025 22:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750891294; cv=none; b=CBkDaochwI97KDiL6QAcIL7zGvUyuzXrBPwOVGsMwvvmpyB6an7pyCsBtVYXYMvIgeR9/uvxzcSClwH2IOi00J1PfORvt8Y4QmrEVVnu1y3SmzC9v9VwSCABqTmJrQ6EOhye2WfLu8xlR5z8dfAlwLGacB+6/wcr6hVt5nqe4W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750891294; c=relaxed/simple;
	bh=6vYEWu9DGhdUZ8Lpy0meruLoiFvzQfm2h/13pKWVoGM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YW8R9TK/UXYMPlqwzJd2bcp1rSkZ7E1Pd74bnM+urBJoHVGCOBrvO6XgbUGtVC3Zh7Rx+Vog/lZBBhHGyEe5B2NqVCwJpZvXwXj3Ofmlv50JZ+hsYGGBDCKhwvJs8vgEw7GCodeNkOaODxC66QJLyhW0eSRQLl+xQcjNJCEaEGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2A5C98077D;
	Wed, 25 Jun 2025 22:41:25 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf07.hostedemail.com (Postfix) with ESMTPA id 3AFF220032;
	Wed, 25 Jun 2025 22:41:23 +0000 (UTC)
Date: Wed, 25 Jun 2025 18:41:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jiazi Li <jqqlijiazi@gmail.com>, linux-kernel@vger.kernel.org,
 "peixuan.qiu" <peixuan.qiu@transsion.com>, io-uring@vger.kernel.org, Peter
 Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] stacktrace: do not trace user stack for user_worker
 tasks
Message-ID: <20250625184144.48c87888@gandalf.local.home>
In-Reply-To: <ddcbdaa0-479a-4821-9230-d3207be20b3c@kernel.dk>
References: <20250623115914.12076-1-jqqlijiazi@gmail.com>
	<20250624130744.602c5b5f@batman.local.home>
	<80e637d3-482d-4f3a-9a86-948d3837b24d@kernel.dk>
	<20250625165054.199093f1@batman.local.home>
	<ddcbdaa0-479a-4821-9230-d3207be20b3c@kernel.dk>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3aczrkng4psaeafaurcpqqo4ezr1i7sp
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: 3AFF220032
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX196oG4RSM3JQlF54pldebc54oHrSoL8/OM=
X-HE-Tag: 1750891283-607082
X-HE-Meta: U2FsdGVkX1/ukDzgmQB7p+I+ZdFCNBeYypRkgS5mGEAlv8nJGBVuCkRtxoY8zf1AzkEWF3t8Y+VCCg5yGUocEXMhpA6uqhWt6WI40CdTFzHEZ0+kVRihumPmzrnxu2q6TqUt5qsrs+rohaUWTlSSPsQ1fZmq54/MX6MZwVXsFJcPMQ6ZCjlVMo27P+0K6i6tHsAxEwIs/HEt4UxzixQ6zEoqu/2zIdNSmiGs71xlqalQMb2DrsR5fh8hU8jwvlPB7jgMnCIjah+qAvUYkq4YeM/Gk4lQhZxMprhgzHZTE/yktpK8f02TwmaE1aRyqjOYJgXxVO0YqYtvzFfnjUrHUDhM/21REIasIbQadXuLbEwgBRqhHrtuWVlYXYvFkTnSFrQGb9tYhJpA2StMcSa5PqV2XG57uxQ3xzjwgqnbQRo=

On Wed, 25 Jun 2025 16:30:55 -0600
Jens Axboe <axboe@kernel.dk> wrote:

> On 6/25/25 2:50 PM, Steven Rostedt wrote:
> > [
> >   Adding Peter Zijlstra as he has been telling me to test against
> >   PF_KTHREAD instead of current->mm to tell if it is a kernel thread.
> >   But that seems to not be enough!
> > ]  
> 
> Not sure I follow - if current->mm is NULL, then it's PF_KTHREAD too.
> Unless it's used kthread_use_mm().
> 
> PF_USER_WORKER will have current->mm of the user task that it was cloned
> from.

The suggestion was to use (current->flags & PF_KTHREAD) instead of
!current->mm to determine if a task is a kernel thread or not as we don't
want to do user space stack tracing on kernel threads. Peter said that
because of io threads which have current->mm set, you can't rely on that,
so check the PF_KHTREAD flag instead. This was assuming that io kthreads
had that set too, but apparently it does not and we need to check for
PF_USER_WORKER instead of just PF_KTHREAD.

> 
> > On Wed, 25 Jun 2025 10:23:28 -0600
> > Jens Axboe <axboe@kernel.dk> wrote:
> >   
> >> On 6/24/25 11:07 AM, Steven Rostedt wrote:  
> >>> On Mon, 23 Jun 2025 19:59:11 +0800
> >>> Jiazi Li <jqqlijiazi@gmail.com> wrote:
> >>>     
> >>>> Tasks with PF_USER_WORKER flag also only run in kernel space,
> >>>> so do not trace user stack for these tasks.    
> >>>
> >>> What exactly is the difference between PF_KTHREAD and PF_USER_WORKER?    
> >>
> >> One is a kernel thread (eg no mm, etc), the other is basically a user
> >> thread. None of them exit to userspace, that's basically the only
> >> thing they have in common.  
> > 
> > Was it ever in user space? Because exiting isn't the issue for getting
> > a user space stack. If it never was in user space than sure, there's no
> > reason to look at the user space stack.  
> 
> It was never in userspace.

OK then for user space stack tracing it is the same as a KTHREAD.

> 
> >>> Has all the locations that test for PF_KTHREAD been audited to make
> >>> sure that PF_USER_WORKER isn't also needed?    
> >>
> >> I did when adding it, to the best of my knowledge. But there certainly
> >> could still be gaps. Sometimes not easy to see why code checks for
> >> PF_KTHREAD in the first place.
> >>  
> >>> I'm working on other code that needs to differentiate between user
> >>> tasks and kernel tasks, and having to have multiple flags to test is
> >>> becoming quite a burden.    
> >>
> >> None of them are user tasks, but PF_USER_WORKER does look like a
> >> user thread and acts like one, except it wasn't created by eg
> >> pthread_create() and it never returns to userspace. When it's done,
> >> it's simply reaped.
> >>  
> > 
> > I'm assuming that it also never was in user space, which is where we
> > don't want to do any user space stack trace.  
> 
> It was not.
> 
> > This looks like more rationale for having a kernel_task() user_task()
> > helper functions:
> > 
> >   https://lore.kernel.org/linux-trace-kernel/20250425204120.639530125@goodmis.org/
> > 
> > Where one returns true for both PF_KERNEL and PF_USER_WORKER and the
> > other returns false.  
> 
> On vacation right now, but you can just CC me on the next iteration and
> I'll take a look.
> 

Well, it was sortof NACKED by Ingo, and he started another version, but I
don't know if that is still happening or not.

  https://lore.kernel.org/linux-trace-kernel/aA0pDUDQViCA1hwi@gmail.com/

Although, that patch just looks like its simply adding helper functions for
all the pf flags, but doesn't solve the issue of just testing "Is this a
kernel thread or user thread?"

-- Steve

