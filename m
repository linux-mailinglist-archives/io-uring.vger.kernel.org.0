Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84F7F58BACD
	for <lists+io-uring@lfdr.de>; Sun,  7 Aug 2022 14:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233412AbiHGM0h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Aug 2022 08:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232885AbiHGM0g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Aug 2022 08:26:36 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A5FA10F0;
        Sun,  7 Aug 2022 05:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659875195; x=1691411195;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=C8OJFU9nJ9ZOIk2R+bGe3FsCe9iC7W48BOxnXR0mX9g=;
  b=FBshF0FlAq33YwiDvEuzuC14PmCSdKFXUJ1U6brvrXe0AvuE32XqnN0A
   4MKIu4vmXAzgml47AtIE55daco5BNN7eYWD1W+fw2vXWcFrUSODKTL/AX
   3tQ/sEokEfP+PVycltJ9BJa5IutO7I1u3DtPyG06gqxXyi/17YZ1Gx7OF
   9HVC7gpkGHjgZjXA7kuUib0TzCOt77Ft+t1R+5KIGapBAxDlOrsP3JFU0
   mAWOAxp+RhGcs9GbGkwzQ8RV6ZXNQ4ehVs4qWeI6xz68TL3VSHCeNER1P
   27jZklH7ztcL0LSLXJHIZkONFRWgByM2m/yN/AfU/QGMEGCFnKXGkAD+E
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10431"; a="287997501"
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="287997501"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 05:26:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="693465426"
Received: from lkp-server01.sh.intel.com (HELO e0eace57cfef) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Aug 2022 05:26:32 -0700
Received: from kbuild by e0eace57cfef with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oKfMV-000LHw-2G;
        Sun, 07 Aug 2022 12:26:31 +0000
Date:   Sun, 7 Aug 2022 20:25:41 +0800
From:   kernel test robot <lkp@intel.com>
To:     Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk, hch@lst.de
Cc:     kbuild-all@lists.01.org, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        ming.lei@redhat.com, joshiiitr@gmail.com, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH 4/4] nvme: wire up async polling for io passthrough
 commands
Message-ID: <202208072057.wTajgd76-lkp@intel.com>
References: <20220805154226.155008-5-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220805154226.155008-5-joshi.k@samsung.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Kanchan,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on axboe-block/for-next]
[also build test WARNING on linus/master next-20220805]
[cannot apply to hch-configfs/for-next v5.19]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Kanchan-Joshi/fs-add-file_operations-uring_cmd_iopoll/20220806-004320
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
config: ia64-randconfig-s032-20220807 (https://download.01.org/0day-ci/archive/20220807/202208072057.wTajgd76-lkp@intel.com/config)
compiler: ia64-linux-gcc (GCC) 12.1.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/0964795577fbf09d8b315269504b5e87b5ac492b
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Kanchan-Joshi/fs-add-file_operations-uring_cmd_iopoll/20220806-004320
        git checkout 0964795577fbf09d8b315269504b5e87b5ac492b
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=ia64 SHELL=/bin/bash drivers/nvme/host/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

sparse warnings: (new ones prefixed by >>)
>> drivers/nvme/host/ioctl.c:639:37: sparse: sparse: Using plain integer as NULL pointer

vim +639 drivers/nvme/host/ioctl.c

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
   638		if (test_bit(QUEUE_FLAG_POLL, &q->queue_flags) && bio && bio->bi_bdev)
 > 639			ret = bio_poll(bio, 0, 0);
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

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
