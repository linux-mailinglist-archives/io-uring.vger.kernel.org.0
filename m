Return-Path: <io-uring+bounces-5443-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C3239ED33B
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 18:19:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A353D18886A9
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 17:19:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 332E11DED63;
	Wed, 11 Dec 2024 17:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lDCNT4zz"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456DD1DE893;
	Wed, 11 Dec 2024 17:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733937539; cv=none; b=kOcuWPujQdjgnGwclrbSqUPzriZsOM96C/0AjtaOOoWJQBuQkfpsR5JvbHNrSY00WCg6SDlbQQtS2nbPsWEgcS7oeUDBtYVJD0Twt/NSSYa4pqgz/C0oQW1M+VSmW4/F+KwH/kY4gr+aAbrJNL55XpiPGMZtSpHGfhSVDXz/hx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733937539; c=relaxed/simple;
	bh=cO5FxiswgNGKsLtgOEU4kMDK52juWwgnR3QMy56n1mk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oSQ4NL6CPx4ySLW83KbZxgAwLQ5hOb4jOoX9gmEX1f+z5yzSQcaYvioJUTJv+OTA2zxTTOwBgKfvJA/7GKACs9p5GIFXIp6d90UEB4v507LAFKWI6EA3eseobep2E41NkYNNcXJ0EgMGeXK4Oh3C+/wJRAGQ5uG9d3/MjG1JYYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lDCNT4zz; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733937537; x=1765473537;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cO5FxiswgNGKsLtgOEU4kMDK52juWwgnR3QMy56n1mk=;
  b=lDCNT4zzVX+Ma8zZx/Y3OZtytmPXb+OCIA6/jZV+T2nQ/xyKutQUW4/z
   EGu6g9aIO5tb7XFHGlzEe/DPqoz0f2yxMagHOrxi8GMlYO9NarVJZw2pD
   hqoGTU+BVWSUszycY5xsqFRtrHQyxaxZyIAvhyUpmviOTdrcIHJjfhY4q
   oMaBuHAMC13A8d+uyVQM1Bkvu17YpR8b+haJgJb45C351jGUvDSC2LZS3
   xsqo6Oui4ScSx/vsORiEPD/tsvMuudORPKdnMm9im/X6fP4Owggd9Ca6l
   SG8EAKUeBBFllneVV0vDWQmJBvj5MGJrgmeXZZEPdAzxjYdKm/3wAdFu5
   A==;
X-CSE-ConnectionGUID: LVImACJnSeiR41yNE1a8VQ==
X-CSE-MsgGUID: Lwb21FozRO2Nwy7T2M1Ixg==
X-IronPort-AV: E=McAfee;i="6700,10204,11283"; a="34203273"
X-IronPort-AV: E=Sophos;i="6.12,226,1728975600"; 
   d="scan'208";a="34203273"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2024 09:18:55 -0800
X-CSE-ConnectionGUID: z2OexCP9RDOTZne8onaveA==
X-CSE-MsgGUID: oWzO42XQRZuwPgcrWQNuAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="126824514"
Received: from lkp-server01.sh.intel.com (HELO 82a3f569d0cb) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 11 Dec 2024 09:18:52 -0800
Received: from kbuild by 82a3f569d0cb with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tLQML-0006vh-22;
	Wed, 11 Dec 2024 17:18:49 +0000
Date: Thu, 12 Dec 2024 01:18:15 +0800
From: kernel test robot <lkp@intel.com>
To: Keith Busch <kbusch@meta.com>, axboe@kernel.dk, hch@lst.de,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, sagi@grimberg.me,
	asml.silence@gmail.com, anuj20.g@samsung.com, joshi.k@samsung.com,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv13 10/11] nvme: register fdp parameters with the block
 layer
Message-ID: <202412120111.L2w9GCZd-lkp@intel.com>
References: <20241210194722.1905732-11-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241210194722.1905732-11-kbusch@meta.com>

Hi Keith,

kernel test robot noticed the following build warnings:

