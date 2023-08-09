Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D83E77570F
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 12:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbjHIK2h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 06:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbjHIK2g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 06:28:36 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 944271FE2;
        Wed,  9 Aug 2023 03:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691576912; x=1723112912;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PFuPyijB9xKozuDgb+d7nAiprMwBmljDI2nu1pstTcY=;
  b=XGhtMBC7lbfNOlhiynFoapYhtWQk8VoS9nxFfEIsXeIcjImOBVWeDWB0
   wm7v4l38JEny50v8l+scJgi90/4RkHUYh50ouvEdtdhQnWrfuZbBCqPz2
   HTTus61JyI2xRBg627zPv7IrsdzQw524ltzeh8dWvHCqP48sbZvZLzK+K
   9PjmiOVYV46/YozNkfoRlvZFHA6Eh0AC8ROVzjS8vR2zP1OznhDfOn+WO
   b1K4pGUsrNmPd1YoXnYy7oKprKJv3ca6z8RHKGcNoEYpgLmUe5Jd8ExTN
   5QoMUq3/9/Z1xZhdrWcuWVITkMD9TxPVW5kEziBqaRm3krffMS8YSwvbN
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="373867964"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="373867964"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2023 03:28:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="875188411"
Received: from lkp-server01.sh.intel.com (HELO d1ccc7e87e8f) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 09 Aug 2023 03:28:32 -0700
Received: from kbuild by d1ccc7e87e8f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qTgQW-00060k-1Z;
        Wed, 09 Aug 2023 10:28:28 +0000
Date:   Wed, 9 Aug 2023 18:27:48 +0800
From:   kernel test robot <lkp@intel.com>
To:     Breno Leitao <leitao@debian.org>, sdf@google.com, axboe@kernel.dk,
        asml.silence@gmail.com, willemdebruijn.kernel@gmail.com
Cc:     oe-kbuild-all@lists.linux.dev, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        io-uring@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH v2 2/8] io_uring/cmd: Introduce SOCKET_URING_OP_GETSOCKOPT
Message-ID: <202308091701.sGyLMOi2-lkp@intel.com>
References: <20230808134049.1407498-3-leitao@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230808134049.1407498-3-leitao@debian.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Breno,

kernel test robot noticed the following build errors:

[auto build test ERROR on next-20230808]
[cannot apply to bpf-next/master bpf/master net/main net-next/main linus/master horms-ipvs/master v6.5-rc5 v6.5-rc4 v6.5-rc3 v6.5-rc5]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Breno-Leitao/net-expose-sock_use_custom_sol_socket/20230809-011901
base:   next-20230808
patch link:    https://lore.kernel.org/r/20230808134049.1407498-3-leitao%40debian.org
patch subject: [PATCH v2 2/8] io_uring/cmd: Introduce SOCKET_URING_OP_GETSOCKOPT
config: m68k-randconfig-r036-20230809 (https://download.01.org/0day-ci/archive/20230809/202308091701.sGyLMOi2-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 12.3.0
reproduce: (https://download.01.org/0day-ci/archive/20230809/202308091701.sGyLMOi2-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202308091701.sGyLMOi2-lkp@intel.com/

All errors (new ones prefixed by >>):

   m68k-linux-ld: io_uring/uring_cmd.o: in function `io_uring_cmd_sock':
>> io_uring/uring_cmd.c:183: undefined reference to `sk_getsockopt'


vim +183 io_uring/uring_cmd.c

   168	
   169	static inline int io_uring_cmd_getsockopt(struct socket *sock,
   170						  struct io_uring_cmd *cmd)
   171	{
   172		void __user *optval = u64_to_user_ptr(READ_ONCE(cmd->sqe->optval));
   173		int optname = READ_ONCE(cmd->sqe->optname);
   174		int optlen = READ_ONCE(cmd->sqe->optlen);
   175		int level = READ_ONCE(cmd->sqe->level);
   176		int err;
   177	
   178		err = security_socket_getsockopt(sock, level, optname);
   179		if (err)
   180			return err;
   181	
   182		if (level == SOL_SOCKET) {
 > 183			err = sk_getsockopt(sock->sk, level, optname,
   184					    USER_SOCKPTR(optval),
   185					    KERNEL_SOCKPTR(&optlen));
   186			if (err)
   187				return err;
   188	
   189			return optlen;
   190		}
   191	
   192		return -EOPNOTSUPP;
   193	}
   194	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
