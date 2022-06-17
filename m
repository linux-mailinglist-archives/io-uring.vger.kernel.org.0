Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0246D54F798
	for <lists+io-uring@lfdr.de>; Fri, 17 Jun 2022 14:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236185AbiFQMaJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jun 2022 08:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236539AbiFQMaI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jun 2022 08:30:08 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF0A27B08
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 05:30:07 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id h1so3737485plf.11
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 05:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=ppCjSQ2efLnLSbZITLjCgY9iOwM2HBeT8ykwHOlDaHg=;
        b=4hNdPGBZsCKrvoPWyeLETuYxlwWLN/EuAQqbvg6YhQiqVbGcXRrwy8RQgNTwY/RCIH
         E/fM8zE0hSFFl8ivfs6RQlcplXf9UL0RjR5clptNAAkK86qm4PO3R0yo4xWdVHrVj3oK
         iN8xUpO6baoWF1eC2AipDbI4gbiCTn/bMzUARde0yEb3lU3gyGSVIBddlMcqRBgSU3Bm
         U2a4wjrjheq6ZS5x6yQMdcCU3kVgb4wPdkS8x+VX2F1IRnFLg3AzRsDzLY+E2Bl0Y7fi
         y/FIZ0mhfVeE2B/34ZaTtWIMkjt3wvMwF3vj5TDs/iFaEVKMrVyEg91ZwsbBaKSAR2T7
         9hSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=ppCjSQ2efLnLSbZITLjCgY9iOwM2HBeT8ykwHOlDaHg=;
        b=NZi1ia6Azzc7Q9rZLEs895WQ7gLCX8LuYB89Fv12Vu+Muwsy26TuBKLNNkOWljSpkt
         qXkksKBmiBQRIcBCD804yug0Ynz+9SbPrZ0iyb8YoBxu3GiMOcNYvGvo3HtxlZCBjr1l
         LJEWeE4o+dsJo5m/irE8L3OO3S1TDSsx3qcBc/DeMyTHj/ToO77HOvu0w9J7YhioXEbF
         Uv8AbrGyP7dQDz9uS2tPBdME3iUXDtAu80pk7+ZGkMCYOjthhD0bpBvGj34DS/g2T8s7
         AXlYxMEIJAh6wW+nSaQ5iL0kCRTltxungW8xNTfeUapUwav7ui9OxkdZpMVjc+reKZFd
         Hgyg==
X-Gm-Message-State: AJIora+DjDb/1JKHowKg5hZHR1n7yjAI48kUdSfnsYgRy154fDLrVzBr
        uL6knfbFy0fvsgGc6ier7y7xsL+GJXkaEQ==
X-Google-Smtp-Source: AGRyM1uJOs4hcQuXC55FS+YHOKwhha7a2ST8BPQlD5Qe7YnLttgpqyqvz3Fe23VU3KhiKnFjVoTeDg==
X-Received: by 2002:a17:902:d2ce:b0:164:be8:33f9 with SMTP id n14-20020a170902d2ce00b001640be833f9mr9327694plc.8.1655469006299;
        Fri, 17 Jun 2022 05:30:06 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t13-20020a17090a5d8d00b001eaae89de5fsm5492923pji.1.2022.06.17.05.30.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jun 2022 05:30:05 -0700 (PDT)
Message-ID: <343c03ed-d56a-e575-bae6-9d015ab8b5e2@kernel.dk>
Date:   Fri, 17 Jun 2022 06:30:04 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: recycle provided buffer if we punt to io-wq
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_arm_poll_handler() will recycle the buffer appropriately if we end
up arming poll (or if we're ready to retry), but not for the io-wq case
if we have attempted poll first.

Explicitly recycle the buffer to avoid both hanging on to it too long,
but also to avoid multiple reads grabbing the same one. This can happen
for ring mapped buffers, since it hasn't necessarily been committed.

Fixes: c7fb19428d67 ("io_uring: add support for ring mapped supplied buffers")
Link: https://github.com/axboe/liburing/issues/605
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 95a1a78d799a..d3ee4fc532fa 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8690,6 +8690,7 @@ static void io_queue_async(struct io_kiocb *req, int ret)
 		 * Queued up for async execution, worker will release
 		 * submit reference when the iocb is actually submitted.
 		 */
+		io_kbuf_recycle(req, 0);
 		io_queue_iowq(req, NULL);
 		break;
 	case IO_APOLL_OK:

-- 
Jens Axboe

