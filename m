Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F12624E403D
	for <lists+io-uring@lfdr.de>; Tue, 22 Mar 2022 15:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233341AbiCVOKi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Mar 2022 10:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232821AbiCVOKh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Mar 2022 10:10:37 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4179D5DA6F
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 07:09:10 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id bg31-20020a05600c3c9f00b00381590dbb33so1870204wmb.3
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 07:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=swaD7rtGstk7uPp8xpgXpYvwvFHl+ue+Q6oItIEhgIY=;
        b=LNnEZEp1vuvuUAQRk6+D3USTKrSWbiSayLWcL8SW05nKflsmQPRhR0MD/nd4ZBnQ49
         RtAVUNdIzMAEkgKUCbrrtq+yQDon/Yb9NqqMKODIeR4e3X5miIPCsAvd5oY9Rk12K9AV
         I/RO3tkjy6hJ105i5vYS5/7Xi28bRqTpr127P2T/H/rv9KbZlntEX5qE5XT+nUVpEwu8
         5TiU8WktzlsBTXAujg0Ow4NNYxJNXiEnjemX9sSD3m7hqNvd8h17n7A9NbKGWwe5Vkvr
         2j/j9epCWuG5VNm4IBuDmC2Fmt+QdFHk1SsQbA6yCb3Ixz3/qgXAHNOkPrkhhveOHbcR
         1dyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=swaD7rtGstk7uPp8xpgXpYvwvFHl+ue+Q6oItIEhgIY=;
        b=K+B8jaVH5SDsaf8UNW7cq3kHZp4TcAATE99bp9HxmTUr3IFJJvgpY8j8NwBbCIJkwb
         vurZaBYScJy0MUBUqe3KF3KOMt215PnTftrkBR0AbXVxMJmHoMypIKPWKf9hyZv8Qk4X
         q2UIE1Nq9tL3kNWrTzhwaNX62nFZyOgKT203IfjnbQ7RpV6Z1vxz5kmOzS6whXC0Z/aT
         XreMggMCH3dR7m+z2dHGIBAzIAya2TpLXslIYny8r6st2faGfyubAMfjilCM6/0rUjBq
         ECiutgo5RB5AVyiqhCVl+Fdb5/5SdGah0cDLk8+i3TmMRuEMz4PxjkiRmxTyjPh0UcXO
         tMtw==
X-Gm-Message-State: AOAM531lDKjAhVsrH7ZXktEiAXebEQV9Cv8Hq9zbcXfYDCQcOzp2k84/
        gwAh42JbHBqu5lMQDajVctQCZiItjP8H9g==
X-Google-Smtp-Source: ABdhPJw7j92xOd6KdMAlflO3Zd2fgjO0VWyIzDtuL5l1zLzEifXYs3DjdYS1I/5Kywxe0hGETDBfCg==
X-Received: by 2002:a5d:5504:0:b0:203:e3be:518b with SMTP id b4-20020a5d5504000000b00203e3be518bmr22518888wrv.462.1647958148544;
        Tue, 22 Mar 2022 07:09:08 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-222-32.dab.02.net. [82.132.222.32])
        by smtp.gmail.com with ESMTPSA id m3-20020a5d64a3000000b00203ed35b0aesm21987733wrp.108.2022.03.22.07.09.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 07:09:08 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 0/3] optimise submit+iopoll mutex locking
Date:   Tue, 22 Mar 2022 14:07:55 +0000
Message-Id: <cover.1647957378.git.asml.silence@gmail.com>
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

This saves one mutex lock/unlock pair per syscall when users do
submit + getevents. Perf tells that for QD1 iopoll this patch reduces overhead
on locking from ~4.3% to ~2.6%, iow cuts 1.3% - 1.9% of CPU time. Something
similar I see in final throughput.

It's a good win for smaller QD, especially considering that io_uring only
takes about 20-30% of all cycles, the rest goes to syscalling, the block
layer and below.

Pavel Begunkov (3):
  io_uring: split off IOPOLL argument verifiction
  io_uring: pre-calculate syscall iopolling decision
  io_uring: optimise mutex locking for submit+iopoll

 fs/io_uring.c | 86 +++++++++++++++++++++++++++++++++------------------
 1 file changed, 56 insertions(+), 30 deletions(-)

-- 
2.35.1

