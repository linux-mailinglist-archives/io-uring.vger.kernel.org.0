Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5791F560814
	for <lists+io-uring@lfdr.de>; Wed, 29 Jun 2022 19:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbiF2R7e (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jun 2022 13:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232101AbiF2R7b (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jun 2022 13:59:31 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD747E9
        for <io-uring@vger.kernel.org>; Wed, 29 Jun 2022 10:59:30 -0700 (PDT)
Received: from integral2.. (unknown [180.245.197.13])
        by gnuweeb.org (Postfix) with ESMTPSA id 70798800EF;
        Wed, 29 Jun 2022 17:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656525570;
        bh=2+vkFY/cAwJcxO/eliCRmSw5WdJfTavO74HpsygISOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gyffyitts7KDaPZcmbnajw+MUVVkKfOfpEFZs49559NSjawby9uUASTG7vCMKzvIs
         dzFimMu/iMMA4JDVvsFok00Ra2uVh/ZLC7HkhcO8w3VrXH7ofMq4e87ejdgysbP9yE
         II55UrruAOPmGv7rlQbY8rMIh2HrnKPizaobobynPbe5A46opMR4ILyJctNqRYcitN
         8Tz9yLju2xJGNwO/88bRWnjyX7aami6GQmLwrfLzQjdYRNfAGNkZjhX+8tS9ix+Nsw
         IxTv9/Di5w0mL4PB1Vf1ryGYJ2ZLex5VJ+SA0cX0FVBZZdjKWAtHejXuZ5Wk17l4U9
         VuTy4RjfpWpOA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <howeyxu@tencent.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@gnuweeb.org>
Subject: [PATCH liburing v2 1/8] CHANGELOG: Fixup missing space
Date:   Thu, 30 Jun 2022 00:58:23 +0700
Message-Id: <20220629175255.1377052-2-ammar.faizi@intel.com>
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

  s/reducingthe/reducing the/

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 CHANGELOG | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/CHANGELOG b/CHANGELOG
index 01cb677..efb3ff3 100644
--- a/CHANGELOG
+++ b/CHANGELOG
@@ -6,7 +6,7 @@ liburing-2.2 release
 - Add support for multishot accept.
 - io_uring_register_files() will set RLIMIT_NOFILE if necessary.
 - Add support for registered ring fds, io_uring_register_ring_fd(),
-  reducingthe overhead of an io_uring_enter() system call.
+  reducing the overhead of an io_uring_enter() system call.
 - Add support for the message ring opcode.
 - Add support for newer request cancelation features.
 - Add support for IORING_SETUP_COOP_TASKRUN, which can help reduce the
-- 
Ammar Faizi

