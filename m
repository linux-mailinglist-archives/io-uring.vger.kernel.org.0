Return-Path: <io-uring+bounces-5439-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F3DF9ECECA
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 15:41:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 24574162210
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 14:41:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ACFD186E54;
	Wed, 11 Dec 2024 14:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SM5GLy0v"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21302246354;
	Wed, 11 Dec 2024 14:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733928092; cv=none; b=TtgeltI2FO0dDlO38QCmDJKUK3zvKYuPgXL4avTC08uI6PhqjyOjyvHriV8FkRqT+RvKNdBgpU2Yawp8FR1QQxBHebqYVQlvOMkjciXu8xvzh+IMUNjq5tyN/B+v4DcDzEktpdD9IZ6tttlb17ngSWZ8Zx15zlX1XjnFZsEZl2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733928092; c=relaxed/simple;
	bh=SwNjv1AC6CVXytqZT3qaDygu0YsKQwsBbZ0nRszYpcs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DYMhzbA0657R2OR9sOliMFQeyEAxsdTYB721oBJcl2b3pZ3jYz7ANkKePkjPCH+1BrxiNfFotIU8q+Sb1z69/pP9WVOUdu2kRdzvuLpNdaPNH4LqqdpfD/v/yBVwv4KopmrWK2xigl80Fq9erKVt/CdMhL1b26lr4oyLD5glHVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SM5GLy0v; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733928090; x=1765464090;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SwNjv1AC6CVXytqZT3qaDygu0YsKQwsBbZ0nRszYpcs=;
  b=SM5GLy0vaENsLnLdaNf0WIINRYH4UwJ6+YkAK5HQpEbQKjK1QkCeeRpx
   RKwmfAt+83MRWliWQsg61/p/p281TIx9dArEf+Frj9BGKeA23ljAkKkKZ
   3J/sRrv2d/tz3QfqWmS3G7kEaG+R5QFD3qIhK5+C2vOBZ7JCnOZ0gBwiy
   zrrmQhG+qrac+AY76iixf45yLB1iz/O136E42MO4e/xCLBsPrBM2uWNWk
   Lt1pXGOCHXD8fT1R0hS0KrU5aTmv8/6zVWbtu/lctCJnAlJAOc7wpQA5b
   rPSAJKyc/56+ig6FBa6gG/F6AkSZVlBslVlI80uPFiQoKNwCqpBx877j9
   g==;
X-CSE-ConnectionGUID: EqBgJR70RMaUS9hC3APP6Q==
X-CSE-MsgGUID: lQTvTnffQkWXLGkobUTuIw==
X-IronPort-AV: E=McAfee;i="6700,10204,11283"; a="51839749"
X-IronPort-AV: E=Sophos;i="6.12,225,1728975600"; 
   d="scan'208";a="51839749"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2024 06:41:16 -0800
X-CSE-ConnectionGUID: JBQWBMwVS1+WzAKyxRaObw==
X-CSE-MsgGUID: m3HoZaClSMmoSCUCBPb9Ww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,225,1728975600"; 
   d="scan'208";a="95691366"
Received: from lkp-server01.sh.intel.com (HELO 82a3f569d0cb) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 11 Dec 2024 06:41:11 -0800
Received: from kbuild by 82a3f569d0cb with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tLNtk-0006kz-0t;
	Wed, 11 Dec 2024 14:41:08 +0000
Date: Wed, 11 Dec 2024 22:40:15 +0800
From: kernel test robot <lkp@intel.com>
To: Keith Busch <kbusch@meta.com>, axboe@kernel.dk, hch@lst.de,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, sagi@grimberg.me, asml.silence@gmail.com,
	anuj20.g@samsung.com, joshi.k@samsung.com,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv13 10/11] nvme: register fdp parameters with the block
 layer
Message-ID: <202412112244.XIKhzaWR-lkp@intel.com>
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
config: i386-buildonly-randconfig-002-20241211 (https://download.01.org/0day-ci/archive/20241211/202412112244.XIKhzaWR-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-12) 11.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241211/202412112244.XIKhzaWR-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202412112244.XIKhzaWR-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/linux/device.h:15,
                    from include/linux/async.h:14,
                    from drivers/nvme/host/core.c:7:
   drivers/nvme/host/core.c: In function 'nvme_query_fdp_granularity':
>> drivers/nvme/host/core.c:2176:26: warning: format '%lu' expects argument of type 'long unsigned int', but argument 3 has type 'size_t' {aka 'unsigned int'} [-Wformat=]
    2176 |                          "failed to allocate %lu bytes for FDP config log\n",
         |                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/dev_printk.h:110:30: note: in definition of macro 'dev_printk_index_wrap'
     110 |                 _p_func(dev, fmt, ##__VA_ARGS__);                       \
         |                              ^~~
   include/linux/dev_printk.h:156:61: note: in expansion of macro 'dev_fmt'
     156 |         dev_printk_index_wrap(_dev_warn, KERN_WARNING, dev, dev_fmt(fmt), ##__VA_ARGS__)
         |                                                             ^~~~~~~
   drivers/nvme/host/core.c:2175:17: note: in expansion of macro 'dev_warn'
    2175 |                 dev_warn(ctrl->device,
         |                 ^~~~~~~~
   drivers/nvme/host/core.c:2176:48: note: format string is defined here
    2176 |                          "failed to allocate %lu bytes for FDP config log\n",
         |                                              ~~^
         |                                                |
         |                                                long unsigned int
         |                                              %u
   In file included from include/linux/device.h:15,
                    from include/linux/async.h:14,
                    from drivers/nvme/host/core.c:7:
   drivers/nvme/host/core.c: In function 'nvme_query_fdp_info':
   drivers/nvme/host/core.c:2254:26: warning: format '%lu' expects argument of type 'long unsigned int', but argument 3 has type 'size_t' {aka 'unsigned int'} [-Wformat=]
    2254 |                          "failed to allocate %lu bytes for FDP io-mgmt\n",
         |                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/dev_printk.h:110:30: note: in definition of macro 'dev_printk_index_wrap'
     110 |                 _p_func(dev, fmt, ##__VA_ARGS__);                       \
         |                              ^~~
   include/linux/dev_printk.h:156:61: note: in expansion of macro 'dev_fmt'
     156 |         dev_printk_index_wrap(_dev_warn, KERN_WARNING, dev, dev_fmt(fmt), ##__VA_ARGS__)
         |                                                             ^~~~~~~
   drivers/nvme/host/core.c:2253:17: note: in expansion of macro 'dev_warn'
    2253 |                 dev_warn(ctrl->device,
         |                 ^~~~~~~~
   drivers/nvme/host/core.c:2254:48: note: format string is defined here
    2254 |                          "failed to allocate %lu bytes for FDP io-mgmt\n",
         |                                              ~~^
         |                                                |
         |                                                long unsigned int
         |                                              %u


vim +2176 drivers/nvme/host/core.c

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
> 2176				 "failed to allocate %lu bytes for FDP config log\n",
  2177				 size);
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

