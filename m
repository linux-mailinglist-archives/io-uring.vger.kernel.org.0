Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3D5262A428
	for <lists+io-uring@lfdr.de>; Tue, 15 Nov 2022 22:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbiKOVao (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Nov 2022 16:30:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238722AbiKOVal (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Nov 2022 16:30:41 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 224E0A1AA;
        Tue, 15 Nov 2022 13:30:39 -0800 (PST)
Received: from localhost.localdomain (unknown [182.253.183.117])
        by gnuweeb.org (Postfix) with ESMTPSA id 65640814D6;
        Tue, 15 Nov 2022 21:30:36 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1668547839;
        bh=CdwAKtOIgZ+7hsrmxIO9J1z+CoWeq0T4ndm7OWRS0po=;
        h=From:To:Cc:Subject:Date:From;
        b=tgk/9BXTYsP/qUfuX+Yn8uf1mQi81HjVXh1cAPZxH8zUVeMTZXqelaSPgicuVhG9O
         GTJE1KRaixi3uVy3GUK2AOofI+UhYC8Qkq2hsr9FgjFWdNO5SwX8uT0uP3n192vsUY
         B0Mo9NUyPnw2XyjBH6J9cRDJXgDM9yk9VxpO7HJXdbLMUvrJ4Z3L1UPvI05e/yRZMd
         dedI9/fu2vlvEfMJWbdonOxstpMI1XxFu3KoyrhWFnWZ3RR8YDHmOaWG0UOPEgKWXH
         Gpl8SfyZh+uJn3W1ofvb9lLnDuj8JwbijHiuaEGn3Vs587T0gw8iAFFteHIQ0SEcFk
         NwJnlywLYtsRQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Metzmacher <metze@samba.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH v1 0/2] io_uring uapi updates
Date:   Wed, 16 Nov 2022 04:29:51 +0700
Message-Id: <20221115212614.1308132-1-ammar.faizi@intel.com>
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

io_uring uapi updates:

1) Don't force linux/time_types.h for userspace. Linux's io_uring.h is
   synced 1:1 into liburing's io_uring.h. liburing has a configure
   check to detect the need for linux/time_types.h (Stefan).

2) Do not use a zero-size array because it doesn't allow the user to
   compile an app that uses liburing with the `-pedantic-errors` flag:

       io_uring.h:611:28: error: zero size arrays are an extension [-Werror,-Wzero-length-array]

   Replace the array size from 0 to 1 (me).

Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Ammar Faizi (1):
  io_uring: uapi: Don't use a zero-size array

Stefan Metzmacher (1):
  io_uring: uapi: Don't force linux/time_types.h for userspace

 include/uapi/linux/io_uring.h | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)


base-commit: 5576035f15dfcc6cb1cec236db40c2c0733b0ba4
-- 
Ammar Faizi

