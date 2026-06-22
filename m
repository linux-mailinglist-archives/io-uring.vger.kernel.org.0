Return-Path: <io-uring+bounces-13808-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id p54dDf30OGpFkgcAu9opvQ
	(envelope-from <io-uring+bounces-13808-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 22 Jun 2026 10:40:29 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CBDC6ADCFA
	for <lists+io-uring@lfdr.de>; Mon, 22 Jun 2026 10:40:28 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=intel.com header.s=Intel header.b=lwi+leCq;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13808-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13808-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BDB8F304C7F6
	for <lists+io-uring@lfdr.de>; Mon, 22 Jun 2026 08:37:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 726543932D0;
	Mon, 22 Jun 2026 08:37:51 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095D1238159;
	Mon, 22 Jun 2026 08:37:48 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782117471; cv=none; b=Qf/0kATbivMuVZTC6NRp2yVNhBpSATd8UW97WNTco9HX1Vnr66h+qf/rKmEYtJSoNhSlrdxZqR/4BgBfZveqjWWGbFFp13a65rYd0ifw15wgWQItntZCeFzTa/FI4QcnIp9IO1Hh2RP3AqPgdowisEb+rCmTsMZff1bZBexCAB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782117471; c=relaxed/simple;
	bh=o0XPey02pNHXumHWa6TQBgjgCeS/R84YiOVlMcvQRTw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=kdsgHnVGCzUbVL9DRipZrLUJnChZekP9N+jzeqr/olTe2w18p91Hmi9jWv+qibOuHS32MTpVtRMM4VQ8JRah1snf3S7sR+7kCw94jccFu7cakKpp6WTQgRT4wbX8aImb3bj9j8yTyTEHqLYrq0il7V0AGWb3j2nF6YcGm0Tks/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lwi+leCq; arc=none smtp.client-ip=198.175.65.17
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782117469; x=1813653469;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=o0XPey02pNHXumHWa6TQBgjgCeS/R84YiOVlMcvQRTw=;
  b=lwi+leCqmYWmuFst6FQBZ5DAHNBzvjzKOvdFm9YAWYeck1lFLPstlLLE
   HfvGplF7vI7ppon4Tfz83R0sJ7Q6UnhkB/puK65jNkqLWlw+oi1UKW+D2
   dmHcxGUFHvd15Dc0mMhfGhhAkaz7ESnKhl+LjgjHZNbe03xX5s2/kyNKX
   T2bQkviWBa+gpSAAvQYc38+tPbNSKQi5BFa0ScUd3NRX/apt0d888B4Lh
   XD1X3LFU5Ma16ZgS00f+GAY92w+Y1DarSdKVL2ZmHgWSG3tOfzLz3BQvQ
   ft49GdYMp53Vh5tvIMO+kqgJGdj8W04FzLYd7CsN+FVf6+Cmg2mV7j/HT
   A==;
X-CSE-ConnectionGUID: MUrLK/3DQ/+jOxbEeduDLw==
X-CSE-MsgGUID: jN0ZpEg6Tg+TQc4Ge4NM4g==
X-IronPort-AV: E=McAfee;i="6800,10657,11824"; a="82844719"
X-IronPort-AV: E=Sophos;i="6.24,218,1774335600"; 
   d="scan'208";a="82844719"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 01:37:48 -0700
X-CSE-ConnectionGUID: 51x2ahlxRfadoXyoUtL0hA==
X-CSE-MsgGUID: PGIuZ8mzSP2g3MT4S82HXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,218,1774335600"; 
   d="scan'208";a="254255860"
Received: from abityuts-desk.ger.corp.intel.com (HELO localhost) ([10.245.245.82])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 01:37:33 -0700
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Kaitao Cheng <kaitao.cheng@linux.dev>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Jens
 Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Alexei
 Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim
 <namhyung@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Juri Lelli
 <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>,
 Paul Moore <paul@paul-moore.com>, Andy Shevchenko
 <andriy.shevchenko@linux.intel.com>, "Paul E. McKenney"
 <paulmck@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, Christian
 =?utf-8?Q?K=C3=B6nig?= <christian.koenig@amd.com>
Cc: David Howells <dhowells@redhat.com>, Simona Vetter
 <simona.vetter@ffwll.ch>, Randy Dunlap <rdunlap@infradead.org>, Luca
 Ceresoli <luca.ceresoli@bootlin.com>, Philipp Stanner <phasta@kernel.org>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 audit@vger.kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-perf-users@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, kexec@lists.infradead.org,
 live-patching@vger.kernel.org, linux-modules@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-pm@vger.kernel.org,
 rcu@vger.kernel.org, sched-ext@lists.linux.dev, linux-mm@kvack.org,
 virtualization@lists.linux.dev, damon@lists.linux.dev,
 llvm@lists.linux.dev, chengkaitao <chengkaitao@kylinos.cn>
Subject: Re: [PATCH v3 0/7] Prepare mutable list iterators to cache cursor
 state
In-Reply-To: <20260622040533.29824-1-kaitao.cheng@linux.dev>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park,
 6 krs Bertel Jungin Aukio 5, 02600 Espoo, Finland
References: <20260622040533.29824-1-kaitao.cheng@linux.dev>
Date: Mon, 22 Jun 2026 11:37:29 +0300
Message-ID: <88f34c7fa5a3d1700cc8005818751d6aa31f09df@intel.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.66 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[intel.com:d:+,kernel.org:s:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13808-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:kaitao.cheng@linux.dev,m:akpm@linux-foundation.org,m:david@kernel.org,m:axboe@kernel.dk,m:tj@kernel.org,m:viro@zeniv.linux.org.uk,m:brauner@kernel.org,m:ast@kernel.org,m:daniel@iogearbox.net,m:andrii@kernel.org,m:hannes@cmpxchg.org,m:peterz@infradead.org,m:mingo@redhat.com,m:acme@kernel.org,m:namhyung@kernel.org,m:tglx@kernel.org,m:juri.lelli@redhat.com,m:vincent.guittot@linaro.org,m:paul@paul-moore.com,m:andriy.shevchenko@linux.intel.com,m:paulmck@kernel.org,m:shakeel.butt@linux.dev,m:christian.koenig@amd.com,m:dhowells@redhat.com,m:simona.vetter@ffwll.ch,m:rdunlap@infradead.org,m:luca.ceresoli@bootlin.com,m:phasta@kernel.org,m:linux-block@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:cgroups@vger.kernel.org,m:linux-ntfs-dev@lists.sourceforge.net,m:linux-fsdevel@vger.kernel.org,m:io-uring@vger.kernel.org,m:audit@vger.kernel.org,m:bpf@vger.kernel.org,m:netdev@vger.kernel.org,m:dri-devel@lists.freedesktop.org,m:linux-perf-users@vger.kernel.org,m:linux-tra
 ce-kernel@vger.kernel.org,m:kexec@lists.infradead.org,m:live-patching@vger.kernel.org,m:linux-modules@vger.kernel.org,m:linux-crypto@vger.kernel.org,m:linux-pm@vger.kernel.org,m:rcu@vger.kernel.org,m:sched-ext@lists.linux.dev,m:linux-mm@kvack.org,m:virtualization@lists.linux.dev,m:damon@lists.linux.dev,m:llvm@lists.linux.dev,m:chengkaitao@kylinos.cn,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[jani.nikula@linux.intel.com,io-uring@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	MIME_TRACE(0.00)[0:+];
	HAS_ORG_HEADER(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jani.nikula@linux.intel.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	ALIAS_RESOLVED(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_GT_50(0.00)[52];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.intel.com:from_mime,linux.dev:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp,intel.com:dkim,intel.com:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 7CBDC6ADCFA

On Mon, 22 Jun 2026, Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
> Add *_mutable() iterator variants for list, hlist and llist.  The new
> helpers are variadic and support both forms.  In the common case, the
> caller omits the temporary cursor and the macro creates a unique internal
> cursor with typeof(pos) and __UNIQUE_ID().  If a loop really needs an
> explicit temporary cursor, the caller can still pass it and the helper
> keeps the existing *_safe() behaviour.
>
> For example, a call site may use the shorter form:
>
>   list_for_each_entry_mutable(pos, head, member)
>
> or keep the explicit temporary cursor form:
>
>   list_for_each_entry_mutable(pos, tmp, head, member)

I'm unconvinced it's a good idea to allow two forms with macro trickery,
*especially* when it's not the last argument you can omit. I think it's
a footgun.

IMO stick with the first form only, and there'll always be the _safe
variant that can be used when the temp pointer is needed.


BR,
Jani.


-- 
Jani Nikula, Intel

