Return-Path: <io-uring+bounces-13835-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id zPcmNKEKPWoswQgAu9opvQ
	(envelope-from <io-uring+bounces-13835-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 25 Jun 2026 13:01:53 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EA7116C4ED3
	for <lists+io-uring@lfdr.de>; Thu, 25 Jun 2026 13:01:46 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ft52+1SA;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13835-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c15:e001:75::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13835-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8A4023024935
	for <lists+io-uring@lfdr.de>; Thu, 25 Jun 2026 11:00:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 833353A9D80;
	Thu, 25 Jun 2026 11:00:57 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9973A960F;
	Thu, 25 Jun 2026 11:00:55 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782385257; cv=none; b=gy3zmA9rq19Ifz1kgvRzpAFdluze481e/k+uH2t6uAeVyzKhKoYxJbqT3rQA2MTGr3WaJMfR1wjAD2Nk4nRgX2Oug4Ysz4XQsjaV9Woddub4m2gQUMN8ch/DsC8ssYxuf8jCrWjDbXU1lWp49ZQnm50llimyyY3wTm9OKfwdzeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782385257; c=relaxed/simple;
	bh=vUCknLxuUl+l9swTriiC6ceqP2YAiFjd4mW5kfnFb/U=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=iByqunH8HDRVjjf7KQRNwxjDiznJGJ1BgWHRuG+ivFRxfa1Z3pIKaRw1rslP+YPl94o6mZl1UCL0Y58mUmAWWt3C6c2Xgfc+hFjH/ntElQ71RFSOmjzeoQTZb1dcI+lvcjWfJ6VMjlonBe5kLfkccZigzE+nF7xZ7D2rAWwUARk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ft52+1SA; arc=none smtp.client-ip=198.175.65.15
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782385256; x=1813921256;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=vUCknLxuUl+l9swTriiC6ceqP2YAiFjd4mW5kfnFb/U=;
  b=Ft52+1SATq1u9siZpCOShDXPUvQAEG9ceDn7d9ZMPuM0nNyneHaVsdhA
   8PEM0RUVdQ2PaDACVwhwaAFzd7noGS03jnog8lD3zVPxeY7okREDQEVxE
   qP9mAd3ifJyapa+aBDMAlWpOlGaiqn2rJCoVw5DJLjtx+ecHuzin0SWW3
   4tR/vC28360JA6YUveloUPYzjUc2LWb5VZVZQNDNCOds2CJ6zGcjXzptW
   JokMDaD019UtCfYUSjYdHqFr5zuA/Ug897IFsMtYRA7yxs2parB9ogQJR
   izsOSKsHwdKywvHy89LMPAiQ9RRyCClmtT/a3AH4RExovS5Dt/1btygar
   w==;
X-CSE-ConnectionGUID: 2PvImUdiS8WGFHJi5Pa1Xw==
X-CSE-MsgGUID: dIvq8SOKTQqtsgS9xAYFeA==
X-IronPort-AV: E=McAfee;i="6800,10657,11827"; a="86838512"
X-IronPort-AV: E=Sophos;i="6.24,224,1774335600"; 
   d="scan'208";a="86838512"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2026 04:00:55 -0700
X-CSE-ConnectionGUID: vmMDYz3IR0yKtgcbLjpOxw==
X-CSE-MsgGUID: owF9N6AWRaOmSHlf6kHSKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,224,1774335600"; 
   d="scan'208";a="254729051"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.126])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2026 04:00:42 -0700
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Kaitao Cheng <kaitao.cheng@linux.dev>, David Laight
 <david.laight.linux@gmail.com>, Christian =?utf-8?Q?K=C3=B6nig?=
 <christian.koenig@amd.com>, "David Hildenbrand (Arm)" <david@kernel.org>,
 Alexei Starovoitov <ast@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
 <david@kernel.org>, Jens Axboe <axboe@kernel.dk>, Tejun Heo
 <tj@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim
 <namhyung@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Juri Lelli
 <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>,
 Paul Moore <paul@paul-moore.com>, Andy Shevchenko
 <andriy.shevchenko@linux.intel.com>, "Paul E. McKenney"
 <paulmck@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, David Howells
 <dhowells@redhat.com>, Simona Vetter <simona.vetter@ffwll.ch>, Randy
 Dunlap <rdunlap@infradead.org>, Luca Ceresoli <luca.ceresoli@bootlin.com>,
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
 llvm@lists.linux.dev, Kaitao Cheng <chengkaitao@kylinos.cn>, Muchun Song
 <muchun.song@linux.dev>
Subject: Re: [PATCH v3 1/7] list: Add mutable iterator variants
In-Reply-To: <0ed6b5c3-e955-46e2-9fc6-075a0dfd1c4f@linux.dev>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park,
 6 krs Bertel Jungin Aukio 5, 02600 Espoo, Finland
