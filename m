Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27D793BD712
	for <lists+io-uring@lfdr.de>; Tue,  6 Jul 2021 14:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241916AbhGFMwQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Jul 2021 08:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238828AbhGFMwB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Jul 2021 08:52:01 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F9D7C061767;
        Tue,  6 Jul 2021 05:49:22 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id r26so20584018lfp.2;
        Tue, 06 Jul 2021 05:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5n4c9I5bltMMn8IwaXvTzNvMMRAdRR2Vt8eQUS9OQr0=;
        b=RB+RD/BcEHS0ZFf5pvugNmSS2iiDSOdce0H3y260HZG7IhEOXlQz+LXXsE5e4ZAvwG
         OJfu9DE0HXxp9i7n+UCqnpzUsEAZvSJTinhVpywXTzb7hN+qVHkWUh7XqyBu3yZW2ypZ
         hzbJbUd913w0+bFTSgBrQC86sLNSDliILWcvTfFDT8bnM6oMFqc0Ki79MHLNKSh/koce
         Ysr+O74e3XkUvq+kTVgyF4+2CibdOMUBiGMm6nguqNyJ8pYD7zJv9Iy94yXQt060aDg4
         0O/64TUUgqTD9lxsLhL6bgeWQt49xDRS4aVZlYJetRgBs6n9K/yKMAX+GbwWUoj3dG/f
         vhVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5n4c9I5bltMMn8IwaXvTzNvMMRAdRR2Vt8eQUS9OQr0=;
        b=NL+fOg51amrUk0XSlfpwbEwYBSsly4DWKfGDsLF/xjwQpI8glCt73OotNTsy18FhyL
         OvZ2WEnT4YtDpIwQstvCz7IQp1l5pPF0dzfzpnT3UQiS9mqVTSLJdU/DqxZbRiyoktBV
         Sl6xGbP49U971AgqJbc/RPi7Yo9ut8vHJ0PFhH0bgapGwwAyNwdBkgOrSYN6UdUF7QTx
         iaHuUa4VQ2leSYnIg9XhE/nYkw46hn6OCgHqeVyA38s80y2w3ub7dXzoStIbCkBSCewr
         NbNFHcoMnGHYwWilu/5Oh7fN/itqjwXdGUtW6IKGU1ABsT1BkX+/g4QxtKAHk4eZ473E
         1oCg==
X-Gm-Message-State: AOAM530szPzOqrrr2uZftLijMFL7GIRbuVWAnUOAQMz0C6lOP787NbnD
        DUHlAxhcJEgBuaLm9H62LKo=
X-Google-Smtp-Source: ABdhPJxOsg21ul4X3yErMc3QMT9n+MSds3L5hAHIBQL4T3/P6pep3lkydKSWQbwzexjaEV52h7RqPg==
X-Received: by 2002:ac2:4475:: with SMTP id y21mr12854503lfl.133.1625575759601;
        Tue, 06 Jul 2021 05:49:19 -0700 (PDT)
Received: from carbon.v ([94.143.149.146])
        by smtp.googlemail.com with ESMTPSA id r18sm139519ljc.120.2021.07.06.05.49.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 05:49:19 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v7 00/10] io_uring: add mkdir and [sym]linkat support
Date:   Tue,  6 Jul 2021 19:48:51 +0700
Message-Id: <20210706124901.1360377-1-dkadashev@gmail.com>
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

The second patch is preparation with no functional changes, makes
do_mkdirat accept struct filename pointer rather than the user string.

The third one leverages that to implement mkdirat in io_uring.

4-7 just convert other similar do_* functions in namei.c to accept
struct filename, for uniformity with do_mkdirat, do_renameat and
do_unlinkat. No functional changes there.

8 changes do_* helpers in namei.c to return ints rather than some of
them returning ints and some longs.

9-10 add symlinkat and linkat support to io_uring correspondingly.

Based on for-5.14/io_uring.

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

Dmitry Kadashev (10):
  namei: ignore ERR/NULL names in putname()
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
 fs/namei.c                    | 139 +++++++++++++++---------
 include/linux/fs.h            |   1 +
 include/uapi/linux/io_uring.h |   4 +
 6 files changed, 300 insertions(+), 56 deletions(-)

-- 
2.30.2

