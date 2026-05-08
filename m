Return-Path: <io-uring+bounces-13257-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SBRIAT1B/mnFoQAAu9opvQ
	(envelope-from <io-uring+bounces-13257-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 08 May 2026 22:02:05 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 726374FB514
	for <lists+io-uring@lfdr.de>; Fri, 08 May 2026 22:02:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9A7EB302B764
	for <lists+io-uring@lfdr.de>; Fri,  8 May 2026 20:02:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00C0E346FB3;
	Fri,  8 May 2026 20:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="0z7DLcol";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="KK9pL1WA"
X-Original-To: io-uring@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A110E3101C0;
	Fri,  8 May 2026 20:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778270521; cv=none; b=tanWnb1DeT3a694C9HPtGbd/iTuJKEf1QMC5lnp9qpOKh1sOK9ZUUViMV+/pmDPqKtqtPAbt56IaHEMR6tlDipdomAra/dGAVl2YyAdD1rAawRgeLm11rveZ4Nwby+izM7Fb0De7ajlyYjbX0lW1JEFUP/Wchqyp1jDC1OXtZhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778270521; c=relaxed/simple;
	bh=BykR7qv2rJEBW+1ipmJDVOTBlBjhiNJn/jDK5p509o8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GA47GA9wKyDf3MQYJMu0Y0sT8f3+yU/fUjRyOPM21018rWiN5OULzKSjKUpptKrpAT5uU8HEzj94CybsrneqGiHm0T+dm7gnjhB9zPn778Tn5KojwSsB+zSwzRD8ExGEgkYxdrdZlB112rDKFMgAxxueUgnOHm0qoLkdDEC9EDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=0z7DLcol; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=KK9pL1WA; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Date: Fri, 8 May 2026 22:01:57 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1778270518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rNkBez2kj8pSOTKjwGur83xGxf1QOwrtzGM5jsyyCyY=;
	b=0z7DLcolD0ydZmCUUSzu3QMQAfzt0afZMtq9sx8vQ5VIN6MBlSM7iGVZ1bXlO/zMHrjxPg
	10UNKhg0yMrmGTpOHel29StuJ2+8QdTf3QWFO1qIB6Qg+R+3cCKWoqeWbTULqKkaF0LeYC
	icT/oKlTEEZyJrpvxnQW8gUeO//pM60ACwmBVPmUsXCRWmhOMPDrffkIhxgkyLfsQqeuSr
	twpAsvZRf7GYBcqOSUimhbrBcrY7g2xORwFU7SWCy41Sr4GtDfplhNnMokymTCH/7THGRP
	rKxT3M+2P7eHzSAPkhT9ytKXHE7Hti66YKewFwcnurwYmwTdETLHCLOjoYo3Fg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1778270518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rNkBez2kj8pSOTKjwGur83xGxf1QOwrtzGM5jsyyCyY=;
	b=KK9pL1WAMVbPb+jWFa4Ki+oBttXdOUAELLnCO1Jim7hOGb6cCxxPcLS5IhQa2lx8edT4Oe
	abhcvmLNtSBpKPDA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Alice Ryhl <aliceryhl@google.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>,
	Andrea Righi <arighi@nvidia.com>, Boqun Feng <boqun@kernel.org>,
	Changwoo Min <changwoo@igalia.com>,
	Clark Williams <clrkwllms@kernel.org>,
	David Vernet <void@manifault.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
	io-uring@vger.kernel.org, rcu@vger.kernel.org,
	sched-ext@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH] sched/task: always defer 'struct task_struct'
 destruction via RCU
Message-ID: <20260508200157.kWPZI3p3@linutronix.de>
References: <20260508-put-task-struct-many-v1-1-8341c18141a6@google.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260508-put-task-struct-many-v1-1-8341c18141a6@google.com>
X-Rspamd-Queue-Id: 726374FB514
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linutronix.de,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[linutronix.de:s=2020,linutronix.de:s=2020e];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13257-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,nvidia.com,igalia.com,manifault.com,redhat.com,kernel.dk,joshtriplett.org,gmail.com,efficios.com,infradead.org,goodmis.org,linux.dev,vger.kernel.org,lists.linux.dev];
	RCPT_COUNT_TWELVE(0.00)[25];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bigeasy@linutronix.de,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[linutronix.de:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linutronix.de:mid,linutronix.de:dkim]
X-Rspamd-Action: no action

On 2026-05-08 14:02:45 [+0000], Alice Ryhl wrote:
> The sched/task.h header file currently exposes a tryget_task_struct()
> function, but it is very risky to use it: If the last refcount of the
> task is dropped using put_task_struct_many(), then the task is freed
> right away without an RCU grace period.
> 
> This means that if the kernel contains a code path anywhere such that
> the last refcount of a task may be dropped with put_task_struct_many(),
> and it also contains a code path anywhere that tries to stash a task
> pointer under rcu and use tryget_task_struct() on it, then if they ever
> execute on the same 'struct task_struct', it results in a
> use-after-free.

If the counter dropped to 0 then tryget_task_struct() won't increment
it. There is also task_struct::rcu_users which holds one `usage' on it
and this RCU grace period we care about.

The only reason why there is a RCU free here is because of RT and it was
limited to RT only. Then a PI case came up (on RT again) I asked
repeatedly to have it unconditional on RT and !RT. Which then did
happen.

I don't think I would mind to align the two code paths but not as a
"this might be UAF if" but to do the same "thing". The important RCU
grace period happens via put_task_struct_rcu_user().

Sebastian

