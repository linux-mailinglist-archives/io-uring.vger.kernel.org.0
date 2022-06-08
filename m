Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C38054325A
	for <lists+io-uring@lfdr.de>; Wed,  8 Jun 2022 16:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241170AbiFHOSk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jun 2022 10:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241166AbiFHOSj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jun 2022 10:18:39 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A6365D21;
        Wed,  8 Jun 2022 07:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654697918; x=1686233918;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=N8RRxR3D8dumuwBq3CnD0xuB5dnkYBY30V4U88YR70s=;
  b=ee1pydQDQZOZrtXrGd70L+f04Uv7PEhqTExwy+UR9PU9NTd3o9HP9pwp
   F056peQ8xlH/4CqYIwgxUo46QsfM+ruqTsSj31jrnUV80PjG1bi2f7cS0
   vUwIOu/JpWYVMLMvxtLbCdu03nsI3h9ZC1C2+r8Z9HVDRq+gmq+SZjh+C
   r7B8PztU3f/75Xu2mLZXoCIjrEOnAoE+GRoptXkQyE6KSvsTTrCsxKv0e
   JDWQ1zkmEJLuyAqsRGA6eGK8r4ozyPuSBKkGRWKc74QabBVFkVCOOVWpb
   vSYPypw5KIO//K6x0omSaT4UlnNdcrkp20cT5GXX+o4KoEek33rx/e2Lz
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="302270880"
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="302270880"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 07:18:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="584915911"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 08 Jun 2022 07:18:35 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nywW2-000Eh3-Hh;
        Wed, 08 Jun 2022 14:18:34 +0000
Date:   Wed, 8 Jun 2022 22:18:32 +0800
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
Message-ID: <202206082229.xoMAgqIw-lkp@intel.com>
References: <20220607080619.513187-5-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220607080619.513187-5-hao.xu@linux.dev>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
config: x86_64-defconfig (https://download.01.org/0day-ci/archive/20220608/202206082229.xoMAgqIw-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-1) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/96683840c3f19b77a536a259094d24e0cd93ebc0
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Hao-Xu/support-nonblock-submission-for-splice-pipe-to-pipe/20220607-161605
        git checkout 96683840c3f19b77a536a259094d24e0cd93ebc0
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> io_uring/splice.c:91:6: warning: no previous prototype for 'io_splice_support_nowait' [-Wmissing-prototypes]
      91 | bool io_splice_support_nowait(struct file *in, struct file *out)
         |      ^~~~~~~~~~~~~~~~~~~~~~~~


vim +/io_splice_support_nowait +91 io_uring/splice.c

    90	
  > 91	bool io_splice_support_nowait(struct file *in, struct file *out)
    92	{
    93		if (get_pipe_info(in, true) && get_pipe_info(out, true))
    94			return true;
    95	
    96		return false;
    97	}
    98	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
