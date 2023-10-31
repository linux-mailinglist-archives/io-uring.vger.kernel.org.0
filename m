Return-Path: <io-uring+bounces-14-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 118FD7DC4A0
	for <lists+io-uring@lfdr.de>; Tue, 31 Oct 2023 03:47:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC51D28155F
	for <lists+io-uring@lfdr.de>; Tue, 31 Oct 2023 02:47:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 296C0EC6;
	Tue, 31 Oct 2023 02:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SOyUaVqS"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877A7A56
	for <io-uring@vger.kernel.org>; Tue, 31 Oct 2023 02:47:11 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB1D9F;
	Mon, 30 Oct 2023 19:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698720430; x=1730256430;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=APU+txMIAmRxP33gXggiCb+jHbwCxGhqfZhP1z0AjZk=;
  b=SOyUaVqSh1oQ32agvGfj89FQqepG+ByzdyapvOpHcyfFe4iYGlu5+bEO
   kdFBK0Hf+17kLUbhSQEdwMEpT4bPTBaldiRhUzkgTBrhQvWyZh62a45A0
   byrsXmSGxqAqnDdOnzi6oHVNud0gQeDtMkiDGfjrUgf/R1pjspM09QzT0
   jkVmpAmolx83svM2StSfF7wllywNLZCEYATpSMH1oDiDqQbRQ+5V/0kKg
   qlnAaa8RkFPeb4r4mT2FpU3DRvEWjS2QOdVRnWuEZqpEpCEMO8AJ05bFL
   MGdMLvc6jje8ZXV2QGWcjaDvnTU6WJiyZ/Flui+IKsbOxYFjoG8brBCrg
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10879"; a="367546695"
X-IronPort-AV: E=Sophos;i="6.03,264,1694761200"; 
   d="scan'208";a="367546695"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2023 19:47:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10879"; a="1091852520"
X-IronPort-AV: E=Sophos;i="6.03,264,1694761200"; 
   d="scan'208";a="1091852520"
Received: from lkp-server01.sh.intel.com (HELO 8917679a5d3e) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 30 Oct 2023 19:47:06 -0700
Received: from kbuild by 8917679a5d3e with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1qxemW-000Dln-20;
	Tue, 31 Oct 2023 02:47:04 +0000
Date: Tue, 31 Oct 2023 10:46:25 +0800
From: kernel test robot <lkp@intel.com>
To: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, io-uring@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, axboe@kernel.dk, hch@lst.de,
	joshi.k@samsung.com, martin.petersen@oracle.com,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv2 1/4] block: bio-integrity: directly map user buffers
Message-ID: <202310311041.38ISTxlo-lkp@intel.com>
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

kernel test robot noticed the following build errors:

[auto build test ERROR on axboe-block/for-next]
[also build test ERROR on linus/master v6.6 next-20231030]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Keith-Busch/block-bio-integrity-directly-map-user-buffers/20231028-022107
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
patch link:    https://lore.kernel.org/r/20231027181929.2589937-2-kbusch%40meta.com
patch subject: [PATCHv2 1/4] block: bio-integrity: directly map user buffers
config: mips-allmodconfig (https://download.01.org/0day-ci/archive/20231031/202310311041.38ISTxlo-lkp@intel.com/config)
compiler: mips-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231031/202310311041.38ISTxlo-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202310311041.38ISTxlo-lkp@intel.com/

All errors (new ones prefixed by >>):

   block/bio-integrity.c: In function 'bio_integrity_map_user':
>> block/bio-integrity.c:294:72: error: passing argument 6 of 'iov_iter_extract_pages' from incompatible pointer type [-Werror=incompatible-pointer-types]
     294 |         bytes = iov_iter_extract_pages(&iter, &pages, len, nr_vecs, 0, &offs);
         |                                                                        ^~~~~
         |                                                                        |
         |                                                                        long unsigned int *
   In file included from include/linux/bio.h:11,
                    from include/linux/blkdev.h:17,
                    from include/linux/blk-mq.h:5,
                    from include/linux/blk-integrity.h:5,
                    from block/bio-integrity.c:9:
   include/linux/uio.h:400:40: note: expected 'size_t *' {aka 'unsigned int *'} but argument is of type 'long unsigned int *'
     400 |                                size_t *offset0);
         |                                ~~~~~~~~^~~~~~~
   cc1: some warnings being treated as errors


