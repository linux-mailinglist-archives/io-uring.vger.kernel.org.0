Return-Path: <io-uring+bounces-4255-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F180B9B7409
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 06:10:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 214201C24120
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 05:10:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74C0413D882;
	Thu, 31 Oct 2024 05:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lu8mjrwu"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B91912D75C;
	Thu, 31 Oct 2024 05:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730351403; cv=none; b=VL58QVBKI9b6jDZUM61N0XzrTt4fEW4LToWzyX0TJaivgRtRro7mO+lxtN2wyWcAAdZ/YAjSGWYi2c4whmVyIR+8divO0cxcjTpAqr4kVy26NFpMgU2TuuBb2frXOJ44Cd4US4uiPlbC5M3VrIXHKfh+IrJ43rMhsirrKie3HpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730351403; c=relaxed/simple;
	bh=o33fEU0qc+QJil6u77F7U8IznH6MnN89js/HQ2lP1A8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=axcem6KQuXU52sGHy6cMcxynFmGdzFQAvI9ocWtVt6gc43MsjFPVf2EgCk55WHYhb4sAbmo6vFONK34pqCe8zPL5WivUTIiQjqHzDFdDsJZrmDleM/n92HqNZt4MawZfEj0j2vJP97fHVR9VoWEyCsqjWWim7Sd7N/mDz09Qkos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Lu8mjrwu; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730351401; x=1761887401;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=o33fEU0qc+QJil6u77F7U8IznH6MnN89js/HQ2lP1A8=;
  b=Lu8mjrwuNa0meNvj/hYw6Xgl40SmY68P5mXmXUty5wQR9qk5OU1UMu66
   5DD5bYWtNR+mmqv6OE9rkyl9fM/DPpOpaZipp4Ak2MsP/EBYVY5TpGq0b
   ixdg9c/RRqaH74D0aScqikKBt27Dn1nnxOecc9TuyRcVDD7cD91bNPCv4
   xDPkSTEhs8al7dhh7viTxkQm25kD7zSQjgpBz3Vm5YN5/o6+3etitBzPE
   U+ucII5K2MZOcOyPR7ZO996wsH6eoy7kMivNJOEybuMP/cqcKySrfzZk3
   TMAKmj2W1d3xncA4/kgQgGCndKV+Z5YqhU8wKRe+Oibh9gD9epBcT4KAf
   A==;
X-CSE-ConnectionGUID: Xt2HqBP1TjmvFIIbYrkVvQ==
X-CSE-MsgGUID: VHpW8ONRTNCWNPLZBRrTVg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30235293"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30235293"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 22:10:01 -0700
X-CSE-ConnectionGUID: qw8pILinQ3yI9qSP+KhdOg==
X-CSE-MsgGUID: MF9jUSkUTu6F4v+s72Dxxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="87311618"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 30 Oct 2024 22:09:56 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t6NRQ-000fgX-2O;
	Thu, 31 Oct 2024 05:09:52 +0000
Date: Thu, 31 Oct 2024 13:09:36 +0800
From: kernel test robot <lkp@intel.com>
To: Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk, hch@lst.de,
	kbusch@kernel.org, martin.petersen@oracle.com,
	asml.silence@gmail.com, brauner@kernel.org, viro@zeniv.linux.org.uk,
	jack@suse.cz
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org, gost.dev@samsung.com,
	vishak.g@samsung.com, anuj1072538@gmail.com,
	Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH v6 09/10] scsi: add support for user-meta interface
Message-ID: <202410311216.YfNcxbSF-lkp@intel.com>
References: <20241030180112.4635-10-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241030180112.4635-10-joshi.k@samsung.com>

Hi Kanchan,

kernel test robot noticed the following build errors:

