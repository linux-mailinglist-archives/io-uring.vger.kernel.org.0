Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E64FD3B2D7C
	for <lists+io-uring@lfdr.de>; Thu, 24 Jun 2021 13:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbhFXLR1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Jun 2021 07:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232414AbhFXLR0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Jun 2021 07:17:26 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E708C061574;
        Thu, 24 Jun 2021 04:15:07 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id i13so9618852lfc.7;
        Thu, 24 Jun 2021 04:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HES2elWJ7CXzn/GWSWTWJBF7UHSag/FbfdrFInBqdec=;
        b=mHFOt1MHYtoRo+6ywZ38NmUevhNgVmzNanxiYtVjvhaR6vjdZN+GlJXouGfoTZDAtB
         bDASlqAGDVBC5gGfEkorsffs0pBo9gisyKu3irtPEa3qt5/YTZm1A/DvQuTiTr9yQgdI
         c3Ms7Z5w4mnCSb9Q/vzbsw8ScfdTywLc0bGo1C3RXGZ7IPE2Puebm6/uRMi9KnwY2OXr
         YNa7KgclVcg2aOg5ioO0juA0fCiTLA7j9WLqhr2RYW6n8fFiCymrnfA3r3g6zQL1fzXZ
         A0QpblSCYIYIh071b9m9zvEnzHprr4CqKO4+IDr8/f8IiVqicieqAUwEqTkTgJJyeSho
         /n7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HES2elWJ7CXzn/GWSWTWJBF7UHSag/FbfdrFInBqdec=;
        b=g6mazBNLyllorqNeI9+PgDKhQJwfuofG+ZXWs8e15f4L8NfHJ3XUcOhlyDRCbU3Ts9
         wAtXLOr8G7fe5hnpWAC9nEJZ6bZcDWDJuJUmLNx/5IhAORRk1eIkHuTnRg1HWLStDW8a
         O7OQii/UYUqBoDO8AEykXumRQtnejNBwPPbAqUqnVLc5lpA8GbonnIKW7zd2sgmxmqOt
         BNLjFA7qkT6n0hvF06WuTV3PP98sUJAwH61ei8daBKkVOQgwIK6Ggl/jOkm2o7hN1kZW
         9bnCWf5lg3akU5v3eDivyzDccf6ZDQRE7SmVeI5ISA+QnghjjgG7jcPiyI+IQOcw9Oy5
         +XyA==
X-Gm-Message-State: AOAM5325wkbLVGL06oIACKc6Xh3HTJHHumsD4C4x36vE0VLi05PXz3uv
        vjFYdHJysT3hCdpG+2FIc1U=
X-Google-Smtp-Source: ABdhPJzwhzYP9kSUayACmIXcBWeVuH/vdLxpiqg1fzzYwxmF2VqEfY3aXHg0q1TvAhNstfv+LDeG1g==
X-Received: by 2002:ac2:414a:: with SMTP id c10mr1782802lfi.605.1624533305833;
        Thu, 24 Jun 2021 04:15:05 -0700 (PDT)
Received: from carbon.v ([94.143.149.146])
        by smtp.googlemail.com with ESMTPSA id q21sm195293lfp.233.2021.06.24.04.15.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 04:15:05 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v6 0/9] io_uring: add mkdir and [sym]linkat support
Date:   Thu, 24 Jun 2021 18:14:43 +0700
Message-Id: <20210624111452.658342-1-dkadashev@gmail.com>
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

The first patch is preparation with no functional changes, makes
do_mkdirat accept struct filename pointer rather than the user string.

The second one leverages that to implement mkdirat in io_uring.

3-6 just convert other similar do_* functions in namei.c to accept
struct filename, for uniformity with do_mkdirat, do_renameat and
do_unlinkat. No functional changes there.

7 changes do_* helpers in namei.c to return ints rather than some of
them returning ints and some longs.

8-9 add symlinkat and linkat support to io_uring correspondingly.

Based on for-5.14/io_uring.

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

Dmitry Kadashev (9):
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
 fs/io_uring.c                 | 196 ++++++++++++++++++++++++++++++++++
 fs/namei.c                    | 137 ++++++++++++++++--------
 include/linux/fs.h            |   1 +
 include/uapi/linux/io_uring.h |   4 +
 6 files changed, 301 insertions(+), 53 deletions(-)

-- 
2.30.2

