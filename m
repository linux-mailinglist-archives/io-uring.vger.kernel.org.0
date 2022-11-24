Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC8F6371DA
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 06:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiKXFqi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 00:46:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiKXFqh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 00:46:37 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55067C6885
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 21:46:36 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.240])
        by gnuweeb.org (Postfix) with ESMTPSA id 130F881352;
        Thu, 24 Nov 2022 05:46:32 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1669268795;
        bh=TWnO8ccZT8DwY8edMo6cXHYw//1oIyJ9rAXDe9m6Dqc=;
        h=From:To:Cc:Subject:Date:From;
        b=FoiQuNUuEQ1S5JhHD+51oxyw3/0gE08+DCLA81s3vk91rp23XzQ3fQxqDB9Hw0AKR
         abMikWm3OeWtWL5jWGNj8WiaF59XKbfuoSK4S1VkWTDdHlFF6RmreNfMsfIncqckoF
         ea5fTJxK8J5dXP7hxt0e6TQAgT0GolD6TOQAvZ0odxYl1VVDfBIY8EzpXRgt5W0Mm6
         5P92YiuYBAGDKMHiCz0iaLdiA2ORlyVq76UZCg3pJ8Lv/5ytb+2kNe0x/fBG2z8dss
         pCj/3oMXNd8t3naRkuJrNVZJfmFULb3fioF/+djgtmkrhHMRR8twdkWn2vr6QBvPhG
         yqX/rEZGTNdrg==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Gilang Fachrezy <gilang4321@gmail.com>, kernel@vnlx.org
Subject: [RFC PATCH liburing v1 0/2] Fix memset() issue and simplify function naming
Date:   Thu, 24 Nov 2022 12:46:14 +0700
Message-Id: <20221124054345.3752171-1-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
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

Hi Jens,

On top of "remove useless branches" series. This is an RFC for
liburing nolibc. There are two patches in this series.

## Patch 1: A fix for memset() issue.

liburing has its own memset() in nolibc.c. liburing nolibc can be
linked to apps that use libc. libc has an optimized version of
memset() function. Alviro reports that he found the memset() from
liburing replaces the optimized memset() from libc when he compiled
liburing statically. When we statically link liburing, the linker will
choose the statically linked memset() over the dynamically linked
memset() that the libc provides.

Change the function name to __uring_memset() and define a macro
memset() as:

    #define memset(PTR, C, LEN) __uring_memset(PTR, C, LEN)

when CONFIG_NOLIBC is enabled. This we don't have to touch the
memset() callers.


## Patch 2: Simplify function naming.

Define malloc() and free() as __uring_malloc() and __uring_free() with
macros when CONFIG_NOLIBC is enabled. This way the callers will just
use malloc() and free() instead of uring_malloc() and uring_free().

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Ammar Faizi (2):
  nolibc: Do not define `memset()` function in liburing
  nolibc: Simplify function naming

 src/lib.h    | 21 +++++----------------
 src/nolibc.c |  2 +-
 src/setup.c  |  6 +++---
 3 files changed, 9 insertions(+), 20 deletions(-)


base-commit: 8fc22e3b3348c0a6384ec926e0b19b6707622e58
prerequisite-patch-id: d74c76e906701902456e2b19f23c100f38f13326
prerequisite-patch-id: bd6f97f77c8f99bd374cde916f97d6223bcbfa33
prerequisite-patch-id: 7c0f399d75e806786b8a7da4d6e23bdb62876710
prerequisite-patch-id: c087dd983f1732fcb9aad8e5b20baf8b9350a935
prerequisite-patch-id: f22f5b7bf9443839ee5bdb5a162c7c7c723a87eb
-- 
Ammar Faizi

