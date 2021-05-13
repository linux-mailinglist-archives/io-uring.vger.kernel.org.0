Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 089B737F660
	for <lists+io-uring@lfdr.de>; Thu, 13 May 2021 13:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233098AbhEMLIV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 May 2021 07:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232434AbhEMLIJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 May 2021 07:08:09 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FCA2C061760;
        Thu, 13 May 2021 04:07:00 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id l4so39312908ejc.10;
        Thu, 13 May 2021 04:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sYSPPrflhhxfPIkiu9hWxAkdC6u5jwyGv1D2zzGLaRo=;
        b=OgGIYvew1B3p3Gm5NKC/CZWnAn89K7tk3xPTD89rqSA9cYOENBd3HiPdS9gS7XRoKC
         URmUcTVXILz7NUEXHXRUZW9WnaridIoKW/zCk8sM4MghW3yzm4jWPLS/qfxPZcgxsDxi
         XDX/xlQ4RTjXcSIvlqIkB8KJvKHt3N9d7qq90aKvXZVLmtIC1+wP7qCUv1icSkNKLm4b
         zbVB0Zug1CI5761k8ciFXa4Sp07dT5BpSufNAFaVkl3zDcnb0fCdVyOBZwc4xR3i32/5
         R0emYNDSH+b2mC5eNuPo7/qC6toCsFnrB4HjcsaSN5i9QzC423pPmf3KpjClt0Gcpgv+
         j5xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sYSPPrflhhxfPIkiu9hWxAkdC6u5jwyGv1D2zzGLaRo=;
        b=eoewuexwVg+9YFQ1DPAYtvOMBpJk22eaG/Kg2IR8B8HrVGMlnhgxPuW0Fh1QRVOPFA
         QGfR3ilpo8AQzr7oPFu6IIoQoKzaxdOQ0brL2i4noSpeRjrDt3X7VLaCrd1Ftru5IO45
         PNcTR/XNhetEQFtvKAHWyeGjbvEYNlVVp1kJkaUed9iPSWKF5fm0VM4xrLithjpiNpp6
         84h/1P7LRKqOf7iVNo3sL/cKGQw9Hl4hZNZ1k9x4+NAlmaNGKOlBCo9nFz12tkkvdt3D
         3cwcF/e/JbeW3C4SvLGy8GkhKCw6sWAyut1N9uneYK6AEn/Sjsz4NHD6W8BXCb/p7uuE
         KMwQ==
X-Gm-Message-State: AOAM531RNus8LaRaIwKvVEobPHtpY8UviDI89XM8Kfx86GFdidZ4vwQh
        Z0NVH5c813e+66EmkWBLG+Q=
X-Google-Smtp-Source: ABdhPJw/FNYZOLigDM7w0JPB1wwvhx5KEKVVaovv0AnP4JmT++Or/DJcLzrQRPuxqi6gZ1jNpGKT+w==
X-Received: by 2002:a17:906:5855:: with SMTP id h21mr43445480ejs.522.1620904018831;
        Thu, 13 May 2021 04:06:58 -0700 (PDT)
Received: from carbon.v ([108.61.166.58])
        by smtp.googlemail.com with ESMTPSA id bn7sm1670864ejb.111.2021.05.13.04.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 04:06:58 -0700 (PDT)
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v4 0/6] io_uring: add mkdirat support
Date:   Thu, 13 May 2021 18:06:06 +0700
Message-Id: <20210513110612.688851-1-dkadashev@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds mkdirat support to io_uring and is heavily based on recently
added renameat() / unlinkat() support.

The first patch is preparation with no functional changes, makes
do_mkdirat accept struct filename pointer rather than the user string.

The second one leverages that to implement mkdirat in io_uring.

The rest of the patches just convert other similar do_* functions in
namei.c to accept struct filename, for uniformity with do_mkdirat,
do_renameat and do_unlinkat. No functional changes there.

Based on io_uring-5.13.

v4:
- update do_mknodat, do_symlinkat and do_linkat to accept struct
  filename for uniformity with do_mkdirat, do_renameat and do_unlinkat;

v3:
- rebase;

v2:
- do not mess with struct filename's refcount in do_mkdirat, instead add
  and use __filename_create() that does not drop the name on success;

Dmitry Kadashev (6):
  fs: make do_mkdirat() take struct filename
  io_uring: add support for IORING_OP_MKDIRAT
  fs: make do_mknodat() take struct filename
  fs: make do_symlinkat() take struct filename
  namei: add getname_uflags()
  fs: make do_linkat() take struct filename

 fs/exec.c                     |   8 +-
 fs/internal.h                 |   1 +
 fs/io_uring.c                 |  55 ++++++++++++++
 fs/namei.c                    | 135 +++++++++++++++++++++++-----------
 include/linux/fs.h            |   1 +
 include/uapi/linux/io_uring.h |   1 +
 6 files changed, 152 insertions(+), 49 deletions(-)

-- 
2.30.2

