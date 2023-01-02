Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F03A65B4D2
	for <lists+io-uring@lfdr.de>; Mon,  2 Jan 2023 17:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbjABQKR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Jan 2023 11:10:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236540AbjABQJ7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Jan 2023 11:09:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6063215
        for <io-uring@vger.kernel.org>; Mon,  2 Jan 2023 08:09:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672675752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Sh73hBCrQns8aoevVV+OOnfi6R1HtUp1NLv5DeAjtKc=;
        b=WgybEYmh49GhZOS/zL+rI1LaVc2MXgfvdPFK7yKVQNx0fxV/z5G7MadflcnSppqdix5sRk
        YZRmjfXqrT0OYCdSQR3LkReQwcMC65K07ZXY590GV+zFusSAolY/627G+tX6/7Hu8ybcOJ
        7Uhdr0CpRlLI7USr9xq7XYIwuVODstg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-h6RgIbbbPnKtMqdUN9kSDg-1; Mon, 02 Jan 2023 11:09:09 -0500
X-MC-Unique: h6RgIbbbPnKtMqdUN9kSDg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 48408811E6E;
        Mon,  2 Jan 2023 16:09:08 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.193.209])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3D18D35455;
        Mon,  2 Jan 2023 16:09:06 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nicolas Pitre <nico@fluxnic.net>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH mm-unstable v1 3/3] drivers/misc/open-dice: don't touch VM_MAYSHARE
Date:   Mon,  2 Jan 2023 17:08:56 +0100
Message-Id: <20230102160856.500584-4-david@redhat.com>
In-Reply-To: <20230102160856.500584-1-david@redhat.com>
References: <20230102160856.500584-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A MAP_SHARED mapping always has VM_MAYSHARE set, and writable
(VM_MAYWRITE) MAP_SHARED mappings have VM_SHARED set as well. To
identify a MAP_SHARED mapping, it's sufficient to look at VM_MAYSHARE.

We cannot have VM_MAYSHARE|VM_WRITE mappings without having VM_SHARED
set. Consequently, current code will never actually end up clearing
VM_MAYSHARE and that code is confusing, because nobody is supposed to
mess with VM_MAYWRITE.

Let's clean it up and restructure the code. No functional change intended.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/misc/open-dice.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/open-dice.c b/drivers/misc/open-dice.c
index c61be3404c6f..9dda47b3fd70 100644
--- a/drivers/misc/open-dice.c
+++ b/drivers/misc/open-dice.c
@@ -90,15 +90,13 @@ static int open_dice_mmap(struct file *filp, struct vm_area_struct *vma)
 {
 	struct open_dice_drvdata *drvdata = to_open_dice_drvdata(filp);
 
-	/* Do not allow userspace to modify the underlying data. */
-	if ((vma->vm_flags & VM_WRITE) && (vma->vm_flags & VM_SHARED))
-		return -EPERM;
-
-	/* Ensure userspace cannot acquire VM_WRITE + VM_SHARED later. */
-	if (vma->vm_flags & VM_WRITE)
-		vma->vm_flags &= ~VM_MAYSHARE;
-	else if (vma->vm_flags & VM_SHARED)
+	if (vma->vm_flags & VM_MAYSHARE) {
+		/* Do not allow userspace to modify the underlying data. */
+		if (vma->vm_flags & VM_WRITE)
+			return -EPERM;
+		/* Ensure userspace cannot acquire VM_WRITE later. */
 		vma->vm_flags &= ~VM_MAYWRITE;
+	}
 
 	/* Create write-combine mapping so all clients observe a wipe. */
 	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
-- 
2.39.0

