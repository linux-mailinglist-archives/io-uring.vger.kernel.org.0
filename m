Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24D0A609E6B
	for <lists+io-uring@lfdr.de>; Mon, 24 Oct 2022 12:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbiJXKBZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Oct 2022 06:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbiJXKBI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Oct 2022 06:01:08 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B12C35B78E
        for <io-uring@vger.kernel.org>; Mon, 24 Oct 2022 03:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=TFV9T22WCzFLH53j+fSK1EnRaFhlvWoFpBMqq4G5o74=; b=3rcuhLFsGs30B9dex5ZxULUYbM
        EXVdg2VLX1F+dDnh4hIJ7YtidTnJ6+9PdjwYh7ragmo7KqkgLRX4qU3shby4b6z4wLyjC2FLiTYn+
        sC9d6AP6rvyDZF7JpFOpSVtEW3y9JA5Ag/W9M8k8oN6ltUja00lQimDl6gk0ie/h+nSzE5aUVwGlD
        UpdkD9PyWyTegyxxsheBPzX0My2vCNM2+Gc+ch829lFpvo5zc+MvDK+CrLKvk0Joh17iYHZ0FulNg
        JoHZpI0VnBrfV4Er1x6UbUabF6j3Vs2gT8wMf0lpqdaYlsF7qLAPwa8NIdJcWFsdgZLFp4ej1H4rM
        nrZdxjgEG9VigFvTEPS6UiuBlFkOW6O6rCDKWsGD/rvd8nqvEmX9kh97lvMjpyu8w5kmQG0DeNmrh
        SWDlLZ05L2SpgMNayDwXKluAUyK48/b/PmpfwAI4nyhAhzsqp6EsvOM6p1Ks8XVJR2xjbXE/bXWzU
        zfzf57SWpADNUav+JrmJ8nqp;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1omuGM-005VjA-Vf; Mon, 24 Oct 2022 10:00:55 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH 1/1] uapi:io_uring.h: don't force linux/time_types.h for userspace
Date:   Mon, 24 Oct 2022 12:00:39 +0200
Message-Id: <c7782923deeb4016f2ac2334bc558921e8d91a67.1666605446.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1666605446.git.metze@samba.org>
References: <cover.1666605446.git.metze@samba.org>
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
linux/time_types.h.

Fixes: 78a861b94959 ("io_uring: add sync cancelation API through io_uring_register()")
Link: https://github.com/axboe/liburing/issues/708
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 include/uapi/linux/io_uring.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 32e1f2a55b70..a2ce8ba7abb5 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -10,7 +10,16 @@
 
 #include <linux/fs.h>
 #include <linux/types.h>
+/*
+ * this file is shared with liburing and that has to autodetect
+ * if linux/time_types.h is available
+ */
+#ifdef __KERNEL__
+#define HAVE_LINUX_TIME_TYPES_H 1
+#endif
+#ifdef HAVE_LINUX_TIME_TYPES_H
 #include <linux/time_types.h>
+#endif
 
 #ifdef __cplusplus
 extern "C" {
-- 
2.34.1

