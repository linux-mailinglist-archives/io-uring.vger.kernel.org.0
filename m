Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAAAF55F260
	for <lists+io-uring@lfdr.de>; Wed, 29 Jun 2022 02:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiF2A2V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jun 2022 20:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiF2A2V (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jun 2022 20:28:21 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8747921E1E
        for <io-uring@vger.kernel.org>; Tue, 28 Jun 2022 17:28:20 -0700 (PDT)
Received: from integral2.. (unknown [180.245.197.13])
        by gnuweeb.org (Postfix) with ESMTPSA id 383367FC83;
        Wed, 29 Jun 2022 00:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656462500;
        bh=9EOHqqHpHFrcRI3qCFB5ehouMVS1GD7Rg5Ue47izIqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cNUES0/9C3ryep2qXQRP1ZZRfjfm6gdBKZDVy+KqY9KmuabqwQ8ACQq38+XCVGE8h
         tuKgKA/EoZ87LXKdhpuhG85rRUcy1lAJRMmeE3iTZiyHru2BGYTtCGNIwgLEkJie9U
         dCUdawaQEhWC8Zd/cn2PJQ1YgWexyjZPYXDloqxZISyLQaUz6Kz1vkvQSsdTXTN4Kr
         1iLeC3CIxv3GhghvQdGkaiDQeKq8zdU/wECCcRFhLObrKBsiNKK3mrG7bho6wXsEUg
         Z5b1ChEr2CRkOpLGpgwGuhA5vflln13ALsaJ/neLm/GFzTCNgn+SFz02QITS0+gg4M
         v76/uvSvv2R7A==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <howeyxu@tencent.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@gnuweeb.org>
Subject: [PATCH liburing v1 2/9] setup: Handle `get_page_size()` failure (for aarch64 nolibc support)
Date:   Wed, 29 Jun 2022 07:27:46 +0700
Message-Id: <20220629002028.1232579-3-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220629002028.1232579-1-ammar.faizi@intel.com>
References: <20220629002028.1232579-1-ammar.faizi@intel.com>
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

This is a preparation patch to add aarch64 nolibc support.

aarch64 supports three values of page size: 4K, 16K, and 64K which are
selected at kernel compilation time. Therefore, we can't hard code the
page size for this arch. We will utilize open(), read() and close()
syscall to find the page size from /proc/self/auxv. Since syscall may
fail, we may also fail to get the page size here. Handle the failure.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/setup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/setup.c b/src/setup.c
index d2adc7f..ca9d30d 100644
--- a/src/setup.c
+++ b/src/setup.c
@@ -336,6 +336,9 @@ ssize_t io_uring_mlock_size_params(unsigned entries, struct io_uring_params *p)
 	}
 
 	page_size = get_page_size();
+	if (page_size < 0)
+		return page_size;
+
 	return rings_size(p, entries, cq_entries, page_size);
 }
 
-- 
Ammar Faizi

