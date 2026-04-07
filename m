Return-Path: <io-uring+bounces-12972-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qLZIA7hk1Wm05gcAu9opvQ
	(envelope-from <io-uring+bounces-12972-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 07 Apr 2026 22:10:32 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 658943B45F6
	for <lists+io-uring@lfdr.de>; Tue, 07 Apr 2026 22:10:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CC9AE302D95A
	for <lists+io-uring@lfdr.de>; Tue,  7 Apr 2026 20:10:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38DA2351C09;
	Tue,  7 Apr 2026 20:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Kr83IjPI"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7151A262A;
	Tue,  7 Apr 2026 20:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775592618; cv=none; b=nC3V2WRamZUqfDlXuVCw5kt0M1gR1M3HXyJlLvvRmBKU6M/7gJ5sE3bg0ad3t6GdSHADZ7NXoYI+bK0KFE+pW38aGbkQKg4Zuvrn4S64rKFldoS5EuDNOZ7LzR2gq7m/hQbK14MpfqkDkD4MSY6WcdTo+ht6vSameiiGEfqIbLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775592618; c=relaxed/simple;
	bh=ZlgXUtbGp9j+zCOWe5Ae967XxGrV535xTwvFK6UmZ5M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZsmV8ADdu9IixX30riIDLvPDbUKD8D0gd47aO5WEhi1ctjIc3Dr4l0N9FWUrJj3TzO2PTiX5J+7vZ9jfMxkHX71x975KOaeEcIg5JwFUNIvGZbrqKRfjKtYohPUwma2EKDWnktX1t/cIL8k4BYCcXmRfY+k1bQ21SLKHkW4p/I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Kr83IjPI; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775592616; x=1807128616;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZlgXUtbGp9j+zCOWe5Ae967XxGrV535xTwvFK6UmZ5M=;
  b=Kr83IjPIeJ4c6s/5nON61jQoZ8itRWxhl3EUmjoAj8THAz8tuOHnMsJD
   hbWJOq2JSHI3pP/DrIRavdCbmUrG3aTwlIRcy8kqDLD28jnLGKYSo+r+3
   0Qsm+q1YuAaP6AF6Nk/Pj2Eeol4QlQoEwu5E4hIuUiPf7bGYovXSA4Z5W
   tb+Fbw26Lw3ldcSLtqhwt0vOhYIdDXGtwuYSAydW/4rUpPFcQNtIxeg12
   +UCZ1zOPHjhwbVj15IKjkIEa2sLGk+mKr3GgzOOYtOz3GBDpo7yN0U4tl
   n0D41Xo7aEhaDlIfI7I5NjlQdOKQ9u0UWBeCY5XVdJ5mIenHhTJil+HT1
   g==;
X-CSE-ConnectionGUID: XakoqsndSS+QuyQMVJ7Pfw==
X-CSE-MsgGUID: Mh//yFtsQ62RNw7WxLuTGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11752"; a="99193182"
X-IronPort-AV: E=Sophos;i="6.23,166,1770624000"; 
   d="scan'208";a="99193182"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 13:10:15 -0700
X-CSE-ConnectionGUID: 0eRiTkflTqqol3ybLGpaKQ==
X-CSE-MsgGUID: p8ynAgY7QhusErKGmcc/Mg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,166,1770624000"; 
   d="scan'208";a="251568846"
Received: from lkp-server01.sh.intel.com (HELO d00eb8a6782a) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 07 Apr 2026 13:10:13 -0700
Received: from kbuild by d00eb8a6782a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wACkU-0000000010H-30K3;
	Tue, 07 Apr 2026 20:10:10 +0000
Date: Wed, 8 Apr 2026 04:10:03 +0800
From: kernel test robot <lkp@intel.com>
To: Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kusaram Devineni <kusaram@devineni.in>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Jens Axboe <axboe@kernel.dk>, Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH] signalfd: don't dequeue the forced fatal signals
Message-ID: <202604080450.mkKRp9Mk-lkp@intel.com>
References: <adKJMRkQJXEwHs-j@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adKJMRkQJXEwHs-j@redhat.com>
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	TAGGED_FROM(0.00)[bounces-12972-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lkp@intel.com,io-uring@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[9];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:email,intel.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 658943B45F6
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi Oleg,

kernel test robot noticed the following build warnings:

[auto build test WARNING on brauner-vfs/vfs.all]
[also build test WARNING on akpm-mm/mm-everything kees/for-next/pstore kees/for-next/kspp linus/master v7.0-rc7 next-20260406]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Oleg-Nesterov/signalfd-don-t-dequeue-the-forced-fatal-signals/20260407-131556
base:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git vfs.all
patch link:    https://lore.kernel.org/r/adKJMRkQJXEwHs-j%40redhat.com
patch subject: [PATCH] signalfd: don't dequeue the forced fatal signals
config: x86_64-randconfig-123-20260407 (https://download.01.org/0day-ci/archive/20260408/202604080450.mkKRp9Mk-lkp@intel.com/config)
compiler: gcc-13 (Debian 13.3.0-16) 13.3.0
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260408/202604080450.mkKRp9Mk-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604080450.mkKRp9Mk-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> fs/signalfd.c:53:40: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected struct k_sigaction *k @@     got struct k_sigaction [noderef] __rcu * @@
   fs/signalfd.c:53:40: sparse:     expected struct k_sigaction *k
   fs/signalfd.c:53:40: sparse:     got struct k_sigaction [noderef] __rcu *
   fs/signalfd.c:69:33: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected struct wait_queue_head [usertype] *wait_address @@     got struct wait_queue_head [noderef] __rcu * @@
   fs/signalfd.c:69:33: sparse:     expected struct wait_queue_head [usertype] *wait_address
   fs/signalfd.c:69:33: sparse:     got struct wait_queue_head [noderef] __rcu *
   fs/signalfd.c:71:31: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   fs/signalfd.c:71:31: sparse:     expected struct spinlock [usertype] *lock
   fs/signalfd.c:71:31: sparse:     got struct spinlock [noderef] __rcu *
   fs/signalfd.c:76:33: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   fs/signalfd.c:76:33: sparse:     expected struct spinlock [usertype] *lock
   fs/signalfd.c:76:33: sparse:     got struct spinlock [noderef] __rcu *
   fs/signalfd.c:110:32: sparse: sparse: cast removes address space '__user' of expression
   fs/signalfd.c:128:33: sparse: sparse: cast removes address space '__user' of expression
   fs/signalfd.c:131:33: sparse: sparse: cast removes address space '__user' of expression
   fs/signalfd.c:135:33: sparse: sparse: cast removes address space '__user' of expression
   fs/signalfd.c:151:32: sparse: sparse: cast removes address space '__user' of expression
   fs/signalfd.c:155:38: sparse: sparse: cast removes address space '__user' of expression
   fs/signalfd.c:175:31: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   fs/signalfd.c:175:31: sparse:     expected struct spinlock [usertype] *lock
   fs/signalfd.c:175:31: sparse:     got struct spinlock [noderef] __rcu *
   fs/signalfd.c:185:41: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   fs/signalfd.c:185:41: sparse:     expected struct spinlock [usertype] *lock
   fs/signalfd.c:185:41: sparse:     got struct spinlock [noderef] __rcu *
   fs/signalfd.c:189:32: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct wait_queue_head *wq_head @@     got struct wait_queue_head [noderef] __rcu * @@
   fs/signalfd.c:189:32: sparse:     expected struct wait_queue_head *wq_head
   fs/signalfd.c:189:32: sparse:     got struct wait_queue_head [noderef] __rcu *
   fs/signalfd.c:199:41: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   fs/signalfd.c:199:41: sparse:     expected struct spinlock [usertype] *lock
   fs/signalfd.c:199:41: sparse:     got struct spinlock [noderef] __rcu *
   fs/signalfd.c:201:39: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   fs/signalfd.c:201:39: sparse:     expected struct spinlock [usertype] *lock
   fs/signalfd.c:201:39: sparse:     got struct spinlock [noderef] __rcu *
   fs/signalfd.c:204:33: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   fs/signalfd.c:204:33: sparse:     expected struct spinlock [usertype] *lock
   fs/signalfd.c:204:33: sparse:     got struct spinlock [noderef] __rcu *
   fs/signalfd.c:206:35: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct wait_queue_head *wq_head @@     got struct wait_queue_head [noderef] __rcu * @@
   fs/signalfd.c:206:35: sparse:     expected struct wait_queue_head *wq_head
   fs/signalfd.c:206:35: sparse:     got struct wait_queue_head [noderef] __rcu *
   fs/signalfd.c:305:39: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   fs/signalfd.c:305:39: sparse:     expected struct spinlock [usertype] *lock
   fs/signalfd.c:305:39: sparse:     got struct spinlock [noderef] __rcu *
   fs/signalfd.c:307:41: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct spinlock [usertype] *lock @@     got struct spinlock [noderef] __rcu * @@
   fs/signalfd.c:307:41: sparse:     expected struct spinlock [usertype] *lock
   fs/signalfd.c:307:41: sparse:     got struct spinlock [noderef] __rcu *
   fs/signalfd.c:309:17: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct wait_queue_head *wq_head @@     got struct wait_queue_head [noderef] __rcu * @@
   fs/signalfd.c:309:17: sparse:     expected struct wait_queue_head *wq_head
   fs/signalfd.c:309:17: sparse:     got struct wait_queue_head [noderef] __rcu *

vim +53 fs/signalfd.c

    50	
    51	static void mk_sigmask(struct signalfd_ctx *ctx, sigset_t *sigmask)
    52	{
  > 53		struct k_sigaction *k = current->sighand->action;
    54		int n;
    55	
    56		*sigmask = ctx->sigmask;
    57		for (n = 1; n <= _NSIG; ++n, ++k) {
    58			if (k->sa.sa_flags & SA_IMMUTABLE)
    59				sigaddset(sigmask, n);
    60		}
    61	}
    62	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

