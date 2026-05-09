Return-Path: <io-uring+bounces-13260-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gM10AQPg/mlxyAAAu9opvQ
	(envelope-from <io-uring+bounces-13260-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 09 May 2026 09:19:31 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B57E24FE6EC
	for <lists+io-uring@lfdr.de>; Sat, 09 May 2026 09:19:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F17A53047BEA
	for <lists+io-uring@lfdr.de>; Sat,  9 May 2026 07:18:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B2483845B7;
	Sat,  9 May 2026 07:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GCyvfSuo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF21382F3C
	for <io-uring@vger.kernel.org>; Sat,  9 May 2026 07:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778311120; cv=none; b=pUjPbQkxvyzL7kanvM2KKQQbHrNwiuun09H8wG+jOqg7oVEuBjRKzRbB3CbkGpP7I68sIkB4AxD8zvarstpxs6uB6h8myow9BBiKo0ANtrr+UpOHDytWYfeTqMhTFOpZWSqtRq1fsHGdFSVcv5hTFnNfCmK6qu0Z68H9wcQM4JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778311120; c=relaxed/simple;
	bh=o7CPCGXOj2haokXsQESfPJhyteLvwzZMKjC6vcdU+L8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gK31qQqhgkdbDSFGvpJTEovKFmDWnPKgrcT+SCqBQYDsU8Ijhk4gETBk0A8YGOsH/OGbWNuu7mGzqoVNR5k3I4K5aklBOrX1Z7BgP/crAqXLR+SeHENmBS1Y7ydJ7zWYicqlBp1aFb6JQg6QxAuYfo8VNcyIRLZOS+Up/BgAMl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GCyvfSuo; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b8704795d25so235924366b.2
        for <io-uring@vger.kernel.org>; Sat, 09 May 2026 00:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778311116; x=1778915916; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nWPmLPcUZniG40mmE6xEF7MYszlEp9VqvWN3AMo3/Bg=;
        b=GCyvfSuo4/3OaRHRdPDYOrTZrnoTyqXh/lmV/5Nm1yUUkrNXhdufSMQ8iZOymcsSFD
         o0oPD70vDF9Fp5BY+7lRZT5SAZ9vUdzc2BcfbmVvpchqCWBRira5muMRm6+pv8MJIdEC
         rFUv6L0StKnzXr2nikkzYTtB3hkyz2u2J8lWvhwMLbijbhk+32p9AAIwAkI7CPlrXdXv
         26XWvsFgFuFEcV7NB87sSwHg5+i9dUQcRv4F6cwzYPaxYodKCYEMyms8PjsChXBFOON9
         m569oPvlOv7DWFutmcD1XePZ9kTQew93eO4cr97mBpowAf1RhQsxWo6kQMXtJi56PQPF
         22AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778311116; x=1778915916;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nWPmLPcUZniG40mmE6xEF7MYszlEp9VqvWN3AMo3/Bg=;
        b=APUZUvoSx/GIoyJBKcKggLj/cfqWcjhvo+RXc7aPGfv9nfnPpVPhgeRnkavweAw9uW
         b5Kys2uAy0diNv+Pe9ETx/9XVinXE6+jLXo60qN4KZM+HKfvXEjhmRGDS71LiVZsBQac
         /Wq+1wGO4gB/eMDUy/hxa06aVRXiHASmpTIlhzNnuNHpR6wVkXp3WN95CFOzDjXws1v8
         6OzUXMq4ydLM7u9duGvpfcVzVMhPzZYqhE+1w/n7XzVs4zCy1GpSnX8ak929PyoWf/zF
         sBXThrZjMCx8hrhVLHcvGHp9SFuQ9xg2ae54I0ZmEmqQIE1TtduQjibMMk4VmvjQb4L7
         KUdg==
X-Forwarded-Encrypted: i=1; AFNElJ+iB9MkR6g14ojXFj9+/2JpC76WXczPlYanIYJ0pOq7BoC0WrDd+fglOyT0KctUCkn41yfgX/uW9Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YyA+DANQhcOFmkU47dtNp0uYHFdiC3X1TRybxCO2BSfMx7n7FPy
	wkrJ3thQ4L6tmB77ImbZXjasNNzKvgpwmUE/PXN1B5anPrWxYLRGwmtd/O0RvJlBPeqVSzNv7F5
	jZW9bvKfxj92o7O/tEw==
X-Received: from ejcbu12.prod.google.com ([2002:a17:907:930c:b0:bca:912a:8b1])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:3e93:b0:ba3:a8ef:3597 with SMTP id a640c23a62f3a-bc56c72d655mr930748266b.25.1778311115972;
 Sat, 09 May 2026 00:18:35 -0700 (PDT)
Date: Sat, 9 May 2026 07:18:34 +0000
In-Reply-To: <20260508200157.kWPZI3p3@linutronix.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260508-put-task-struct-many-v1-1-8341c18141a6@google.com> <20260508200157.kWPZI3p3@linutronix.de>
Message-ID: <af7fym1VhjYMw_h4@google.com>
Subject: Re: [PATCH] sched/task: always defer 'struct task_struct' destruction
 via RCU
From: Alice Ryhl <aliceryhl@google.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: "Paul E. McKenney" <paulmck@kernel.org>, Andrea Righi <arighi@nvidia.com>, Boqun Feng <boqun@kernel.org>, 
	Changwoo Min <changwoo@igalia.com>, Clark Williams <clrkwllms@kernel.org>, 
	David Vernet <void@manifault.com>, Frederic Weisbecker <frederic@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Jens Axboe <axboe@kernel.dk>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Josh Triplett <josh@joshtriplett.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Zqiang <qiang.zhang@linux.dev>, io-uring@vger.kernel.org, rcu@vger.kernel.org, 
	sched-ext@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: B57E24FE6EC
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13260-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,nvidia.com,igalia.com,manifault.com,redhat.com,kernel.dk,joshtriplett.org,gmail.com,efficios.com,infradead.org,goodmis.org,linux.dev,vger.kernel.org,lists.linux.dev];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[25];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[aliceryhl@google.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Action: no action

On Fri, May 08, 2026 at 10:01:57PM +0200, Sebastian Andrzej Siewior wrote:
> On 2026-05-08 14:02:45 [+0000], Alice Ryhl wrote:
> > The sched/task.h header file currently exposes a tryget_task_struct()
> > function, but it is very risky to use it: If the last refcount of the
> > task is dropped using put_task_struct_many(), then the task is freed
> > right away without an RCU grace period.
> > 
> > This means that if the kernel contains a code path anywhere such that
> > the last refcount of a task may be dropped with put_task_struct_many(),
> > and it also contains a code path anywhere that tries to stash a task
> > pointer under rcu and use tryget_task_struct() on it, then if they ever
> > execute on the same 'struct task_struct', it results in a
> > use-after-free.
> 
> If the counter dropped to 0 then tryget_task_struct() won't increment
> it.

Yes. If the 'struct task_struct' hasn't been freed yet. What is the
scenario where it might be zero, but you are certain it is not yet
freed? If not rcu, then I guess this applies only to those cases where
__put_task_struct() itself removes the task from the relevant collection
when 'users' hits zero.

If tryget_task_struct() can only safely be used in that scenario, then I
think that's worth at least a comment in the header file, because at
first glance it's a surprising limitation.

> There is also task_struct::rcu_users which holds one `usage' on it
> and this RCU grace period we care about.

Sure, but I guess my question is: why does tryget_task_struct() exist?
The 'rcu_users' field is not the reason because 'usage' can't be zero
when using that field.

Alice

> The only reason why there is a RCU free here is because of RT and it was
> limited to RT only. Then a PI case came up (on RT again) I asked
> repeatedly to have it unconditional on RT and !RT. Which then did
> happen.
> 
> I don't think I would mind to align the two code paths but not as a
> "this might be UAF if" but to do the same "thing". The important RCU
> grace period happens via put_task_struct_rcu_user().
> 
> Sebastian

