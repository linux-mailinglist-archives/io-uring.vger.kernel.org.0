Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53A754B6121
	for <lists+io-uring@lfdr.de>; Tue, 15 Feb 2022 03:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233703AbiBOClo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Feb 2022 21:41:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232692AbiBOCln (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Feb 2022 21:41:43 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37AA119C14;
        Mon, 14 Feb 2022 18:41:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644892891; x=1676428891;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zWXnrgqBKLup/OQfdGAvpbfBybF/qzrEr723T6dByos=;
  b=f8ObIKR+S1BQIdAD3u0Agu0X0Bb2SOQOjxbwNvsAUJSGmdHeLxx/xqWA
   cBndyavAj3lSu2BtdlC/HZRhfYKc6QhmXi4r/XPs1CDU0CRE8Io4nDWoY
   RSFW0Al3MKs8XbG+ajLBK7rIpIHDqJ3cTxMkQMiIM1nIEMFWqySDp3twF
   u51xcVNWR3oBdl6P2a9ZONda3y+gCRA03TilMTRJzep4YWecs3uGaV3X1
   B+TsXZ3XGrRLNKouUgC6H+kevrsV3dTlxaxZFqYRQhDseT9A+2l+HrmS7
   +z7d07z4KX+vAzZgy3xb8nxp/Upvv7Q/uNs9vYH+ZAADHTD3UkMsqZBHz
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10258"; a="237642807"
X-IronPort-AV: E=Sophos;i="5.88,369,1635231600"; 
   d="scan'208";a="237642807"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2022 18:41:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,369,1635231600"; 
   d="scan'208";a="635571634"
Received: from lkp-server01.sh.intel.com (HELO d95dc2dabeb1) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 14 Feb 2022 18:41:29 -0800
Received: from kbuild by d95dc2dabeb1 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nJnmS-0009Br-MW; Tue, 15 Feb 2022 02:41:28 +0000
Date:   Tue, 15 Feb 2022 10:40:46 +0800
From:   kernel test robot <lkp@intel.com>
To:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        kernel-team@fb.com
Cc:     kbuild-all@lists.01.org, shr@fb.com
Subject: [RFC PATCH] fs: __alloc_page_buffers() can be static
Message-ID: <20220215024046.GA23599@ac25a70e2135>
References: <20220214174403.4147994-6-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214174403.4147994-6-shr@fb.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

fs/buffer.c:805:20: warning: symbol '__alloc_page_buffers' was not declared. Should it be static?

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: kernel test robot <lkp@intel.com>
---
 fs/buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index a1986f95a39a0..19a4ab1f61686 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -802,7 +802,7 @@ int remove_inode_buffers(struct inode *inode)
 	return ret;
 }
 
-struct buffer_head *__alloc_page_buffers(struct page *page, unsigned long size,
+static struct buffer_head *__alloc_page_buffers(struct page *page, unsigned long size,
 		gfp_t gfp)
 {
 	struct buffer_head *bh, *head;
