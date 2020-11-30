Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 339642C8DEE
	for <lists+io-uring@lfdr.de>; Mon, 30 Nov 2020 20:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729906AbgK3TVJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 Nov 2020 14:21:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729913AbgK3TVF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 Nov 2020 14:21:05 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2EFC0613D4
        for <io-uring@vger.kernel.org>; Mon, 30 Nov 2020 11:20:25 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id o1so3770177wrx.7
        for <io-uring@vger.kernel.org>; Mon, 30 Nov 2020 11:20:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KOPrbukq3YaRklZhCGG889Tm/jJw2nOlCFD+c/sWc+E=;
        b=nV/ZUnTvpLDzHzEPvUFiJDPrHDyZ2fSex/y6ORIn9a+SdY3n9Oh6d6LHuHwl4L463H
         3F8peK4vMLjataSJLgrbF4fB9pxT0g076Jt4Uh371+K32+MHGweY0to0u/rISVMTQpod
         3yYc+vpxfSBaYjagpJSCq7fticGpuOMKRK/lv5f1uI2hIK19NG2RewygzK4JTJn/3KNr
         T2ByecUGIGgjaayLnI1qpFcHbR031+OJ50ORjscnBAqXAcjwiCXZcyUQ6I0qHAMYCY7Z
         MuAUmfyzONlm0mYrIHIiGV1ErIlTZLCcYhBqcIKzS5WWGcO6g7jE/HOLAFJLQ2OJC5k1
         wQRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KOPrbukq3YaRklZhCGG889Tm/jJw2nOlCFD+c/sWc+E=;
        b=pV15kJlol8xBKMEThfwoWBT1jaGCYsShH6IaJXx9OXj1yJ8/CYVgRkvPhpr+ZBbskF
         7hkf9fdtQY+t5SlkMI6dndmfrJD1H+1n7vCS5kW11wlLq2RxxAZ+vrFklMtLqqd6W8te
         HhtRreh4bmVGQSGTT+jsTGp0Wl9GHcYr0LnekZWx1AgPpCr22dky5JNHD10D0oagFJ2C
         RbtVSgTamGJnKk2/G4XQzmU6CXfF8nxmHjZf060XDAL7BJQ2R0GvLk+OnpfUVVuWOfZf
         ENYHeM5pkru0Dmk/P1b4O0A5TQZKqIGvP1A9F+S1YO5u2+fLI/9z+pxzooQ2Rgcle3Fr
         TqpA==
X-Gm-Message-State: AOAM533PuqVUvpbJAWk+EBHJtkfoaLAKInGK7UFSjhjhnYwKNrsiL07Z
        2tHJ1qkdyqQUjUejdjRlFi0=
X-Google-Smtp-Source: ABdhPJxokcLOI7yGriBFXNBj25QXRHyh9/kmHKNDYxqNUiW0yNlDRlaJ/SkTxolWwVmmQCeitVadnQ==
X-Received: by 2002:adf:de12:: with SMTP id b18mr30154657wrm.187.1606764024126;
        Mon, 30 Nov 2020 11:20:24 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-135.range109-152.btcentralplus.com. [109.152.100.135])
        by smtp.gmail.com with ESMTPSA id i11sm29886775wrm.1.2020.11.30.11.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 11:20:23 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing v2 0/2] test timeout updates
Date:   Mon, 30 Nov 2020 19:17:00 +0000
Message-Id: <cover.1606763704.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

v2: [1/2] bit 1 for IORING_TIMEOUT_UPDATE
    [2/2] test sqpoll

Pavel Begunkov (2):
  Add timeout update
  test/timeout: test timeout updates

 src/include/liburing.h          |   9 ++
 src/include/liburing/io_uring.h |   1 +
 test/timeout.c                  | 272 +++++++++++++++++++++++++++++++-
 3 files changed, 281 insertions(+), 1 deletion(-)

-- 
2.24.0

