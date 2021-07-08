Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A21E3BF595
	for <lists+io-uring@lfdr.de>; Thu,  8 Jul 2021 08:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbhGHGhv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Jul 2021 02:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbhGHGhv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Jul 2021 02:37:51 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C044AC061574;
        Wed,  7 Jul 2021 23:35:08 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id x12so6897859eds.5;
        Wed, 07 Jul 2021 23:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uR+36EWv46gYxO+tNpHgOc1tUufNJEtMP3npNKkJ6r0=;
        b=HXX5pJgC1DUodChuU6Q3kqVHJ/3nuzjMu1tkimAxtT97wa/pxZqWmQ13ZT6RK/SyEv
         3DM6j9t7jKpi2j+sVDWLTbwN9gmQRhoNiic/WF2rmuO1ZwNd7NfzzWzv2/2lFYZuYhrV
         QKFepNPXW+QlsKsBvxGC/4eDI9w4j1zaNEL/ZFxL9AMmalrpXPgcGxgdiCBT6nmEb8Pr
         6/4xqtJsB/2vmKUnTGeehzolzpZiHv8ZJyPzpxJI9XRzqGFaNZE375xNpteH9G0KF7Ua
         5+3J+mGCQh2EpNSuLKFxYO6TOzqgSOigDZUoobI6luuX2sabiTVGf4AdctGHvmurShjv
         Ktqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uR+36EWv46gYxO+tNpHgOc1tUufNJEtMP3npNKkJ6r0=;
        b=a7DIhHwQobdBR3TjTklT3pwzB+tlXy1rznqIS+qCl8tAKxX/g1WgJmeMVlfpCpWkS4
         16figGs9wV+fvNm2VLJHeLlR8hEV+mdXJGn5o3yyReYVkxDAh8OxmB+7deaS+J1/Ze75
         2evFkqA5vUp18o/5XWT23lf3HFhMKA0xJ3Dz11K2NBdYLiRETGeE0HGIXf8kGxpTQlwG
         jBzdQmCiHOfp2awxklcP39r3rn7F7dV8+vM3ciNFadfV5n8yMbb26IHSx1ejEmp6ceIZ
         65+CvqABFR1xMY+epno2wUe5yXWw/yUBvzfstfhhVSJiZcq2FDiutVhMy22V1Fq8nlLj
         KWgw==
X-Gm-Message-State: AOAM531kUOVmNZPdbj8VMCmznotwMhEsUd/yavjqu1pOXSPqksis43TT
        K2bonuQlJ2ie1ekmZjk1OFpSgauUcuYz66tT
X-Google-Smtp-Source: ABdhPJyNIs1Xybl2aejC7cq593mSuIWtrJ+zArExzujihn1zb40IefX+j0XNQIquXlLw0vPekA40lw==
X-Received: by 2002:aa7:c74e:: with SMTP id c14mr7860744eds.40.1625726107285;
        Wed, 07 Jul 2021 23:35:07 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id u21sm410260eja.59.2021.07.07.23.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 23:35:06 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v9 00/11] io_uring: add mkdir and [sym]linkat support
Date:   Thu,  8 Jul 2021 13:34:36 +0700
Message-Id: <20210708063447.3556403-1-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This started out as an attempt to add mkdirat support to io_uring which
is heavily based on renameat() / unlinkat() support.

During the review process more operations were added (linkat, symlinkat,
mknodat) mainly to keep things uniform internally (in namei.c), and
with things changed in namei.c adding support for these operations to
io_uring is trivial, so that was done too (except for mknodat). See
https://lore.kernel.org/io-uring/20210514145259.wtl4xcsp52woi6ab@wittgenstein/

The first patch makes putname() ignore IS_ERR_OR_NULL names and converts
a couple of places where the check was already implemented in the
callers. No functional changes.

The second one splits filename_lookup() that used to consume the passed
struct filename * on error but not on the success (returning it) into
two: filename_lookup(), that always consumes the name and
__filename_lookup() that never does. This is a preparation change to
enable the subsequent changes to filename_create and filename_lookup. No
functional changes.

The third patch is preparation with no functional changes, makes
do_mkdirat accept struct filename pointer rather than the user string.

4-7 just convert other similar do_* functions in namei.c to accept
struct filename, for uniformity with do_mkdirat, do_renameat and
do_unlinkat. No functional changes there.

8 changes do_* helpers in namei.c to return ints rather than some of
them returning ints and some longs.

9-11 leverages the previous changes to add mkdirat, symlinkat and linkat
support to io_uring correspondingly

Based on for-5.14/io_uring.

v9:
- reorder commits to keep io_uring ones nicely grouped at the end
- change 'fs:' to 'namei:' in related commit subjects, since this is
  what seems to be usually used in such cases

v8:
- update filename_parentat() calling conventions to be uniform with the
  ones followed by (changed in subsequent patches) filename_create()
  and filename_lookup()

v7:
- rebase
- make putname() ignore IS_ERR_OR_NULL names, remove conditional calls
  to it from the callers

v6:

- rebase
- add safety checks for IOPOLL mode
- add safety checks for unused sqe parts
- drop mknodat support from io_uring as requested by Jens
- add Christian's Acked-by

v5:
- rebase
- add symlinkat, linkat and mknodat support to io_uring

v4:
- update do_mknodat, do_symlinkat and do_linkat to accept struct
  filename for uniformity with do_mkdirat, do_renameat and do_unlinkat;

v3:
- rebase;

v2:
- do not mess with struct filename's refcount in do_mkdirat, instead add
  and use __filename_create() that does not drop the name on success;

Dmitry Kadashev (11):
  namei: ignore ERR/NULL names in putname()
  namei: change filename_parentat() calling conventions
  namei: make do_mkdirat() take struct filename
  namei: make do_mknodat() take struct filename
  namei: make do_symlinkat() take struct filename
  namei: add getname_uflags()
  namei: make do_linkat() take struct filename
  namei: update do_*() helpers to return ints
  io_uring: add support for IORING_OP_MKDIRAT
  io_uring: add support for IORING_OP_SYMLINKAT
  io_uring: add support for IORING_OP_LINKAT

 fs/exec.c                     |   8 +-
 fs/internal.h                 |   8 +-
 fs/io_uring.c                 | 196 ++++++++++++++++++++++++++++
 fs/namei.c                    | 239 +++++++++++++++++++---------------
 include/linux/fs.h            |   1 +
 include/uapi/linux/io_uring.h |   4 +
 6 files changed, 346 insertions(+), 110 deletions(-)

-- 
2.30.2

