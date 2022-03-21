Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9824E22D0
	for <lists+io-uring@lfdr.de>; Mon, 21 Mar 2022 10:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236390AbiCUJDY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Mar 2022 05:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345671AbiCUJDP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Mar 2022 05:03:15 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ACE088799
        for <io-uring@vger.kernel.org>; Mon, 21 Mar 2022 02:01:49 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id dr20so28080490ejc.6
        for <io-uring@vger.kernel.org>; Mon, 21 Mar 2022 02:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=puBqLt/d/3tmMnlB0pg8dzKc2HZvVEOeAx2SKOuk7Ks=;
        b=WaOE9dJj+lhoFS0A0ACdzM68rEA37bEQq8GHOlcZTD6XALTCUnX+V2+ebgJNAV9H8T
         JZuvoxsuockwy2uBcDtA9YHeTWUNndb1yOa62AnYIVUNfmoWHgqbcYkUGuxa4ypos4pQ
         8OQGa1CSVFViBSn7SDLpLUKg6DZ8J/WEWAFIvCGfEEYqYI9BCL0u1hbStFSDTJrzHOH6
         WYuPZfYFqm5cDdij9BHms8yxcFSaiJ422ojybOt7ljr2lSRbR1xWX9xZvWpWuUFZ2M3R
         LHqvZoq11Ndt0vc0+epCecpQe5DxT7cEZqsIWnkggCx0mJyvGLMj77YXlg4bo7+Pf8Nj
         Q55g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=puBqLt/d/3tmMnlB0pg8dzKc2HZvVEOeAx2SKOuk7Ks=;
        b=Da2FPPB8t4kqK0B4p/oyU3ezp/6dCktqqBHPw5JWOoNOw88XrkKBxIzGDfyJsVGHgS
         XVD9qx5MoeTDzlbj6VwupwKRseH7juycDFqn/1tnvRAxx3c+bDrzKnn2MF+QBHcaNrWs
         ejtc9fWswZrswKSFzMDIyLuA8HMRmpA9S0iXEao/7PJ/b0UlLLFkPZxLcbxN8SDy6wun
         /ZYrOK4IyOl7OVdrIUo9LpYYfIL+VV/ZIIUj7tp0mB4JU05+2OHZOjuhVTIevOJ2xGL2
         3Thhupb3mygql5dRdju+EDoIySgjoBkoCl7X+wdVQ/BNFUxj5y8b/dcuytyy2vRA3wtu
         r6Xg==
X-Gm-Message-State: AOAM530G9vU0sXRFXY78EhhNcIjRIiVwlV6vnn23ktDLLNvAWqjn9N8k
        5rbr93v2dpoUTzOdFyDWgAYVeu43DoQ5BOkAe+E=
X-Google-Smtp-Source: ABdhPJxOMzJZ0GrN6W4N4thVFgO00F+luumOStz2HV0Mm0CleYFrshzJBa++5V84Cq6/TsG+U5Imdg==
X-Received: by 2002:a17:906:f857:b0:6df:ae2d:73a0 with SMTP id ks23-20020a170906f85700b006dfae2d73a0mr15080054ejb.614.1647853307779;
        Mon, 21 Mar 2022 02:01:47 -0700 (PDT)
Received: from localhost.localdomain (89-139-33-239.bb.netvision.net.il. [89.139.33.239])
        by smtp.gmail.com with ESMTPSA id ga10-20020a1709070c0a00b006dfc7c089f7sm3244040ejc.1.2022.03.21.02.01.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 02:01:47 -0700 (PDT)
From:   Almog Khaikin <almogkh@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com
Subject: [PATCH v2] io_uring: fix memory ordering when SQPOLL thread goes to sleep
Date:   Mon, 21 Mar 2022 11:00:59 +0200
Message-Id: <20220321090059.46313-1-almogkh@gmail.com>
X-Mailer: git-send-email 2.35.1
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

Without a full memory barrier between the store to the flags and the
load of the SQ tail the two operations can be reordered and this can
lead to a situation where the SQPOLL thread goes to sleep while the
application writes to the SQ tail and doesn't see the wakeup flag.
This memory barrier pairs with a full memory barrier in the application
between its store to the SQ tail and its load of the flags.

Signed-off-by: Almog Khaikin <almogkh@gmail.com>
---

v2: Fix trailing whitespace and rebase to latest tag

 fs/io_uring.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5fa736344b67..695ee5fddc84 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8035,6 +8035,13 @@ static int io_sq_thread(void *data)
 					needs_sched = false;
 					break;
 				}
+
+				/*
+				 * Ensure the store of the wakeup flag is not
+				 * reordered with the load of the SQ tail
+				 */
+				smp_mb();
+
 				if (io_sqring_entries(ctx)) {
 					needs_sched = false;
 					break;

base-commit: 5e929367468c8f97cd1ffb0417316cecfebef94b
-- 
2.35.1

