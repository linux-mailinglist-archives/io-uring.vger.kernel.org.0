Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E863686FBD
	for <lists+io-uring@lfdr.de>; Wed,  1 Feb 2023 21:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjBAUfN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Feb 2023 15:35:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjBAUfN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Feb 2023 15:35:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E41F9728F9
        for <io-uring@vger.kernel.org>; Wed,  1 Feb 2023 12:34:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675283665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=v7qADo0C7UbOjbiomYrQ/+MoliYjhSvDYemrOxMV+7A=;
        b=UcPCqlZe+AL89p5ZoDj4gVApbtkMtK9Zpq8glYMoghFcVjMGRQz1fY48ZH5mEqfc6EL5I+
        w+2PJtTaMTkTK2cZoNpdB/++FdU9Jyw+H5Pw70P8/P9vlxqiSZ1dz7pCPi3RYnaTEGxKHi
        Tn/Qs3lr0j0stv5WzU8ydmOgr4Miy9g=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-381-EVnDlQL2OHadySfnqKWopg-1; Wed, 01 Feb 2023 15:34:21 -0500
X-MC-Unique: EVnDlQL2OHadySfnqKWopg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5E03B38173C1;
        Wed,  1 Feb 2023 20:34:21 +0000 (UTC)
Received: from madcap2.tricolour.com (unknown [10.22.50.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C96D753A0;
        Wed,  1 Feb 2023 20:34:19 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org
Cc:     Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        Steve Grubb <sgrubb@redhat.com>,
        Richard Guy Briggs <rgb@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Stefan Roesch <shr@fb.com>
Subject: [PATCH v2] io_uring,audit: don't log IORING_OP_MADVISE
Date:   Wed,  1 Feb 2023 15:33:33 -0500
Message-Id: <b5dfdcd541115c86dbc774aa9dd502c964849c5f.1675282642.git.rgb@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

fadvise and madvise both provide hints for caching or access pattern for
file and memory respectively.  Skip them.

Fixes: 5bd2182d58e9 ("audit,io_uring,io-wq: add some basic audit support to io_uring")
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
changelog
v2:
- drop *GETXATTR patch
- drop FADVISE hunk

 io_uring/opdef.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 3aa0d65c50e3..d3f36c633ceb 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -312,6 +312,7 @@ const struct io_op_def io_op_defs[] = {
 		.issue			= io_fadvise,
 	},
 	[IORING_OP_MADVISE] = {
+		.audit_skip		= 1,
 		.name			= "MADVISE",
 		.prep			= io_madvise_prep,
 		.issue			= io_madvise,
-- 
2.27.0

