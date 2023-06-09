Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5E172A6A4
	for <lists+io-uring@lfdr.de>; Sat, 10 Jun 2023 01:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbjFIXQ6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Jun 2023 19:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjFIXQ6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Jun 2023 19:16:58 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC112D74;
        Fri,  9 Jun 2023 16:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686352616; x=1717888616;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NKoOHaX6l6x0SCS24r79Bw/KIMVdA/0NvICFzPRQVdI=;
  b=XHqrY/Uj6hEa5S3urP4FAAZfl1+VvWRQ2AV2pH28rbGuAGmGYlGh3Wie
   nGMEVM1gR1d6Ont/zdpbJpYrct769ajw3vLFTUxzU2B27SdgbkYbEofef
   VZCmRMyPmEU38oFlkZ4ajWGruSODE2ZbrQC2j3zdOelPS6a5md12KK2Xa
   OF03qAgbtVbntJqUS+B/YNpFiPCuruALFzQTwAw+0HSfRwfmByNZZjO8Q
   ffiFV0vrWoj/msE1EI7et+2p+7lqafrkR4BxY4PzryEPqgJdsL+S1qe21
   4vo47KK0oT3rRxHoA+UZGBV6aJEzH6h8PyWM99/xGwjykaNEVTPGLMPJz
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="357704651"
X-IronPort-AV: E=Sophos;i="6.00,230,1681196400"; 
   d="scan'208";a="357704651"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 16:16:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="800374545"
X-IronPort-AV: E=Sophos;i="6.00,230,1681196400"; 
   d="scan'208";a="800374545"
Received: from lkp-server01.sh.intel.com (HELO 15ab08e44a81) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 09 Jun 2023 16:16:53 -0700
Received: from kbuild by 15ab08e44a81 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1q7lLg-0009UJ-2q;
        Fri, 09 Jun 2023 23:16:52 +0000
Date:   Sat, 10 Jun 2023 07:16:36 +0800
From:   kernel test robot <lkp@intel.com>
To:     Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        hch@lst.de, axboe@kernel.dk
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        sagi@grimberg.me, joshi.k@samsung.com,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv2 2/2] nvme: improved uring polling
Message-ID: <202306100746.D72gucag-lkp@intel.com>
References: <20230609204517.493889-3-kbusch@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230609204517.493889-3-kbusch@meta.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Keith,

kernel test robot noticed the following build errors:

