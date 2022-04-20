Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6F00508853
	for <lists+io-uring@lfdr.de>; Wed, 20 Apr 2022 14:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353659AbiDTMoU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Apr 2022 08:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350752AbiDTMoT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Apr 2022 08:44:19 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 488A1183AB
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 05:41:33 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id r4-20020a05600c35c400b0039295dc1fc3so1144577wmq.3
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 05:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dyHFId9/CpxAmn6Oj+Q/tpCkHDC8FpnEP/k4Y4ivo4k=;
        b=e0Y0AMJvrk7EAa3TQI8ioSs3SZye3PUxLomDEJ3zwojieM3IFa3hqnlfw7T1r57d8w
         3cZ5d0VO8cAV+XEe4QZtJtQ/eXZ9saEaVtl1WnsUWZd+ErLoK/OxyYu5cH/6EPGmmlkq
         8I4ZcvsFekG0VQ231cDvLt0BP8n68kudiUyUG1uTIY2tFslpKnrrfKGE03Mrl7ahp66K
         QTU7DWl1jjVU+s+5B+IBRY5VzdtUMnGIwcP3dMFm64enlNcNoZd6NXISOsPewlzD/Hi8
         92LnaAwPYpNKbY6IWi43CudZc+kb8bENJ0gPFyfh4swQQlEQfuQNO3jwTxaSmQTLQeKW
         /IoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dyHFId9/CpxAmn6Oj+Q/tpCkHDC8FpnEP/k4Y4ivo4k=;
        b=jin1ah8JsrFs9CImyYMn8ldaCZKguYb+m+6Jnll6HQv/QMId2akgZrex5eQ/GUWJRK
         g4PdRsdIeUqYyI0jqRziMrBIUtzd3FHGmNui6xS9xc+lpNfkbUOE4dEURWtFGqmrnBFj
         BXNHORKtFMsBwCeQRATvAF6D7+ApZYRRhMtDvg1/VqED92LPUPxGhrh99+et2ST1mCg1
         KdV5ZpY+VKWaYJFpkxNoEtmoB6hI4EWlh707iYI9tcRR2Om+sHSaU1OUWkOy00bbwQjB
         8YX6MPmQVFu15l4hxuaAqikFGRQjr8B6hDW/+TgEVRLFogaTp9R0cEHpgXUsWYDcGlDH
         8tJA==
X-Gm-Message-State: AOAM5319vTpdn+8YgLA3aTRbN4ZILFQ82nABCjgXT7ouL/977gs8rckD
        ctDkmqLpfqWmz3vVnkeSe1UjlLNvAPU=
X-Google-Smtp-Source: ABdhPJwQXPjINYyQ3QlZxWJk2RtkW5hWGU0OogUBpimgtbZ/NNm6VDoaI1QDRdw4jX2MhskGsg38AQ==
X-Received: by 2002:a7b:c30e:0:b0:37f:a63d:3d1f with SMTP id k14-20020a7bc30e000000b0037fa63d3d1fmr3423569wmj.178.1650458491748;
        Wed, 20 Apr 2022 05:41:31 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-244-154.dab.02.net. [82.132.244.154])
        by smtp.gmail.com with ESMTPSA id v11-20020adfa1cb000000b0020ab21e1e61sm971322wrv.51.2022.04.20.05.41.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 05:41:31 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 0/3] timeout fixes & improvements
Date:   Wed, 20 Apr 2022 13:40:52 +0100
Message-Id: <cover.1650458197.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
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

Fix the recent disarming syz report about deadlocking and brush a bit
up timeout/completion locking.

Pavel Begunkov (3):
  io_uring: fix nested timeout locking on disarming
  io_uring: move tout locking in io_timeout_cancel()
  io_uring: refactor io_disarm_next() locking

 fs/io_uring.c | 46 +++++++++++++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 15 deletions(-)

-- 
2.36.0

