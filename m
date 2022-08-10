Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4FB58E41D
	for <lists+io-uring@lfdr.de>; Wed, 10 Aug 2022 02:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiHJAcw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Aug 2022 20:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiHJAcv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Aug 2022 20:32:51 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A40A7AC22
        for <io-uring@vger.kernel.org>; Tue,  9 Aug 2022 17:32:51 -0700 (PDT)
Received: from integral2.. (unknown [180.246.144.41])
        by gnuweeb.org (Postfix) with ESMTPSA id 83F8F80866;
        Wed, 10 Aug 2022 00:32:48 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1660091570;
        bh=UAM+iegT+0YgZACF4mFDrxf/kclbwpYnTqerz3nIjfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AkqJeGy2RbvDIf9YjRMLGCA5AguQ1iW2wdWjBStKv/ZH7xYO8A459Ta8i2C/jrY2W
         WaMyjf0VQ6HVQ7Nzq0d2ALE1Z0DoRdKyhdLglEqPwv/EBo7tTsZFEIh7Z2n+TdpMzl
         /yvSelRATGPH5OyKkYWBK9LQIl2oOkcPVWUIFXkLNpLL6tedIXR77a99/ootBsIA5G
         AViFowLr48fVtZGL9oxAcX0UjJw4Tc1CDYxuOJ2U1PNNaegOhyr0VHLFwjPnm9SeL6
         iwkZILYphXSVShM8Ms8t6N8oNpi1ymo2zWFA+8d4HfFZMBwFDnr1zDSdLgOwNvbO9c
         8vRMugeME8yUA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Vitaly Chikunov <vt@altlinux.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v1 09/10] test/eventfd-disable: Fix reading uninitialized variable
Date:   Wed, 10 Aug 2022 07:31:58 +0700
Message-Id: <20220810002735.2260172-10-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220810002735.2260172-1-ammar.faizi@intel.com>
References: <20220810002735.2260172-1-ammar.faizi@intel.com>
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

Fix this:

  ==2256099== Conditional jump or move depends on uninitialised value(s)
  ==2256099==    at 0x109DF5: main (eventfd-disable.c:136)

Link: https://github.com/axboe/liburing/issues/640
Reported-by: Vitaly Chikunov <vt@altlinux.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 test/eventfd-disable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/eventfd-disable.c b/test/eventfd-disable.c
index 2c8cf6d..9de2465 100644
--- a/test/eventfd-disable.c
+++ b/test/eventfd-disable.c
@@ -21,7 +21,7 @@ int main(int argc, char *argv[])
 	struct io_uring_sqe *sqe;
 	struct io_uring_cqe *cqe;
 	struct io_uring ring;
-	uint64_t ptr;
+	uint64_t ptr = 0;
 	struct iovec vec = {
 		.iov_base = &ptr,
 		.iov_len = sizeof(ptr)
-- 
Ammar Faizi

