Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6692DA4E6
	for <lists+io-uring@lfdr.de>; Tue, 15 Dec 2020 01:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgLOAYo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Dec 2020 19:24:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbgLOAYo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Dec 2020 19:24:44 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961A6C061793;
        Mon, 14 Dec 2020 16:24:03 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id q75so16855449wme.2;
        Mon, 14 Dec 2020 16:24:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8jc3AIzkIPReSThseVXRAPm4odmJMoGYu8KGcGUo5xA=;
        b=UdWHcglApp9RdDZeyVfl7LsJgdxW48tzLbgNRju6ud80NwZdq8pS6rNA48XayxnD2y
         gxp99ju2U22s0IgeHpYxNkwEmEsSWmjKvkDVgboRjCL0u2BjvWzJuRm3fQuna6NzrVJX
         tY83rFJle/+8UqxI4cOpq7ZEPwQanA4rNBX48zfg4PVtL5ODTFYQfgYr+oKNqJ85Y/gd
         599roSuL8vkZuUsB+DMvesJq5/Qay+HaVljVBmkn57M9MaFlDCjvpgkaWPWHAqXbqbH5
         awkn32y9RHX7Bg8npAuH4ig4MoKopNAyVbodgQEudUlOhmPl/5BfCRzLw7S/Tb6KT7TR
         Av8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8jc3AIzkIPReSThseVXRAPm4odmJMoGYu8KGcGUo5xA=;
        b=JjH7Xp3ZjrUPqt0bm0f52mOdf+VEv41WWJNFd5zZmerIWueDZ4ud/4wCS4AHQn//KP
         yz7xTY1dr+tIjnd+qTmFJ3C8nmB3UamvlZyBkQqVebySh2wZ7ewMbhPSKjjTN2EbMXMm
         pkC+c6B1isPYgjQ+jgRfaH7J1mErUMrdZm4DAm6L3PzHI5i73sKrY0tNM94kJ21aQudX
         2X8qjebGo3JUPuKZCgEGC7yLidNoK82iGc5aof7gyDw7T7mtssCSujCHcaBFbXw5zbef
         DS0ix2m5rk6/U7dFwwfw66FJlxh4HHAiJlOkZrAUc6Rnyv0gvC0RpdiRGewsAWPI9Ett
         +nVQ==
X-Gm-Message-State: AOAM531NvqE4EFF++ZUDnUIa/hgiy0BnypCXAdurAe2lnojwulERxGBs
        wUMdrDWQkqSSQVRaFCw/5r8V+SagMKvQzKLc
X-Google-Smtp-Source: ABdhPJwGNnrKGp65JFv4dDtyk0FguiKKzh1xTxkYj/G+sMLant4a7Rnm4MCbD8CKdIpwjoDGsmxiog==
X-Received: by 2002:a05:600c:258:: with SMTP id 24mr30918877wmj.16.1607991842015;
        Mon, 14 Dec 2020 16:24:02 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.163])
        by smtp.gmail.com with ESMTPSA id b19sm5362012wmj.37.2020.12.14.16.24.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 16:24:01 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     linux-block@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Ming Lei <ming.lei@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH v1 0/6] no-copy bvec
Date:   Tue, 15 Dec 2020 00:20:19 +0000
Message-Id: <cover.1607976425.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Instead of creating a full copy of iter->bvec into bio in direct I/O,
the patchset makes use of the one provided. It changes semantics and
obliges users of asynchronous kiocb to track bvec lifetime, and [1/6]
converts the only place that doesn't.

bio_iov_iter_get_pages() is still does iov_iter_advance(), which is
not great, but neccessary for revert to work. It's desirable to have
a fast version of iov_iter_advance(i, i->count), so we may want to
hack something up for that. E.g. allow to not keep it consistent
in some cases when i->count==0. Also we can add a separate bio pool
without inlined bvec. Very easy to do and shrinks bios from 3 to 2
cachelines.

Also as suggested it removes BIO_WORKINGSET from direct paths: blkdev,
iomap, fs/direct-io. Even though the last one is not very important as
more filesystems are converted to iomap, but still looks hacky. Maybe,
as Johannes mentioned in another thread, moving it to the writeback
code (or other option) would be better in the end. Afterwards?

since RFC:
- add target_core_file patch by Christoph
- make no-copy default behaviour, remove iter flag
- iter_advance() instead of hacks to revert to work
- add bvec iter_advance() optimisation patch
- remove PSI annotations from direct IO (iomap, block and fs/direct)
- note in d/f/porting

Christoph Hellwig (1):
  target/file: allocate the bvec array as part of struct
    target_core_file_cmd

Pavel Begunkov (5):
  iov_iter: optimise bvec iov_iter_advance()
  bio: deduplicate adding a page into bio
  block/psi: remove PSI annotations from direct IO
  bio: add a helper calculating nr segments to alloc
  block/iomap: don't copy bvec for direct IO

 Documentation/filesystems/porting.rst |   9 +++
 block/bio.c                           | 103 ++++++++++++--------------
 drivers/target/target_core_file.c     |  20 ++---
 fs/block_dev.c                        |   7 +-
 fs/direct-io.c                        |   2 +
 fs/iomap/direct-io.c                  |   9 +--
 include/linux/bio.h                   |   9 +++
 lib/iov_iter.c                        |  19 +++++
 8 files changed, 102 insertions(+), 76 deletions(-)

-- 
2.24.0

