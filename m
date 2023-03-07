Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7DC6AFACF
	for <lists+io-uring@lfdr.de>; Wed,  8 Mar 2023 00:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbjCGX6e (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Mar 2023 18:58:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjCGX6c (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Mar 2023 18:58:32 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4393A674F;
        Tue,  7 Mar 2023 15:58:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678233510; x=1709769510;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=U1r11wGTdNUd/e243gWXbHVrx+jIyFT1yWtGKx/A41A=;
  b=WYoIspkTKmMW3z80kjSyYerf6z1j4BDxVQ3LfMP7ODumsOQkYuU/7MqB
   5Iy1ZSV6p4VNGqXO2ayWXqylcn1ob93YSjfWJxPTPzbwZRxMIZk+ZViT1
   k5Q2Hbvy1xdTIMabL1fpkbhyCmPB3ShOTR2qO24PeqP/LwfQi1kaj4zn0
   HoASu5MjclL2dnPu6hA0vulga0PvzZDxCPvl81tuB/66V9YaeaGx9/wCR
   8cH1HrZdarI96NstFm5B7tgtPFTEbXwy6oYjTqhKZU42XDyVlFNBEs4+G
   32RvTVAWzigfIaM31QcwI7hy+wMrn0fvNJXnQYF+iblsK3/4cduilm5JW
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="334723924"
X-IronPort-AV: E=Sophos;i="5.98,242,1673942400"; 
   d="scan'208";a="334723924"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 15:58:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="800544382"
X-IronPort-AV: E=Sophos;i="5.98,242,1673942400"; 
   d="scan'208";a="800544382"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 07 Mar 2023 15:58:27 -0800
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pZhCM-0001hT-2L;
        Tue, 07 Mar 2023 23:58:26 +0000
Date:   Wed, 8 Mar 2023 07:57:51 +0800
From:   kernel test robot <lkp@intel.com>
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, linux-block@vger.kernel.org,
        Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V2 12/17] block: ublk_drv: cleanup ublk_copy_user_pages
Message-ID: <202303080731.bXLTXesK-lkp@intel.com>
References: <20230307141520.793891-13-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230307141520.793891-13-ming.lei@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Ming,

I love your patch! Perhaps something to improve:

[auto build test WARNING on axboe-block/for-next]
[also build test WARNING on linus/master v6.3-rc1 next-20230307]
[cannot apply to char-misc/char-misc-testing char-misc/char-misc-next char-misc/char-misc-linus]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ming-Lei/io_uring-add-IO_URING_F_FUSED-and-prepare-for-supporting-OP_FUSED_CMD/20230307-222928
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
patch link:    https://lore.kernel.org/r/20230307141520.793891-13-ming.lei%40redhat.com
patch subject: [PATCH V2 12/17] block: ublk_drv: cleanup ublk_copy_user_pages
config: m68k-allyesconfig (https://download.01.org/0day-ci/archive/20230308/202303080731.bXLTXesK-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/c375364124e3c63211e7edd23bb74d22a86d5194
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Ming-Lei/io_uring-add-IO_URING_F_FUSED-and-prepare-for-supporting-OP_FUSED_CMD/20230307-222928
        git checkout c375364124e3c63211e7edd23bb74d22a86d5194
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash drivers/block/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303080731.bXLTXesK-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/block/ublk_drv.c: In function 'ublk_map_io':
>> drivers/block/ublk_drv.c:532:42: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
     532 |                 import_single_range(dir, (void __user *)io->addr,
         |                                          ^
   drivers/block/ublk_drv.c: In function 'ublk_unmap_io':
   drivers/block/ublk_drv.c:553:42: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
     553 |                 import_single_range(dir, (void __user *)io->addr,
         |                                          ^


vim +532 drivers/block/ublk_drv.c

   516	
   517	static int ublk_map_io(const struct ublk_queue *ubq, const struct request *req,
   518			struct ublk_io *io)
   519	{
   520		const unsigned int rq_bytes = blk_rq_bytes(req);
   521	
   522		/*
   523		 * no zero copy, we delay copy WRITE request data into ublksrv
   524		 * context and the big benefit is that pinning pages in current
   525		 * context is pretty fast, see ublk_pin_user_pages
   526		 */
   527		if (ublk_need_map_req(req)) {
   528			struct iov_iter iter;
   529			struct iovec iov;
   530			const int dir = ITER_DEST;
   531	
 > 532			import_single_range(dir, (void __user *)io->addr,
   533					rq_bytes, &iov, &iter);
   534	
   535			return ublk_copy_user_pages(req, &iter, dir);
   536		}
   537		return rq_bytes;
   538	}
   539	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
