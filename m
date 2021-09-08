Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0099403CAC
	for <lists+io-uring@lfdr.de>; Wed,  8 Sep 2021 17:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344817AbhIHPmm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 11:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240206AbhIHPmm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 11:42:42 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E0DC061575
        for <io-uring@vger.kernel.org>; Wed,  8 Sep 2021 08:41:34 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id q26so3946456wrc.7
        for <io-uring@vger.kernel.org>; Wed, 08 Sep 2021 08:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p0CEYn5ofZc/BvqkxTM04o33h8RvU22EbL8ooG/FU2w=;
        b=j5clbbMTC5nJTa+xRbtTF3elmNX8+J7e1SmJ06xgwwJvnyIhBXPopQTz6SBKNg3h3A
         R/KidWMSZG/pVWh8U0/a5UASPpZB1+EpwvebmlXt+WPiGlLHJOgEIsKQm2TmSLACINXU
         g4yHAlDgxNJWNabiLwGwZtuj0ecTU+uUM84z6shdBZyb0B+Y/DmNT9S0ylL4yVh4wCrn
         Q22+Dzh1L54CZuYHkBo3XFGQKXfG//9WzRmLzKPB12H9WYJDxa/pLwMbx8oN3G0PErkI
         qhaG3ww2yvtEQmEaGqbXejUdMedhtgywrSUTlXRr3DWdvEj4RBlLJ7DOQwzmWPPta46c
         710Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p0CEYn5ofZc/BvqkxTM04o33h8RvU22EbL8ooG/FU2w=;
        b=xfHtBLlvUkRmn8fzmbb0NsnSLkHzX9GeYZtzsaEYMy7O9z26+cC1BXB0VtH0lMttP4
         IavGgI7efbrab1H9fKEguqwyBWgG9YZfph8EJrG/1PqHQMCgY86AZhlD26dqZhXjZcAC
         6CQ4OMEFtDuX1N3wjxWFYN27jJm2KmwWnQJJE7NMSmSw+zkd7HQT7IGO3dAb8WSoR7QR
         xulO49e9ur77PYMPE4W9wDutOTEI9SmifPGrAEnu0jyRahKCTRXtVpxz1qxbARPCWfP4
         HjoB37JG5tR7kwvmXh93ATWdGVD7Gu/2WK5j4pLrhPJqvitYhyv3a2OxWnI4/i4q1xm9
         LuDA==
X-Gm-Message-State: AOAM532hPfvVZiJm7w6A3QmMzh7Gr/UNOciPF5kbW43S3LQAo0zYsc1N
        a+0uHzhscV8egP5GwPNmbJ+t3B2QFko=
X-Google-Smtp-Source: ABdhPJxG3msEFE/hS8EuuyOi2+EOsq/rjhG2AOpDFg7K/uwL4igLIZodZ4CNNUXQPA2+cR+eNTqA0w==
X-Received: by 2002:adf:eb81:: with SMTP id t1mr2915885wrn.245.1631115692753;
        Wed, 08 Sep 2021 08:41:32 -0700 (PDT)
Received: from localhost.localdomain ([185.69.144.232])
        by smtp.gmail.com with ESMTPSA id s10sm2580979wrg.42.2021.09.08.08.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 08:41:32 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/5 for-next] small for-next optimisations
Date:   Wed,  8 Sep 2021 16:40:48 +0100
Message-Id: <cover.1631115443.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Small optimisations for 5.16, mostly targeting links

Pavel Begunkov (5):
  io_uring: kill off ios_left
  io_uring: inline io_dismantle_req
  io_uring: inline linked part of io_req_find_next
  io_uring: dedup CQE flushing non-empty checks
  io_uring: kill extra wake_up_process in tw add

 fs/io_uring.c | 78 +++++++++++++++++++++++++--------------------------
 1 file changed, 39 insertions(+), 39 deletions(-)

-- 
2.33.0

