Return-Path: <io-uring+bounces-11246-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 31135CD6D5A
	for <lists+io-uring@lfdr.de>; Mon, 22 Dec 2025 18:33:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8E89C305846C
	for <lists+io-uring@lfdr.de>; Mon, 22 Dec 2025 17:31:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BEF7338926;
	Mon, 22 Dec 2025 17:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LAHloAlD"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91F9299A8F;
	Mon, 22 Dec 2025 17:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766424295; cv=none; b=e5m7XSKIhqWLTM7esObYYVq+PS3wP+ZSBKogdlqcweahQEofC7odv9uJ61bnfvENfvDufLXamCp6lhg7S5jbNxo6+GELukcbuymRqmBZa4ojrUcsGRgTY5rgRkbfzPLvSQUi5VWVTRR151/GSJ6QruV9TKJe5F+t7NS4Wm/Wr3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766424295; c=relaxed/simple;
	bh=Meh4IFJKwQmWFy7b4k7Ru7HZTrffdNhPM8b0t4yMLHA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j9EqwdXhw57IpEalxMo05Y5TMGwnKoqlAcP9XzKunDQTKxvkZk2jtux1P6puNZKfQOpuraKF/py6MebY5R15YPw5tobUOwAIGAgK2Rck+cHutYgMLh+Cqi+CfQMwQkn00Eqxuuwrbf2YGMBou5cyxWb1qInEt6/Z4DjN51jr6gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LAHloAlD; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766424292; x=1797960292;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Meh4IFJKwQmWFy7b4k7Ru7HZTrffdNhPM8b0t4yMLHA=;
  b=LAHloAlD48Xvp1XK9c9aoPvFklMaS7dNj5qqCaObfqexGOyfH0gPPnVb
   q+/wizfDbL0k302MDsXD5IXtOyefGlRCQfGUh97cavrHIS/8opXqNwcaY
   RJaYsDxMU5LaD7ebNDOTYtMygsH1JGyBKx/FSmDLsKTAxLdr/cqSn+I9n
   z6PUWMo2GLo5/xYcJOEAANiMTezUiHY7xC8RoOjW0ty/XynOMIVhLd/co
   wSTHTHq7NIlkiD7aSow1HUvA1zBIDWq90aOoRuErcJ4fIlNqAXGZ9s3H+
   8YVML6vGfjZAMMR2PLU4TuFWq70MHgaNtkcOaUVUNu8MKy2goiwXWK1n3
   A==;
X-CSE-ConnectionGUID: Fmj3zsz4TtuYCjLtSXeCIg==
X-CSE-MsgGUID: LPP6NkRmQHWk0trAjaxiLQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11650"; a="93753033"
X-IronPort-AV: E=Sophos;i="6.21,168,1763452800"; 
   d="scan'208";a="93753033"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2025 09:24:50 -0800
X-CSE-ConnectionGUID: 3D03URhnR7qKeY5xeft+uA==
X-CSE-MsgGUID: bm0uX86LSyWVPF7HV1Kz9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,168,1763452800"; 
   d="scan'208";a="199214417"
Received: from lkp-server02.sh.intel.com (HELO dd3453e2b682) ([10.239.97.151])
  by fmviesa007.fm.intel.com with ESMTP; 22 Dec 2025 09:24:48 -0800
Received: from kbuild by dd3453e2b682 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vXjeI-000000000vV-0Dw5;
	Mon, 22 Dec 2025 17:24:46 +0000
Date: Tue, 23 Dec 2025 01:23:55 +0800
From: kernel test robot <lkp@intel.com>
To: Joanne Koong <joannelkoong@gmail.com>, miklos@szeredi.hu,
	axboe@kernel.dk
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, bschubert@ddn.com,
	asml.silence@gmail.com, io-uring@vger.kernel.org,
	csander@purestorage.com, xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 19/25] fuse: add io-uring kernel-managed buffer ring
Message-ID: <202512230043.PJcZViVh-lkp@intel.com>
References: <20251218083319.3485503-20-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218083319.3485503-20-joannelkoong@gmail.com>

Hi Joanne,

kernel test robot noticed the following build warnings:

