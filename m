Return-Path: <io-uring+bounces-8491-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 52712AE8FB2
	for <lists+io-uring@lfdr.de>; Wed, 25 Jun 2025 22:51:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0FEAB7AA481
	for <lists+io-uring@lfdr.de>; Wed, 25 Jun 2025 20:49:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C0901F4297;
	Wed, 25 Jun 2025 20:51:18 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ADBE3074AD;
	Wed, 25 Jun 2025 20:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750884678; cv=none; b=CWClPTXgvhr7FM4dQsrF4Yn9TTYp6u8m0xRGkFgwbrkwmEkLdXqyeOP4lio5rBplz25rIA5itw67IQXiD9iUdnvW4omYQ30YMlDq3yGFa4zmDlWrru6MG6NuqICDNC0Atvep8zBJAWeJC/12ezUgGRrwMoiKTnSsHz3igOaMmfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750884678; c=relaxed/simple;
	bh=6KkgogaZ8zdurDpNx/9i2VO5L1eeG4hr6lZaiwa4V6I=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GMAM0WKzYW+1jtf5Q0HLpb0/p61zYRv9WWp7Epgp7AVpy0WGg23BdfR8oR+mZWS4/FREYvFwW19oZuv+OVl666GUYrF3SM3ty/DHN99hj4mfKelRBrGv07q/IlRjudrvxb9UsiKnfCIyz8OzWyFLcYDrCoRUZv4c1Xiq3qR/t4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ED0C810468F;
	Wed, 25 Jun 2025 20:51:06 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf18.hostedemail.com (Postfix) with ESMTPA id 3336330;
	Wed, 25 Jun 2025 20:51:05 +0000 (UTC)
Date: Wed, 25 Jun 2025 16:50:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jiazi Li <jqqlijiazi@gmail.com>, linux-kernel@vger.kernel.org,
 "peixuan.qiu" <peixuan.qiu@transsion.com>, io-uring@vger.kernel.org, Peter
 Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] stacktrace: do not trace user stack for user_worker
 tasks
Message-ID: <20250625165054.199093f1@batman.local.home>
In-Reply-To: <80e637d3-482d-4f3a-9a86-948d3837b24d@kernel.dk>
References: <20250623115914.12076-1-jqqlijiazi@gmail.com>
	<20250624130744.602c5b5f@batman.local.home>
	<80e637d3-482d-4f3a-9a86-948d3837b24d@kernel.dk>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xafjfh53pddn6wo38thmi4gzzca9ar6z
X-Rspamd-Server: rspamout07
X-Rspamd-Queue-Id: 3336330
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19g5aGSHAsoIS2cMM7hYXD74NMSHkUDja0=
X-HE-Tag: 1750884665-748652
X-HE-Meta: U2FsdGVkX1+p6Z0Hf1vmldNDykjSGqq1TUpuT+GHffjCeaqkm+Z1cXBA1mJi+7f0ug/eEAi5nD0Cw/W7UOJIbT/ImATJTQyr2+Wj8SobUljq79GHHPZoncZb0yggqmfa5B8nhEuqWz/8r+ld/dxZ5llBhp1JLnPzvTschpYAa5ajPHnsaarixYNaFRBUUQ+IpMT5p2wT8FZWT7ezHFDkzFPi8ycsjznCZs2NX8RyMqt5d5H5wGeyh33P3AAq5XL1uwauTaJjhvTUwT/r+t833TYUVj/QwLBxMesgJWdnSO7t1mJHJv2F776WZPgCovnMTUiNg+3aDnxWCzm++Q+TXr3wABA8r25b5KslGOypoUkLzzZTZNOZ7e48arvS4peXxmwV/xLl/d9hdVQ1ErOnMJ9AbaipoJ3HfbMXlgEwOoU=

[
  Adding Peter Zijlstra as he has been telling me to test against
  PF_KTHREAD instead of current->mm to tell if it is a kernel thread.
  But that seems to not be enough!
]

On Wed, 25 Jun 2025 10:23:28 -0600
Jens Axboe <axboe@kernel.dk> wrote:

> On 6/24/25 11:07 AM, Steven Rostedt wrote:
> > On Mon, 23 Jun 2025 19:59:11 +0800
> > Jiazi Li <jqqlijiazi@gmail.com> wrote:
> >   
> >> Tasks with PF_USER_WORKER flag also only run in kernel space,
> >> so do not trace user stack for these tasks.  
> > 
> > What exactly is the difference between PF_KTHREAD and PF_USER_WORKER?  
> 
> One is a kernel thread (eg no mm, etc), the other is basically a user
> thread. None of them exit to userspace, that's basically the only
> thing they have in common.

Was it ever in user space? Because exiting isn't the issue for getting
a user space stack. If it never was in user space than sure, there's no
reason to look at the user space stack.

> 
> > Has all the locations that test for PF_KTHREAD been audited to make
> > sure that PF_USER_WORKER isn't also needed?  
> 
> I did when adding it, to the best of my knowledge. But there certainly
> could still be gaps. Sometimes not easy to see why code checks for
> PF_KTHREAD in the first place.
> 
> > I'm working on other code that needs to differentiate between user
> > tasks and kernel tasks, and having to have multiple flags to test is
> > becoming quite a burden.  
> 
> None of them are user tasks, but PF_USER_WORKER does look like a
> user thread and acts like one, except it wasn't created by eg
> pthread_create() and it never returns to userspace. When it's done,
> it's simply reaped.
> 

I'm assuming that it also never was in user space, which is where we
don't want to do any user space stack trace.

This looks like more rationale for having a kernel_task() user_task()
helper functions:

  https://lore.kernel.org/linux-trace-kernel/20250425204120.639530125@goodmis.org/

Where one returns true for both PF_KERNEL and PF_USER_WORKER and the
other returns false.

-- Steve

