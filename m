Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7D56B218B
	for <lists+io-uring@lfdr.de>; Thu,  9 Mar 2023 11:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbjCIKfW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Mar 2023 05:35:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbjCIKfU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Mar 2023 05:35:20 -0500
Received: from mail2-relais-roc.national.inria.fr (mail2-relais-roc.national.inria.fr [192.134.164.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B549DDB48C;
        Thu,  9 Mar 2023 02:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=jB9MPIQW9EXAFPQ7RbmYegOPcdJp+A1GBktU3yA6KpE=;
  b=jvxWP0h1EHCWcyZcc5oi3wM8kbz3ihehKSgaEm5y3sWVHmWn/t5bwNFe
   FC+xJgDBtRFvS+LBnO+FCwcHrkNoknIjbqQCYB5sBedDQUzxAyfz0C0Io
   qFDy5tLKLtdUn/NQpwAmc/srKEoQC6xGOSXF/Fcsk9T30EJXx3owcikxP
   A=;
Authentication-Results: mail2-relais-roc.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=julia.lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.98,246,1673910000"; 
   d="scan'208";a="96274942"
Received: from dt-lawall.paris.inria.fr ([128.93.67.65])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2023 11:35:15 +0100
Date:   Thu, 9 Mar 2023 11:35:15 +0100 (CET)
From:   Julia Lawall <julia.lawall@inria.fr>
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
cc:     linux-block@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V2 17/17] block: ublk_drv: apply io_uring FUSED_CMD for
 supporting zero copy (fwd)
Message-ID: <2dbb69e-cdb-80b8-fdd3-3e5e8442d70@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



---------- Forwarded message ----------
Date: Thu, 9 Mar 2023 18:32:45 +0800
From: kernel test robot <lkp@intel.com>
To: oe-kbuild@lists.linux.dev
Cc: lkp@intel.com, Julia Lawall <julia.lawall@inria.fr>
Subject: Re: [PATCH V2 17/17] block: ublk_drv: apply io_uring FUSED_CMD for
    supporting zero copy

BCC: lkp@intel.com
CC: oe-kbuild-all@lists.linux.dev
In-Reply-To: <20230307141520.793891-18-ming.lei@redhat.com>
References: <20230307141520.793891-18-ming.lei@redhat.com>
TO: Ming Lei <ming.lei@redhat.com>
TO: Jens Axboe <axboe@kernel.dk>
TO: io-uring@vger.kernel.org
CC: linux-block@vger.kernel.org
CC: Miklos Szeredi <mszeredi@redhat.com>
CC: ZiyangZhang <ZiyangZhang@linux.alibaba.com>
CC: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
CC: Bernd Schubert <bschubert@ddn.com>
CC: Ming Lei <ming.lei@redhat.com>

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
patch link:    https://lore.kernel.org/r/20230307141520.793891-18-ming.lei%40redhat.com
patch subject: [PATCH V2 17/17] block: ublk_drv: apply io_uring FUSED_CMD for supporting zero copy
:::::: branch date: 2 days ago
:::::: commit date: 2 days ago
config: alpha-randconfig-c041-20230308 (https://download.01.org/0day-ci/archive/20230309/202303091820.3ZY3kqmx-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 12.1.0

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Julia Lawall <julia.lawall@inria.fr>
| Link: https://lore.kernel.org/r/202303091820.3ZY3kqmx-lkp@intel.com/

cocci warnings: (new ones prefixed by >>)
>> drivers/block/ublk_drv.c:78:26-29: WARNING use flexible-array member instead (https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
