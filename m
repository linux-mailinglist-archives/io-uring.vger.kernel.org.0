Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBA1F5B329C
	for <lists+io-uring@lfdr.de>; Fri,  9 Sep 2022 11:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbiIIJCB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Sep 2022 05:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbiIIJBK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Sep 2022 05:01:10 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5DBC9BB69;
        Fri,  9 Sep 2022 02:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662714066; x=1694250066;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MrByRSTypJUP62/kimyr5ja73Ms8BpZ/4lwOy+iwPk8=;
  b=lLv+dUG5m0IA+Qnq4yH+BEiEWkw2iTWEdWaF3OZ8OyQU3SZAP/ADSxpp
   li0m5XBI+JK7AP6XGGSB4D22E/2+wl4dvHW1d/GixncDuaU+GtF5V7m1a
   kS0+JnqqBgn1w4RTW9sjpB4rcOjiopTmE3wouIptLVbLFbZUWZibiZHPe
   M/CXOvcX7QZ1Rhay1kBd5MXDDIOn4C7VbzKWyQprb3CrR00BPPrTriYpI
   /hggDFoEurpkNw7axnrH7ubNH492IiAL/gY5+jMKqtcd7pBx2HJwiw/Id
   5SiCP8azUqkOIzrdlc9KCona7B/lMQmLs19O745YYShC97b0c07CkR6B8
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="280456435"
X-IronPort-AV: E=Sophos;i="5.93,302,1654585200"; 
   d="scan'208";a="280456435"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 02:01:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,302,1654585200"; 
   d="scan'208";a="648375394"
Received: from lkp-server02.sh.intel.com (HELO b2938d2e5c5a) ([10.239.97.151])
  by orsmga001.jf.intel.com with ESMTP; 09 Sep 2022 02:01:02 -0700
Received: from kbuild by b2938d2e5c5a with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oWZsk-0000xN-0l;
        Fri, 09 Sep 2022 09:01:02 +0000
Date:   Fri, 9 Sep 2022 17:00:37 +0800
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
Message-ID: <202209091631.jlGYR8Lf-lkp@intel.com>
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
config: um-x86_64_defconfig (https://download.01.org/0day-ci/archive/20220909/202209091631.jlGYR8Lf-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-5) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/eda3c42ce63fd33731304cc2ec9a8e1704270690
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Alexander-V-Buev/implement-direct-IO-with-integrity/20220909-143807
        git checkout eda3c42ce63fd33731304cc2ec9a8e1704270690
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=um SUBARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> io_uring/rw_pi.c:181:5: warning: no previous prototype for 'kiocb_done' [-Wmissing-prototypes]
     181 | int kiocb_done(struct io_kiocb *req, ssize_t ret,
         |     ^~~~~~~~~~


vim +/kiocb_done +181 io_uring/rw_pi.c

   180	
 > 181	int kiocb_done(struct io_kiocb *req, ssize_t ret,
   182			       unsigned int issue_flags)
   183	{
   184		struct io_async_rw_pi *arw = req->async_data;
   185		struct io_rw_pi *rw = io_kiocb_to_cmd(req, struct io_rw_pi);
   186	
   187		/* add previously done IO, if any */
   188		if (req_has_async_data(req) && arw->data.bytes_done > 0) {
   189			if (ret < 0)
   190				ret = arw->data.bytes_done;
   191			else
   192				ret += arw->data.bytes_done;
   193		}
   194	
   195		if (req->flags & REQ_F_CUR_POS)
   196			req->file->f_pos = rw->kiocb.ki_pos;
   197		if (ret >= 0 && (rw->kiocb.ki_complete == io_complete_rw)) {
   198			if (!__io_complete_rw_common(req, ret)) {
   199				io_req_set_res(req, req->cqe.res, 0);
   200				return IOU_OK;
   201			}
   202		} else {
   203			io_rw_done(&rw->kiocb, ret);
   204		}
   205	
   206		if (req->flags & REQ_F_REISSUE) {
   207			req->flags &= ~REQ_F_REISSUE;
   208			if (io_resubmit_prep(req))
   209				io_req_task_queue_reissue(req);
   210			else
   211				io_req_task_queue_fail(req, ret);
   212		}
   213		return IOU_ISSUE_SKIP_COMPLETE;
   214	}
   215	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