[auto build test WARNING on axboe-block/for-next]
[also build test WARNING on next-20241211]
[cannot apply to brauner-vfs/vfs.all hch-configfs/for-next linus/master v6.13-rc2]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Keith-Busch/fs-add-a-write-stream-field-to-the-kiocb/20241211-080803
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
patch link:    https://lore.kernel.org/r/20241210194722.1905732-11-kbusch%40meta.com
patch subject: [PATCHv13 10/11] nvme: register fdp parameters with the block layer
config: arm-randconfig-003-20241211 (https://download.01.org/0day-ci/archive/20241212/202412120111.L2w9GCZd-lkp@intel.com/config)
compiler: clang version 20.0.0git (https://github.com/llvm/llvm-project 2dc22615fd46ab2566d0f26d5ba234ab12dc4bf8)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241212/202412120111.L2w9GCZd-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202412120111.L2w9GCZd-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from drivers/nvme/host/core.c:8:
   In file included from include/linux/blkdev.h:9:
   In file included from include/linux/blk_types.h:10:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:8:
   In file included from include/linux/cacheflush.h:5:
   In file included from arch/arm/include/asm/cacheflush.h:10:
   In file included from include/linux/mm.h:2223:
   include/linux/vmstat.h:518:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     518 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
>> drivers/nvme/host/core.c:2177:5: warning: format specifies type 'unsigned long' but the argument has type 'size_t' (aka 'unsigned int') [-Wformat]
    2176 |                          "failed to allocate %lu bytes for FDP config log\n",
         |                                              ~~~
         |                                              %zu
    2177 |                          size);
         |                          ^~~~
   include/linux/dev_printk.h:156:70: note: expanded from macro 'dev_warn'
     156 |         dev_printk_index_wrap(_dev_warn, KERN_WARNING, dev, dev_fmt(fmt), ##__VA_ARGS__)
         |                                                                     ~~~     ^~~~~~~~~~~
   include/linux/dev_printk.h:110:23: note: expanded from macro 'dev_printk_index_wrap'
     110 |                 _p_func(dev, fmt, ##__VA_ARGS__);                       \
         |                              ~~~    ^~~~~~~~~~~
   drivers/nvme/host/core.c:2255:5: warning: format specifies type 'unsigned long' but the argument has type 'size_t' (aka 'unsigned int') [-Wformat]
    2254 |                          "failed to allocate %lu bytes for FDP io-mgmt\n",
         |                                              ~~~
         |                                              %zu
    2255 |                          size);
         |                          ^~~~
   include/linux/dev_printk.h:156:70: note: expanded from macro 'dev_warn'
     156 |         dev_printk_index_wrap(_dev_warn, KERN_WARNING, dev, dev_fmt(fmt), ##__VA_ARGS__)
         |                                                                     ~~~     ^~~~~~~~~~~
   include/linux/dev_printk.h:110:23: note: expanded from macro 'dev_printk_index_wrap'
     110 |                 _p_func(dev, fmt, ##__VA_ARGS__);                       \
         |                              ~~~    ^~~~~~~~~~~
   3 warnings generated.


vim +2177 drivers/nvme/host/core.c

  2153	
  2154	static int nvme_query_fdp_granularity(struct nvme_ctrl *ctrl,
  2155					      struct nvme_ns_info *info, u8 fdp_idx)
  2156	{
  2157		struct nvme_fdp_config_log hdr, *h;
  2158		struct nvme_fdp_config_desc *desc;
  2159		size_t size = sizeof(hdr);
  2160		int i, n, ret;
  2161		void *log;
  2162	
  2163		ret = nvme_get_log_lsi(ctrl, 0, NVME_LOG_FDP_CONFIGS, 0,
  2164				       NVME_CSI_NVM, &hdr, size, 0, info->endgid);
  2165		if (ret) {
  2166			dev_warn(ctrl->device,
  2167				 "FDP configs log header status:0x%x endgid:%x\n", ret,
  2168				 info->endgid);
  2169			return ret;
  2170		}
  2171	
  2172		size = le32_to_cpu(hdr.sze);
  2173		h = kzalloc(size, GFP_KERNEL);
  2174		if (!h) {
  2175			dev_warn(ctrl->device,
  2176				 "failed to allocate %lu bytes for FDP config log\n",
> 2177				 size);
  2178			return -ENOMEM;
  2179		}
  2180	
  2181		ret = nvme_get_log_lsi(ctrl, 0, NVME_LOG_FDP_CONFIGS, 0,
  2182				       NVME_CSI_NVM, h, size, 0, info->endgid);
  2183		if (ret) {
  2184			dev_warn(ctrl->device,
  2185				 "FDP configs log status:0x%x endgid:%x\n", ret,
  2186				 info->endgid);
  2187			goto out;
  2188		}
  2189	
  2190		n = le16_to_cpu(h->numfdpc) + 1;
  2191		if (fdp_idx > n) {
  2192			dev_warn(ctrl->device, "FDP index:%d out of range:%d\n",
  2193				 fdp_idx, n);
  2194			/* Proceed without registering FDP streams */
  2195			ret = 0;
  2196			goto out;
  2197		}
  2198	
  2199		log = h + 1;
  2200		desc = log;
  2201		for (i = 0; i < fdp_idx; i++) {
  2202			log += le16_to_cpu(desc->dsze);
  2203			desc = log;
  2204		}
  2205	
  2206		if (le32_to_cpu(desc->nrg) > 1) {
  2207			dev_warn(ctrl->device, "FDP NRG > 1 not supported\n");
  2208			ret = 0;
  2209			goto out;
  2210		}
  2211	
  2212		info->runs = le64_to_cpu(desc->runs);
  2213	out:
  2214		kfree(h);
  2215		return ret;
  2216	}
  2217	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

