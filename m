Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8503E6510A7
	for <lists+io-uring@lfdr.de>; Mon, 19 Dec 2022 17:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbiLSQph (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Dec 2022 11:45:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232277AbiLSQpe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Dec 2022 11:45:34 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748C463F7;
        Mon, 19 Dec 2022 08:45:32 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.89])
        by gnuweeb.org (Postfix) with ESMTPSA id 274B481930;
        Mon, 19 Dec 2022 16:45:29 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1671468332;
        bh=8Cf4AMYWaURSR8KFu9Qq2TfXuIKb5Q+3FDrpQzifzEE=;
        h=From:To:Cc:Subject:Date:From;
        b=tlXtQIrLE7j39nfSc6t0X5DKoQqYGVyhLxCNkSFC3RXEyKUn4Ab7s04jILGhBnvxf
         B6razJGb/TpwiUh17LCskvgSW6hbmupRIGnRvHgPrXodaxj7jlE0zDvU6w94wIOORq
         gCekLKsV9vLqiypRkzfz+ywIdUhKUs6KIeegS5Ut/Gk0O2d/HpN5U2cz/W9Nwp0xSC
         FmSHK3GXONPbKMZoL154OC9DVKitDXgUpn3HwuIPRGi7FqlM+eZAAmauz0oZ1CsHgy
         gt/KCsCLaIBIUeXF0sF1g2CHgaJnMoTgZfaO1AY0F4KkC/MMqFM1q7EuWgU7oQT69C
         w/st4I/oMhc0Q==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] MAINTAINERS: io_uring: Add include/trace/events/io_uring.h
Date:   Mon, 19 Dec 2022 23:45:21 +0700
Message-Id: <20221219164521.2481728-1-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

This header file was introduced in commit c826bd7a743f ("io_uring: add
set of tracing events"). It didn't get added to the io_uring
maintainers section. Add this header file to the io_uring maintainers
section.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index cf0f18502372..8b3502dfff9d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10742,6 +10742,7 @@ T:	git git://git.kernel.dk/liburing
 F:	io_uring/
 F:	include/linux/io_uring.h
 F:	include/linux/io_uring_types.h
+F:	include/trace/events/io_uring.h
 F:	include/uapi/linux/io_uring.h
 F:	tools/io_uring/
 

base-commit: 5576035f15dfcc6cb1cec236db40c2c0733b0ba4
-- 
Ammar Faizi

