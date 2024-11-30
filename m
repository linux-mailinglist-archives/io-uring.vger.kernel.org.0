Return-Path: <io-uring+bounces-5159-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F1DA19DF346
	for <lists+io-uring@lfdr.de>; Sat, 30 Nov 2024 22:05:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1F498B20E39
	for <lists+io-uring@lfdr.de>; Sat, 30 Nov 2024 21:05:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37FCA1AA1D3;
	Sat, 30 Nov 2024 21:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XplM/77y"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0183C535DC;
	Sat, 30 Nov 2024 21:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733000723; cv=none; b=KZKVj0By9MajguV/c62jRcRTYL+48Jj1yp/BtGc1wdM9ZeaOw4Y5fSJ1z18X73JETiqevVTLL9cq1rB9I0ee2yppQ/iOZpZaa2eJiycOEdjj2a+Kf+1pH+kfdW6KAQ2PnixOpz5WBG/49DU7cgo5NGhjw/1YI22sQhvVN4YA0Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733000723; c=relaxed/simple;
	bh=+T8n7bvP/HSW8AefSu6V2BUZeXCElB+vKKwnKLP6Cw0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a7XRdcO7CCdFMH9ffaUOEheQOORLTGjKHK1reHGQQHHKrNkMUcQevT2Lm9ZnT55CN4ZsLcV4uOp1RvVZ9IbEuiJCstcXed6bSf+gjBWxJJHyhdLKCM9+zlUziZ4udNrHIbUKWS2kpr0HjG1ht4dRnwJcH/CxRlSZyTqMig8kPek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XplM/77y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D685C4CECC;
	Sat, 30 Nov 2024 21:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733000722;
	bh=+T8n7bvP/HSW8AefSu6V2BUZeXCElB+vKKwnKLP6Cw0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XplM/77yzRsY9Ul5Am4/Jwt/PYl8JmH6EQ0wAJgk6PnNXv19zdEsOrrCXqBV5vK96
	 qBng8VIUTIVUOmM4l1e2WWWABx38GhF/3UMfUlX0RXA3s8EODIDg2gJTvOsfpVYFQN
	 D1ccZf8sjL5Xuc1nZ4q/I28ZyB0ZtabCku9rjhcGMWmJCxs4dQigzAZMz3dHW5hQpJ
	 /lPc66WwkVgYxFIh5gSfkbQKtXgFfHPaoi9EcwgGBOWoY2QClLB3CXAOffZWU4IbCk
	 WVpLengyHosmhp/1ps3/Ap8Go54v+hpOOVH3bzN8oArTmgeIABnS8wAyCXaPPeih16
	 GEibrkTK8QWjQ==
Date: Sat, 30 Nov 2024 13:05:18 -0800
From: Kees Cook <kees@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Biederman <ebiederm@xmission.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chen Yu <yu.c.chen@intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH] exec: Make sure task->comm is always NUL-terminated
Message-ID: <202411301244.381F2B8D17@keescook>
References: <20241130044909.work.541-kees@kernel.org>
 <CAHk-=wjAmu9OBS--RwB+HQn4nhUku=7ECOnSRP8JG0oRU97-kA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjAmu9OBS--RwB+HQn4nhUku=7ECOnSRP8JG0oRU97-kA@mail.gmail.com>

On Fri, Nov 29, 2024 at 11:15:44PM -0800, Linus Torvalds wrote:
> Edited down to just the end result:
> 
> On Fri, 29 Nov 2024 at 20:49, Kees Cook <kees@kernel.org> wrote:
> >
> >  void __set_task_comm(struct task_struct *tsk, const char *buf, bool exec)
> >  {
> >         size_t len = min(strlen(buf), sizeof(tsk->comm) - 1);
> >
> >         trace_task_rename(tsk, buf);
> >         memcpy(tsk->comm, buf, len);
> >         memset(&tsk->comm[len], 0, sizeof(tsk->comm) - len);
> >         perf_event_comm(tsk, exec);
> >  }
> 
> I actually don't think that's super-safe either. Yeah, it works in
> practice, and the last byte is certainly always going to be 0, but it
> might not be reliably padded.

Right, my concern over comm is strictly about unterminated reads (i.e.
exposing memory contents stored after "comm" in the task_struct). I've not
been worried about "uninitialized content" exposure because the starting
contents have always been wiped and will (now) always end with a NUL,
so the worst exposure is seeing prior or racing bytes of whatever is
being written into comm concurrently.

> Why? It walks over the source twice. First at strlen() time, then at
> memcpy. So if the source isn't stable, the end result might have odd
> results with NUL characters in the middle.

Yeah, this just means it has greater potential to be garbled.

> And strscpy() really was *supposed* to be safe even in this case, and
> I thought it was until I looked closer.
> 
> But I think strscpy() can be saved.

Yeah, fixing the final NUL byte write is needed.

> Something (UNTESTED!) like the attached I think does the right thing.
> I added a couple of "READ_ONCE()" things to make it really super-clear
> that strscpy() reads the source exactly once, and to not allow any
> compiler re-materialization of the reads (although I think that when I
> asked people, it turns out neither gcc nor clang rematerialize memory
> accesses, so that READ_ONCE is likely more a documentation ad
> theoretical thing than a real thing).

This is fine, but it doesn't solve either an unstable source nor
concurrent writers to dest. If source changes out from under strscpy,
we can still copy a "torn" write. If destination changes out from under
strscpy, we just get a potentially interleaved output (but with the
NUL-write change, we never have a dest that _lacks_ a NUL terminator).

So yeah, let's change the loop as you have it. I'm fine with the
READ_ONCE() additions, but I'm not clear on what benefit it has.

> Hmm? I don't think your version is wrong, but I also think we'd be
> better off making our 'strscpy()' infrastructure explicitly safe wrt
> unstable source strings.

Agreed. I'll get this tested against our string handling selftests...

-- 
Kees Cook

