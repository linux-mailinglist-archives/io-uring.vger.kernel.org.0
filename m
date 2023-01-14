Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFE966A908
	for <lists+io-uring@lfdr.de>; Sat, 14 Jan 2023 04:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbjANDy2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Jan 2023 22:54:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbjANDy0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Jan 2023 22:54:26 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64FDC3AB35
        for <io-uring@vger.kernel.org>; Fri, 13 Jan 2023 19:54:24 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.184])
        by gnuweeb.org (Postfix) with ESMTPSA id 927AF7E799;
        Sat, 14 Jan 2023 03:54:21 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1673668464;
        bh=7CaOxh+S96wsVYtqquOG9shNDujwpa5ymKx65ZNpgqk=;
        h=From:To:Cc:Subject:Date:From;
        b=B5QfsRp5dyH6KT1ycmWpIXd8hP8HFNtKShcl6KYL27XWgoyzB23lHdKbudSBbNsT8
         /XAp1Xe5ZH6+mD0p9h3DjAMqnXcudzlr6qqhoHrHXfnFXBiMS0a1i1cKqYapjs6cN6
         kHEgXDwZooOGL9iKEq1BvifLXEms88QgfzMYyL1Yyll1XRruyqfh21sD9LXMCCjhkV
         1K4hxYWGRRshK+c/b0j2qFcBExG6geyMHyUkVWsyAL31nUcxmsCTCepJDzaaCgekPY
         BkrjLXOqhnMCyKhAguBnb47mYuLpiCtRaci31sOTOJA2crnvn9frfBcH3rfWU3oN3Q
         mRvHKp+W/uA+g==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        VNLX Kernel Department <kernel@vnlx.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Dylan Yudaken <dylany@meta.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH liburing v1] liburing.map: Export `io_uring_{enable_rings,register_restrictions}`
Date:   Sat, 14 Jan 2023 10:54:05 +0700
Message-Id: <20230114035405.429608-1-ammar.faizi@intel.com>
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

When adding these two functions, Stefano didn't add
io_uring_enable_rings() and io_uring_register_restrictions() to
liburing.map. It causes a linking problem. Add them to liburing.map.

This issue hits liburing 2.0 to 2.3.

Closes: https://github.com/axboe/liburing/pull/774
Fixes: https://github.com/axboe/liburing/issues/773
Fixes: https://github.com/facebook/folly/issues/1908
Fixes: d2654b1ac886 ("Add helper to enable rings")
Fixes: 25cf9b968a27 ("Add helper to register restrictions")
Cc: Dylan Yudaken <dylany@meta.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/liburing.map | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/liburing.map b/src/liburing.map
index 67aebae..1dbe765 100644
--- a/src/liburing.map
+++ b/src/liburing.map
@@ -73,4 +73,7 @@ LIBURING_2.4 {
 		io_uring_major_version;
 		io_uring_minor_version;
 		io_uring_check_version;
+
+		io_uring_enable_rings;
+		io_uring_register_restrictions;
 } LIBURING_2.3;

base-commit: 0df8a379e929641699c2ab1f42de1efd2515b908
-- 
Ammar Faizi

