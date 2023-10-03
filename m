Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6AA77B5E32
	for <lists+io-uring@lfdr.de>; Tue,  3 Oct 2023 02:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237630AbjJCA1h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Oct 2023 20:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbjJCA1h (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Oct 2023 20:27:37 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF0293
        for <io-uring@vger.kernel.org>; Mon,  2 Oct 2023 17:27:35 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id 98e67ed59e1d1-2773b10bd05so81892a91.0
        for <io-uring@vger.kernel.org>; Mon, 02 Oct 2023 17:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1696292854; x=1696897654; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7BrfX1xDxz0oI6lLJhXyI4Cs4wLYuMdlX8k9NWW1bYI=;
        b=KSJKfewhgm6+5sld3qllG7iOS+ChiVju5sMY4Um2I4jMLVL2nmXRxpaiMoGonPFVS6
         VwRrwPRiLTuBuTSAfUz9wLWuCIZcSnSMYRw0amY40YB7cSd0yZCSCMFmlbozsKTBxbXS
         k6JaieFYYC6bMbdK2I5vyI2zSboPzRxChHOYZfQtsyWzXOMitZtjLM7N/G4S4DKFQeAk
         GqQgR/Wv4H7GQ1BPXu4FJwhK0zh8MPGKmzFR26neKvTmuUWEvjAUuhUZgmlo4NABteD4
         yh199TJHmI5xj/j3Q9gPM7vr1tgnsvL5CviIz2W7hHkiu2Y/tamnGVOjhFivykDu514N
         U6BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696292854; x=1696897654;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7BrfX1xDxz0oI6lLJhXyI4Cs4wLYuMdlX8k9NWW1bYI=;
        b=WC+Z9VVutSxTUIcyPJ/M/1dDuoGnEKHrwTsYuow0gnIZdl+JGiuqgApPgMI33wGlQX
         02buxBc/0LaBCrIdW9rXdaFBGCmNBCSo1iPkMUkzI8KgqVKkahKQ+rQhhPls3gMzZ8LX
         1byOqB1uv6zs7DqjZ6jI2FhcRHTcf40cZ4PQI4p3z0J2gOfhi7jXftRifM81J5zFJvkK
         U3Ihaha59EpbmQyOtH7JE4zpNq4JgoNwqZTGkJhvH6FF2vvli6jBO89rK7U/xbhyhd/A
         4kl/fRL3TWgGTmecRnl5hIqdVNfT2yhwmvLrbgWT6efBjSxVNsQJ1lxFYeKDlOPppBvK
         sYfg==
X-Gm-Message-State: AOJu0YxViiFpQZIHth5utz31LnlaxD/T6qNm8GYffkq6+e9aLhuZMiwj
        CKim2TnZgvtsIdEHqRXy8OGkl7zVBJfWy29Ph8A=
X-Google-Smtp-Source: AGHT+IFxe+keMS3VjtAz/LYT0pV47qGFpNl+F2AF8LL05CemhpHdAnCTnHD7Iomb46pj4YQiqYZ6Vg==
X-Received: by 2002:a05:6a21:9984:b0:15a:2c0b:6c81 with SMTP id ve4-20020a056a21998400b0015a2c0b6c81mr15279364pzb.3.1696292853642;
        Mon, 02 Oct 2023 17:27:33 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id c14-20020aa7880e000000b00693411c6c3csm90959pfo.39.2023.10.02.17.27.32
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Oct 2023 17:27:32 -0700 (PDT)
Message-ID: <87b4a76e-0376-4c08-b56a-263bd7149538@kernel.dk>
Date:   Mon, 2 Oct 2023 18:27:32 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH for-next] io_uring/rsrc: cleanup io_pin_pages()
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

This function is overly convoluted with a goto error path, and checks
under the mmap_read_lock() that don't need to be at all. Rearrange it
a bit so the checks and errors fall out naturally, rather than needing
to jump around for it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index d9c853d10587..7034be555334 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1037,39 +1037,36 @@ struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages)
 {
 	unsigned long start, end, nr_pages;
 	struct page **pages = NULL;
-	int pret, ret = -ENOMEM;
+	int ret;
 
 	end = (ubuf + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	start = ubuf >> PAGE_SHIFT;
 	nr_pages = end - start;
+	WARN_ON(!nr_pages);
 
 	pages = kvmalloc_array(nr_pages, sizeof(struct page *), GFP_KERNEL);
 	if (!pages)
-		goto done;
+		return ERR_PTR(-ENOMEM);
 
-	ret = 0;
 	mmap_read_lock(current->mm);
-	pret = pin_user_pages(ubuf, nr_pages, FOLL_WRITE | FOLL_LONGTERM,
-			      pages);
-	if (pret == nr_pages)
+	ret = pin_user_pages(ubuf, nr_pages, FOLL_WRITE | FOLL_LONGTERM, pages);
+	mmap_read_unlock(current->mm);
+
+	/* success, mapped all pages */
+	if (ret == nr_pages) {
 		*npages = nr_pages;
-	else
-		ret = pret < 0 ? pret : -EFAULT;
+		return pages;
+	}
 
-	mmap_read_unlock(current->mm);
-	if (ret) {
+	/* partial map, or didn't map anything */
+	if (ret >= 0) {
 		/* if we did partial map, release any pages we did get */
-		if (pret > 0)
-			unpin_user_pages(pages, pret);
-		goto done;
-	}
-	ret = 0;
-done:
-	if (ret < 0) {
-		kvfree(pages);
-		pages = ERR_PTR(ret);
+		if (ret)
+			unpin_user_pages(pages, ret);
+		ret = -EFAULT;
 	}
-	return pages;
+	kvfree(pages);
+	return ERR_PTR(ret);
 }
 
 static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,

-- 
Jens Axboe

