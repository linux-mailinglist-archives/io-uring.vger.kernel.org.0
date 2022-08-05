Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5476958B115
	for <lists+io-uring@lfdr.de>; Fri,  5 Aug 2022 23:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238140AbiHEVXr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Aug 2022 17:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240275AbiHEVXp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Aug 2022 17:23:45 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8679567C8D;
        Fri,  5 Aug 2022 14:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659734623; x=1691270623;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=R+cx4naRn4EL5oWfO7JYH/qaE90sSoLCRakX+2FvYew=;
  b=TJa3Xc6DenWHoCgnYo8p5ZRwe/JKEhnvwS5xqu3FrNBniSXtg/PrD8HW
   mKYOdGpEXnila/TWgHURBaJPWX755ITTCpq9/Mdv/UEyWM03sTPFR52t5
   iLPE+QlYt1+p/yH+i1Q9DBkHG15gHudmGsatAPFq65in9HltrGZO39PaI
   Jsm4dG+hFt16D+kQZrOcDF3WfVKMpIrN3U3tog1GfM23/toNwdqt1Tt6d
   XS/U+rLfvTVi1GaunI/+4BpcztQJVFvndC+Wf3fOdiiwgC3pbUIOL8hd1
   sqzfk/SXXhdjA28inSNfhQor6B8G8NxRC4OMBJnHIQjOvpiQBRA+aGdlb
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10430"; a="291519747"
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="291519747"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2022 14:23:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="603728097"
Received: from lkp-server01.sh.intel.com (HELO e0eace57cfef) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 05 Aug 2022 14:23:33 -0700
Received: from kbuild by e0eace57cfef with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oK4n6-000JkF-2P;
        Fri, 05 Aug 2022 21:23:32 +0000
Date:   Sat, 6 Aug 2022 05:22:47 +0800
From:   kernel test robot <lkp@intel.com>
To:     Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk, hch@lst.de
Cc:     kbuild-all@lists.01.org, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        ming.lei@redhat.com, joshiiitr@gmail.com, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH 4/4] nvme: wire up async polling for io passthrough
 commands
