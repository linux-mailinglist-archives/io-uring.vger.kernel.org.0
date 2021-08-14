Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9C833EC3CF
	for <lists+io-uring@lfdr.de>; Sat, 14 Aug 2021 18:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbhHNQ1R (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 Aug 2021 12:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234941AbhHNQ1Q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 Aug 2021 12:27:16 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0798AC061764
        for <io-uring@vger.kernel.org>; Sat, 14 Aug 2021 09:26:48 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id g138so8805145wmg.4
        for <io-uring@vger.kernel.org>; Sat, 14 Aug 2021 09:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GfAcGhd90dJax6PHtFt8tcbEdaD2zeW27prl2X8LKyU=;
        b=umO0MbPZzMd4VesJRH5wQr1vpwxKRHE0VrFaWYwoVLyQlsFxTZAMcAYyJxHAL3VpGz
         g1RJdrr/kQHD4EL4zhjObUx4JXKWm6kB1B8JzmAGndlAua0/Q2Lyly6l4aSuHPRHlElJ
         kKTtKSW3Kz6LfXgOShmNb1QOI4mE+jpZpu0IRp4Ept3rDE+Y0Lmk/OlSRxQXOakXXYrc
         qbDAiwnZ+2laCeQletvIPcRR06BRz1f5LFob7t4j9H5vH3vISTTQoHVzuw9lUy6i4m6V
         no3IeCxewTySTG1xmdmkw5bOqkI+bygusnTRrkMoJHc7wcD1KDE9cTyGENApSKRA+AQD
         64nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GfAcGhd90dJax6PHtFt8tcbEdaD2zeW27prl2X8LKyU=;
        b=U+W+0TmM9ifhLhhElQmItopmzPlAeHqGfeKGpcXM22CGOFnIjy0tVG9YWPXERPLmud
         9X305d4DNhfAJpSzlRydkhL6ijdy6WGGBOmUipoV32t03cYWfTBaROgztbq0THkopFnR
         Efbj3DkdAP35hODBVhNKPi4h79PHKClvbOH8Ip+69gaJ7M0vDCjBSXh+PbwzIZOfpmLd
         gBgDCcRwTTQDlSvezrfVt3XtDOnz0LsPxzkIx9wBnOx33G52fJzHz31qnnIJ0+jCIyPk
         cxHlDTjLROLureDolffB8jnzq5YkkiOtEs1idI3o/8qlTChjFoM+y1RPgmBvmezCSOT8
         rwlA==
X-Gm-Message-State: AOAM533E7sKjTSlnCBWcXGodxc0QN6QIcaEs7j77Bm+ZwbBL5cYP8te1
        KkhCVvFGgmdDxoDk+u3GfV0=
X-Google-Smtp-Source: ABdhPJzPsYyui4LPmvOXpEFNdliEnP7oBaxFHw4y1EGAJucOrl/ANa/kj7CWQntK4rEvDDiN/z4Dww==
X-Received: by 2002:a05:600c:3593:: with SMTP id p19mr5750935wmq.95.1628958406602;
        Sat, 14 Aug 2021 09:26:46 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.97])
        by smtp.gmail.com with ESMTPSA id m62sm5028263wmm.8.2021.08.14.09.26.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 09:26:46 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH for-next 0/5] 5.15 cleanups and optimisations
Date:   Sat, 14 Aug 2021 17:26:05 +0100
Message-Id: <cover.1628957788.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Some improvements after killing refcounting, and other cleanups.

With 2/2 with will be only tracking reqs with
file->f_op == &io_uring_fops, which is nice.

Pavel Begunkov (5):
  io_uring: optimise iowq refcounting
  io_uring: don't inflight-track linked timeouts
  io_uring: optimise initial ltimeout refcounting
  io_uring: kill not necessary resubmit switch
  io_uring: deduplicate cancellation code

 fs/io_uring.c | 82 ++++++++++++++++++++++++---------------------------
 1 file changed, 38 insertions(+), 44 deletions(-)

-- 
2.32.0

