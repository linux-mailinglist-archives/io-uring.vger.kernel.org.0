Return-Path: <io-uring+bounces-13833-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id PsA9Am6aPGoFpwgAu9opvQ
	(envelope-from <io-uring+bounces-13833-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 25 Jun 2026 05:03:10 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id EE5906C2841
	for <lists+io-uring@lfdr.de>; Thu, 25 Jun 2026 05:03:08 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f3XfhSe6;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13833-lists+io-uring=lfdr.de@vger.kernel.org" designates 104.64.211.4 as permitted sender) smtp.mailfrom="io-uring+bounces-13833-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=linux.dev;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2C73B30113BD
	for <lists+io-uring@lfdr.de>; Thu, 25 Jun 2026 03:02:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0C1F3AE1B4;
	Thu, 25 Jun 2026 03:02:36 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A5531F9BC
	for <io-uring@vger.kernel.org>; Thu, 25 Jun 2026 03:02:28 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782356556; cv=none; b=HSRbGoBOVHdA0ovkH1TcsQwS/sdWQSt+3pFk7Lxgicujyr6jtbkLOsvgN70z8/eEno/zPiKl+z8O6SVrJg1rpsf2c/gWzdXjF84Ltbvu+7uDrtCKdkW9D6grrhqLUoZq9t9TKMhaWxTHroDBdycYSzEjWglT4t4xz9+Y2hGi9mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782356556; c=relaxed/simple;
	bh=AJ5z7v+xj1bwU2aG0Bcmfo35foG9ftC+wsjfKkRv/5U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NP79f8ZmsAokTnuhRcGfeAC7c24JUr56Wo9HOG4D+3RUaifa1bDYi6XJXlbERCi0/jlgNquXm9XBTBd0Se8X4fSTgt+4QN29PrQONBjVjZ2oURTC21rH1spXiNQT2QmZUOQFrTpMBHDSBUUbQ+/zOCsZ83URj23ZgQtH1JeYKrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=f3XfhSe6; arc=none smtp.client-ip=91.218.175.173
Message-ID: <0ed6b5c3-e955-46e2-9fc6-075a0dfd1c4f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782356535;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bg7TU7hDzDNv/08FHHH/On04xmb+0Xhy9JCW39bnqOs=;
	b=f3XfhSe6G7brFNVp6GZqjOXNU3vcFca4poUFfkwgVZymI1EYtq9zeoyJzoopay7HWx5JvC
	E0YJXxuEv9p9ioc24zHIhHD7MfpA8W6eQqa3vo59Vdd3bvTmswHZxeWqPUReOxJ21Oxizv
	nnsvKa6R3D4a+gLxizvgKiVabRJ3kcE=
Date: Thu, 25 Jun 2026 11:01:21 +0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3 1/7] list: Add mutable iterator variants
To: David Laight <david.laight.linux@gmail.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 Alexei Starovoitov <ast@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Tejun Heo <tj@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Paul Moore <paul@paul-moore.com>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, David Howells <dhowells@redhat.com>,
 Simona Vetter <simona.vetter@ffwll.ch>, Randy Dunlap
 <rdunlap@infradead.org>, Luca Ceresoli <luca.ceresoli@bootlin.com>,
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
 llvm@lists.linux.dev, Kaitao Cheng <chengkaitao@kylinos.cn>,
 Muchun Song <muchun.song@linux.dev>
References: <20260622040533.29824-1-kaitao.cheng@linux.dev>
 <20260622040533.29824-2-kaitao.cheng@linux.dev>
 <20260622094242.64531b9a@pumpkin>
 <351a6b67-b394-4c58-aee2-88b6c8089ad5@linux.dev>
 <cf8467c7-b98f-44a5-9cf9-60b43b5da711@amd.com>
 <20260624152324.3def88ce@pumpkin>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kaitao Cheng <kaitao.cheng@linux.dev>
