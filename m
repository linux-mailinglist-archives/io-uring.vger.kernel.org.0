Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A510A565D41
	for <lists+io-uring@lfdr.de>; Mon,  4 Jul 2022 19:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbiGDRze (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jul 2022 13:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231177AbiGDRzd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jul 2022 13:55:33 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC83CDFF2
        for <io-uring@vger.kernel.org>; Mon,  4 Jul 2022 10:55:32 -0700 (PDT)
Received: from integral2.. (unknown [36.81.65.188])
        by gnuweeb.org (Postfix) with ESMTPSA id AD5478024A;
        Mon,  4 Jul 2022 17:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1656957332;
        bh=zQ5DQmoxSwZ6Mva+LUDQuM5nON1RwWAYQmZoxevo84c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qt6WfdjVG9BSfixR1PCkoT0wxPkg8tdvfPkdcTTbHk0j+SE3ZxBlspJPj5EbqMNLD
         NkRQg6LJF98BNHzXYY5YofzwHkpCKpnNStAOJey5SGJsAMKlJsZWqj2U0xyoGmooqw
         AXh3kgcaCorv3SaAYp+whWcgmsWglErO/8Kplxm7WQM2sArsjJpFwEkzhrzpHeVPZK
         5jYIe4LI9CSbsMkh3sB6TjOVJdfQt9xcrVxdOk6A5TBcidJFFMJdqKc1a+t1oeSKDa
         hXR4FAKZ9QLiA8f/lLTyMiLFPonYOhBTEuPSuUMGV0ffr7RUTSCBh28GO93iquYe4J
         IjEcIubPy+hIw==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Hao Xu <howeyxu@tencent.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v3 10/10] CHANGELOG: Note about aarch64 support
Date:   Tue,  5 Jul 2022 00:54:36 +0700
Message-Id: <20220704174858.329326-11-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220704174858.329326-1-ammar.faizi@intel.com>
References: <20220704174858.329326-1-ammar.faizi@intel.com>
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

