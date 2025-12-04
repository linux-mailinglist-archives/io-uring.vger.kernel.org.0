Return-Path: <io-uring+bounces-10969-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B7902CA5A2B
	for <lists+io-uring@lfdr.de>; Thu, 04 Dec 2025 23:37:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8F5973106D36
	for <lists+io-uring@lfdr.de>; Thu,  4 Dec 2025 22:37:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EF523358C9;
	Thu,  4 Dec 2025 22:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Oe19tkon"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776B1311599;
	Thu,  4 Dec 2025 22:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764887864; cv=none; b=VeAB+zKLpC6nuQlyVZGGlF5RNCYMBTsch3EyBQTOcK6dk4zyg6UR/CEF1XaLUrq5PialxMAy40fGAOLWsvD/1LMDmUMrIlO8idLjuBxmQBoQcEfDi3GaxzxFBQSlQuqu1CiaxNj9jEG/6sc3/wfqG0PlQhaOAAad1rc3+Dr1xOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764887864; c=relaxed/simple;
	bh=yKHCvRNpJH7xPDYiNZurxGHI6SlycvPNboVI3w0Vgh0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DqKsX11UbG/Un2jRdnX1xT9Bl67JPDi9w6mO6z47CTnf31DV5MGGCwWleX0k5PHw7gIpD0RbKr5nFf1REvsVltJEfXi3lAPrruqWk9ZZZpwlR+eddP30znEcuN14JFXRCeP+PlgdhapAUxE+fXvdYlZXIZXpaRyfdL+8vUJpJvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Oe19tkon; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764887862; x=1796423862;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yKHCvRNpJH7xPDYiNZurxGHI6SlycvPNboVI3w0Vgh0=;
  b=Oe19tkonnEHawYbmO0h+bHENXHWrf6P5XAlFGA6Y7DPhZ5bPlFZMbMvw
   Ti772v39KNxMH0ARPeC9gFIr30loDNhcl8oNXNDaNjtaD5i3zIy321yXu
   2qITgnEpJUn8Y4Uf/EfZeTUhceRgDLq3tkvt//MDCIwmom+SNijAvoYIf
   s/QTtjLxNGk62qU+rm2TI1332h1Em8ph4FdmTSEc57Ft6fChGlo07sR4/
   nvF42LAqynJ5ERmcWB6O3XOZ7unrE9cz/nx+h7xf/giwt4MsRiRbRJ370
   s6OTxAK2xtuoj2nrmPt14DL2j+wm/OaNdlgAhmYDddhq8WmGu8WgMFg4J
   Q==;
X-CSE-ConnectionGUID: rDcEvur1QbqP9jq67NKuLg==
X-CSE-MsgGUID: HJYI3r4EQwWslTFmJD4q1w==
X-IronPort-AV: E=McAfee;i="6800,10657,11632"; a="78030964"
X-IronPort-AV: E=Sophos;i="6.20,250,1758610800"; 
   d="scan'208";a="78030964"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 14:37:42 -0800
X-CSE-ConnectionGUID: 0XB2ewAhRMqjG8vPOR0UUQ==
X-CSE-MsgGUID: t+p3J7fTSmmIWqw8jxoczQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,250,1758610800"; 
   d="scan'208";a="200232956"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 04 Dec 2025 14:37:38 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vRHxA-00000000EJR-10WK;
	Thu, 04 Dec 2025 22:37:36 +0000
Date: Fri, 5 Dec 2025 06:37:10 +0800
From: kernel test robot <lkp@intel.com>
To: Xiaobing Li <xiaobing.li@samsung.com>, miklos@szeredi.hu,
	axboe@kernel.dk
Cc: oe-kbuild-all@lists.linux.dev, io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, bschubert@ddn.com,
	asml.silence@gmail.com, joannelkoong@gmail.com, dw@davidwei.uk,
	josef@toxicpanda.com, kbusch@kernel.org, peiwei.li@samsung.com,
	joshi.k@samsung.com, Xiaobing Li <xiaobing.li@samsung.com>
