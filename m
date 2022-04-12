Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31C764FE5C5
	for <lists+io-uring@lfdr.de>; Tue, 12 Apr 2022 18:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233978AbiDLQ1w (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Apr 2022 12:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357569AbiDLQ1W (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Apr 2022 12:27:22 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C8E44BFDB
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 09:25:04 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id q20so12278116wmq.1
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 09:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nAZSzpC8sCbBMVWDzawkUtiidPgttHEZYzIuKRYIXCY=;
        b=NUlFzi6FlN0Rj7J+JLiP21dG33mySbPpeUJDMiPS3D07LfCI59OUI9/WiuuaYaaqlj
         y1wyTFtuqI6Qwv6M7EOyl+Eho2GdXYbWF1ak5Tgv6XRG1VeuqLHa3f8FCG0cw+dj6UWQ
         pn9NCM+wrjLhkOe2ANS1G9ytiJCtn5iV8Aedum1ACmshD4KPnIZIT8A5z1VXqHyKYH/6
         1jo+W1HyNoxRRBtwksp7d7tVVDvUF0GGb2iC3bU1e/if8qu75Piv2D6u4mIBzG5OV0LT
         KqymCk/LO+v4PJ8uqBcKZ2V2WrMc6D/xwJMBaTsKBPMtmxTKZAqM3TWWnFwLaROcuaLu
         n3fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nAZSzpC8sCbBMVWDzawkUtiidPgttHEZYzIuKRYIXCY=;
        b=0DFTXzzpgoyKKqebS3Ncdq7sAsW1Vv3fVnFxoAJMjsIQkv7WZo6okaKOOrjiPEavwi
         9eTdUrQW3r+aHqTjazRMUa3s2bswgMp6DZLUU22ZKOa3bjYFgtAYcyXv+/Vg6Y2bRtwi
         UReCNvKCnqIElrBRYPv0I3MHohAjRWArR7WfiKIlMXMBcYia7sl75tgoyDXKQHIVh7vP
         EUt5AnTYbTpmcUKInnpAJ/nqSngsnhWefB/rmnmgiHXnA53zr4W/HIx0dfa54BshylpN
         bB2h4subzv4DksAKSq/2OEO1laHPEVsj4/nbn3ce1U2lpKgYgvFW9ssCpz2DsHi0DJ+6
         MLyw==
X-Gm-Message-State: AOAM532800VgMEFwTfN8bnRfJy7jbOZcM2GTwQy8yvsBPDy69gU/MHEI
        1Ectl0HrbA0KBGcPzyB4TscoqXXlouo=
X-Google-Smtp-Source: ABdhPJyRe3dPcs2FKgup6FoB1ZNKsEj6lLhETJ38DyHVirk3PW8WcqWf1DLr2SL4fnOfheabIB25/w==
X-Received: by 2002:a05:600c:34d4:b0:38c:5ec7:1e38 with SMTP id d20-20020a05600c34d400b0038c5ec71e38mr4739026wmq.184.1649780702974;
        Tue, 12 Apr 2022 09:25:02 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.222])
        by smtp.gmail.com with ESMTPSA id 10-20020a5d47aa000000b00207afc4bd39sm2504629wrb.18.2022.04.12.09.25.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 09:25:02 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring: fix leaks on IOPOLL and CQE_SKIP
Date:   Tue, 12 Apr 2022 17:24:29 +0100
Message-Id: <c19df8bde9a9ab89425abf7339de3564c96fd858.1649780645.git.asml.silence@gmail.com>
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

If all completed requests in io_do_iopoll() were marked with
REQ_F_CQE_SKIP, we'll not only skip CQE posting but also
io_free_batch_list() leaking memory and resources.

Move @nr_events increment before REQ_F_CQE_SKIP check. We'll potentially
return the value greater than the real one, but iopolling will deal with
it and the userspace will re-iopoll if needed. In anyway, I don't think
there are many use cases for REQ_F_CQE_SKIP + IOPOLL.

Fixes: 83a13a4181b0e ("io_uring: tweak iopoll CQE_SKIP event counting")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index cbd876c023b1..738ec10f038f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2872,11 +2872,10 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 		/* order with io_complete_rw_iopoll(), e.g. ->result updates */
 		if (!smp_load_acquire(&req->iopoll_completed))
 			break;
+		nr_events++;
 		if (unlikely(req->flags & REQ_F_CQE_SKIP))
 			continue;
-
 		__io_fill_cqe_req(req, req->cqe.res, io_put_kbuf(req, 0));
-		nr_events++;
 	}
 
 	if (unlikely(!nr_events))
-- 
2.35.1

