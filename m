Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5E7F4B5E3D
	for <lists+io-uring@lfdr.de>; Tue, 15 Feb 2022 00:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbiBNX2d (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Feb 2022 18:28:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232136AbiBNX2d (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Feb 2022 18:28:33 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE21013C9F3;
        Mon, 14 Feb 2022 15:28:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644881304; x=1676417304;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=W5UIWR8IMeyiFdF3gjE6OW8Sj3dciI4kypY/RklK8Aw=;
  b=eu9y2CXkIQpD+I1WI4cmR9QQ3dOu4o+6AGRpt1egt8Aj3WvW+NW9Cr8L
   tHvxbKxall0TRKbZCr9QTeQeaXyXJnBYsRarlhRgqWbE09ssgLFHtRoui
   +ZTktBt9XiMxsYhEcpsjcQz48L7ho40J7bDVCBY+LmqbPMJu49OMPNWy4
   63w+Od5ELSjiBUqHMnfKmxBjyFbajH39TZryx7nYk5Pr19raQR3RK+sQL
   qwklrM+KwERgF3vzOcOWRvUwZEs26tW0/ju1OcSQzzA6WOKmlTw5nxb6T
   wpOB8wXBS7GfbzN/UHLW0QkVYwAR/CNOZ80RiIFrHge8JvKpI7BygwI+o
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10258"; a="247801910"
X-IronPort-AV: E=Sophos;i="5.88,368,1635231600"; 
   d="scan'208";a="247801910"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 15:28:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,368,1635231600"; 
   d="scan'208";a="603507168"
Received: from lkp-server01.sh.intel.com (HELO d95dc2dabeb1) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 14 Feb 2022 15:28:22 -0800
Received: from kbuild by d95dc2dabeb1 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nJklZ-00091z-Tr; Mon, 14 Feb 2022 23:28:21 +0000
Date:   Tue, 15 Feb 2022 07:27:25 +0800
From:   kernel test robot <lkp@intel.com>
To:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        kernel-team@fb.com
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, shr@fb.com
Subject: Re: [PATCH v1 05/14] fs: split off __alloc_page_buffers function
Message-ID: <202202150743.R5ymlf5z-lkp@intel.com>
References: <20220214174403.4147994-6-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214174403.4147994-6-shr@fb.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
config: arm-s5pv210_defconfig (https://download.01.org/0day-ci/archive/20220215/202202150743.R5ymlf5z-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project ea071884b0cc7210b3cc5fe858f0e892a779a23b)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm cross compiling tool for clang build
        # apt-get install binutils-arm-linux-gnueabi
        # https://github.com/0day-ci/linux/commit/e8b24c1ab111c127cbe1daaac3b607c626fb03a8
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Stefan-Roesch/Support-sync-buffered-writes-for-io-uring/20220215-014908
        git checkout e8b24c1ab111c127cbe1daaac3b607c626fb03a8
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> fs/buffer.c:805:21: warning: no previous prototype for function '__alloc_page_buffers' [-Wmissing-prototypes]
   struct buffer_head *__alloc_page_buffers(struct page *page, unsigned long size,
                       ^
   fs/buffer.c:805:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   struct buffer_head *__alloc_page_buffers(struct page *page, unsigned long size,
   ^
   static 
   1 warning generated.


vim +/__alloc_page_buffers +805 fs/buffer.c

   804	
 > 805	struct buffer_head *__alloc_page_buffers(struct page *page, unsigned long size,
   806			gfp_t gfp)
   807	{
   808		struct buffer_head *bh, *head;
   809		long offset;
   810		struct mem_cgroup *memcg, *old_memcg;
   811	
   812		/* The page lock pins the memcg */
   813		memcg = page_memcg(page);
   814		old_memcg = set_active_memcg(memcg);
   815	
   816		head = NULL;
   817		offset = PAGE_SIZE;
   818		while ((offset -= size) >= 0) {
   819			bh = alloc_buffer_head(gfp);
   820			if (!bh)
   821				goto no_grow;
   822	
   823			bh->b_this_page = head;
   824			bh->b_blocknr = -1;
   825			head = bh;
   826	
   827			bh->b_size = size;
   828	
   829			/* Link the buffer to its page */
   830			set_bh_page(bh, page, offset);
   831		}
   832	out:
   833		set_active_memcg(old_memcg);
   834		return head;
   835	/*
   836	 * In case anything failed, we just free everything we got.
   837	 */
   838	no_grow:
   839		if (head) {
   840			do {
   841				bh = head;
   842				head = head->b_this_page;
   843				free_buffer_head(bh);
   844			} while (head);
   845		}
   846	
   847		goto out;
   848	}
   849	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
