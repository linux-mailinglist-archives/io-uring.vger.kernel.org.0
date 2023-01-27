Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA27467EC5C
	for <lists+io-uring@lfdr.de>; Fri, 27 Jan 2023 18:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235180AbjA0RZH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Jan 2023 12:25:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235185AbjA0RZF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Jan 2023 12:25:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABBEE78AC7
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 09:24:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674840256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qTj1NY9uDDolSfOmg33hPPt92c/gJa5SVLegok4bxCs=;
        b=OQhmyBdK0VMo3+zDT8b3POmQx9aCF8487T5Wm8cnpqrVtynMAZ5tw8f2xKuNkjPsVS2OCE
        YB5BPd+TKFVKuaragHfd4alYV6EktEb3L2PUL0/dIc/9DchT/rCK04qLPVLc3r5Uq3GpZv
        Z5ZEfq3VousMYrwUsJA5QlwsLbyTN7k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-246-XDUGUybROuewq9juZwbq5A-1; Fri, 27 Jan 2023 12:24:13 -0500
X-MC-Unique: XDUGUybROuewq9juZwbq5A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1F61885A588;
        Fri, 27 Jan 2023 17:24:13 +0000 (UTC)
Received: from madcap2.tricolour.com (ovpn-0-3.rdu2.redhat.com [10.22.0.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A60262166B26;
        Fri, 27 Jan 2023 17:24:11 +0000 (UTC)
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
Subject: [PATCH v1 1/2] io_uring,audit: audit IORING_OP_FADVISE but not IORING_OP_MADVISE
Date:   Fri, 27 Jan 2023 12:23:45 -0500
Message-Id: <68eb0c2dd50bca1af91203669f7f1f8312331f38.1674682056.git.rgb@redhat.com>
In-Reply-To: <cover.1674682056.git.rgb@redhat.com>
References: <cover.1674682056.git.rgb@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Since FADVISE can truncate files and MADVISE operates on memory, reverse
the audit_skip tags.

Fixes: 5bd2182d58e9 ("audit,io_uring,io-wq: add some basic audit support to io_uring")
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 io_uring/opdef.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 3aa0d65c50e3..a2bf53b4a38a 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -306,12 +306,12 @@ const struct io_op_def io_op_defs[] = {
 	},
 	[IORING_OP_FADVISE] = {
 		.needs_file		= 1,
-		.audit_skip		= 1,
 		.name			= "FADVISE",
 		.prep			= io_fadvise_prep,
 		.issue			= io_fadvise,
 	},
 	[IORING_OP_MADVISE] = {
+		.audit_skip		= 1,
 		.name			= "MADVISE",
 		.prep			= io_madvise_prep,
 		.issue			= io_madvise,
-- 
2.27.0

