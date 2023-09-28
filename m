Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3F407B1CC4
	for <lists+io-uring@lfdr.de>; Thu, 28 Sep 2023 14:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232266AbjI1Mo0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Sep 2023 08:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232525AbjI1MoZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Sep 2023 08:44:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC47180
        for <io-uring@vger.kernel.org>; Thu, 28 Sep 2023 05:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695905020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=EGQv8WHWzBOGeXP20BWUU0/SoENJTiP/zRSu2EFqd3E=;
        b=OD1zZajj/Q+jpjr/1eY9a3Fyhsn1fpwI7yOdLm5UbzN3evWo/DvYkaezYgbc5Z/vcrn3Hk
        jKwraBxzwKLaxhM9rRCuZFKfGXuT7/meY37F8r/a2m4VJ0d9mD2uKqHZwFEsurNMdnbUpG
        SZpHuvac2WH45rL/xMh0ov6cGRIyEkw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-drWz3kt8MbWFpHWGz0Ebrw-1; Thu, 28 Sep 2023 08:43:36 -0400
X-MC-Unique: drWz3kt8MbWFpHWGz0Ebrw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 45DE83C025B4;
        Thu, 28 Sep 2023 12:43:36 +0000 (UTC)
Received: from localhost (unknown [10.72.120.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 49F3C492C37;
        Thu, 28 Sep 2023 12:43:34 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     Gabriel Krisman Bertazi <krisman@suse.de>,
        Anuj Gupta <anuj20.g@samsung.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V5 0/2] io_uring: cancelable uring_cmd
Date:   Thu, 28 Sep 2023 20:43:23 +0800
Message-ID: <20230928124327.135679-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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

V5:
	- return void from io_uring_cmd_mark_cancelable()
	- fix one line comment on IO_URING_F_CANCEL
	- remove one unnecessary warn from io_uring_try_cancel_uring_cmd()
	- all are suggested from Jens

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

 include/linux/io_uring.h       | 18 +++++++++++++
 include/linux/io_uring_types.h |  6 +++++
 include/uapi/linux/io_uring.h  |  5 ++--
 io_uring/io_uring.c            | 36 +++++++++++++++++++++++++
 io_uring/uring_cmd.c           | 49 +++++++++++++++++++++++++++++++++-
 5 files changed, 110 insertions(+), 4 deletions(-)

-- 
2.41.0