References: <20260622040533.29824-1-kaitao.cheng@linux.dev>
 <20260622040533.29824-2-kaitao.cheng@linux.dev>
 <20260622094242.64531b9a@pumpkin>
 <351a6b67-b394-4c58-aee2-88b6c8089ad5@linux.dev>
 <cf8467c7-b98f-44a5-9cf9-60b43b5da711@amd.com>
 <20260624152324.3def88ce@pumpkin>
 <0ed6b5c3-e955-46e2-9fc6-075a0dfd1c4f@linux.dev>
Date: Thu, 25 Jun 2026 14:00:39 +0300
Message-ID: <734f66ca51485ee3ec9788c0eaaead681e00664b@intel.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.66 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[intel.com:d:+,kernel.org:s:+];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13835-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:kaitao.cheng@linux.dev,m:david.laight.linux@gmail.com,m:christian.koenig@amd.com,m:david@kernel.org,m:ast@kernel.org,m:akpm@linux-foundation.org,m:axboe@kernel.dk,m:tj@kernel.org,m:viro@zeniv.linux.org.uk,m:brauner@kernel.org,m:daniel@iogearbox.net,m:andrii@kernel.org,m:hannes@cmpxchg.org,m:peterz@infradead.org,m:mingo@redhat.com,m:acme@kernel.org,m:namhyung@kernel.org,m:tglx@kernel.org,m:juri.lelli@redhat.com,m:vincent.guittot@linaro.org,m:paul@paul-moore.com,m:andriy.shevchenko@linux.intel.com,m:paulmck@kernel.org,m:shakeel.butt@linux.dev,m:dhowells@redhat.com,m:simona.vetter@ffwll.ch,m:rdunlap@infradead.org,m:luca.ceresoli@bootlin.com,m:phasta@kernel.org,m:linux-block@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:cgroups@vger.kernel.org,m:linux-ntfs-dev@lists.sourceforge.net,m:linux-fsdevel@vger.kernel.org,m:io-uring@vger.kernel.org,m:audit@vger.kernel.org,m:bpf@vger.kernel.org,m:netdev@vger.kernel.org,m:dri-devel@lists.freedesktop.org,m:linux-perf-us
 ers@vger.kernel.org,m:linux-trace-kernel@vger.kernel.org,m:kexec@lists.infradead.org,m:live-patching@vger.kernel.org,m:linux-modules@vger.kernel.org,m:linux-crypto@vger.kernel.org,m:linux-pm@vger.kernel.org,m:rcu@vger.kernel.org,m:sched-ext@lists.linux.dev,m:linux-mm@kvack.org,m:virtualization@lists.linux.dev,m:damon@lists.linux.dev,m:llvm@lists.linux.dev,m:chengkaitao@kylinos.cn,m:muchun.song@linux.dev,m:davidlaightlinux@gmail.com,s:lists@lfdr.de];
	FREEMAIL_TO(0.00)[linux.dev,gmail.com,amd.com,kernel.org];
	HAS_ORG_HEADER(0.00)[];
	ASN_FAIL(0.00)[1.2.3.5.c.f.2.1.0.0.0.0.0.0.0.0.5.7.0.0.1.0.0.e.5.1.c.3.0.0.6.2.asn6.rspamd.com:query timed out];
	FORGED_SENDER(0.00)[jani.nikula@linux.intel.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jani.nikula@linux.intel.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[intel.com:+];
	RCPT_COUNT_GT_50(0.00)[55];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TO_DN_SOME(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,intel.com:dkim,intel.com:mid,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,amd.com:email,kylinos.cn:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: EA7116C4ED3

On Thu, 25 Jun 2026, Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
> =E5=9C=A8 2026/6/24 22:23, David Laight =E5=86=99=E9=81=93:
>> On Wed, 24 Jun 2026 15:23:47 +0200
>> Christian K=C3=B6nig <christian.koenig@amd.com> wrote:
>>> On 6/24/26 15:14, Kaitao Cheng wrote:
>>>> =E5=9C=A8 2026/6/22 16:42, David Laight =E5=86=99=E9=81=93:=20=20
>>>>> On Mon, 22 Jun 2026 12:05:31 +0800
>>>>> Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
>>>>>=20=20
>>>>>> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>>>>>>
>>>>>> The list_for_each*_safe() helpers are used when the loop body may
>>>>>> remove the current entry.  Their API exposes the temporary cursor at
>>>>>> every call site, even though most users only need it for the iterator
>>>>>> implementation and never reference it in the loop body.
>>>>>>
>>>>>> Add *_mutable() variants for list and hlist iteration.  The new help=
ers
>>>>>> support both forms: callers may keep passing an explicit temporary c=
ursor
>>>>>> when they need to inspect or reset it, or omit it and let the helper=
 use
>>>>>> a unique internal cursor.=20=20
>>>>>
>>>>> I'm not really sure 'mutable' means anything either.
>>>>> It is possible to make it valid for the loop body (or even other thre=
ads)
>>>>> to delete arbitrary list items - but that needs significant extra ove=
rheads.
>>>>>
>>>>> It might be worth doing something that doesn't need the extra variabl=
e,
>>>>> but there is little point doing all the churn just to rename things.
>>>>>=20=20
>>>>>>
>>>>>> This makes call sites that only mutate the list through the current =
entry
>>>>>> less noisy, while keeping the existing *_safe() helpers available for
>>>>>> compatibility.
>>>>>>
>>>>>> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
>>>>>> ---
>>>>>>  include/linux/list.h | 269 +++++++++++++++++++++++++++++++++++++---=
---
>>>>>>  1 file changed, 231 insertions(+), 38 deletions(-)
>>>>>>
>>>>>> diff --git a/include/linux/list.h b/include/linux/list.h
>>>>>> index 09d979976b3b..1081def7cea9 100644
>>>>>> --- a/include/linux/list.h
>>>>>> +++ b/include/linux/list.h
>>>>>> @@ -7,6 +7,7 @@
>>>>>>  #include <linux/stddef.h>
>>>>>>  #include <linux/poison.h>
>>>>>>  #include <linux/const.h>
>>>>>> +#include <linux/args.h>
>>>>>>=20=20
>>>>>>  #include <asm/barrier.h>
>>>>>>=20=20
>>>>>> @@ -763,28 +764,72 @@ static inline void list_splice_tail_init(struc=
t list_head *list,
>>>>>>  #define list_for_each_prev(pos, head) \
>>>>>>  	for (pos =3D (head)->prev; !list_is_head(pos, (head)); pos =3D pos=
->prev)
>>>>>>=20=20
>>>>>> -/**
>>>>>> - * list_for_each_safe - iterate over a list safe against removal of=
 list entry
>>>>>> - * @pos:	the &struct list_head to use as a loop cursor.
>>>>>> - * @n:		another &struct list_head to use as temporary storage
>>>>>> - * @head:	the head for your list.
>>>>>> +/*
>>>>>> + * list_for_each_safe is an old interface, use list_for_each_mutabl=
e instead.
>>>>>>   */
>>>>>>  #define list_for_each_safe(pos, n, head) \
>>>>>>  	for (pos =3D (head)->next, n =3D pos->next; \
>>>>>>  	     !list_is_head(pos, (head)); \
>>>>>>  	     pos =3D n, n =3D pos->next)
>>>>>>=20=20
>>>>>> +#define __list_for_each_mutable_internal(pos, tmp, head)		\
>>>>>> +	for (typeof(pos) tmp =3D (pos =3D (head)->next)->next;		\=20=20
>>>>>
>>>>> Use auto
>>>>>=20=20
>>>>>> +	     !list_is_head(pos, (head));				\
>>>>>> +	     pos =3D tmp, tmp =3D pos->next)
>>>>>> +
>>>>>> +#define __list_for_each_mutable1(pos, head)				\
>>>>>> +	__list_for_each_mutable_internal(pos, __UNIQUE_ID(next), head)
>>>>>> +
>>>>>> +#define __list_for_each_mutable2(pos, next, head)			\
>>>>>> +	list_for_each_safe(pos, next, head)
>>>>>> +
>>>>>>  /**
>>>>>> - * list_for_each_prev_safe - iterate over a list backwards safe aga=
inst removal of list entry
>>>>>> + * list_for_each_mutable - iterate over a list safe against entry r=
emoval
>>>>>>   * @pos:	the &struct list_head to use as a loop cursor.
>>>>>> - * @n:		another &struct list_head to use as temporary storage
>>>>>> - * @head:	the head for your list.
>>>>>> + * @...:	either (head) or (next, head)
>>>>>> + *
>>>>>> + * next:	another &struct list_head to use as optional temporary sto=
rage.
>>>>>> + *		The temporary cursor is internal unless explicitly supplied by
>>>>>> + *		the caller.
>>>>>> + * head:	the head for your list.
>>>>>> + */
>>>>>> +#define list_for_each_mutable(pos, ...)					\
>>>>>> +	CONCATENATE(__list_for_each_mutable, COUNT_ARGS(__VA_ARGS__))	\
>>>>>> +		(pos, __VA_ARGS__)=20=20
>>>>>
>>>>> The variable argument count logic really just slows down compilation.
>>>>> Maybe there aren't enough copies of this code to make that significan=
t.
>>>>> But just because you can do it doesn't mean it is a gooD idea.
>>>>> I'm also not sure it really adds anything to the readability.
>>>>>
>>>>> And, it you are going to make the middle argument optional there is
>>>>> no need to change the macro name.=20=20
>>>>
>>>> Christian K=C3=B6nig and Jani Nikula also disagree with the variadic-a=
rgument
>>>> implementation approach. If we abandon that method, it means we will
>>>> inevitably need to add some new macros. If mutable is not a good name,
>>>> suggestions for better alternatives would be welcome; coming up with a
>>>> suitable name is indeed rather tricky.=20=20
>>>
>>> I don't think you need to add a new macro for the specific use case tha=
t people want to modify the next element of the iteration.
>>>
>>> If I remember your numbers correctly that is a really corner case and k=
eeping using the existing *_safe() macros for that sounds perfectly fine to=
 me.
>>=20
>> IIRC currently you have a choice of either:
>> 	define               Item that can't be deleted
>> 	list_for_each()	     The current item.
>> 	list_for_each_safe() The next item.
>> There is also likely to be code that updates the variables to allow
>> for other scenarios.
>>=20
>> Note that if increase a reference count and release a lock then list_for=
_each()
>> is likely safer than list_for_each_safe() :-)
>>=20
>> list.h has 9 variants of the 'safe' loop.
>> The bloat of another 9 is getting excessive.
>>=20
>> It has to be said that this is one of my least favourite type of list...
>
> Hi Christian K=C3=B6nig, David Laight, Jani Nikula, David Hildenbrand,
> Andy Shevchenko, Alexei Starovoitov
>
> For ease of discussion, I need to summarize the currently possible
> approaches and briefly describe their respective pros and cons,
> using the list_for_each_entry* interfaces as examples.
>
> 1. Add list_for_each_entry_mutable, while keeping list_for_each_entry
> and list_for_each_entry_safe unchanged. list_for_each_entry_mutable
> would be used specifically for safe deletion scenarios that do not
> need to expose the temporary cursor externally. The code can refer to
> the v1 version.
>
> Pros: Does not depend on immediate per-subsystem adaptation and can be
>       merged directly.
> Cons: Requires adding a whole set of mutable interfaces, which makes the
>       code somewhat redundant.

Seems fine, and the original _safe naming is ambiguous anyway.

> 2. Directly optimize away the temporary cursor in list_for_each_entry_safe
> and define it inside the loop instead, changing the interface from four
> arguments to three.
>
> Pros: Does not add redundant interfaces.
> Cons: (1) Users need to manually update special cases that use the
>       traversal variable of list_for_each_entry_safe, the new
>       list_for_each_entry_safe would no longer apply there and would
>       need to be open-coded.
>       (2) Because the macro arguments changes, all list_for_each_entry_sa=
fe
>       callers would need to be modified and merged together, making it
>       difficult to merge such a large amount of code at once.

This won't fly because there are literally thousands of
list_for_each_entry_safe() users.

> 3. Use a variadic macro approach to optimize list_for_each_entry_safe,
> so that it supports both three and four arguments.
>
> Pros: (1) Does not add redundant interfaces.
>       (2) Does not depend on immediate per-subsystem adaptation and can
>       be merged directly.
> Cons: (1) Increases compile time.
>       (2) Makes the interface harder for users to use.

Basically I'm against any variadic macro tricks where the optional
argument is not the last argument. That's just way too surprising, and
goes against common practice in just about all other languages.

> 4. Optimize list_for_each_entry by defining the temporary cursor internal=
ly,
> making it compatible with the functionality of list_for_each_entry_safe.
> The code can refer to the v2 version.
>
> Pros: (1) Does not add redundant interfaces.
>       (2) The number of externally visible arguments of list_for_each_ent=
ry
>       remains unchanged, still three.
> Cons: (1) list_for_each_entry and list_for_each_entry_safe would be merged
>       into one, and list_for_each_entry_safe would gradually be deprecate=
d.
>       (2) Users need to manually update special cases that use the traver=
sal
>       variable of list_for_each_entry, the new list_for_each_entry would =
no
>       longer apply there and would need to be open-coded. There are 15 su=
ch
>       cases in total.

This sounds good to me, though I take it there's some code size increase
and/or performance penalty?

Maybe the 15 cases are questionable anyway?

> 5. Use a variadic macro approach to optimize list_for_each_entry, so that
> it supports both three and four arguments.
>
> Pros: (1) Does not add redundant interfaces.
>       (2) Does not depend on immediate per-subsystem adaptation and can be
>       merged directly.
> Cons: (1) Increases compile time.
>       (2) list_for_each_entry and list_for_each_entry_safe would be merged
>       into one, and list_for_each_entry_safe would gradually be deprecate=
d.

Please don't do the macro tricks.

> 6. Make no changes, keep the current logic unchanged, and close the curre=
nt
> email discussion.

I like hiding the temporary stuff when possible.


BR,
Jani.

--=20
Jani Nikula, Intel

