Return-Path: <io-uring+bounces-4254-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FA469B73DE
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 05:34:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F016A286153
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 04:34:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DE28128369;
	Thu, 31 Oct 2024 04:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q81r0xgL"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97BC184047;
	Thu, 31 Oct 2024 04:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730349240; cv=none; b=tHK4NBPS4K5DDBKpmo8f40Sn4UizAfQ9l/ztvU5ss8iQvILQjnZtfkk7yTjHUucXu+Mxu+y+lMTr1YcKs4Y8UIat1Y0DJyNK6J/B+L4uwNUod2O9D7QwpUMdYnU4H2vWe8TwYJfb7+LWcRU1PCNrPWkTZVKkr3ifilGlhsS8/6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730349240; c=relaxed/simple;
	bh=VUkj7APm42ytkCv5hyJJUWMrjq2Ht8Itvcvvp3DRwr0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AhioS1LFbgEQw9oM85NT5Opv4lRDfLdlalLec4Weh5tE/3zes8Pd7MxBkvOwWzP3KdBCZmf2qWOqw0K+SaVLAv2c2esz0d3ccx3snEmV7puvVwoMi3+NiepBIXEZRq8JHc+IVjjsmHcPOM01O4C6W+Mbb1Amd83HSSvwsp6lGP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q81r0xgL; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730349238; x=1761885238;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VUkj7APm42ytkCv5hyJJUWMrjq2Ht8Itvcvvp3DRwr0=;
  b=Q81r0xgL8ZzqA0YQoyMfbf1hwE7TlcNSmwoRQd1egwhlB1fe7DC8+GsV
   WhECcDyYgMlBVA9bzjyVJniKFjBQ+7k2UWH9WkoVc7ZJKf0SPzKOgNvXt
   Pry5KEvFAGlHvSUXoSQqYERk+H3V/CA/Df6N8cWpggaLS6WjYvmGceL6F
   iyw2qJ3mvSaMuEybF/H076FYQyzGxTaRwr4asMB+Nuomm0rr2BufsxjGO
   7b2y4ZiMb1h1FJR6A3U6AqY4VrNvjqIy8ig6rnd412F5h+r9y7JoSV077
   7Cnh207NFyzWCXgmYl6ONFXCjTc6rQJPn1jSRU1bwQXln2kbLT2JkFhJJ
   Q==;
X-CSE-ConnectionGUID: Zmi5W2ciSfqcwoqkJfZ8yw==
X-CSE-MsgGUID: pW9FiY9MTIm4s1ohVHY9Jw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="52631564"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="52631564"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 21:33:58 -0700
X-CSE-ConnectionGUID: buv4+dYoTP+C97Nj5efliw==
X-CSE-MsgGUID: Rb1baIvVQLiVBWa/sKFkIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,246,1725346800"; 
   d="scan'208";a="82168572"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 30 Oct 2024 21:33:54 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t6MsZ-000ffK-1M;
	Thu, 31 Oct 2024 04:33:51 +0000
Date: Thu, 31 Oct 2024 12:33:01 +0800
From: kernel test robot <lkp@intel.com>
To: Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk, hch@lst.de,
	kbusch@kernel.org, martin.petersen@oracle.com,
	asml.silence@gmail.com, brauner@kernel.org, viro@zeniv.linux.org.uk,
	jack@suse.cz
Cc: oe-kbuild-all@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
	gost.dev@samsung.com, vishak.g@samsung.com, anuj1072538@gmail.com,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v6 03/10] block: modify bio_integrity_map_user to accept
 iov_iter as argument
Message-ID: <202410311228.zl84IPP6-lkp@intel.com>
References: <20241030180112.4635-4-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241030180112.4635-4-joshi.k@samsung.com>

Hi Kanchan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on axboe-block/for-next]
[cannot apply to brauner-vfs/vfs.all mkp-scsi/for-next jejb-scsi/for-next linus/master v6.12-rc5 next-20241030]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Kanchan-Joshi/block-define-set-of-integrity-flags-to-be-inherited-by-cloned-bip/20241031-021248
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
patch link:    https://lore.kernel.org/r/20241030180112.4635-4-joshi.k%40samsung.com
patch subject: [PATCH v6 03/10] block: modify bio_integrity_map_user to accept iov_iter as argument
config: alpha-allnoconfig (https://download.01.org/0day-ci/archive/20241031/202410311228.zl84IPP6-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 13.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241031/202410311228.zl84IPP6-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410311228.zl84IPP6-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/linux/blk-integrity.h:6,
                    from block/bdev.c:15:
>> include/linux/bio-integrity.h:104:12: warning: 'bio_integrity_map_user' defined but not used [-Wunused-function]
     104 | static int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter)
         |            ^~~~~~~~~~~~~~~~~~~~~~


vim +/bio_integrity_map_user +104 include/linux/bio-integrity.h

   103	
 > 104	static int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter)
   105	{
   106		return -EINVAL;
   107	}
   108	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

