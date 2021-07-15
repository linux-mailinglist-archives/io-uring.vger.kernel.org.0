Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC5943C9D0E
	for <lists+io-uring@lfdr.de>; Thu, 15 Jul 2021 12:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241616AbhGOKsn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Jul 2021 06:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241613AbhGOKsn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Jul 2021 06:48:43 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54604C06175F;
        Thu, 15 Jul 2021 03:45:49 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id qb4so8482786ejc.11;
        Thu, 15 Jul 2021 03:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FwwLaXHeFD676V7GhX0BNFyfYdUME4hhQYfPK3kPSew=;
        b=LqIOBe+FxZPw2bEagj+i8pD4iScWyZ984CDYMQphE8LakbG3GSLi8Z8A7o/sowg1fi
         5NW2KGkojWkGoiczpAUh0RqvbHHXpdL5TPoZ/dMHzPQ9wxsHfFEfNzDl2YOeQ5CGq4JV
         QBvTsUqYnvSZXYlzMawwbY0/PdXs+8iy4XTd9vsjPe7sCECrIssXeOChBGG3AUGoRKoH
         G0MbQp/vK79487C73ApOoxu0A9DbbMkBXKhEcAZnARL24HFloQ8+d3HWFJzTx46nocAo
         koNVpjkNN5nottPgIsi2y8mubmE5RPk6AHvHwpB1vc0JzeQCzmaDwQg1ma8wac3+eG2U
         g/yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FwwLaXHeFD676V7GhX0BNFyfYdUME4hhQYfPK3kPSew=;
        b=Vn/nEwekx+2vIsixf2Ro5/rDZ99xcruzMKO/DzByTP3epwCz2zKXcYA5fXx9y2sIif
         cFgSW0+csLbJQC3sxsN7RPB4tFjo1ye1KJrNGZyDidO2278/mk+yIZYRwfWdLpczrQlu
         wFnug4ZKAlDSoqJePJ83C0SZ68+eC5Y5XxB7x+oXEvavWYDSgO4ERtTHdytrqBw25pHt
         F7oC5dmr0SjAXu/VKdGDqXBJZlkjU8yDdskP9pL8I+7J3Ruu1TSAMEgd+YkW2iia5Z+A
         kUWrazzU/oW1svnNSLbPLJacRgdIWIMGJkOVhMl0bC5qsXJEhHuVPeV25V/F3N9oyOAK
         NF8Q==
X-Gm-Message-State: AOAM53081e8lXAPHwQKBSZ7SeclN8Kds/2FyioHyAZrWcxOT7o9NyXH4
        3vrh3XjzYWDEL5xMmquHXS0=
X-Google-Smtp-Source: ABdhPJwcc9i5Uz/wI1jXhN4AzFXT129QvaxOX+XOjxQL8ktg7cyXYi8Rg6TqCuJBFpGt+RpnIoCvzw==
X-Received: by 2002:a17:906:39d7:: with SMTP id i23mr4825375eje.121.1626345947928;
        Thu, 15 Jul 2021 03:45:47 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id d19sm2231498eds.54.2021.07.15.03.45.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 03:45:47 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v2 00/14] namei: clean up retry logic in various do_* functions
Date:   Thu, 15 Jul 2021 17:45:22 +0700
Message-Id: <20210715104536.3598130-1-dkadashev@gmail.com>
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

