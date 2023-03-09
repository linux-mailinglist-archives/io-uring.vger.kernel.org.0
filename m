Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32E036B1CE5
	for <lists+io-uring@lfdr.de>; Thu,  9 Mar 2023 08:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjCIHuM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Mar 2023 02:50:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbjCIHtz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Mar 2023 02:49:55 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFFC31B57E;
        Wed,  8 Mar 2023 23:48:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678348087; x=1709884087;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qeq63lYyfAfHhk1xOZ63kvMHWyrmYCAuvEirxhJBR10=;
  b=aHbMw2sJC+pcbNjD3bNWzCfc/TKAzBmRJ3ISsKlEfMqJXIcgMgTcZeSV
   0htCjOaT8ezP5SrqT27VybUOOezQwi6QrJCGn/90K0d30l1cR1A/VirwQ
   JlwhEiCP+POUP5RaqudXLVNJjqd+e8zf3NCq2Xb+kOpNPfr1LCdwQC95E
   HBAulC4YnFI+oSXfrBrZEwHBlGTUnU2e1iEoBDHUDSkm4WUIKhJy2sAC7
   xKYiHsqKaRfqbdo29feFbyiUnbUcuZ9PZXyuJ5rrx/vvVY5vrrGaEsnKu
   fxT70C5POExKAT02ggRaTm/wK3Z0IpQuHEtAkpECVZJTFNbRPTUp2+bb4
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10643"; a="401216047"
X-IronPort-AV: E=Sophos;i="5.98,245,1673942400"; 
   d="scan'208";a="401216047"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2023 23:47:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10643"; a="766333568"
X-IronPort-AV: E=Sophos;i="5.98,245,1673942400"; 
   d="scan'208";a="766333568"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Mar 2023 23:47:14 -0800
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1paAza-0002ko-0I;
        Thu, 09 Mar 2023 07:47:14 +0000
Date:   Thu, 9 Mar 2023 15:46:49 +0800
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
Message-ID: <202303091544.WIDavyIo-lkp@intel.com>
References: <20230307141520.793891-6-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230307141520.793891-6-ming.lei@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
config: i386-randconfig-a003 (https://download.01.org/0day-ci/archive/20230309/202303091544.WIDavyIo-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/0a921da27026b3ba08aeceb432dd983480281344
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Ming-Lei/io_uring-add-IO_URING_F_FUSED-and-prepare-for-supporting-OP_FUSED_CMD/20230307-222928
        git checkout 0a921da27026b3ba08aeceb432dd983480281344
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 olddefconfig
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303091544.WIDavyIo-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/linux/bits.h:6,
                    from include/linux/bitops.h:6,
                    from include/linux/kernel.h:22,
                    from io_uring/net.c:2:
   include/vdso/bits.h:7:40: warning: left shift count >= width of type [-Wshift-count-overflow]
       7 | #define BIT(nr)                 (UL(1) << (nr))
         |                                        ^~
   include/linux/io_uring_types.h:475:35: note: in expansion of macro 'BIT'
     475 |         REQ_F_FUSED_SLAVE       = BIT(REQ_F_FUSED_SLAVE_BIT),
         |                                   ^~~
   io_uring/net.c: In function 'io_send':
>> io_uring/net.c:385:48: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     385 |                 ret = io_import_kbuf_for_slave((u64)sr->buf, sr->len,
         |                                                ^
   io_uring/net.c: In function 'io_recv':
   io_uring/net.c:880:48: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     880 |                 ret = io_import_kbuf_for_slave((u64)sr->buf, sr->len, ITER_DEST,
         |                                                ^
   io_uring/net.c: In function 'io_send_zc':
   io_uring/net.c:1135:48: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
    1135 |                 ret = io_import_kbuf_for_slave((u64)zc->buf, zc->len,
         |                                                ^


vim +385 io_uring/net.c

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
