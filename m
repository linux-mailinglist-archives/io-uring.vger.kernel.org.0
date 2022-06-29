Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED9F856082F
	for <lists+io-uring@lfdr.de>; Wed, 29 Jun 2022 20:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbiF2SAA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jun 2022 14:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232227AbiF2R77 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jun 2022 13:59:59 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462BEC7F
        for <io-uring@vger.kernel.org>; Wed, 29 Jun 2022 10:59:59 -0700 (PDT)
Received: from integral2.. (unknown [180.245.197.13])
        by gnuweeb.org (Postfix) with ESMTPSA id 086A2800E7;
        Wed, 29 Jun 2022 17:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656525598;
        bh=zQ5DQmoxSwZ6Mva+LUDQuM5nON1RwWAYQmZoxevo84c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WlXuj/jJ27sGGLPY0zTkNnVRCIBSjyG4A6wWz+El8cCt4mKG8Sz/L8IS/LeI+xea3
         OPU7JgoTExP3T/IWA/2QJhDtLFIHGxwBnW7yCaL4lsVZglXq6a/GLqNDW94xtK1HRC
         FATv8UIw4+G37iX+MeuZLncJgNnwwF1xGo+t55taWn21KdPiyhTdCvDK3k6xFYZDP+
         3sRRjiVnzhHWhVv/LDZbh9g9xcTcVXhPHjI06kzADFzCC48tjwYweDv1G65seGnEJu
         F2QZvBNhkR+xUgoOyNefbMDUoYj0ofEbQJZMP+ghgqhI1uzY9kkCczbnFnDYrIiDri
         RW/bVsJvYs8MQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <howeyxu@tencent.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@gnuweeb.org>
Subject: [PATCH liburing v2 8/8] CHANGELOG: Note about aarch64 support
Date:   Thu, 30 Jun 2022 00:58:30 +0700
Message-Id: <20220629175255.1377052-9-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220629175255.1377052-1-ammar.faizi@intel.com>
References: <20220629175255.1377052-1-ammar.faizi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 CHANGELOG | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/CHANGELOG b/CHANGELOG
index efb3ff3..9c054b0 100644
--- a/CHANGELOG
+++ b/CHANGELOG
@@ -1,3 +1,8 @@
+liburing-2.3 release
+
+- Support non-libc build for aarch64.
+
+
 liburing-2.2 release
 
 - Support non-libc builds.
-- 
Ammar Faizi