[auto build test ERROR on axboe-block/for-next]
[also build test ERROR on next-20230609]
[cannot apply to linus/master v6.4-rc5]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Keith-Busch/block-add-request-polling-helper/20230610-044707
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
patch link:    https://lore.kernel.org/r/20230609204517.493889-3-kbusch%40meta.com
patch subject: [PATCHv2 2/2] nvme: improved uring polling
config: riscv-randconfig-r015-20230608 (https://download.01.org/0day-ci/archive/20230610/202306100746.D72gucag-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project.git f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        mkdir -p ~/bin
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install riscv cross compiling tool for clang build
        # apt-get install binutils-riscv64-linux-gnu
        git remote add axboe-block https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git
        git fetch axboe-block for-next
        git checkout axboe-block/for-next
        b4 shazam https://lore.kernel.org/r/20230609204517.493889-3-kbusch@meta.com
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang ~/bin/make.cross W=1 O=build_dir ARCH=riscv olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang ~/bin/make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash drivers/nvme/host/

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306100746.D72gucag-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/nvme/host/ioctl.c:546:2: error: expected expression
           else {
           ^
>> drivers/nvme/host/ioctl.c:555:1: error: function definition is not allowed here
   {
   ^
   drivers/nvme/host/ioctl.c:638:1: error: function definition is not allowed here
   {
   ^
   drivers/nvme/host/ioctl.c:648:1: error: function definition is not allowed here
   {
   ^
   drivers/nvme/host/ioctl.c:679:1: error: function definition is not allowed here
   {
   ^
   drivers/nvme/host/ioctl.c:708:1: error: function definition is not allowed here
   {
   ^
   drivers/nvme/host/ioctl.c:722:1: error: function definition is not allowed here
   {
   ^
   drivers/nvme/host/ioctl.c:733:1: error: function definition is not allowed here
   {
   ^
   drivers/nvme/host/ioctl.c:744:1: error: function definition is not allowed here
   {
   ^
   drivers/nvme/host/ioctl.c:769:1: error: function definition is not allowed here
   {
   ^
   drivers/nvme/host/ioctl.c:779:1: error: function definition is not allowed here
   {
   ^
   drivers/nvme/host/ioctl.c:884:1: error: function definition is not allowed here
   {
   ^
   drivers/nvme/host/ioctl.c:912:1: error: function definition is not allowed here
   {
   ^
   drivers/nvme/host/ioctl.c:946:1: error: function definition is not allowed here
   {
   ^
>> drivers/nvme/host/ioctl.c:974:2: error: expected '}'
   }
    ^
   drivers/nvme/host/ioctl.c:532:1: note: to match this '{'
   {
   ^
   15 errors generated.


vim +546 drivers/nvme/host/ioctl.c

   529	
   530	static enum rq_end_io_ret nvme_uring_cmd_end_io_meta(struct request *req,
   531							     blk_status_t err)
   532	{
   533		struct io_uring_cmd *ioucmd = req->end_io_data;
   534		struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
   535	
   536		req->bio = pdu->bio;
   537		pdu->req = req;
   538	
   539		/*
   540		 * For iopoll, complete it directly.
   541		 * Otherwise, move the completion to task work.
   542		 */
   543		if (blk_rq_is_poll(req)) {
   544			WRITE_ONCE(ioucmd->cookie, NULL);
   545			nvme_uring_task_meta_cb(ioucmd, IO_URING_F_UNLOCKED);
 > 546		else {
   547			io_uring_cmd_do_in_task_lazy(ioucmd, nvme_uring_task_meta_cb);
   548		}
   549	
   550		return RQ_END_IO_NONE;
   551	}
   552	
   553	static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
   554			struct io_uring_cmd *ioucmd, unsigned int issue_flags, bool vec)
 > 555	{
   556		struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
   557		const struct nvme_uring_cmd *cmd = io_uring_sqe_cmd(ioucmd->sqe);
   558		struct request_queue *q = ns ? ns->queue : ctrl->admin_q;
   559		struct nvme_uring_data d;
   560		struct nvme_command c;
   561		struct request *req;
   562		blk_opf_t rq_flags = REQ_ALLOC_CACHE;
   563		blk_mq_req_flags_t blk_flags = 0;
   564		void *meta = NULL;
   565		int ret;
   566	
   567		c.common.opcode = READ_ONCE(cmd->opcode);
   568		c.common.flags = READ_ONCE(cmd->flags);
   569		if (c.common.flags)
   570			return -EINVAL;
   571	
   572		c.common.command_id = 0;
   573		c.common.nsid = cpu_to_le32(cmd->nsid);
   574		if (!nvme_validate_passthru_nsid(ctrl, ns, le32_to_cpu(c.common.nsid)))
   575			return -EINVAL;
   576	
   577		c.common.cdw2[0] = cpu_to_le32(READ_ONCE(cmd->cdw2));
   578		c.common.cdw2[1] = cpu_to_le32(READ_ONCE(cmd->cdw3));
   579		c.common.metadata = 0;
   580		c.common.dptr.prp1 = c.common.dptr.prp2 = 0;
   581		c.common.cdw10 = cpu_to_le32(READ_ONCE(cmd->cdw10));
   582		c.common.cdw11 = cpu_to_le32(READ_ONCE(cmd->cdw11));
   583		c.common.cdw12 = cpu_to_le32(READ_ONCE(cmd->cdw12));
   584		c.common.cdw13 = cpu_to_le32(READ_ONCE(cmd->cdw13));
   585		c.common.cdw14 = cpu_to_le32(READ_ONCE(cmd->cdw14));
   586		c.common.cdw15 = cpu_to_le32(READ_ONCE(cmd->cdw15));
   587	
   588		if (!nvme_cmd_allowed(ns, &c, 0, ioucmd->file->f_mode))
   589			return -EACCES;
   590	
   591		d.metadata = READ_ONCE(cmd->metadata);
   592		d.addr = READ_ONCE(cmd->addr);
   593		d.data_len = READ_ONCE(cmd->data_len);
   594		d.metadata_len = READ_ONCE(cmd->metadata_len);
   595		d.timeout_ms = READ_ONCE(cmd->timeout_ms);
   596	
   597		if (issue_flags & IO_URING_F_NONBLOCK) {
   598			rq_flags |= REQ_NOWAIT;
   599			blk_flags = BLK_MQ_REQ_NOWAIT;
   600		}
   601		if (issue_flags & IO_URING_F_IOPOLL)
   602			rq_flags |= REQ_POLLED;
   603	
   604		req = nvme_alloc_user_request(q, &c, rq_flags, blk_flags);
   605		if (IS_ERR(req))
   606			return PTR_ERR(req);
   607		req->timeout = d.timeout_ms ? msecs_to_jiffies(d.timeout_ms) : 0;
   608	
   609		if (d.addr && d.data_len) {
   610			ret = nvme_map_user_request(req, d.addr,
   611				d.data_len, nvme_to_user_ptr(d.metadata),
   612				d.metadata_len, 0, &meta, ioucmd, vec);
   613			if (ret)
   614				return ret;
   615		}
   616	
   617		if (blk_rq_is_poll(req)) {
   618			ioucmd->flags |= IORING_URING_CMD_POLLED;
   619			WRITE_ONCE(ioucmd->cookie, req);
   620		}
   621	
   622		/* to free bio on completion, as req->bio will be null at that time */
   623		pdu->bio = req->bio;
   624		pdu->meta_len = d.metadata_len;
   625		req->end_io_data = ioucmd;
   626		if (pdu->meta_len) {
   627			pdu->u.meta = meta;
   628			pdu->u.meta_buffer = nvme_to_user_ptr(d.metadata);
   629			req->end_io = nvme_uring_cmd_end_io_meta;
   630		} else {
   631			req->end_io = nvme_uring_cmd_end_io;
   632		}
   633		blk_execute_rq_nowait(req, false);
   634		return -EIOCBQUEUED;
   635	}
   636	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
