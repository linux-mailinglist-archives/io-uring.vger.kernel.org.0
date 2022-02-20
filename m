Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E48994BD21F
	for <lists+io-uring@lfdr.de>; Sun, 20 Feb 2022 22:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232539AbiBTVyT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Feb 2022 16:54:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239908AbiBTVyT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Feb 2022 16:54:19 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B32945041;
        Sun, 20 Feb 2022 13:53:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645394037; x=1676930037;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=iuiiWenYt67holwnVQv8zJaXPdKgdUwKtgkBSh02yFM=;
  b=U5eTcsXc8BCNhC6w/bMD7EjW6IxVJaBUZ3agc1T/2dJTmjzejCCA4g4r
   EDgYmJ84pcLySeztrR/ib+a5hlPTseWkU0l1uAYD3a+VMIa9HEfz524LN
   Q4X6IxBUv++SPfkE+GsgOXt0/qEpm+aUhLIJTWWQbh4hguLlrYsqrW7Az
   fXOuXSgIiyB2CNf/v4ozoHqa17R6MsxZIqio7T+JaX/qFqYqtR3uu8x7b
   0edENUb91rxuhVI1gkHgnoowGiDDY5pjG0/xtYhxjqBgXakqchg/pFT9P
   jXDpq4NMmkAHHp1KYeVrY1XdybxWDfjs9Y0kYqCSxAorFP45MqutGNzsH
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10264"; a="251587441"
X-IronPort-AV: E=Sophos;i="5.88,384,1635231600"; 
   d="scan'208";a="251587441"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2022 13:53:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,384,1635231600"; 
   d="scan'208";a="507416709"
Received: from lkp-server01.sh.intel.com (HELO da3212ac2f54) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 20 Feb 2022 13:53:54 -0800
Received: from kbuild by da3212ac2f54 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nLu9R-0000tb-VA; Sun, 20 Feb 2022 21:53:53 +0000
Date:   Mon, 21 Feb 2022 05:53:47 +0800
From:   kernel test robot <lkp@intel.com>
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     kbuild-all@lists.01.org, Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <haoxu@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] io_uring: Add support for napi_busy_poll
Message-ID: <202202210559.9VjKAZdv-lkp@intel.com>
References: <d11e31bd59c75b2cce994dd90a07e769d4e039db.1645257310.git.olivier@trillion01.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d11e31bd59c75b2cce994dd90a07e769d4e039db.1645257310.git.olivier@trillion01.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Olivier,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v5.17-rc4]
[cannot apply to next-20220217]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Olivier-Langlois/io_uring-Add-support-for-napi_busy_poll/20220220-190634
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 4f12b742eb2b3a850ac8be7dc4ed52976fc6cb0b
config: nds32-allnoconfig (https://download.01.org/0day-ci/archive/20220221/202202210559.9VjKAZdv-lkp@intel.com/config)
compiler: nds32le-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/ad36ae938f354b0cd3b38716572385f710accdb0
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Olivier-Langlois/io_uring-Add-support-for-napi_busy_poll/20220220-190634
        git checkout ad36ae938f354b0cd3b38716572385f710accdb0
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=nds32 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   fs/io_uring.c: In function 'io_ring_ctx_alloc':
>> fs/io_uring.c:1472:28: error: 'struct io_ring_ctx' has no member named 'napi_list'
    1472 |         INIT_LIST_HEAD(&ctx->napi_list);
         |                            ^~
   fs/io_uring.c: In function '__io_submit_flush_completions':
   fs/io_uring.c:2529:40: warning: variable 'prev' set but not used [-Wunused-but-set-variable]
    2529 |         struct io_wq_work_node *node, *prev;
         |                                        ^~~~


vim +1472 fs/io_uring.c

  1413	
  1414	static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
  1415	{
  1416		struct io_ring_ctx *ctx;
  1417		int hash_bits;
  1418	
  1419		ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
  1420		if (!ctx)
  1421			return NULL;
  1422	
  1423		/*
  1424		 * Use 5 bits less than the max cq entries, that should give us around
  1425		 * 32 entries per hash list if totally full and uniformly spread.
  1426		 */
  1427		hash_bits = ilog2(p->cq_entries);
  1428		hash_bits -= 5;
  1429		if (hash_bits <= 0)
  1430			hash_bits = 1;
  1431		ctx->cancel_hash_bits = hash_bits;
  1432		ctx->cancel_hash = kmalloc((1U << hash_bits) * sizeof(struct hlist_head),
  1433						GFP_KERNEL);
  1434		if (!ctx->cancel_hash)
  1435			goto err;
  1436		__hash_init(ctx->cancel_hash, 1U << hash_bits);
  1437	
  1438		ctx->dummy_ubuf = kzalloc(sizeof(*ctx->dummy_ubuf), GFP_KERNEL);
  1439		if (!ctx->dummy_ubuf)
  1440			goto err;
  1441		/* set invalid range, so io_import_fixed() fails meeting it */
  1442		ctx->dummy_ubuf->ubuf = -1UL;
  1443	
  1444		if (percpu_ref_init(&ctx->refs, io_ring_ctx_ref_free,
  1445				    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL))
  1446			goto err;
  1447	
  1448		ctx->flags = p->flags;
  1449		init_waitqueue_head(&ctx->sqo_sq_wait);
  1450		INIT_LIST_HEAD(&ctx->sqd_list);
  1451		INIT_LIST_HEAD(&ctx->cq_overflow_list);
  1452		init_completion(&ctx->ref_comp);
  1453		xa_init_flags(&ctx->io_buffers, XA_FLAGS_ALLOC1);
  1454		xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
  1455		mutex_init(&ctx->uring_lock);
  1456		init_waitqueue_head(&ctx->cq_wait);
  1457		spin_lock_init(&ctx->completion_lock);
  1458		spin_lock_init(&ctx->timeout_lock);
  1459		INIT_WQ_LIST(&ctx->iopoll_list);
  1460		INIT_LIST_HEAD(&ctx->defer_list);
  1461		INIT_LIST_HEAD(&ctx->timeout_list);
  1462		INIT_LIST_HEAD(&ctx->ltimeout_list);
  1463		spin_lock_init(&ctx->rsrc_ref_lock);
  1464		INIT_LIST_HEAD(&ctx->rsrc_ref_list);
  1465		INIT_DELAYED_WORK(&ctx->rsrc_put_work, io_rsrc_put_work);
  1466		init_llist_head(&ctx->rsrc_put_llist);
  1467		INIT_LIST_HEAD(&ctx->tctx_list);
  1468		ctx->submit_state.free_list.next = NULL;
  1469		INIT_WQ_LIST(&ctx->locked_free_list);
  1470		INIT_DELAYED_WORK(&ctx->fallback_work, io_fallback_req_func);
  1471		INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
> 1472		INIT_LIST_HEAD(&ctx->napi_list);
  1473		return ctx;
  1474	err:
  1475		kfree(ctx->dummy_ubuf);
  1476		kfree(ctx->cancel_hash);
  1477		kfree(ctx);
  1478		return NULL;
  1479	}
  1480	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
