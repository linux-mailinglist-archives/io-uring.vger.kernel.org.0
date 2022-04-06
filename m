Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBD54F6310
	for <lists+io-uring@lfdr.de>; Wed,  6 Apr 2022 17:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235827AbiDFPTz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Apr 2022 11:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235836AbiDFPSj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Apr 2022 11:18:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9AB2533E585
        for <io-uring@vger.kernel.org>; Wed,  6 Apr 2022 05:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649247549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=AcjzWGcdu18BMqkfmj4vFQYOWEOKNr12Idy3vAbhIVw=;
        b=GyrNTwCSC4hES0kq8aqkCNxcseKWdFtruZf/uqxTUM7/MhCf+8d5tKMpCuLuJERVlwMHAG
        KHxk/TNU1v9q+hhY2SdWbxQZqnp7p7tBESkLlNgctvN+KXBsEN55sKSBnF+u308anwL0Pz
        2vQrSy57ziE8ArqN/RyJG06hn9v3bEI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-502-Bbd3XBGAPq2BPBjOc-j5Dg-1; Wed, 06 Apr 2022 07:55:37 -0400
X-MC-Unique: Bbd3XBGAPq2BPBjOc-j5Dg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4375F824072;
        Wed,  6 Apr 2022 11:55:37 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0219140CF905;
        Wed,  6 Apr 2022 11:55:35 +0000 (UTC)
Date:   Wed, 6 Apr 2022 13:55:33 +0200
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Artem Savkov <asavkov@redhat.com>
Subject: [PATCH] io_uring: implement compat handling for
 IORING_REGISTER_IOWQ_AFF
Message-ID: <20220406115533.GA5165@asgard.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Similarly to the way it is done im mbind syscall.

Cc: stable@vger.kernel.org # 5.14
Fixes: fe76421d1da1dcdb ("io_uring: allow user configurable IO thread CPU affinity")
Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
---
 fs/io_uring.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index de9c9de..83e194f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10803,7 +10803,15 @@ static __cold int io_register_iowq_aff(struct io_ring_ctx *ctx,
 	if (len > cpumask_size())
 		len = cpumask_size();
 
-	if (copy_from_user(new_mask, arg, len)) {
+	if (in_compat_syscall()) {
+		ret = compat_get_bitmap(cpumask_bits(new_mask),
+					(const compat_ulong_t __user *)arg,
+					len * 8 /* CHAR_BIT */);
+	} else {
+		ret = copy_from_user(new_mask, arg, len);
+	}
+
+	if (ret) {
 		free_cpumask_var(new_mask);
 		return -EFAULT;
 	}
-- 
2.1.4

