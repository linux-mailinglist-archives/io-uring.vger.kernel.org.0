Return-Path: <io-uring+bounces-8985-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F3670B28B7F
	for <lists+io-uring@lfdr.de>; Sat, 16 Aug 2025 09:44:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF8722A5FE1
	for <lists+io-uring@lfdr.de>; Sat, 16 Aug 2025 07:44:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F99042A9D;
	Sat, 16 Aug 2025 07:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S3IiG5ii"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E898F22D4C3;
	Sat, 16 Aug 2025 07:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755330295; cv=none; b=m7VgHeGJE86muyLGo2T7KoTbrq+i82w+xsEGp4ObaQoU/dBSMznkjNud6egHttIrySuDgmKqTAa3qerDm/Ipo7O/UfL/VLwejP9kNsypsKcQsQGmspKzftoBDuZ3z/wgtVLgz3g/qEmwerFQpLawCB2QijwNI1JY2OlME119uCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755330295; c=relaxed/simple;
	bh=FDTVrovJiNTKEaABlXLg4LIyv1BzW1WJIThardotLaA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cEjYpGFVTJxk793JvFN0Sy+6+o2fdhMCjV/f5szZaRPGX+Ww53EMk45ilpm4EwBLHuqVtYOVp2Es/gjH6ia9rZ202clncFnPZQdxgJKIXbXeuBfNfaqWM2hT6T6RUBUJzQ5+OqCFysFaQX3412JfhowZCA72tzxj1zH+YQ9bvLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S3IiG5ii; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755330292; x=1786866292;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FDTVrovJiNTKEaABlXLg4LIyv1BzW1WJIThardotLaA=;
  b=S3IiG5iiShUpHP1FemnKH6NQbWdMxQOEenBt8ttPhE5AVsIDedC+2m3/
   RXiNQOJpStBE2Q4yni7gojjj5kKG8HR5WjRIa5UxjMXw3ouxdnXxVKNmP
   0WMLTDNhRN3/+BbHNY6+SoxuwjVjwL/SY7q5+ro8Ob23TN804umn9CAUD
   zlDeCUPiMW1bH91UaFSwacBec9RPatgC+MR/S1dJu1MJ+Ww/reFr32VMj
   zFUXpj6GrkSMmVgQ5UFXZOy6qHz6Y/jUvwlgBBwtvvmOB8+dP/RHSxsQx
   xZ0cpTiNvuir9t0tjHK7bAyRpF5VMGavs1OoBJ8zo7sk/8X2Oxi16Q5H3
   Q==;
X-CSE-ConnectionGUID: shjyrv9aRym9W1X2db4+iw==
X-CSE-MsgGUID: zdtiI+aXSs+o7//gG28Ekg==
X-IronPort-AV: E=McAfee;i="6800,10657,11523"; a="61270501"
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="61270501"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2025 00:44:51 -0700
X-CSE-ConnectionGUID: xd+UO464SjyvQM+D85GEKg==
X-CSE-MsgGUID: HEW+kR6mRFmysny/LchRpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="172512746"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa005.jf.intel.com with ESMTP; 16 Aug 2025 00:44:46 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1unBaf-000CgW-09;
	Sat, 16 Aug 2025 07:44:37 +0000
Date: Sat, 16 Aug 2025 15:43:38 +0800
From: kernel test robot <lkp@intel.com>
To: Thomas Bertschinger <tahbertschinger@gmail.com>,
	io-uring@vger.kernel.org, axboe@kernel.dk,
	linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
	brauner@kernel.org, linux-nfs@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev,
	Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: Re: [PATCH 2/6] io_uring: add support for IORING_OP_NAME_TO_HANDLE_AT
Message-ID: <202508161506.L391RGhx-lkp@intel.com>
References: <20250814235431.995876-3-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250814235431.995876-3-tahbertschinger@gmail.com>

Hi Thomas,

kernel test robot noticed the following build errors:

[auto build test ERROR on brauner-vfs/vfs.all]
[also build test ERROR on linus/master v6.17-rc1 next-20250815]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Thomas-Bertschinger/fhandle-create-helper-for-name_to_handle_at-2/20250815-075417
base:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git vfs.all
patch link:    https://lore.kernel.org/r/20250814235431.995876-3-tahbertschinger%40gmail.com
patch subject: [PATCH 2/6] io_uring: add support for IORING_OP_NAME_TO_HANDLE_AT
config: parisc-randconfig-r132-20250816 (https://download.01.org/0day-ci/archive/20250816/202508161506.L391RGhx-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 11.5.0
reproduce: (https://download.01.org/0day-ci/archive/20250816/202508161506.L391RGhx-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508161506.L391RGhx-lkp@intel.com/

All errors (new ones prefixed by >>):

   hppa-linux-ld: io_uring/openclose.o: in function `io_name_to_handle_at':
>> io_uring/openclose.c:221:(.text+0x838): undefined reference to `do_name_to_handle_at'


vim +221 io_uring/openclose.c

   211	
   212	int io_name_to_handle_at(struct io_kiocb *req, unsigned int issue_flags)
   213	{
   214		struct io_name_to_handle *nh = io_kiocb_to_cmd(req, struct io_name_to_handle);
   215		int lookup_flags = 0;
   216		long ret;
   217	
   218		if (issue_flags & IO_URING_F_NONBLOCK)
   219			lookup_flags = LOOKUP_CACHED;
   220	
 > 221		ret = do_name_to_handle_at(nh->dfd, nh->path, nh->ufh, nh->mount_id,
   222					   nh->open_flag, lookup_flags);
   223	
   224		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
   225			return -EAGAIN;
   226	
   227		if (ret < 0)
   228			req_set_fail(req);
   229		io_req_set_res(req, ret, 0);
   230		return IOU_COMPLETE;
   231	}
   232	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

