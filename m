Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDED4E7274
	for <lists+io-uring@lfdr.de>; Fri, 25 Mar 2022 12:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240103AbiCYLy7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Mar 2022 07:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233824AbiCYLy7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Mar 2022 07:54:59 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72329AE51
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 04:53:24 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id p15so14845498ejc.7
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 04:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4/30JCC7bO7Y4ed3Rx8Mol+6pP0u6yiNgFFIcsqTg6g=;
        b=cC4Q5pfjw8jAsS7yJSeTiK5kB4yMy4bjQk1O4PzgGMGV8T4d5R+JPAkuRIx0upPRFd
         HUDC5ypbvWiWlDmBbdwEux1NDQbdJmRg7MN5rKhHk5VNR2L7jrgnxQMEbfnOc+qhtBN6
         DNTeTMjJl8fsLYcgW34Kvi/Ty4gvHNYEzKw4WTfddSwQ4KPz0zshRzRfI3OW4RjcosAn
         cWAmjxatU6FS+NIvK4xB006/UELl4z49gwQ+FH5ppdIao0V7hQvqZEOIC6TE07T2bDes
         PKg4pq/6SqnAfw7icarhsvOGPPxE3UCUlfMF81G5R/EZAdU7fsXAJyW6e36XBOlXKl6T
         Culw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4/30JCC7bO7Y4ed3Rx8Mol+6pP0u6yiNgFFIcsqTg6g=;
        b=xn40U9ytVq6zxIkH+RenWNl9R+00q3ld7fu8NE3XqXcKNox0DvYvzj4ycNik3hLKWP
         YPzno74GNEmazZKrb/kDgMoHHxbiSPrrJaHk+Dg8dDB5nucsryYnR2Ds0zIaLB1UDWiM
         Qm+FKBUVRhB/6+pG2i6dHwa9isSESRxsSPyNaG6Ykl8lu/s0E9lDJTVh5bs/P9Rknrav
         4liEEdqd+UrmYcsnetNmw1gQ9iej5t0spKdQiovYZS1byoXTlK+S9xerTRr358/972RM
         jiLbzAVAM1523UNVU3Ws5cRoyG8A5rnMmq0ZFbVLLHG9qQGGGRkk7d765XQrD8L9Oz7K
         C4PA==
X-Gm-Message-State: AOAM531/m6mrE8wXDzhSJV1RtK7WOZHp5he2QonFPvTRmj/7+w6TmCVZ
        RDpilNNHPpFPEaAvpAx5H7PxQsojoo1SGQ==
X-Google-Smtp-Source: ABdhPJxTETKiiGnGiG4FFuME6oarBYQZMYL3hEViehI8gGcD5KMWs+8UVg/egTAJ37CZtvLdvRRWsg==
X-Received: by 2002:a17:906:4408:b0:6da:bec1:2808 with SMTP id x8-20020a170906440800b006dabec12808mr10958000ejo.543.1648209202559;
        Fri, 25 Mar 2022 04:53:22 -0700 (PDT)
Received: from 127.0.0.1localhost ([78.179.227.119])
        by smtp.gmail.com with ESMTPSA id u4-20020aa7db84000000b004136c2c357csm2706777edt.70.2022.03.25.04.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 04:53:22 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 0/5] small for-next cleanups
Date:   Fri, 25 Mar 2022 11:52:13 +0000
Message-Id: <cover.1648209006.git.asml.silence@gmail.com>
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

Minor cleanups around the code w/o any particular theme.

Pavel Begunkov (5):
  io_uring: cleanup conditional submit locking
  io_uring: partially uninline io_put_task()
  io_uring: silence io_for_each_link() warning
  io_uring: refactor io_req_add_compl_list()
  io_uring: improve req fields comments

 fs/io_uring.c | 130 +++++++++++++++++++++++---------------------------
 1 file changed, 61 insertions(+), 69 deletions(-)

-- 
2.35.1

