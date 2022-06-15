Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECE354CEBF
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 18:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356130AbiFOQeb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 12:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356290AbiFOQe3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 12:34:29 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747DD2AE20
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 09:34:26 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id z17so6626357wmi.1
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 09:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k46oSdWBMRFyrSPcvfSDXhtbQZ+LMkvj3QX/VlFQyEs=;
        b=m/tkFw9NYuvs3nTcLBTFFvJ6CYz6n/KeGv1VTjOTmR5qjxwJHzYy7YIEfY5c8x56Yi
         emakDT69EQY56rDoVFb6GBVT7zEoc+mx0nKoA7ZuQ1iGhlxCgZZ6yloWrD6vr2N/smwM
         SxXKsKZJ/W/AQl62pwzbvx6gMGfcyqkoqDIpgOcygm1g5LKeZRiHqMXsEL2EzUjjUzUr
         gHU6z8/sTKCoofCqjdoZK/aHoF5qah+39xsQzvBo5/dzUa/WgTcHWnnbOJ1t2oxeRr56
         Ot7TtwiBYc1LHurmfYkj56pq3ysgEEqWfOrkhRZvlTNkGl2y4aNH8kUeg3WIbPKWnihn
         qXYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=k46oSdWBMRFyrSPcvfSDXhtbQZ+LMkvj3QX/VlFQyEs=;
        b=VQ/MJTzFhODTzy0OjQeJtq6F0iDRFx55/7IgITHdoij/EnLbbK5h3YSRQW3+gNLzYi
         cLKA6GJB+mYr8FByfojrqGIKgYbpH/00sjMQGF9t8oCrUNflHZVyIt5lZ2oZjm3eh4Wj
         HO0JZDDzkBpKPa6aUv6Tl/aWhZ6GCxyT81tcwdh0CK1RRCpanMb2SHfeznoPutHcOhww
         Fp5JMHTXCfvr3IIJMVa+JFeZGleP0+rgqMhEUVqwku/8GBgnFU+lRBQkoyo15UgMUKeO
         QfvK7c3moKEfG2TgaXBJh5x9G+p5xpU99MJCYOgVgn5XF7j0TkN4m0Ayizqs68yHNEP2
         Q2rg==
X-Gm-Message-State: AJIora/a73N5FmqWOv+AeWk51hT9h+XF2r9BGo/zIhPUhHywiQ7s2qEq
        79QYnCCQ2oGYtQJMeLzABa+IJI1Zh44M/A==
X-Google-Smtp-Source: AGRyM1vMS+xuzlmHO+1/5ZBb1+gbyBbpXTpoKXGMfA7l1FlLsukoRlV2DrW3XAlxvjQTSHM7wPIAYg==
X-Received: by 2002:a05:600c:29d3:b0:397:4730:ee75 with SMTP id s19-20020a05600c29d300b003974730ee75mr267730wmd.149.1655310864652;
        Wed, 15 Jun 2022 09:34:24 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id u2-20020a056000038200b0020ff3a2a925sm17894953wrf.63.2022.06.15.09.34.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 09:34:24 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 00/10] 5.20 cleanups
Date:   Wed, 15 Jun 2022 17:33:46 +0100
Message-Id: <cover.1655310733.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
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

Simple cleanups split off from a larger series.

Pavel Begunkov (10):
  io_uring: make reg buf init consistent
  io_uring: move defer_list to slow data
  io_uring: better caching for ctx timeout fields
  io_uring: refactor ctx slow data placement
  io_uring: move small helpers to headers
  io_uring: explain io_wq_work::cancel_seq placement
  io_uring: inline ->registered_rings
  io_uring: never defer-complete multi-apoll
  io_uring: remove check_cq checking from hot paths
  io_uring: don't set REQ_F_COMPLETE_INLINE in tw

 io_uring/io-wq.h          |  1 +
 io_uring/io_uring.c       | 55 +++++++++----------------
 io_uring/io_uring.h       | 22 ++++++++++
 io_uring/io_uring_types.h | 87 ++++++++++++++++++++-------------------
 io_uring/rsrc.c           |  9 ++--
 io_uring/tctx.c           |  9 ----
 io_uring/tctx.h           |  3 +-
 7 files changed, 93 insertions(+), 93 deletions(-)

-- 
2.36.1

