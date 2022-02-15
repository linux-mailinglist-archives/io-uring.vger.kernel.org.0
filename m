Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 587BD4B6126
	for <lists+io-uring@lfdr.de>; Tue, 15 Feb 2022 03:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233715AbiBOCml (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Feb 2022 21:42:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233669AbiBOCmk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Feb 2022 21:42:40 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82104111DC3;
        Mon, 14 Feb 2022 18:42:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644892951; x=1676428951;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ymUxp0XdwB1tSymGwsMVGCDGKJ7qTLE+FJH01P7W150=;
  b=KJAv0J+KAUd1KZ0201BS1bvTymtZYvxxnMsY1LsyYb0DFSMi/ukfAPZa
   G8OsHUkEhR/IT4trBxjx2wMluZ37cC4KlgnsOy42Ewqo6Z/mCs1MB7a2Q
   WvNEFyl4T5UR3vHxrU/QYScXuGs4cyRDlyIXgnzunG7InLvl81t+TZgIU
   d+3ZBmxhTUQtRnVLCVH6gYga7BZpAnkDBOvddFrQnSK42He0xX2nUpGgE
   Gr1JUzSWmjanGI0KNpZ5N9nMnkrrjq1nPCL2TntsWVCfu6ssaPbhOJrzI
   G6hwzsKVsO4CO7ZtDFEFI13id2eiI6i9oWBqRq1Xhffhni0Kvl/oOSTMf
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10258"; a="313507870"
X-IronPort-AV: E=Sophos;i="5.88,369,1635231600"; 
   d="scan'208";a="313507870"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 18:42:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,369,1635231600"; 
   d="scan'208";a="775564613"
Received: from lkp-server01.sh.intel.com (HELO d95dc2dabeb1) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 14 Feb 2022 18:42:29 -0800
Received: from kbuild by d95dc2dabeb1 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nJnnQ-0009C6-P1; Tue, 15 Feb 2022 02:42:28 +0000
Date:   Tue, 15 Feb 2022 10:41:47 +0800
From:   kernel test robot <lkp@intel.com>
To:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        kernel-team@fb.com
Cc:     kbuild-all@lists.01.org, shr@fb.com
Subject: Re: [PATCH v1 05/14] fs: split off __alloc_page_buffers function
Message-ID: <202202151030.Z3rVrN17-lkp@intel.com>
References: <20220214174403.4147994-6-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214174403.4147994-6-shr@fb.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Stefan,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on f1baf68e1383f6ed93eb9cff2866d46562607a43]

url:    https://github.com/0day-ci/linux/commits/Stefan-Roesch/Support-sync-buffered-writes-for-io-uring/20220215-014908
base:   f1baf68e1383f6ed93eb9cff2866d46562607a43
config: i386-randconfig-s002-20220214 (https://download.01.org/0day-ci/archive/20220215/202202151030.Z3rVrN17-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/0day-ci/linux/commit/e8b24c1ab111c127cbe1daaac3b607c626fb03a8
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Stefan-Roesch/Support-sync-buffered-writes-for-io-uring/20220215-014908
        git checkout e8b24c1ab111c127cbe1daaac3b607c626fb03a8
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> fs/buffer.c:805:20: sparse: sparse: symbol '__alloc_page_buffers' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
