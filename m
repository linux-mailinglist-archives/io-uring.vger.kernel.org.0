Return-Path: <io-uring+bounces-10158-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 76F8BC01578
	for <lists+io-uring@lfdr.de>; Thu, 23 Oct 2025 15:23:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2EE544E252C
	for <lists+io-uring@lfdr.de>; Thu, 23 Oct 2025 13:23:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7C3030C345;
	Thu, 23 Oct 2025 13:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B01qGBel"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA043019DA;
	Thu, 23 Oct 2025 13:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761225826; cv=none; b=EFdmen/4CSrXmKhPOjjCG5Y1bRP8W2Ylc/ob+USRc0Cx64+iPWc1BHryQ8oamZ5WTwA9Yz/i6jySKc8DDkNWtuWBb8YqwIxQmCZAMzDvGcNgG2mnoVlWSsbz/G3n2uk3I0wG64Z8NOfFzyJLWRuLU2tyjCiHEckJUYwWlTscD94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761225826; c=relaxed/simple;
	bh=UZJ7rtuDhf2dV+t2MpDDxignV1q/vjHFdxInnFmgxbg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=buzh0Lx7gn+FMz/HFzk7vPdmP1cpEi8mCd41a+Ub0X9pRWYxakfgnjKsSIlpV6yezyuAM1uNghPH7XbIuzuddW4DYWTh/40PekewCjfPJbUqRbHmXbiDrJRnpyUMWOE5D1JorIWB9d+IcKZV+JxfML50B2LF6jJ5J10n+aI8nWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B01qGBel; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761225824; x=1792761824;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UZJ7rtuDhf2dV+t2MpDDxignV1q/vjHFdxInnFmgxbg=;
  b=B01qGBeld2r0c6+dxn7X3SwOLEPTqpc5izMC8ZMpLtBRZCRZSuvzE6hl
   l3iVwSAuLKKkeZrsUcGdrzhTYMO+UM+K+qolPibyMl1UzWpmuh5NKqqNG
   SL6GL5qRQOtTuVUEmllKFCcJyzPoJpcpbjhrGURmOW9E0KjIwbTA4ymPm
   issWIT8Ex9F5SW5vp8LeWSwchhUCk+R17zzED4aV6Dq6P+JfAqgxxuvVY
   GYk4mrMrY7omdVydycXIc+JCf7cLolHJqKXAS5qgd2Pgi/D6YDTbKNbsA
   nR9UCcFrNk19f2E3BCqEUvQk88oH50luYYtEKf3sLgUQSyVO9Kjo9bjZv
   w==;
X-CSE-ConnectionGUID: Y18tH/vWReCxX9mo6YKv5A==
X-CSE-MsgGUID: rJwEahUPQ7OR/uc+PZV8ag==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="62603631"
X-IronPort-AV: E=Sophos;i="6.19,249,1754982000"; 
   d="scan'208";a="62603631"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 06:23:44 -0700
X-CSE-ConnectionGUID: bL2DiRSvQQSnFiykPx9JpQ==
X-CSE-MsgGUID: Zps6QcEdQ+iOkzg3PGwFSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,249,1754982000"; 
   d="scan'208";a="184546770"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by fmviesa008.fm.intel.com with ESMTP; 23 Oct 2025 06:23:41 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vBvHn-000DWX-0w;
	Thu, 23 Oct 2025 13:23:29 +0000
Date: Thu, 23 Oct 2025 21:22:27 +0800
From: kernel test robot <lkp@intel.com>
To: Joanne Koong <joannelkoong@gmail.com>, miklos@szeredi.hu,
	axboe@kernel.dk
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, bschubert@ddn.com,
	asml.silence@gmail.com, io-uring@vger.kernel.org,
	xiaobing.li@samsung.com