Message-ID: <202208060547.zSVYtFTN-lkp@intel.com>
References: <20220805154226.155008-5-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220805154226.155008-5-joshi.k@samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Kanchan,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on axboe-block/for-next]
[also build test ERROR on linus/master]
[cannot apply to hch-configfs/for-next v5.19]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Kanchan-Joshi/fs-add-file_operations-uring_cmd_iopoll/20220806-004320
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
config: i386-allyesconfig (https://download.01.org/0day-ci/archive/20220806/202208060547.zSVYtFTN-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/0964795577fbf09d8b315269504b5e87b5ac492b
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Kanchan-Joshi/fs-add-file_operations-uring_cmd_iopoll/20220806-004320
        git checkout 0964795577fbf09d8b315269504b5e87b5ac492b
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from <command-line>:
   drivers/nvme/host/ioctl.c: In function 'nvme_ns_head_chr_uring_cmd_iopoll':
>> drivers/nvme/host/ioctl.c:737:39: error: 'struct io_uring_cmd' has no member named 'private'
     737 |                 bio = READ_ONCE(ioucmd->private);
         |                                       ^~
   include/linux/compiler_types.h:334:23: note: in definition of macro '__compiletime_assert'
     334 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:354:9: note: in expansion of macro '_compiletime_assert'
     354 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:9: note: in expansion of macro 'compiletime_assert'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |         ^~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:28: note: in expansion of macro '__native_word'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |                            ^~~~~~~~~~~~~
   include/asm-generic/rwonce.h:49:9: note: in expansion of macro 'compiletime_assert_rwonce_type'
      49 |         compiletime_assert_rwonce_type(x);                              \
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/nvme/host/ioctl.c:737:23: note: in expansion of macro 'READ_ONCE'
     737 |                 bio = READ_ONCE(ioucmd->private);
         |                       ^~~~~~~~~
>> drivers/nvme/host/ioctl.c:737:39: error: 'struct io_uring_cmd' has no member named 'private'
     737 |                 bio = READ_ONCE(ioucmd->private);
         |                                       ^~
   include/linux/compiler_types.h:334:23: note: in definition of macro '__compiletime_assert'
     334 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:354:9: note: in expansion of macro '_compiletime_assert'
     354 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:9: note: in expansion of macro 'compiletime_assert'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |         ^~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:28: note: in expansion of macro '__native_word'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |                            ^~~~~~~~~~~~~
   include/asm-generic/rwonce.h:49:9: note: in expansion of macro 'compiletime_assert_rwonce_type'
      49 |         compiletime_assert_rwonce_type(x);                              \
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/nvme/host/ioctl.c:737:23: note: in expansion of macro 'READ_ONCE'
     737 |                 bio = READ_ONCE(ioucmd->private);
         |                       ^~~~~~~~~
>> drivers/nvme/host/ioctl.c:737:39: error: 'struct io_uring_cmd' has no member named 'private'
     737 |                 bio = READ_ONCE(ioucmd->private);
         |                                       ^~
   include/linux/compiler_types.h:334:23: note: in definition of macro '__compiletime_assert'
     334 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:354:9: note: in expansion of macro '_compiletime_assert'
     354 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:9: note: in expansion of macro 'compiletime_assert'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |         ^~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:28: note: in expansion of macro '__native_word'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |                            ^~~~~~~~~~~~~
   include/asm-generic/rwonce.h:49:9: note: in expansion of macro 'compiletime_assert_rwonce_type'
      49 |         compiletime_assert_rwonce_type(x);                              \
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/nvme/host/ioctl.c:737:23: note: in expansion of macro 'READ_ONCE'
     737 |                 bio = READ_ONCE(ioucmd->private);
         |                       ^~~~~~~~~
>> drivers/nvme/host/ioctl.c:737:39: error: 'struct io_uring_cmd' has no member named 'private'
     737 |                 bio = READ_ONCE(ioucmd->private);
         |                                       ^~
   include/linux/compiler_types.h:334:23: note: in definition of macro '__compiletime_assert'
     334 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:354:9: note: in expansion of macro '_compiletime_assert'
     354 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:9: note: in expansion of macro 'compiletime_assert'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |         ^~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:28: note: in expansion of macro '__native_word'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |                            ^~~~~~~~~~~~~
   include/asm-generic/rwonce.h:49:9: note: in expansion of macro 'compiletime_assert_rwonce_type'
      49 |         compiletime_assert_rwonce_type(x);                              \
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/nvme/host/ioctl.c:737:23: note: in expansion of macro 'READ_ONCE'
     737 |                 bio = READ_ONCE(ioucmd->private);
         |                       ^~~~~~~~~
>> drivers/nvme/host/ioctl.c:737:39: error: 'struct io_uring_cmd' has no member named 'private'
     737 |                 bio = READ_ONCE(ioucmd->private);
         |                                       ^~
   include/linux/compiler_types.h:334:23: note: in definition of macro '__compiletime_assert'
     334 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:354:9: note: in expansion of macro '_compiletime_assert'
     354 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:9: note: in expansion of macro 'compiletime_assert'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |         ^~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:49:9: note: in expansion of macro 'compiletime_assert_rwonce_type'
      49 |         compiletime_assert_rwonce_type(x);                              \
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/nvme/host/ioctl.c:737:23: note: in expansion of macro 'READ_ONCE'
     737 |                 bio = READ_ONCE(ioucmd->private);
         |                       ^~~~~~~~~
>> drivers/nvme/host/ioctl.c:737:39: error: 'struct io_uring_cmd' has no member named 'private'
     737 |                 bio = READ_ONCE(ioucmd->private);
         |                                       ^~
   include/linux/compiler_types.h:310:27: note: in definition of macro '__unqual_scalar_typeof'
     310 |                 _Generic((x),                                           \
         |                           ^
   include/asm-generic/rwonce.h:50:9: note: in expansion of macro '__READ_ONCE'
      50 |         __READ_ONCE(x);                                                 \
         |         ^~~~~~~~~~~
   drivers/nvme/host/ioctl.c:737:23: note: in expansion of macro 'READ_ONCE'
     737 |                 bio = READ_ONCE(ioucmd->private);
         |                       ^~~~~~~~~
   In file included from ./arch/x86/include/generated/asm/rwonce.h:1,
                    from include/linux/compiler.h:248,
                    from include/linux/ptrace.h:5,
                    from drivers/nvme/host/ioctl.c:6:
>> drivers/nvme/host/ioctl.c:737:39: error: 'struct io_uring_cmd' has no member named 'private'
     737 |                 bio = READ_ONCE(ioucmd->private);
         |                                       ^~
   include/asm-generic/rwonce.h:44:73: note: in definition of macro '__READ_ONCE'
      44 | #define __READ_ONCE(x)  (*(const volatile __unqual_scalar_typeof(x) *)&(x))
         |                                                                         ^
   drivers/nvme/host/ioctl.c:737:23: note: in expansion of macro 'READ_ONCE'
     737 |                 bio = READ_ONCE(ioucmd->private);
         |                       ^~~~~~~~~


vim +737 drivers/nvme/host/ioctl.c

   724	
   725	int nvme_ns_head_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd)
   726	{
   727		struct cdev *cdev = file_inode(ioucmd->file)->i_cdev;
   728		struct nvme_ns_head *head = container_of(cdev, struct nvme_ns_head, cdev);
   729		int srcu_idx = srcu_read_lock(&head->srcu);
   730		struct nvme_ns *ns = nvme_find_path(head);
   731		struct bio *bio;
   732		int ret = 0;
   733		struct request_queue *q;
   734	
   735		if (ns) {
   736			rcu_read_lock();
 > 737			bio = READ_ONCE(ioucmd->private);
   738			q = ns->queue;
   739			if (test_bit(QUEUE_FLAG_POLL, &q->queue_flags) && bio
   740					&& bio->bi_bdev)
   741				ret = bio_poll(bio, 0, 0);
   742			rcu_read_unlock();
   743		}
   744		srcu_read_unlock(&head->srcu, srcu_idx);
   745		return ret;
   746	}
   747	#endif /* CONFIG_NVME_MULTIPATH */
   748	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
