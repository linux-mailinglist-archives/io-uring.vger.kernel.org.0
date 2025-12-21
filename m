Return-Path: <io-uring+bounces-11240-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id ECE9ECD39BD
	for <lists+io-uring@lfdr.de>; Sun, 21 Dec 2025 03:11:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 14954300D176
	for <lists+io-uring@lfdr.de>; Sun, 21 Dec 2025 02:10:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8285F10F2;
	Sun, 21 Dec 2025 02:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Dhzf4v3w"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4274817A30A;
	Sun, 21 Dec 2025 02:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766283058; cv=none; b=HNkkcPHgnvN+GD0/upBqrd7gFTGJCL3ibJKU5IwY6JFIlD8zhBn+Ml/J2ADFvUQgsXe3qexIcnQOVMLmbhQliSvJTe2xyh2Q4wGSsF2aWnJqfO4/mUDP0saqHnw15tKsM9d+JGmBNKJVheEejnYODPL+YClDiNy3CIZJ61guMW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766283058; c=relaxed/simple;
	bh=56kGoDHWLGE+H+rnmh/Ft03FSl8vKIz5buC2Xe0Y3i4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S3dkv9c5tCGoyYFviuYVl3yG8bz+zzHgCL+kqS/sS5RUiHCUfUfeuq+2Dy6SzoOl3+vfy1CJzZktpE9AK4+Z6jthJapCDN3Fs0K2BRXDOG2HCA+EBS4zhq0K20lvxXLfGJLo7KDNyxRfD6GB166dCmZ5e7VDFUvFaivtuPCGySI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Dhzf4v3w; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766283056; x=1797819056;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=56kGoDHWLGE+H+rnmh/Ft03FSl8vKIz5buC2Xe0Y3i4=;
  b=Dhzf4v3w+v+pdozfAtiiawtPkf1irn3JVLQ1rCv7fJAa+HoHcCwO3oVk
   4YVV71xBTsHgz7Fc45CTs9D7IqBl2d9MLvbeafJ1ZBPDztlnNgNkmfVQh
   mXzUkErFf+grTE/bXWHapUDWQNSPTP7Nanh9kM31X5HxwoDN2Ky+7NLiu
   d5M497mcJvUGfDsINVfB3U+lB8xU6GpLicPIP58JzG0DQKlhjnOUxpMRq
   WqCdahpxsdqTNYBqdl59duts4TFX0SyAJucnLbzLsmCWHZTBsqxs1hL/0
   pC+6rnMWrxEHEkSb40jTqAwIn6BWYrcrYgoPmothKsr8a7TOl3ihUWuke
   A==;
X-CSE-ConnectionGUID: aJF8n7vmRFuu4GZ6PZu2ug==
X-CSE-MsgGUID: W588IkjJSEi7UxHbO2UO1A==
X-IronPort-AV: E=McAfee;i="6800,10657,11648"; a="78510142"
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="78510142"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2025 18:10:55 -0800
X-CSE-ConnectionGUID: S922zZlZSh6/mF2nVJBrxg==
X-CSE-MsgGUID: BI+sPBhTSb+C+b1wGwVy1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="200089274"
Received: from igk-lkp-server01.igk.intel.com (HELO 8a0c053bdd2a) ([10.211.93.152])
  by fmviesa010.fm.intel.com with ESMTP; 20 Dec 2025 18:10:52 -0800
Received: from kbuild by 8a0c053bdd2a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vX8uI-000000004tg-2lXI;
	Sun, 21 Dec 2025 02:10:50 +0000
Date: Sun, 21 Dec 2025 03:10:22 +0100
From: kernel test robot <lkp@intel.com>
To: Joanne Koong <joannelkoong@gmail.com>, miklos@szeredi.hu,
	axboe@kernel.dk
Cc: oe-kbuild-all@lists.linux.dev, bschubert@ddn.com,
	asml.silence@gmail.com, io-uring@vger.kernel.org,
	csander@purestorage.com, xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 19/25] fuse: add io-uring kernel-managed buffer ring
Message-ID: <202512210325.13rE0qzj-lkp@intel.com>
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

kernel test robot noticed the following build errors:

[auto build test ERROR on axboe/for-next]
[also build test ERROR on linus/master v6.19-rc1 next-20251219]
[cannot apply to mszeredi-fuse/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Joanne-Koong/io_uring-kbuf-refactor-io_buf_pbuf_register-logic-into-generic-helpers/20251218-165107
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git for-next
patch link:    https://lore.kernel.org/r/20251218083319.3485503-20-joannelkoong%40gmail.com
patch subject: [PATCH v2 19/25] fuse: add io-uring kernel-managed buffer ring
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20251221/202512210325.13rE0qzj-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251221/202512210325.13rE0qzj-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512210325.13rE0qzj-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from <command-line>:
>> ./usr/include/linux/fuse.h:1310:25: error: unknown type name 'bool'
    1310 |                         bool use_bufring;
         |                         ^~~~

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

