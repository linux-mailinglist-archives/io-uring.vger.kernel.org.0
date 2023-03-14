Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35F156B9CCE
	for <lists+io-uring@lfdr.de>; Tue, 14 Mar 2023 18:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbjCNRRB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Mar 2023 13:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbjCNRQ5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Mar 2023 13:16:57 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E198A400A;
        Tue, 14 Mar 2023 10:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678814208; x=1710350208;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zWgLG6xZP3tF/SUfhq70iU9Mn541eOYzqSxbrqH2r00=;
  b=AvArblcXCXZ9bOvqf9PXYoPhRMXE2P5zWEQQTlsUmyPGuOGWAs/Ntu7o
   pSZSfQJeP0cvx+Lwi/5ZxXHQAgNZjzlQ74gTzQh0R56b/aIC/0gx4/kFP
   zJVimcgciaAegyVy1v73MFZDVuVmS/QIps4ZzqWT3mnKS6pbXn/RmnPYA
   7LAa0UVvFyYFM7aOOPQqEKS+5YRnt8gaA/C/UBDJM98buR/89ccOiBZZ1
   hzfymDQ1jJ5FXXHQlsoQOr7Z1h0pRwMU3GBu0botIBZ/BbQ9g4D4BhgHI
   QYPuwOYHmgk1Cc52nQKvRFZlRXhOGzYBaJ+pDRjLBBMJA/Rt6ZhLwilZs
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="365161713"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="365161713"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 10:16:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="925007348"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="925007348"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 14 Mar 2023 10:16:45 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pc8GT-00073g-0J;
        Tue, 14 Mar 2023 17:16:45 +0000
Date:   Wed, 15 Mar 2023 01:15:59 +0800
From:   kernel test robot <lkp@intel.com>
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, linux-block@vger.kernel.org,
        Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V2 07/17] block: ublk_drv: add common exit handling
Message-ID: <202303150036.BLkTgToJ-lkp@intel.com>
References: <20230307141520.793891-8-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230307141520.793891-8-ming.lei@redhat.com>
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
patch link:    https://lore.kernel.org/r/20230307141520.793891-8-ming.lei%40redhat.com
patch subject: [PATCH V2 07/17] block: ublk_drv: add common exit handling
config: microblaze-randconfig-s033-20230308 (https://download.01.org/0day-ci/archive/20230315/202303150036.BLkTgToJ-lkp@intel.com/config)
compiler: microblaze-linux-gcc (GCC) 12.1.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/53855edaeebdbd21c916cbb864ac45cb64def9cd
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Ming-Lei/io_uring-add-IO_URING_F_FUSED-and-prepare-for-supporting-OP_FUSED_CMD/20230307-222928
        git checkout 53855edaeebdbd21c916cbb864ac45cb64def9cd
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=microblaze olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=microblaze SHELL=/bin/bash drivers/block/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303150036.BLkTgToJ-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/block/ublk_drv.c:665:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected int res @@     got restricted blk_status_t @@
   drivers/block/ublk_drv.c:665:21: sparse:     expected int res
   drivers/block/ublk_drv.c:665:21: sparse:     got restricted blk_status_t
>> drivers/block/ublk_drv.c:696:33: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected restricted blk_status_t [usertype] error @@     got int res @@
   drivers/block/ublk_drv.c:696:33: sparse:     expected restricted blk_status_t [usertype] error
   drivers/block/ublk_drv.c:696:33: sparse:     got int res

vim +665 drivers/block/ublk_drv.c

   651	
   652	/* todo: handle partial completion */
   653	static void ublk_complete_rq(struct request *req)
   654	{
   655		struct ublk_queue *ubq = req->mq_hctx->driver_data;
   656		struct ublk_io *io = &ubq->ios[req->tag];
   657		unsigned int unmapped_bytes;
   658		int res = BLK_STS_OK;
   659	
   660		/* failed read IO if nothing is read */
   661		if (!io->res && req_op(req) == REQ_OP_READ)
   662			io->res = -EIO;
   663	
   664		if (io->res < 0) {
 > 665			res = errno_to_blk_status(io->res);
   666			goto exit;
   667		}
   668	
   669		/*
   670		 * FLUSH, DISCARD or WRITE_ZEROES usually won't return bytes returned, so end them
   671		 * directly.
   672		 *
   673		 * Both the two needn't unmap.
   674		 */
   675		if (req_op(req) != REQ_OP_READ && req_op(req) != REQ_OP_WRITE)
   676			goto exit;
   677	
   678		/* for READ request, writing data in iod->addr to rq buffers */
   679		unmapped_bytes = ublk_unmap_io(ubq, req, io);
   680	
   681		/*
   682		 * Extremely impossible since we got data filled in just before
   683		 *
   684		 * Re-read simply for this unlikely case.
   685		 */
   686		if (unlikely(unmapped_bytes < io->res))
   687			io->res = unmapped_bytes;
   688	
   689		if (blk_update_request(req, BLK_STS_OK, io->res))
   690			blk_mq_requeue_request(req, true);
   691		else
   692			__blk_mq_end_request(req, BLK_STS_OK);
   693	
   694		return;
   695	exit:
 > 696		blk_mq_end_request(req, res);
   697	}
   698	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
