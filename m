Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E05826DB7C1
	for <lists+io-uring@lfdr.de>; Sat,  8 Apr 2023 02:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbjDHAXU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Apr 2023 20:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjDHAXT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Apr 2023 20:23:19 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB30E06F;
        Fri,  7 Apr 2023 17:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680913398; x=1712449398;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LufqfnytMANvcxNJ9tE+ZSPiZ5hHXw1+mMxhZIW3ZOo=;
  b=JZcMX2K3BSv9QJx2zEvpQDdG1UnU2VzuZ8UnmCJeUMPMEqx3vV39ob/R
   TOL+ZwzEjS2VR+lLBlz9H+uNG+BAzCuEFGeEMGYKEiwmm5XK3obKyOQOP
   EPlKvxTANBXFhwWdqSI4Z9kM+lCEdOZfdmslkXFIS0gvbH1x7rWpkZvaI
   T1D94i8vZJVmCVJl+PVUOXtF3RoXdMlVsNeR6TdoM7h1L/uI+xOS4AxRO
   xEVEpPpT6zOHNdiL7J6bfwLSkxwnCjel+SSL24zwiEqDEvC2ex9ZQydLX
   n1xq5jCjixrgtRs54n5ftxhCmxwvFjQWSBfnqO8y/9UcX23aB21fdIgiE
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10673"; a="429377758"
X-IronPort-AV: E=Sophos;i="5.98,328,1673942400"; 
   d="scan'208";a="429377758"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2023 17:23:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10673"; a="637860228"
X-IronPort-AV: E=Sophos;i="5.98,328,1673942400"; 
   d="scan'208";a="637860228"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 07 Apr 2023 17:23:15 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pkwMM-000T3h-12;
        Sat, 08 Apr 2023 00:23:14 +0000
Date:   Sat, 8 Apr 2023 08:22:32 +0800
From:   kernel test robot <lkp@intel.com>
To:     Keith Busch <kbusch@meta.com>, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        axboe@kernel.dk, hch@lst.de
Cc:     oe-kbuild-all@lists.linux.dev, sagi@grimberg.me,
        joshi.k@samsung.com, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv2 2/5] nvme: simplify passthrough bio cleanup
Message-ID: <202304080846.C2qDQtUd-lkp@intel.com>
References: <20230407191636.2631046-3-kbusch@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407191636.2631046-3-kbusch@meta.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Keith,

kernel test robot noticed the following build warnings:

