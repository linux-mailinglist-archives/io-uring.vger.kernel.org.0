Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92F746B2BF2
	for <lists+io-uring@lfdr.de>; Thu,  9 Mar 2023 18:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbjCIRXv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Mar 2023 12:23:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbjCIRXm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Mar 2023 12:23:42 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18CBA18B35;
        Thu,  9 Mar 2023 09:23:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678382621; x=1709918621;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=K3OoSeBFVBCAzSn/NYt4XYgke9k0N2/YyslC9mwV60k=;
  b=QqUpvchfRr0Rjz9GotcBEVLLC25ztIdoSiFwViUJiLs5qQX5LFpffH7N
   KXAvw+BgD26F1wAHnNfeQNDnpyIKCX6So7kfUvvROJMu5QD3aa5tAwm6J
   Q/YoQWjOyRDgYPZuCMM0qiHvJ5sBaVnfgxnZsikW75xMBdsJi+8K0rkVp
   U6frhLOG1ZWxxPErmCBq0yJAJeXyVigSl2+YbGfp91XXCsM+YbDBhfdbj
   l7KhlOVf8d3emdBCT8aZXXTEvluadxWgnH0Hr1OEtvgadUVUV9msjXPqD
   IoTZiYs6m8Qhwl+cImPKW0mnWGaFwbxwk4FTJUgADV5pjw7cLoDQA3NoB
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="335210897"
X-IronPort-AV: E=Sophos;i="5.98,247,1673942400"; 
   d="scan'208";a="335210897"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2023 09:23:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="923335333"
X-IronPort-AV: E=Sophos;i="5.98,247,1673942400"; 
   d="scan'208";a="923335333"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 09 Mar 2023 09:23:35 -0800
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1paJzK-000371-35;
        Thu, 09 Mar 2023 17:23:34 +0000
Date:   Fri, 10 Mar 2023 01:22:59 +0800
From:   kernel test robot <lkp@intel.com>
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, linux-block@vger.kernel.org,
        Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V2 05/17] io_uring: support OP_SEND_ZC/OP_RECV for fused
 slave request
Message-ID: <202303100159.i9Bzx24n-lkp@intel.com>
References: <20230307141520.793891-6-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230307141520.793891-6-ming.lei@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Ming,

I love your patch! Perhaps something to improve:

[auto build test WARNING on axboe-block/for-next]
[also build test WARNING on linus/master v6.3-rc1 next-20230309]
[cannot apply to char-misc/char-misc-testing char-misc/char-misc-next char-misc/char-misc-linus]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ming-Lei/io_uring-add-IO_URING_F_FUSED-and-prepare-for-supporting-OP_FUSED_CMD/20230307-222928
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
patch link:    https://lore.kernel.org/r/20230307141520.793891-6-ming.lei%40redhat.com
patch subject: [PATCH V2 05/17] io_uring: support OP_SEND_ZC/OP_RECV for fused slave request
config: sparc64-randconfig-s031-20230308 (https://download.01.org/0day-ci/archive/20230310/202303100159.i9Bzx24n-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 12.1.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/0a921da27026b3ba08aeceb432dd983480281344
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Ming-Lei/io_uring-add-IO_URING_F_FUSED-and-prepare-for-supporting-OP_FUSED_CMD/20230307-222928
        git checkout 0a921da27026b3ba08aeceb432dd983480281344
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=sparc64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=sparc64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303100159.i9Bzx24n-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   io_uring/net.c: note: in included file (through io_uring/io_uring.h):
   io_uring/slist.h:116:29: sparse: sparse: no newline at end of file
   io_uring/net.c: note: in included file (through io_uring/io_uring.h):
   include/linux/io_uring_types.h:179:37: sparse: sparse: array of flexible structures
>> io_uring/net.c:385:49: sparse: sparse: cast removes address space '__user' of expression
   io_uring/net.c:880:49: sparse: sparse: cast removes address space '__user' of expression
   io_uring/net.c:1135:49: sparse: sparse: cast removes address space '__user' of expression

vim +/__user +385 io_uring/net.c

   343	
   344	int io_send(struct io_kiocb *req, unsigned int issue_flags)
   345	{
   346		struct sockaddr_storage __address;
   347		struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
   348		struct msghdr msg;
   349		struct socket *sock;
   350		unsigned flags;
   351		int min_ret = 0;
   352		int ret;
   353	
   354		msg.msg_name = NULL;
   355		msg.msg_control = NULL;
   356		msg.msg_controllen = 0;
   357		msg.msg_namelen = 0;
   358		msg.msg_ubuf = NULL;
   359	
   360		if (sr->addr) {
   361			if (req_has_async_data(req)) {
   362				struct io_async_msghdr *io = req->async_data;
   363	
   364				msg.msg_name = &io->addr;
   365			} else {
   366				ret = move_addr_to_kernel(sr->addr, sr->addr_len, &__address);
   367				if (unlikely(ret < 0))
   368					return ret;
   369				msg.msg_name = (struct sockaddr *)&__address;
   370			}
   371			msg.msg_namelen = sr->addr_len;
   372		}
   373	
   374		if (!(req->flags & REQ_F_POLLED) &&
   375		    (sr->flags & IORING_RECVSEND_POLL_FIRST))
   376			return io_setup_async_addr(req, &__address, issue_flags);
   377	
   378		sock = sock_from_file(req->file);
   379		if (unlikely(!sock))
   380			return -ENOTSOCK;
   381	
   382		if (!(req->flags & REQ_F_FUSED_SLAVE))
   383			ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len, &msg.msg_iter);
   384		else
 > 385			ret = io_import_kbuf_for_slave((u64)sr->buf, sr->len,
   386					ITER_SOURCE, &msg.msg_iter, req);
   387		if (unlikely(ret))
   388			return ret;
   389	
   390		flags = sr->msg_flags;
   391		if (issue_flags & IO_URING_F_NONBLOCK)
   392			flags |= MSG_DONTWAIT;
   393		if (flags & MSG_WAITALL)
   394			min_ret = iov_iter_count(&msg.msg_iter);
   395	
   396		msg.msg_flags = flags;
   397		ret = sock_sendmsg(sock, &msg);
   398		if (ret < min_ret) {
   399			if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
   400				return io_setup_async_addr(req, &__address, issue_flags);
   401	
   402			if (ret > 0 && io_net_retry(sock, flags)) {
   403				sr->len -= ret;
   404				sr->buf += ret;
   405				sr->done_io += ret;
   406				req->flags |= REQ_F_PARTIAL_IO;
   407				return io_setup_async_addr(req, &__address, issue_flags);
   408			}
   409			if (ret == -ERESTARTSYS)
   410				ret = -EINTR;
   411			req_set_fail(req);
   412		}
   413		if (ret >= 0)
   414			ret += sr->done_io;
   415		else if (sr->done_io)
   416			ret = sr->done_io;
   417		io_req_set_res(req, ret, 0);
   418		return IOU_OK;
   419	}
   420	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
