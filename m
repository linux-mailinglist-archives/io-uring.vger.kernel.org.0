Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A03C3C9CD0
	for <lists+io-uring@lfdr.de>; Thu, 15 Jul 2021 12:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232542AbhGOKjE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jul 2021 06:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232526AbhGOKjE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jul 2021 06:39:04 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A15EC06175F;
        Thu, 15 Jul 2021 03:36:10 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id h8so7427638eds.4;
        Thu, 15 Jul 2021 03:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FwwLaXHeFD676V7GhX0BNFyfYdUME4hhQYfPK3kPSew=;
        b=bHS8DCtxxF9lDg973HKJJvhPTD5l+/YGDoUowamOiEvU21nCtztYzu14qnsiLLB2DX
         AJX+1lqcspDexte1ViAeJBoGWcK/0aff1fde/yXpJ8EznldR+x8ghUulD6onO8UETrr4
         fgHeX3e+w2JncxgI5BqaX4v6UcgWekFKCkL8VGz/gAlTuPdEbaVLSrCa+8ekMHG9IRdu
         tOp3MbJ3F/ktNhhgj5iiMDY9PEegW8HzwpUCwKuQHJoKXvXZDUSllTmO0MYGwm2oVnJ2
         EObTb46gKN3/K+5nC9TxGQAk2o4UFdiw3HDYe4yYBCgaGal37h2hTA33zsKT04uD+oS+
         91Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FwwLaXHeFD676V7GhX0BNFyfYdUME4hhQYfPK3kPSew=;
        b=gCaZnk+JNND+Hl9M1qmXZ6rFg3MC3yCBmz/X32NbFyV92BPLx2zVA0o7kyWJJDSdDG
         ldzBG7iZSM+Vu7ENXY6g/a9Nb3UtBYrFx3t29Pt/Tkd6DgWUfBW+5YsPJOCcoxIvW+wI
         D8djUtYaf/dGA955VX4ppPv48C983q+jBDlrcMN2ZAvUHvOUji7SjH/mhnrRSwgcTlMh
         FloHn49gpror7RSFNbjewuGr7AVAe9Pi4G9YntR8QGCt9HEOeIGq9Qw2p1RrTUqRCHuB
         Xsk5Iq8EGMYAGdfRuodo6ztbDNaqrOjwaQl+VpgntSqAZJtTHqcNieR5WKRsvi8gNFD8
         F4IA==
X-Gm-Message-State: AOAM532FvZsKbVLbAMfxpgKz0FGCxDM0A6RXNk4H9KkLtvagkwWoQFE2
        U7F7UOe6uB59SfjuSNIOLuk=
X-Google-Smtp-Source: ABdhPJxvkCRrLxCUkrvohOuOcpaB29uUCe4cVF9v03r+3+Rx/zI4fmG8nCcGNfEl2WNy/Ch/CH9/Rw==
X-Received: by 2002:aa7:c04e:: with SMTP id k14mr5866183edo.157.1626345369016;
        Thu, 15 Jul 2021 03:36:09 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id dd24sm2228464edb.45.2021.07.15.03.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 03:36:08 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH  00/14] namei: clean up retry logic in various do_* functions
Date:   Thu, 15 Jul 2021 17:35:46 +0700
Message-Id: <20210715103600.3570667-1-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Suggested by Linus in https://lore.kernel.org/io-uring/CAHk-=wh=cpt_tQCirzFZRPawRpbuFTZ2MxNpXiyUF+eBXF=+sw@mail.gmail.com/

This patchset does all the do_* functions one by one. The idea is to
move the main logic to a helper function and handle stale retries /
struct filename cleanups outside, which makes the logic easier to
follow.

There are a few minor changes in behavior:

1. filename_lookup() / filename_parentat() / filename_create() do their
own retries on ESTALE (regardless of flags), and previously they were
exempt from retries in the do_* functions (but they *were* called on
retry - it's just the return code wasn't checked for ESTALE). And
now the retry is done on the upper level, and so technically it could be
called a behavior change. Hopefully it's an edge case where an
additional check does not matter.

2. Some safety checks like may_mknod() / flags validation are now
repeated on retry. Those are mostly trivial and retry is a slow path, so
that should be OK.

3. retry_estale() is wrapped into unlikely() now

On top of https://lore.kernel.org/io-uring/20210708063447.3556403-1-dkadashev@gmail.com/

v2:

- Split flow changes and code reorganization to different commits;

- Move more checks into the new helpers, to avoid gotos in the touched
  do_* functions completely;

- Add unlikely() around retry_estale();

- Name the new helper functions try_* instead of *_helper;

Dmitry Kadashev (14):
  namei: prepare do_rmdir for refactoring
  namei: clean up do_rmdir retry logic
  namei: prepare do_unlinkat for refactoring
  namei: clean up do_unlinkat retry logic
  namei: prepare do_mkdirat for refactoring
  namei: clean up do_mkdirat retry logic
  namei: prepare do_mknodat for refactoring
  namei: clean up do_mknodat retry logic
  namei: prepare do_symlinkat for refactoring
  namei: clean up do_symlinkat retry logic
  namei: prepare do_linkat for refactoring
  namei: clean up do_linkat retry logic
  namei: prepare do_renameat2 for refactoring
  namei: clean up do_renameat2 retry logic

 fs/namei.c | 252 +++++++++++++++++++++++++++++------------------------
 1 file changed, 140 insertions(+), 112 deletions(-)

-- 
2.30.2

