Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8EDD3E599B
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 14:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238481AbhHJMGx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Aug 2021 08:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238215AbhHJMGx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Aug 2021 08:06:53 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75088C0613D3
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 05:06:31 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 203-20020a1c00d40000b02902e6a4e244e4so737196wma.4
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 05:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Bd+NLYUYHKX27YaMshtkFENfBe7Qd6TQTvdSaUCqAII=;
        b=owjIoiN5dGuZ480HU6NChIggfS+djrOQxEsbWn0CD4mz9JA9kzdZqmVg4ETwKNKdPO
         1ysIWaT8FyZbjm1crw3RQ1u/QiPjRHs+qAgPgL/kKCrykPzoKNQOyO4mrQdoiiL+yPS+
         MsO7uPXRA419wnrRKWfFC+WKJpwLNtlOvbDoFKp1tq5E6zrQbNNMzcCG8V9vgVAeARGy
         8XwxAcO+hSgtHZeVPThMOqZ5syeWC2aDr0bDDSMulZLsGG03rYR3Fme48wDFTzCBIVvN
         lLPhUurwXTlk1Lv1ejofbL2LlmEOiC5GW0465sJ1AToi9CLpsJ4g+5e2Cw07KAiG4FXx
         a2PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Bd+NLYUYHKX27YaMshtkFENfBe7Qd6TQTvdSaUCqAII=;
        b=CxAkEIN1YnQtLYwDHmjvRUHp1PGBknv0iwtmjj0ZjtRoPw9gkeposb/MjTGrb/Vh0F
         2eatbIMoNK9Mzq4K5PPxFNdQ3xd3UH/eYoeEt8urxVAj3zoYqbnPzXUqSPaVCg+Lq4+l
         bbwDTWBaoIF0iegdyRGF6kQd+r+LUjkeD164thfA1FTJjMAfOHj7wEQRu3Tb219UC1eY
         m6NFJ96ZWsEYHM/tvWOXMXNaX3MPGkrZn3oY87CMiAIB8iyoE5ekQiA6kbzr/b2uWo86
         3ebzHkFCfV4U5dYuQuGC47em6ojiKhgPbGuD9V26Ib8pbD0zy1V5t1jpR26ynJOSFlh9
         wBFw==
X-Gm-Message-State: AOAM530mbQYXmu9idaL5Kbo12uu5PQ+/H09EGBzTtTQ3Dylfz5+CkPNb
        INb6QwSWwyA6h6qpnCDuUn2nHIRjkKg=
X-Google-Smtp-Source: ABdhPJyjFs+SehAIkTewWwoVNtlulRqFKe6gZabz4nL/iuIUJMZDTdquBOpYV/eFh5TWb1m3ySnPxg==
X-Received: by 2002:a1c:9d4d:: with SMTP id g74mr3728748wme.61.1628597189949;
        Tue, 10 Aug 2021 05:06:29 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.97])
        by smtp.gmail.com with ESMTPSA id d15sm24954362wri.96.2021.08.10.05.06.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 05:06:29 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/5] skip request refcounting
Date:   Tue, 10 Aug 2021 13:05:49 +0100
Message-Id: <cover.1628595748.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

With some tricks, we can avoid refcounting in most of the cases and
so save on atomics. The series implements this optimisation. 1-4 are
simple enough preparations, the biggest part is 5/5. Would be great
to have extra pair of eyes on it.

Jens tried out a prototype before, apparently it gave ~3% win for
the default read test. Not much has changed since then, so I'd
expect same result, and also hope that it should be of even greater
benefit to multithreaded workloads.

Pavel Begunkov (5):
  io_uring: move req_ref_get() and friends
  io_uring: delay freeing ->async_data
  io_uring: protect rsrc dealloc by uring_lock
  io_uring: remove req_ref_sub_and_test()
  io_uring: request refcounting skipping

 fs/io_uring.c | 176 +++++++++++++++++++++++++++++---------------------
 1 file changed, 101 insertions(+), 75 deletions(-)

-- 
2.32.0

