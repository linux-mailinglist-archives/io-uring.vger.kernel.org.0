Return-Path: <io-uring+bounces-1644-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DA8228B3628
	for <lists+io-uring@lfdr.de>; Fri, 26 Apr 2024 12:59:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 095461C20D9E
	for <lists+io-uring@lfdr.de>; Fri, 26 Apr 2024 10:59:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7350144D3C;
	Fri, 26 Apr 2024 10:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UIRiVGIv"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7647144D1D;
	Fri, 26 Apr 2024 10:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714129132; cv=none; b=IAf6qC5f5YwkasZT+nh1hY5jzgGpIKO0tt4lmME2Jx9mROM/qzUlavlUYDK3xeTq7XuBDeGfKaEL013SsXlTv38iP0F05RdKm8IygrBRlD++7mC396V43BNpkhn5Eq6Zk7XI6EEGjAfgzodJ0dgxKOo/X32McDfapxC5GR8f4aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714129132; c=relaxed/simple;
	bh=huF0ExFgsepJp65/LgFBeJslQGlknYDeyxkOEhJEQXQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tdSE9cB+DwNbIkKTEHqcXQPwllq/63DlC+Etag/FNzwKls7iLNA0NJ9ZtQYGRGFYhUx/TXKwYtoQsbPejkeS06GbY2DqgekCPN4VjIOCC6atcyUXcUWxkbBiVMEKyrcySNdlm/FUWT0HcurmvDLOqoY5zQ2sm6RwDr1t3urXmlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UIRiVGIv; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714129131; x=1745665131;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=huF0ExFgsepJp65/LgFBeJslQGlknYDeyxkOEhJEQXQ=;
  b=UIRiVGIvCpQL+kD5F1ou0JjKXW47KjsIpsNy1Bpy+ldjkeIoPDHeTQjt
   5aPXrq8S524116UZHjkt6MUlpLtVC+iD4khnzixWIDlEzIft7cRtA8wqp
   e11I3/Ud4455ypvPJdBP55yeeVUgZdPeNh6hlbAgFOMEWNpj79Gj5veRU
   EH5oeh2TQ/akEUpZG4b1nyN9K7xKaX4brUMF9SwYreBpBgOa0xNNMGH5z
   3TLveURpBE0+Aelf0yJcZdhSMq4Suc5SpD7KRwUEJiMuzZyHmmxgboRyT
   GSYsbUbZGD0IcNYV4tAmD5sEkH6Dy0kjl32+lYyezFaqAPWTqy79O4u7y
   w==;
X-CSE-ConnectionGUID: i8KGEbNPRemMZY70hN8SvA==
X-CSE-MsgGUID: ncuX/lPnTA+LZ6qOKkE3rw==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="10392667"
X-IronPort-AV: E=Sophos;i="6.07,232,1708416000"; 
   d="scan'208";a="10392667"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2024 03:58:50 -0700
X-CSE-ConnectionGUID: sXGMn23tQF2eCCFEw7Rqhw==
X-CSE-MsgGUID: zKSID86WTWqpID8gkQOvfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,232,1708416000"; 
   d="scan'208";a="62863083"
Received: from lkp-server01.sh.intel.com (HELO e434dd42e5a1) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 26 Apr 2024 03:58:46 -0700
Received: from kbuild by e434dd42e5a1 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1s0JHv-0003ck-2K;
	Fri, 26 Apr 2024 10:58:43 +0000
Date: Fri, 26 Apr 2024 18:57:50 +0800
From: kernel test robot <lkp@intel.com>
To: Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk,
	martin.petersen@oracle.com, kbusch@kernel.org, hch@lst.de,
	brauner@kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	asml.silence@gmail.com, dw@davidwei.uk, io-uring@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH 10/10] nvme: add separate handling for user integrity
 buffer
Message-ID: <202404261859.n3J0awuF-lkp@intel.com>
References: <20240425183943.6319-11-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240425183943.6319-11-joshi.k@samsung.com>

Hi Kanchan,

kernel test robot noticed the following build errors:

[auto build test ERROR on 24c3fc5c75c5b9d471783b4a4958748243828613]

