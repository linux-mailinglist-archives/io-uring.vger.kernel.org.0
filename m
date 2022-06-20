Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE2B5550E33
	for <lists+io-uring@lfdr.de>; Mon, 20 Jun 2022 02:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238799AbiFTAyY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Jun 2022 20:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238037AbiFTAyX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Jun 2022 20:54:23 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7795E6563;
        Sun, 19 Jun 2022 17:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655686459; x=1687222459;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wBwCFUA6Q64fHaprgGzpO55tKWN6E6OjOh5MnrN96K8=;
  b=nQHQEvacjc8Wbz7/mrAmFFH9U0T1fmWgNgDyBrtuK0qOHZIihGeVYx8S
   5RxjIAb4GNRUkOxY5W2SPnnwvdQvHnNKMNIhjxBJsCGI3Ed++tMrwa288
   bMNkRrHYpXBBfFAC2vZmi6FILg5XSURwTstjFMMRdIM0z3qWN8iRNcDR+
   nrRz+SgJzZAHFH5p4ICxVojRy59Kqkwjk7haaUOdlUweqsVSnxs8/yC2U
   FtevTcQ0G+qQ62wSYJm7+WwsgrxYpVb8B93VbQLvhtoy8MHZlDPjnwWuA
   VEWzIGMeGw37QTFRylYgZD8obHeCVgqsShu4SSAVS5I8HCSSzu2IoXL+3
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="262810907"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="262810907"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2022 17:54:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="832871961"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 19 Jun 2022 17:54:16 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o35gF-000Riq-FN;
        Mon, 20 Jun 2022 00:54:15 +0000
Date:   Mon, 20 Jun 2022 08:53:15 +0800
From:   kernel test robot <lkp@intel.com>
To:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        kernel-team@fb.com, linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, shr@fb.com, david@fromorbit.com,
        jack@suse.cz, hch@infradead.org, axboe@kernel.dk,
        willy@infradead.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v9 03/14] mm: Add balance_dirty_pages_ratelimited_flags()
 function
Message-ID: <202206200844.loRI4cvL-lkp@intel.com>
References: <20220616212221.2024518-4-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220616212221.2024518-4-shr@fb.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Stefan,

I love your patch! Perhaps something to improve:

[auto build test WARNING on b13baccc3850ca8b8cccbf8ed9912dbaa0fdf7f3]

url:    https://github.com/intel-lab-lkp/linux/commits/Stefan-Roesch/io-uring-xfs-support-async-buffered-writes/20220617-060910
base:   b13baccc3850ca8b8cccbf8ed9912dbaa0fdf7f3
config: i386-randconfig-c021 (https://download.01.org/0day-ci/archive/20220620/202206200844.loRI4cvL-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>


cocci warnings: (new ones prefixed by >>)
>> mm/page-writeback.c:1887:5-8: Unneeded variable: "ret". Return "0" on line 1891

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
