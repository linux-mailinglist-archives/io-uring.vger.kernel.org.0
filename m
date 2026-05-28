Return-Path: <io-uring+bounces-13537-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4IrYEToHGGrGaQgAu9opvQ
	(envelope-from <io-uring+bounces-13537-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2026 11:13:30 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id ABF1F5EF54D
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2026 11:13:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9EC1E31F56EA
	for <lists+io-uring@lfdr.de>; Thu, 28 May 2026 08:59:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B44136A374;
	Thu, 28 May 2026 08:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZLjGjCS8"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0809377EBA;
	Thu, 28 May 2026 08:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779958754; cv=none; b=netuq0PWdY3Kq5/z/hbyVscVm7iNBrcBRSA40Ry7sK0piCp4QBRAvo67KqVlIaSvV4ADzcTlNIwfJ9SkUwAT5K3K6FXx96o7eTBqZsmhOUwXXvy4xU0a9+TCh8LFECM0esIuvpMMX5zb5KACpPfnbFl/c101wxIVqD7g73ws/L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779958754; c=relaxed/simple;
	bh=yITXz7miJoKkLJkFy0JeLjTGaWJ0V8x8RwQLEqHLRmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iOMcckbopTyZ3OB+GllmxVS78eUTEB0S6mwcBmLyHgOHmf6ed4yOw35TFjXKYKT8Wj7lzatuFhKryT5Jx+BGZRf2afgdwVoHw3S07JTuFLaUz2OKyz61/wnHIgP8qsOU4/58DQOSIubkM6uSI+q5VqwinYqtnF4JLnH5bLghCJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZLjGjCS8; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779958753; x=1811494753;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yITXz7miJoKkLJkFy0JeLjTGaWJ0V8x8RwQLEqHLRmQ=;
  b=ZLjGjCS8wiNcOhv0UVujYSv2STmW4NEvvxaBjIu9pH9XcD2BjNXRc/2H
   oWxLTYUwkIz3UHBLfP2zCHwbJNsQfyByIfGMlDLMqB7tQaUTzI4vHYoh4
   U6Va9hk/d2cD+APLK7gF7FosLYlRPJaGygriTPPAC21ueXmdxaSZx3JCw
   hIeEYXen3Zyildyrit+LBdg4lRQFEOH3NIZpni44JxG79R1vDGQrSK1f1
   opFsJj4qAmAgCLK/7y3l3KK7luKcs+jyktGNF4NIE0HiWKJiSgqik7B/L
   4Y8R/Oegzch6TSdrynPkAnN2f8/d9DvXSg9vPXEE9rhZa2AnNEsXEh1SC
   w==;
X-CSE-ConnectionGUID: iPULJdZQTyeeAyzrk2BHiw==
X-CSE-MsgGUID: 8k8i7sWxTqWscFozEpUTOA==
X-IronPort-AV: E=McAfee;i="6800,10657,11799"; a="79946333"
X-IronPort-AV: E=Sophos;i="6.24,173,1774335600"; 
   d="scan'208";a="79946333"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 01:59:12 -0700
X-CSE-ConnectionGUID: OWoJ8s+vSmKaooVbl3p+sQ==
X-CSE-MsgGUID: R+cGajzlR9ql9VHI5YnIIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,173,1774335600"; 
   d="scan'208";a="246523117"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 28 May 2026 01:59:07 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wSWa0-000000005l0-1tso;
	Thu, 28 May 2026 08:59:04 +0000
Date: Thu, 28 May 2026 16:58:24 +0800
From: kernel test robot <lkp@intel.com>
To: Christoph Hellwig <hch@lst.de>, Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@linux-foundation.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
	freedreno@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org, kasan-dev@googlegroups.com,
	bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] mm/slab: improve kmem_cache_alloc_bulk
