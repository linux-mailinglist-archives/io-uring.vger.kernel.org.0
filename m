Return-Path: <io-uring+bounces-434-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0C87833403
	for <lists+io-uring@lfdr.de>; Sat, 20 Jan 2024 13:14:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B2C71C20F90
	for <lists+io-uring@lfdr.de>; Sat, 20 Jan 2024 12:14:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0271EACE;
	Sat, 20 Jan 2024 12:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fGIP8mTK"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0152DF4E;
	Sat, 20 Jan 2024 12:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.134.136.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705752885; cv=none; b=hVoRjqab2UVdCBw8/SBtnxLrEZl4sEagdN4CzywcZJyrZAaV1Svy2Xraz2eFMM7GHp22dTyItvNh+9h5/tave1xZiRc21ntV94lSyTyb6W9tNsYex0WXCPgGzFYPGsFap+uVeGoVQiwjjp9iGoU4R3hj/6aXDsAeSJR9OL+0Suc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705752885; c=relaxed/simple;
	bh=Ho3DF6crRTzmtv55CJ2tz0JrUawUaStPuH3do49eLb4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lx5IZoLfLbhR22rV3SIk9fJPyVEBAXXqdhGAer8vtlcMGsjXgPW/j40LtKgKIDiI/vVQLtLtmareTteCbB/59XnPqJV+WPDhUrFxsN5AcuxtBKtwgyHktkqJAijd6WzdLoj3INZdu0tBkKNKGq4NH/3LIf66XPEGufHwi5Vn9WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fGIP8mTK; arc=none smtp.client-ip=134.134.136.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705752883; x=1737288883;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Ho3DF6crRTzmtv55CJ2tz0JrUawUaStPuH3do49eLb4=;
  b=fGIP8mTK2IaF6+e/Ea4JJMFhP18pUT/W8KRMwmJm0kTWah3qYTn5seoV
   MR2HTLLagiZvwjxTnU0LHGgQFZ34kVDQ4oZAbQ4NTg+8pvbl1S3ZUmxhI
   VEnH6M0gnKW4UC10Es1t52t4bxlSIeLbubmTjbVwRorV9J4POqG4s3Zxg
   pimN8x+1J6dPy+DWxGVnBD9cgfUPvPMtAYb+tx2RIaLrdO4FCiyETxcEK
   g0lRrwkNb/9achn1kkgvOzPJdYAJHAmHuGlXzC120opOx1lVlMEwEUXD5
   DFzP33RRJBszayy7PQVHt0p74WYv3wHOTQsiYnR2GGtPvLg7r19HXy4Nx
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10957"; a="404703597"
X-IronPort-AV: E=Sophos;i="6.05,207,1701158400"; 
   d="scan'208";a="404703597"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2024 04:14:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,207,1701158400"; 
   d="scan'208";a="893937"
Received: from lkp-server01.sh.intel.com (HELO 961aaaa5b03c) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 20 Jan 2024 04:14:38 -0800
Received: from kbuild by 961aaaa5b03c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rRAFA-00054o-0v;
	Sat, 20 Jan 2024 12:14:36 +0000
Date: Sat, 20 Jan 2024 20:13:46 +0800
From: kernel test robot <lkp@intel.com>
To: Subramanya Swamy <subramanya.swamy.linux@gmail.com>, corbet@lwn.net,
	axboe@kernel.dk, asml.silence@gmail.com, ribalda@chromium.org,
	rostedt@goodmis.org, bhe@redhat.com, akpm@linux-foundation.org,
	matteorizzo@google.com, ardb@kernel.org, alexghiti@rivosinc.com,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH] iouring:added boundary value check for io_uring_group
 systl
Message-ID: <202401202013.dEvDNaAX-lkp@intel.com>
References: <20240115124925.1735-1-subramanya.swamy.linux@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240115124925.1735-1-subramanya.swamy.linux@gmail.com>

Hi Subramanya,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]
[also build test WARNING on linus/master v6.7 next-20240119]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Subramanya-Swamy/iouring-added-boundary-value-check-for-io_uring_group-systl/20240115-205112
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20240115124925.1735-1-subramanya.swamy.linux%40gmail.com
patch subject: [PATCH] iouring:added boundary value check for io_uring_group systl
config: i386-buildonly-randconfig-002-20240116 (https://download.01.org/0day-ci/archive/20240120/202401202013.dEvDNaAX-lkp@intel.com/config)
compiler: ClangBuiltLinux clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240120/202401202013.dEvDNaAX-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202401202013.dEvDNaAX-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> io_uring/io_uring.c:157:21: warning: unused variable 'min_gid' [-Wunused-variable]
     157 | static unsigned int min_gid;
         |                     ^~~~~~~
>> io_uring/io_uring.c:158:21: warning: unused variable 'max_gid' [-Wunused-variable]
     158 | static unsigned int max_gid  = 4294967294;  /*4294967294 is the max guid*/
         |                     ^~~~~~~
   2 warnings generated.


vim +/min_gid +157 io_uring/io_uring.c

   154	
   155	static int __read_mostly sysctl_io_uring_disabled;
   156	static unsigned int __read_mostly sysctl_io_uring_group;
 > 157	static unsigned int min_gid;
 > 158	static unsigned int max_gid  = 4294967294;  /*4294967294 is the max guid*/
   159	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

