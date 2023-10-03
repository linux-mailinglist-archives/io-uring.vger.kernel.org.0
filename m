Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 537757B5E30
	for <lists+io-uring@lfdr.de>; Tue,  3 Oct 2023 02:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbjJCA06 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Oct 2023 20:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbjJCA06 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Oct 2023 20:26:58 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97551A9
        for <io-uring@vger.kernel.org>; Mon,  2 Oct 2023 17:26:55 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id 98e67ed59e1d1-273e3d8b57aso78030a91.0
        for <io-uring@vger.kernel.org>; Mon, 02 Oct 2023 17:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1696292814; x=1696897614; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4pVQsHhvfSSRE2joppktElLdQZkr30WmjZHZhUCIP4U=;
        b=gZdLD9IjYvkEU1NYhEWqyU+jcmAgvyDScPkejDrdOlu03SbGSuEbplSPwrefx4D54d
         2KlmQ2YV6XsMYyBkMc5IK+B4g/CSHhh8Zt2lZO92YekOisbeKoS7+U3KFiaAiUwPiI9X
         IKC57hjFv0M6WDRYjPeMUU7IxsLjvKNoczvaMn/AEbie7TkGp45DdNRzrM08oT9xLbMC
         trzvuJ+xv7YyEkfBjryUTJWzRvszOiNHo94UKV32bjYDcEH4BX+qe9Yn2oelCGotToSZ
         pigic/4MoFZUNaDrmVMKH9NELeGyc2A6eCwkeD8szS0nTrlTHYvZXA/IruXxyJfr0vz1
         mjcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696292814; x=1696897614;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4pVQsHhvfSSRE2joppktElLdQZkr30WmjZHZhUCIP4U=;
        b=I0J2IPj+9QZAnECU0m3LFVqEhUAZZolzovxKZeZNxXVrFRTlJ7Olh7VnYRqjrWR85R
         0e9MyNMzxzliqamGJeOEky3SwHZIt17Hv7YrOwr/c2qQnMwAPa5Hf5XPllWVGKNBKpTk
         b2E2hVfKAztKv+OIsQo98ipwMYA5cIm1WoBVdO4ehe2bV8G3tQ2UmywLXHwBgFGOCQ23
         XdGvcxegTFuRg2Yy2JO9Pt2jmRJnRLG+dKEMAVK2myRbiY46JHmsVBYP72em5T8jbikO
         FfxIASz2Y7lJ4fDWLIrLniD//GIBzcFg8HjITJpdF8xkgTlnsHB8aodbWnfvJfR9xc1y
         zTVA==
X-Gm-Message-State: AOJu0Yz+5jO68GBAR+0E2yaN0ysQLgyOM3ERL7G45Ua7egOeEkvD19RT
        i6+iTzbNRRlLvCPAzRr0BdqcELc90RU7BVvdfhk=
X-Google-Smtp-Source: AGHT+IE7NhUdAfkhSp5e9QqCcJov4jumfxbv8OoQgfa7kVoNa4hXqrRKz1hgFNmdkAhTsAX7T0zFrQ==
X-Received: by 2002:aa7:83d6:0:b0:690:c79c:1912 with SMTP id j22-20020aa783d6000000b00690c79c1912mr12364682pfn.0.1696292814348;
        Mon, 02 Oct 2023 17:26:54 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id c14-20020aa7880e000000b00693411c6c3csm90959pfo.39.2023.10.02.17.26.53
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Oct 2023 17:26:53 -0700 (PDT)
Message-ID: <1f151dd0-a8e4-4994-bf2a-1bbd10cf58bc@kernel.dk>
Date:   Mon, 2 Oct 2023 18:26:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/kbuf: don't allow registered buffer rings on highmem
 pages
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot reports that registering a mapped buffer ring on arm32 can
trigger an OOPS. Registered buffer rings have two modes, one of them
is the application passing in the memory that the buffer ring should
reside in. Once those pages are mapped, we use page_address() to get
a virtual address. This will obviously fail on highmem pages, which
aren't mapped.

Add a check if we have any highmem pages after mapping, and fail the
attempt to register a provided buffer ring if we do. This will return
the same error as kernels do that don't support provided buffer rings
to begin with.

Link: https://lore.kernel.org/io-uring/000000000000af635c0606bcb889@google.com/
Fixes: c56e022c0a27 ("io_uring: add support for user mapped provided buffer ring")
Cc: stable@vger.kernel.org
Reported-by: syzbot+2113e61b8848fa7951d8@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 556f4df25b0f..c5a2d4b38c8a 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -477,7 +477,7 @@ static int io_pin_pbuf_ring(struct io_uring_buf_reg *reg,
 {
 	struct io_uring_buf_ring *br;
 	struct page **pages;
-	int nr_pages;
+	int i, nr_pages;
 
 	pages = io_pin_pages(reg->ring_addr,
 			     flex_array_size(br, bufs, reg->ring_entries),
@@ -485,6 +485,17 @@ static int io_pin_pbuf_ring(struct io_uring_buf_reg *reg,
 	if (IS_ERR(pages))
 		return PTR_ERR(pages);
 
+	/*
+	 * Apparently some 32-bit boxes (ARM) will return highmem pages,
+	 * which then need to be mapped. We could support that, but it'd
+	 * complicate the code and slowdown the common cases quite a bit.
+	 * So just error out, returning -EINVAL just like we did on kernels
+	 * that didn't support mapped buffer rings.
+	 */
+	for (i = 0; i < nr_pages; i++)
+		if (PageHighMem(pages[i]))
+			goto error_unpin;
+
 	br = page_address(pages[0]);
 #ifdef SHM_COLOUR
 	/*
@@ -496,13 +507,8 @@ static int io_pin_pbuf_ring(struct io_uring_buf_reg *reg,
 	 * should use IOU_PBUF_RING_MMAP instead, and liburing will handle
 	 * this transparently.
 	 */
-	if ((reg->ring_addr | (unsigned long) br) & (SHM_COLOUR - 1)) {
-		int i;
-
-		for (i = 0; i < nr_pages; i++)
-			unpin_user_page(pages[i]);
-		return -EINVAL;
-	}
+	if ((reg->ring_addr | (unsigned long) br) & (SHM_COLOUR - 1))
+		goto error_unpin;
 #endif
 	bl->buf_pages = pages;
 	bl->buf_nr_pages = nr_pages;
@@ -510,6 +516,10 @@ static int io_pin_pbuf_ring(struct io_uring_buf_reg *reg,
 	bl->is_mapped = 1;
 	bl->is_mmap = 0;
 	return 0;
+error_unpin:
+	for (i = 0; i < nr_pages; i++)
+		unpin_user_page(pages[i]);
+	return -EINVAL;
 }
 
 static int io_alloc_pbuf_ring(struct io_uring_buf_reg *reg,

-- 
Jens Axboe

