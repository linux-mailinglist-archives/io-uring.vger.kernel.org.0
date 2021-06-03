Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 802663999B1
	for <lists+io-uring@lfdr.de>; Thu,  3 Jun 2021 07:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbhFCFUu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Jun 2021 01:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbhFCFUt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Jun 2021 01:20:49 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 854DBC06174A;
        Wed,  2 Jun 2021 22:18:55 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id k25so1798078eja.9;
        Wed, 02 Jun 2021 22:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IxEW4kyC7KsYu7xL8uJ27zJ88YN78T3I5X5KS2VFbbA=;
        b=ODKG/vBAOAJyLIBihOn3gbTWZ6QUKXfGpUuuy/qh3HpdIYQcjxTjIRhCxs+P0UDlh3
         mHd2/V6Dut8OhCo7JqoLs/CfBVkTfq9NlIUUxFWYpqJmmOz4XdpMa/agOw/aeYMv+gaW
         JwVxnxZqwD2leAtv9YTOJYd/u29jg29b4tbUi7/TVQMbbNrBIzdl018ZTHA9dtaIuv1d
         eUHahxK1VbKGY0iScv73HGtCTl1oLOWWx4X4mFv/zSNBIU6XKIISJ+bniFpg8/aYB835
         rgNGLxZAHak9Y7OA30RdgDA0TLhqYiHU7GpI4k7QVxO3WQH5bikhSBPljeZt06OTjFHZ
         gR0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IxEW4kyC7KsYu7xL8uJ27zJ88YN78T3I5X5KS2VFbbA=;
        b=UdPadDc+hoC2WLj/M6N78MShGFfKINg2QgqnlgdoPeNgDsLMyo3JduhLdDLEDo6tru
         qSarJ/CfVkfYp1Vf1m5yLSUjn8wOI95WC1HhAq930ASEpeZmrOb6qOnouIB4y1e69Olv
         1NDzMZadmfqOWKivT9YqSXdGNMCYFvQFylslHy1WeKWoXev5EfeWRzo98snU3cqFXfDD
         xK2PcKtlVGysozDjSL5+yqkK2n5iI3RFjO7UsjIUdwIdhGj0mES4CpMCTtoYo60y1qFF
         PvXdRWkyBmWdtJn9pMgMcKizSEV+O0/ft7ZMEZMxvcL6ifM9gs4m6afCByER5scWYXDj
         Arcg==
X-Gm-Message-State: AOAM532D9W3JxYNKOv1qjEKGH8zJWS+3yKBK69MSS8X1AXlxlRmafdA1
        kBneT8Rtsmc6nfc9VR8kEpY=
X-Google-Smtp-Source: ABdhPJyGAimUMmOgh+4cX9PExDbgfM6nK2h1O00ZlK4suYAUKcWy58Nvxx4FGEayOmybSOxxrKms2w==
X-Received: by 2002:a17:906:6156:: with SMTP id p22mr23869327ejl.242.1622697533925;
        Wed, 02 Jun 2021 22:18:53 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id f7sm963668ejz.95.2021.06.02.22.18.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 22:18:53 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v5 00/10] io_uring: add mkdir, [sym]linkat and mknodat support
Date:   Thu,  3 Jun 2021 12:18:26 +0700
Message-Id: <20210603051836.2614535-1-dkadashev@gmail.com>
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
io_uring is trivial, so that was done too. See
https://lore.kernel.org/io-uring/20210514145259.wtl4xcsp52woi6ab@wittgenstein/

The first patch is preparation with no functional changes, makes
do_mkdirat accept struct filename pointer rather than the user string.

The second one leverages that to implement mkdirat in io_uring.

3-6 just convert other similar do_* functions in namei.c to accept
struct filename, for uniformity with do_mkdirat, do_renameat and
do_unlinkat. No functional changes there.

7 changes do_* helpers in namei.c to return ints rather than some of
them returning ints and some longs.

8-10 add symlinkat, linkat and mknodat support to io_uring
(correspondingly).

Based on for-5.14/io_uring.

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
  fs: make do_mkdirat() take struct filename
  io_uring: add support for IORING_OP_MKDIRAT
  fs: make do_mknodat() take struct filename
  fs: make do_symlinkat() take struct filename
  namei: add getname_uflags()
  fs: make do_linkat() take struct filename
  fs: update do_*() helpers to return ints
  io_uring: add support for IORING_OP_SYMLINKAT
  io_uring: add support for IORING_OP_LINKAT
  io_uring: add support for IORING_OP_MKNODAT

 fs/exec.c                     |   8 +-
 fs/internal.h                 |  10 +-
 fs/io_uring.c                 | 240 ++++++++++++++++++++++++++++++++++
 fs/namei.c                    | 137 ++++++++++++-------
 include/linux/fs.h            |   1 +
 include/uapi/linux/io_uring.h |   6 +
 6 files changed, 349 insertions(+), 53 deletions(-)

-- 
2.30.2

