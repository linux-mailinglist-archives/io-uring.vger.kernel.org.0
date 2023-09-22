Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97FBF7AB598
	for <lists+io-uring@lfdr.de>; Fri, 22 Sep 2023 18:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjIVQLm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Sep 2023 12:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbjIVQLj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Sep 2023 12:11:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C69AD196
        for <io-uring@vger.kernel.org>; Fri, 22 Sep 2023 09:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695399053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mvOh6EIsqWi4szyKwu3X7nDFJW+6eI1IGRZ4BninK+g=;
        b=ipKvn4SrmYcB72poJcWexROS0357DXs/vjlXGtB5TmXiHqtZfJoIuMhWhSpgbAiH8mBZVi
        +vAPUFcDJ2Sax2LavmdPjDFp5PAqUbyMnmRh0Oq3CNm75FgETra/soU8R7tsf5/01lX88N
        WMI5ydIAsnlXB/TiLFKS1mLM6nbsXHw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-304-AyHOI6xHPj-f37_a65UsbQ-1; Fri, 22 Sep 2023 12:10:51 -0400
X-MC-Unique: AyHOI6xHPj-f37_a65UsbQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D6D553C147EB;
        Fri, 22 Sep 2023 16:10:50 +0000 (UTC)
Received: from localhost (unknown [10.72.120.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E874420268D4;
        Fri, 22 Sep 2023 16:10:49 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     Gabriel Krisman Bertazi <krisman@suse.de>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V3 0/2] io_uring: cancelable uring_cmd
Date:   Sat, 23 Sep 2023 00:09:39 +0800
Message-ID: <20230922160943.2793779-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
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
 io_uring/io_uring.c            | 34 +++++++++++++++++++++++
 io_uring/uring_cmd.c           | 51 +++++++++++++++++++++++++++++++++-
 5 files changed, 111 insertions(+), 4 deletions(-)

-- 
2.41.0

