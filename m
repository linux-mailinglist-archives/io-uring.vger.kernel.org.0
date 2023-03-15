Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7566BA707
	for <lists+io-uring@lfdr.de>; Wed, 15 Mar 2023 06:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbjCOF0e (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Mar 2023 01:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231637AbjCOF0L (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Mar 2023 01:26:11 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39AFB366A9;
        Tue, 14 Mar 2023 22:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678857891; x=1710393891;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2/TH1LWxLih8S4MHEb64nBaGJRSX7584AONhxzPciDI=;
  b=nyF0YWWhFjk9EKlXkBat1l2W266bcsx/TH/avJ/8c+5mZQ5Px1T4h+5A
   p5yyfbu9Wi+GSMzpEg8YyNjhNvGFXf4lGWJleTglRtFYbMSG++D3+u4mz
   bsBhlenLhH6K4r6jozYT3L8eMts5hhRiQh3zRJD5UQoBMdH3pNaGWTcwL
   tq30SorKF8KvBxhBKO4OzN6XnVgHspNtAg+2I7Znx4Qmn3XrV+G6X35rv
   VSCAWmpTgH1zOEjaBunPRbnPxmgQ7to7miS3fUXgJfPoOYTfg26PKuiA4
   nvss8t0Dcjs/G1GlhvKGgIFWGMTFJcmyxQ++guK4s2QzkSOMCRgfpCBkf
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="365293998"
X-IronPort-AV: E=Sophos;i="5.98,261,1673942400"; 
   d="scan'208";a="365293998"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 22:21:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="672609063"
X-IronPort-AV: E=Sophos;i="5.98,261,1673942400"; 
   d="scan'208";a="672609063"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 14 Mar 2023 22:21:10 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pcJZV-0007Sh-1W;
        Wed, 15 Mar 2023 05:21:09 +0000
Date:   Wed, 15 Mar 2023 13:20:58 +0800
From:   kernel test robot <lkp@intel.com>
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, linux-block@vger.kernel.org,
        Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V2 13/17] block: ublk_drv: grab request reference when
 the request is handled by userspace
Message-ID: <202303151232.tHK2H9T3-lkp@intel.com>
References: <20230307141520.793891-14-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230307141520.793891-14-ming.lei@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Ming,

I love your patch! Perhaps something to improve:

[auto build test WARNING on axboe-block/for-next]
[also build test WARNING on char-misc/char-misc-testing char-misc/char-misc-next char-misc/char-misc-linus linus/master v6.3-rc2 next-20230314]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ming-Lei/io_uring-add-IO_URING_F_FUSED-and-prepare-for-supporting-OP_FUSED_CMD/20230307-222928
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
patch link:    https://lore.kernel.org/r/20230307141520.793891-14-ming.lei%40redhat.com
patch subject: [PATCH V2 13/17] block: ublk_drv: grab request reference when the request is handled by userspace
config: microblaze-randconfig-s033-20230308 (https://download.01.org/0day-ci/archive/20230315/202303151232.tHK2H9T3-lkp@intel.com/config)
compiler: microblaze-linux-gcc (GCC) 12.1.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/8e1a2115a8d58ff04cbc1aad6192805e29d0b63e
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Ming-Lei/io_uring-add-IO_URING_F_FUSED-and-prepare-for-supporting-OP_FUSED_CMD/20230307-222928
        git checkout 8e1a2115a8d58ff04cbc1aad6192805e29d0b63e
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=microblaze olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=microblaze SHELL=/bin/bash drivers/block/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303151232.tHK2H9T3-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/block/ublk_drv.c:688:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected int res @@     got restricted blk_status_t [usertype] @@
   drivers/block/ublk_drv.c:688:21: sparse:     expected int res
   drivers/block/ublk_drv.c:688:21: sparse:     got restricted blk_status_t [usertype]
   drivers/block/ublk_drv.c:697:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected int res @@     got restricted blk_status_t @@
   drivers/block/ublk_drv.c:697:21: sparse:     expected int res
   drivers/block/ublk_drv.c:697:21: sparse:     got restricted blk_status_t
   drivers/block/ublk_drv.c:728:33: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected restricted blk_status_t [usertype] error @@     got int res @@
   drivers/block/ublk_drv.c:728:33: sparse:     expected restricted blk_status_t [usertype] error
   drivers/block/ublk_drv.c:728:33: sparse:     got int res
>> drivers/block/ublk_drv.c:688:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected int res @@     got restricted blk_status_t [usertype] @@
   drivers/block/ublk_drv.c:688:21: sparse:     expected int res
   drivers/block/ublk_drv.c:688:21: sparse:     got restricted blk_status_t [usertype]
   drivers/block/ublk_drv.c:697:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected int res @@     got restricted blk_status_t @@
   drivers/block/ublk_drv.c:697:21: sparse:     expected int res
   drivers/block/ublk_drv.c:697:21: sparse:     got restricted blk_status_t
   drivers/block/ublk_drv.c:728:33: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected restricted blk_status_t [usertype] error @@     got int res @@
   drivers/block/ublk_drv.c:728:33: sparse:     expected restricted blk_status_t [usertype] error
   drivers/block/ublk_drv.c:728:33: sparse:     got int res
>> drivers/block/ublk_drv.c:688:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected int res @@     got restricted blk_status_t [usertype] @@
   drivers/block/ublk_drv.c:688:21: sparse:     expected int res
   drivers/block/ublk_drv.c:688:21: sparse:     got restricted blk_status_t [usertype]
   drivers/block/ublk_drv.c:697:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected int res @@     got restricted blk_status_t @@
   drivers/block/ublk_drv.c:697:21: sparse:     expected int res
   drivers/block/ublk_drv.c:697:21: sparse:     got restricted blk_status_t
   drivers/block/ublk_drv.c:728:33: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected restricted blk_status_t [usertype] error @@     got int res @@
   drivers/block/ublk_drv.c:728:33: sparse:     expected restricted blk_status_t [usertype] error
   drivers/block/ublk_drv.c:728:33: sparse:     got int res

vim +688 drivers/block/ublk_drv.c

   677	
   678	/* todo: handle partial completion */
   679	static inline void __ublk_complete_rq(struct request *req)
   680	{
   681		struct ublk_queue *ubq = req->mq_hctx->driver_data;
   682		struct ublk_io *io = &ubq->ios[req->tag];
   683		unsigned int unmapped_bytes;
   684		int res = BLK_STS_OK;
   685	
   686		/* called from ublk_abort_queue() code path */
   687		if (io->flags & UBLK_IO_FLAG_ABORTED) {
 > 688			res = BLK_STS_IOERR;
   689			goto exit;
   690		}
   691	
   692		/* failed read IO if nothing is read */
   693		if (!io->res && req_op(req) == REQ_OP_READ)
   694			io->res = -EIO;
   695	
   696		if (io->res < 0) {
   697			res = errno_to_blk_status(io->res);
   698			goto exit;
   699		}
   700	
   701		/*
   702		 * FLUSH, DISCARD or WRITE_ZEROES usually won't return bytes returned, so end them
   703		 * directly.
   704		 *
   705		 * Both the two needn't unmap.
   706		 */
   707		if (req_op(req) != REQ_OP_READ && req_op(req) != REQ_OP_WRITE)
   708			goto exit;
   709	
   710		/* for READ request, writing data in iod->addr to rq buffers */
   711		unmapped_bytes = ublk_unmap_io(ubq, req, io);
   712	
   713		/*
   714		 * Extremely impossible since we got data filled in just before
   715		 *
   716		 * Re-read simply for this unlikely case.
   717		 */
   718		if (unlikely(unmapped_bytes < io->res))
   719			io->res = unmapped_bytes;
   720	
   721		if (blk_update_request(req, BLK_STS_OK, io->res))
   722			blk_mq_requeue_request(req, true);
   723		else
   724			__blk_mq_end_request(req, BLK_STS_OK);
   725	
   726		return;
   727	exit:
   728		blk_mq_end_request(req, res);
   729	}
   730	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
