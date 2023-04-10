Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C13AD6DCC86
	for <lists+io-uring@lfdr.de>; Mon, 10 Apr 2023 23:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbjDJVCo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Apr 2023 17:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbjDJVCo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Apr 2023 17:02:44 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17ED010F6;
        Mon, 10 Apr 2023 14:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681160563; x=1712696563;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/iFIhWoDac+UT40gLNkBeOwuDo3E6+5ZVwgNZZpo0ak=;
  b=cJsUjj8mqUXhTBnWzlhw91jfHbqpp/FJSKE4eikEDWUJwCTqAAE8XP+C
   qmYuFGss5Fpy58qBxRMG2E+7FmyhXkMJDuYBbB/9LdfWABm/Rs4EIJeQU
   tosjdc/8adimk/ekX8or8tHohC+kmSAVn+ktMfzIv+coyQ0vdqLwrU9XR
   QdOHZNb6EBJEXT0FmJ+4COz0uvibCKWbSvrHldQ5/vZwKVwIVQuIfIyX/
   N6mVNsMpKXPCyi2MVOQcfT4UrfHXtE+lN3NxAC9hOhAURhS4imnAsvCL0
   GY3bOW1jeu+VwJCeoJ5m7MaGXy3oynvo5D82O9dVF1FoGZcz8GjEpnq5d
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="345240686"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="345240686"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 14:02:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="832096656"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="832096656"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 10 Apr 2023 14:02:39 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1plyes-000VfZ-2X;
        Mon, 10 Apr 2023 21:02:38 +0000
Date:   Tue, 11 Apr 2023 05:02:22 +0800
From:   kernel test robot <lkp@intel.com>
To:     Keith Busch <kbusch@meta.com>, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        axboe@kernel.dk, hch@lst.de
Cc:     oe-kbuild-all@lists.linux.dev, sagi@grimberg.me,
        joshi.k@samsung.com, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv2 2/5] nvme: simplify passthrough bio cleanup
Message-ID: <202304110443.e026C3nq-lkp@intel.com>
References: <20230407191636.2631046-3-kbusch@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407191636.2631046-3-kbusch@meta.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Keith,

kernel test robot noticed the following build warnings:

[auto build test WARNING on axboe-block/for-next]
[also build test WARNING on next-20230406]
[cannot apply to linus/master v6.3-rc6]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Keith-Busch/block-add-request-polling-helper/20230408-031926
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
patch link:    https://lore.kernel.org/r/20230407191636.2631046-3-kbusch%40meta.com
patch subject: [PATCHv2 2/5] nvme: simplify passthrough bio cleanup
config: x86_64-rhel-8.3 (https://download.01.org/0day-ci/archive/20230411/202304110443.e026C3nq-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/9a32e7ca02dd8cff559b273fe161b5347b5b5c97
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Keith-Busch/block-add-request-polling-helper/20230408-031926
        git checkout 9a32e7ca02dd8cff559b273fe161b5347b5b5c97
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 olddefconfig
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/nvme/host/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304110443.e026C3nq-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/nvme/host/ioctl.c: In function 'nvme_submit_user_cmd':
   drivers/nvme/host/ioctl.c:232:21: warning: variable 'bio' set but not used [-Wunused-but-set-variable]
     232 |         struct bio *bio;
         |                     ^~~
   drivers/nvme/host/ioctl.c: In function 'nvme_uring_cmd_end_io_meta':
>> drivers/nvme/host/ioctl.c:528:36: warning: unused variable 'pdu' [-Wunused-variable]
     528 |         struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
         |                                    ^~~


vim +/pdu +528 drivers/nvme/host/ioctl.c

c0a7ba77e81b84 Jens Axboe    2022-09-21  523  
c0a7ba77e81b84 Jens Axboe    2022-09-21  524  static enum rq_end_io_ret nvme_uring_cmd_end_io_meta(struct request *req,
c0a7ba77e81b84 Jens Axboe    2022-09-21  525  						     blk_status_t err)
c0a7ba77e81b84 Jens Axboe    2022-09-21  526  {
c0a7ba77e81b84 Jens Axboe    2022-09-21  527  	struct io_uring_cmd *ioucmd = req->end_io_data;
c0a7ba77e81b84 Jens Axboe    2022-09-21 @528  	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
c0a7ba77e81b84 Jens Axboe    2022-09-21  529  	void *cookie = READ_ONCE(ioucmd->cookie);
c0a7ba77e81b84 Jens Axboe    2022-09-21  530  
c0a7ba77e81b84 Jens Axboe    2022-09-21  531  	/*
c0a7ba77e81b84 Jens Axboe    2022-09-21  532  	 * For iopoll, complete it directly.
c0a7ba77e81b84 Jens Axboe    2022-09-21  533  	 * Otherwise, move the completion to task work.
c0a7ba77e81b84 Jens Axboe    2022-09-21  534  	 */
c0a7ba77e81b84 Jens Axboe    2022-09-21  535  	if (cookie != NULL && blk_rq_is_poll(req))
9d2789ac9d60c0 Jens Axboe    2023-03-20  536  		nvme_uring_task_meta_cb(ioucmd, IO_URING_F_UNLOCKED);
c0a7ba77e81b84 Jens Axboe    2022-09-21  537  	else
c0a7ba77e81b84 Jens Axboe    2022-09-21  538  		io_uring_cmd_complete_in_task(ioucmd, nvme_uring_task_meta_cb);
c0a7ba77e81b84 Jens Axboe    2022-09-21  539  
de671d6116b521 Jens Axboe    2022-09-21  540  	return RQ_END_IO_NONE;
456cba386e94f2 Kanchan Joshi 2022-05-11  541  }
456cba386e94f2 Kanchan Joshi 2022-05-11  542  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
