Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D62F58B33D
	for <lists+io-uring@lfdr.de>; Sat,  6 Aug 2022 03:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbiHFBip (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Aug 2022 21:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241563AbiHFBio (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Aug 2022 21:38:44 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0DCA165A0;
        Fri,  5 Aug 2022 18:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659749922; x=1691285922;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=szq5MDh+o5m9XK7uyYnF8RJiFtQFKDvsgVMvsNGKPyE=;
  b=nwj54uXog7WeJs8R3w4brScuE1/5redbjJaDcUvkpVyWFkql4QUZFKj8
   051AGlMGlnxfud9f/sk6LKizqCRI5o62gkeFfs+HWH4eBQtG9gpx9uG0J
   r6srkm9/Zgn41Q0suLEpaSBbih+zD37n4UUg1BgRSm12EI3V8eG3syq/1
   u5YSfO5HesGyB0w5v3ts05NA6IAcxoWqPqggbPvDUqB59hB8n1E+meVen
   R0OoeVj7TtMIVULQqLzNhx2dWz7zF0sEBhY8dEfLWR1DMYqaIbFV3RE1u
   V+HHuC3rPIxxSx3hQVsL8fi7VgMvXHlNaxFH0G7MCBmjPj0nuAm6x2n0n
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10430"; a="277250679"
X-IronPort-AV: E=Sophos;i="5.93,217,1654585200"; 
   d="scan'208";a="277250679"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2022 18:38:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,217,1654585200"; 
   d="scan'208";a="603782749"
Received: from lkp-server01.sh.intel.com (HELO e0eace57cfef) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 05 Aug 2022 18:38:39 -0700
Received: from kbuild by e0eace57cfef with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oK8ly-000JuD-1E;
        Sat, 06 Aug 2022 01:38:38 +0000
Date:   Sat, 6 Aug 2022 09:38:19 +0800
From:   kernel test robot <lkp@intel.com>
To:     Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk, hch@lst.de
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, ming.lei@redhat.com,
        joshiiitr@gmail.com, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH 4/4] nvme: wire up async polling for io passthrough
 commands
Message-ID: <202208060944.JJcNJmU1-lkp@intel.com>
References: <20220805154226.155008-5-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220805154226.155008-5-joshi.k@samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
config: hexagon-randconfig-r015-20220805 (https://download.01.org/0day-ci/archive/20220806/202208060944.JJcNJmU1-lkp@intel.com/config)
compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project 5f1c7e2cc5a3c07cbc2412e851a7283c1841f520)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/0964795577fbf09d8b315269504b5e87b5ac492b
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Kanchan-Joshi/fs-add-file_operations-uring_cmd_iopoll/20220806-004320
        git checkout 0964795577fbf09d8b315269504b5e87b5ac492b
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash drivers/nvme/host/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All error/warnings (new ones prefixed by >>):

>> drivers/nvme/host/ioctl.c:638:6: warning: variable 'ret' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
           if (test_bit(QUEUE_FLAG_POLL, &q->queue_flags) && bio && bio->bi_bdev)
               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/hexagon/include/asm/bitops.h:175:28: note: expanded from macro 'test_bit'
   #define test_bit(nr, addr) __test_bit(nr, addr)
                              ^
   drivers/nvme/host/ioctl.c:641:9: note: uninitialized use occurs here
           return ret;
                  ^~~
   drivers/nvme/host/ioctl.c:638:2: note: remove the 'if' if its condition is always true
           if (test_bit(QUEUE_FLAG_POLL, &q->queue_flags) && bio && bio->bi_bdev)
           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/nvme/host/ioctl.c:638:6: warning: variable 'ret' is used uninitialized whenever '&&' condition is false [-Wsometimes-uninitialized]
           if (test_bit(QUEUE_FLAG_POLL, &q->queue_flags) && bio && bio->bi_bdev)
               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/hexagon/include/asm/bitops.h:175:28: note: expanded from macro 'test_bit'
   #define test_bit(nr, addr) __test_bit(nr, addr)
                              ^
   drivers/nvme/host/ioctl.c:641:9: note: uninitialized use occurs here
           return ret;
                  ^~~
   drivers/nvme/host/ioctl.c:638:6: note: remove the '&&' if its condition is always true
           if (test_bit(QUEUE_FLAG_POLL, &q->queue_flags) && bio && bio->bi_bdev)
               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/hexagon/include/asm/bitops.h:175:28: note: expanded from macro 'test_bit'
   #define test_bit(nr, addr) __test_bit(nr, addr)
                              ^
>> drivers/nvme/host/ioctl.c:638:6: warning: variable 'ret' is used uninitialized whenever '&&' condition is false [-Wsometimes-uninitialized]
           if (test_bit(QUEUE_FLAG_POLL, &q->queue_flags) && bio && bio->bi_bdev)
               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/hexagon/include/asm/bitops.h:175:28: note: expanded from macro 'test_bit'
   #define test_bit(nr, addr) __test_bit(nr, addr)
                              ^~~~~~~~~~~~~~~~~~~~
   drivers/nvme/host/ioctl.c:641:9: note: uninitialized use occurs here
           return ret;
                  ^~~
   drivers/nvme/host/ioctl.c:638:6: note: remove the '&&' if its condition is always true
           if (test_bit(QUEUE_FLAG_POLL, &q->queue_flags) && bio && bio->bi_bdev)
               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/hexagon/include/asm/bitops.h:175:28: note: expanded from macro 'test_bit'
   #define test_bit(nr, addr) __test_bit(nr, addr)
                              ^
   drivers/nvme/host/ioctl.c:629:9: note: initialize the variable 'ret' to silence this warning
           int ret;
                  ^
                   = 0
>> drivers/nvme/host/ioctl.c:737:27: error: no member named 'private' in 'struct io_uring_cmd'
                   bio = READ_ONCE(ioucmd->private);
                                   ~~~~~~  ^
   include/asm-generic/rwonce.h:49:33: note: expanded from macro 'READ_ONCE'
           compiletime_assert_rwonce_type(x);                              \
                                          ^
   include/asm-generic/rwonce.h:36:35: note: expanded from macro 'compiletime_assert_rwonce_type'
           compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
                                            ^
   include/linux/compiler_types.h:321:10: note: expanded from macro '__native_word'
           (sizeof(t) == sizeof(char) || sizeof(t) == sizeof(short) || \
                   ^
   include/linux/compiler_types.h:354:22: note: expanded from macro 'compiletime_assert'
           _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
                               ^~~~~~~~~
   include/linux/compiler_types.h:342:23: note: expanded from macro '_compiletime_assert'
           __compiletime_assert(condition, msg, prefix, suffix)
                                ^~~~~~~~~
   include/linux/compiler_types.h:334:9: note: expanded from macro '__compiletime_assert'
                   if (!(condition))                                       \
                         ^~~~~~~~~
>> drivers/nvme/host/ioctl.c:737:27: error: no member named 'private' in 'struct io_uring_cmd'
                   bio = READ_ONCE(ioucmd->private);
                                   ~~~~~~  ^
   include/asm-generic/rwonce.h:49:33: note: expanded from macro 'READ_ONCE'
           compiletime_assert_rwonce_type(x);                              \
                                          ^
   include/asm-generic/rwonce.h:36:35: note: expanded from macro 'compiletime_assert_rwonce_type'
           compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
                                            ^
   include/linux/compiler_types.h:321:39: note: expanded from macro '__native_word'
           (sizeof(t) == sizeof(char) || sizeof(t) == sizeof(short) || \
                                                ^
   include/linux/compiler_types.h:354:22: note: expanded from macro 'compiletime_assert'
           _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
                               ^~~~~~~~~
   include/linux/compiler_types.h:342:23: note: expanded from macro '_compiletime_assert'
           __compiletime_assert(condition, msg, prefix, suffix)
                                ^~~~~~~~~
   include/linux/compiler_types.h:334:9: note: expanded from macro '__compiletime_assert'
                   if (!(condition))                                       \
                         ^~~~~~~~~
>> drivers/nvme/host/ioctl.c:737:27: error: no member named 'private' in 'struct io_uring_cmd'
                   bio = READ_ONCE(ioucmd->private);
                                   ~~~~~~  ^
   include/asm-generic/rwonce.h:49:33: note: expanded from macro 'READ_ONCE'
           compiletime_assert_rwonce_type(x);                              \
                                          ^
   include/asm-generic/rwonce.h:36:35: note: expanded from macro 'compiletime_assert_rwonce_type'
           compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
                                            ^
   include/linux/compiler_types.h:322:10: note: expanded from macro '__native_word'
            sizeof(t) == sizeof(int) || sizeof(t) == sizeof(long))
                   ^
   include/linux/compiler_types.h:354:22: note: expanded from macro 'compiletime_assert'
           _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
                               ^~~~~~~~~
   include/linux/compiler_types.h:342:23: note: expanded from macro '_compiletime_assert'
           __compiletime_assert(condition, msg, prefix, suffix)
                                ^~~~~~~~~
   include/linux/compiler_types.h:334:9: note: expanded from macro '__compiletime_assert'
                   if (!(condition))                                       \
                         ^~~~~~~~~
>> drivers/nvme/host/ioctl.c:737:27: error: no member named 'private' in 'struct io_uring_cmd'
                   bio = READ_ONCE(ioucmd->private);
                                   ~~~~~~  ^
   include/asm-generic/rwonce.h:49:33: note: expanded from macro 'READ_ONCE'
           compiletime_assert_rwonce_type(x);                              \
                                          ^
   include/asm-generic/rwonce.h:36:35: note: expanded from macro 'compiletime_assert_rwonce_type'
           compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
                                            ^
   include/linux/compiler_types.h:322:38: note: expanded from macro '__native_word'
            sizeof(t) == sizeof(int) || sizeof(t) == sizeof(long))
                                               ^
   include/linux/compiler_types.h:354:22: note: expanded from macro 'compiletime_assert'
           _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
                               ^~~~~~~~~
   include/linux/compiler_types.h:342:23: note: expanded from macro '_compiletime_assert'
           __compiletime_assert(condition, msg, prefix, suffix)
                                ^~~~~~~~~
   include/linux/compiler_types.h:334:9: note: expanded from macro '__compiletime_assert'
                   if (!(condition))                                       \
                         ^~~~~~~~~
>> drivers/nvme/host/ioctl.c:737:27: error: no member named 'private' in 'struct io_uring_cmd'
                   bio = READ_ONCE(ioucmd->private);
                                   ~~~~~~  ^
   include/asm-generic/rwonce.h:49:33: note: expanded from macro 'READ_ONCE'
           compiletime_assert_rwonce_type(x);                              \
                                          ^
   include/asm-generic/rwonce.h:36:48: note: expanded from macro 'compiletime_assert_rwonce_type'
           compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
                                                         ^
   include/linux/compiler_types.h:354:22: note: expanded from macro 'compiletime_assert'
           _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
                               ^~~~~~~~~
   include/linux/compiler_types.h:342:23: note: expanded from macro '_compiletime_assert'
           __compiletime_assert(condition, msg, prefix, suffix)
                                ^~~~~~~~~
   include/linux/compiler_types.h:334:9: note: expanded from macro '__compiletime_assert'
                   if (!(condition))                                       \
                         ^~~~~~~~~
>> drivers/nvme/host/ioctl.c:737:27: error: no member named 'private' in 'struct io_uring_cmd'
                   bio = READ_ONCE(ioucmd->private);
                                   ~~~~~~  ^
   include/asm-generic/rwonce.h:50:14: note: expanded from macro 'READ_ONCE'
           __READ_ONCE(x);                                                 \
                       ^
   include/asm-generic/rwonce.h:44:65: note: expanded from macro '__READ_ONCE'
   #define __READ_ONCE(x)  (*(const volatile __unqual_scalar_typeof(x) *)&(x))
                                                                    ^
   include/linux/compiler_types.h:310:13: note: expanded from macro '__unqual_scalar_typeof'
                   _Generic((x),                                           \
                             ^
>> drivers/nvme/host/ioctl.c:737:27: error: no member named 'private' in 'struct io_uring_cmd'
                   bio = READ_ONCE(ioucmd->private);
                                   ~~~~~~  ^
   include/asm-generic/rwonce.h:50:14: note: expanded from macro 'READ_ONCE'
           __READ_ONCE(x);                                                 \
                       ^
   include/asm-generic/rwonce.h:44:65: note: expanded from macro '__READ_ONCE'
   #define __READ_ONCE(x)  (*(const volatile __unqual_scalar_typeof(x) *)&(x))
                                                                    ^
   include/linux/compiler_types.h:317:15: note: expanded from macro '__unqual_scalar_typeof'
                            default: (x)))
                                      ^
