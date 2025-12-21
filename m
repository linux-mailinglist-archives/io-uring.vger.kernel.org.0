Return-Path: <io-uring+bounces-11243-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 362E6CD40CE
	for <lists+io-uring@lfdr.de>; Sun, 21 Dec 2025 14:50:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5C0EE3000B77
	for <lists+io-uring@lfdr.de>; Sun, 21 Dec 2025 13:50:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4118381ACA;
	Sun, 21 Dec 2025 13:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ApAtOcdk"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889AE18CBE1;
	Sun, 21 Dec 2025 13:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766325024; cv=none; b=or79jmDcqQ9h7mvPXec0neC+RML9teVjQ2xB0sT+v06jcrJ82s/QVTFev0y+F0aRlWh7BfoCUCZ7xsOd6yp/V0fdpG3vFlPuFLU0Dj1gYo9USSMKq1wTOOgpkkvPxapvxB/5LZq05/7Hh3R5uqLSRxcn07CzhpkJUZMV0DSkNMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766325024; c=relaxed/simple;
	bh=0UMBuPsh+npKSmTKDqiNdaBPkOMxU7iid/wS/f+fc2s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MaeDoioy/v4PkIDPlj5Zd8lWd0yqYpMf/LjAF3HmdY69Uv3cjxZXNOq3+TP+ASpFnMDNmWaWxBHNQh2RSiDy5uj45jgCLgOUixNUo/TunUnjyY6CkB62GdHl2d5acD8V1R+TD5ybFH16Vgwkmds7E5XCBqvic2frJw/cqiYyhWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ApAtOcdk; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766325021; x=1797861021;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0UMBuPsh+npKSmTKDqiNdaBPkOMxU7iid/wS/f+fc2s=;
  b=ApAtOcdkEfnviAGYoUH9Sax7l/k3iOzPrrINHY04Ik0z8GBvtgEOi2QG
   ltHKVWkpeXhkTEbdw6EkTW209om3vudg4vCfLXbUlK1rfOZrs0dyqIEn6
   Sz1TG7OQf9WjkLQ3Gs69zJ//mu2f9D2J85MEjn0Inh3UH9K+3umlZTxDp
   vh1S3u9VyE5PlqNB4TA4d91ridvI4FO4i0ceCJTgFKAqNhBH7VRc4qWpu
   Ttba52Yqhu2n3BYJFSm2W2U6BQtrOdYbnEUU2drJ/1hJflpirUtdMgqiC
   dABUwZYsAiswWlCeH6X+Jc1n5JjUEva9I2ZyDxjbpy24UqcC0qlXGKy3T
   Q==;
X-CSE-ConnectionGUID: fESKx/G7Rbm+sqXMwnW+bw==
X-CSE-MsgGUID: j97mZDFVQnmMIVZf5X2mUg==
X-IronPort-AV: E=McAfee;i="6800,10657,11649"; a="72054962"
X-IronPort-AV: E=Sophos;i="6.21,166,1763452800"; 
   d="scan'208";a="72054962"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2025 05:50:21 -0800
X-CSE-ConnectionGUID: sMHCfxaMSj+Pz+fEwrrffw==
X-CSE-MsgGUID: AvmMsgCZTZ64tPXbAhnU8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,166,1763452800"; 
   d="scan'208";a="204373396"
Received: from lkp-server01.sh.intel.com (HELO 0d09efa1b85f) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 21 Dec 2025 05:50:18 -0800
Received: from kbuild by 0d09efa1b85f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vXJpA-000000005iL-06JW;
	Sun, 21 Dec 2025 13:50:16 +0000
Date: Sun, 21 Dec 2025 21:49:19 +0800
From: kernel test robot <lkp@intel.com>
To: Joanne Koong <joannelkoong@gmail.com>, miklos@szeredi.hu,
	axboe@kernel.dk
Cc: oe-kbuild-all@lists.linux.dev, bschubert@ddn.com,
	asml.silence@gmail.com, io-uring@vger.kernel.org,
	csander@purestorage.com, xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 05/25] io_uring/kbuf: support kernel-managed buffer
 rings in buffer selection
Message-ID: <202512212111.RWRN4N7A-lkp@intel.com>
References: <20251218083319.3485503-6-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218083319.3485503-6-joannelkoong@gmail.com>

Hi Joanne,

kernel test robot noticed the following build warnings:

[auto build test WARNING on axboe/for-next]
[also build test WARNING on linus/master v6.19-rc1 next-20251219]
[cannot apply to mszeredi-fuse/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Joanne-Koong/io_uring-kbuf-refactor-io_buf_pbuf_register-logic-into-generic-helpers/20251218-165107
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git for-next
patch link:    https://lore.kernel.org/r/20251218083319.3485503-6-joannelkoong%40gmail.com
patch subject: [PATCH v2 05/25] io_uring/kbuf: support kernel-managed buffer rings in buffer selection
config: nios2-allnoconfig (https://download.01.org/0day-ci/archive/20251221/202512212111.RWRN4N7A-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251221/202512212111.RWRN4N7A-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512212111.RWRN4N7A-lkp@intel.com/

All warnings (new ones prefixed by >>):

   io_uring/kbuf.c: In function 'io_ring_buffer_select':
>> io_uring/kbuf.c:210:29: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
     210 |                 sel.kaddr = (void *)buf->addr;
         |                             ^
   io_uring/kbuf.c: In function 'io_setup_kmbuf_ring':
   io_uring/kbuf.c:826:29: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     826 |                 buf->addr = (u64)buf_region;
         |                             ^


vim +210 io_uring/kbuf.c

   183	
   184	static struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
   185						      struct io_buffer_list *bl,
   186						      unsigned int issue_flags)
   187	{
   188		struct io_uring_buf_ring *br = bl->buf_ring;
   189		__u16 tail, head = bl->head;
   190		struct io_br_sel sel = { };
   191		struct io_uring_buf *buf;
   192		u32 buf_len;
   193	
   194		tail = smp_load_acquire(&br->tail);
   195		if (unlikely(tail == head))
   196			return sel;
   197	
   198		if (head + 1 == tail)
   199			req->flags |= REQ_F_BL_EMPTY;
   200	
   201		buf = io_ring_head_to_buf(br, head, bl->mask);
   202		buf_len = READ_ONCE(buf->len);
   203		if (*len == 0 || *len > buf_len)
   204			*len = buf_len;
   205		req->flags |= REQ_F_BUFFER_RING | REQ_F_BUFFERS_COMMIT;
   206		req->buf_index = READ_ONCE(buf->bid);
   207		sel.buf_list = bl;
   208		sel.addr = u64_to_user_ptr(READ_ONCE(buf->addr));
   209		if (bl->flags & IOBL_KERNEL_MANAGED)
 > 210			sel.kaddr = (void *)buf->addr;
   211		else
   212			sel.addr = u64_to_user_ptr(READ_ONCE(buf->addr));
   213	
   214		if (io_should_commit(req, bl, issue_flags)) {
   215			io_kbuf_commit(req, sel.buf_list, *len, 1);
   216			sel.buf_list = NULL;
   217		}
   218		return sel;
   219	}
   220	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

