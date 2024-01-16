Return-Path: <io-uring+bounces-406-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 502CA82FCA6
	for <lists+io-uring@lfdr.de>; Tue, 16 Jan 2024 23:26:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9F10DB26E79
	for <lists+io-uring@lfdr.de>; Tue, 16 Jan 2024 22:25:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2916631752;
	Tue, 16 Jan 2024 21:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I+IRHN1S"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD502EAEA;
	Tue, 16 Jan 2024 21:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705440457; cv=none; b=aF55CiQqrSPfIfGlWiX9pjHu8dbRRom7QhDfva+pbBCOxFml4+B0Baoj3YVF2LTPuFaPYDbZPkNv5VVGSVoFjTRh1VNWCL4643TcvR09mZcuI7XTWkPFHCHvgD1dUg8cgm6nxzNJ1E4NgRYdLdOadMqe5Q69FKuxxNrDpLnQr1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705440457; c=relaxed/simple;
	bh=SLPMdKVtmRbSltsx06ZScUJ6qCa6a3f0g1WFofzyiDI=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:X-IronPort-AV:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=gIMD6lJ7oPWKqcasBjvVoCiB7BgvaTMi+CX/SR7mfu/NM8T2sNbOsD6pe8RYdHdO/9c3yHz+GY/T3QuDg6yAD/pXo5q60tkqCh575rJJJzcc+OqV0wzq6ZqNFDxdHto8+bQK/4iQl6TNQ3YqmygKw1er5jbZuZsewF2jQdReErk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I+IRHN1S; arc=none smtp.client-ip=192.55.52.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705440455; x=1736976455;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SLPMdKVtmRbSltsx06ZScUJ6qCa6a3f0g1WFofzyiDI=;
  b=I+IRHN1SbNHNeeZYg+ZA9avzmBMse9xsTHHOtRDja20uQnff9WzRmON1
   NTWWrkScnHMLi++LF3SIaIwPGJlSKk0qyeGKnCBdQSQVjG1cj41q9mraC
   ESW0su8Nu42vvLc5pztFq9VGImtGenqEL1DBMzKdIb7U8yA3ASkRg2fZR
   xRfga8IsTRbUTAySVy0zw2abd9Ht3kbsEIV1MyPBOEGfDliM4j4lRBcAd
   FyAOFBhknlxaCkorVjibnkiB5tTIlLFeLhZ80U67IIk6pkgL3hch4IvSp
   CO1VC7+cYtlPH7pCAoIS0Zsx5LzUM+zHCNLxlTa1HzmSP07xDGn4UhsWY
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10955"; a="486149264"
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400"; 
   d="scan'208";a="486149264"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2024 13:27:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10955"; a="787585732"
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400"; 
   d="scan'208";a="787585732"
Received: from lkp-server01.sh.intel.com (HELO 961aaaa5b03c) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 16 Jan 2024 13:27:31 -0800
Received: from kbuild by 961aaaa5b03c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rPqy1-0001G8-07;
	Tue, 16 Jan 2024 21:27:29 +0000
Date: Wed, 17 Jan 2024 05:26:59 +0800
From: kernel test robot <lkp@intel.com>
To: Subramanya Swamy <subramanya.swamy.linux@gmail.com>, corbet@lwn.net,
	axboe@kernel.dk, asml.silence@gmail.com, ribalda@chromium.org,
	rostedt@goodmis.org, bhe@redhat.com, akpm@linux-foundation.org,
	matteorizzo@google.com, ardb@kernel.org, alexghiti@rivosinc.com,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH] iouring:added boundary value check for io_uring_group
 systl
Message-ID: <202401170507.IOhrswHN-lkp@intel.com>
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
[also build test WARNING on linus/master v6.7 next-20240112]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Subramanya-Swamy/iouring-added-boundary-value-check-for-io_uring_group-systl/20240115-205112
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20240115124925.1735-1-subramanya.swamy.linux%40gmail.com
patch subject: [PATCH] iouring:added boundary value check for io_uring_group systl
config: sparc-randconfig-r122-20240116 (https://download.01.org/0day-ci/archive/20240117/202401170507.IOhrswHN-lkp@intel.com/config)
compiler: sparc-linux-gcc (GCC) 13.2.0
reproduce: (https://download.01.org/0day-ci/archive/20240117/202401170507.IOhrswHN-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202401170507.IOhrswHN-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> io_uring/io_uring.c:158:21: warning: 'max_gid' defined but not used [-Wunused-variable]
     158 | static unsigned int max_gid  = 4294967294;  /*4294967294 is the max guid*/
         |                     ^~~~~~~
>> io_uring/io_uring.c:157:21: warning: 'min_gid' defined but not used [-Wunused-variable]
     157 | static unsigned int min_gid;
         |                     ^~~~~~~


vim +/max_gid +158 io_uring/io_uring.c

   154	
   155	static int __read_mostly sysctl_io_uring_disabled;
   156	static unsigned int __read_mostly sysctl_io_uring_group;
 > 157	static unsigned int min_gid;
 > 158	static unsigned int max_gid  = 4294967294;  /*4294967294 is the max guid*/
   159	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

