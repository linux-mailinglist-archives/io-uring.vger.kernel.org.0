Return-Path: <io-uring+bounces-10157-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A07D9C012E7
	for <lists+io-uring@lfdr.de>; Thu, 23 Oct 2025 14:40:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1176F18C3AF9
	for <lists+io-uring@lfdr.de>; Thu, 23 Oct 2025 12:41:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD5E630DD0B;
	Thu, 23 Oct 2025 12:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="meBFo0u9"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4702EC568;
	Thu, 23 Oct 2025 12:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761223251; cv=none; b=j7k7i8nNoey4yDmGYg+Ntm5gKZOzDdazPh3eqvdRv4Y/c+NjgTpsxUK/FjJQIJHLkmvje5K70iqsgPuHecjv/ujEhW8AtVpL+s531Ul6iM/XpId0c3dg97MpgCASKTv3XpnHY0L9Os41VXhDQ/w3HPNYzh7lxXX1/5aWvRMzTZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761223251; c=relaxed/simple;
	bh=Rfzx1RVvSErhKrraTGgi09m3R7z5yigPgkc4w5STX/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W95AOaZUbd6S8/Ye+LerHuflr/AFBsrlGnnFu49gdv8t9sA1OJucImwlVuwG0A/He/YwfoZ4+QKz+WPAWknUZ5xL/2WUraehUi0Vg7yBZLm0jzd3n6tyQP3TwjBOZxm6LqrlwDWy11iEf2zycaZOxT22rueCYLlUZb+NihbLpxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=meBFo0u9; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761223251; x=1792759251;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Rfzx1RVvSErhKrraTGgi09m3R7z5yigPgkc4w5STX/8=;
  b=meBFo0u9yQfC1FT6aY/GAnRsxdLjg1KUsEaHesA+Pf4M3xrMrtJ2mu+y
   yePNn35bHuPuSMdpAS7uRaiuJ1kmla6NMeCBKeqjY39MdRXzmSzypn1bC
   g7KjQxb1qIdpFbUfjPpU9Vs/UJpzoLjEY5IbtEEygAqPVfmi8+/D4DJLP
   LJecQqGV/QMxkXYWnMGmYLVQZ6BmnrFnA2VcWSZ85BJ00evUGgSQNVkTm
   UU7M4d8N0IEz5w74OWFAeOybhR7zzZGOi4lOhqoXuRt8gRH1shIu/Wv0C
   AZJM7xSyKdHFLqVXdUCQ3xkj1FAMw2GAewMinIUWKj2eNvnf/Wltp3KXC
   w==;
X-CSE-ConnectionGUID: T49gbyK5QaeFcl18VgQQ8g==
X-CSE-MsgGUID: mWY29FbKQAq23rWLnTL0Ww==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="73680874"
X-IronPort-AV: E=Sophos;i="6.19,249,1754982000"; 
   d="scan'208";a="73680874"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 05:40:50 -0700
X-CSE-ConnectionGUID: Bmjuq/IqTDSqw9auKJ4n1w==
X-CSE-MsgGUID: uDiq+3atS42nIqMvajiORw==
X-ExtLoop1: 1
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by fmviesa003.fm.intel.com with ESMTP; 23 Oct 2025 05:40:47 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vBucR-000DUn-18;
	Thu, 23 Oct 2025 12:40:41 +0000
Date: Thu, 23 Oct 2025 20:39:44 +0800
From: kernel test robot <lkp@intel.com>
To: Joanne Koong <joannelkoong@gmail.com>, miklos@szeredi.hu,
	axboe@kernel.dk
Cc: oe-kbuild-all@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	bschubert@ddn.com, asml.silence@gmail.com, io-uring@vger.kernel.org,
	xiaobing.li@samsung.com
Subject: Re: [PATCH v1 2/2] fuse: support io-uring registered buffers
Message-ID: <202510232014.8BtM55jj-lkp@intel.com>
References: <20251022202021.3649586-3-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022202021.3649586-3-joannelkoong@gmail.com>

Hi Joanne,

kernel test robot noticed the following build errors:

[auto build test ERROR on mszeredi-fuse/for-next]
[also build test ERROR on linus/master v6.18-rc2 next-20251023]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Joanne-Koong/io-uring-add-io_uring_cmd_get_buffer_info/20251023-042601
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-next
patch link:    https://lore.kernel.org/r/20251022202021.3649586-3-joannelkoong%40gmail.com
patch subject: [PATCH v1 2/2] fuse: support io-uring registered buffers
config: i386-buildonly-randconfig-003-20251023 (https://download.01.org/0day-ci/archive/20251023/202510232014.8BtM55jj-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251023/202510232014.8BtM55jj-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510232014.8BtM55jj-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from fs/fuse/inode.c:11:
>> fs/fuse/dev_uring_i.h:51:41: error: field 'payload_iter' has incomplete type
      51 |                         struct iov_iter payload_iter;
         |                                         ^~~~~~~~~~~~
>> fs/fuse/dev_uring_i.h:52:41: error: field 'headers_iter' has incomplete type
      52 |                         struct iov_iter headers_iter;
         |                                         ^~~~~~~~~~~~


vim +/payload_iter +51 fs/fuse/dev_uring_i.h

    38	
    39	/** A fuse ring entry, part of the ring queue */
    40	struct fuse_ring_ent {
    41		/* True if daemon has registered its buffers ahead of time */
    42		bool is_fixed_buffer;
    43		union {
    44			/* userspace buffer */
    45			struct {
    46				struct fuse_uring_req_header __user *headers;
    47				void __user *payload;
    48			} user;
    49	
    50			struct {
  > 51				struct iov_iter payload_iter;
  > 52				struct iov_iter headers_iter;
    53			} fixed_buffer;
    54		};
    55	
    56		/* the ring queue that owns the request */
    57		struct fuse_ring_queue *queue;
    58	
    59		/* fields below are protected by queue->lock */
    60	
    61		struct io_uring_cmd *cmd;
    62	
    63		struct list_head list;
    64	
    65		enum fuse_ring_req_state state;
    66	
    67		struct fuse_req *fuse_req;
    68	};
    69	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

