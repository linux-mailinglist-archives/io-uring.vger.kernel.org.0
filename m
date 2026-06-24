Return-Path: <io-uring+bounces-13828-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id rx/EK4nXO2oyeAgAu9opvQ
	(envelope-from <io-uring+bounces-13828-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 24 Jun 2026 15:11:37 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BC3266BE75A
	for <lists+io-uring@lfdr.de>; Wed, 24 Jun 2026 15:11:36 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t7N5AMoP;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13828-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c15:e001:75::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13828-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=linux.dev;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D3BEE304AEEE
	for <lists+io-uring@lfdr.de>; Wed, 24 Jun 2026 13:06:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6F9F3B442B;
	Wed, 24 Jun 2026 13:06:11 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E583B0AFA;
	Wed, 24 Jun 2026 13:06:09 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782306371; cv=none; b=XsFRbkTYaV58xEPsmF/f7QnvsFIADp8tSDCFT6wCb1mfxsFxSUHHOiUH+QIWxfOX6rvh9Y4LkFXh9h6cMbSH5dnX11S+yhDZn2OHhnTfVz4gbiDockdjDniAuB6Nk72wS9dJ2n49TpuLbVKxzbvZKR+/fJ6FATmQrSWlYK8Sdj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782306371; c=relaxed/simple;
	bh=DuA83fRrvg9FcK3+uKVtP7zDj3cARtxSAMCxIPj6Ris=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=isKrKv66aLcbXc3RyIKqUVQ08wM/kk4IT8Gxs/s3LtMkr+cskLDfvUbUeTi3I1A08gWu3aCptvNWpKPVSHfEdB4KkYoq++MHZJ4qLdyqIY59m7+leDIDscvxu7sBp976sVs4RT184PNe/Rk2K5x+0oLjKd/CiCT43whlZ0Gs62U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=t7N5AMoP; arc=none smtp.client-ip=91.218.175.185
Message-ID: <96334e07-dbd9-47a0-93f5-ac4762b7b919@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782306356;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z2iAFOHBRMR/Xa17pT7sXAqMACpdvIbkzmpfw9EGJVs=;
	b=t7N5AMoP0/i8dFY3FrC7HO2yNmLfeZFETlWYqXUODrlmNpqyaftZywjo0y9UNn13O8QGRa
	AXb39zIwwMhdHGGwdLIWZOxZlc/RB5gme76K1wm+eYFw8s2/p0wLK8vNz3AEO2CElTbLsC
	uEFuGXWFUWXMM2nzKZ+r26KvGnuXTwQ=
Date: Wed, 24 Jun 2026 21:05:32 +0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3 0/7] Prepare mutable list iterators to cache cursor
 state
To: Jani Nikula <jani.nikula@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>,
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
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: David Howells <dhowells@redhat.com>,
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
 llvm@lists.linux.dev, chengkaitao <chengkaitao@kylinos.cn>
References: <20260622040533.29824-1-kaitao.cheng@linux.dev>
 <88f34c7fa5a3d1700cc8005818751d6aa31f09df@intel.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kaitao Cheng <kaitao.cheng@linux.dev>
In-Reply-To: <88f34c7fa5a3d1700cc8005818751d6aa31f09df@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13828-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:jani.nikula@linux.intel.com,m:akpm@linux-foundation.org,m:david@kernel.org,m:axboe@kernel.dk,m:tj@kernel.org,m:viro@zeniv.linux.org.uk,m:brauner@kernel.org,m:ast@kernel.org,m:daniel@iogearbox.net,m:andrii@kernel.org,m:hannes@cmpxchg.org,m:peterz@infradead.org,m:mingo@redhat.com,m:acme@kernel.org,m:namhyung@kernel.org,m:tglx@kernel.org,m:juri.lelli@redhat.com,m:vincent.guittot@linaro.org,m:paul@paul-moore.com,m:andriy.shevchenko@linux.intel.com,m:paulmck@kernel.org,m:shakeel.butt@linux.dev,m:christian.koenig@amd.com,m:dhowells@redhat.com,m:simona.vetter@ffwll.ch,m:rdunlap@infradead.org,m:luca.ceresoli@bootlin.com,m:phasta@kernel.org,m:linux-block@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:cgroups@vger.kernel.org,m:linux-ntfs-dev@lists.sourceforge.net,m:linux-fsdevel@vger.kernel.org,m:io-uring@vger.kernel.org,m:audit@vger.kernel.org,m:bpf@vger.kernel.org,m:netdev@vger.kernel.org,m:dri-devel@lists.freedesktop.org,m:linux-perf-users@vger.kernel.org,m:linu
 x-trace-kernel@vger.kernel.org,m:kexec@lists.infradead.org,m:live-patching@vger.kernel.org,m:linux-modules@vger.kernel.org,m:linux-crypto@vger.kernel.org,m:linux-pm@vger.kernel.org,m:rcu@vger.kernel.org,m:sched-ext@lists.linux.dev,m:linux-mm@kvack.org,m:virtualization@lists.linux.dev,m:damon@lists.linux.dev,m:llvm@lists.linux.dev,m:chengkaitao@kylinos.cn,s:lists@lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER(0.00)[kaitao.cheng@linux.dev,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[linux.dev:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCPT_COUNT_GT_50(0.00)[52];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kaitao.cheng@linux.dev,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,linux.dev:dkim,linux.dev:email,linux.dev:mid,linux.dev:from_mime,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: BC3266BE75A



在 2026/6/22 16:37, Jani Nikula 写道:
> On Mon, 22 Jun 2026, Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
>> Add *_mutable() iterator variants for list, hlist and llist.  The new
>> helpers are variadic and support both forms.  In the common case, the
>> caller omits the temporary cursor and the macro creates a unique internal
>> cursor with typeof(pos) and __UNIQUE_ID().  If a loop really needs an
>> explicit temporary cursor, the caller can still pass it and the helper
>> keeps the existing *_safe() behaviour.
>>
>> For example, a call site may use the shorter form:
>>
>>   list_for_each_entry_mutable(pos, head, member)
>>
>> or keep the explicit temporary cursor form:
>>
>>   list_for_each_entry_mutable(pos, tmp, head, member)
> 
> I'm unconvinced it's a good idea to allow two forms with macro trickery,
> *especially* when it's not the last argument you can omit. I think it's
> a footgun.
> 
> IMO stick with the first form only, and there'll always be the _safe
> variant that can be used when the temp pointer is needed.

Could we go back to the v1 version? What do you think of that
implementation approach?

https://lore.kernel.org/all/20260529082149.76764-1-kaitao.cheng@linux.dev/

-- 
Thanks
Kaitao Cheng


