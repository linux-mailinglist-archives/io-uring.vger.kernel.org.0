Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F368775A90
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 13:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233216AbjHILJf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 07:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233214AbjHILJe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 07:09:34 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F9C10F3;
        Wed,  9 Aug 2023 04:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691579374; x=1723115374;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Y/Oqi7kJ/0eaV+Zo9BP0T3NPTyRyjUXPNOygyZXvNwI=;
  b=nKYY1nz42OmSvIjjj+hnVdX5DM8XrAWymX/WgxZnYnk1mTpNHoT8lfps
   ChbVp0mJnGl3cBwY0ezehPb8wU014QaZxLgc53PhJRLzYs9l5Hf4kMZDV
   GaEXIi4XmLzsxFflqRl2hZcWpXLie5lO+ESKph6OokhwdZZhZuwNQvAIP
   Q+4ZXQ7YM6PDOPffnglVgmxudDoLSi1t2lKpqGy96o33Sn1QmslHpvXBf
   gye7uxN6CrCeera1sW6W/U1FAl91GTVC2EcBSBmJbXhGoKwiAL9jfvmQe
   dOAsUGwQScnrbZaGyAIRvqppjfqrONaEQJjqCYbSE7VWkuTyLMAn7X59l
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="434979692"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="434979692"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2023 04:09:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="875201554"
Received: from lkp-server01.sh.intel.com (HELO d1ccc7e87e8f) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 09 Aug 2023 04:09:33 -0700
Received: from kbuild by d1ccc7e87e8f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qTh4D-00063k-2z;
        Wed, 09 Aug 2023 11:09:29 +0000
Date:   Wed, 9 Aug 2023 19:09:16 +0800
From:   kernel test robot <lkp@intel.com>
To:     Breno Leitao <leitao@debian.org>, sdf@google.com, axboe@kernel.dk,
        asml.silence@gmail.com, willemdebruijn.kernel@gmail.com
Cc:     oe-kbuild-all@lists.linux.dev, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        io-uring@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH v2 3/8] io_uring/cmd: Introduce SOCKET_URING_OP_SETSOCKOPT
Message-ID: <202308091848.hWtNtas3-lkp@intel.com>
References: <20230808134049.1407498-4-leitao@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230808134049.1407498-4-leitao@debian.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
patch link:    https://lore.kernel.org/r/20230808134049.1407498-4-leitao%40debian.org
patch subject: [PATCH v2 3/8] io_uring/cmd: Introduce SOCKET_URING_OP_SETSOCKOPT
config: m68k-randconfig-r036-20230809 (https://download.01.org/0day-ci/archive/20230809/202308091848.hWtNtas3-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 12.3.0
reproduce: (https://download.01.org/0day-ci/archive/20230809/202308091848.hWtNtas3-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202308091848.hWtNtas3-lkp@intel.com/

All errors (new ones prefixed by >>):

   m68k-linux-ld: io_uring/uring_cmd.o: in function `io_uring_cmd_sock':
   io_uring/uring_cmd.c:183: undefined reference to `sk_getsockopt'
>> m68k-linux-ld: io_uring/uring_cmd.c:210: undefined reference to `sock_setsockopt'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
