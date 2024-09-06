Return-Path: <io-uring+bounces-3054-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AA2B696E82A
	for <lists+io-uring@lfdr.de>; Fri,  6 Sep 2024 05:24:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 28B911F24163
	for <lists+io-uring@lfdr.de>; Fri,  6 Sep 2024 03:24:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 291F23770D;
	Fri,  6 Sep 2024 03:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bwURKxXy"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791BD1773A;
	Fri,  6 Sep 2024 03:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725593045; cv=none; b=eZieF4OVi8XC4wimMfW9iRraLtBb85eunF24qISxlXGHVEffA+VXCTpBVMqgwgD9rbr5Ti8hZuHKebgsS9JrE5s2YgxWHSnkaKZMTgc8sPBxvr6k6V2wgSIfnHTh9OmYIQacwvySYmqDkz2EJOVPew6EJILqMRpRzhe/hUucJ50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725593045; c=relaxed/simple;
	bh=RH6TZLZQD54kymWTWzrD/ChEmeUBlBEentXZxNOU++s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g+c4ZfOIC8dg5MKUU4FpRYMSheDV1ckaSFiXoGhr0wELqDCy8ZkMVQ1UZh0Qg5Bjr6W5HTzNwCp6i894qbTNUt/IrIXmW97PggjC9SgV3laSpiHRHrHA3FkCxwn4t0Fww/g1rfXxOb4LdZbpO70098gMUjfz4Fp/FOgRKJxpKtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bwURKxXy; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725593044; x=1757129044;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RH6TZLZQD54kymWTWzrD/ChEmeUBlBEentXZxNOU++s=;
  b=bwURKxXydBE4loQEEqtNEvNP8OAskbUs9mt+9IAeylh49wJUY5OCq5i8
   EpajR+RHvjMIMKdRhfmvkYIbwG3/Lu8Qg9rX1qQmC152Fsqm32S5iBPEL
   OdprMq/7Q2rqPRfU8YPCXGCC5RixOChviqJ1izovFutWJ89Qj7O4Ss4iI
   eWPT8x15MT2IUJGuask14yhFclAMglxwdgl7on0CFx/aD+GtK4GaYrV/9
   n4QEBEUrbq8Viz8SehtJ323BWwx9XixtfgycoyViuWsnMJGX65rL+abMi
   zjrKAeocnDvYArUgkt15sB86f6wBgG/v6VJH+h9R+Vadk6ZnwDGQZB4gH
   w==;
X-CSE-ConnectionGUID: Jt3qzRa7SVKOijCPggK74Q==
X-CSE-MsgGUID: n/eVVuMwRL+3m0v6SxUeVA==
X-IronPort-AV: E=McAfee;i="6700,10204,11186"; a="35012714"
X-IronPort-AV: E=Sophos;i="6.10,206,1719903600"; 
   d="scan'208";a="35012714"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2024 20:24:03 -0700
X-CSE-ConnectionGUID: cA6JjpjfQZqIGy6c+qY9hA==
X-CSE-MsgGUID: fFkCuXrFRICuRwwqMHvuJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,206,1719903600"; 
   d="scan'208";a="70393846"
Received: from lkp-server01.sh.intel.com (HELO 9c6b1c7d3b50) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 05 Sep 2024 20:24:01 -0700
Received: from kbuild by 9c6b1c7d3b50 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1smPZm-000AZ2-21;
	Fri, 06 Sep 2024 03:23:58 +0000
Date: Fri, 6 Sep 2024 11:23:09 +0800
From: kernel test robot <lkp@intel.com>
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com, Conrad Meyer <conradmeyer@meta.com>,
	linux-block@vger.kernel.org, linux-mm@kvack.org,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 7/8] block: add nowait flag for
 __blkdev_issue_zero_pages
Message-ID: <202409061126.hKdAymJK-lkp@intel.com>
References: <292fa1c611adb064efe16ab741aad65c2128ada8.1725459175.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <292fa1c611adb064efe16ab741aad65c2128ada8.1725459175.git.asml.silence@gmail.com>

Hi Pavel,

kernel test robot noticed the following build warnings:

[auto build test WARNING on axboe-block/for-next]
[also build test WARNING on akpm-mm/mm-everything linus/master v6.11-rc6 next-20240905]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Pavel-Begunkov/io_uring-cmd-expose-iowq-to-cmds/20240904-222012
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
patch link:    https://lore.kernel.org/r/292fa1c611adb064efe16ab741aad65c2128ada8.1725459175.git.asml.silence%40gmail.com
patch subject: [PATCH v3 7/8] block: add nowait flag for __blkdev_issue_zero_pages
config: i386-randconfig-141-20240906 (https://download.01.org/0day-ci/archive/20240906/202409061126.hKdAymJK-lkp@intel.com/config)
compiler: clang version 18.1.5 (https://github.com/llvm/llvm-project 617a15a9eac96088ae5e9134248d8236e34b91b1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240906/202409061126.hKdAymJK-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202409061126.hKdAymJK-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> block/blk-lib.c:200:12: warning: variable 'opf' set but not used [-Wunused-but-set-variable]
     200 |         blk_opf_t opf = REQ_OP_WRITE;
         |                   ^
   1 warning generated.


vim +/opf +200 block/blk-lib.c

   195	
   196	int blkdev_issue_zero_pages_bio(struct block_device *bdev,
   197			sector_t sector, sector_t nr_sects, gfp_t gfp_mask,
   198			struct bio **biop, unsigned int flags)
   199	{
 > 200		blk_opf_t opf = REQ_OP_WRITE;
   201	
   202		if (flags & BLKDEV_ZERO_PAGES_NOWAIT) {
   203			sector_t max_bio_sectors = BIO_MAX_VECS << PAGE_SECTORS_SHIFT;
   204	
   205			if (nr_sects > max_bio_sectors)
   206				return -EAGAIN;
   207			opf |= REQ_NOWAIT;
   208		}
   209	
   210		while (nr_sects) {
   211			unsigned int nr_vecs = __blkdev_sectors_to_bio_pages(nr_sects);
   212			struct bio *bio;
   213	
   214			bio = bio_alloc(bdev, nr_vecs, REQ_OP_WRITE, gfp_mask);
   215			if (!bio)
   216				return -ENOMEM;
   217			bio->bi_iter.bi_sector = sector;
   218	
   219			if ((flags & BLKDEV_ZERO_KILLABLE) &&
   220			    fatal_signal_pending(current))
   221				return -EINTR;
   222	
   223			do {
   224				unsigned int len, added;
   225	
   226				len = min_t(sector_t,
   227					PAGE_SIZE, nr_sects << SECTOR_SHIFT);
   228				added = bio_add_page(bio, ZERO_PAGE(0), len, 0);
   229				if (added < len)
   230					break;
   231				nr_sects -= added >> SECTOR_SHIFT;
   232				sector += added >> SECTOR_SHIFT;
   233			} while (nr_sects);
   234	
   235			*biop = bio_chain_and_submit(*biop, bio);
   236			cond_resched();
   237		}
   238	
   239		return 0;
   240	}
   241	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