Message-ID: <202605281629.y8HhAihO-lkp@intel.com>
References: <20260527070239.2252948-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527070239.2252948-2-hch@lst.de>
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13537-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lkp@intel.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[19];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: ABF1F5EF54D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi Christoph,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Christoph-Hellwig/mm-slab-improve-kmem_cache_alloc_bulk/20260527-150421
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260527070239.2252948-2-hch%40lst.de
patch subject: [PATCH] mm/slab: improve kmem_cache_alloc_bulk
config: parisc-randconfig-r071-20260528 (https://download.01.org/0day-ci/archive/20260528/202605281629.y8HhAihO-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 8.5.0
smatch: v0.5.0-9185-gbcc58b9c
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260528/202605281629.y8HhAihO-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605281629.y8HhAihO-lkp@intel.com/

All errors (new ones prefixed by >>):

   lib/test_meminit.c: In function 'do_kmem_cache_size':
>> lib/test_meminit.c:239:29: error: 'ret' undeclared (first use in this function); did you mean 'net'?
        kmem_cache_free_bulk(c, ret, bulk_array);
                                ^~~
                                net
   lib/test_meminit.c:239:29: note: each undeclared identifier is reported only once for each function it appears in


vim +239 lib/test_meminit.c

dc5c5ad79f0cc2d Laura Abbott        2019-12-04  209  
5015a300a522c8f Alexander Potapenko 2019-07-16  210  /*
5015a300a522c8f Alexander Potapenko 2019-07-16  211   * Test kmem_cache with given parameters:
5015a300a522c8f Alexander Potapenko 2019-07-16  212   *  want_ctor - use a constructor;
5015a300a522c8f Alexander Potapenko 2019-07-16  213   *  want_rcu - use SLAB_TYPESAFE_BY_RCU;
5015a300a522c8f Alexander Potapenko 2019-07-16  214   *  want_zero - use __GFP_ZERO.
5015a300a522c8f Alexander Potapenko 2019-07-16  215   */
5015a300a522c8f Alexander Potapenko 2019-07-16  216  static int __init do_kmem_cache_size(size_t size, bool want_ctor,
5015a300a522c8f Alexander Potapenko 2019-07-16  217  				     bool want_rcu, bool want_zero,
5015a300a522c8f Alexander Potapenko 2019-07-16  218  				     int *total_failures)
5015a300a522c8f Alexander Potapenko 2019-07-16  219  {
5015a300a522c8f Alexander Potapenko 2019-07-16  220  	struct kmem_cache *c;
5015a300a522c8f Alexander Potapenko 2019-07-16  221  	int iter;
5015a300a522c8f Alexander Potapenko 2019-07-16  222  	bool fail = false;
5015a300a522c8f Alexander Potapenko 2019-07-16  223  	gfp_t alloc_mask = GFP_KERNEL | (want_zero ? __GFP_ZERO : 0);
5015a300a522c8f Alexander Potapenko 2019-07-16  224  	void *buf, *buf_copy;
5015a300a522c8f Alexander Potapenko 2019-07-16  225  
5015a300a522c8f Alexander Potapenko 2019-07-16  226  	c = kmem_cache_create("test_cache", size, 1,
5015a300a522c8f Alexander Potapenko 2019-07-16  227  			      want_rcu ? SLAB_TYPESAFE_BY_RCU : 0,
5015a300a522c8f Alexander Potapenko 2019-07-16  228  			      want_ctor ? test_ctor : NULL);
5015a300a522c8f Alexander Potapenko 2019-07-16  229  	for (iter = 0; iter < 10; iter++) {
dc5c5ad79f0cc2d Laura Abbott        2019-12-04  230  		/* Do a test of bulk allocations */
dc5c5ad79f0cc2d Laura Abbott        2019-12-04  231  		if (!want_rcu && !want_ctor) {
863d4ee245fb4d6 Christoph Hellwig   2026-05-27  232  			if (!kmem_cache_alloc_bulk(c, alloc_mask, BULK_SIZE,
863d4ee245fb4d6 Christoph Hellwig   2026-05-27  233  					bulk_array)) {
dc5c5ad79f0cc2d Laura Abbott        2019-12-04  234  				fail = true;
dc5c5ad79f0cc2d Laura Abbott        2019-12-04  235  			} else {
dc5c5ad79f0cc2d Laura Abbott        2019-12-04  236  				int i;
863d4ee245fb4d6 Christoph Hellwig   2026-05-27  237  				for (i = 0; i < BULK_SIZE; i++)
dc5c5ad79f0cc2d Laura Abbott        2019-12-04  238  					fail |= check_buf(bulk_array[i], size, want_ctor, want_rcu, want_zero);
dc5c5ad79f0cc2d Laura Abbott        2019-12-04 @239  				kmem_cache_free_bulk(c, ret, bulk_array);
dc5c5ad79f0cc2d Laura Abbott        2019-12-04  240  			}
dc5c5ad79f0cc2d Laura Abbott        2019-12-04  241  		}
dc5c5ad79f0cc2d Laura Abbott        2019-12-04  242  
5015a300a522c8f Alexander Potapenko 2019-07-16  243  		buf = kmem_cache_alloc(c, alloc_mask);
5015a300a522c8f Alexander Potapenko 2019-07-16  244  		/* Check that buf is zeroed, if it must be. */
dc5c5ad79f0cc2d Laura Abbott        2019-12-04  245  		fail |= check_buf(buf, size, want_ctor, want_rcu, want_zero);
5015a300a522c8f Alexander Potapenko 2019-07-16  246  		fill_with_garbage_skip(buf, size, want_ctor ? CTOR_BYTES : 0);
d3a811617ae629d Arnd Bergmann       2019-07-16  247  
d3a811617ae629d Arnd Bergmann       2019-07-16  248  		if (!want_rcu) {
d3a811617ae629d Arnd Bergmann       2019-07-16  249  			kmem_cache_free(c, buf);
d3a811617ae629d Arnd Bergmann       2019-07-16  250  			continue;
d3a811617ae629d Arnd Bergmann       2019-07-16  251  		}
d3a811617ae629d Arnd Bergmann       2019-07-16  252  
5015a300a522c8f Alexander Potapenko 2019-07-16  253  		/*
5015a300a522c8f Alexander Potapenko 2019-07-16  254  		 * If this is an RCU cache, use a critical section to ensure we
5015a300a522c8f Alexander Potapenko 2019-07-16  255  		 * can touch objects after they're freed.
5015a300a522c8f Alexander Potapenko 2019-07-16  256  		 */
5015a300a522c8f Alexander Potapenko 2019-07-16  257  		rcu_read_lock();
5015a300a522c8f Alexander Potapenko 2019-07-16  258  		/*
5015a300a522c8f Alexander Potapenko 2019-07-16  259  		 * Copy the buffer to check that it's not wiped on
5015a300a522c8f Alexander Potapenko 2019-07-16  260  		 * free().
5015a300a522c8f Alexander Potapenko 2019-07-16  261  		 */
733d1d1a7745113 Alexander Potapenko 2019-08-02  262  		buf_copy = kmalloc(size, GFP_ATOMIC);
5015a300a522c8f Alexander Potapenko 2019-07-16  263  		if (buf_copy)
5015a300a522c8f Alexander Potapenko 2019-07-16  264  			memcpy(buf_copy, buf, size);
d3a811617ae629d Arnd Bergmann       2019-07-16  265  
4ab7ace465466d2 Alexander Potapenko 2019-07-16  266  		kmem_cache_free(c, buf);
5015a300a522c8f Alexander Potapenko 2019-07-16  267  		/*
5015a300a522c8f Alexander Potapenko 2019-07-16  268  		 * Check that |buf| is intact after kmem_cache_free().
5015a300a522c8f Alexander Potapenko 2019-07-16  269  		 * |want_zero| is false, because we wrote garbage to
5015a300a522c8f Alexander Potapenko 2019-07-16  270  		 * the buffer already.
5015a300a522c8f Alexander Potapenko 2019-07-16  271  		 */
5015a300a522c8f Alexander Potapenko 2019-07-16  272  		fail |= check_buf(buf, size, want_ctor, want_rcu,
5015a300a522c8f Alexander Potapenko 2019-07-16  273  				  false);
5015a300a522c8f Alexander Potapenko 2019-07-16  274  		if (buf_copy) {
5015a300a522c8f Alexander Potapenko 2019-07-16  275  			fail |= (bool)memcmp(buf, buf_copy, size);
5015a300a522c8f Alexander Potapenko 2019-07-16  276  			kfree(buf_copy);
5015a300a522c8f Alexander Potapenko 2019-07-16  277  		}
5015a300a522c8f Alexander Potapenko 2019-07-16  278  		rcu_read_unlock();
5015a300a522c8f Alexander Potapenko 2019-07-16  279  	}
5015a300a522c8f Alexander Potapenko 2019-07-16  280  	kmem_cache_destroy(c);
5015a300a522c8f Alexander Potapenko 2019-07-16  281  
5015a300a522c8f Alexander Potapenko 2019-07-16  282  	*total_failures += fail;
5015a300a522c8f Alexander Potapenko 2019-07-16  283  	return 1;
5015a300a522c8f Alexander Potapenko 2019-07-16  284  }
5015a300a522c8f Alexander Potapenko 2019-07-16  285  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

