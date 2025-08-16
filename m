Return-Path: <io-uring+bounces-8986-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D3D0FB28CB1
	for <lists+io-uring@lfdr.de>; Sat, 16 Aug 2025 12:11:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 91E031CC632A
	for <lists+io-uring@lfdr.de>; Sat, 16 Aug 2025 10:11:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D79D28CF7A;
	Sat, 16 Aug 2025 10:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T79D3kzH"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B69E728CF5C;
	Sat, 16 Aug 2025 10:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755339064; cv=none; b=PDpr7gIMBoICsl4kqVpt603ZPIV0Iz0UI76hcOWcrO2aNjS/BnJtb7wfnzTgitZsu+rZdk2YxvBo8Zp7JHL3Y1KD74jeOjrMrNVn5Y6iqbKR2qzHk/WFm64hRFNcNBzBnCbwwKaf9bzGyhc9xJ9QRB8MZ0BmD+c3NcMMupTLc+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755339064; c=relaxed/simple;
	bh=axqTjNFlmphNfFORcQmFtJ3vQU2+7Fg2Z26+WcSA7r0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S4GOnxBFIXN9BkSLj88H10aujClfqrQ5s4nsZxroX9b10747BROhunLEPibtScbrqOTSnv+0+x9P9l2qFtW6LhbUKx6D9ebRQHyhNMIYOm2oxrPWyRjJeuIedB/Zs07IH/59fFOtnpyIzKhPeljN2LYnOLGh+0A/OoH1efgYthA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T79D3kzH; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755339062; x=1786875062;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=axqTjNFlmphNfFORcQmFtJ3vQU2+7Fg2Z26+WcSA7r0=;
  b=T79D3kzH+sTdIZFCORWXnle2/olgx1WJG6mdbeyrR52kWJmXIb1Ke4Li
   8349VcXxqfSh4HnLBttKqqKwczm13AhUndNPvuTINqjpKMvGi6OCdNtSG
   SZL4Ini/19mFPK4tnoHZHxLKkVPdA0MHUGXTvvOgCRcrCiGhNHxTaIj0J
   NAnKzCNf4lPn+NNsgbgJNMM8xIEG+485gjuPe0qJgokT+hJY5p2JxaCum
   ZWAkVFSMa8ex+AGDHge3gfLSduT/9NbRNCU+gRZ5H/xJE8wY7HIiIw9vT
   CWQhbI+jZ1reHkCuXmzm2NuDpqBHg/dezvC4JyVaw8TRrRl3BgLoPeXgT
   w==;
X-CSE-ConnectionGUID: X+DJaioYT0K8YQcyluUfXg==
X-CSE-MsgGUID: 3SALENQ9TtaaaspQUEFVog==
X-IronPort-AV: E=McAfee;i="6800,10657,11523"; a="61274085"
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="61274085"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2025 03:11:02 -0700
X-CSE-ConnectionGUID: wf4JgEWbQZ+I66zReqgvtg==
X-CSE-MsgGUID: 6b3a/uRcR8iSvvHTBhGd8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="198044644"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa001.fm.intel.com with ESMTP; 16 Aug 2025 03:10:59 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1unDro-000Cnw-2d;
	Sat, 16 Aug 2025 10:10:39 +0000
Date: Sat, 16 Aug 2025 18:10:13 +0800
From: kernel test robot <lkp@intel.com>
To: Thomas Bertschinger <tahbertschinger@gmail.com>,
	io-uring@vger.kernel.org, axboe@kernel.dk,
	linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
	brauner@kernel.org, linux-nfs@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev,
	Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: Re: [PATCH 6/6] io_uring: add support for IORING_OP_OPEN_BY_HANDLE_AT
Message-ID: <202508161702.2Ey3J7m9-lkp@intel.com>
References: <20250814235431.995876-7-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250814235431.995876-7-tahbertschinger@gmail.com>

Hi Thomas,

kernel test robot noticed the following build errors:

[auto build test ERROR on brauner-vfs/vfs.all]
[also build test ERROR on linus/master v6.17-rc1 next-20250815]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Thomas-Bertschinger/fhandle-create-helper-for-name_to_handle_at-2/20250815-075417
base:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git vfs.all
patch link:    https://lore.kernel.org/r/20250814235431.995876-7-tahbertschinger%40gmail.com
patch subject: [PATCH 6/6] io_uring: add support for IORING_OP_OPEN_BY_HANDLE_AT
config: parisc-randconfig-r132-20250816 (https://download.01.org/0day-ci/archive/20250816/202508161702.2Ey3J7m9-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 11.5.0
reproduce: (https://download.01.org/0day-ci/archive/20250816/202508161702.2Ey3J7m9-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508161702.2Ey3J7m9-lkp@intel.com/

All errors (new ones prefixed by >>):

   hppa-linux-ld: io_uring/openclose.o: in function `io_name_to_handle_at':
   io_uring/openclose.c:241:(.text+0x870): undefined reference to `do_name_to_handle_at'
   hppa-linux-ld: io_uring/openclose.o: in function `io_open_by_handle_at':
>> io_uring/openclose.c:287:(.text+0x990): undefined reference to `__do_handle_open'


vim +287 io_uring/openclose.c

   266	
   267	int io_open_by_handle_at(struct io_kiocb *req, unsigned int issue_flags)
   268	{
   269		struct io_open *open = io_kiocb_to_cmd(req, struct io_open);
   270		struct file *file;
   271		bool fixed = !!open->file_slot;
   272		int ret;
   273	
   274		/*
   275		 * Always try again if we aren't supposed to block, because there is no
   276		 * way of preventing the FS implementation from blocking.
   277		 */
   278		if (issue_flags & IO_URING_F_NONBLOCK)
   279			return -EAGAIN;
   280	
   281		if (!fixed) {
   282			ret = __get_unused_fd_flags(open->how.flags, open->nofile);
   283			if (ret < 0)
   284				goto err;
   285		}
   286	
 > 287		file = __do_handle_open(open->dfd, open->ufh, open->how.flags);
   288	
   289		if (IS_ERR(file)) {
   290			if (!fixed)
   291				put_unused_fd(ret);
   292			ret = PTR_ERR(file);
   293			goto err;
   294		}
   295	
   296		if (!fixed)
   297			fd_install(ret, file);
   298		else
   299			ret = io_fixed_fd_install(req, issue_flags, file,
   300						  open->file_slot);
   301	
   302	err:
   303		if (ret < 0)
   304			req_set_fail(req);
   305		io_req_set_res(req, ret, 0);
   306		return IOU_COMPLETE;
   307	}
   308	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

