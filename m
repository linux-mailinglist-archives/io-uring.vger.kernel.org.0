Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8DBD6B2B27
	for <lists+io-uring@lfdr.de>; Thu,  9 Mar 2023 17:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjCIQuC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Mar 2023 11:50:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbjCIQtc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Mar 2023 11:49:32 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B777E63F3
        for <io-uring@vger.kernel.org>; Thu,  9 Mar 2023 08:39:14 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id h17-20020a17090aea9100b0023739b10792so2541032pjz.1
        for <io-uring@vger.kernel.org>; Thu, 09 Mar 2023 08:39:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678379954;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=14IHqzgqA+gQYwW5l/+Gjv2KMDa5LvGPA95vj5hjTR8=;
        b=ZhUDsRnieajlY9nhbPwRZkOr0dfAVA6bnk6ZxsmwK1VbNv8nupViXMpjVpNgdepEs3
         3EO4YZwfuUdZ9IR920HAostwLDw6zG0/8URL/d1Eagtfp41AJDEwsMQ3+FgwFfRpA4H9
         JTIxNFBDB7NgIk2/Zkx/FzAhC7q3yLOX1xfNkQT6vGZqpqMZJzLuLxmMqvNK1kqe2IkN
         4oMXT1cyXWpqIl7IfQbXrbC/V8jvgFJtprS0nHDl0tXjWgwPGW73dp/V4kr0RDuCtATk
         5aWcptGC1b/ZchjFg/9p/uAbwiwZCdz17BJGJb/wDYvZ6HMJ6j/7vqOu/f+liHzDqqsN
         3LHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678379954;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=14IHqzgqA+gQYwW5l/+Gjv2KMDa5LvGPA95vj5hjTR8=;
        b=DCRXKSRGVf5BkMaoRDz8ucR2m4r80I8at2Pkl5gyqxsRYWCNIEKvoixVuFBF2b+4/4
         yfIGy5Kd8p+DB9k5Py0oq47GRccUYpcbT3IQqlncUttSdbk27w1hWGcbJ7eiFzsbobKb
         MPECtckQMSX1g0i9kJmz2gY+GRwne07nYo8f3v6KeQjrLB1IRIB5p+vmi/6zNejdz0vG
         tySPKgCUlZRV43Dy3GAflvaJKmoChg2nTpIzCUn0BG9g4EEYCfgHHNrSxkJys2Tt3lTV
         FExyrTjIj4BW1ITIP1K1qbYXUNFR0B6+QIgEmA/GIdVguAjH2X5+AmPeDdFo0bJmPuL3
         TW0g==
X-Gm-Message-State: AO0yUKWKyQ5H1flyfasmHszgp6FsjiuXKNWsM2Zbp1t3F04BIslwqIF+
        xAfQexzAajscz4/199Ooz8POJwMFOWovk3CiWrkbWw==
X-Google-Smtp-Source: AK7set+fpXWwO9gN2kKmUicf/BX6Ua9pRX30vzBdydHykorMjyyvh90BYYUmdTbGxnTBbOeJ9vPZJA==
X-Received: by 2002:a17:90a:8185:b0:233:dd4d:6b1a with SMTP id e5-20020a17090a818500b00233dd4d6b1amr17252767pjn.3.1678379953742;
        Thu, 09 Mar 2023 08:39:13 -0800 (PST)
Received: from [172.20.4.229] ([50.233.106.125])
        by smtp.gmail.com with ESMTPSA id n5-20020a17090a670500b00234e6d2de3dsm163985pjj.11.2023.03.09.08.39.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Mar 2023 08:39:13 -0800 (PST)
Message-ID: <30c76605-c453-fbcf-3993-a2be689e6ad7@kernel.dk>
Date:   Thu, 9 Mar 2023 09:39:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v2] io_uring: suppress an unused warning
Content-Language: en-US
To:     Vincenzo Palazzo <vincenzopalazzodev@gmail.com>,
        io-uring@vger.kernel.org
References: <20230309125903.170857-1-vincenzopalazzodev@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230309125903.170857-1-vincenzopalazzodev@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/9/23 5:59?AM, Vincenzo Palazzo wrote:
> suppress unused warnings and fix the error that there is
> with the W=1 enabled.
> 
> Warning generated
> 
> io_uring/io_uring.c: In function ?__io_submit_flush_completions?:
> io_uring/io_uring.c:1502:40: error: variable ?prev? set but not used [-Werror=unused-but-set-variable]
>  1502 |         struct io_wq_work_node *node, *prev;

I think it'd be cleaner to just add an iterator that doesn't track
'prev' if we don't actually need it. Ala:


diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index fd1cc35a1c00..722624b6d0dc 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1499,14 +1499,14 @@ void io_free_batch_list(struct io_ring_ctx *ctx, struct io_wq_work_node *node)
 static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	__must_hold(&ctx->uring_lock)
 {
-	struct io_wq_work_node *node, *prev;
 	struct io_submit_state *state = &ctx->submit_state;
+	struct io_wq_work_node *node;
 
 	__io_cq_lock(ctx);
 	/* must come first to preserve CQE ordering in failure cases */
 	if (state->cqes_count)
 		__io_flush_post_cqes(ctx);
-	wq_list_for_each(node, prev, &state->compl_reqs) {
+	__wq_list_for_each(node, &state->compl_reqs) {
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 					    comp_list);
 
diff --git a/io_uring/slist.h b/io_uring/slist.h
index 7c198a40d5f1..0eb194817242 100644
--- a/io_uring/slist.h
+++ b/io_uring/slist.h
@@ -3,6 +3,9 @@
 
 #include <linux/io_uring_types.h>
 
+#define __wq_list_for_each(pos, head)				\
+	for (pos = (head)->first; pos; pos = (pos)->next)
+
 #define wq_list_for_each(pos, prv, head)			\
 	for (pos = (head)->first, prv = NULL; pos; prv = pos, pos = (pos)->next)
 
@@ -113,4 +116,4 @@ static inline struct io_wq_work *wq_next_work(struct io_wq_work *work)
 	return container_of(work->list.next, struct io_wq_work, list);
 }
 
-#endif // INTERNAL_IO_SLIST_H
\ No newline at end of file
+#endif // INTERNAL_IO_SLIST_H

-- 
Jens Axboe

