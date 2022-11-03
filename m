Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBC661791D
	for <lists+io-uring@lfdr.de>; Thu,  3 Nov 2022 09:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiKCIv0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Nov 2022 04:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiKCIvZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Nov 2022 04:51:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93034D2DC
        for <io-uring@vger.kernel.org>; Thu,  3 Nov 2022 01:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667465428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=FeqABZBo26005zjL1Br5RZrJuJL5HVgW06cRmiuIaZg=;
        b=hAe7c+oox8n9rrYyuKYT6zujshRu2HaAQlSmtwZSGzQUsGDMMiUDuhhZXZgkh5FJlRKXfN
        xBuN9F9SYqA4e316fF5t0WvEu69/Ps2MEmcLd79BNKDGZKNohuhinahiGn52894B2iIB/o
        LOmqwCSyClFn4LYzpSZGld/qxkagcas=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-100-LeVvhBuJPlGnBUxBUZBlrw-1; Thu, 03 Nov 2022 04:50:25 -0400
X-MC-Unique: LeVvhBuJPlGnBUxBUZBlrw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 165491C0513A;
        Thu,  3 Nov 2022 08:50:25 +0000 (UTC)
Received: from localhost (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B7B9839D6A;
        Thu,  3 Nov 2022 08:50:23 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Miklos Szeredi <mszeredi@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [RFC PATCH 0/4] io_uring/splice: extend splice for supporting ublk zero copy
Date:   Thu,  3 Nov 2022 16:50:00 +0800
Message-Id: <20221103085004.1029763-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello Guys,

This patch extends io_uring/splice by adding two flags(SPLICE_F_DIRECT &
SPLICE_F_READ_TO_READ) for supporting ublk zero copy, and fuse could benefit
from the change too.

- SPLICE_F_DIRECT is for using do_splice_direct() to support zero copy

- SPLICE_F_READ_TO_READ is for supporting ublk READ zero copy, the plain
splice can support WRITE zero copy by:

	splice(ublkc_fd, ublkc_pos, pipe_wr_fd, NULL, len, flags)
	splice(pipe_rd_fd, NULL, backing_fd, backing_off, len, flags)

but can't support READ zc. Extend splice to allow to splice from the 1st
->splice_read()(producer) to the 2nd ->splice_read()(consumer), then READ
request pages reference can be transferred to backing IO code path.

The initial idea is suggested by Miklos Szeredi & Stefan Hajnoczi.

The patchset has been verified basically by ublk builtin tests(loop/008,
loop/009, generic/003), and basic mount, git clone, kernel building, umount
tests on ublk-loop[1] which is created by 'ublk add -t loop -f $backing -z'.

The next step is to allow io_uring to run do_splice_direct*()
in async style like normal async RW instead of offloading to
iowq context, so that top performance can be reached, and that
depends on current work.

Any comments are welcome.

[1] https://github.com/ming1/ubdsrv/commits/splice-zc


Ming Lei (4):
  io_uring/splice: support do_splice_direct
  fs/splice: add helper of splice_dismiss_pipe()
  io_uring/splice: support splice from ->splice_read to ->splice_read
  ublk_drv: support splice based read/write zero copy

 drivers/block/ublk_drv.c      | 151 +++++++++++++++++++++++++-
 fs/read_write.c               |   5 +-
 fs/splice.c                   | 193 +++++++++++++++++++++++++++++-----
 include/linux/fs.h            |   2 +
 include/linux/pipe_fs_i.h     |   9 ++
 include/linux/splice.h        |  14 +++
 include/uapi/linux/ublk_cmd.h |  34 +++++-
 io_uring/splice.c             |  16 ++-
 8 files changed, 392 insertions(+), 32 deletions(-)

-- 
2.31.1

