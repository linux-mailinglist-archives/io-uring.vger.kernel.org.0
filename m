Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52022667A4F
	for <lists+io-uring@lfdr.de>; Thu, 12 Jan 2023 17:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232632AbjALQGY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Jan 2023 11:06:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232105AbjALQGA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Jan 2023 11:06:00 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F308255A0;
        Thu, 12 Jan 2023 07:57:29 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.184])
        by gnuweeb.org (Postfix) with ESMTPSA id 828207E73D;
        Thu, 12 Jan 2023 15:57:26 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1673539049;
        bh=yBIS9FwtQ5Dko+wK3qpwtAbxSv3Mr7MwLjxCXmCrwJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VRhTJJtT7xipuhKIcbDWNpa3bZwFbtObAXw6wF+Dl+VcaCdXtCRJDpaQjyXtKcP1L
         9MUhrW916qnhV41VTKo5o3gNvwdJpeJjB5nDF709zKVO66FWKM43sw6/diSDuWMNMt
         kCPR9m2ypRGV41EdZBzkv5dxdl4h71twSrN2QYx6ZKkHsGI9kvTXO95OmCRvn2IuJ+
         WkaEVZNrIzH1D8EOgV/FcMMwZTMpV38+FSDnLYFmtOi+NP4Ap4tRRj8pUSYHDqhLKV
         mkpFfCm20bcqHPVUKmRyP9ipUMp/rwCGCUmK+bCFnEaPRO+kaGYkAikF63mlJ/lOsE
         BLAEZ/DRiV/iQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Breno Leitao <leitao@debian.org>,
        Christian Mazakas <christian.mazakas@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        VNLX Kernel Department <kernel@vnlx.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v1 3/4] liburing.h: 's/is adjust/is adjusted/' and fix indentation
Date:   Thu, 12 Jan 2023 22:57:08 +0700
Message-Id: <20230112155709.303615-4-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230112155709.303615-1-ammar.faizi@intel.com>
References: <20230112155709.303615-1-ammar.faizi@intel.com>
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

  - Fix a typo: 's/is adjust/is adjusted/'.

  - Fix indentation.

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 src/include/liburing.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index cc3677e..c7139ef 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -388,8 +388,8 @@ IOURINGINLINE void io_uring_prep_rw(int op, struct io_uring_sqe *sqe, int fd,
  * @param off_in If fd_in refers to a pipe, off_in must be (int64_t) -1;
  *		 If fd_in does not refer to a pipe and off_in is (int64_t) -1,
  *		 then bytes are read from fd_in starting from the file offset
- *		 and it is adjust appropriately;
- *               If fd_in does not refer to a pipe and off_in is not
+ *		 and it is adjusted appropriately;
+ *		 If fd_in does not refer to a pipe and off_in is not
  *		 (int64_t) -1, then the  starting offset of fd_in will be
  *		 off_in.
  * @param off_out The description of off_in also applied to off_out.
-- 
Ammar Faizi

