Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8F15B32A9
	for <lists+io-uring@lfdr.de>; Fri,  9 Sep 2022 11:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbiIIJCV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Sep 2022 05:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231714AbiIIJBN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Sep 2022 05:01:13 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C807F2EF3D;
        Fri,  9 Sep 2022 02:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662714070; x=1694250070;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5EfSaT6CA7O3ibItsXtQNbp51h72/TK2+889SmrkfPk=;
  b=KoJ5o6OcbR1cURHjvEBjQ+9oeJ6HJUZXpFbdUlZkOxeI1aJ5+eckb1tR
   /iWUC4pY4Jx4lXdv2JA/+xI/XF4QOgI3jTVLY8pZ/ZQcYp0tOiazDNTYG
   QDBWpiz7Ik9AyPg7veDOWqYqnI6ylevM3laM1EQUUJIs22ftmNi/W/leb
   OF4viaNvUxdFxYHG5rQcA4esP+It/e8+C7arj1OOzHn926qHvE6YSzRxt
   z8fkyfkOZ87PER+Prbu8cEnfVrEuWT1SJ3396AaBIfjZgKmOnsRIwSCqn
   j8AxwyR/oG2aTFsPn3kkRPuyb/mGOoE9DAifSin0VhXKRrzUVWmH0KEBL
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="280456434"
X-IronPort-AV: E=Sophos;i="5.93,302,1654585200"; 
   d="scan'208";a="280456434"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 02:01:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,302,1654585200"; 
   d="scan'208";a="648375395"
Received: from lkp-server02.sh.intel.com (HELO b2938d2e5c5a) ([10.239.97.151])
  by orsmga001.jf.intel.com with ESMTP; 09 Sep 2022 02:01:02 -0700
Received: from kbuild by b2938d2e5c5a with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oWZsk-0000xP-0o;
        Fri, 09 Sep 2022 09:01:02 +0000
Date:   Fri, 9 Sep 2022 17:00:36 +0800
From:   kernel test robot <lkp@intel.com>
To:     "Alexander V. Buev" <a.buev@yadro.com>, linux-block@vger.kernel.org
Cc:     kbuild-all@lists.01.org, io-uring@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Mikhail Malygin <m.malygin@yadro.com>, linux@yadro.com,
        "Alexander V. Buev" <a.buev@yadro.com>
Subject: Re: [PATCH v3 2/3] block: io-uring: add READV_PI/WRITEV_PI operations
Message-ID: <202209091641.ayJsNmnv-lkp@intel.com>
References: <20220909063257.1072450-3-a.buev@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909063257.1072450-3-a.buev@yadro.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Alexander,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on axboe-block/for-next]
[also build test WARNING on linus/master v6.0-rc4 next-20220908]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Alexander-V-Buev/implement-direct-IO-with-integrity/20220909-143807
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
config: um-i386_defconfig (https://download.01.org/0day-ci/archive/20220909/202209091641.ayJsNmnv-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-5) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/eda3c42ce63fd33731304cc2ec9a8e1704270690
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Alexander-V-Buev/implement-direct-IO-with-integrity/20220909-143807
        git checkout eda3c42ce63fd33731304cc2ec9a8e1704270690
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=um SUBARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   io_uring/rw_pi.c:181:5: warning: no previous prototype for 'kiocb_done' [-Wmissing-prototypes]
     181 | int kiocb_done(struct io_kiocb *req, ssize_t ret,
         |     ^~~~~~~~~~
   io_uring/rw_pi.c: In function 'io_import_iovecs_pi':
>> io_uring/rw_pi.c:266:16: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
     266 |         uvec = (struct iovec *)rw->addr;
         |                ^


vim +266 io_uring/rw_pi.c

   255	
   256	
   257	static inline int
   258	io_import_iovecs_pi(int io_dir, struct io_kiocb *req, struct iovec **iovec,
   259				struct io_rw_state *s_data, struct __io_rw_pi_state *s_pi)
   260	{
   261		struct io_rw_pi *rw = io_kiocb_to_cmd(req, struct io_rw_pi);
   262		struct iovec __user *uvec;
   263		ssize_t ret;
   264	
   265		/* data */
 > 266		uvec = (struct iovec *)rw->addr;
   267		iovec[DATA] = s_data->fast_iov;
   268		ret = __import_iovec(io_dir, uvec, rw->nr_segs,
   269					UIO_FASTIOV, iovec + DATA,
   270					&s_data->iter, req->ctx->compat);
   271	
   272		if (unlikely(ret <= 0))
   273			return (ret) ? ret : -EINVAL;
   274		/* pi */
   275		uvec = (struct iovec *)rw->kiocb.private;
   276		iovec[PI] = s_pi->fast_iov;
   277		ret = __import_iovec(io_dir, uvec, rw->nr_pi_segs,
   278					UIO_FASTIOV_PI, iovec + PI,
   279					&s_pi->iter, req->ctx->compat);
   280		if (unlikely(ret <= 0)) {
   281			if (iovec[DATA])
   282				kfree(iovec[DATA]);
   283			return (ret) ? ret : -EINVAL;
   284		}
   285	
   286		/* save states */
   287		io_rw_pi_state_iter_save(s_data, s_pi);
   288	
   289		return 0;
   290	}
   291	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