url:    https://github.com/intel-lab-lkp/linux/commits/Kanchan-Joshi/block-set-bip_vcnt-correctly/20240426-024916
base:   24c3fc5c75c5b9d471783b4a4958748243828613
patch link:    https://lore.kernel.org/r/20240425183943.6319-11-joshi.k%40samsung.com
patch subject: [PATCH 10/10] nvme: add separate handling for user integrity buffer
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20240426/202404261859.n3J0awuF-lkp@intel.com/config)
compiler: clang version 18.1.4 (https://github.com/llvm/llvm-project e6c3289804a67ea0bb6a86fadbe454dd93b8d855)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240426/202404261859.n3J0awuF-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202404261859.n3J0awuF-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/nvme/host/core.c:1014:31: error: member reference base type 'void' is not a structure or union
    1014 |                         if (bio_integrity(req->bio)->bip_flags &
         |                             ~~~~~~~~~~~~~~~~~~~~~~~^ ~~~~~~~~~
   1 error generated.


vim +/void +1014 drivers/nvme/host/core.c

   971	
   972	static inline blk_status_t nvme_setup_rw(struct nvme_ns *ns,
   973			struct request *req, struct nvme_command *cmnd,
   974			enum nvme_opcode op)
   975	{
   976		u16 control = 0;
   977		u32 dsmgmt = 0;
   978	
   979		if (req->cmd_flags & REQ_FUA)
   980			control |= NVME_RW_FUA;
   981		if (req->cmd_flags & (REQ_FAILFAST_DEV | REQ_RAHEAD))
   982			control |= NVME_RW_LR;
   983	
   984		if (req->cmd_flags & REQ_RAHEAD)
   985			dsmgmt |= NVME_RW_DSM_FREQ_PREFETCH;
   986	
   987		cmnd->rw.opcode = op;
   988		cmnd->rw.flags = 0;
   989		cmnd->rw.nsid = cpu_to_le32(ns->head->ns_id);
   990		cmnd->rw.cdw2 = 0;
   991		cmnd->rw.cdw3 = 0;
   992		cmnd->rw.metadata = 0;
   993		cmnd->rw.slba =
   994			cpu_to_le64(nvme_sect_to_lba(ns->head, blk_rq_pos(req)));
   995		cmnd->rw.length =
   996			cpu_to_le16((blk_rq_bytes(req) >> ns->head->lba_shift) - 1);
   997		cmnd->rw.reftag = 0;
   998		cmnd->rw.apptag = 0;
   999		cmnd->rw.appmask = 0;
  1000	
  1001		if (ns->head->ms) {
  1002			/*
  1003			 * If formated with metadata, the block layer always provides a
  1004			 * metadata buffer if CONFIG_BLK_DEV_INTEGRITY is enabled.  Else
  1005			 * we enable the PRACT bit for protection information or set the
  1006			 * namespace capacity to zero to prevent any I/O.
  1007			 */
  1008			if (!blk_integrity_rq(req)) {
  1009				if (WARN_ON_ONCE(!nvme_ns_has_pi(ns->head)))
  1010					return BLK_STS_NOTSUPP;
  1011				control |= NVME_RW_PRINFO_PRACT;
  1012			} else {
  1013				/* process user-created integrity */
> 1014				if (bio_integrity(req->bio)->bip_flags &
  1015						BIP_INTEGRITY_USER) {
  1016					nvme_setup_user_integrity(ns, req, cmnd,
  1017								  &control);
  1018					goto out;
  1019				}
  1020			}
  1021	
  1022			switch (ns->head->pi_type) {
  1023			case NVME_NS_DPS_PI_TYPE3:
  1024				control |= NVME_RW_PRINFO_PRCHK_GUARD;
  1025				break;
  1026			case NVME_NS_DPS_PI_TYPE1:
  1027			case NVME_NS_DPS_PI_TYPE2:
  1028				control |= NVME_RW_PRINFO_PRCHK_GUARD |
  1029						NVME_RW_PRINFO_PRCHK_REF;
  1030				if (op == nvme_cmd_zone_append)
  1031					control |= NVME_RW_APPEND_PIREMAP;
  1032				nvme_set_ref_tag(ns, cmnd, req);
  1033				break;
  1034			}
  1035		}
  1036	out:
  1037		cmnd->rw.control = cpu_to_le16(control);
  1038		cmnd->rw.dsmgmt = cpu_to_le32(dsmgmt);
  1039		return 0;
  1040	}
  1041	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

