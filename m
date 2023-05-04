Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 188B66F6473
	for <lists+io-uring@lfdr.de>; Thu,  4 May 2023 07:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbjEDFgA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 May 2023 01:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjEDFf7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 May 2023 01:35:59 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B641BF6
        for <io-uring@vger.kernel.org>; Wed,  3 May 2023 22:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683178559; x=1714714559;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=LrMPPNz2yGvPfS/P182NlYJPSZd9VUwSeu5QBFDXrGk=;
  b=Y6zxmP4jzEFgSUiAolMjZRZZ4NU7sW/N+9+fwFRpZNIDJwUO6u56gAiO
   Suuit3Kl+1p8boknb8wYLbOgmWzMxdcBDMX+RkZNSexm2wrkY+OJiWzRd
   txr0vZy2pM7n8JYYs538W9UqkjYNMYdKXAkGRRhaz6k+UWIP3GcLW8AK5
   gErMO87Oz6+fCAsrmu+afHKZHQIhMZrOUqI1GCofbzW547Xr8fczW6bI0
   AtQqqBYxU1tpPMA5CHdBmmHLQqTlX9UX+xCWXYI1yF9OCBt3/Cuiz+S+y
   CH9XbD936a7L1Qy0FVcp2hkr70Nfbne9yNWx0Bt5dgd2CDA/ArLpyhLFg
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="329196699"
X-IronPort-AV: E=Sophos;i="5.99,249,1677571200"; 
   d="scan'208";a="329196699"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2023 22:35:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="808560655"
X-IronPort-AV: E=Sophos;i="5.99,249,1677571200"; 
   d="scan'208";a="808560655"
Received: from sse-cse-haiyue-nuc.sh.intel.com ([10.112.226.22])
  by fmsmga002.fm.intel.com with ESMTP; 03 May 2023 22:35:57 -0700
From:   Haiyue Wang <haiyue.wang@intel.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, Haiyue Wang <haiyue.wang@intel.com>
Subject: [PATCH liburing v1] .gitignore: Add `examples/rsrc-update-bench`
Date:   Thu,  4 May 2023 13:38:35 +0800
Message-Id: <20230504053835.118208-1-haiyue.wang@intel.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The commit c0940508607f ("examples: add rsrc update benchmark") didn't
add the built example binary into `.gitignore` file.

Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index bfb2224..69ec296 100644
--- a/.gitignore
+++ b/.gitignore
@@ -22,6 +22,7 @@
 /examples/ucontext-cp
 /examples/poll-bench
 /examples/send-zerocopy
+/examples/rsrc-update-bench
 
 /test/*.t
 /test/*.dmesg
-- 
2.40.1

