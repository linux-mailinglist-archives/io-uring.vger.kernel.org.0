Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9A777ABD50
	for <lists+io-uring@lfdr.de>; Sat, 23 Sep 2023 04:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjIWCv6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Sep 2023 22:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjIWCv5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Sep 2023 22:51:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F45180
        for <io-uring@vger.kernel.org>; Fri, 22 Sep 2023 19:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695437471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=H50Tr31ru9HvhO8rEZ3ODbOso0TpVHQKVy+sqCdrdlA=;
        b=XRJ5auRLWVLlQFnG1twaMUYg1FHxF7kBady1Yn2pLKB+0uBmRMstHFEuGlCzzr0txSvw1w
        eBNgSk3bdBtGSTexhJ0WOyr/MaN3yINUACGxnch6gEyatSPa3TPeQ7Q84LmBcHjmwaB8sT
        cKV9YPkFL20cdi9llgnmSZsgJpd4XV0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606-XlnTJSLfMHah9EuCR83rOA-1; Fri, 22 Sep 2023 22:51:08 -0400
X-MC-Unique: XlnTJSLfMHah9EuCR83rOA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3A8E3802C1A;
        Sat, 23 Sep 2023 02:51:08 +0000 (UTC)
Received: from localhost (unknown [10.72.120.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7273D71128A;
        Sat, 23 Sep 2023 02:51:07 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     Gabriel Krisman Bertazi <krisman@suse.de>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V4 0/2] io_uring: cancelable uring_cmd
Date:   Sat, 23 Sep 2023 10:50:01 +0800
Message-ID: <20230923025006.2830689-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

Patch 1 retains top 8bits of  uring_cmd flags for kernel internal use.

Patch 2 implements cancelable uring_cmd.

git tree(with ublk change)

	https://github.com/ming1/linux/commits/uring_exit_and_ublk

V4:
	- return -EINVAL in case that internal bits are set
	- replace static lock checker with lockdep_assert_held(&ctx->uring_lock);

V3:
	- code style change as suggested by Jens
	- add patch 1

V2:
	- use ->uring_cmd() with IO_URING_F_CANCEL for canceling command


Ming Lei (2):
  io_uring: retain top 8bits of uring_cmd flags for kernel internal use
  io_uring: cancelable uring_cmd

 include/linux/io_uring.h       | 19 +++++++++++++
 include/linux/io_uring_types.h |  6 ++++
 include/uapi/linux/io_uring.h  |  5 ++--
 io_uring/io_uring.c            | 39 ++++++++++++++++++++++++++
 io_uring/uring_cmd.c           | 51 +++++++++++++++++++++++++++++++++-
 5 files changed, 116 insertions(+), 4 deletions(-)

-- 
2.41.0

