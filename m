Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1C507D1AB0
	for <lists+io-uring@lfdr.de>; Sat, 21 Oct 2023 05:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjJUDxz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Oct 2023 23:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjJUDxz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Oct 2023 23:53:55 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF552D71;
        Fri, 20 Oct 2023 20:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697860429; x=1729396429;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KSNO7vOH2xYOL/+j22XGMf283vnlJoT1CRb7A5owLFQ=;
  b=g4N7ttHdXeJzMTO2I0rqfYK/WksxOBq5PF4/KIEjvIo4JnZweZXGYUiA
   4XJMPGpFIYqe2YgXyVnqwbkQ9BkWF4tbb4jqETN4v8tD+RGzpuHg6fUob
   szkeiAXsH885xp/t0P4GVhi7lhvS+jCdU7tixSURCEOwDlAjfgr4lfb0P
   T/27u9vRpR4AJsZsNjKC/iuhWzJSnB+oAZu8rcAc8P0x3vRiXrC9pxo3k
   Lu1cMGZNwF4eNUDXbyNDO1NGUY+gAEnaamxUOt9hC4ALpbdP63oLnKhgf
   /8A5bxAMmdCZ/RROYGdQAnhQAhAICDDZEviirpsLNtTYwQpAfqQ58lMMH
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="366836728"
X-IronPort-AV: E=Sophos;i="6.03,239,1694761200"; 
   d="scan'208";a="366836728"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2023 20:53:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="823451798"
X-IronPort-AV: E=Sophos;i="6.03,239,1694761200"; 
   d="scan'208";a="823451798"
Received: from lkp-server01.sh.intel.com (HELO 8917679a5d3e) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 20 Oct 2023 20:53:47 -0700
Received: from kbuild by 8917679a5d3e with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qu33Y-0004Na-2Z;
        Sat, 21 Oct 2023 03:53:44 +0000
Date:   Sat, 21 Oct 2023 11:53:01 +0800
From:   kernel test robot <lkp@intel.com>
To:     Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, io-uring@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, axboe@kernel.dk, hch@lst.de,
        joshi.k@samsung.com, martin.petersen@oracle.com,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 1/4] block: bio-integrity: add support for user buffers
Message-ID: <202310211117.qmDPOVfI-lkp@intel.com>
References: <20231018151843.3542335-2-kbusch@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231018151843.3542335-2-kbusch@meta.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Keith,

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[also build test ERROR on v6.6-rc6 next-20231020]
[cannot apply to axboe-block/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Keith-Busch/block-bio-integrity-add-support-for-user-buffers/20231018-232704
base:   linus/master
patch link:    https://lore.kernel.org/r/20231018151843.3542335-2-kbusch%40meta.com
patch subject: [PATCH 1/4] block: bio-integrity: add support for user buffers
config: um-i386_defconfig (https://download.01.org/0day-ci/archive/20231021/202310211117.qmDPOVfI-lkp@intel.com/config)
compiler: gcc-7 (Ubuntu 7.5.0-6ubuntu2) 7.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231021/202310211117.qmDPOVfI-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202310211117.qmDPOVfI-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/blkdev.h:17:0,
                    from init/main.c:85:
   include/linux/bio.h: In function 'bio_integrity_map_user':
>> include/linux/bio.h:798:1: error: expected ';' before '}' token
    }
    ^
--
   In file included from include/linux/blkdev.h:17:0,
                    from lib/vsprintf.c:47:
   include/linux/bio.h: In function 'bio_integrity_map_user':
>> include/linux/bio.h:798:1: error: expected ';' before '}' token
    }
    ^
   lib/vsprintf.c: In function 'va_format':
   lib/vsprintf.c:1682:2: warning: function 'va_format' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
     buf += vsnprintf(buf, end > buf ? end - buf : 0, va_fmt->fmt, va);
     ^~~


vim +798 include/linux/bio.h

   793	
   794	static inline int bio_integrity_map_user(struct bio *bio, void __user *ubuf,
   795						 unsigned int len, u32 seed, u32 maxvecs)
   796	{
   797		return -EINVAL
 > 798	}
   799	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
