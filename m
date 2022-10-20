Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 546A460551F
	for <lists+io-uring@lfdr.de>; Thu, 20 Oct 2022 03:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbiJTBnn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Oct 2022 21:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbiJTBnm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Oct 2022 21:43:42 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A0B1D1AA5
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 18:43:41 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id z97so27768035ede.8
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 18:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oahsLGuUWEVpsNcRBCatufFOnEuT47UKOe02aPsu6Vg=;
        b=pixuOYghgjQBw+OBR7JoIofGVn75LyFAeiXHdP5Sy5XgGFgiKqJWP2s7vkZumZVVdt
         P9FvWjE2YBkws61e18+J0KiJnvH7nvUFHA58rfRHoCDy/mFbzMBCO4llw27l9CFxQouJ
         tj4Pcs3ICnd94fuELb5bZs7oFiWvohJqr8MGZb581NzWaBzYVgHsphXkktBvXLah2kgE
         ndqpoojKlNwEA+cOsHUaO3zAP1lnk1zvQmDmsIbP/YGd0LINAz8Hei1lUmg/6Ov+nhCn
         n44Pa8HOQQ6PK9Z349lF8gNE/ZQ6+2adpvjEbm9wQ2D/+tsGnGhK1izLqaW97jH21VDB
         c9zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oahsLGuUWEVpsNcRBCatufFOnEuT47UKOe02aPsu6Vg=;
        b=iHUoiu8GrvAXrwPA5o59VlSckJV5feawWcTn21ZXcVO8JpYgo44qEOFP5FK9EHnoKc
         0HLJZW1EBw36jcYiK32rj2sPbrD3DoR0k598IUllzURknZqAQbBGgkOAxuDZS/JboRTS
         /nC7qQ8SV0wmOAMMtf0Mq3iO099bhHpvCaSQm98s5nwFnFBGgwl8ZkKJ4gl9QrqWGV2w
         rIwe4KawH/VeIoWEpbp3/iLEja9X0VW/VletREqxeBwDlPLgqpNzm6wAksTU5fEGnI9I
         Bthhuw9Z8lwrNB69NxPtP+jOcY3hbliWhemJraKMDd0AP7NFzJk5gjSYhiQVLkOauW8c
         ZYsw==
X-Gm-Message-State: ACrzQf0wY+wVn06q99bBN3aKtJ8QB90I9EJ01YpViXi1r7XBiHl4X7jx
        vcjj+Tl1h2I1a4hiBA5LInLEuwybBpc=
X-Google-Smtp-Source: AMsMyM67CzsXWbWAQqSl+T9pd21J2uD/IIyZL6a0DREbqiqsVknCPyK0OAjJDyRe2kg1XfWNySPL1Q==
X-Received: by 2002:a05:6402:11ce:b0:45c:a364:2c3d with SMTP id j14-20020a05640211ce00b0045ca3642c3dmr10231999edw.204.1666230219909;
        Wed, 19 Oct 2022 18:43:39 -0700 (PDT)
Received: from 127.0.0.1localhost (94.197.72.2.threembb.co.uk. [94.197.72.2])
        by smtp.gmail.com with ESMTPSA id g16-20020a170906539000b0073d5948855asm9695530ejo.1.2022.10.19.18.43.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 18:43:39 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Stefan Metzmacher <metze@samba.org>
Subject: [PATCH for-6.1 2/2] io_uring/net: fail zc sendmsg for unsupported protocols
Date:   Thu, 20 Oct 2022 02:42:36 +0100
Message-Id: <0f5e5b81ab680649bf56f025da94497f3f6a3f53.1666229889.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1666229889.git.asml.silence@gmail.com>
References: <cover.1666229889.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The previous patch fails zerocopy send requests for protocols that don't
support it, do the same for zerocopy sendmsg.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/net.c b/io_uring/net.c
index 28127f1de1f0..735eec545115 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1160,6 +1160,8 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 	sock = sock_from_file(req->file);
 	if (unlikely(!sock))
 		return -ENOTSOCK;
+	if (!io_sock_support_zc(sock))
+		return -EOPNOTSUPP;
 
 	if (req_has_async_data(req)) {
 		kmsg = req->async_data;
-- 
2.38.0

