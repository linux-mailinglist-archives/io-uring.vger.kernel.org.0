Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 188C95099AC
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 09:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385855AbiDUH4R (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 03:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386253AbiDUH4Q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 03:56:16 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C6813F78
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 00:53:27 -0700 (PDT)
Received: from integral2.. (unknown [36.72.215.21])
        by gnuweeb.org (Postfix) with ESMTPSA id F2C8B7E3B2;
        Thu, 21 Apr 2022 07:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1650527606;
        bh=Mt2VRO253xQa0r8ambVsnyMeAGCxEtdzWWUh9awIb8A=;
        h=From:To:Cc:Subject:Date:From;
        b=XQ04ABI0E7ebJi6gecpvmfIU3eFH2bRu1YaJoLyGb+ZjFADswWQ5GemrjHT3LhdCj
         FiNVFJWq2iM25olc0EsgVyFw50BkVIXGlLbcMW5a+wTtIBh9q0Dr+/a3z/XG6XQ99C
         7qJeigSDGieQtsGGDnCBUrqNVzTxLz6CUhNt7pNr7ZvoT0NqkUhIgfgBy/XNw0St4P
         OC+foJFyDBLocvKboojcjI4S430+uSJ20Xh2/QdQNM+2TASyuB9Aw3zXyFtWZJj5TG
         1PTBDeCnOPKLOkLHw4ZZuRDxDyTYBfHUyc2TvJ3ehdlj9OdT4fPtt3HcEgVQpPwElS
         TAJ7tNYnSy7DA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH liburing] arch/x86/syscall: Remove TODO comment
Date:   Thu, 21 Apr 2022 14:52:30 +0700
Message-Id: <20220421075205.98770-1-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.32.0
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

nolibc support for x86 32-bit has been added in commit b7d8dd8bbf5b855
("arch/x86/syscall: Add x86 32-bit native syscall support"). But I
forgot to remove the comment that says "We can't use CONFIG_NOLIBC for
x86 (32-bit)".

Remove it.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Hi Jens,

Hopefully, this is the last x86 changes before v2.2 release.

 src/arch/x86/syscall.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/src/arch/x86/syscall.h b/src/arch/x86/syscall.h
index 8cd24dd..43c576b 100644
--- a/src/arch/x86/syscall.h
+++ b/src/arch/x86/syscall.h
@@ -144,12 +144,6 @@
 
 #else /* #if defined(__x86_64__) */
 
-/*
- * For x86 (32-bit), fallback to libc wrapper.
- * We can't use CONFIG_NOLIBC for x86 (32-bit) at the moment.
- *
- * TODO: Add x86 (32-bit) nolibc support.
- */
 #ifdef CONFIG_NOLIBC
 /**
  * Note for syscall registers usage (x86, 32-bit):
-- 
Ammar Faizi

