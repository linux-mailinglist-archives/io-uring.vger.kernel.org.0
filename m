Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EABD75A2D83
	for <lists+io-uring@lfdr.de>; Fri, 26 Aug 2022 19:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343568AbiHZRbQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Aug 2022 13:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbiHZRbP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Aug 2022 13:31:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC2CDB068
        for <io-uring@vger.kernel.org>; Fri, 26 Aug 2022 10:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661535074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=9zTPBGEPrD6+mFgZJVC3QNCoYNLmjkAC44ad7nWQk38=;
        b=QaLvx6RDVqPF6rSLGu5XO4FLYzFxOjOUoHpO1wDn1hGC/GFI3Cth1CoO5oXfECo68XiuSu
        EyVWJas5dSVeI5vA4x0X6uSNo/rhkqMId/7Jz3YBiwIdI+R6uzC1zAXu3SMk7J1Yci8Rzo
        5mm/VwDUBAxuvUTbVpEyCvOhNg03BQo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-252-xNDYVhR_PrePXCXW2c3LYQ-1; Fri, 26 Aug 2022 13:31:10 -0400
X-MC-Unique: xNDYVhR_PrePXCXW2c3LYQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 11225101A54E;
        Fri, 26 Aug 2022 17:31:10 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E8413492C3B;
        Fri, 26 Aug 2022 17:31:09 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     io-uring@vger.kernel.org, axboe@kernel.dk
Cc:     eschwartz93@gmail.com
Subject: [patch] liburing: fix return code for test/hardlink.t
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Fri, 26 Aug 2022 13:34:59 -0400
Message-ID: <x49fshiq56k.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Commit a68c88a093719 ("tests: mark passing tests which exit early as
skipped") changed the return code for this test from success to skip for
the case where the test successfully runs to completion.  Fix it.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/test/hardlink.c b/test/hardlink.c
index 29395c3..aeb9ac6 100644
--- a/test/hardlink.c
+++ b/test/hardlink.c
@@ -124,7 +124,7 @@ int main(int argc, char *argv[])
 	unlinkat(AT_FDCWD, linkname, 0);
 	unlinkat(AT_FDCWD, target, 0);
 	io_uring_queue_exit(&ring);
-	return T_EXIT_SKIP;
+	return T_EXIT_PASS;
 skip:
 	unlinkat(AT_FDCWD, linkname, 0);
 	unlinkat(AT_FDCWD, target, 0);