[auto build test WARNING on axboe-block/for-next]
[also build test WARNING on next-20230406]
[cannot apply to linus/master v6.3-rc5]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Keith-Busch/block-add-request-polling-helper/20230408-031926
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
patch link:    https://lore.kernel.org/r/20230407191636.2631046-3-kbusch%40meta.com
patch subject: [PATCHv2 2/5] nvme: simplify passthrough bio cleanup
config: ia64-allyesconfig (https://download.01.org/0day-ci/archive/20230408/202304080846.C2qDQtUd-lkp@intel.com/config)
compiler: ia64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/9a32e7ca02dd8cff559b273fe161b5347b5b5c97
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Keith-Busch/block-add-request-polling-helper/20230408-031926
        git checkout 9a32e7ca02dd8cff559b273fe161b5347b5b5c97
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=ia64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=ia64 SHELL=/bin/bash drivers/nvme/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202304080846.C2qDQtUd-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/nvme/host/ioctl.c: In function 'nvme_submit_user_cmd':
>> drivers/nvme/host/ioctl.c:232:21: warning: variable 'bio' set but not used [-Wunused-but-set-variable]
     232 |         struct bio *bio;
         |                     ^~~
   drivers/nvme/host/ioctl.c: In function 'nvme_uring_cmd_end_io_meta':
   drivers/nvme/host/ioctl.c:528:36: warning: unused variable 'pdu' [-Wunused-variable]
     528 |         struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
         |                                    ^~~


vim +/bio +232 drivers/nvme/host/ioctl.c

2405252a680e21 Christoph Hellwig 2021-04-10  222  
bcad2565b5d647 Christoph Hellwig 2022-05-11  223  static int nvme_submit_user_cmd(struct request_queue *q,
7b7fdb8e2dbc15 Christoph Hellwig 2023-01-08  224  		struct nvme_command *cmd, u64 ubuffer, unsigned bufflen,
7b7fdb8e2dbc15 Christoph Hellwig 2023-01-08  225  		void __user *meta_buffer, unsigned meta_len, u32 meta_seed,
7b7fdb8e2dbc15 Christoph Hellwig 2023-01-08  226  		u64 *result, unsigned timeout, unsigned int flags)
bcad2565b5d647 Christoph Hellwig 2022-05-11  227  {
62281b9ed671be Christoph Hellwig 2022-12-14  228  	struct nvme_ns *ns = q->queuedata;
bc8fb906b0ff93 Keith Busch       2022-09-19  229  	struct nvme_ctrl *ctrl;
bcad2565b5d647 Christoph Hellwig 2022-05-11  230  	struct request *req;
bcad2565b5d647 Christoph Hellwig 2022-05-11  231  	void *meta = NULL;
bcad2565b5d647 Christoph Hellwig 2022-05-11 @232  	struct bio *bio;
bc8fb906b0ff93 Keith Busch       2022-09-19  233  	u32 effects;
bcad2565b5d647 Christoph Hellwig 2022-05-11  234  	int ret;
bcad2565b5d647 Christoph Hellwig 2022-05-11  235  
470e900c8036ff Kanchan Joshi     2022-09-30  236  	req = nvme_alloc_user_request(q, cmd, 0, 0);
bcad2565b5d647 Christoph Hellwig 2022-05-11  237  	if (IS_ERR(req))
bcad2565b5d647 Christoph Hellwig 2022-05-11  238  		return PTR_ERR(req);
bcad2565b5d647 Christoph Hellwig 2022-05-11  239  
470e900c8036ff Kanchan Joshi     2022-09-30  240  	req->timeout = timeout;
470e900c8036ff Kanchan Joshi     2022-09-30  241  	if (ubuffer && bufflen) {
470e900c8036ff Kanchan Joshi     2022-09-30  242  		ret = nvme_map_user_request(req, ubuffer, bufflen, meta_buffer,
7b7fdb8e2dbc15 Christoph Hellwig 2023-01-08  243  				meta_len, meta_seed, &meta, NULL, flags);
470e900c8036ff Kanchan Joshi     2022-09-30  244  		if (ret)
470e900c8036ff Kanchan Joshi     2022-09-30  245  			return ret;
470e900c8036ff Kanchan Joshi     2022-09-30  246  	}
470e900c8036ff Kanchan Joshi     2022-09-30  247  
bcad2565b5d647 Christoph Hellwig 2022-05-11  248  	bio = req->bio;
bc8fb906b0ff93 Keith Busch       2022-09-19  249  	ctrl = nvme_req(req)->ctrl;
bcad2565b5d647 Christoph Hellwig 2022-05-11  250  
62281b9ed671be Christoph Hellwig 2022-12-14  251  	effects = nvme_passthru_start(ctrl, ns, cmd->common.opcode);
62281b9ed671be Christoph Hellwig 2022-12-14  252  	ret = nvme_execute_rq(req, false);
2405252a680e21 Christoph Hellwig 2021-04-10  253  	if (result)
2405252a680e21 Christoph Hellwig 2021-04-10  254  		*result = le64_to_cpu(nvme_req(req)->result.u64);
bcad2565b5d647 Christoph Hellwig 2022-05-11  255  	if (meta)
bcad2565b5d647 Christoph Hellwig 2022-05-11  256  		ret = nvme_finish_user_metadata(req, meta_buffer, meta,
bcad2565b5d647 Christoph Hellwig 2022-05-11  257  						meta_len, ret);
2405252a680e21 Christoph Hellwig 2021-04-10  258  	blk_mq_free_request(req);
bc8fb906b0ff93 Keith Busch       2022-09-19  259  
bc8fb906b0ff93 Keith Busch       2022-09-19  260  	if (effects)
bc8fb906b0ff93 Keith Busch       2022-09-19  261  		nvme_passthru_end(ctrl, effects, cmd, ret);
bc8fb906b0ff93 Keith Busch       2022-09-19  262  
2405252a680e21 Christoph Hellwig 2021-04-10  263  	return ret;
2405252a680e21 Christoph Hellwig 2021-04-10  264  }
2405252a680e21 Christoph Hellwig 2021-04-10  265  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
