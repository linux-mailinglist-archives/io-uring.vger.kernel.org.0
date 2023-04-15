Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA7246E329D
	for <lists+io-uring@lfdr.de>; Sat, 15 Apr 2023 18:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjDOQ6h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Apr 2023 12:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjDOQ6h (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Apr 2023 12:58:37 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBADC1FCC;
        Sat, 15 Apr 2023 09:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1681577913;
        bh=0CTGm3I05CdleUvat9354L/5PXgDh5WQkTscUXC526A=;
        h=From:To:Cc:Subject:Date;
        b=OZNx5exOSPxB0aj0old1pSPogFasDneCuuGhSzLyUwr0dufDNf3+Uup2xFC3oPDY3
         R9EP8pnRcJdjHViTWSTmYiRXfSzfO8QvTZsLfTRkr2L+YXa+Uv6u3DKYS4/R400i6D
         D83TrROv1h9lD6aw+0pQ+cr9QMZ5F9RQZUYvNijJ2U24FF5isgEqv2ubLl/AAJLF+2
         ljs40Tvr3bfXtt0tFsKyN7mBJRG0LaOc7iSeZnZWDq/MUEykCBuvtC64NArbx0E2fT
         MHl5BC01vbGmZYb04ovExeRJuc/LNoYMx3l12BLDw9tnuI9l+wl1gde/XmzdpBgDc/
         Tq0LlazBnLl+w==
Received: from localhost.localdomain (unknown [182.253.88.211])
        by gnuweeb.org (Postfix) with ESMTPSA id 3DE3B2450ED;
        Sat, 15 Apr 2023 23:58:29 +0700 (WIB)
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [RFC PATCH liburing v1 0/2] io_uring sendto
Date:   Sat, 15 Apr 2023 23:58:19 +0700
Message-Id: <20230415165821.791763-1-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

There are two patches in this series. The first patch adds
io_uring_prep_sendto() function. The second patch addd the
manpage and CHANGELOG.

Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Ammar Faizi (2):
  liburing: Add `io_uring_prep_sendto()`
  man: Add `io_uring_prep_sendto()`

 CHANGELOG                  |  1 +
 man/io_uring_prep_send.3   | 31 +++++++++++++++++++++++++++++++
 man/io_uring_prep_sendto.3 |  1 +
 src/include/liburing.h     | 25 +++++++++++++++++--------
 src/liburing-ffi.map       |  1 +
 5 files changed, 51 insertions(+), 8 deletions(-)
 create mode 120000 man/io_uring_prep_sendto.3


base-commit: 4fed79510a189cc7997f6d04855ebf7fb66cc323
-- 
Ammar Faizi

