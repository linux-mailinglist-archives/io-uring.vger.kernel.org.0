Return-Path: <io-uring+bounces-13829-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id /7tABHnYO2pneAgAu9opvQ
	(envelope-from <io-uring+bounces-13829-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 24 Jun 2026 15:15:37 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BA20A6BE7D5
	for <lists+io-uring@lfdr.de>; Wed, 24 Jun 2026 15:15:36 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Kz4Q9rbh;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13829-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13829-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=linux.dev;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4FA2B3021D37
	for <lists+io-uring@lfdr.de>; Wed, 24 Jun 2026 13:15:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DF113B42E8;
	Wed, 24 Jun 2026 13:15:28 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D440A3B0AD1
	for <io-uring@vger.kernel.org>; Wed, 24 Jun 2026 13:15:26 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782306928; cv=none; b=ffArJjy5MG39/QI7EWJ+munnaG4KbWSt9KnjKbvSEfNB8vTJnGzO5Wysl6L3zSwRVQUQ9xDRwSACmT7uJof14IPO60I6qC9dZgTXdkqNPrBcA9N6jrjL7gz+fmjMzXih+ykjO6u1fgulW4etuXL37Vil47W6zEAbocYexFy6kl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782306928; c=relaxed/simple;
	bh=moyOQIzaR6smZ9rBrd3W/NuwPZRv54jsj9HwphWn/HQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KLd6GtpauGCNhDeGTku3OcQHwYSl5+vuhjC2jBpYHgdsrWZm9chvxNxEYC10tHv3xqi7ezyglgVjCVmsmpJL56czye2JeC0fl3GZzaqLZTbjEJtCqol0jj+sx0gU7fHvLJm9Qn94XgvNr2d5zsfsAWfEtJ+Q7vPg1DoEoOAQ240=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Kz4Q9rbh; arc=none smtp.client-ip=91.218.175.170
Message-ID: <351a6b67-b394-4c58-aee2-88b6c8089ad5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782306914;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jm5h4EGMu1/G65UxgDlhva2Uqze8a2QIkXsB3xVvPew=;
	b=Kz4Q9rbh7etgj8euhlBLWO3TzYATCTCfu6njur0dxfGVJdMqB9UP/InGWtI0bOGTstOlHl
	POIMRyO3mRJBT5/BeQDQV44BuugXQiS1AZGuvJ0EWei9+7fme1gtEeTZSwt1IwIDM7n5ZK
	H6199we71vGASxf1nAZQvllBRzYOKVU=
Date: Wed, 24 Jun 2026 21:14:50 +0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3 1/7] list: Add mutable iterator variants
To: David Laight <david.laight.linux@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Tejun Heo <tj@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Paul Moore <paul@paul-moore.com>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 David Howells <dhowells@redhat.com>, Simona Vetter <simona.vetter@ffwll.ch>,
 Randy Dunlap <rdunlap@infradead.org>,
 Luca Ceresoli <luca.ceresoli@bootlin.com>,
 Philipp Stanner <phasta@kernel.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 linux-ntfs-dev@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, audit@vger.kernel.org, bpf@vger.kernel.org,
 netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 kexec@lists.infradead.org, live-patching@vger.kernel.org,
 linux-modules@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-pm@vger.kernel.org, rcu@vger.kernel.org, sched-ext@lists.linux.dev,
 linux-mm@kvack.org, virtualization@lists.linux.dev, damon@lists.linux.dev,
 llvm@lists.linux.dev, Kaitao Cheng <chengkaitao@kylinos.cn>
References: <20260622040533.29824-1-kaitao.cheng@linux.dev>
 <20260622040533.29824-2-kaitao.cheng@linux.dev>
 <20260622094242.64531b9a@pumpkin>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kaitao Cheng <kaitao.cheng@linux.dev>
In-Reply-To: <20260622094242.64531b9a@pumpkin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13829-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:david.laight.linux@gmail.com,m:akpm@linux-foundation.org,m:david@kernel.org,m:axboe@kernel.dk,m:tj@kernel.org,m:viro@zeniv.linux.org.uk,m:brauner@kernel.org,m:ast@kernel.org,m:daniel@iogearbox.net,m:andrii@kernel.org,m:hannes@cmpxchg.org,m:peterz@infradead.org,m:mingo@redhat.com,m:acme@kernel.org,m:namhyung@kernel.org,m:tglx@kernel.org,m:juri.lelli@redhat.com,m:vincent.guittot@linaro.org,m:paul@paul-moore.com,m:andriy.shevchenko@linux.intel.com,m:paulmck@kernel.org,m:shakeel.butt@linux.dev,m:christian.koenig@amd.com,m:dhowells@redhat.com,m:simona.vetter@ffwll.ch,m:rdunlap@infradead.org,m:luca.ceresoli@bootlin.com,m:phasta@kernel.org,m:linux-block@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:cgroups@vger.kernel.org,m:linux-ntfs-dev@lists.sourceforge.net,m:linux-fsdevel@vger.kernel.org,m:io-uring@vger.kernel.org,m:audit@vger.kernel.org,m:bpf@vger.kernel.org,m:netdev@vger.kernel.org,m:dri-devel@lists.freedesktop.org,m:linux-perf-users@vger.kernel.org,m:lin
 ux-trace-kernel@vger.kernel.org,m:kexec@lists.infradead.org,m:live-patching@vger.kernel.org,m:linux-modules@vger.kernel.org,m:linux-crypto@vger.kernel.org,m:linux-pm@vger.kernel.org,m:rcu@vger.kernel.org,m:sched-ext@lists.linux.dev,m:linux-mm@kvack.org,m:virtualization@lists.linux.dev,m:damon@lists.linux.dev,m:llvm@lists.linux.dev,m:chengkaitao@kylinos.cn,m:davidlaightlinux@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[kaitao.cheng@linux.dev,io-uring@vger.kernel.org];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCPT_COUNT_GT_50(0.00)[52];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kaitao.cheng@linux.dev,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:dkim,linux.dev:email,linux.dev:mid,linux.dev:from_mime,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,kylinos.cn:email,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: BA20A6BE7D5



