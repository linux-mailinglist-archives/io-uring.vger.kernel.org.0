Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D136C50C12B
	for <lists+io-uring@lfdr.de>; Fri, 22 Apr 2022 23:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbiDVViX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 17:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbiDVViO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 17:38:14 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002FF409D09
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 13:42:38 -0700 (PDT)
Received: from integral2.. (unknown [36.72.214.135])
        by gnuweeb.org (Postfix) with ESMTPSA id 5DF127E76C;
        Fri, 22 Apr 2022 20:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1650659764;
        bh=mqI0+q4JQVe0kgIIOyV1JgwWzkWZjtVVqfgxEhf36ZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N2I4YZrmEYq1dzTl89thW0F2Bn61NsgOU0eQ6G4g9PLnDVcD0wWNQ6wdenvgo49MZ
         kD9KIwDEJv+H4oOWR6/J76gYBr6+0gHB7y70RhHGDR5+I1DmsKQiHNUHotWnx/Odmp
         Og0MEAROArOW2qMyMAkFz7AOthJbFsn+Ft4qixT1X9U2iPM88sjD3snGnaynUGygMJ
         Sds4jTSIeEPS+1s/MT57pUR4ga/tH3CWHVsi7AKzUWsgf2kSFSssyCDLI/QNTm22JO
         f8+wWo7leLcVxVa8ykgc5GXhHzxWBFP8cfrAus1Uz5dTX41DeGphSTub5TsijO5+pk
         jWawr6TrHRydQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH liburing v1 1/6] test/runtests-quiet.sh: Fixup redirection
Date:   Sat, 23 Apr 2022 03:35:37 +0700
Message-Id: <20220422203340.682723-2-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220422203340.682723-1-ammar.faizi@intel.com>
References: <20220422203340.682723-1-ammar.faizi@intel.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=980; h=from:subject:message-id; bh=JfHwySbfROCEyyajjNgtzJP37zdGJjCCOab3QatIxBw=; b=owGbwMvMwMVo5r/L5L84lzfjabUkhqRkwey5YWmCs7YmtUcaToh67ilzXjk4Mzlgeq9r9s6tgvct Osw6GY1ZGBi5GGTFFFleTC7KPfHkwD3rRYzsMINYmUCmMHBxCsBEAnXY/5e5bfpg+5794jYmy0tmxY JtPDmpNo8i/11rT/BQ/7dvn0HckT1Tu/3vXIppPrjWf5HsooTXMS+yDrr7KXFOalHT+ZJwmGtCScL2 J9fe9XR8WLs0THi9d20Vk6fKv7SzPVzRh62yI8W7f57x2xBx+GDvkX1cE7+Lys1aMZFDU/pJ2caskM DQh4LXipeZfDrFdmJxyUmviI48FWWXXzfl81sX9fbxhc9KeZIubLWz69DeO9se3/q5vPRxnCJPm77Q fX2m1dNTak7wzTf/O12sW0mRQbrEmo3n/lvJk6E18W9ZmOZPLl2l577By88rnLFEeyo/s0Zl5+e1Of l221QX8TKy5bp9ilBbv4bRq7wcAA==
X-Developer-Key: i=ammarfaizi2@gnuweeb.org; a=openpgp; fpr=E893726DC8E4C0DE3BA20107364FBA34FF170A4B
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

1) command > file.txt

will redirect the stdout to file.txt.

2) command > file.txt 2>&1

will redirect the stdout and stderr to file.txt.

What we want is (2). Previous commits placed the "2>&1" wrong.

Cc: Dylan Yudaken <dylany@fb.com>
Fixes: 770efd14e8b17ccf23a45c95ecc9d38de4e17011 ("test/runtests-quiet.sh: fixup redirection")
Fixes: 6480f692d62afbebb088febc369b30a63dbc2ea7 ("test: add make targets for each test")
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 test/runtests-quiet.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/runtests-quiet.sh b/test/runtests-quiet.sh
index 2b84b9f..2bc7da0 100755
--- a/test/runtests-quiet.sh
+++ b/test/runtests-quiet.sh
@@ -2,7 +2,7 @@
 
 TESTS=("$@")
 RESULT_FILE=$(mktemp)
-{ ./runtests.sh "${TESTS[@]}"; } 2>&1 > "$RESULT_FILE"
+./runtests.sh "${TESTS[@]}" > "$RESULT_FILE" 2>&1
 RET="$?"
 if [ "${RET}" -ne 0 ]; then
     cat "$RESULT_FILE"
-- 
Ammar Faizi

