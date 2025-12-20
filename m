Return-Path: <io-uring+bounces-11239-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7527ACD3884
	for <lists+io-uring@lfdr.de>; Sat, 20 Dec 2025 23:46:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3FE02300F30B
	for <lists+io-uring@lfdr.de>; Sat, 20 Dec 2025 22:46:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7744021CA0D;
	Sat, 20 Dec 2025 22:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y7CzfPzS"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DABBF2222A1;
	Sat, 20 Dec 2025 22:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766270768; cv=none; b=a9n6x/MvMzUY7UCYdevZQxR92zkvBJONte2fJaiTZvJOd40boQQh6RZIEJOTEboI51YGqx9FBUeIK4XKRadyMZQd+vAYbhz5dg6HglrPZoa1Pzzy30ceCYrjywk7h37/Qoo8RyUvciKgwuTbVRtKwaGo8F0wPM5xUYCnVN+idw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766270768; c=relaxed/simple;
	bh=bqV5TyU5J/Ga+U3o+uzi9ZFeOmqgF6sTivCW7bXDCpY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vy7CUpov5eDTHkDanTFdhNUaXjshjjJ06R3jKnhsTZ5X14Du2r6vZu3WQ0fgEZ6EG4MrvGee99fnrBfB5IeZQ7H/KsXZ6JAiifOAF5RCLYW94R4g3gftelkd2v3UX3XrF9co2g3d6ezlsvKhHiALqxw715Ct4xXWP9dToPMxLps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y7CzfPzS; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766270764; x=1797806764;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bqV5TyU5J/Ga+U3o+uzi9ZFeOmqgF6sTivCW7bXDCpY=;
  b=Y7CzfPzSohgSeU8t1ca7l/zWKmx8PWlZuNiv8/QCTbHFuhVkfH2/y9RR
   WTFo2EHtIpLQj6cWKLdxgqjMMzu0yY6T7+riQdd/Y/Mk8w+KQOUk9KN4c
   FYAcQOmFH1ubyd6PrjJy9ahmMya3NWrY5zZqGYUZ7o9wlOdeK0G60bcD6
   0Zbn4cz4Yw78qlnxDeA6KscFIT96cH5H2WzZHTwOPtyHMh+U9p1ysj43S
   mSDfdug9NIaO0WSTfIVh0/ozZZ66aTq6PhUAH52G7Gp0o39ARPQTv0YFx
   aU8DARI3VmRxdijDuz7BGo3WA5Y7kKfXgXHSsUx2KDEWixsglgoKNvmGT
   g==;
X-CSE-ConnectionGUID: HoR8fgTOThq2hZSDT6ppcQ==
X-CSE-MsgGUID: 8p+1s+8jQ7mE+i+swZKy1w==
X-IronPort-AV: E=McAfee;i="6800,10657,11648"; a="68265779"
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="68265779"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2025 14:46:03 -0800
X-CSE-ConnectionGUID: 92vZp5oCQDGEOwhHHWekaA==
X-CSE-MsgGUID: jDdV41mOSliyssVkLrf9qw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="204118978"
Received: from igk-lkp-server01.igk.intel.com (HELO 8a0c053bdd2a) ([10.211.93.152])
  by fmviesa004.fm.intel.com with ESMTP; 20 Dec 2025 14:45:49 -0800
Received: from kbuild by 8a0c053bdd2a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vX5hq-000000004oG-266s;
	Sat, 20 Dec 2025 22:45:46 +0000
Date: Sat, 20 Dec 2025 23:45:03 +0100
From: kernel test robot <lkp@intel.com>
To: Joanne Koong <joannelkoong@gmail.com>, miklos@szeredi.hu,
	axboe@kernel.dk
Cc: oe-kbuild-all@lists.linux.dev, bschubert@ddn.com,
	asml.silence@gmail.com, io-uring@vger.kernel.org,
	csander@purestorage.com, xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 19/25] fuse: add io-uring kernel-managed buffer ring
Message-ID: <202512202342.AGVIgnBx-lkp@intel.com>
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
[also build test WARNING on linus/master v6.19-rc1 next-20251219]
[cannot apply to mszeredi-fuse/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Joanne-Koong/io_uring-kbuf-refactor-io_buf_pbuf_register-logic-into-generic-helpers/20251218-165107
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git for-next
patch link:    https://lore.kernel.org/r/20251218083319.3485503-20-joannelkoong%40gmail.com
patch subject: [PATCH v2 19/25] fuse: add io-uring kernel-managed buffer ring
config: i386-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20251220/202512202342.AGVIgnBx-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251220/202512202342.AGVIgnBx-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512202342.AGVIgnBx-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> fs/fuse/dev_uring.c:704:35: warning: format specifies type 'unsigned long' but the argument has type 'size_t' (aka 'unsigned int') [-Wformat]
     703 |                                     "header_type=%u, header_size=%lu, "
         |                                                                  ~~~
         |                                                                  %zu
     704 |                                     "use_bufring=%d\n", type, header_size,
         |                                                               ^~~~~~~~~~~
   ./include/linux/printk.h:726:46: note: expanded from macro 'pr_info_ratelimited'
     726 |         printk_ratelimited(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
         |                                             ~~~     ^~~~~~~~~~~
   ./include/linux/printk.h:706:17: note: expanded from macro 'printk_ratelimited'
     706 |                 printk(fmt, ##__VA_ARGS__);                             \
         |                        ~~~    ^~~~~~~~~~~
   ./include/linux/printk.h:512:60: note: expanded from macro 'printk'
     512 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                                                     ~~~    ^~~~~~~~~~~
   ./include/linux/printk.h:484:19: note: expanded from macro 'printk_index_wrap'
     484 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                         ~~~~    ^~~~~~~~~~~
   fs/fuse/dev_uring.c:743:35: warning: format specifies type 'unsigned long' but the argument has type 'size_t' (aka 'unsigned int') [-Wformat]
     742 |                                     "header_type=%u, header_size=%lu, "
         |                                                                  ~~~
         |                                                                  %zu
     743 |                                     "use_bufring=%d\n", type, header_size,
         |                                                               ^~~~~~~~~~~
   ./include/linux/printk.h:726:46: note: expanded from macro 'pr_info_ratelimited'
     726 |         printk_ratelimited(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
         |                                             ~~~     ^~~~~~~~~~~
   ./include/linux/printk.h:706:17: note: expanded from macro 'printk_ratelimited'
     706 |                 printk(fmt, ##__VA_ARGS__);                             \
         |                        ~~~    ^~~~~~~~~~~
   ./include/linux/printk.h:512:60: note: expanded from macro 'printk'
     512 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                                                     ~~~    ^~~~~~~~~~~
   ./include/linux/printk.h:484:19: note: expanded from macro 'printk_index_wrap'
     484 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                         ~~~~    ^~~~~~~~~~~
   2 warnings generated.


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