[auto build test ERROR on axboe-block/for-next]
[cannot apply to brauner-vfs/vfs.all mkp-scsi/for-next jejb-scsi/for-next linus/master v6.12-rc5 next-20241030]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Kanchan-Joshi/block-define-set-of-integrity-flags-to-be-inherited-by-cloned-bip/20241031-021248
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
patch link:    https://lore.kernel.org/r/20241030180112.4635-10-joshi.k%40samsung.com
patch subject: [PATCH v6 09/10] scsi: add support for user-meta interface
config: arm-randconfig-001-20241031 (https://download.01.org/0day-ci/archive/20241031/202410311216.YfNcxbSF-lkp@intel.com/config)
compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241031/202410311216.YfNcxbSF-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410311216.YfNcxbSF-lkp@intel.com/

All errors (new ones prefixed by >>):

>> block/bio-integrity.c:566:40: error: use of undeclared identifier 'BIP_CTRL_NOCHECK'; did you mean 'BIP_DISK_NOCHECK'?
     566 |         bip->bip_flags = bip_src->bip_flags & BIP_CLONE_FLAGS;
         |                                               ^
   include/linux/bio-integrity.h:35:49: note: expanded from macro 'BIP_CLONE_FLAGS'
      35 | #define BIP_CLONE_FLAGS (BIP_MAPPED_INTEGRITY | BIP_CTRL_NOCHECK | \
         |                                                 ^
   include/linux/bio-integrity.h:10:2: note: 'BIP_DISK_NOCHECK' declared here
      10 |         BIP_DISK_NOCHECK        = 1 << 2, /* disable disk integrity checking */
         |         ^
   1 error generated.

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for GET_FREE_REGION
   Depends on [n]: SPARSEMEM [=n]
   Selected by [y]:
   - RESOURCE_KUNIT_TEST [=y] && RUNTIME_TESTING_MENU [=y] && KUNIT [=y]


vim +566 block/bio-integrity.c

7ba1ba12eeef0aa fs/bio-integrity.c    Martin K. Petersen 2008-06-30  543  
7ba1ba12eeef0aa fs/bio-integrity.c    Martin K. Petersen 2008-06-30  544  /**
7ba1ba12eeef0aa fs/bio-integrity.c    Martin K. Petersen 2008-06-30  545   * bio_integrity_clone - Callback for cloning bios with integrity metadata
7ba1ba12eeef0aa fs/bio-integrity.c    Martin K. Petersen 2008-06-30  546   * @bio:	New bio
7ba1ba12eeef0aa fs/bio-integrity.c    Martin K. Petersen 2008-06-30  547   * @bio_src:	Original bio
87092698c665e0a fs/bio-integrity.c    un'ichi Nomura     2009-03-09  548   * @gfp_mask:	Memory allocation mask
7ba1ba12eeef0aa fs/bio-integrity.c    Martin K. Petersen 2008-06-30  549   *
7ba1ba12eeef0aa fs/bio-integrity.c    Martin K. Petersen 2008-06-30  550   * Description:	Called to allocate a bip when cloning a bio
7ba1ba12eeef0aa fs/bio-integrity.c    Martin K. Petersen 2008-06-30  551   */
7878cba9f0037f5 fs/bio-integrity.c    Martin K. Petersen 2009-06-26  552  int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
1e2a410ff71504a fs/bio-integrity.c    Kent Overstreet    2012-09-06  553  			gfp_t gfp_mask)
7ba1ba12eeef0aa fs/bio-integrity.c    Martin K. Petersen 2008-06-30  554  {
180b2f95dd33101 block/bio-integrity.c Martin K. Petersen 2014-09-26  555  	struct bio_integrity_payload *bip_src = bio_integrity(bio_src);
7ba1ba12eeef0aa fs/bio-integrity.c    Martin K. Petersen 2008-06-30  556  	struct bio_integrity_payload *bip;
7ba1ba12eeef0aa fs/bio-integrity.c    Martin K. Petersen 2008-06-30  557  
7ba1ba12eeef0aa fs/bio-integrity.c    Martin K. Petersen 2008-06-30  558  	BUG_ON(bip_src == NULL);
7ba1ba12eeef0aa fs/bio-integrity.c    Martin K. Petersen 2008-06-30  559  
ba942238056584e block/bio-integrity.c Anuj Gupta         2024-07-02  560  	bip = bio_integrity_alloc(bio, gfp_mask, 0);
7b6c0f8034d7839 block/bio-integrity.c Dan Carpenter      2015-12-09  561  	if (IS_ERR(bip))
7b6c0f8034d7839 block/bio-integrity.c Dan Carpenter      2015-12-09  562  		return PTR_ERR(bip);
7ba1ba12eeef0aa fs/bio-integrity.c    Martin K. Petersen 2008-06-30  563  
ba942238056584e block/bio-integrity.c Anuj Gupta         2024-07-02  564  	bip->bip_vec = bip_src->bip_vec;
d57a5f7c6605f15 fs/bio-integrity.c    Kent Overstreet    2013-11-23  565  	bip->bip_iter = bip_src->bip_iter;
be32c1180d327a0 block/bio-integrity.c Anuj Gupta         2024-10-30 @566  	bip->bip_flags = bip_src->bip_flags & BIP_CLONE_FLAGS;
7ba1ba12eeef0aa fs/bio-integrity.c    Martin K. Petersen 2008-06-30  567  
7ba1ba12eeef0aa fs/bio-integrity.c    Martin K. Petersen 2008-06-30  568  	return 0;
7ba1ba12eeef0aa fs/bio-integrity.c    Martin K. Petersen 2008-06-30  569  }
7ba1ba12eeef0aa fs/bio-integrity.c    Martin K. Petersen 2008-06-30  570  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