Subject: Re: [PATCH] fuse: add zero-copy to fuse-over-io_uring
Message-ID: <202512050506.gwZpnWio-lkp@intel.com>
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

kernel test robot noticed the following build warnings:

[auto build test WARNING on mszeredi-fuse/for-next]
[also build test WARNING on linus/master v6.18 next-20251204]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Xiaobing-Li/fuse-add-zero-copy-to-fuse-over-io_uring/20251204-165924
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-next
patch link:    https://lore.kernel.org/r/20251204082536.17349-1-xiaobing.li%40samsung.com
patch subject: [PATCH] fuse: add zero-copy to fuse-over-io_uring
config: um-randconfig-r052-20251205 (https://download.01.org/0day-ci/archive/20251205/202512050506.gwZpnWio-lkp@intel.com/config)
compiler: gcc-13 (Debian 13.3.0-16) 13.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251205/202512050506.gwZpnWio-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512050506.gwZpnWio-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from fs/fuse/dev_uring.c:8:
   fs/fuse/dev_uring_i.h:43:25: error: field 'payload_iter' has incomplete type
      43 |         struct iov_iter payload_iter;
         |                         ^~~~~~~~~~~~
   fs/fuse/dev_uring.c: In function 'fuse_uring_create_ring_ent':
>> fs/fuse/dev_uring.c:1086:49: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
    1086 |                 err = io_uring_cmd_import_fixed((u64)ent->payload, payload_size, ITER_DEST,
         |                                                 ^


vim +1086 fs/fuse/dev_uring.c

  1042	
  1043	static struct fuse_ring_ent *
  1044	fuse_uring_create_ring_ent(struct io_uring_cmd *cmd,
  1045				   struct fuse_ring_queue *queue)
  1046	{
  1047		struct fuse_ring *ring = queue->ring;
  1048		struct fuse_ring_ent *ent;
  1049		size_t payload_size;
  1050		struct iovec iov[FUSE_URING_IOV_SEGS];
  1051		int err;
  1052	
  1053		err = fuse_uring_get_iovec_from_sqe(cmd->sqe, iov);
  1054		if (err) {
  1055			pr_info_ratelimited("Failed to get iovec from sqe, err=%d\n",
  1056					    err);
  1057			return ERR_PTR(err);
  1058		}
  1059	
  1060		err = -EINVAL;
  1061		if (iov[0].iov_len < sizeof(struct fuse_uring_req_header)) {
  1062			pr_info_ratelimited("Invalid header len %zu\n", iov[0].iov_len);
  1063			return ERR_PTR(err);
  1064		}
  1065	
  1066		payload_size = iov[1].iov_len;
  1067		if (payload_size < ring->max_payload_sz) {
  1068			pr_info_ratelimited("Invalid req payload len %zu\n",
  1069					    payload_size);
  1070			return ERR_PTR(err);
  1071		}
  1072	
  1073		err = -ENOMEM;
  1074		ent = kzalloc(sizeof(*ent), GFP_KERNEL_ACCOUNT);
  1075		if (!ent)
  1076			return ERR_PTR(err);
  1077	
  1078		INIT_LIST_HEAD(&ent->list);
  1079	
  1080		ent->queue = queue;
  1081		ent->headers = iov[0].iov_base;
  1082		ent->payload = iov[1].iov_base;
  1083	
  1084		if (READ_ONCE(cmd->sqe->uring_cmd_flags) & IORING_URING_CMD_FIXED) {
  1085			ent->zero_copy = true;
> 1086			err = io_uring_cmd_import_fixed((u64)ent->payload, payload_size, ITER_DEST,
  1087							&ent->payload_iter, cmd, 0);
  1088	
  1089			if (err) {
  1090				kfree(ent);
  1091				return ERR_PTR(err);
  1092			}
  1093		}
  1094	
  1095		atomic_inc(&ring->queue_refs);
  1096		return ent;
  1097	}
  1098	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