Subject: Re: [PATCH v1 2/2] fuse: support io-uring registered buffers
Message-ID: <202510232038.LOpSOOQa-lkp@intel.com>
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
config: i386-buildonly-randconfig-002-20251023 (https://download.01.org/0day-ci/archive/20251023/202510232038.LOpSOOQa-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251023/202510232038.LOpSOOQa-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510232038.LOpSOOQa-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from fs/fuse/dev.c:9:
>> fs/fuse/dev_uring_i.h:51:20: error: field has incomplete type 'struct iov_iter'
      51 |                         struct iov_iter payload_iter;
         |                                         ^
   include/linux/fs.h:74:8: note: forward declaration of 'struct iov_iter'
      74 | struct iov_iter;
         |        ^
   In file included from fs/fuse/dev.c:9:
   fs/fuse/dev_uring_i.h:52:20: error: field has incomplete type 'struct iov_iter'
      52 |                         struct iov_iter headers_iter;
         |                                         ^
   include/linux/fs.h:74:8: note: forward declaration of 'struct iov_iter'
      74 | struct iov_iter;
         |        ^
   2 errors generated.
--
   In file included from fs/fuse/dev_uring.c:8:
>> fs/fuse/dev_uring_i.h:51:20: error: field has incomplete type 'struct iov_iter'
      51 |                         struct iov_iter payload_iter;
         |                                         ^
   include/linux/fs.h:74:8: note: forward declaration of 'struct iov_iter'
      74 | struct iov_iter;
         |        ^
   In file included from fs/fuse/dev_uring.c:8:
   fs/fuse/dev_uring_i.h:52:20: error: field has incomplete type 'struct iov_iter'
      52 |                         struct iov_iter headers_iter;
         |                                         ^
   include/linux/fs.h:74:8: note: forward declaration of 'struct iov_iter'
      74 | struct iov_iter;
         |        ^
>> fs/fuse/dev_uring.c:588:22: error: no member named 'fixed_buffer' in 'struct fuse_ring_ent'
     588 |         payload_iter = ent->fixed_buffer.payload_iter;
         |                        ~~~  ^
   fs/fuse/dev_uring.c:590:22: error: no member named 'fixed_buffer' in 'struct fuse_ring_ent'
     590 |         headers_iter = ent->fixed_buffer.headers_iter;
         |                        ~~~  ^
>> fs/fuse/dev_uring.c:618:43: error: no member named 'user' in 'struct fuse_ring_ent'
     618 |         err = copy_from_user(&ring_in_out, &ent->user.headers->ring_ent_in_out,
         |                                             ~~~  ^
   fs/fuse/dev_uring.c:623:38: error: no member named 'user' in 'struct fuse_ring_ent'
     623 |         err = import_ubuf(ITER_SOURCE, ent->user.payload, ring->max_payload_sz,
         |                                        ~~~  ^
   fs/fuse/dev_uring.c:653:22: error: no member named 'fixed_buffer' in 'struct fuse_ring_ent'
     653 |         payload_iter = ent->fixed_buffer.payload_iter;
         |                        ~~~  ^
   fs/fuse/dev_uring.c:656:22: error: no member named 'fixed_buffer' in 'struct fuse_ring_ent'
     656 |         headers_iter = ent->fixed_buffer.headers_iter;
         |                        ~~~  ^
   fs/fuse/dev_uring.c:725:36: error: no member named 'user' in 'struct fuse_ring_ent'
     725 |         err = import_ubuf(ITER_DEST, ent->user.payload, ring->max_payload_sz, &iter);
         |                                      ~~~  ^
   fs/fuse/dev_uring.c:741:29: error: no member named 'user' in 'struct fuse_ring_ent'
     741 |                         err = copy_to_user(&ent->user.headers->op_in, in_args->value,
         |                                             ~~~  ^
   fs/fuse/dev_uring.c:762:27: error: no member named 'user' in 'struct fuse_ring_ent'
     762 |         err = copy_to_user(&ent->user.headers->ring_ent_in_out, &ent_in_out,
         |                             ~~~  ^
   fs/fuse/dev_uring.c:797:39: error: no member named 'fixed_buffer' in 'struct fuse_ring_ent'
     797 |                 struct iov_iter headers_iter = ent->fixed_buffer.headers_iter;
         |                                                ~~~  ^
   fs/fuse/dev_uring.c:807:28: error: no member named 'user' in 'struct fuse_ring_ent'
     807 |                 err = copy_to_user(&ent->user.headers->in_out, &req->in.h,
         |                                     ~~~  ^
   fs/fuse/dev_uring.c:936:39: error: no member named 'fixed_buffer' in 'struct fuse_ring_ent'
     936 |                 struct iov_iter headers_iter = ent->fixed_buffer.headers_iter;
         |                                                ~~~  ^
   fs/fuse/dev_uring.c:944:43: error: no member named 'user' in 'struct fuse_ring_ent'
     944 |                 err = copy_from_user(&req->out.h, &ent->user.headers->in_out,
         |                                                    ~~~  ^
   fs/fuse/dev_uring.c:1187:12: error: no member named 'fixed_buffer' in 'struct fuse_ring_ent'
    1187 |                                         &ent->fixed_buffer.payload_iter, cmd, 0);
         |                                          ~~~  ^
   fs/fuse/dev_uring.c:1194:12: error: no member named 'fixed_buffer' in 'struct fuse_ring_ent'
    1194 |                                         &ent->fixed_buffer.headers_iter, cmd, 0);
         |                                          ~~~  ^
   fs/fuse/dev_uring.c:1245:7: error: no member named 'user' in 'struct fuse_ring_ent'
    1245 |         ent->user.headers = iov[0].iov_base;
         |         ~~~  ^
   fs/fuse/dev_uring.c:1246:7: error: no member named 'user' in 'struct fuse_ring_ent'
    1246 |         ent->user.payload = iov[1].iov_base;
         |         ~~~  ^
   19 errors generated.


vim +51 fs/fuse/dev_uring_i.h

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
    52				struct iov_iter headers_iter;
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

