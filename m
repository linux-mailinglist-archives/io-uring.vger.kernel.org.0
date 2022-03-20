Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87CC64E1998
	for <lists+io-uring@lfdr.de>; Sun, 20 Mar 2022 05:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiCTECr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Mar 2022 00:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiCTECp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Mar 2022 00:02:45 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864EE5F274
        for <io-uring@vger.kernel.org>; Sat, 19 Mar 2022 21:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647748883; x=1679284883;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VPZaa+TjLsgOuyu5L01JNKsr8vC91qIxj/yinHI2Hb4=;
  b=geLJ1bN1OvQHwU3p5JMwBxxGciU0xNvBBsptlxwgJA2VdRRPLg2qyKF1
   RLC93pTaU6L/NtD4cqXtSsan1tm64kCXXAnEhbcdEETRngvaZYO3T1oLT
   dkmrK0BkG8OkECASFjkfHCt9q3i7u0zBbbWFyyTcFC73L8TZq2PqF0XR1
   YFy3l49pEnPTomL2x0pSmmBm0e3848BpVkqaK1y632sqiP6rnFkKg9LyH
   oHjsZErv1UYwzey2trARlNxEThTgDVVKwqAtldoQ2gyg6iJvpgfoZLWhP
   zW9Un2lcgGGkNMGLQj5qUED7Fm3vlW/TrjLzyE7FkC4AFkf6OQc5y8D0o
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10291"; a="254917142"
X-IronPort-AV: E=Sophos;i="5.90,195,1643702400"; 
   d="scan'208";a="254917142"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2022 21:01:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,195,1643702400"; 
   d="scan'208";a="582480778"
Received: from npg-dpdk-haiyue-2.sh.intel.com ([10.67.111.4])
  by orsmga001.jf.intel.com with ESMTP; 19 Mar 2022 21:01:22 -0700
From:   Haiyue Wang <haiyue.wang@intel.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, Haiyue Wang <haiyue.wang@intel.com>
Subject: [PATCH liburing v1] .gitignore: Add `test/drop-submit` to .gitignore
Date:   Sun, 20 Mar 2022 11:26:53 +0800
Message-Id: <20220320032653.5986-1-haiyue.wang@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The commit c56200f72a01 forgot to add it to .gitignore when creating
this test.

Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index 5e3b949..30119dd 100644
--- a/.gitignore
+++ b/.gitignore
@@ -45,6 +45,7 @@
 /test/d77a67ed5f27-test
 /test/defer
 /test/double-poll-crash
+/test/drop-submit
 /test/eeed8b54e0df-test
 /test/empty-eownerdead
 /test/eventfd
-- 
2.35.1

