Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78FA9544173
	for <lists+io-uring@lfdr.de>; Thu,  9 Jun 2022 04:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236634AbiFICZW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jun 2022 22:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236796AbiFICZU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jun 2022 22:25:20 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDA1237C33;
        Wed,  8 Jun 2022 19:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654741514; x=1686277514;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YP0GfCR3frVBCVPCzq9Bik9yPPVF+3ipJPZkCGY/04k=;
  b=X0u9mejv2Kj2q4PFOJVPLFglYbRw+ip0ZuPjl2C/UQI80hn1V1EPmfhp
   L7V2jLnFbtCLPGgABCfwrPwnC3dV0ddW3/WClhiEFuIH3jekUuc0ozw7u
   zUcnsdSrgUpdSiy8ybTBtuXJV1C4LIKHYv2u1p8xSh4ActJDs/wrwWdjL
   UQSJny9gze9WwCySY+2vTQ2xbXpx/ifRpjOmifC7JIOLEU3XV5OAQe6SM
   L+ne6e8uuUsZR6yC0fZB2x2TC5GwHRC6VFSHgPqpwgzYj/qcRj87T6fqk
   cu3RnEnIEBCxi57wOPrr0V1Slq5tc3Mh/dzGI3fecBeTJOsysBgzzEW4f
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10372"; a="265909212"
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="265909212"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 19:25:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="566181328"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 08 Jun 2022 19:25:11 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nz7rC-000FLn-UB;
        Thu, 09 Jun 2022 02:25:10 +0000
Date:   Thu, 9 Jun 2022 10:24:47 +0800
From:   kernel test robot <lkp@intel.com>
To:     Hao Xu <hao.xu@linux.dev>, io-uring@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Subject: Re: [PATCH 4/5] io_uring: support nonblock try for splicing from
 pipe to pipe
Message-ID: <202206090959.CEWN5SEB-lkp@intel.com>
References: <20220607080619.513187-5-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220607080619.513187-5-hao.xu@linux.dev>
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Hao,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on d8271bf021438f468dab3cd84fe5279b5bbcead8]

url:    https://github.com/intel-lab-lkp/linux/commits/Hao-Xu/support-nonblock-submission-for-splice-pipe-to-pipe/20220607-161605
base:   d8271bf021438f468dab3cd84fe5279b5bbcead8
config: i386-randconfig-s001 (https://download.01.org/0day-ci/archive/20220609/202206090959.CEWN5SEB-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-1) 11.3.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-26-gb3cf30ba-dirty
        # https://github.com/intel-lab-lkp/linux/commit/96683840c3f19b77a536a259094d24e0cd93ebc0
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Hao-Xu/support-nonblock-submission-for-splice-pipe-to-pipe/20220607-161605
        git checkout 96683840c3f19b77a536a259094d24e0cd93ebc0
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> io_uring/splice.c:91:6: sparse: sparse: symbol 'io_splice_support_nowait' was not declared. Should it be static?

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
