Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 322DF65E9BF
	for <lists+io-uring@lfdr.de>; Thu,  5 Jan 2023 12:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbjAELXv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Jan 2023 06:23:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233220AbjAELXg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Jan 2023 06:23:36 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9AD94E42E
        for <io-uring@vger.kernel.org>; Thu,  5 Jan 2023 03:23:35 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id k26-20020a05600c1c9a00b003d972646a7dso1050492wms.5
        for <io-uring@vger.kernel.org>; Thu, 05 Jan 2023 03:23:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rpbSPant5cggrLBmtqBItkB+rcpfw2nGgE6wmfcc54c=;
        b=T/vA3qTHuQNITtmOyU78q7iBccc16GXZAEsHp6nQqP6Z9f44FOFfYV3opncVLf2i+j
         dI0knvUeyrSm+nvHP3D/VmN4QK/hoDEAsJQVN18Ma7Rpq+iP2zKfBAem9ZNga5bB84Cb
         UW89GDTHHyKbhEy7h3rHYdx3iWdv+0UPiccRm9HOgk+JWTb68dWhFcUmk4RkiM7a/k++
         RU4JdKr8YKFOKuaJTQAwcEwNv4HAMRUultH0rzpgs9DwaCWK7x8ZsthsS1K3M2wuj75X
         yiqHWJYxEJglWbPPvBP4E7nKobSFafoaR2pkeuMBgQ9uFk1bZUSTuHd5B1KqZVNhKDng
         B9Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rpbSPant5cggrLBmtqBItkB+rcpfw2nGgE6wmfcc54c=;
        b=OrjTtYVVPkCCdWUMtChhKLDVz7zfnopxMoixqnf0CeMFeKvIeSDcc/cy5H/t9l7t+6
         0/S2QP1Urq8Oru1oUgRgXd5L6Yzt+ttzLeD/OaRJ3taPbM19WXf243ySKOrvR69GmTiY
         qL9LZrry8dbR21xWiO9LgzrVfgfT0aAXyJlYvi5scwBaZAAnXy4Gg4BNPw9L6vREtHZH
         Cj/JmFmbb6+Yz2b83kj1byQc0ryOOY8JhUXwVAo6Hehv29SPjVZ5mQ5BoswKE0mUjlJq
         Ih1gEqoX42S1Br/Vv5KTO4osdXLcJqWnDBaVdZH7zvxgLtRFbxhYBGoX8y8Bl9IILevJ
         17YA==
X-Gm-Message-State: AFqh2kr1dSLVud7Z8PYBd8BNZtpow0SXy+YaRE2knYTfc6qsiWGcwIre
        szDJdYyUX8aEN/a8JkiRz1P/TQuTlm8=
X-Google-Smtp-Source: AMrXdXuo941vlJkwTvq8xEPCTOVwhcwYpIHN5Py/29As2tgvUe6CCcKqpeHyMoN5HguKUhr3AAf79Q==
X-Received: by 2002:a05:600c:13ca:b0:3d3:4427:dfbf with SMTP id e10-20020a05600c13ca00b003d34427dfbfmr35362239wmg.5.1672917814371;
        Thu, 05 Jan 2023 03:23:34 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::2:5c5f])
        by smtp.gmail.com with ESMTPSA id u13-20020a05600c19cd00b003c6f1732f65sm2220688wmq.38.2023.01.05.03.23.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 03:23:34 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCHSET REBASE 09/10] io_uring: optimise non-timeout waiting
Date:   Thu,  5 Jan 2023 11:22:28 +0000
Message-Id: <89f880574eceee6f4899783377ead234df7b3d04.1672916894.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1672916894.git.asml.silence@gmail.com>
References: <cover.1672916894.git.asml.silence@gmail.com>
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

Unlike the jiffy scheduling version, schedule_hrtimeout() jumps a few
functions before getting into schedule() even if there is no actual
timeout needed. Some tests showed that it takes up to 1% of CPU cycles.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 54ec0106ab83..420b022f6c31 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2476,7 +2476,9 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 		return -EINTR;
 	if (unlikely(io_should_wake(iowq)))
 		return 0;
-	if (!schedule_hrtimeout(timeout, HRTIMER_MODE_ABS))
+	if (*timeout == KTIME_MAX)
+		schedule();
+	else if (!schedule_hrtimeout(timeout, HRTIMER_MODE_ABS))
 		return -ETIME;
 	return 0;
 }
-- 
2.38.1

