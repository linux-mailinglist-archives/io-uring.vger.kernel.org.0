Return-Path: <io-uring+bounces-5273-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CA8819E6F34
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 14:20:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C66751881EBF
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 13:19:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 729A3207647;
	Fri,  6 Dec 2024 13:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IjsupD+e"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655BB206F34;
	Fri,  6 Dec 2024 13:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733491153; cv=none; b=HdlaWAfELTh6KvztMaz3cLv+JgtvyTzvZjbI395U3p9lb9D48ORMQTQ4Y4ND4mhfU5//tkdtTsKdcZE3KPe/f7t9T15/q9csWTygdRGR1nBw7V9vi7I5ydPkp4y1da+wFiLdfYz4bG+PWkENwGqYcFPOyCGaFEwJilG8yh4wek0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733491153; c=relaxed/simple;
	bh=ReJyLj4SdzIR5dt17fE0IRPkn0ixnhvwFQ8E8A1Bd50=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fp5dUrYkKeDHrCp0zZDcxe4TGz3fhermAP67FoOgCS7s27Tc8ywlYMbC/byNOE2lBpIj8wk6xE436dL844lPh2Odr9OiPUir1AJ0pHzBMQq5gs1+GZHU+KujxMlpYwjdFz13+iAgd+0vP/I3ltycwaoTzqEALhqYVhszMSLkQ7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IjsupD+e; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733491152; x=1765027152;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ReJyLj4SdzIR5dt17fE0IRPkn0ixnhvwFQ8E8A1Bd50=;
  b=IjsupD+eU2VMKKkqdk/76cuvhFmPr5p/T++fpnDRzoj0oTehwcbWDwd7
   CsYENowOyNkq6Xlm4z4BIYLjf6OLyqDg03e48LeP+30NFa72T8Nn47JgS
   XuOOoKKG9+YuRINdgz66uqMP9Tmb7ryzLlCPz9JBUOwtu0AmbY0CefZct
   Ld+wFLXBmix1rIRMk7DTcU29wVeypdUSMp6aziEZQrsj7/j9tC6gpwEDh
   hirORnybcvFzrESoyGZ8ENF/INN5r5mmRAH42oqiBFPDJfOo8YgmUl3eB
   ztBqm29oytjixprQWrOU8dpCUU4BP3/qoe6D8oDOnlRxByDVLk+ksHiIY
   A==;
X-CSE-ConnectionGUID: i5r4ylruToCuI0TEZTBufw==
X-CSE-MsgGUID: HmBeUzx3QS2D47Mq0Su0fA==
X-IronPort-AV: E=McAfee;i="6700,10204,11278"; a="34080518"
X-IronPort-AV: E=Sophos;i="6.12,213,1728975600"; 
   d="scan'208";a="34080518"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2024 05:19:11 -0800
X-CSE-ConnectionGUID: MzWSVAckTBqH+m6g+yoiQQ==
X-CSE-MsgGUID: tnGVdlFhRKCG/Vvc0iOvFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,213,1728975600"; 
   d="scan'208";a="94766654"
Received: from lkp-server01.sh.intel.com (HELO 82a3f569d0cb) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 06 Dec 2024 05:19:08 -0800
Received: from kbuild by 82a3f569d0cb with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tJYEb-00015D-31;
	Fri, 06 Dec 2024 13:19:05 +0000
Date: Fri, 6 Dec 2024 21:18:52 +0800
From: kernel test robot <lkp@intel.com>
To: Keith Busch <kbusch@meta.com>, axboe@kernel.dk, hch@lst.de,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, sagi@grimberg.me, asml.silence@gmail.com,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv11 10/10] nvme: use fdp streams if write stream is
 provided
Message-ID: <202412062116.SzYvrv5L-lkp@intel.com>
References: <20241206015308.3342386-11-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241206015308.3342386-11-kbusch@meta.com>

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
patch link:    https://lore.kernel.org/r/20241206015308.3342386-11-kbusch%40meta.com
patch subject: [PATCHv11 10/10] nvme: use fdp streams if write stream is provided
config: i386-randconfig-061 (https://download.01.org/0day-ci/archive/20241206/202412062116.SzYvrv5L-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241206/202412062116.SzYvrv5L-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202412062116.SzYvrv5L-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   drivers/nvme/host/core.c: note: in included file (through drivers/nvme/host/nvme.h):
   include/linux/nvme.h:790:44: sparse: sparse: array of flexible structures
>> drivers/nvme/host/core.c:2261:34: sparse: sparse: cast to restricted __le16
   drivers/nvme/host/core.c: note: in included file (through include/linux/async.h):
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true

vim +2261 drivers/nvme/host/core.c

  2209	
  2210	static int nvme_query_fdp_info(struct nvme_ns *ns, struct nvme_ns_info *info)
  2211	{
  2212		struct nvme_fdp_ruh_status_desc *ruhsd;
  2213		struct nvme_ns_head *head = ns->head;
  2214		struct nvme_fdp_ruh_status *ruhs;
  2215		struct nvme_command c = {};
  2216		u32 fdp, fdp_idx;
  2217		int size, ret, i;
  2218	
  2219		ret = nvme_get_features(ns->ctrl, NVME_FEAT_FDP, info->endgid, NULL, 0,
  2220					&fdp);
  2221		if (ret)
  2222			goto err;
  2223	
  2224		if (!(fdp & NVME_FDP_FDPE))
  2225			goto err;
  2226	
  2227		fdp_idx = (fdp >> NVME_FDP_FDPCIDX_SHIFT) & NVME_FDP_FDPCIDX_MASK;
  2228		ret = nvme_check_fdp(ns, info, fdp_idx);
  2229		if (ret || !info->runs)
  2230			goto err;
  2231	
  2232		size = struct_size(ruhs, ruhsd, NVME_MAX_PLIDS);
  2233		ruhs = kzalloc(size, GFP_KERNEL);
  2234		if (!ruhs) {
  2235			ret = -ENOMEM;
  2236			goto err;
  2237		}
  2238	
  2239		c.imr.opcode = nvme_cmd_io_mgmt_recv;
  2240		c.imr.nsid = cpu_to_le32(head->ns_id);
  2241		c.imr.mo = NVME_IO_MGMT_RECV_MO_RUHS;
  2242		c.imr.numd = cpu_to_le32(nvme_bytes_to_numd(size));
  2243		ret = nvme_submit_sync_cmd(ns->queue, &c, ruhs, size);
  2244		if (ret)
  2245			goto free;
  2246	
  2247		head->nr_plids = le16_to_cpu(ruhs->nruhsd);
  2248		if (!head->nr_plids)
  2249			goto free;
  2250	
  2251		head->nr_plids = min(head->nr_plids, NVME_MAX_PLIDS);
  2252		head->plids = kcalloc(head->nr_plids, sizeof(head->plids),
  2253				      GFP_KERNEL);
  2254		if (!head->plids) {
  2255			ret = -ENOMEM;
  2256			goto free;
  2257		}
  2258	
  2259		for (i = 0; i < head->nr_plids; i++) {
  2260			ruhsd = &ruhs->ruhsd[i];
> 2261			head->plids[i] = le16_to_cpu(ruhsd->pid);
  2262		}
  2263	
  2264		kfree(ruhs);
  2265		return 0;
  2266	
  2267	free:
  2268		kfree(ruhs);
  2269	err:
  2270		head->nr_plids = 0;
  2271		info->runs = 0;
  2272		return ret;
  2273	}
  2274	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

