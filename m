Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F33B4581006
	for <lists+io-uring@lfdr.de>; Tue, 26 Jul 2022 11:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232430AbiGZJgE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jul 2022 05:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231765AbiGZJgD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jul 2022 05:36:03 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DCD55B5
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 02:36:01 -0700 (PDT)
Received: from integral2.. (unknown [125.160.106.238])
        by gnuweeb.org (Postfix) with ESMTPSA id 3AA977E328;
        Tue, 26 Jul 2022 09:35:59 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1658828160;
        bh=MJOaOYY+xn15MVzQy2v646fZc3jmIuOkKaAgyodx7eo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TkOYuXQKHFWKpEExZBB4FAOZ2fLGyzwXdfftpKObq28Gtd/TRhfiClxFK+cGG4OEf
         TnZCG/79IEGFlblKmmW2uOd0ci6o1/WB0JoPYRBvT92LS+kly49RfVXU/GHiiuadXg
         BRE6ol1A/T7hccfAn5nu62LhIiB38XiQz30ul7ArKf9WDdHrwEEt8dhpalT7iyufqn
         22+UCxZzSRVLHLDPrYG8rJxBA5lX1blSD4jrpnWE8gEpcnm9NnvYtCb0MdqtHgSfBQ
         spTw304M4Lc/ZYtoJkdR5EfbGcYjPQRT4dtIz4eSsA3721l9QtSZamsIxRKhs2oqia
         UOErVHinsm50g==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Eli Schwartz <eschwartz93@gmail.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH liburing 3/4] tests: add tests for zerocopy send and notifications
Date:   Tue, 26 Jul 2022 16:35:41 +0700
Message-Id: <55b6d481ea394ab6e18d455a10e0c7ed@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <eb9f8e37-a3b5-0b87-4f90-7ec80772e3fb@kernel.dk>
References: <cover.1658743360.git.asml.silence@gmail.com> <92dccd4b172d5511646d72c51205241aa2e62458.1658743360.git.asml.silence@gmail.com> <bf034949-b5b3-f155-ca33-781712273881@gnuweeb.org> <c89d373f-bc0d-dccf-630f-763e8e1a0fe5@gmail.com> <7ed1000e-9d13-0d7f-80bd-7180969fec1c@gnuweeb.org> <7f146700-ad7a-08b2-ecb8-c88d4f57a8eb@gmail.com> <eb9f8e37-a3b5-0b87-4f90-7ec80772e3fb@kernel.dk>
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
Subject: [PATCH] helpers.h: Kill T_EXIT_ERROR because it's not used

This value is not used anywhere in liburing tests and we are not
going to make a distinction between FAIL and ERROR. Kill it to
avoid confusion in choosing them. Just always use T_EXIT_FAIL
whenever we fail.

Cc: Eli Schwartz <eschwartz93@gmail.com>
Link: https://lore.kernel.org/io-uring/eb9f8e37-a3b5-0b87-4f90-7ec80772e3fb@kernel.dk
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

On Mon, 25 Jul 2022 17:37:03 -0600, Jens Axboe wrote:
> I think we should kill that, it just causes confusion and I generally
> hate adding infrastructure that isn't even being used.

The killing patch below...

 test/helpers.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/test/helpers.h b/test/helpers.h
index fbfd7d1..6d5726c 100644
--- a/test/helpers.h
+++ b/test/helpers.h
@@ -20,7 +20,6 @@ enum t_test_result {
 	T_EXIT_PASS   = 0,
 	T_EXIT_FAIL   = 1,
 	T_EXIT_SKIP   = 77,
-	T_EXIT_ERROR  = 99,
 };
 
 /*

base-commit: 30a20795d7e4f300c606c6a2aa0a4c9492882d1d
-- 
Ammar Faizi

