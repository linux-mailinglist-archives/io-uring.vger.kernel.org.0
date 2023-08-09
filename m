Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E16C7751E0
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 06:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbjHIEUo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 00:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjHIEUn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 00:20:43 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C9B1BC3;
        Tue,  8 Aug 2023 21:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691554842; x=1723090842;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=r7oMnxHSYoVbyUtHi0M6LPujLJLQY6C1FqwGaO8iCt8=;
  b=LVE1pfFDg8DQGr2bdhC/XLX66tYOjOlfxVZbd7hfEZwq+V8XAvJd8Ef6
   DX1fW6YvaKkrjaa6eDrJlX2VkbpljFxGq5pg5CCZ2BsoJXIzL8WbsPmKP
   V1+k6AsT3NAXml1Ult31d1Hkn1ALAct8Xmxo5o4MQ78gDk8xOpImnGJ+R
   zy8EsBww+MByHTfz7zZXCXKdmygP+Uu1So4oUS3kWbDzgsDQZ2ArN5lZC
   LQ/doKP2Kd1lmBEZ7S+wBqJdoqYANl/8sqvK6XtwBWCexaJrbmVWur17p
   25zXgueJAiE3eEjJGTCwfU+db/XEIlomqwros9pzcVsGj882tc9x6nhKM
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="361141854"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="361141854"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2023 21:18:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="725215103"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="725215103"
Received: from lkp-server01.sh.intel.com (HELO d1ccc7e87e8f) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 08 Aug 2023 21:18:22 -0700
Received: from kbuild by d1ccc7e87e8f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qTaeL-0005nk-0u;
        Wed, 09 Aug 2023 04:18:21 +0000
Date:   Wed, 9 Aug 2023 12:17:53 +0800
From:   kernel test robot <lkp@intel.com>
To:     Breno Leitao <leitao@debian.org>, sdf@google.com, axboe@kernel.dk,
        asml.silence@gmail.com, willemdebruijn.kernel@gmail.com
