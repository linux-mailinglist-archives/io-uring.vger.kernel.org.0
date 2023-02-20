Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D231769CF1F
	for <lists+io-uring@lfdr.de>; Mon, 20 Feb 2023 15:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbjBTOPM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Feb 2023 09:15:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjBTOPM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Feb 2023 09:15:12 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1352210246
        for <io-uring@vger.kernel.org>; Mon, 20 Feb 2023 06:15:11 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id o4-20020a05600c4fc400b003e1f5f2a29cso1242140wmq.4
        for <io-uring@vger.kernel.org>; Mon, 20 Feb 2023 06:15:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7NYmdjO52cFo/lR5il5nIEn6/cT4Vw+dPSVlcJv33pk=;
        b=LwL4NA6X3g8rhAMGIinrHXLlRSQvtaxkc9RKyyXJKRWfV0j/rFTBjfhbTvRVTrdhBx
         UjsRKsvpihfp/RCL1jvy03pSs22ek47jIfTnyrM9KkOzax5XnD3kyE03a4HJVvvtgxwH
         94juXW95qhq4mXDY0H3HN68L9OyqPnY62iS06p4JRP8WpjCCCHyFAl9jfybAhm0ciTFU
         Cf/9sfBxnzsRrspMtsIre/Wdd7KqyXWmbIWuNfiMUOxIq5MHkTOf2j/29ULZFMQefoKY
         AWEJAraL2+K0lsWn5tRiw8CW38zeMJE92hN57VDJ6JPnB+yc1VRnhRn6NbqqBCRN05xj
         XXVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7NYmdjO52cFo/lR5il5nIEn6/cT4Vw+dPSVlcJv33pk=;
        b=z0i4KQUly81lURcUtJLGTjhaCjLA0PrQ7PH6Bg8GoaobGGDjYBpBxxi62FBGaL49Re
         7nUI/f+YCPB94MenxyvlYeMR5ol+2ne7i14l+PoQa1dnqV9KlqRmv3YLOXX0hF+yV7Dy
         oofRYz49MqvPRNllbCw9snhL7qk5r4Nk7jULv/nkgStSvVJ8KcCmav6kF63MDJSG7w8+
         KioLj4nvHA9px2fFySRnkfI8wlULPdaGBbTqStDD3j1peCXo9T8Qjb0Us+mdOJB1MKyX
         J36a5P5wD+4KFCrDNRACdxGV0eM+lWKYFlU36rVyfhFka3YxNRbHj4VnyrHwmW6wGyyb
         ShyQ==
X-Gm-Message-State: AO0yUKVc+WM8SQqb1sfc3vMj26gBvRVI82KmADQbc0IeXHGOUgzklFP8
        OVCSeSM8nU+h7Iu6vW50FKc4ly0sQkE=
X-Google-Smtp-Source: AK7set+Y9PQvfer7+P7m8eEMlJ4ujgt0YarFjFcPNfyeq5nIxm6TLINUVz0WvfS21n7DABbHbbDaqQ==
X-Received: by 2002:a05:600c:1895:b0:3e1:fc61:e0e5 with SMTP id x21-20020a05600c189500b003e1fc61e0e5mr1298077wmp.33.1676902509109;
        Mon, 20 Feb 2023 06:15:09 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.95.64.threembb.co.uk. [94.196.95.64])
        by smtp.gmail.com with ESMTPSA id y14-20020a7bcd8e000000b003e118684d56sm247879wmj.45.2023.02.20.06.15.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 06:15:08 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 1/1] io_uring/rsrc: don't mix different mappings in reg
Date:   Mon, 20 Feb 2023 14:13:32 +0000
Message-Id: <813cdd2d15c3c471bf06c6c93a0a35315d08a3ad.1676902351.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If two or more mappings go back to back to each other they can be passed
into io_uring to be registered as a single registered buffer. That would
even work if mappings came from different sources, e.g. it's possible to
mix in this way anon pages and pages from shmem or hugetlb. That is not
a problem but it'd rather be less prone if we forbid such mixing.

Cc: <stable@vger.kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index a59fc02de598..70d7f94670f9 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1162,18 +1162,19 @@ struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages)
 	pret = pin_user_pages(ubuf, nr_pages, FOLL_WRITE | FOLL_LONGTERM,
 			      pages, vmas);
 	if (pret == nr_pages) {
+		struct file *file = vmas[0]->vm_file;
+
 		/* don't support file backed memory */
 		for (i = 0; i < nr_pages; i++) {
-			struct vm_area_struct *vma = vmas[i];
-
-			if (vma_is_shmem(vma))
+			if (vmas[i]->vm_file != file)
+				break;
+			if (!file)
 				continue;
-			if (vma->vm_file &&
-			    !is_file_hugepages(vma->vm_file)) {
-				ret = -EOPNOTSUPP;
+			if (!vma_is_shmem(vmas[i]) && !is_file_hugepages(file))
 				break;
-			}
 		}
+		if (i != nr_pages)
+			ret = -EOPNOTSUPP;
 		*npages = nr_pages;
 	} else {
 		ret = pret < 0 ? pret : -EFAULT;
-- 
2.39.1

