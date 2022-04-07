Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 342EB4F8008
	for <lists+io-uring@lfdr.de>; Thu,  7 Apr 2022 15:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238357AbiDGNHo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Apr 2022 09:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235552AbiDGNHn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Apr 2022 09:07:43 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E069A57141
        for <io-uring@vger.kernel.org>; Thu,  7 Apr 2022 06:05:43 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id q19so7763547wrc.6
        for <io-uring@vger.kernel.org>; Thu, 07 Apr 2022 06:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GRSpA4poIym2UWhKhGT19TNXfhY3K7r0DciZgyfZ5HE=;
        b=RJTKmYXA6uSA56qTWqCD+ChUEAxqiz9JwtG0m79otJiTXyIUCfeNb0hWdzJKReZFgx
         C/2Tw7Wyf776FLVzOcdgv6T1xs6tAR4pMxgmmdN4E/q4G5mQ9uiC3jlRdlqomr/CpM1R
         HgriMIZpyQOZO5nFudkK1U6QXERE2wjF1mW1tCUqFnwl8eFqAgf1L/+qZu/SKnM1lXWA
         zv9ClKTDOG/KvF5mrWnrLY2xc0YZvO2bI02kEBvyLhkdre+bdqkljqgG10Q6l3IEffpq
         0TO84Li2x6Os+AqiE2r47cG6wqmMCQcistr+qrN6cz+afGrkX76Wc85Uq1mBjX0Hd8Gm
         EHFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GRSpA4poIym2UWhKhGT19TNXfhY3K7r0DciZgyfZ5HE=;
        b=fID8kbkirpOTk68s0wd1WYscWEuRyC07KP0NcWCzw4mV1FpcS7fVg4vSlOI7raK1XZ
         jyer2aktpeyKnVh0NC4pSJ0TtRouigOX9OSW92c3xntSvfounIZJX2YNZwujCAW/2ZmA
         y+H28bcNBdVjY07unjKkum/asEDUTFhtCObiKS2MhCxxwYTUGoxEteobyFrjg1YOKLgw
         Pvo1fNWf9kRp8Y6JyUx8Buq7dZwNkWvSfyY8wtHMp8dFHR3llI9Mdg1x0aoXfgbyuNFB
         isvlD0TkwIwMT+Szee9Ffd5Ra7P8C8qaF4zZHlmUjIQUkrii2I/mluY58nMFdQGsTLwW
         P9YA==
X-Gm-Message-State: AOAM530RJ3QnKB/xS3g85X6cvAtHoTeD50swsqTS0FuzmJ1J7EnTKZ49
        tUinYu4bho8DnpLJzbCIikFQ82yaAfw=
X-Google-Smtp-Source: ABdhPJwlL2lCTCNbL1BgqEYGcXUFMI5JQy+rd1t2APrkNWjlM7IuX0zCJjGbebmlkjtZj1WrWgR1Gg==
X-Received: by 2002:a05:6000:1a87:b0:207:84f5:910c with SMTP id f7-20020a0560001a8700b0020784f5910cmr2995060wry.213.1649336742280;
        Thu, 07 Apr 2022 06:05:42 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.237.149])
        by smtp.gmail.com with ESMTPSA id v15-20020a056000144f00b002057eac999fsm17640306wrx.76.2022.04.07.06.05.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 06:05:41 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/2] io_uring: zero tag on rsrc removal
Date:   Thu,  7 Apr 2022 14:05:04 +0100
Message-Id: <1cf262a50df17478ea25b22494dcc19f3a80301f.1649336342.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649336342.git.asml.silence@gmail.com>
References: <cover.1649336342.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Automatically default rsrc tag in io_queue_rsrc_removal(), it's safer
than leaving it there and relying on the rest of the code to behave and
not use it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 714a3797c678..c8993a656c1f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8848,13 +8848,15 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 static int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx,
 				 struct io_rsrc_node *node, void *rsrc)
 {
+	u64 *tag_slot = io_get_tag_slot(data, idx);
 	struct io_rsrc_put *prsrc;
 
 	prsrc = kzalloc(sizeof(*prsrc), GFP_KERNEL);
 	if (!prsrc)
 		return -ENOMEM;
 
-	prsrc->tag = *io_get_tag_slot(data, idx);
+	prsrc->tag = *tag_slot;
+	*tag_slot = 0;
 	prsrc->rsrc = rsrc;
 	list_add(&prsrc->list, &node->rsrc_list);
 	return 0;
-- 
2.35.1

