Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60ED7169A31
	for <lists+io-uring@lfdr.de>; Sun, 23 Feb 2020 22:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgBWVRl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 Feb 2020 16:17:41 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34259 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbgBWVRl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 Feb 2020 16:17:41 -0500
Received: by mail-pl1-f194.google.com with SMTP id j7so3190352plt.1
        for <io-uring@vger.kernel.org>; Sun, 23 Feb 2020 13:17:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=GSovxHW4tOdoJ683vSQQXXgMv5/NHs+CXI+2wzuw1w8=;
        b=ea4cK67ERkWZzjnN3J8Caqo0LMJ5chOk3y0jR9Kt9716umGiOYDPBfq5I9E2RRneTC
         +U0PA4N7eszBB1RYSUAmCFIDj5bSN/2R47nK6DwQT86fn3Q2KV9H/jeef2MLD7C3IeoC
         b3v+/xvNLMqS4ACts0TYukKSbDid/3kvy0jZXlGkZbtRA6H239W9teyQ0nnr9QjZBDZ3
         ao+8q5eNmF15PaVGU+pNIvWdm2XSQcGrqo6qAks9f408xNrkkhEXt4WFSlUzePG1pkaA
         USTfNqC9D5gFXr+/cZyLdaOzQo4Z0jJo1kbquOq15/1q+ObmGeXE0/i2FM9vfna+RPMT
         5KjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=GSovxHW4tOdoJ683vSQQXXgMv5/NHs+CXI+2wzuw1w8=;
        b=P3qY1aLDLZ09iEH+UsLua+3sSgOsXLYNnoMWtw61kFaOsSOLOeDRRWuV5e7jPTIhTf
         YCjsElBAFEnaumuNaOQdV/ydTabHkja6QyrZ6+lZrAqnMsQF4YBQD8QGZ5hBnzqpEJhc
         BQkWRUKBPG0bJNWfBMODpYvOdT5VAN+HOdgNwhN53pUddGWhe0dvbq2LjDe99y3eAEbO
         kNW2u7fNXJfUBgGtYAIKExCsZPJR1YEmyDzyNBbkTlr+sLxjgjY9kCh8KshoUAOYuY//
         HJdnIz1ozAzmLzd3KWuA8ZjPZqHXluTXvXzhM7VHHO7OIqalysT5ZwDpHz124A/+ztr4
         9j+g==
X-Gm-Message-State: APjAAAVHCwO79qCB5lJtXgRAR2e9bB0siXLLUpgPeP01tMr2TwReu3F/
        g/prALwJdWL+W5ltDU31udl2ohWlKB8=
X-Google-Smtp-Source: APXvYqyfXTvTdJ9HHJahv8XmWXXvwyGEZse0WISjY2GJtfw2wVi0fawmZVav8xVt6d/OX+hAP5wl/A==
X-Received: by 2002:a17:90a:8c8a:: with SMTP id b10mr16843531pjo.51.1582492659278;
        Sun, 23 Feb 2020 13:17:39 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id g24sm9909818pfk.92.2020.02.23.13.17.38
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Feb 2020 13:17:38 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: fix personality idr leak
Message-ID: <a77e7987-0b1b-a01a-bd31-264c1179816c@kernel.dk>
Date:   Sun, 23 Feb 2020 14:17:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We somehow never free the idr, even though we init it for every ctx.
Free it when the rest of the ring data is freed.

Fixes: 071698e13ac6 ("io_uring: allow registering credentials")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7d0be264527d..d961945cb332 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6339,6 +6339,7 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_sqe_buffer_unregister(ctx);
 	io_sqe_files_unregister(ctx);
 	io_eventfd_unregister(ctx);
+	idr_destroy(&ctx->personality_idr);
 
 #if defined(CONFIG_UNIX)
 	if (ctx->ring_sock) {

-- 
Jens Axboe