Cc:     oe-kbuild-all@lists.linux.dev, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        io-uring@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH v2 7/8] io_uring/cmd: BPF hook for getsockopt cmd
Message-ID: <202308091149.ltz0y4QZ-lkp@intel.com>
References: <20230808134049.1407498-8-leitao@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230808134049.1407498-8-leitao@debian.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
patch link:    https://lore.kernel.org/r/20230808134049.1407498-8-leitao%40debian.org
patch subject: [PATCH v2 7/8] io_uring/cmd: BPF hook for getsockopt cmd
config: x86_64-randconfig-r012-20230808 (https://download.01.org/0day-ci/archive/20230809/202308091149.ltz0y4QZ-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce: (https://download.01.org/0day-ci/archive/20230809/202308091149.ltz0y4QZ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202308091149.ltz0y4QZ-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/export.h:5,
                    from include/linux/linkage.h:7,
                    from include/linux/kernel.h:17,
                    from io_uring/uring_cmd.c:2:
   io_uring/uring_cmd.c: In function 'io_uring_cmd_getsockopt':
>> include/linux/bpf-cgroup.h:393:41: error: 'tcp_bpf_bypass_getsockopt' undeclared (first use in this function)
     393 |                                         tcp_bpf_bypass_getsockopt,             \
         |                                         ^~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/compiler.h:76:45: note: in definition of macro 'likely'
      76 | # define likely(x)      __builtin_expect(!!(x), 1)
         |                                             ^
   include/linux/indirect_call_wrapper.h:66:42: note: in expansion of macro 'INDIRECT_CALL_1'
      66 | #define INDIRECT_CALL_INET_1(f, f1, ...) INDIRECT_CALL_1(f, f1, __VA_ARGS__)
         |                                          ^~~~~~~~~~~~~~~
   include/linux/bpf-cgroup.h:392:22: note: in expansion of macro 'INDIRECT_CALL_INET_1'
     392 |                     !INDIRECT_CALL_INET_1((sock)->sk_prot->bpf_bypass_getsockopt, \
         |                      ^~~~~~~~~~~~~~~~~~~~
   io_uring/uring_cmd.c:191:23: note: in expansion of macro 'BPF_CGROUP_RUN_PROG_GETSOCKOPT'
     191 |                 err = BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock->sk, level,
         |                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/bpf-cgroup.h:393:41: note: each undeclared identifier is reported only once for each function it appears in
     393 |                                         tcp_bpf_bypass_getsockopt,             \
         |                                         ^~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/compiler.h:76:45: note: in definition of macro 'likely'
      76 | # define likely(x)      __builtin_expect(!!(x), 1)
         |                                             ^
   include/linux/indirect_call_wrapper.h:66:42: note: in expansion of macro 'INDIRECT_CALL_1'
      66 | #define INDIRECT_CALL_INET_1(f, f1, ...) INDIRECT_CALL_1(f, f1, __VA_ARGS__)
         |                                          ^~~~~~~~~~~~~~~
   include/linux/bpf-cgroup.h:392:22: note: in expansion of macro 'INDIRECT_CALL_INET_1'
     392 |                     !INDIRECT_CALL_INET_1((sock)->sk_prot->bpf_bypass_getsockopt, \
         |                      ^~~~~~~~~~~~~~~~~~~~
   io_uring/uring_cmd.c:191:23: note: in expansion of macro 'BPF_CGROUP_RUN_PROG_GETSOCKOPT'
     191 |                 err = BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock->sk, level,
         |                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/net/sock.h:62,
                    from include/linux/bpf-cgroup.h:11,
                    from io_uring/uring_cmd.c:9:
>> include/linux/bpf-cgroup.h:393:41: error: implicit declaration of function 'tcp_bpf_bypass_getsockopt' [-Werror=implicit-function-declaration]
     393 |                                         tcp_bpf_bypass_getsockopt,             \
         |                                         ^~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/indirect_call_wrapper.h:19:35: note: in definition of macro 'INDIRECT_CALL_1'
      19 |                 likely(f == f1) ? f1(__VA_ARGS__) : f(__VA_ARGS__);     \
         |                                   ^~
   include/linux/bpf-cgroup.h:392:22: note: in expansion of macro 'INDIRECT_CALL_INET_1'
     392 |                     !INDIRECT_CALL_INET_1((sock)->sk_prot->bpf_bypass_getsockopt, \
         |                      ^~~~~~~~~~~~~~~~~~~~
   io_uring/uring_cmd.c:191:23: note: in expansion of macro 'BPF_CGROUP_RUN_PROG_GETSOCKOPT'
     191 |                 err = BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock->sk, level,
         |                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   io_uring/uring_cmd.c: In function 'io_uring_cmd_setsockopt':
   io_uring/uring_cmd.c:223:58: error: 'koptval' undeclared (first use in this function); did you mean 'optval'?
     223 |                                             USER_SOCKPTR(koptval), optlen);
         |                                                          ^~~~~~~
         |                                                          optval
   cc1: some warnings being treated as errors


vim +/tcp_bpf_bypass_getsockopt +393 include/linux/bpf-cgroup.h

0d01da6afc5402 Stanislav Fomichev 2019-06-27  384  
0d01da6afc5402 Stanislav Fomichev 2019-06-27  385  #define BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock, level, optname, optval, optlen,   \
0d01da6afc5402 Stanislav Fomichev 2019-06-27  386  				       max_optlen, retval)		       \
0d01da6afc5402 Stanislav Fomichev 2019-06-27  387  ({									       \
0d01da6afc5402 Stanislav Fomichev 2019-06-27  388  	int __ret = retval;						       \
46531a30364bd4 Pavel Begunkov     2022-01-27  389  	if (cgroup_bpf_enabled(CGROUP_GETSOCKOPT) &&			       \
46531a30364bd4 Pavel Begunkov     2022-01-27  390  	    cgroup_bpf_sock_enabled(sock, CGROUP_GETSOCKOPT))		       \
9cacf81f816111 Stanislav Fomichev 2021-01-15  391  		if (!(sock)->sk_prot->bpf_bypass_getsockopt ||		       \
9cacf81f816111 Stanislav Fomichev 2021-01-15  392  		    !INDIRECT_CALL_INET_1((sock)->sk_prot->bpf_bypass_getsockopt, \
9cacf81f816111 Stanislav Fomichev 2021-01-15 @393  					tcp_bpf_bypass_getsockopt,	       \
9cacf81f816111 Stanislav Fomichev 2021-01-15  394  					level, optname))		       \
9cacf81f816111 Stanislav Fomichev 2021-01-15  395  			__ret = __cgroup_bpf_run_filter_getsockopt(	       \
9cacf81f816111 Stanislav Fomichev 2021-01-15  396  				sock, level, optname, optval, optlen,	       \
9cacf81f816111 Stanislav Fomichev 2021-01-15  397  				max_optlen, retval);			       \
9cacf81f816111 Stanislav Fomichev 2021-01-15  398  	__ret;								       \
9cacf81f816111 Stanislav Fomichev 2021-01-15  399  })
9cacf81f816111 Stanislav Fomichev 2021-01-15  400  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
