Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8E8520197
	for <lists+io-uring@lfdr.de>; Mon,  9 May 2022 17:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238661AbiEIPzB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 May 2022 11:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238658AbiEIPy6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 May 2022 11:54:58 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36CAD43EE2
        for <io-uring@vger.kernel.org>; Mon,  9 May 2022 08:51:03 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id c125so15766668iof.9
        for <io-uring@vger.kernel.org>; Mon, 09 May 2022 08:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BkpH5Y5FYdPWa9RPUHFmfUFNElPOGoKELSjkyhz/ZGs=;
        b=ea0qjMKxY4RWE3D3wukIhkvaNDZj9ddnWCwD+NYvxAFTiiznwrGaTsZTs6evzvObxZ
         sf4swCwHhWaLFFr6OEi2V/3+THI9LpELyx5lytMasUW7+kn+yNwKqHODEtM2QusYUpEZ
         4WWmJy5gH9nnGCUEJ8xDpkm5fyD0zokU5MFATyj4bGMV0JF/sfpxQW+HQGlevnHXW0vJ
         NSlEYqOUogWhDGL/jqtZjxCdSs5ZihM3tfORUMBNon9hZFl8On6OAYdKtNXMWHa7qvqk
         GVnqhZIu6LdMGR9uS1otq3sIyP/TM04Zr663wBVshtqS/pFtIIffVLIu/jQ6Bq4PAu6T
         D8vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BkpH5Y5FYdPWa9RPUHFmfUFNElPOGoKELSjkyhz/ZGs=;
        b=lFJe86FkLsR5an6CGXDZJTryUZOWEvy0F4RmJ/0xNqH3pL67Xl1st51ThoXVOBArBM
         LGTGeZ9HHmku2A7YJhOsHOT1ux71HgfY03qkLwnPKDcL3cMp+H4aMDg2qzubDCSa+Ggd
         2FROgzUljlSbIcxVZTf5AIcaUHKq3TXqdUJTvFSFxw7XU8O7o/8qnoyGblG3G6K0GVJ3
         cjLgs4CjZgrvNMx4T4lMhTemAGNFXweRfZmTk8AhHZEmXxkYRvoAr1CHgDknA47unh2n
         a0XubjM0f0skYSrka9SnqZpgW6rSqw/80ISLel1lsG0JSEm4sGACMfIC7lsrNlbmgkLL
         yRWQ==
X-Gm-Message-State: AOAM531LQUg6E9o2e9ATwvd4u20cV+TopklXuY9pGEwSiAr3uxnSTRsa
        hraY3U8zklqKsLerwxeSCL0yzP4xO1kz8Q==
X-Google-Smtp-Source: ABdhPJzVZDI9giEwOSS4670DT017ij1vWm1gBYUje0fHC4AG6p5GujLWUf1cKvUbYaFZZB+uVYoBSw==
X-Received: by 2002:a6b:410e:0:b0:65b:1b72:5326 with SMTP id n14-20020a6b410e000000b0065b1b725326mr1129600ioa.170.1652111462307;
        Mon, 09 May 2022 08:51:02 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id a1-20020a056638004100b0032b3a78177esm3696499jap.66.2022.05.09.08.51.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 08:51:01 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, haoxu.linux@gmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/6] io_uring: bump max direct descriptor count to 1M
Date:   Mon,  9 May 2022 09:50:54 -0600
Message-Id: <20220509155055.72735-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220509155055.72735-1-axboe@kernel.dk>
References: <20220509155055.72735-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We currently limit these to 32K, but since we're now backing the table
space with vmalloc when needed, there's no reason why we can't make it
bigger. The total space is limited by RLIMIT_NOFILE as well.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7356e80ffdbb..644f57a46c5f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -94,7 +94,7 @@
 #define IORING_SQPOLL_CAP_ENTRIES_VALUE 8
 
 /* only define max */
-#define IORING_MAX_FIXED_FILES	(1U << 15)
+#define IORING_MAX_FIXED_FILES	(1U << 20)
 #define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
 				 IORING_REGISTER_LAST + IORING_OP_LAST)
 
-- 
2.35.1