vim +/iov_iter_extract_pages +294 block/bio-integrity.c

   257	
   258	int bio_integrity_map_user(struct bio *bio, void __user *ubuf, unsigned int len,
   259				   u32 seed)
   260	{
   261		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
   262		unsigned long offs, align = q->dma_pad_mask | queue_dma_alignment(q);
   263		int ret, direction, nr_vecs, i, j, folios = 0;
   264		struct bio_vec stack_vec[UIO_FASTIOV];
   265		struct bio_vec bv, *bvec = stack_vec;
   266		struct page *stack_pages[UIO_FASTIOV];
   267		struct page **pages = stack_pages;
   268		struct bio_integrity_payload *bip;
   269		struct iov_iter iter;
   270		struct bvec_iter bi;
   271		u32 bytes;
   272	
   273		if (bio_integrity(bio))
   274			return -EINVAL;
   275		if (len >> SECTOR_SHIFT > queue_max_hw_sectors(q))
   276			return -E2BIG;
   277	
   278		if (bio_data_dir(bio) == READ)
   279			direction = ITER_DEST;
   280		else
   281			direction = ITER_SOURCE;
   282	
   283		iov_iter_ubuf(&iter, direction, ubuf, len);
   284		nr_vecs = iov_iter_npages(&iter, BIO_MAX_VECS + 1);
   285		if (nr_vecs > BIO_MAX_VECS)
   286			return -E2BIG;
   287		if (nr_vecs > UIO_FASTIOV) {
   288			bvec = kcalloc(sizeof(*bvec), nr_vecs, GFP_KERNEL);
   289			if (!bvec)
   290				return -ENOMEM;
   291			pages = NULL;
   292		}
   293	
 > 294		bytes = iov_iter_extract_pages(&iter, &pages, len, nr_vecs, 0, &offs);
   295		if (unlikely(bytes < 0)) {
   296			ret =  bytes;
   297			goto free_bvec;
   298		}
   299	
   300		for (i = 0; i < nr_vecs; i = j) {
   301			size_t size = min_t(size_t, bytes, PAGE_SIZE - offs);
   302			struct folio *folio = page_folio(pages[i]);
   303	
   304			bytes -= size;
   305			for (j = i + 1; j < nr_vecs; j++) {
   306				size_t next = min_t(size_t, PAGE_SIZE, bytes);
   307	
   308				if (page_folio(pages[j]) != folio ||
   309				    pages[j] != pages[j - 1] + 1)
   310					break;
   311				unpin_user_page(pages[j]);
   312				size += next;
   313				bytes -= next;
   314			}
   315	
   316			bvec_set_page(&bvec[folios], pages[i], size, offs);
   317			offs = 0;
   318			folios++;
   319		}
   320	
   321		if (pages != stack_pages)
   322			kvfree(pages);
   323	
   324		if (folios > queue_max_integrity_segments(q) ||
   325		    !iov_iter_is_aligned(&iter, align, align)) {
   326			ret = bio_integrity_copy_user(bio, bvec, folios, len,
   327						      direction, seed);
   328			if (ret)
   329				goto release_pages;
   330			return 0;
   331		}
   332	
   333		bip = bio_integrity_alloc(bio, GFP_KERNEL, folios);
   334		if (IS_ERR(bip)) {
   335			ret = PTR_ERR(bip);
   336			goto release_pages;
   337		}
   338	
   339		memcpy(bip->bip_vec, bvec, folios * sizeof(*bvec));
   340		if (bvec != stack_vec)
   341			kfree(bvec);
   342	
   343		bip->bip_flags |= BIP_INTEGRITY_USER;
   344		bip->copy_vec = NULL;
   345		return 0;
   346	
   347	release_pages:
   348		bi.bi_size = len;
   349		for_each_bvec(bv, bvec, bi, bi)
   350			unpin_user_page(bv.bv_page);
   351	free_bvec:
   352		if (bvec != stack_vec)
   353			kfree(bvec);
   354		return ret;
   355	}
   356	EXPORT_SYMBOL_GPL(bio_integrity_map_user);
   357	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