[auto build test WARNING on axboe/for-next]
[also build test WARNING on linus/master v6.19-rc2 next-20251219]
[cannot apply to mszeredi-fuse/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Joanne-Koong/io_uring-kbuf-refactor-io_buf_pbuf_register-logic-into-generic-helpers/20251218-165107
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git for-next
patch link:    https://lore.kernel.org/r/20251218083319.3485503-20-joannelkoong%40gmail.com
patch subject: [PATCH v2 19/25] fuse: add io-uring kernel-managed buffer ring
config: um-randconfig-001-20251222 (https://download.01.org/0day-ci/archive/20251223/202512230043.PJcZViVh-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 185f5fd5ce4c65116ca8cf6df467a682ef090499)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251223/202512230043.PJcZViVh-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512230043.PJcZViVh-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from fs/fuse/dev_uring.c:7:
   In file included from fs/fuse/fuse_i.h:23:
   In file included from include/linux/backing-dev.h:16:
   In file included from include/linux/writeback.h:13:
   In file included from include/linux/blk_types.h:10:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from arch/um/include/asm/hardirq.h:24:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:12:
   In file included from arch/um/include/asm/io.h:24:
   include/asm-generic/io.h:1209:55: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
    1209 |         return (port > MMIO_UPPER_LIMIT) ? NULL : PCI_IOBASE + port;
         |                                                   ~~~~~~~~~~ ^
>> fs/fuse/dev_uring.c:704:35: warning: format specifies type 'unsigned long' but the argument has type 'size_t' (aka 'unsigned int') [-Wformat]
     703 |                                     "header_type=%u, header_size=%lu, "
         |                                                                  ~~~
         |                                                                  %zu
     704 |                                     "use_bufring=%d\n", type, header_size,
         |                                                               ^~~~~~~~~~~
   include/linux/printk.h:726:46: note: expanded from macro 'pr_info_ratelimited'
     726 |         printk_ratelimited(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
         |                                             ~~~     ^~~~~~~~~~~
   include/linux/printk.h:706:17: note: expanded from macro 'printk_ratelimited'
     706 |                 printk(fmt, ##__VA_ARGS__);                             \
         |                        ~~~    ^~~~~~~~~~~
   include/linux/printk.h:512:60: note: expanded from macro 'printk'
     512 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                                                     ~~~    ^~~~~~~~~~~
   include/linux/printk.h:484:19: note: expanded from macro 'printk_index_wrap'
     484 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                         ~~~~    ^~~~~~~~~~~
   fs/fuse/dev_uring.c:743:35: warning: format specifies type 'unsigned long' but the argument has type 'size_t' (aka 'unsigned int') [-Wformat]
     742 |                                     "header_type=%u, header_size=%lu, "
         |                                                                  ~~~
         |                                                                  %zu
     743 |                                     "use_bufring=%d\n", type, header_size,
         |                                                               ^~~~~~~~~~~
   include/linux/printk.h:726:46: note: expanded from macro 'pr_info_ratelimited'
     726 |         printk_ratelimited(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
         |                                             ~~~     ^~~~~~~~~~~
   include/linux/printk.h:706:17: note: expanded from macro 'printk_ratelimited'
     706 |                 printk(fmt, ##__VA_ARGS__);                             \
         |                        ~~~    ^~~~~~~~~~~
   include/linux/printk.h:512:60: note: expanded from macro 'printk'
     512 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                                                     ~~~    ^~~~~~~~~~~
   include/linux/printk.h:484:19: note: expanded from macro 'printk_index_wrap'
     484 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                         ~~~~    ^~~~~~~~~~~
   3 warnings generated.


vim +704 fs/fuse/dev_uring.c

   670	
   671	static __always_inline int copy_header_to_ring(struct fuse_ring_ent *ent,
   672						       enum fuse_uring_header_type type,
   673						       const void *header,
   674						       size_t header_size)
   675	{
   676		bool use_bufring = ent->queue->use_bufring;
   677		int err = 0;
   678	
   679		if (use_bufring) {
   680			struct iov_iter iter;
   681	
   682			err =  get_kernel_ring_header(ent, type, &iter);
   683			if (err)
   684				goto done;
   685	
   686			if (copy_to_iter(header, header_size, &iter) != header_size)
   687				err = -EFAULT;
   688		} else {
   689			void __user *ring = get_user_ring_header(ent, type);
   690	
   691			if (!ring) {
   692				err = -EINVAL;
   693				goto done;
   694			}
   695	
   696			if (copy_to_user(ring, header, header_size))
   697				err = -EFAULT;
   698		}
   699	
   700	done:
   701		if (err)
   702			pr_info_ratelimited("Copying header to ring failed: "
   703					    "header_type=%u, header_size=%lu, "
 > 704					    "use_bufring=%d\n", type, header_size,
   705					    use_bufring);
   706	
   707		return err;
   708	}
   709	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

