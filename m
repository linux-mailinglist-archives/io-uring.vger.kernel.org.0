Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63BD1C251B
	for <lists+io-uring@lfdr.de>; Sat,  2 May 2020 14:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgEBMMr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 2 May 2020 08:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726896AbgEBMMr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 2 May 2020 08:12:47 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB0CC061A0C
        for <io-uring@vger.kernel.org>; Sat,  2 May 2020 05:12:47 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id g12so3120081wmh.3
        for <io-uring@vger.kernel.org>; Sat, 02 May 2020 05:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=OTXw9mN8rXe77orjzGk/uMC+I6Mqctasvyrsu4HPajU=;
        b=qA9QhGMbFOIku69fXbuwdDqHADmxrunuDKIRizQOHKwmnIoKkETribV82kaEWOprSd
         C+W8wiGMQDMj+zmSa/Fwx+WCx3ohj0Yb81pHxDVBLiLQlQq5yfcVpRx9w/6SIdpzmyqS
         Lr2JbBf2DrMEx5VMcC1vKjJ+bSZwpgtaX+4Ok4GjJwhPn5Ql5pZOOAKu2twIZSaBNTkU
         FCwSi4uj7ECdAwxTYhq8YBpUFA0ZOesiQQVQvMpQaInlr2QI63MuxTebKCIWCOyHXGDW
         rJqjNzNL2NY3EFaQkfMgOu9+6A8LwUMO0/i1Ti/nW9RW8w26UNtDWjIpU20kVIbIAxIB
         XF1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OTXw9mN8rXe77orjzGk/uMC+I6Mqctasvyrsu4HPajU=;
        b=BoYqqepapfqREXyfntvqG0N7tMcf/jzQ6GShWtiYtbKAM+Js7qbteJgXBvLUNn1Tih
         Od7wjkXo2Fj9DWVaLdf06vCaKpBX6/jC+cnq++Pv+HxbhcxacsUbVgUcSe0O+vxCN15G
         JDITSQ004s/kHeaOBcnylnNM6c8N14nWovv5y1bzl2oJgqITP4F42dPax2m0RQ+OUBYf
         gFH9RjDuQzbkw6VLgQwioeA+dsghdiKsTlBacru++fv195bH3VC27TdfdkvD4mUanZwy
         lqgwUmdi0b85wPiJnD1b6ByO+F8Jr4MqE52zqBGCdNk7UElWzz6DjYIRkdD5rk5EQBDi
         7tsA==
X-Gm-Message-State: AGi0PubpT7PdoH4GFhEEQ7nKN8x6HCbE1D8wYnlXv8Jgt4FNiDO0UzXc
        8TPtBEIM9I4T78dFMKi+RaO60Q/m
X-Google-Smtp-Source: APiQypLHQrSHauLGMhi5LrwD1AVW80jN/eti78zRHbAHuuMd+TaPg6Fp8T5YuPSCyXcwRnzvteDESw==
X-Received: by 2002:a05:600c:c9:: with SMTP id u9mr4313208wmm.15.1588421565666;
        Sat, 02 May 2020 05:12:45 -0700 (PDT)
Received: from localhost.localdomain ([109.126.133.135])
        by smtp.gmail.com with ESMTPSA id m188sm3993913wme.47.2020.05.02.05.12.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 May 2020 05:12:45 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Clay Harris <bugs@claycon.org>
Subject: [PATCH liburing 2/3] update io_uring.h with tee()
Date:   Sat,  2 May 2020 15:11:28 +0300
Message-Id: <26944f9b262bad36f46b8a2a086796a9bfa68f06.1588421430.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1588421430.git.asml.silence@gmail.com>
References: <cover.1588421430.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing/io_uring.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index e48d746..a279151 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -129,6 +129,7 @@ enum {
 	IORING_OP_SPLICE,
 	IORING_OP_PROVIDE_BUFFERS,
 	IORING_OP_REMOVE_BUFFERS,
+	IORING_OP_TEE,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.24.0

