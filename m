Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD4169CF41
	for <lists+io-uring@lfdr.de>; Mon, 20 Feb 2023 15:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbjBTOWf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Feb 2023 09:22:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbjBTOWe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Feb 2023 09:22:34 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E96091EFC4
        for <io-uring@vger.kernel.org>; Mon, 20 Feb 2023 06:22:33 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id h32so5549228eda.2
        for <io-uring@vger.kernel.org>; Mon, 20 Feb 2023 06:22:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7NYmdjO52cFo/lR5il5nIEn6/cT4Vw+dPSVlcJv33pk=;
        b=SkHgLA5f5iWwx0gbQMXMSe3/nmcukJ8W2psNuRQo3r1LCAeYyU2+HRu55cmn8XsD5J
         wlmbyrNJ8jIwPFXSCUJoLIyTzDRDyRSGdupo2YqqmsGFU2I6lec/gccjuRZSdVkFlo1/
         ZGRPOzLA09Zxwb1pftawEeGRv3sHBsFdLVEktQFEeSIpfR6pPHu3CUp5c9cFZHfvGt0g
         sgUuA8wczIFpLxXXEJTYeAPjywpqI86MPGIIwTmB7sYGAEZcJxnWZNKTlF/+1Yy0EGeW
         Aay8DtlAFQIpZ1UqCfEQpP9Bp4gGItk/y+5BCzQfc+tqMXC8zEr39qmxRzC8yJGTekQn
         lGhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7NYmdjO52cFo/lR5il5nIEn6/cT4Vw+dPSVlcJv33pk=;
        b=MgMgLv/vRUxvc+y8I1xta/VZuqVhD5P/UiGhnVcbrhU9xkL6wzvzqhm6H5eEOuKCow
         or3G/KRaHd1tZHcgu5qyhMXFXAjW7ioIcYpmXWO52/g6vns67u9mWnm/URmfAGcr3tV7
         VVqmo+/JN6HRgLEjjb+zf3mL/DpjctooTZexou+gEtFYXatb4JPqKEg2NLtMx3ENBErB
         ht2kbCPpLiPycrfDJhtIRkplQ3nvzdYNGz5jHmiekK1rysD4I4hmeVqn4mM29JzvVmka
         +sIgs0o8yl7EdolOWMHbJoykL7ppN+0D2q/aGf9Zc2ttu7NgJnJA60XjaUwyoa+XFh0Y
         NwlQ==
X-Gm-Message-State: AO0yUKVC35p0i8i/0arDb6omuvbMiVH9EXOsPXh/OczxZEPmqi/cp+8Y
        3oBn3wttrKgAu5F7FbXQD/lAdjKjYlQ=
X-Google-Smtp-Source: AK7set/D3xSdHFJCQcD251VcwLDVZVyGRM4lHY0Zl6ka7vDJrdhFjS1XCiCQj38OhikKmJZ375548Q==
X-Received: by 2002:a05:6402:34f:b0:4ac:b7ff:945f with SMTP id r15-20020a056402034f00b004acb7ff945fmr1777826edw.9.1676902952288;
        Mon, 20 Feb 2023 06:22:32 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.95.64.threembb.co.uk. [94.196.95.64])
        by smtp.gmail.com with ESMTPSA id 21-20020a508755000000b004acc02d1531sm849293edv.14.2023.02.20.06.22.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 06:22:31 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 1/1] io_uring/rsrc: disallow multi-source reg buffers
Date:   Mon, 20 Feb 2023 14:20:57 +0000
Message-Id: <6d973a629a321aa73c286f2d64d5375327d5c02a.1676902832.git.asml.silence@gmail.com>
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

