Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A17CF662FAA
	for <lists+io-uring@lfdr.de>; Mon,  9 Jan 2023 19:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233422AbjAIS7S (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Jan 2023 13:59:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231133AbjAIS7Q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Jan 2023 13:59:16 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF551C92A;
        Mon,  9 Jan 2023 10:59:15 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id v25so14446798lfe.12;
        Mon, 09 Jan 2023 10:59:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wz6Ca+oQ8IzgEW6Ky8musAelT/aFhsyy9Pu0evu/Z3k=;
        b=lzOm2a9gfexhjoVHefqn5Ow1ntN2shn4UjDJ3g9oW3UyTojiu0rWSLeCKkJ6nmz8zl
         8Md8Qj5b7mkJXUoJXtd9ls3iT8lhnxblXwbQ19Raebf8VQEcq8pG8oALem1whqSAV1X4
         aWeK/ifuzmcuNfIIiNAN5UvrdJvemg5sjUidFpMxCyyoqzrO9s5INNV0qgtPEkGQfQTN
         lm00e3+UelG2yK1S06wsC326d4IhmL0hgFbDil4MBPaljB2VeAWpGUMvwstaoDD7NL4y
         Cg0sX8lbbUs/GLH5OA8NCziYtHDwN33ORDZQhpeMhcBShbGqiHGdesT+Zo32KyUmWyE4
         vuuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wz6Ca+oQ8IzgEW6Ky8musAelT/aFhsyy9Pu0evu/Z3k=;
        b=6p6ocJc/YJ1MJhcyoiareEtnVJNSYENXDTHb0TiM8/9WM/pvsMqxL0qbJ0LspXx3i0
         LY1mzK/6r7UnUaAp0NvDFOV/07bKpprZty2EsCOhGHXU50LVp4QzD4Cc6fN38bsG4u+Q
         egQaDsILD1LghCdMeAiZesil8IRlI3GDJdma9LXzABrqKKcXHxGZZMfHfM/UY3AmRoIM
         JVOYzH3wuZ8V+4vPjmL4UCLSAjEQMhMF+T2AgVPaP6BBjQCD/qnS95+KSpgEhkSg/ssL
         yoliJmJvW1fLL5n8TO4wac/FY/wk5ItPLCY8ZxIHHOlX9TjmEzOi7Qv/yOqrR92XmjlF
         34Qg==
X-Gm-Message-State: AFqh2kpkbuGoLhZ53740rC78AtqaMACFFTRiRkmMMBcUFX8nCI6LULyy
        E890S0VnA/S1V15jdcO7HJ2RuVfcKrofrC9k
X-Google-Smtp-Source: AMrXdXv6vxiB5OFxbBrp+x934d2/2VDbof/95XznE/8aTHeh08qXGgr+vgSAfAQ3X2FybFcu9KcAzw==
X-Received: by 2002:a05:6512:2619:b0:4cb:c48:9d44 with SMTP id bt25-20020a056512261900b004cb0c489d44mr14918702lfb.28.1673290753705;
        Mon, 09 Jan 2023 10:59:13 -0800 (PST)
Received: from localhost.localdomain ([77.223.97.133])
        by smtp.gmail.com with ESMTPSA id bi35-20020a0565120ea300b0048a982ad0a8sm1753929lfb.23.2023.01.09.10.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 10:59:13 -0800 (PST)
From:   Dmitrii Bundin <dmitrii.bundin.a@gmail.com>
To:     axboe@kernel.dk, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitrii Bundin <dmitrii.bundin.a@gmail.com>
Subject: [PATCH] io_uring: remove excessive unlikely on IS_ERR
Date:   Mon,  9 Jan 2023 21:58:54 +0300
Message-Id: <20230109185854.25698-1-dmitrii.bundin.a@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The IS_ERR function uses the IS_ERR_VALUE macro under the hood which
already wraps the condition into unlikely.

Signed-off-by: Dmitrii Bundin <dmitrii.bundin.a@gmail.com>
---
 io_uring/rw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 8227af2e1c0f..27d5e3323a53 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -410,7 +410,7 @@ static inline int io_import_iovec(int rw, struct io_kiocb *req,
 				  unsigned int issue_flags)
 {
 	*iovec = __io_import_iovec(rw, req, s, issue_flags);
-	if (unlikely(IS_ERR(*iovec)))
+	if (IS_ERR(*iovec))
 		return PTR_ERR(*iovec);
 
 	iov_iter_save_state(&s->iter, &s->iter_state);
-- 
2.17.1

