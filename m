Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA28A625FE2
	for <lists+io-uring@lfdr.de>; Fri, 11 Nov 2022 17:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234175AbiKKQzp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Nov 2022 11:55:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbiKKQzg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Nov 2022 11:55:36 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 556294AF24
        for <io-uring@vger.kernel.org>; Fri, 11 Nov 2022 08:55:32 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id kt23so13838152ejc.7
        for <io-uring@vger.kernel.org>; Fri, 11 Nov 2022 08:55:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TMY/ClcnBCZW9Y6tNadniJ7o0GwBqIjuO1gxGlUKbgQ=;
        b=G+2evnXZv+BdNY910liFWvi3fhLle+SPKjv9TqhHPw8n2z/p8qNUtMd4t/RmgUGAt2
         DCz72f47Z0Lgl3m2duh+3ToIsNhibQ9M2BbvM4oS2K8AqROBGbAUDgHLCK0tLxKLeo3P
         mwYGWf9APBPvR8P2IX88aAbLRGRP+1eh4g5keFm5jPzB2m/vq+yo1mv5MDXvb1xUWrkZ
         SCQy79MAZlg7yFvTO7DwsG6eudvNUuGX16aYmK5eHUlJRewjtUWOG/vF1BdOJnuyxz/G
         1Ar+KIcYqE/t84J5+Jtke7ohP+EP0W9ZnVLuLW74IBkPfSYFXy+gp62MS+xscGf0G3pk
         7aWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TMY/ClcnBCZW9Y6tNadniJ7o0GwBqIjuO1gxGlUKbgQ=;
        b=cnp54QZNjF3aA+KbjNHHt1aSbM6UchDjC919iMZHMu53KyfsBxALGPVipHn1wtxUEx
         8bvL0I5duMO073PSScjoTAZUuobf3Rpa6+aRST4CI6m+SpcjvTIzZ/8SlbiqePynlNQh
         LOUQvW4XzfBJlmUx1+sg8yP7YEIqZ7n4k696Fr+GsO9IOgNNNxuRtUVg/+0lrG1mLmxT
         2FVP06QYfG7/uiOkahpE7jbn4AovbL2RkZFbXHDyWaIl+jB6AdjsRe5LIzHxup/rWZm1
         TvEDONrNYjotplk0h4pXD/SEdWlnwteT7xJg5mvrUB27a/sBNmfiI+eGfPswoer06Bav
         ZB0w==
X-Gm-Message-State: ANoB5pmG9BRdDABzATQbk5rb8s1slm3inC9nTpRs/gVaA4RFoOjNYakU
        5wtVibNtDUAtiya5DnYVumQpLhp2GyA=
X-Google-Smtp-Source: AA0mqf6UM/sasrJJOgBxTKTFZ0YJD0vxZWcQbhKtIBoYItva+duL13kgMRHVlj2JK62lEznKsFmBmQ==
X-Received: by 2002:a17:906:7203:b0:7ae:664a:a7d2 with SMTP id m3-20020a170906720300b007ae664aa7d2mr2532960ejk.676.1668185730401;
        Fri, 11 Nov 2022 08:55:30 -0800 (PST)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:7f38])
        by smtp.gmail.com with ESMTPSA id 20-20020a170906329400b0079dbf06d558sm1022540ejw.184.2022.11.11.08.55.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 08:55:29 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 0/2] small tw add improvements
Date:   Fri, 11 Nov 2022 16:54:07 +0000
Message-Id: <cover.1668162751.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
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

Fiddle with inlining of task_work add so the compiler generates more
concise and efficient code.

Pavel Begunkov (2):
  io_uring: inline io_req_task_work_add()
  io_uring: split tw fallback into a function

 io_uring/io_uring.c | 32 ++++++++++++++++----------------
 io_uring/io_uring.h |  7 ++++++-
 2 files changed, 22 insertions(+), 17 deletions(-)

-- 
2.38.1

