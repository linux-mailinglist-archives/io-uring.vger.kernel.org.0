Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88DCA67EC5A
	for <lists+io-uring@lfdr.de>; Fri, 27 Jan 2023 18:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234116AbjA0RZF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Jan 2023 12:25:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbjA0RZD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Jan 2023 12:25:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A5227492
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 09:24:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674840259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eX6Cm8kNYSgck1tuSa55reiDXfLO+860Yz9cAHbWxZ0=;
        b=I3RPb+csFthXzPXDL/v6X6LHaHCHx7iHXTncAeOxgdC+pZmRoycFG519G4nn3KjC1R5IgY
        9W/BMC8kczKNN4vqHotLklFuf+to8FJB69Ao4bmxaQ39JpaaVHAsW1Fm4yu7eC4JA10xCU
        E69XA+VByF4ESJUp+5Pz1omOVO5BGIY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-437-OGMzI3qxM8SD5hKBXp2rUw-1; Fri, 27 Jan 2023 12:24:15 -0500
X-MC-Unique: OGMzI3qxM8SD5hKBXp2rUw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D34D8101A521;
        Fri, 27 Jan 2023 17:24:14 +0000 (UTC)
Received: from madcap2.tricolour.com (ovpn-0-3.rdu2.redhat.com [10.22.0.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 54BD72166B26;
        Fri, 27 Jan 2023 17:24:13 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org
Cc:     Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        Steve Grubb <sgrubb@redhat.com>,
        Richard Guy Briggs <rgb@redhat.com>,
        Stefan Roesch <shr@fb.com>,
        Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v1 2/2] io_uring,audit: do not log IORING_OP_*GETXATTR
Date:   Fri, 27 Jan 2023 12:23:46 -0500
Message-Id: <f602429ce0f419c2abc3ae5a0e705e1368ac5650.1674682056.git.rgb@redhat.com>
In-Reply-To: <cover.1674682056.git.rgb@redhat.com>
References: <cover.1674682056.git.rgb@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Getting XATTRs is not particularly interesting security-wise.

Suggested-by: Steve Grubb <sgrubb@redhat.com>
Fixes: a56834e0fafe ("io_uring: add fgetxattr and getxattr support")
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 io_uring/opdef.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index a2bf53b4a38a..f6bfe2cf078c 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -462,12 +462,14 @@ const struct io_op_def io_op_defs[] = {
 	},
 	[IORING_OP_FGETXATTR] = {
 		.needs_file = 1,
+		.audit_skip		= 1,
 		.name			= "FGETXATTR",
 		.prep			= io_fgetxattr_prep,
 		.issue			= io_fgetxattr,
 		.cleanup		= io_xattr_cleanup,
 	},
 	[IORING_OP_GETXATTR] = {
+		.audit_skip		= 1,
 		.name			= "GETXATTR",
 		.prep			= io_getxattr_prep,
 		.issue			= io_getxattr,
-- 
2.27.0

