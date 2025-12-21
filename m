Return-Path: <io-uring+bounces-11241-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 49403CD39C4
	for <lists+io-uring@lfdr.de>; Sun, 21 Dec 2025 03:29:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E0CBE300CB94
	for <lists+io-uring@lfdr.de>; Sun, 21 Dec 2025 02:28:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67C0F3B1B3;
	Sun, 21 Dec 2025 02:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M5k0SFts"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DB613FEE;
	Sun, 21 Dec 2025 02:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766284138; cv=none; b=YXlg+win4Gmql/vpeAYIeymmUXQJQ2gdrIe+DNPXrwS+s+6h6YLtxBHPVfQKq8sf5+BqA4BBvxQ56I4hd7r54CkKi60oReBsfX3iC2TCmCWk7TyO6LsRsdF4UIB53g5QEnEYAEwJnLbVs/T0XJ4f7TUDk2GCPVqFCpyBUnGKzWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766284138; c=relaxed/simple;
	bh=zWyOdYOZRlqUbz38ByLXJzsPNEXfBPqSvhxivGTIwEo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tMwLgcqEMKC9tGJRSubBFk52DJm3zLEBLr6gZWQyylKS1g/Q6bifx48+m9oSV8wny1YAIVeDcQdsoZaIa1lp+fSp4Ema5mf7hBCakuuPAhyfQmJK8fb3RygBFzO6Q+N+KZpt3xfhweVxpKiE5gO4j/wF+iMIaQ0xDyWV/7Kt8nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M5k0SFts; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766284136; x=1797820136;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zWyOdYOZRlqUbz38ByLXJzsPNEXfBPqSvhxivGTIwEo=;
  b=M5k0SFts1dZqYYG7zBK+vgEW+q27Lq1F0EUbNI7jOskXOwhkxJ51LEKP
   +I55TejDZvvuYcdMOVnDvMD040T/GkgPL/kmf9LfpAkfiU/ehsKdbhJNE
   hh4YxjY2feBSo9hfg9+dVCYBhs6k9R3gVxKF6W289LVscXoenquvnMGYj
   PhDVMmNcCyPZ2Z6lh4euAU3jKZHiuN8QifPCXSGxYgehzIw7FBebJE45p
   GOGzqHANBFSgt4aGRGtx8XyHSVhhi6FNDn4utF/RcQZWvj3kBBETFUq2u
   soCNhoQnuI2m9rQyfXOYbFiEvVHqQ3x3W7UB6V/D83F8CuTf0VAcUoPOo
   A==;
X-CSE-ConnectionGUID: hvUoNfwQSZqjkqukg15kVQ==
X-CSE-MsgGUID: ELEHYw3IS9GnDsJ5Ai8mWQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="68128990"
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="68128990"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2025 18:28:55 -0800
X-CSE-ConnectionGUID: Lxp/T6RbTMyH3M7dsh0EBQ==
X-CSE-MsgGUID: XQdHALwPQQ+4ydY6QC/i8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="203727498"
Received: from igk-lkp-server01.igk.intel.com (HELO 8a0c053bdd2a) ([10.211.93.152])
  by orviesa004.jf.intel.com with ESMTP; 20 Dec 2025 18:28:53 -0800
Received: from kbuild by 8a0c053bdd2a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vX9Bi-000000004u0-3gxE;
	Sun, 21 Dec 2025 02:28:50 +0000
Date: Sun, 21 Dec 2025 03:28:25 +0100
From: kernel test robot <lkp@intel.com>
To: Joanne Koong <joannelkoong@gmail.com>, miklos@szeredi.hu,
	axboe@kernel.dk
Cc: oe-kbuild-all@lists.linux.dev, bschubert@ddn.com,
	asml.silence@gmail.com, io-uring@vger.kernel.org,
	csander@purestorage.com, xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 25/25] docs: fuse: add io-uring bufring and zero-copy
 documentation
Message-ID: <202512210331.Yc46M5Rg-lkp@intel.com>
References: <20251218083319.3485503-26-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218083319.3485503-26-joannelkoong@gmail.com>

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
patch link:    https://lore.kernel.org/r/20251218083319.3485503-26-joannelkoong%40gmail.com
patch subject: [PATCH v2 25/25] docs: fuse: add io-uring bufring and zero-copy documentation
reproduce: (https://download.01.org/0day-ci/archive/20251221/202512210331.Yc46M5Rg-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512210331.Yc46M5Rg-lkp@intel.com/

All warnings (new ones prefixed by >>):

   ERROR: Cannot find file ./include/linux/fscache.h
   WARNING: No kernel-doc for file ./include/linux/fscache.h
   ERROR: Cannot find file ./include/linux/fiemap.h
   WARNING: No kernel-doc for file ./include/linux/fiemap.h
   Documentation/filesystems/fuse/fuse-io-uring.rst:103: ERROR: Unexpected indentation. [docutils]
>> Documentation/filesystems/fuse/fuse-io-uring.rst:104: WARNING: Block quote ends without a blank line; unexpected unindent. [docutils]
   Documentation/filesystems/fuse/fuse-io-uring.rst:112: ERROR: Unexpected indentation. [docutils]
   Documentation/filesystems/fuse/fuse-io-uring.rst:115: WARNING: Block quote ends without a blank line; unexpected unindent. [docutils]
   Documentation/filesystems/fuse/fuse-io-uring.rst:140: ERROR: Unexpected indentation. [docutils]
   Documentation/filesystems/fuse/fuse-io-uring.rst:141: WARNING: Block quote ends without a blank line; unexpected unindent. [docutils]
   ERROR: Cannot find file ./include/linux/jbd2.h


vim +104 Documentation/filesystems/fuse/fuse-io-uring.rst

   100	
   101	Kernel-managed buffer rings have two main advantages:
   102	* eliminates the overhead of pinning/unpinning user pages and translating
 > 103	  virtual addresses for every server-kernel interaction
 > 104	* reduces buffer memory allocation requirements
   105	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

