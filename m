Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3B074ED03
	for <lists+io-uring@lfdr.de>; Tue, 11 Jul 2023 13:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjGKLlF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Jul 2023 07:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbjGKLlF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Jul 2023 07:41:05 -0400
Received: from out-5.mta0.migadu.com (out-5.mta0.migadu.com [91.218.175.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B3E6E77
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 04:41:00 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689075658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7fk1VXvFWbgwVshWOThVU6Vz7tLoV59cHnYwaUoyuXE=;
        b=NttpOphY2TFNlLM/VqaTtOaZYd7hw/4T8njM+0qTAh8zHmNIVaoivcwH3ltoVDBdoY3vZw
        u8BqjN+HTTG3z2mRzK2kk/GZFstmCcvy6yGILmr3EQpCGESpzhBI+HMRjgK54OPTd+0iom
        +cCMKHjKnyrTbnBMg811s88DeEzbvPg=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH v3 0/3] io_uring getdents
Date:   Tue, 11 Jul 2023 19:40:24 +0800
Message-Id: <20230711114027.59945-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

This series introduce getdents64 to io_uring, the code logic is similar
with the snychronized version's. It first try nowait issue, and offload
it to io-wq threads if the first try fails.


v2->v3:
 - removed the kernfs patches
 - add f_pos_lock logic
 - remove the "reduce last EOF getdents try" optimization since
   Dominique reports that doesn't make difference
 - remove the rewind logic, I think the right way is to introduce lseek
   to io_uring not to patch this logic to getdents.
 - add Singed-off-by of Stefan Roesch for patch 1 since checkpatch
   complained that Co-developed-by someone should be accompanied with
   Signed-off-by same person, I can remove them if Stefan thinks that's
   not proper.


Dominique Martinet (1):
  fs: split off vfs_getdents function of getdents64 syscall

Hao Xu (2):
  vfs_getdents/struct dir_context: add flags field
  io_uring: add support for getdents

 fs/internal.h                 |  8 +++++
 fs/readdir.c                  | 36 ++++++++++++++++-----
 include/linux/fs.h            |  8 +++++
 include/uapi/linux/io_uring.h |  7 ++++
 io_uring/fs.c                 | 60 +++++++++++++++++++++++++++++++++++
 io_uring/fs.h                 |  3 ++
 io_uring/opdef.c              |  8 +++++
 7 files changed, 122 insertions(+), 8 deletions(-)

-- 
2.25.1

