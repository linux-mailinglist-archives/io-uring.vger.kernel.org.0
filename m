Return-Path: <io-uring+bounces-12-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7D1A7DC370
	for <lists+io-uring@lfdr.de>; Tue, 31 Oct 2023 01:14:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 54C4D2813EF
	for <lists+io-uring@lfdr.de>; Tue, 31 Oct 2023 00:14:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61D2C360;
	Tue, 31 Oct 2023 00:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T4QTfUr6"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB36B362
	for <io-uring@vger.kernel.org>; Tue, 31 Oct 2023 00:14:22 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31554AB;
	Mon, 30 Oct 2023 17:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698711261; x=1730247261;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Kmk6KxUWFitEDciuF9oDB5RU0GkS5ElP0kWrFDqc2hQ=;
  b=T4QTfUr6/YSq1vg7ny2uz1VwHHcQLcN454TPmoF+cSp0E9UXlFVIKlvr
   Q3PiNohQxFIza8dT74KMNqhBCJwwuHFxnlm6JbZSB5b89piY86vIZRkMS
   NtJWz4xyqnsEODe8Wl5iafgqrJzL5Blf2AgQ+190iY6JNLzROVwhputl5
   1VdVt5gC33t+vEoZ/n7h3RAXpVDlhjc4esFo3GoPrF9T2d5y2ttxx08On
   pLsxKWQFeiw1Uy7dgpJyXfuHF7GwX1loOtE2+3fzsNiBCafpe4749Fwat
   YaSIMWYUbQA/NQ/TWV89nkMW4JqyvFTXcmFy/TO3n/6t3lF1gghlviv1v
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10879"; a="373236072"
X-IronPort-AV: E=Sophos;i="6.03,264,1694761200"; 
   d="scan'208";a="373236072"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2023 17:14:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10879"; a="1007586475"
X-IronPort-AV: E=Sophos;i="6.03,264,1694761200"; 
   d="scan'208";a="1007586475"
Received: from lkp-server01.sh.intel.com (HELO 8917679a5d3e) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 30 Oct 2023 17:14:17 -0700
Received: from kbuild by 8917679a5d3e with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1qxcOd-000Dg2-0P;
	Tue, 31 Oct 2023 00:14:15 +0000
Date: Tue, 31 Oct 2023 08:13:52 +0800
From: kernel test robot <lkp@intel.com>
To: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, io-uring@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, axboe@kernel.dk,
	hch@lst.de, joshi.k@samsung.com, martin.petersen@oracle.com,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv2 1/4] block: bio-integrity: directly map user buffers
Message-ID: <202310310704.l4FwoJDd-lkp@intel.com>
References: <20231027181929.2589937-2-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231027181929.2589937-2-kbusch@meta.com>

Hi Keith,

kernel test robot noticed the following build warnings:

[auto build test WARNING on axboe-block/for-next]
[also build test WARNING on linus/master v6.6 next-20231030]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Keith-Busch/block-bio-integrity-directly-map-user-buffers/20231028-022107
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
patch link:    https://lore.kernel.org/r/20231027181929.2589937-2-kbusch%40meta.com
patch subject: [PATCHv2 1/4] block: bio-integrity: directly map user buffers
config: x86_64-rhel-8.3-rust (https://download.01.org/0day-ci/archive/20231031/202310310704.l4FwoJDd-lkp@intel.com/config)
compiler: clang version 16.0.4 (https://github.com/llvm/llvm-project.git ae42196bc493ffe877a7e3dff8be32035dea4d07)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231031/202310310704.l4FwoJDd-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202310310704.l4FwoJDd-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> block/bio-integrity.c:215:6: warning: variable 'ret' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
           if (!buf)
               ^~~~
   block/bio-integrity.c:255:9: note: uninitialized use occurs here
           return ret;
                  ^~~
   block/bio-integrity.c:215:2: note: remove the 'if' if its condition is always false
           if (!buf)
           ^~~~~~~~~
   block/bio-integrity.c:204:9: note: initialize the variable 'ret' to silence this warning
           int ret;
                  ^
                   = 0
   1 warning generated.


vim +215 block/bio-integrity.c

   195	
   196	static int bio_integrity_copy_user(struct bio *bio, struct bio_vec *bvec,
   197					   int nr_vecs, unsigned int len,
   198					   unsigned int direction, u32 seed)
   199	{
   200		struct bio_integrity_payload *bip;
   201		struct bio_vec *copy_vec = NULL;
   202		struct iov_iter iter;
   203		void *buf;
   204		int ret;
   205	
   206		/* if bvec is on the stack, we need to allocate a copy for the completion */
   207		if (nr_vecs <= UIO_FASTIOV) {
   208			copy_vec = kcalloc(sizeof(*bvec), nr_vecs, GFP_KERNEL);
   209			if (!copy_vec)
   210				return -ENOMEM;
   211			memcpy(copy_vec, bvec, nr_vecs * sizeof(*bvec));
   212		}
   213	
   214		buf = kmalloc(len, GFP_KERNEL);
 > 215		if (!buf)
   216			goto free_copy;
   217	
   218		if (direction == ITER_SOURCE) {
   219			iov_iter_bvec(&iter, direction, bvec, nr_vecs, len);
   220			if (!copy_from_iter_full(buf, len, &iter)) {
   221				ret = -EFAULT;
   222				goto free_buf;
   223			}
   224		} else {
   225			memset(buf, 0, len);
   226		}
   227	
   228		/*
   229		 * We just need one vec for this bip, but we need to preserve the
   230		 * number of vecs in the user bvec for the completion handling, so use
   231		 * nr_vecs.
   232		 */
   233		bip = bio_integrity_alloc(bio, GFP_KERNEL, nr_vecs);
   234		if (IS_ERR(bip)) {
   235			ret = PTR_ERR(bip);
   236			goto free_buf;
   237		}
   238	
   239		ret = bio_integrity_add_page(bio, virt_to_page(buf), len,
   240					     offset_in_page(buf));
   241		if (ret != len) {
   242			ret = -ENOMEM;
   243			goto free_bip;
   244		}
   245	
   246		bip->bip_flags |= BIP_INTEGRITY_USER;
   247		bip->copy_vec = copy_vec ?: bvec;
   248		return 0;
   249	free_bip:
   250		bio_integrity_free(bio);
   251	free_buf:
   252		kfree(buf);
   253	free_copy:
   254		kfree(copy_vec);
   255		return ret;
   256	}
   257	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

