Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 559EE600345
	for <lists+io-uring@lfdr.de>; Sun, 16 Oct 2022 22:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiJPUdI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 Oct 2022 16:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiJPUdH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 Oct 2022 16:33:07 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D8553057D
        for <io-uring@vger.kernel.org>; Sun, 16 Oct 2022 13:33:06 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a26so20862736ejc.4
        for <io-uring@vger.kernel.org>; Sun, 16 Oct 2022 13:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZjPK20Gpm06cfu/aaNkEBhOYqkMQWlW3+Fjwk493YA0=;
        b=IZtW6RZRokKotnndtoGqITMYU1czP/veWNGRhbk2d5t1HKW8Z7vu/KBU5UM6UhXmLV
         PaxPc8kujcfYXdHMlFG3m0Nc8Wgh5HSqtlX/Lu66ePiwYe+B4Rtj4GDEEWihz5576slr
         BcNqHsT/bsyOl91/7qTonqTvAOzmSUUZv+zuSmSPy+mqpyVzBsml47nQwyYJ1a/Ccyoo
         Xnfmghmv00QpojkK5aKs7QGbD4YUqa4EC/KGQ5gAeJibmtz3FzNBEeka4paj3bC7BtOM
         6S2N39VB+JVqmlqIEXTr+MpTW6+CafFwe96a30GvVpsQyjUuX0+tE+1kZjcQAOmCMZrc
         1Aeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZjPK20Gpm06cfu/aaNkEBhOYqkMQWlW3+Fjwk493YA0=;
        b=daXi/VMfFyUZ4/5CGm1uVOi2c+E8H6pXo/wFJynchfJhKnR0z0nt1PQhklt9QuyqdH
         sQkWLXdj2TqheJ9mCbixSyBQemMs758gVlvDUa9zon7My9EldpFq2AHEgmSglovfV2JE
         A47/nfQqw+uo2fLMqlNBhtSkvPN5WTG+TU58alUnpory+iJJ+60X4lVH1kWD1Xncu3bF
         fK5/XPaiMMVoyz/l4qV0hm4g7OpS/mZq3ybQyjiUi/ANehAy9DwA8YElUmQlqSvWoh0r
         djMBQdzjARKrLegLMEMAKCtsQ880juOofrX0eygJqnbrcC2TzWI5quoo6efZx77a5LYe
         UrAg==
X-Gm-Message-State: ACrzQf0+exf0X0Xj6JNXV+KpnFhHv1hln8VL1yVrDM5iHxrv5B61iMre
        QlrJ8xpbw3sD0tC024wNgy33EZp4/3Y=
X-Google-Smtp-Source: AMsMyM5OYnPGbwv2+n0FMmU9dazc7UG5KwOtjr77EZije99ZoPDCyC80u6NZV65Zl7292ivF0g2Shw==
X-Received: by 2002:a17:907:7635:b0:78d:c5e9:3e57 with SMTP id jy21-20020a170907763500b0078dc5e93e57mr6257074ejc.204.1665952384318;
        Sun, 16 Oct 2022 13:33:04 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.234.149.threembb.co.uk. [94.196.234.149])
        by smtp.gmail.com with ESMTPSA id y11-20020a1709060a8b00b00788c622fa2csm5069345ejf.135.2022.10.16.13.33.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Oct 2022 13:33:03 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 2/4] io_uring: kill hot path fixed file bitmap debug checks
Date:   Sun, 16 Oct 2022 21:30:49 +0100
Message-Id: <cf77f2ded68d2e5b2bc7355784d969837d48e023.1665891182.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1665891182.git.asml.silence@gmail.com>
References: <cover.1665891182.git.asml.silence@gmail.com>
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

We test file_table.bitmap in io_file_get_fixed() to check invariants,
don't do it, it's expensive and was showing up in profiles.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/filetable.h | 1 +
 io_uring/io_uring.c  | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/filetable.h b/io_uring/filetable.h
index 19d2aed66c72..351111ff8882 100644
--- a/io_uring/filetable.h
+++ b/io_uring/filetable.h
@@ -25,6 +25,7 @@ unsigned int io_file_get_flags(struct file *file);
 
 static inline void io_file_bitmap_clear(struct io_file_table *table, int bit)
 {
+	WARN_ON_ONCE(!test_bit(bit, table->bitmap));
 	__clear_bit(bit, table->bitmap);
 	table->alloc_hint = bit;
 }
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 18aa39709fae..6e50f548de1a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1858,7 +1858,6 @@ inline struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 	/* mask in overlapping REQ_F and FFS bits */
 	req->flags |= (file_ptr << REQ_F_SUPPORT_NOWAIT_BIT);
 	io_req_set_rsrc_node(req, ctx, 0);
-	WARN_ON_ONCE(file && !test_bit(fd, ctx->file_table.bitmap));
 out:
 	io_ring_submit_unlock(ctx, issue_flags);
 	return file;
-- 
2.38.0

