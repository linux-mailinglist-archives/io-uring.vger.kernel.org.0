Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1950477D121
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 19:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238879AbjHORdd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 13:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238938AbjHORd2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 13:33:28 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C671BDB
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 10:33:26 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-997c4107d62so752360266b.0
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 10:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692120805; x=1692725605;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f2DEBEI1Rhro87I5c331VMzG9L/kWUItjuQZp5E+Z+g=;
        b=ejf2GKyEy/7WZjyKtAFJm/6sXYwHJQFvUghKceSKy4W3j0uEv+XRF+JQ0JWkLm7rzk
         QNY3mrEi8x6SykC+30LxshTIz8kqsqhcgwQExZAFIk3VzadUfL51l88yakZXSLuLRcrh
         BcZ8DeaVS7uwiR4rZ4y1tLGB4kD01WjZDYcOTh936FAaZfNrlvuk4mEdYZLRKaRH0zZb
         HWXQ+T+7HJrLy+tQac3LbywJ+EmdsPZ5MH5tJHAUIHfSwwikUnSJV3jUIb1DpIF4cqD8
         JH48Ssn4Pc1CF8Tixa8XrUAwLI0f6FFatOtrI9oxvL2u2R0yJy2Lnvuw7JrgaD2DjlXS
         z95w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692120805; x=1692725605;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f2DEBEI1Rhro87I5c331VMzG9L/kWUItjuQZp5E+Z+g=;
        b=lVbRjNh64UDgGz1dejesSEjqxP90NSvD3OeXUj1TYvktrUH2Abx91lIn8LSlHyjL4e
         ONW+CF+LpGdAfWmkfavtjZKYcpaC46ECPNk29ApkAZROIX+Xd7Z7hm9eeCFjalNTeHfa
         MpG64hBz5mw0JA/cydQxxMRHukKmjC7CKBotVebuh/vVZQMAQSEDvX1QnqvZGKCyjrcH
         EnU3yOZdgD1DaFmNoEL93Xy5WWflbi19Nkw03uIHRG7rsphjtzbGlIWSCvoVVC1EyWuH
         Ei0epo3zAPJ3f0vHf/8yJwKmurorFSX9aII7DtFe8PpGwhai1T8+8gxgADTq248ltkX9
         38Gg==
X-Gm-Message-State: AOJu0YzNkl4sHmbVsLI4sx7OGOyHJ3rJxVOoDNXiz7Eiydf+8tIjq5M+
        NUg5wROWguvYbbA1WEDxHvTKVknokXQ=
X-Google-Smtp-Source: AGHT+IFQvIo3cJEdYao0O7NxA+FzfLBXzmi4zuUDrNDtZ4odxA3PfR+U+VmLXP+mE6lzj6gHULvA3A==
X-Received: by 2002:a17:906:3f12:b0:99d:dfd:a5ba with SMTP id c18-20020a1709063f1200b0099d0dfda5bamr11423291ejj.43.1692120805121;
        Tue, 15 Aug 2023 10:33:25 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:6d35])
        by smtp.gmail.com with ESMTPSA id kk9-20020a170907766900b0099cc36c4681sm7269878ejc.157.2023.08.15.10.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Aug 2023 10:33:24 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 16/16] io_uring: force inline io_fill_cqe_req
Date:   Tue, 15 Aug 2023 18:31:45 +0100
Message-ID: <2365692588dc7410db42e68d92960ee7dc2bf2f9.1692119258.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1692119257.git.asml.silence@gmail.com>
References: <cover.1692119257.git.asml.silence@gmail.com>
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

There are only 2 callers of io_fill_cqe_req left, and one of them is
extremely hot. Force inline the function.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 07fd185064d2..547c30582fb8 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -132,7 +132,8 @@ static inline bool io_get_cqe(struct io_ring_ctx *ctx, struct io_uring_cqe **ret
 	return io_get_cqe_overflow(ctx, ret, false);
 }
 
-static inline bool io_fill_cqe_req(struct io_ring_ctx *ctx, struct io_kiocb *req)
+static __always_inline bool io_fill_cqe_req(struct io_ring_ctx *ctx,
+					    struct io_kiocb *req)
 {
 	struct io_uring_cqe *cqe;
 
-- 
2.41.0

