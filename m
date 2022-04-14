Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35295501E84
	for <lists+io-uring@lfdr.de>; Fri, 15 Apr 2022 00:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347114AbiDNWoe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Apr 2022 18:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239245AbiDNWoe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Apr 2022 18:44:34 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1BDC6B69
        for <io-uring@vger.kernel.org>; Thu, 14 Apr 2022 15:42:08 -0700 (PDT)
Received: from integral2.. (unknown [36.80.217.41])
        by gnuweeb.org (Postfix) with ESMTPSA id A2CFD7E3AD;
        Thu, 14 Apr 2022 22:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1649976128;
        bh=o1PbIHmcgO+A22sheM0mAyRO/gvPxoZA82Pcbth3ySo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gcDMwNhgJNYRQ/FZgsnP6vPV5OtKtF0qboIYobJOpc6SgOGXssPel58noh2L0zoNW
         YBoax15i5YGKrS+yGby6V1wVZI8B2eom6cPgjcgz0jAz0+hrcgkc5F6mUONWosnEIU
         hLcwx5iBG5mSda7J9TfhahKtOf2nwLiHpEOYiWaHyNSV2eGqsjKTBILv3MjjBeubl8
         zNCMxGBaLbW2TrwZ6q/TFOn+Z8sZkO5A15OaLBxBjJKTVRBpj0+8sjTkP5y0DshnJg
         CPBV6txLMlvDVVwLNBeYmdBqGd2+FeA/u7zCpUsOcciUfinhfkvTBGgH0iGbfTDGnZ
         K5yHnQiImX7EA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Subject: [PATCH liburing 1/3] arch/syscall-defs: Use `__NR_mmap2` instead of `__NR_mmap` for x86 32-bit
Date:   Fri, 15 Apr 2022 05:41:38 +0700
Message-Id: <20220414224001.187778-2-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220414224001.187778-1-ammar.faizi@intel.com>
References: <20220414224001.187778-1-ammar.faizi@intel.com>
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

A preparation to add x86 32-bit native syscall support for the nolibc
build. On x86 32-bit, the __NR_mmap maps to sys_old_mmap:

  long sys_old_mmap(struct mmap_arg_struct __user *arg);

which only receives one argument and is not suitable with the canonical
mmap() definition we use. As such, use __NR_mmap2 that maps to
sys_mmap_pgoff:

  long sys_mmap_pgoff(unsigned long addr, unsigned long len,
                      unsigned long prot, unsigned long flags,
                      unsigned long fd, unsigned long pgoff);

Note: For __NR_mmap2, the offset must be shifted-right by 12-bit.

Co-authored-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/arch/syscall-defs.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/src/arch/syscall-defs.h b/src/arch/syscall-defs.h
index f79f56a..1e8ae1b 100644
--- a/src/arch/syscall-defs.h
+++ b/src/arch/syscall-defs.h
@@ -6,8 +6,15 @@
 static inline void *__sys_mmap(void *addr, size_t length, int prot, int flags,
 			       int fd, off_t offset)
 {
-	return (void *) __do_syscall6(__NR_mmap, addr, length, prot, flags, fd,
-				      offset);
+	int nr;
+
+#if defined(__i386__)
+	nr = __NR_mmap2;
+	offset >>= 12;
+#else
+	nr = __NR_mmap;
+#endif
+	return (void *) __do_syscall6(nr, addr, length, prot, flags, fd, offset);
 }
 
 static inline int __sys_munmap(void *addr, size_t length)
-- 
Ammar Faizi

