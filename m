Return-Path: <io-uring+bounces-4256-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 017309B740C
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 06:11:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9C0451F22955
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 05:11:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF2FF13C3C2;
	Thu, 31 Oct 2024 05:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cLiQx+tN"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE4780BFF;
	Thu, 31 Oct 2024 05:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730351461; cv=none; b=OXY9Td405A2u7VVhysofNrzdo8RSrIO4s4uKP6TXmmDpZXiLRaK5h5cmAusaUz4wuzgYr5PLSG3BLIzoFXTK25pPr/nYeEuDZ8+KfktFlJa+Z9ILKPTuUUO2/KVDX8ajv+gZ+PV7U2fSWh+poZmj2FEyHDi79f8byGBwP/Amg2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730351461; c=relaxed/simple;
	bh=9vZzBCAsC062W9Df4/VGF9NQR6R/aHZDeAs+rsCpev8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hmpKRS7M2ISn7/wXRgSmEaGzY39QbmmiDs0gdT/NHJVCKmPGWcx98y5hSn4JdMPf78cJeGrJXjGX4+cjfevF5jDz3thxccxByHBqu7FSeiCYct6ZoUiSyDLLQ+19eqFLAUuUHLuwx9FbDoWlDtmpF5UTQG9+ovJf7677lsegl+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cLiQx+tN; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730351460; x=1761887460;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9vZzBCAsC062W9Df4/VGF9NQR6R/aHZDeAs+rsCpev8=;
  b=cLiQx+tN3unL1uU4Qf8FAJJFUaMKn3M/Yz4oYAkZz3cc3fLrt5WQ0q2U
   Qvs0eN0CoSxzwI+DS8J44nJKxwVNPgfptMnfc4jvqr3/+YR8sf4avbNn5
   I6ksRKSpKhQf+mCuUUeQChixaOL+gOlJk2fXiyxQ5FDh+iMfFW0Yz5cm7
   8x/HLDgf/xOe8+6IAZkUBohUgJRJsNmlRIAIHLO3zp2GyQGqn5FlnXyjG
   XCytf8XmqqFq9AHWOo1Znh3dY2aZEOMHcdhqdfpNkvHPeXTFYTOf1OLco
   13tJvxXxJiJITbb2+lQzAk/sxEIBtRWOSquZQ6jrjhVsJrExUjqdFhc7d
   w==;
X-CSE-ConnectionGUID: SMfZctzkQG+IxYyCBaTrnw==
X-CSE-MsgGUID: Ydz8hu9OSJOWECoJloHF/Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="52632737"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="52632737"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 22:11:00 -0700
X-CSE-ConnectionGUID: Kb9NHA9jRgmy4FPXYVg8rw==
X-CSE-MsgGUID: l+d0N/CZSDaXo4itPpZg4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,246,1725346800"; 
   d="scan'208";a="82069495"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 30 Oct 2024 22:10:55 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t6NSO-000fge-2S;
	Thu, 31 Oct 2024 05:10:52 +0000
Date: Thu, 31 Oct 2024 13:10:21 +0800
From: kernel test robot <lkp@intel.com>
To: Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk, hch@lst.de,
	kbusch@kernel.org, martin.petersen@oracle.com,
	asml.silence@gmail.com, brauner@kernel.org, viro@zeniv.linux.org.uk,
	jack@suse.cz
Cc: oe-kbuild-all@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
	gost.dev@samsung.com, vishak.g@samsung.com, anuj1072538@gmail.com,
	Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH v6 09/10] scsi: add support for user-meta interface
Message-ID: <202410311347.qYRyUdmR-lkp@intel.com>
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
config: x86_64-rhel-8.3 (https://download.01.org/0day-ci/archive/20241031/202410311347.qYRyUdmR-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241031/202410311347.qYRyUdmR-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410311347.qYRyUdmR-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/blk-integrity.h:6,
                    from block/bio-integrity.c:9:
   block/bio-integrity.c: In function 'bio_integrity_clone':
>> include/linux/bio-integrity.h:35:49: error: 'BIP_CTRL_NOCHECK' undeclared (first use in this function); did you mean 'BIP_DISK_NOCHECK'?
      35 | #define BIP_CLONE_FLAGS (BIP_MAPPED_INTEGRITY | BIP_CTRL_NOCHECK | \
         |                                                 ^~~~~~~~~~~~~~~~
   block/bio-integrity.c:566:47: note: in expansion of macro 'BIP_CLONE_FLAGS'
     566 |         bip->bip_flags = bip_src->bip_flags & BIP_CLONE_FLAGS;
         |                                               ^~~~~~~~~~~~~~~
   include/linux/bio-integrity.h:35:49: note: each undeclared identifier is reported only once for each function it appears in
      35 | #define BIP_CLONE_FLAGS (BIP_MAPPED_INTEGRITY | BIP_CTRL_NOCHECK | \
         |                                                 ^~~~~~~~~~~~~~~~
   block/bio-integrity.c:566:47: note: in expansion of macro 'BIP_CLONE_FLAGS'
     566 |         bip->bip_flags = bip_src->bip_flags & BIP_CLONE_FLAGS;
         |                                               ^~~~~~~~~~~~~~~


vim +35 include/linux/bio-integrity.h

da042a365515115 Christoph Hellwig 2024-07-02  34  
be32c1180d327a0 Anuj Gupta        2024-10-30 @35  #define BIP_CLONE_FLAGS (BIP_MAPPED_INTEGRITY | BIP_CTRL_NOCHECK | \
ed538815d9325f6 Anuj Gupta        2024-10-30  36  			 BIP_IP_CHECKSUM | BIP_CHECK_GUARD | \
ed538815d9325f6 Anuj Gupta        2024-10-30  37  			 BIP_CHECK_REFTAG | BIP_CHECK_APPTAG)
be32c1180d327a0 Anuj Gupta        2024-10-30  38  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