在 2026/6/22 16:42, David Laight 写道:
> On Mon, 22 Jun 2026 12:05:31 +0800
> Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
> 
>> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>>
>> The list_for_each*_safe() helpers are used when the loop body may
>> remove the current entry.  Their API exposes the temporary cursor at
>> every call site, even though most users only need it for the iterator
>> implementation and never reference it in the loop body.
>>
>> Add *_mutable() variants for list and hlist iteration.  The new helpers
>> support both forms: callers may keep passing an explicit temporary cursor
>> when they need to inspect or reset it, or omit it and let the helper use
>> a unique internal cursor.
> 
> I'm not really sure 'mutable' means anything either.
> It is possible to make it valid for the loop body (or even other threads)
> to delete arbitrary list items - but that needs significant extra overheads.
> 
> It might be worth doing something that doesn't need the extra variable,
> but there is little point doing all the churn just to rename things.
> 
>>
>> This makes call sites that only mutate the list through the current entry
>> less noisy, while keeping the existing *_safe() helpers available for
>> compatibility.
>>
>> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
>> ---
>>  include/linux/list.h | 269 +++++++++++++++++++++++++++++++++++++------
>>  1 file changed, 231 insertions(+), 38 deletions(-)
>>
>> diff --git a/include/linux/list.h b/include/linux/list.h
>> index 09d979976b3b..1081def7cea9 100644
>> --- a/include/linux/list.h
>> +++ b/include/linux/list.h
>> @@ -7,6 +7,7 @@
>>  #include <linux/stddef.h>
>>  #include <linux/poison.h>
>>  #include <linux/const.h>
>> +#include <linux/args.h>
>>  
>>  #include <asm/barrier.h>
>>  
>> @@ -763,28 +764,72 @@ static inline void list_splice_tail_init(struct list_head *list,
>>  #define list_for_each_prev(pos, head) \
>>  	for (pos = (head)->prev; !list_is_head(pos, (head)); pos = pos->prev)
>>  
>> -/**
>> - * list_for_each_safe - iterate over a list safe against removal of list entry
>> - * @pos:	the &struct list_head to use as a loop cursor.
>> - * @n:		another &struct list_head to use as temporary storage
>> - * @head:	the head for your list.
>> +/*
>> + * list_for_each_safe is an old interface, use list_for_each_mutable instead.
>>   */
>>  #define list_for_each_safe(pos, n, head) \
>>  	for (pos = (head)->next, n = pos->next; \
>>  	     !list_is_head(pos, (head)); \
>>  	     pos = n, n = pos->next)
>>  
>> +#define __list_for_each_mutable_internal(pos, tmp, head)		\
>> +	for (typeof(pos) tmp = (pos = (head)->next)->next;		\
> 
> Use auto
> 
>> +	     !list_is_head(pos, (head));				\
>> +	     pos = tmp, tmp = pos->next)
>> +
>> +#define __list_for_each_mutable1(pos, head)				\
>> +	__list_for_each_mutable_internal(pos, __UNIQUE_ID(next), head)
>> +
>> +#define __list_for_each_mutable2(pos, next, head)			\
>> +	list_for_each_safe(pos, next, head)
>> +
>>  /**
>> - * list_for_each_prev_safe - iterate over a list backwards safe against removal of list entry
>> + * list_for_each_mutable - iterate over a list safe against entry removal
>>   * @pos:	the &struct list_head to use as a loop cursor.
>> - * @n:		another &struct list_head to use as temporary storage
>> - * @head:	the head for your list.
>> + * @...:	either (head) or (next, head)
>> + *
>> + * next:	another &struct list_head to use as optional temporary storage.
>> + *		The temporary cursor is internal unless explicitly supplied by
>> + *		the caller.
>> + * head:	the head for your list.
>> + */
>> +#define list_for_each_mutable(pos, ...)					\
>> +	CONCATENATE(__list_for_each_mutable, COUNT_ARGS(__VA_ARGS__))	\
>> +		(pos, __VA_ARGS__)
> 
> The variable argument count logic really just slows down compilation.
> Maybe there aren't enough copies of this code to make that significant.
> But just because you can do it doesn't mean it is a gooD idea.
> I'm also not sure it really adds anything to the readability.
> 
> And, it you are going to make the middle argument optional there is
> no need to change the macro name.

Christian König and Jani Nikula also disagree with the variadic-argument
implementation approach. If we abandon that method, it means we will
inevitably need to add some new macros. If mutable is not a good name,
suggestions for better alternatives would be welcome; coming up with a
suitable name is indeed rather tricky.

-- 
Thanks
Kaitao Cheng


