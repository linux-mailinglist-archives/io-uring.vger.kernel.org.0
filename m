Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAAC9581053
	for <lists+io-uring@lfdr.de>; Tue, 26 Jul 2022 11:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232651AbiGZJto (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jul 2022 05:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238332AbiGZJtm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jul 2022 05:49:42 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C3331DD7
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 02:49:41 -0700 (PDT)
Received: from integral2.. (unknown [125.160.106.238])
        by gnuweeb.org (Postfix) with ESMTPSA id 9B8D580631;
        Tue, 26 Jul 2022 09:49:39 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1658828981;
        bh=h+UyL3Y0CwV/mlfP72kZqjb7K7ZRYibA0lhtAU8GBnU=;
        h=From:To:Cc:Subject:Date:From;
        b=MrwUbPaBaxT1HR9XYnSh6TFfQhW3DnPRbsm1pLZxJYcyBISnEUpTuXPWkgU30zo3p
         VGmMCvrS+/jZJAznYOpBCzQHaUTDm7CLubIGs1jMBh83DAcBJkKnrR0IH2ZtHfTC0w
         CbVzTDlUnxw9DGe5nIuBdsKNt/LcPeqHEozCueExrjWuZbvFWwwcbi42/owc1HVSMF
         qAk8cMs3dTgpcVNUKuYw7+ukopdQ9bbPcraXvO7c3mlG4VQuoNdPKuKbbcHxvrA+5s
         HrBiQxk4FoRMe1Ch5J7iA1CkiKgtXoCLusuhY5eZFXOzDg8i2FcJgc2M/2NPfUsEg/
         XfKd5IsPXBpZg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@gnuweeb.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH liburing] .gitignore: Add poll-bench and send-zerocopy examples
Date:   Tue, 26 Jul 2022 16:49:08 +0700
Message-Id: <20220726094908.226477-1-ammarfaizi2@gnuweeb.org>
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

Previous commits add poll-bench and send-zerocopy examples but forgot
to add the compiled files to .gitignore. Add them to .gitignore to
make "git status" clean after build.

Cc: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 .gitignore | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/.gitignore b/.gitignore
index b5acffd..4b63a91 100644
--- a/.gitignore
+++ b/.gitignore
@@ -15,6 +15,8 @@
 /examples/io_uring-test
 /examples/link-cp
 /examples/ucontext-cp
+/examples/poll-bench
+/examples/send-zerocopy
 
 /test/*.t
 /test/*.dmesg

base-commit: 30a20795d7e4f300c606c6a2aa0a4c9492882d1d
-- 
Ammar Faizi

