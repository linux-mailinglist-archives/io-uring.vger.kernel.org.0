Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 293F253F7D1
	for <lists+io-uring@lfdr.de>; Tue,  7 Jun 2022 10:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbiFGIGf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jun 2022 04:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbiFGIGd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jun 2022 04:06:33 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDECBB82CB;
        Tue,  7 Jun 2022 01:06:30 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654589188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Q9dRghnFkILQdPYWcUsRRYt5J44z96C8xyuH0KKJKo0=;
        b=pRSgLe45xDKwMAH1FTar8sBZE3H4ZW4ErO1YQjF9bbZgdiUSLlmLXK3ajMhH7/XGfK+JXD
        b+1TqXi2etZLrdJa71RlhqIhdk4HU86nVfkNqBcVJYxe2r6oiqD0orJEBdW+9wAki1BlWw
        w2r46j8JiMAnu5QQqUoRNbvoql0vQTw=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Subject: [RFC 0/5] support nonblock submission for splice pipe to pipe
Date:   Tue,  7 Jun 2022 16:06:14 +0800
Message-Id: <20220607080619.513187-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

splice from pipe to pipe is a trivial case, and we can support nonblock
try for it easily. splice depends on iowq at all which is slow. Let's
build a fast submission path for it by supporting nonblock.

Wrote a simple test to test time spent of splicing from pipe to pipe:


Did 50 times test for each, ignore the highest and lowest number,
calculate the average number:

before patchset: 119.85 usec
with patchset: 29.5 usec

----------------
I'm not sure if we should use a io_uring specific flag rather than
SPLICE_F_NONBLOCK since from mutex_lock_nest to mutex_trylock changes
the behavior under debug environment I guess. Or maybe there is another
better option than mutex_trylock?


Hao Xu (5):
  io_uring: move sp->len check up for splice and tee
  pipe: add trylock helpers for pipe lock
  splice: support nonblock for splice from pipe to pipe
  io_uring: support nonblock try for splicing from pipe to pipe
  io_uring: add file_in in io_splice{} to avoid duplicate calculation

 fs/pipe.c                 | 29 +++++++++++++++++++++
 fs/splice.c               | 21 +++++++++++++---
 include/linux/pipe_fs_i.h |  2 ++
 io_uring/splice.c         | 53 +++++++++++++++++++++++++++++----------
 4 files changed, 89 insertions(+), 16 deletions(-)


base-commit: d8271bf021438f468dab3cd84fe5279b5bbcead8
-- 
2.25.1

