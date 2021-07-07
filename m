Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5DCB3BE7D8
	for <lists+io-uring@lfdr.de>; Wed,  7 Jul 2021 14:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbhGGMak (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Jul 2021 08:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231534AbhGGMaj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Jul 2021 08:30:39 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7ECCC061574;
        Wed,  7 Jul 2021 05:27:59 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id hc16so2941082ejc.12;
        Wed, 07 Jul 2021 05:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1kDvFhpMOkdIH+U7Ir83URtQHny6rvk2ucDvPOWjy/E=;
        b=d2bRY7+WmbhMsVgjPsySTZxoNtiRS6SW6+D9VwBw3RytgdrQJsbo//nvDglcNZnKgM
         LWrIWlVkG2TfIfPuwB+RMbxh+MI+Binne/HlPRCTKp5+xlj0+ji6HEBioNrbC2Vjfcsc
         tkRwFiqVa8r1U54uTYplJ0ujQMkOU/lBS3gE74QvsC6iLIOoxel8qxkGeqtoSYS3cBBA
         VSF/qM6cbDaNAPx/7ER1PuYG3UKck3GqQ05Z0QtIzTP7oduijJdnMY7ZJ4XLuv/3mt3F
         W6KobnSD0W5kqeLkLNkiF+LmBEaPyw6XU5eUGt84K0vTg+eBQ6s8C4B4goEVloTvORzy
         BJXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1kDvFhpMOkdIH+U7Ir83URtQHny6rvk2ucDvPOWjy/E=;
        b=npPy3yJHr+kOKrvXmdY5Lc5JptKW5xrS6wa51PkxflQqUEXnqH/o+7JEHFuIfuHomO
         oap7VHLGrJg2Zw5efy7Ir2OkNib/D35QpUTUFm0GDDLBrRawvOeBogTSLKKT0LuHHnvY
         EGhbRZiR8ZR64YLj2zA+nVvjNhqucnW80x9tvYRgPVDuXlFQLiKt7sCgVzmK4SDXUmtQ
         urnQsXL/R/Zl9wGbpqMCkWUgEhRktNvVF41ACtGSxEZe6akM4VxVx7px0deXBz3wX/wH
         3jjoHkvu/xhJ1CNnvk+qTzRszYdCMNTbbhh3Oo/fDFWhtI3wEEzbUg23zfxyFc1cAINS
         biow==
X-Gm-Message-State: AOAM532GTlMNFZRzlCfdkjcDnGe2HJREBD3Ccrmdbxd+mwEZutQQz5oa
        mXjNGuxlKdHgctLELmjov0s=
X-Google-Smtp-Source: ABdhPJwoPkOixqrTO2wL4zg1wJ93bKc/gzgdqDTGXyb+WjfbL0G8sSAH+RCVvhDNnmwIuBBlI2n/PA==
X-Received: by 2002:a17:906:4e4f:: with SMTP id g15mr23997189ejw.217.1625660878208;
        Wed, 07 Jul 2021 05:27:58 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id ze15sm7019821ejb.79.2021.07.07.05.27.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 05:27:57 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v8 00/11] io_uring: add mkdir and [sym]linkat support
Date:   Wed,  7 Jul 2021 19:27:36 +0700
Message-Id: <20210707122747.3292388-1-dkadashev@gmail.com>
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

The fourth one leverages that to implement mkdirat in io_uring.

5-8 just convert other similar do_* functions in namei.c to accept
struct filename, for uniformity with do_mkdirat, do_renameat and
do_unlinkat. No functional changes there.

9 changes do_* helpers in namei.c to return ints rather than some of
them returning ints and some longs.

10-11 add symlinkat and linkat support to io_uring correspondingly.

Based on for-5.14/io_uring.

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
  fs: make do_mkdirat() take struct filename
  io_uring: add support for IORING_OP_MKDIRAT
  fs: make do_mknodat() take struct filename
  fs: make do_symlinkat() take struct filename
  namei: add getname_uflags()
  fs: make do_linkat() take struct filename
  fs: update do_*() helpers to return ints
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

