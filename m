Return-Path: <io-uring+bounces-11027-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EEECCB95B8
	for <lists+io-uring@lfdr.de>; Fri, 12 Dec 2025 17:51:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5667C3014F6B
	for <lists+io-uring@lfdr.de>; Fri, 12 Dec 2025 16:51:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 044AA2C1595;
	Fri, 12 Dec 2025 16:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ag17266z"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F8D26CE33;
	Fri, 12 Dec 2025 16:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765558278; cv=none; b=d10gnGPOIOdzIr6D3z59Hpvh+SVG3nhTm7TRoj/EBpSboM3cv4V7Tk+vCibZFelHON/sy7JUO/zNwv5WcwbM93/ieV6i96mypZVPmrFBWVlXMkeLlbJjFgHXFQGhG90iGCWXAOe/4NhAyaXpbmBbSikRAfeqdAIbaJiGiYkUM/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765558278; c=relaxed/simple;
	bh=WoUBnN3FNLrieQtztiSM/G+ujxyyjWUBmik66D48fvs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iU1RTpzX83T4RsK+gtjfydrF809t8jiNXI61U86UGgmwzmVHdcHrgzZbuS+iZA4oMa6lPuxGOIBfaqgwdU/sFZvZJNX7K9zMhMV2mAJ7EoHKnv24kaOUkNVHdEyVTRMEp9dGaaaS8uEh8a36drzKvyAsEaF5osL90Ocabjbvy7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ag17266z; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765558276; x=1797094276;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WoUBnN3FNLrieQtztiSM/G+ujxyyjWUBmik66D48fvs=;
  b=Ag17266z+uLfSl3t3ufc/85dUvEhBa5Bkvi9Mbc5QmtLyoTzNqFkz8hj
   yIkyha6V38pdDMAS/wXXJSxU3Inwamnv0RD0wRANu/occySTgWcGDHN1w
   DMtbWvZq2W5BSKcmeXb3/jm6Cnq/5R7S5TaTAJR/PMlf1CvWJyQxvVo03
   azgQQs/IdyYJH8w9GhSuIuHqC9+q/j02rMBx9tbc2rGzCcJKhAWf8GrDh
   Q/flStowApvgCs7MdEw+xciiTdYTp1Gr8eX0vJeAiX+okWVSWuCiOLl/d
   Lj8uFMHvE+2RqHGwYKylkT/KNOCLoMyka7w/WFNcoDR5ayirIZAek3oXq
   w==;
X-CSE-ConnectionGUID: 4BU0Kb+RRLCRTz5J6JVcPA==
X-CSE-MsgGUID: aumw/ebTQLadfGZbydktJQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11640"; a="67439900"
X-IronPort-AV: E=Sophos;i="6.21,144,1763452800"; 
   d="scan'208";a="67439900"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2025 08:51:14 -0800
X-CSE-ConnectionGUID: X+zbKeBpQm6lUfzWLFWTjw==
X-CSE-MsgGUID: A2jZJyX9RdW/W9RrZxeRsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,144,1763452800"; 
   d="scan'208";a="197031500"
Received: from lkp-server01.sh.intel.com (HELO d335e3c6db51) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 12 Dec 2025 08:51:10 -0800
Received: from kbuild by d335e3c6db51 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vU6MF-000000006Jl-2vjm;
	Fri, 12 Dec 2025 16:51:07 +0000
Date: Sat, 13 Dec 2025 00:50:12 +0800
From: kernel test robot <lkp@intel.com>
To: Xiaobing Li <xiaobing.li@samsung.com>, miklos@szeredi.hu,
	axboe@kernel.dk
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	bschubert@ddn.com, asml.silence@gmail.com, joannelkoong@gmail.com,
	dw@davidwei.uk, josef@toxicpanda.com, kbusch@kernel.org,
	peiwei.li@samsung.com, joshi.k@samsung.com,
	Xiaobing Li <xiaobing.li@samsung.com>
Subject: Re: [PATCH] fuse: add zero-copy to fuse-over-io_uring
Message-ID: <202512130032.tLxDKB6B-lkp@intel.com>
References: <20251204082536.17349-1-xiaobing.li@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204082536.17349-1-xiaobing.li@samsung.com>

Hi Xiaobing,

kernel test robot noticed the following build errors:

[auto build test ERROR on mszeredi-fuse/for-next]
[also build test ERROR on linus/master v6.18 next-20251212]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Xiaobing-Li/fuse-add-zero-copy-to-fuse-over-io_uring/20251204-165924
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-next
patch link:    https://lore.kernel.org/r/20251204082536.17349-1-xiaobing.li%40samsung.com
patch subject: [PATCH] fuse: add zero-copy to fuse-over-io_uring
config: hexagon-randconfig-002-20251212 (https://download.01.org/0day-ci/archive/20251213/202512130032.tLxDKB6B-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 1335a05ab8bc8339ce24be3a9da89d8c3f4e0571)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251213/202512130032.tLxDKB6B-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512130032.tLxDKB6B-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from fs/fuse/trace.c:6:
>> fs/fuse/dev_uring_i.h:43:18: error: field has incomplete type 'struct iov_iter'
      43 |         struct iov_iter payload_iter;
         |                         ^
   include/linux/fs.h:74:8: note: forward declaration of 'struct iov_iter'
      74 | struct iov_iter;
         |        ^
   1 error generated.


vim +43 fs/fuse/dev_uring_i.h

    38	
    39	/** A fuse ring entry, part of the ring queue */
    40	struct fuse_ring_ent {
    41		bool zero_copy;
    42	
  > 43		struct iov_iter payload_iter;
    44	
    45		/* userspace buffer */
    46		struct fuse_uring_req_header __user *headers;
    47		void __user *payload;
    48	
    49		/* the ring queue that owns the request */
    50		struct fuse_ring_queue *queue;
    51	
    52		/* fields below are protected by queue->lock */
    53	
    54		struct io_uring_cmd *cmd;
    55	
    56		struct list_head list;
    57	
    58		enum fuse_ring_req_state state;
    59	
    60		struct fuse_req *fuse_req;
    61	};
    62	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

