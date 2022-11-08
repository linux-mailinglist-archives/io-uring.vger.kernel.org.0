Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F30F621BC0
	for <lists+io-uring@lfdr.de>; Tue,  8 Nov 2022 19:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234865AbiKHSUV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Nov 2022 13:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234486AbiKHSTv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Nov 2022 13:19:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6877721B
        for <io-uring@vger.kernel.org>; Tue,  8 Nov 2022 10:19:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA266B81BED
        for <io-uring@vger.kernel.org>; Tue,  8 Nov 2022 18:19:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 325BBC433D7;
        Tue,  8 Nov 2022 18:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667931540;
        bh=0a5VMb3A/dQ5w19luMlNlp/ScSH2MsXxDmYCY2o0nfk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jYL6F1JjYUZrswRS4loV4BLiDfcank8b/FKX01wb2J6s5hFMcKm6xHmemV/o5069N
         41pSLvFsHySC+UzgMHUwJM1S1u7WTX34Fv5ig/rETO6uV2FAdCCVSXFukqdKhNqtXG
         akuM2v8w/lnI1wMpVSDSgdhwAUSyoaYlaRP63xPyQvI4EWuebhLk7GPx/sqLcB5tIC
         /wtG9lwzI2w8+GfuaHURFVBs/V7eYMZxQswQEVjOxtAKq5usQCUW77aHHgEn+b5J4M
         APTa4kSb8GUg+ZCjA0yjcDHzPaIMGlSnIuoqYzecH6CsIpT0JAa2BQtNFA8W1VcQ3I
         dyQCE7pW2w98w==
Date:   Tue, 8 Nov 2022 11:18:57 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     Dylan Yudaken <dylany@meta.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Subject: Re: [PATCH liburing] Alphabetise the test list
Message-ID: <Y2qdkSw4h/AXw3lZ@kbusch-mbp>
References: <20221108172137.2528931-1-dylany@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108172137.2528931-1-dylany@meta.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Nov 08, 2022 at 09:21:37AM -0800, Dylan Yudaken wrote:
> Alphabetical order is commanded by the comment at the top of the list

We could create a make target to detect this kind of thing. A quick
script off the top of my head gets pretty close to finding improper
order, though not sure how pedantic it needs to be with the dashes '-'.

$ diff -u <(sed -e '/test_srcs :=/,/EOL/!d' test/Makefile | sed '1d;$d' | sed 's/\.c//g') \
          <(sed -e '/test_srcs :=/,/EOL/!d' test/Makefile | sed '1d;$d' | sed 's/\.c//g' | sort)

--- /dev/fd/63  2022-11-08 10:11:22.040884177 -0800
+++ /dev/fd/62  2022-11-08 10:11:22.041884178 -0800
@@ -69,8 +69,8 @@
        msg-ring \
        multicqes_drain \
        nolibc \
-       nop-all-sizes \
        nop \
+       nop-all-sizes \
        openat2 \
        open-close \
        open-direct-link \
@@ -83,13 +83,13 @@
        poll-cancel \
        poll-cancel-all \
        poll-cancel-ton \
+       pollfree \
        poll-link \
        poll-many \
        poll-mshot-overflow \
        poll-mshot-update \
        poll-ring \
        poll-v-poll \
-       pollfree \
        probe \
        read-before-exit \
        read-write \
@@ -99,8 +99,8 @@
        register-restrictions \
        rename \
        ringbuf-read \
-       ring-leak2 \
        ring-leak \
+       ring-leak2 \
        rsrc_tags \
        rw_merge_test \
        self \
