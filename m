Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC79579D77A
	for <lists+io-uring@lfdr.de>; Tue, 12 Sep 2023 19:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233439AbjILRZG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Sep 2023 13:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbjILRZG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Sep 2023 13:25:06 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80BD510D9
        for <io-uring@vger.kernel.org>; Tue, 12 Sep 2023 10:25:02 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id ca18e2360f4ac-760dff4b701so70076339f.0
        for <io-uring@vger.kernel.org>; Tue, 12 Sep 2023 10:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1694539501; x=1695144301; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wfd+d+m/3KvVMsdu3pCzTp+8VUzfP026lLxnLsu8SvM=;
        b=Ek9XtnM16vKxArCmQzN5IxSUbrArP5JpBFshlSuuiN0BIiEIy68z60yJ4XpeMXkLxl
         F8RL4rrbICYC9MMK3lB+CyuOA2FQ3zZecDt4kpxVt0wF7juP3K/ted85ACYkrp+/k2Cy
         VVU74cr239wRbaRq7GDj9k8VNjm+FbO2rigOvSRleKZE/BV0keoQixBBtYIalGIAPYlF
         Pkq5IJ5TlG1nnr27TphqJufA8JJXMVO1QDOKJr9QExvCZocJ+2BsKh69F6nc4E65lnvR
         M7/bDV9hBPPjo1U36GxfE0/BXlxE321VtoACywSHSGxmkt+xLmKYlvZ/AU1VwjbrxDHt
         rTtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694539501; x=1695144301;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wfd+d+m/3KvVMsdu3pCzTp+8VUzfP026lLxnLsu8SvM=;
        b=UUwjb7m4HIbqcvNA/WEwLpTGwwkYxyIhUSQ3By9mxgvOpALbv+AyA67fJ9AwLdc6MY
         rMsDCDLgdCvYzoMrv9VuBv3YtDwJGMbFtcTcXM+vDEo+WT+kKFpJvzwiYOwzr32hXTcq
         WEUkZnQV1bfITK1cXwpmklqkbmhGtDSZHFUGeobAk7N8uqBJ0TVuk3sZfj31vqY1hY1y
         C0r93phK0UUiwT2iWbSXBncCavICdrBkQsTx73jlV5kDZkLzmPlnLW/gtarJvOBakXuF
         nWEFjIgsOtEEdrXfDKM/X+/AZw+Yi/W+kpny2JERRO4BLepfQcTLLw/0QGvfpxfZgWdw
         3rTw==
X-Gm-Message-State: AOJu0Yz6s/zBwFYTporD+Uza/m5FPoU2WxR4VTIJJGue6j/hgyHFr8KI
        Vajjd+Jb7KNmhYuO7WADPTbWVWGXEYQsXFDeU7L+Zw==
X-Google-Smtp-Source: AGHT+IHJmUK+LKYZwJjovZqklt0NzWeUjwrV8ceoqhQgIxxkCvNNPs6zPErT/ZBMnAo7cuN5WA7cvg==
X-Received: by 2002:a92:cc05:0:b0:34f:6742:13b5 with SMTP id s5-20020a92cc05000000b0034f674213b5mr164441ilp.3.1694539501252;
        Tue, 12 Sep 2023 10:25:01 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id d4-20020a056e02214400b0034ac1a32fd9sm1777055ilv.44.2023.09.12.10.24.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 10:24:59 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, krisman@suse.de
Subject: [PATCHSET v2 0/3] Add support for multishot reads
Date:   Tue, 12 Sep 2023 11:24:55 -0600
Message-Id: <20230912172458.1646720-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

We support multishot for other request types, generally in the shape of
a flag for the request. Doing a flag based approach with reads isn't
straightforward, as the read/write flags are in the RWF_ space. Instead,
add a separate opcode for this, IORING_OP_READ_MULTISHOT.

This can only be used provided buffers, like other multishot request
types that read/receive data.

It can also only be used for pollable file types, like a tun device or
pipes, for example. File types that are always readable (or seekable),
like regular files, cannot be used with multishot reads.

This is based on the io_uring-futex branch (which, in turn, is based on
the io_uring-waitid branch). No dependencies as such between them,
except the opcode numbering.

Can also be found here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-mshot-read

and there's a liburing branch with some basic support and some test
cases here:

https://git.kernel.dk/cgit/liburing/log/?h=read-mshot

 include/uapi/linux/io_uring.h |  1 +
 io_uring/opdef.c              | 14 ++++++
 io_uring/opdef.h              |  2 +
 io_uring/rw.c                 | 92 ++++++++++++++++++++++++++++++++---
 io_uring/rw.h                 |  2 +
 5 files changed, 105 insertions(+), 6 deletions(-)

Changes since v1:
- Code reformatting
- Add/expand a few comments

-- 
Jens Axboe


