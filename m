Return-Path: <io-uring+bounces-5266-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CFA09E66D7
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 06:28:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC897284A02
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 05:28:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 745C3197548;
	Fri,  6 Dec 2024 05:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="by6NMBS3"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC83196C67;
	Fri,  6 Dec 2024 05:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733462873; cv=none; b=HGhUcl1R6jGWljjBEvaogx7+eHbHgkWaUXDRf7Crr1KAk8dGprOspB7ok/EynQV0c/7uv58t+RyCLnI/M3KalAOwHADjeZgESEirXwQh8f89P/EVL0Y2eGEyD7V2Qh41ay13Ap0tp3h/yJu9SZDuEGo9Vn/e2PJa7IAxJrh87To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733462873; c=relaxed/simple;
	bh=X9VFMKr7/fJOGLXPS8atTYCy0j+P7k6TXaVhXB6yhIM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n8M9YefnSIBv4yb2KtLI/SHHF31X8WJWEboCl3TcmQmSWFGuwarLUKqwP6ACXGStxaF3cS2gadtWxKnRcR/fDm8n0EIw+YLXsDme9Zo2lgoqw1uU6YdYyP7kIg5Lx1QJ+hGrlADDYoh4Zah+KxhPPFbuZ9/7gU+wQkasWtzVcpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=by6NMBS3; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733462871; x=1764998871;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=X9VFMKr7/fJOGLXPS8atTYCy0j+P7k6TXaVhXB6yhIM=;
  b=by6NMBS3uuoSS7jABjt9Zm3SNEQdWKKljeRvA2gA5evSGQVa+tuRN77R
   E+FmhGtvHfLck/XXpnliXxwOep7ut6Oti0NmIF2zrSn3BFofTrHro9Hy9
   b3M6oeU2hXU/JRV5yuutDkrlRavEEppee1yGMbqz1ymoEPmJWTGmk+W0n
   DmN2OeIc0Ct6h4LLss1B8zmCbe1mkqxaBsV0LwZnir1md/5xJcf2Xb4XH
   9ywufUdn6dwbQusn1Ukfo79lzwSf8SFUur/h1xG4NZHLwlYhEqXHlyLUi
   S2F4fd0xg/+oTAfYuW4YkI/cVDIz6N1KCiyQaBMgSoGPC3Lh9//r7RDn4
   g==;
X-CSE-ConnectionGUID: c1q1MMzBTMSHzEULQZ/MOQ==
X-CSE-MsgGUID: G1cJ9ZENSpGms5A9Jyq/pw==
X-IronPort-AV: E=McAfee;i="6700,10204,11277"; a="56299061"
X-IronPort-AV: E=Sophos;i="6.12,212,1728975600"; 
   d="scan'208";a="56299061"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2024 21:27:50 -0800
X-CSE-ConnectionGUID: 46M0KqbPSFGW7xrYdXXJNA==
X-CSE-MsgGUID: DsKRuo40THuu3yk9bYd+6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,212,1728975600"; 
   d="scan'208";a="131724228"
Received: from lkp-server01.sh.intel.com (HELO 82a3f569d0cb) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 05 Dec 2024 21:27:48 -0800
Received: from kbuild by 82a3f569d0cb with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tJQsT-0000jD-1x;
	Fri, 06 Dec 2024 05:27:45 +0000
Date: Fri, 6 Dec 2024 13:26:59 +0800
From: kernel test robot <lkp@intel.com>
To: Keith Busch <kbusch@meta.com>, axboe@kernel.dk, hch@lst.de,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, sagi@grimberg.me,
	asml.silence@gmail.com, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv11 09/10] nvme: register fdp queue limits
Message-ID: <202412061328.YMG9MZn5-lkp@intel.com>
References: <20241206015308.3342386-10-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241206015308.3342386-10-kbusch@meta.com>

Hi Keith,

kernel test robot noticed the following build warnings:

[auto build test WARNING on axboe-block/for-next]
[also build test WARNING on next-20241205]
[cannot apply to brauner-vfs/vfs.all hch-configfs/for-next linus/master v6.13-rc1]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Keith-Busch/fs-add-a-write-stream-field-to-the-kiocb/20241206-095707
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
patch link:    https://lore.kernel.org/r/20241206015308.3342386-10-kbusch%40meta.com
patch subject: [PATCHv11 09/10] nvme: register fdp queue limits
config: i386-buildonly-randconfig-003 (https://download.01.org/0day-ci/archive/20241206/202412061328.YMG9MZn5-lkp@intel.com/config)
compiler: clang version 19.1.3 (https://github.com/llvm/llvm-project ab51eccf88f5321e7c60591c5546b254b6afab99)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241206/202412061328.YMG9MZn5-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202412061328.YMG9MZn5-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from drivers/nvme/host/core.c:8:
   In file included from include/linux/blkdev.h:9:
   In file included from include/linux/blk_types.h:10:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:8:
   In file included from include/linux/cacheflush.h:5:
   In file included from arch/x86/include/asm/cacheflush.h:5:
   In file included from include/linux/mm.h:2223:
   include/linux/vmstat.h:518:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     518 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
>> drivers/nvme/host/core.c:2178:18: warning: variable 'h' is uninitialized when used here [-Wuninitialized]
    2178 |         n = le16_to_cpu(h->numfdpc) + 1;
         |                         ^
   include/linux/byteorder/generic.h:91:21: note: expanded from macro 'le16_to_cpu'
      91 | #define le16_to_cpu __le16_to_cpu
         |                     ^
   include/uapi/linux/byteorder/little_endian.h:37:51: note: expanded from macro '__le16_to_cpu'
      37 | #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
         |                                                   ^
   drivers/nvme/host/core.c:2157:36: note: initialize the variable 'h' to silence this warning
    2157 |         struct nvme_fdp_config_log hdr, *h;
         |                                           ^
         |                                            = NULL
   2 warnings generated.


vim +/h +2178 drivers/nvme/host/core.c

  2153	
  2154	static int nvme_check_fdp(struct nvme_ns *ns, struct nvme_ns_info *info,
  2155				  u8 fdp_idx)
  2156	{
  2157		struct nvme_fdp_config_log hdr, *h;
  2158		size_t size = sizeof(hdr);
  2159		int i, n, ret;
  2160		void *log;
  2161	
  2162		info->runs = 0;
  2163		ret = nvme_get_log_lsi(ns->ctrl, 0, NVME_LOG_FDP_CONFIG, 0, NVME_CSI_NVM,
  2164				   (void *)&hdr, size, 0, info->endgid);
  2165		if (ret)
  2166			return ret;
  2167	
  2168		size = le32_to_cpu(hdr.sze);
  2169		log = kzalloc(size, GFP_KERNEL);
  2170		if (!log)
  2171			return 0;
  2172	
  2173		ret = nvme_get_log_lsi(ns->ctrl, 0, NVME_LOG_FDP_CONFIG, 0, NVME_CSI_NVM,
  2174				   log, size, 0, info->endgid);
  2175		if (ret)
  2176			goto out;
  2177	
> 2178		n = le16_to_cpu(h->numfdpc) + 1;
  2179		if (fdp_idx > n)
  2180			goto out;
  2181	
  2182		h = log;
  2183		log = h->configs;
  2184		for (i = 0; i < n; i++) {
  2185			struct nvme_fdp_config_desc *config = log;
  2186	
  2187			if (i == fdp_idx) {
  2188				info->runs = le64_to_cpu(config->runs);
  2189				break;
  2190			}
  2191			log += le16_to_cpu(config->size);
  2192		}
  2193	out:
  2194		kfree(h);
  2195		return ret;
  2196	}
  2197	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

