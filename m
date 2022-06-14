Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB24554B11C
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 14:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242647AbiFNMdu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 08:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245251AbiFNMdY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 08:33:24 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4EE044A01
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:30:39 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id x6-20020a1c7c06000000b003972dfca96cso4712771wmc.4
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ToujjDMrgxjXImVoVU6hciJcYYHsx0thIW3gWEU5SEA=;
        b=nTcDlCuG/00HkgwY92Q3tY5WQhp7nXfww4UCWNXZJ/2WFTibK0VHf9F6pvqlXcTqWj
         aHMsLQUrakD9XYjCeiAl486PJ3yLuPXUs2NG9SIBR0v3nftF12Tp7Xp5BRsp/AnrObpf
         fo6nl8YMQKPx27JUxEqwE4ZY4/Nz5IZcYa1peHGGAZs4o9MBzI8tTwF8uCg25fQj7vLC
         psXmkl77FGQg6KvzO7y1AC5OUDY8i9UDscceWOtoYj8W1YtLgUPMqqs9WVRvOnISIYdc
         /8BD+LCLpkPr5tesvgYSyaIBpAf8kC+IC02RCyCEdNe4khdRcWsYWOalm+6D2ZXHG0+p
         e5/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ToujjDMrgxjXImVoVU6hciJcYYHsx0thIW3gWEU5SEA=;
        b=mCSpMDN59Y1scAxpxgVkb3+UtS6ynaqaVpXUOMqSET+hqAVLWQNOwLERDV1oze3VZI
         QoVO/QthbpjvO+9ivF9+vDt6Gbm4XEUY4AKQ9aiLm7NfmiCIAmorzD4mwCKzgxP0gaQX
         KJbYwbfQ9qck9fjoUbCTAPbX18cAmRlpgq69v03Z7nUeKzFl9oihMw4xq9YXm7uQ0rFj
         dKc3qSgz25zWzO/rybDWT3PHNETLIzNVMEJbc7QcKBOfHCCzP9K1MQsTMwGhh1OckUoN
         WXj0YXzSEdjxr5o0yhjpkbf2/TNUNDSuJbLG++//jPhJvy9N3us9OF+pZr90v6V8B9tS
         Cn9g==
X-Gm-Message-State: AOAM531olpJt7lextwWdCVlhh8fHbURvJgSjxsXwGByuIxFQbm1i/Nrb
        Y/uEJkEujvARB349Ofqx6g0n8y4hcwh/SA==
X-Google-Smtp-Source: ABdhPJz26FqgShcnU56x4IISwHonAR5Nhy3xktetYZINkroEmFjTmf/iGKMt0nBP+9chJhI+eY+hHA==
X-Received: by 2002:a05:600c:601f:b0:39c:416c:4069 with SMTP id az31-20020a05600c601f00b0039c416c4069mr3867322wmb.85.1655209837312;
        Tue, 14 Jun 2022 05:30:37 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t7-20020a05600c198700b0039c5fb1f592sm12410651wmq.14.2022.06.14.05.30.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:30:36 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 02/25] io_uring: move defer_list to slow data
Date:   Tue, 14 Jun 2022 13:29:40 +0100
Message-Id: <097c9f3eb3f8ab052e10160567928ec8df0f1303.1655209709.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655209709.git.asml.silence@gmail.com>
References: <cover.1655209709.git.asml.silence@gmail.com>
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

draining is slow path, move defer_list to the end where slow data lives
inside the context.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring_types.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring_types.h b/io_uring/io_uring_types.h
index 7c22cf35a7e2..52e91c3df8d5 100644
--- a/io_uring/io_uring_types.h
+++ b/io_uring/io_uring_types.h
@@ -160,7 +160,6 @@ struct io_ring_ctx {
 		struct io_uring_sqe	*sq_sqes;
 		unsigned		cached_sq_head;
 		unsigned		sq_entries;
-		struct list_head	defer_list;
 
 		/*
 		 * Fixed resources fast path, should be accessed only under
@@ -272,8 +271,12 @@ struct io_ring_ctx {
 		struct work_struct		exit_work;
 		struct list_head		tctx_list;
 		struct completion		ref_comp;
+
+		/* io-wq management, e.g. thread count */
 		u32				iowq_limits[2];
 		bool				iowq_limits_set;
+
+		struct list_head		defer_list;
 	};
 };
 
-- 
2.36.1

