Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E44922FC8AB
	for <lists+io-uring@lfdr.de>; Wed, 20 Jan 2021 04:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbhATDVw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Jan 2021 22:21:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731298AbhATCg6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Jan 2021 21:36:58 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D35C061757
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 18:36:10 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id c12so3077487wrc.7
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 18:36:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=38bNs2D+wnJJCAo6n0QniR/tj1axnsh+nvdg3Id7Slk=;
        b=TIqj40FJ/hPpHWOTW+lGSiWvb9H/6Le0GMaGqoEyef+UJANo1WtK0yB5XJP6TslWnQ
         oCsfyxg/bfPY9BxdokdN+//lWDzUPMgLYDWfLYjVZD9QKDiDfXD53WBi5J2bmux88kXg
         LQYjGLdMY/rxD9rzJMVRgtqnpPodgWoji1sd9VZ/mPW2oUNXRv0KAfxPDnua5kuhiXfQ
         dfoaTDfwigXQF5ShwGcN1hhez1EZs6c00zFWle63NaODaHcMIVQhaPi5flw5KIhAws8H
         jyD3JgmmPxODqI6Pk2Y+deHZfC15l6WsgcAHtE7VhwEezHlzW0a+XZFt6oWfHj70DjH2
         c9yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=38bNs2D+wnJJCAo6n0QniR/tj1axnsh+nvdg3Id7Slk=;
        b=PsW4/dPJBvdwB45rsn/zKHG0B1kzX4s+NQhAVNJNX00d5mATstFlMaZUy5Ip0Batyr
         98/wJBg9JDOX9XgfVkH37EwwvsKJkXZlwYDSS15A2JzSRVL+D2lkbQBGNXoyUADDfLpH
         bayF7Li/ehl+Z0MT6rXG5LsP3I5+Jryc8hfKVH9tpnzp7UCJPE+hZJAChNoQQFbFjKyF
         N4dyFkO31z/svtOhvp7zb+QOFfQQihm3yEqAi4mRKCyuM9f2gNtc5Xp5f05BaaDrSTlK
         Iw+8ZTZ6jefN/wwmzTUneuA84BLtFvSFBt5KroSAIUNOg+mBUhjPG3Fj1ij8YZutByZL
         Ih4Q==
X-Gm-Message-State: AOAM532nKOSXfK0GNgk9s5V4fnnUwFMhlXPqgTuzSSKrWhFO0EOzlqIh
        w7YsNDvyB48pANohFSAkUKM=
X-Google-Smtp-Source: ABdhPJxYbD6txi4zIv/sBvHcPkswMKdg+4K+yGCn2FT+9YkaRYk42zC5O0XrW6McB6AI2kLRygcyZA==
X-Received: by 2002:a5d:5181:: with SMTP id k1mr6760458wrv.226.1611110169087;
        Tue, 19 Jan 2021 18:36:09 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.152])
        by smtp.gmail.com with ESMTPSA id v20sm1082767wra.19.2021.01.19.18.36.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 18:36:08 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/3] files cancellation cleanup
Date:   Wed, 20 Jan 2021 02:32:22 +0000
Message-Id: <cover.1611109718.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Carefully remove leftovers from removing cancellations by files

Pavel Begunkov (3):
  io_uring: remove cancel_files and inflight tracking
  io_uring: cleanup iowq cancellation files matching
  io_uring: don't pass files for cancellation

 fs/io_uring.c | 168 ++++++++++----------------------------------------
 1 file changed, 32 insertions(+), 136 deletions(-)

-- 
2.24.0

