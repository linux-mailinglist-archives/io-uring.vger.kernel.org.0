Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76CA95A4150
	for <lists+io-uring@lfdr.de>; Mon, 29 Aug 2022 05:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiH2DIk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Aug 2022 23:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiH2DIb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Aug 2022 23:08:31 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649963ECC8;
        Sun, 28 Aug 2022 20:08:20 -0700 (PDT)
Received: from localhost.localdomain (unknown [182.2.68.216])
        by gnuweeb.org (Postfix) with ESMTPSA id 094AE80B11;
        Mon, 29 Aug 2022 03:07:58 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1661742481;
        bh=SJyjDYyBoXZYMkiEKyI9duAVBN/pZrSeFntJlaGszDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gwekcET9EqL1L9NEGMfYp16jvfi3VpuSluLXOmVGq97uPtSRKy3fU3cZri2Jtec7J
         vIdhc+iLGIKrQtk+jFK0nxrvCaAQFIAEfQfROuaMSDZoILmlFfZH7TJXhHAcdcdsxQ
         kXtFJlICe4qCZXr4JOf/OkvxvYRdWfHQdcGvdzoKeo+UvPuNoWKJ3uhbNiG7hLrW6o
         krf14hOgI+on2FQAYzrPhhTDjTCeDk9uIGsR16QydCjRVOPh58DmoaulsoM1AFOV5+
         kHSY/IN/O8fO1ru+ph3J4savkPG7oyHoSlSzgTBfg6rMYuOXK4KZcS55AoaJ5x4rxd
         HFeM6k/AFAlUw==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Caleb Sander <csander@purestorage.com>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [RFC PATCH liburing v1 3/4] man: Alias `io_uring_enter2()` to `io_uring_enter()`
Date:   Mon, 29 Aug 2022 10:07:38 +0700
Message-Id: <20220829030521.3373516-4-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220829030521.3373516-1-ammar.faizi@intel.com>
References: <20220829030521.3373516-1-ammar.faizi@intel.com>
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

We have a new function io_uring_enter2(), add the man page entry for it
by aliasing it to io_uring_enter(). This aliased man entry has already
explained it.

Cc: Caleb Sander <csander@purestorage.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 man/io_uring_enter2.2 | 1 +
 1 file changed, 1 insertion(+)
 create mode 120000 man/io_uring_enter2.2

diff --git a/man/io_uring_enter2.2 b/man/io_uring_enter2.2
new file mode 120000
index 0000000..5566c09
--- /dev/null
+++ b/man/io_uring_enter2.2
@@ -0,0 +1 @@
+io_uring_enter.2
\ No newline at end of file
-- 
Ammar Faizi

