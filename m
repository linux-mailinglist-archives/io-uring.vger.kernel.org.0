Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA476650F55
	for <lists+io-uring@lfdr.de>; Mon, 19 Dec 2022 16:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbiLSPxm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Dec 2022 10:53:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232664AbiLSPxK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Dec 2022 10:53:10 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F501166
        for <io-uring@vger.kernel.org>; Mon, 19 Dec 2022 07:50:52 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.89])
        by gnuweeb.org (Postfix) with ESMTPSA id 339BD81930;
        Mon, 19 Dec 2022 15:50:48 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1671465052;
        bh=j2AB9YkhkwD65xQctqMhzrGIN73QOyK63B9gEyv9Vwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=omLJ+zJvfftJdcFoRe3F4HFY+t7AKaIxOOSLTH4wXsw940W/VFmGg5JHgalF4An6o
         L7A2Cb3mWpVdd6SZmxRJq8ZGPcozF+1xMbLqEPc7igl00b4YoEBp4HUooGFjgGNjEO
         m8mFt9l/QnbJ5jHbhgQst4UaLQwqTdvsdEvqPz/8Abq4uJdBCbcPy8VMldcNalypOV
         9pe3M7/5ed9E6i3l7RaPdSIzr4Js3HOTFvYeDt68bOYlThW2eOxhK8fAYkVrpRSD59
         W9yW+vS1pYgt5oF3giypxoIQa53/eSKJCwTkix/PiEOCCtGiEyjhAIr1fz3qBe66Mo
         m1ROsZhWqQ0sg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        VNLX Kernel Department <kernel@vnlx.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Christian Hergert <chergert@redhat.com>,
        Christian Mazakas <christian.mazakas@gmail.com>
Subject: [PATCH liburing v1 8/8] CHANGELOG: Update the CHANGELOG file
Date:   Mon, 19 Dec 2022 22:50:00 +0700
Message-Id: <20221219155000.2412524-9-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221219155000.2412524-1-ammar.faizi@intel.com>
References: <20221219155000.2412524-1-ammar.faizi@intel.com>
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

Cc: Christian Hergert <chergert@redhat.com> # version check
Cc: Christian Mazakas <christian.mazakas@gmail.com> # FFI support
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 CHANGELOG | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/CHANGELOG b/CHANGELOG
index 09511af..68b732c 100644
--- a/CHANGELOG
+++ b/CHANGELOG
@@ -1,10 +1,16 @@
+liburing-2.4 release
+
+- Add io_uring_{major,minor,check}_version() functions.
+- Add IO_URING_{MAJOR,MINOR,CHECK}_VERSION() macros.
+- FFI support (for non-C/C++ languages integration).
+
 liburing-2.3 release
 
 - Support non-libc build for aarch64.
 - Add io_uring_{enter,enter2,register,setup} syscall functions.
 - Add sync cancel interface, io_uring_register_sync_cancel().
 - Fix return value of io_uring_submit_and_wait_timeout() to match the
   man page.
 - Improvements to the regression tests
 - Add support and test case for passthrough IO
 - Add recv and recvmsg multishot helpers and support
-- 
Ammar Faizi

