Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9EF31A1AD
	for <lists+io-uring@lfdr.de>; Fri, 12 Feb 2021 16:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhBLPaK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Feb 2021 10:30:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbhBLPaI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Feb 2021 10:30:08 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E8AC0613D6
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 07:29:28 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id m17so9657198ioy.4
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 07:29:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=OlawhdIzqElNYi0WJg9VOgu7ttdlsXpsJApss/hqSr0=;
        b=yQBt+SAxFmErXBHl5u+KHisF4KRjJFV5rHWNxXvy45oSudkxUwax+wWjJ8hjbPVD2l
         KT4bQIRfmpjgtndTToRCmc6N3IEW1q3/7iOq8HyRQTAsOcByWlVZTIjNcWj7QkM37NWw
         gP3MFOOGxU0CQLuchR8WB2fhQuqYiJMMWvSmKn08IvahmZs/mYvj7sSNhhZTGEeT7pV9
         kehlfxBaSVZNIbwYTNFljc3dSbjaedkC/gdLtgtphHB/e5eFVe5FrzAIbVLLkrLwoN2i
         AUlbo9TQ2Mvrxpd6SRZtldDcioDntK4+MAKT4fk7pNpn3IBD3HxGdW4BEPYQtENX2l44
         V0Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=OlawhdIzqElNYi0WJg9VOgu7ttdlsXpsJApss/hqSr0=;
        b=drsDICKjYR/wRC/wwpeVOsC8ixotCuwj0ypuC4Blp2897hZMdMhZComWkBhVApoaNe
         7rT7I7brmBGAIJ7t9AmSRKglsfFI43Xdnv7DPIBdwswGgCXxCFe+QA45MhFjqtFh4854
         KRLGrx+hN7rGa6EfmF7PwCTJS/Z7Mp83+9H2+Vgi9IQXwgBRXIxQ2YSXVuD70i78vAzz
         ydECO7am2i77kS3ZtvwvpZwyYtsU3j+reG+cS+yels6BhqsbR0+pwLu24Sp+vWof525u
         2zl0dqUTtxxkdvLWslII0q9VgNAGXT4uIw+e7MaNQn1o6JuuhP5j7Q/yQd896OL0npoV
         jsHw==
X-Gm-Message-State: AOAM531iUd2FW1DR+LpD/qiw+sfvHDT8gHyZkzSpC4dE4p78jdSR+dte
        ME1GsrU4CPl+424l2r67NwSBVGt/oXu2gwkm
X-Google-Smtp-Source: ABdhPJyvykF2C21BwWjByCn7lEgFjKtyVIDGzhFAhG7pgWOSwpZ8s9h+LA+A/v4JUifadXEfS4TleA==
X-Received: by 2002:a05:6638:1928:: with SMTP id p40mr3207670jal.3.1613143767524;
        Fri, 12 Feb 2021 07:29:27 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id c19sm4595472ile.17.2021.02.12.07.29.27
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 07:29:27 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: move submit side state closer in the ring
Message-ID: <21532b0e-0054-169c-9e3a-7d72c19b5f7c@kernel.dk>
Date:   Fri, 12 Feb 2021 08:29:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We recently added the submit side req cache, but it was placed at the
end of the struct. Move it near the other submission state for better
memory placement, and reshuffle a few other members at the same time.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index cd9c4c05f6f5..8be7a24aa10e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -346,6 +346,13 @@ struct io_ring_ctx {
 		struct io_uring_sqe	*sq_sqes;
 	} ____cacheline_aligned_in_smp;
 
+	struct {
+		struct mutex		uring_lock;
+		wait_queue_head_t	wait;
+	} ____cacheline_aligned_in_smp;
+
+	struct io_submit_state		submit_state;
+
 	struct io_rings	*rings;
 
 	/* IO offload */
@@ -413,11 +420,6 @@ struct io_ring_ctx {
 		struct eventfd_ctx	*cq_ev_fd;
 	} ____cacheline_aligned_in_smp;
 
-	struct {
-		struct mutex		uring_lock;
-		wait_queue_head_t	wait;
-	} ____cacheline_aligned_in_smp;
-
 	struct {
 		spinlock_t		completion_lock;
 
@@ -441,9 +443,10 @@ struct io_ring_ctx {
 	struct list_head		rsrc_ref_list;
 	spinlock_t			rsrc_ref_lock;
 
-	struct work_struct		exit_work;
 	struct io_restriction		restrictions;
-	struct io_submit_state		submit_state;
+
+	/* Keep this last, we don't need it for the fast path */
+	struct work_struct		exit_work;
 };
 
 /*

-- 
Jens Axboe