>> drivers/nvme/host/ioctl.c:737:27: error: no member named 'private' in 'struct io_uring_cmd'
                   bio = READ_ONCE(ioucmd->private);
                                   ~~~~~~  ^
   include/asm-generic/rwonce.h:50:14: note: expanded from macro 'READ_ONCE'
           __READ_ONCE(x);                                                 \
                       ^
   include/asm-generic/rwonce.h:44:72: note: expanded from macro '__READ_ONCE'
   #define __READ_ONCE(x)  (*(const volatile __unqual_scalar_typeof(x) *)&(x))
                                                                           ^
>> drivers/nvme/host/ioctl.c:737:7: error: assigning to 'struct bio *' from incompatible type 'void'
                   bio = READ_ONCE(ioucmd->private);
                       ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~
   3 warnings and 9 errors generated.


vim +737 drivers/nvme/host/ioctl.c

   625	
   626	int nvme_ns_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd)
   627	{
   628		struct bio *bio;
   629		int ret;
   630		struct nvme_ns *ns;
   631		struct request_queue *q;
   632	
   633		rcu_read_lock();
   634		bio = READ_ONCE(ioucmd->cookie);
   635		ns = container_of(file_inode(ioucmd->file)->i_cdev,
   636				struct nvme_ns, cdev);
   637		q = ns->queue;
 > 638		if (test_bit(QUEUE_FLAG_POLL, &q->queue_flags) && bio && bio->bi_bdev)
   639			ret = bio_poll(bio, 0, 0);
   640		rcu_read_unlock();
   641		return ret;
   642	}
   643	#ifdef CONFIG_NVME_MULTIPATH
   644	static int nvme_ns_head_ctrl_ioctl(struct nvme_ns *ns, unsigned int cmd,
   645			void __user *argp, struct nvme_ns_head *head, int srcu_idx)
   646		__releases(&head->srcu)
   647	{
   648		struct nvme_ctrl *ctrl = ns->ctrl;
   649		int ret;
   650	
   651		nvme_get_ctrl(ns->ctrl);
   652		srcu_read_unlock(&head->srcu, srcu_idx);
   653		ret = nvme_ctrl_ioctl(ns->ctrl, cmd, argp);
   654	
   655		nvme_put_ctrl(ctrl);
   656		return ret;
   657	}
   658	
   659	int nvme_ns_head_ioctl(struct block_device *bdev, fmode_t mode,
   660			unsigned int cmd, unsigned long arg)
   661	{
   662		struct nvme_ns_head *head = bdev->bd_disk->private_data;
   663		void __user *argp = (void __user *)arg;
   664		struct nvme_ns *ns;
   665		int srcu_idx, ret = -EWOULDBLOCK;
   666	
   667		srcu_idx = srcu_read_lock(&head->srcu);
   668		ns = nvme_find_path(head);
   669		if (!ns)
   670			goto out_unlock;
   671	
   672		/*
   673		 * Handle ioctls that apply to the controller instead of the namespace
   674		 * seperately and drop the ns SRCU reference early.  This avoids a
   675		 * deadlock when deleting namespaces using the passthrough interface.
   676		 */
   677		if (is_ctrl_ioctl(cmd))
   678			return nvme_ns_head_ctrl_ioctl(ns, cmd, argp, head, srcu_idx);
   679	
   680		ret = nvme_ns_ioctl(ns, cmd, argp);
   681	out_unlock:
   682		srcu_read_unlock(&head->srcu, srcu_idx);
   683		return ret;
   684	}
   685	
   686	long nvme_ns_head_chr_ioctl(struct file *file, unsigned int cmd,
   687			unsigned long arg)
   688	{
   689		struct cdev *cdev = file_inode(file)->i_cdev;
   690		struct nvme_ns_head *head =
   691			container_of(cdev, struct nvme_ns_head, cdev);
   692		void __user *argp = (void __user *)arg;
   693		struct nvme_ns *ns;
   694		int srcu_idx, ret = -EWOULDBLOCK;
   695	
   696		srcu_idx = srcu_read_lock(&head->srcu);
   697		ns = nvme_find_path(head);
   698		if (!ns)
   699			goto out_unlock;
   700	
   701		if (is_ctrl_ioctl(cmd))
   702			return nvme_ns_head_ctrl_ioctl(ns, cmd, argp, head, srcu_idx);
   703	
   704		ret = nvme_ns_ioctl(ns, cmd, argp);
   705	out_unlock:
   706		srcu_read_unlock(&head->srcu, srcu_idx);
   707		return ret;
   708	}
   709	
   710	int nvme_ns_head_chr_uring_cmd(struct io_uring_cmd *ioucmd,
   711			unsigned int issue_flags)
   712	{
   713		struct cdev *cdev = file_inode(ioucmd->file)->i_cdev;
   714		struct nvme_ns_head *head = container_of(cdev, struct nvme_ns_head, cdev);
   715		int srcu_idx = srcu_read_lock(&head->srcu);
   716		struct nvme_ns *ns = nvme_find_path(head);
   717		int ret = -EINVAL;
   718	
   719		if (ns)
   720			ret = nvme_ns_uring_cmd(ns, ioucmd, issue_flags);
   721		srcu_read_unlock(&head->srcu, srcu_idx);
   722		return ret;
   723	}
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
