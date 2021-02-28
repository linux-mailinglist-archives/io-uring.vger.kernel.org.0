Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39DBF3274E7
	for <lists+io-uring@lfdr.de>; Sun, 28 Feb 2021 23:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbhB1WkA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Feb 2021 17:40:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbhB1WkA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Feb 2021 17:40:00 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D5EC06174A
        for <io-uring@vger.kernel.org>; Sun, 28 Feb 2021 14:39:19 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id a18so5932965wrc.13
        for <io-uring@vger.kernel.org>; Sun, 28 Feb 2021 14:39:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XhXj7a8fcg40UIMCg7yQT5UJd0C82FmgngQJRiaNwSQ=;
        b=sxeWtLYopJi8sZYVwJLC3frSHYVvtiSV6mt+K2895iD59JsNdL2QxPpHR7Tqoi389g
         r1ldZLif6cMGMlA9azFYfScKUEorY8NcXZ/g2Be9X3acs+MBtGOptryqCxdGv7xqXJiR
         qn2GrDM/CasWkYFET47ukS2Rc+4eXsc/1Yt+sfRarnfc1gm/KBtNQIx5a9pj5AzjGB76
         0QeOhy/VLzcwqiJXkPgPrTHA5QN0owJP9tpjP1+/I7UYP+TekJ+TsO6sw/T08uKpwv9H
         36Kh1hLiimwyvktZj4rRRsFtYBHJ9UrFVRF49Zadjdg5mfYSGUbPzu7xitagaktSnmrp
         ++Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XhXj7a8fcg40UIMCg7yQT5UJd0C82FmgngQJRiaNwSQ=;
        b=UXvNs9wxS26r268s9fXxckJGMvRzKrlMxa9bqeDrTzBRq0HBD2+szIUQE2zxK3dJD6
         PkMFKGc6i8djPzjl9QP2+M+259ghKFnJiFo6UBAXr7MPM/cJSFhbR1sJ7VUz3Iw+SU4S
         juW/+hi14Pd8WurBRwkqnYFsbh1PRwbV9tJ9B6u44ASSY2lVPUN70dXwM7Xn+ou62j24
         8XJNa8WoAWJMbBraHPp3ser+zNDHZnTlwVaNyUj9j3A4mXf4ZnGyuCU8tVegsqSmlc71
         /Kb0kqBVDzKbBK+Bft9G4wrSqleqnO+R8PlwBf4zFVJ71InslvBYTkgPYiN1BljwSzC1
         GHcQ==
X-Gm-Message-State: AOAM531ONgdJvUcsyrJUAVIjWzTi6fzX6y80syo/e92z2hPmu7zbj2J4
        MJiqKf5AIHgS2N9YQ3JwEUMn4IQRS15Hvg==
X-Google-Smtp-Source: ABdhPJzV2+avwL18dYrt8mOZaD6Ou5gCcgoEfK/58MtTlaQ/VUEEnAuMiR0r1GkfaEm5BBVpeHCwVw==
X-Received: by 2002:adf:d1ce:: with SMTP id b14mr13730368wrd.126.1614551958516;
        Sun, 28 Feb 2021 14:39:18 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.38])
        by smtp.gmail.com with ESMTPSA id y62sm22832576wmy.9.2021.02.28.14.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 14:39:18 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH RESEND for-next 00/12] 5.13 first batch
Date:   Sun, 28 Feb 2021 22:35:08 +0000
Message-Id: <cover.1614551467.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1-7 are just random stuff
8-12 are further cleanups for around prep_async

based on io_uring-worker.v4, but should apply fine to for-next

Pavel Begunkov (12):
  io_uring: avoid taking ctx refs for task-cancel
  io_uring: reuse io_req_task_queue_fail()
  io_uring: further deduplicate file slot selection
  io_uring: add a helper failing not issued requests
  io_uring: refactor provide/remove buffer locking
  io_uring: don't restirct issue_flags for io_openat
  io_uring: use better types for cflags
  io_uring: refactor out send/recv async setup
  io_uring: untie alloc_async_data and needs_async_data
  io_uring: rethink def->needs_async_data
  io_uring: merge defer_prep() and prep_async()
  io_uring: simplify io_resubmit_prep()

 fs/io_uring.c | 210 ++++++++++++++++----------------------------------
 1 file changed, 68 insertions(+), 142 deletions(-)

-- 
2.24.0

