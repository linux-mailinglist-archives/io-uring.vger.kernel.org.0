Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECA06CA939
	for <lists+io-uring@lfdr.de>; Mon, 27 Mar 2023 17:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbjC0Pjd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Mar 2023 11:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232659AbjC0Pjc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Mar 2023 11:39:32 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F99C2
        for <io-uring@vger.kernel.org>; Mon, 27 Mar 2023 08:39:31 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id r11so37972341edd.5
        for <io-uring@vger.kernel.org>; Mon, 27 Mar 2023 08:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679931570;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9LkcL8/cgWNPk/JBTzwzUlZyTOF+Z9zwh8eIwjaFvK0=;
        b=Zac7QLgSS/cyr70gE3zkuKRsyktl93i8BDlY5yEym7YcmdVuXAvdnYRFnwuW2zT7ef
         dRA5ysBcF73HXdrc0U4UYDSRizoPekDl4O2fPETRwS1vLr0zEkclv800uGdGxmjjDIvJ
         a36T++r4POpNNxx7coLo/LmIJjS8z0otoQGqvlPlJmpkpmWBB6u3y0FVDAySwWzd4THo
         67nIiO6ZJQ+tW3KuZ9d/nbcXK6K6PWrikEzki8kT9kUB+4eAXPRQSjX0ZrGbyqyVPWnV
         mOyXiQ0LIk6P+OCwxXPe/N+sFxTr+t+WMJmTLNxjmAUyh8h9IpqTpACpVR+Chc5gzXpo
         6Qiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679931570;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9LkcL8/cgWNPk/JBTzwzUlZyTOF+Z9zwh8eIwjaFvK0=;
        b=nC8kyq0T3aBKL5iQh5Z3dX35OOer7jqKX7n7CpuJ/+dEP/WvIkomVVBcfOHmacmVR3
         V9OWUiSYUU0xsPP3RaDdGtMbNBG9KScERzOIWhWfRH47KvZCbSGwwVGoxJMMVFe/FKx7
         4EYQDk0AA0+H4XyJOrjHIH3MXDacHL/LjJulENwvj9qf/s90//655sx3BfCnpt9LLFpO
         vjTAn6Yfi6/wKhHvs6Ys9PztIEN2+PkYGetkDggUzdmnqx4Nc9U7EraiRaLoB8vztGPo
         YcO8su0ahITKj+efBouZY/+P+JzGSVq7/YcRcOkNxOcgGqYjcTET2rno6ifLLZcoVrkR
         3iWA==
X-Gm-Message-State: AAQBX9f7BRkKB8XnNYeO6Nh0YYS5i8qrvXD3EUG64l7qcwkzlYOjFWqB
        K6iZt33PigIyN/a+1RUiM2hzq7UAvQo=
X-Google-Smtp-Source: AKy350Z5i9d7dPnn47vO4JDKCYMNSCoAq7oBCRKrTXeMSFZK59ozJmX+W6XThazXFQLPh6pHNPuYDQ==
X-Received: by 2002:a17:906:2d52:b0:930:e055:8698 with SMTP id e18-20020a1709062d5200b00930e0558698mr13120464eji.70.1679931569779;
        Mon, 27 Mar 2023 08:39:29 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:e437])
        by smtp.gmail.com with ESMTPSA id lx12-20020a170906af0c00b008e57b5e0ce9sm14055073ejb.108.2023.03.27.08.39.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 08:39:29 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/2] io_uring: remove extra tw trylocks
Date:   Mon, 27 Mar 2023 16:38:14 +0100
Message-Id: <1ecec9483d58696e248d1bfd52cf62b04442df1d.1679931367.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1679931367.git.asml.silence@gmail.com>
References: <cover.1679931367.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Before cond_resched()'ing in handle_tw_list() we also drop the current
ring context, and so the next loop iteration will need to pick/pin a new
context and do trylock.

The chunk removed by this patch was intended to be an optimisation
covering exactly this case, i.e. retaking the lock after reschedule, but
in reality it's skipped for the first iteration after resched as
described and will keep hammering the lock if it's contended.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 24be4992821b..2669aca0ba39 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1186,8 +1186,7 @@ static unsigned int handle_tw_list(struct llist_node *node,
 			/* if not contended, grab and improve batching */
 			*locked = mutex_trylock(&(*ctx)->uring_lock);
 			percpu_ref_get(&(*ctx)->refs);
-		} else if (!*locked)
-			*locked = mutex_trylock(&(*ctx)->uring_lock);
+		}
 		req->io_task_work.func(req, locked);
 		node = next;
 		count++;
-- 
2.39.1

