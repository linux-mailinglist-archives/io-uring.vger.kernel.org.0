Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA1C36D0142
	for <lists+io-uring@lfdr.de>; Thu, 30 Mar 2023 12:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbjC3Kc0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Mar 2023 06:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbjC3KcY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Mar 2023 06:32:24 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7D91992
        for <io-uring@vger.kernel.org>; Thu, 30 Mar 2023 03:32:21 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id eh3so74457630edb.11
        for <io-uring@vger.kernel.org>; Thu, 30 Mar 2023 03:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680172339;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lcOuIaE/0CfU2XGiXqzEy2pCagEt+qFFJlvvo2AylwM=;
        b=AjJPqG+cpCIS/pK48HJhJX1Nn/gM0GaxVmy6h7bKVZcUWW3z65FrMiemhn0oPOdvkB
         PbvajqovdrIiS9eW0AZhaocf5rNN/Df/eiApWd12XwbKV9468karlFyqvMjfsB05I3bl
         ymEScVxtUq0opCWkPDM93pvF3JCz8XtS8HAJPdBJCc0Nk6cIWNCIa5md9WIU+aAPxFsJ
         rAVRpf30Q5vxw5HTP0FtNw6+Gbqx/cxQQ2EdJlSpj2AuwkO/8gLGXPq7wTK7uv1YK2Xh
         wZzmcN+Xp/2vrkrt3atzV8fWeoTxjKiFFUugzdXLd88TE79vQlMS4M2+NVCbCiQB0jkR
         P4rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680172339;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lcOuIaE/0CfU2XGiXqzEy2pCagEt+qFFJlvvo2AylwM=;
        b=4Uz4VluffNsG+gfp3KYSP9vk0ELr0MgCGOcK09zlL/F64SiHTVnx/51DvD0iAyYANs
         zambDEHb6CIH5IvNoVOUiXXhCXg/3fdpbPAnY22Je6oDFsAGyQ4UtMQ8/CmdXOW74W+g
         qbO8F6QU9aFV+E+Vm6oE8oPLNkfKCSelv5qkCs9ifsrKFTCXJAmfkQanKTaKT8wjPnze
         Asfi8qakxOGZJRTXHemSj2EymkCUz4ajB6YSBZkqI5lzIcbtYy7CR2TuAp1h0qv1hWtR
         jRS8PD/yX1wQMZzHLtP9neYmspL4oSukZJqf82Tt851ozsrpSmKi5uKcAmOsfcw6ok8I
         /y0w==
X-Gm-Message-State: AAQBX9clXDHACBp4iaL4rcNTC6CYRDVyoamrdaGDEaFt5XgdLs91vpHC
        60iGvNsN1YRQFbvFQDdzngtZ3c+qRPA=
X-Google-Smtp-Source: AKy350ZTgYHg7eA9vVnajbcCcFlFTh1k9UbFRG99/v4VIJxRJn4zK1i0L4SWHxjNBTRdmFA5j+9dbg==
X-Received: by 2002:a17:907:3e14:b0:947:3af0:66c0 with SMTP id hp20-20020a1709073e1400b009473af066c0mr3486069ejc.26.1680172338931;
        Thu, 30 Mar 2023 03:32:18 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:e0e1])
        by smtp.gmail.com with ESMTPSA id v5-20020a17090690c500b0093188e8d478sm17454256ejw.103.2023.03.30.03.32.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 03:32:18 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: fix poll/netmsg alloc caches
Date:   Thu, 30 Mar 2023 11:31:36 +0100
Message-Id: <0126812afc5845096c987c1003e2ec078eefcd8a.1680172256.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
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

We increase cache->nr_cached when we free into the cache but don't
decrease when we take from it, so in some time we'll get an empty
cache with cache->nr_cached larger than IO_ALLOC_CACHE_MAX, that fails
io_alloc_cache_put() and effectively disables caching.

Fixes: 9b797a37c4bd8 ("io_uring: add abstraction around apoll cache")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/alloc_cache.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/alloc_cache.h b/io_uring/alloc_cache.h
index 3aba7b356320..2fbecaa3a1ba 100644
--- a/io_uring/alloc_cache.h
+++ b/io_uring/alloc_cache.h
@@ -31,6 +31,7 @@ static inline struct io_cache_entry *io_alloc_cache_get(struct io_alloc_cache *c
 		entry = container_of(cache->list.next, struct io_cache_entry, node);
 		kasan_unpoison_range(entry, cache->elem_size);
 		cache->list.next = cache->list.next->next;
+		cache->nr_cached--;
 		return entry;
 	}
 
-- 
2.39.1

