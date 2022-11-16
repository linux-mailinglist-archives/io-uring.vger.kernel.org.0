Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD2CE62CAC4
	for <lists+io-uring@lfdr.de>; Wed, 16 Nov 2022 21:25:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiKPUZl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Nov 2022 15:25:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbiKPUZj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Nov 2022 15:25:39 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E69E326112
        for <io-uring@vger.kernel.org>; Wed, 16 Nov 2022 12:25:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=rntLvw8Fzns2+2VI3TUnQtEpHR+nY3Owpwunp5YuotA=; b=K95kBqDBicMp+L9ldsyFxRV5UE
        K5sTmf1qhHqWMU3e7q/vM93PjU0XaWhZYBPutbfBk4gz7mlHrjh4GIFy6RlAv4ko4k1CaZODvuBJN
        Sjz/GETc7M7Rc9yYoZXGiLhjDtYOzcujMXZNA93G2a8R/nYY1qejo+6n6yWor5v8T/uNBQMqYPpUY
        GGzHoNTeuN87j4lOXaIaOYb+C/SvhzXOfe/usxwlcIH8pYP21zNXKXEGD1oCNdujLiP2cqbbXOglH
        cpjD37lPg7JORyZoS/n9+mhYyj4cFqXqIsoC8JvOXyfS5AayMEFoFeK/ijqdvZGEzZ71yhm7aiUdD
        zCVv+PBu7ppIWVU3/NjDFyBOt168yssRbDQ7x3sSswXbev7PAqF2+MFTvAziNRh8EVso7LcwWxDB0
        IKX2td+B9a7Kar8TvlEghZrTo7xSsjuxEWd1thbWkAOc7QqNGaJ5cY2ll5mhW3UZxidcoBbbZ7kpZ
        RG5ox5Z5/qW84rUSb9u9Rg1S;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1ovOyW-008wqq-Fy; Wed, 16 Nov 2022 20:25:36 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH v2 1/1] uapi:io_uring.h: allow linux/time_types.h to be skipped
Date:   Wed, 16 Nov 2022 21:25:24 +0100
Message-Id: <7071a0a1d751221538b20b63f9160094fc7e06f4.1668630247.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1668630247.git.metze@samba.org>
References: <cover.1668630247.git.metze@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

include/uapi/linux/io_uring.h is synced 1:1 into
liburing:src/include/liburing/io_uring.h.

liburing has a configure check to detect the need for
linux/time_types.h. It can opt-out by defining
UAPI_LINUX_IO_URING_H_SKIP_LINUX_TIME_TYPES_H

Fixes: 78a861b94959 ("io_uring: add sync cancelation API through io_uring_register()")
Link: https://github.com/axboe/liburing/issues/708
Link: https://github.com/axboe/liburing/pull/709
Link: https://lore.kernel.org/io-uring/20221115212614.1308132-1-ammar.faizi@intel.com/T/#m9f5dd571cd4f6a5dee84452dbbca3b92ba7a4091
CC: Jens Axboe <axboe@kernel.dk>
Cc: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 include/uapi/linux/io_uring.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 551e75908f33..082020257f19 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -10,7 +10,15 @@
 
 #include <linux/fs.h>
 #include <linux/types.h>
+/*
+ * this file is shared with liburing and that has to autodetect
+ * if linux/time_types.h is available or not, it can
+ * define UAPI_LINUX_IO_URING_H_SKIP_LINUX_TIME_TYPES_H
+ * if linux/time_types.h is not available
+ */
+#ifndef UAPI_LINUX_IO_URING_H_SKIP_LINUX_TIME_TYPES_H
 #include <linux/time_types.h>
+#endif
 
 #ifdef __cplusplus
 extern "C" {
-- 
2.34.1

