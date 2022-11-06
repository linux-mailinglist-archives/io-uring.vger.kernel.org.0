Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA34E61E6A4
	for <lists+io-uring@lfdr.de>; Sun,  6 Nov 2022 22:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbiKFVn2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 6 Nov 2022 16:43:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbiKFVn1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 6 Nov 2022 16:43:27 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D1DBC10
        for <io-uring@vger.kernel.org>; Sun,  6 Nov 2022 13:43:25 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id q9so8977239pfg.5
        for <io-uring@vger.kernel.org>; Sun, 06 Nov 2022 13:43:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fzZ6LPgUy1/VULzldZ3l8WZy9LqObKfUOIjozB0AhiM=;
        b=darlqFjsgQ8sJkz7ayxYMfdxiZf0pkIMK3dtCQDs8jY+0TTkUh5cuscajAR7AH3j/S
         H4ABS2yjTGW1omcrAvLkEbl8QaviBJ+cxCgGJE9M7/HTmQffHroZ9eXRqPXuL/vU8HJ7
         Fw17DQr6OlRZUf7DSGTSL4SoSGVHEO4KEFo0pcr4H78smv6PMwLrsP8PIe02LFXIBntw
         yqMjffX/cvaH2LGjeWI5HUfC1nUNXj5RFltiHXeTu9AjeeixG8C6hT3zw95nB8UiKK6Z
         DbHBSkmFFLVturlTPYzRSpjdJqAhBDbxBWfBk+p9w/R8bljRfLRvrqr9nQp4DszgYNMu
         ZBPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fzZ6LPgUy1/VULzldZ3l8WZy9LqObKfUOIjozB0AhiM=;
        b=zHG+0x6FnIaiH+S3suw6BI32aUjnoGNcbp5zoRTC8MDW7Q6BYs+C7+xhcKc0i9y70d
         2dkGk/pNHnQRNYmM7ErDv6ukOVumDdiYjiPETR4zWrILbiHnryRliViYTRN7Dj9GkfEA
         Khc99sLeXvvCygOgZFIy7endd7BGqIW7H/0jOUlldmUFxmnx4kBrfmyocrPyd901FxBk
         98NADWksH9diYq+Rb7At2AJO02wZItBd4GiXZh4PTfIj4TK7wOHShtJjc+CVZM1wiGY9
         WBThRsD1E4cHMzhWGNOCqaAJWJbyNoUeWyQ1FiTDYUh9Al3OX8V3T2KvU8mFDDh2lfYY
         jZKg==
X-Gm-Message-State: ACrzQf21GxtAxkdBp4E5cPzuZdtvceSSkWwBa6cM5IINe0ob8OxFIFos
        B7UOplh7THmWerW6q5nz7p5TEazlcMZbO+Ta
X-Google-Smtp-Source: AMsMyM6+3el+mtRfutQHKpcAn+dur6/dKT+vOUvzI9DZWGWg0BTQmYNS/SaN+xem1eoJHbXsVz99Pw==
X-Received: by 2002:a63:1d24:0:b0:46f:a203:13c0 with SMTP id d36-20020a631d24000000b0046fa20313c0mr35384019pgd.404.1667771004748;
        Sun, 06 Nov 2022 13:43:24 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id z11-20020a1709027e8b00b00186f81a074fsm3502735pla.290.2022.11.06.13.43.23
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Nov 2022 13:43:23 -0800 (PST)
Message-ID: <1b92a697-e886-99f0-633e-7beb8c578043@kernel.dk>
Date:   Sun, 6 Nov 2022 14:43:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: fix typo in io_uring.h comment
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Just a basic s/thig/this swap, fixing up a typo introduced by a commit
added in the 6.1 release.

Fixes: 9cda70f622cd ("io_uring: introduce fixed buffer support for io_uring_cmd")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index ab7458033ee3..2df3225b562f 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -222,7 +222,7 @@ enum io_uring_op {
 
 /*
  * sqe->uring_cmd_flags
- * IORING_URING_CMD_FIXED	use registered buffer; pass thig flag
+ * IORING_URING_CMD_FIXED	use registered buffer; pass this flag
  *				along with setting sqe->buf_index.
  */
 #define IORING_URING_CMD_FIXED	(1U << 0)

-- 
Jens Axboe