In-Reply-To: <20260624152324.3def88ce@pumpkin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13833-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:david.laight.linux@gmail.com,m:christian.koenig@amd.com,m:jani.nikula@linux.intel.com,m:david@kernel.org,m:ast@kernel.org,m:akpm@linux-foundation.org,m:axboe@kernel.dk,m:tj@kernel.org,m:viro@zeniv.linux.org.uk,m:brauner@kernel.org,m:daniel@iogearbox.net,m:andrii@kernel.org,m:hannes@cmpxchg.org,m:peterz@infradead.org,m:mingo@redhat.com,m:acme@kernel.org,m:namhyung@kernel.org,m:tglx@kernel.org,m:juri.lelli@redhat.com,m:vincent.guittot@linaro.org,m:paul@paul-moore.com,m:andriy.shevchenko@linux.intel.com,m:paulmck@kernel.org,m:shakeel.butt@linux.dev,m:dhowells@redhat.com,m:simona.vetter@ffwll.ch,m:rdunlap@infradead.org,m:luca.ceresoli@bootlin.com,m:phasta@kernel.org,m:linux-block@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:cgroups@vger.kernel.org,m:linux-ntfs-dev@lists.sourceforge.net,m:linux-fsdevel@vger.kernel.org,m:io-uring@vger.kernel.org,m:audit@vger.kernel.org,m:bpf@vger.kernel.org,m:netdev@vger.kernel.org,m:dri-devel@lists.freedesktop.org,m:linux-pe
 rf-users@vger.kernel.org,m:linux-trace-kernel@vger.kernel.org,m:kexec@lists.infradead.org,m:live-patching@vger.kernel.org,m:linux-modules@vger.kernel.org,m:linux-crypto@vger.kernel.org,m:linux-pm@vger.kernel.org,m:rcu@vger.kernel.org,m:sched-ext@lists.linux.dev,m:linux-mm@kvack.org,m:virtualization@lists.linux.dev,m:damon@lists.linux.dev,m:llvm@lists.linux.dev,m:chengkaitao@kylinos.cn,m:muchun.song@linux.dev,m:davidlaightlinux@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[kaitao.cheng@linux.dev,io-uring@vger.kernel.org];
	FREEMAIL_TO(0.00)[gmail.com,amd.com,linux.intel.com,kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCPT_COUNT_GT_50(0.00)[55];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kaitao.cheng@linux.dev,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email,vger.kernel.org:from_smtp,linux.dev:dkim,linux.dev:email,linux.dev:mid,linux.dev:from_mime,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,kylinos.cn:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: EE5906C2841

在 2026/6/24 22:23, David Laight 写道:
> On Wed, 24 Jun 2026 15:23:47 +0200
> Christian König <christian.koenig@amd.com> wrote:
>> On 6/24/26 15:14, Kaitao Cheng wrote:
>>> 在 2026/6/22 16:42, David Laight 写道:  
>>>> On Mon, 22 Jun 2026 12:05:31 +0800
>>>> Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
>>>>  
>>>>> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>>>>>
>>>>> The list_for_each*_safe() helpers are used when the loop body may
>>>>> remove the current entry.  Their API exposes the temporary cursor at
>>>>> every call site, even though most users only need it for the iterator
>>>>> implementation and never reference it in the loop body.
>>>>>
>>>>> Add *_mutable() variants for list and hlist iteration.  The new helpers
>>>>> support both forms: callers may keep passing an explicit temporary cursor
>>>>> when they need to inspect or reset it, or omit it and let the helper use
>>>>> a unique internal cursor.  
>>>>
>>>> I'm not really sure 'mutable' means anything either.
>>>> It is possible to make it valid for the loop body (or even other threads)
>>>> to delete arbitrary list items - but that needs significant extra overheads.
>>>>
>>>> It might be worth doing something that doesn't need the extra variable,
>>>> but there is little point doing all the churn just to rename things.
>>>>  
>>>>>
>>>>> This makes call sites that only mutate the list through the current entry
>>>>> less noisy, while keeping the existing *_safe() helpers available for
>>>>> compatibility.
>>>>>
>>>>> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
>>>>> ---
>>>>>  include/linux/list.h | 269 +++++++++++++++++++++++++++++++++++++------
>>>>>  1 file changed, 231 insertions(+), 38 deletions(-)
>>>>>
>>>>> diff --git a/include/linux/list.h b/include/linux/list.h
>>>>> index 09d979976b3b..1081def7cea9 100644
>>>>> --- a/include/linux/list.h
>>>>> +++ b/include/linux/list.h
>>>>> @@ -7,6 +7,7 @@
>>>>>  #include <linux/stddef.h>
>>>>>  #include <linux/poison.h>
>>>>>  #include <linux/const.h>
>>>>> +#include <linux/args.h>
>>>>>  
>>>>>  #include <asm/barrier.h>
>>>>>  
>>>>> @@ -763,28 +764,72 @@ static inline void list_splice_tail_init(struct list_head *list,
>>>>>  #define list_for_each_prev(pos, head) \
>>>>>  	for (pos = (head)->prev; !list_is_head(pos, (head)); pos = pos->prev)
>>>>>  
>>>>> -/**
>>>>> - * list_for_each_safe - iterate over a list safe against removal of list entry
>>>>> - * @pos:	the &struct list_head to use as a loop cursor.
>>>>> - * @n:		another &struct list_head to use as temporary storage
>>>>> - * @head:	the head for your list.
>>>>> +/*
>>>>> + * list_for_each_safe is an old interface, use list_for_each_mutable instead.
>>>>>   */
>>>>>  #define list_for_each_safe(pos, n, head) \
>>>>>  	for (pos = (head)->next, n = pos->next; \
>>>>>  	     !list_is_head(pos, (head)); \
>>>>>  	     pos = n, n = pos->next)
>>>>>  
>>>>> +#define __list_for_each_mutable_internal(pos, tmp, head)		\
>>>>> +	for (typeof(pos) tmp = (pos = (head)->next)->next;		\  
>>>>
>>>> Use auto
>>>>  
>>>>> +	     !list_is_head(pos, (head));				\
>>>>> +	     pos = tmp, tmp = pos->next)
>>>>> +
>>>>> +#define __list_for_each_mutable1(pos, head)				\
>>>>> +	__list_for_each_mutable_internal(pos, __UNIQUE_ID(next), head)
>>>>> +
>>>>> +#define __list_for_each_mutable2(pos, next, head)			\
>>>>> +	list_for_each_safe(pos, next, head)
>>>>> +
>>>>>  /**
>>>>> - * list_for_each_prev_safe - iterate over a list backwards safe against removal of list entry
>>>>> + * list_for_each_mutable - iterate over a list safe against entry removal
>>>>>   * @pos:	the &struct list_head to use as a loop cursor.
>>>>> - * @n:		another &struct list_head to use as temporary storage
>>>>> - * @head:	the head for your list.
>>>>> + * @...:	either (head) or (next, head)
>>>>> + *
>>>>> + * next:	another &struct list_head to use as optional temporary storage.
>>>>> + *		The temporary cursor is internal unless explicitly supplied by
>>>>> + *		the caller.
>>>>> + * head:	the head for your list.
>>>>> + */
>>>>> +#define list_for_each_mutable(pos, ...)					\
>>>>> +	CONCATENATE(__list_for_each_mutable, COUNT_ARGS(__VA_ARGS__))	\
>>>>> +		(pos, __VA_ARGS__)  
>>>>
>>>> The variable argument count logic really just slows down compilation.
>>>> Maybe there aren't enough copies of this code to make that significant.
>>>> But just because you can do it doesn't mean it is a gooD idea.
>>>> I'm also not sure it really adds anything to the readability.
>>>>
>>>> And, it you are going to make the middle argument optional there is
>>>> no need to change the macro name.  
>>>
>>> Christian König and Jani Nikula also disagree with the variadic-argument
>>> implementation approach. If we abandon that method, it means we will
>>> inevitably need to add some new macros. If mutable is not a good name,
>>> suggestions for better alternatives would be welcome; coming up with a
>>> suitable name is indeed rather tricky.  
>>
>> I don't think you need to add a new macro for the specific use case that people want to modify the next element of the iteration.
>>
>> If I remember your numbers correctly that is a really corner case and keeping using the existing *_safe() macros for that sounds perfectly fine to me.
> 
> IIRC currently you have a choice of either:
> 	define               Item that can't be deleted
> 	list_for_each()	     The current item.
> 	list_for_each_safe() The next item.
> There is also likely to be code that updates the variables to allow
> for other scenarios.
> 
> Note that if increase a reference count and release a lock then list_for_each()
> is likely safer than list_for_each_safe() :-)
> 
> list.h has 9 variants of the 'safe' loop.
> The bloat of another 9 is getting excessive.
> 
> It has to be said that this is one of my least favourite type of list...

Hi Christian König, David Laight, Jani Nikula, David Hildenbrand,
Andy Shevchenko, Alexei Starovoitov

For ease of discussion, I need to summarize the currently possible
approaches and briefly describe their respective pros and cons,
using the list_for_each_entry* interfaces as examples.

1. Add list_for_each_entry_mutable, while keeping list_for_each_entry
and list_for_each_entry_safe unchanged. list_for_each_entry_mutable
would be used specifically for safe deletion scenarios that do not
need to expose the temporary cursor externally. The code can refer to
the v1 version.

Pros: Does not depend on immediate per-subsystem adaptation and can be
      merged directly.
Cons: Requires adding a whole set of mutable interfaces, which makes the
      code somewhat redundant.

2. Directly optimize away the temporary cursor in list_for_each_entry_safe
and define it inside the loop instead, changing the interface from four
arguments to three.

Pros: Does not add redundant interfaces.
Cons: (1) Users need to manually update special cases that use the
      traversal variable of list_for_each_entry_safe, the new
      list_for_each_entry_safe would no longer apply there and would
      need to be open-coded.
      (2) Because the macro arguments changes, all list_for_each_entry_safe
      callers would need to be modified and merged together, making it
      difficult to merge such a large amount of code at once.

3. Use a variadic macro approach to optimize list_for_each_entry_safe,
so that it supports both three and four arguments.

Pros: (1) Does not add redundant interfaces.
      (2) Does not depend on immediate per-subsystem adaptation and can
      be merged directly.
Cons: (1) Increases compile time.
      (2) Makes the interface harder for users to use.

4. Optimize list_for_each_entry by defining the temporary cursor internally,
making it compatible with the functionality of list_for_each_entry_safe.
The code can refer to the v2 version.

Pros: (1) Does not add redundant interfaces.
      (2) The number of externally visible arguments of list_for_each_entry
      remains unchanged, still three.
Cons: (1) list_for_each_entry and list_for_each_entry_safe would be merged
      into one, and list_for_each_entry_safe would gradually be deprecated.
      (2) Users need to manually update special cases that use the traversal
      variable of list_for_each_entry, the new list_for_each_entry would no
      longer apply there and would need to be open-coded. There are 15 such
      cases in total.

5. Use a variadic macro approach to optimize list_for_each_entry, so that
it supports both three and four arguments.

Pros: (1) Does not add redundant interfaces.
      (2) Does not depend on immediate per-subsystem adaptation and can be
      merged directly.
Cons: (1) Increases compile time.
      (2) list_for_each_entry and list_for_each_entry_safe would be merged
      into one, and list_for_each_entry_safe would gradually be deprecated.

6. Make no changes, keep the current logic unchanged, and close the current
email discussion.


Which of the six solutions above do people prefer?

-- 
Thanks
Kaitao Cheng


