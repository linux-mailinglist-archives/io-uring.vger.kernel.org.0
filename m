Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D795F7B5879
	for <lists+io-uring@lfdr.de>; Mon,  2 Oct 2023 18:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238192AbjJBQnu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Oct 2023 12:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231972AbjJBQns (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Oct 2023 12:43:48 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C521A4
        for <io-uring@vger.kernel.org>; Mon,  2 Oct 2023 09:43:45 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id e9e14a558f8ab-3526ac53d43so1353515ab.1
        for <io-uring@vger.kernel.org>; Mon, 02 Oct 2023 09:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1696265025; x=1696869825; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AMtl0t8ewUYdyp0PrDfhIKqyNakrSyvKX53mRjqJ1tE=;
        b=AsvpsuzX5OBlNuy47XGRYREwbzmMJbNYSjuYUfnczlL4K9l+K40SrK9FDxfQjuIJI6
         DAeSHMGpb9vzMGvB9TH4sAQA9JHqgUmXpU7cVGQhBoDAqFyZIjM9th506DHGUIflEtZJ
         WdbLXEzGSccuzl+cPlSr9qpOOSv8dRXlqyz7bzReZbgGDP3JATEmryBoKg3M2bBfEFbc
         izOKP2c+8tFlCW4lYDZA7M/u9+pv6tgM/uHgm+RLMDH0PwNxkeAOlPlM0UpnLLAzp/xG
         ds4V2flzs6Gk2EiHQO52otdTZ6JlYCHW9e1iW/dF6c02gt5qTRr9gFnX3IBt8paa0CPM
         aAcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696265025; x=1696869825;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AMtl0t8ewUYdyp0PrDfhIKqyNakrSyvKX53mRjqJ1tE=;
        b=fiU2tTsCkL7g7OmtZOxJ2+D4yfFJgWJguF/lcXV/ZTqKs3+wv/8ppdfrdph7Wllw0z
         Y1EzSfcZnZYPrTS1YZsoZ8Bhe1m04E41K1+sjSYCma6El4y6d9Mo21PtV+iO0xR2Y34j
         TeNqXm75YSCW4wdqlnAUrh/3xaTIN97wQaT51eHTyPfxRRCGBNdkWQ+4cZyDuB3Dwz+u
         dSCFvBRJ1N2tWNuDB8CsFHw3p2lCCAwF1ZQ2aRSz65m/4QCGxWXmpHn9ylYIc9eAeUUb
         Nn+QNd7NfNZD48f/F1XwbH/9ozlNTqmVmyr9NSFRHX7LtE8gnVNcYAKNhf4+G1YORSHc
         uw0A==
X-Gm-Message-State: AOJu0YythUJxD4TevI/RW/nQE5Iz++JiVmkJGui05/LhbsH3k10Qu2rC
        mhbIhvmXTekxiAkvkGGcr71UAIlhdkt7d6Mdejv3pA==
X-Google-Smtp-Source: AGHT+IFxLlGnk5JYcLuvXJfpCR2uF82ZolgrFATVVixab45nCxnLhXnmWGgUaIVvnmXUehKzsv6Inw==
X-Received: by 2002:a92:d487:0:b0:34f:7ba2:50e8 with SMTP id p7-20020a92d487000000b0034f7ba250e8mr11080042ilg.2.1696265024968;
        Mon, 02 Oct 2023 09:43:44 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id r17-20020a92d991000000b0035260e105fdsm2550151iln.36.2023.10.02.09.43.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Oct 2023 09:43:44 -0700 (PDT)
Message-ID: <7567c27a-b5d0-41fc-a7e5-d65ed168b39c@kernel.dk>
Date:   Mon, 2 Oct 2023 10:43:43 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] BUG: unable to handle kernel NULL pointer
 dereference in __io_remove_buffers (2)
Content-Language: en-US
To:     syzbot <syzbot+2113e61b8848fa7951d8@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000af635c0606bcb889@google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <000000000000af635c0606bcb889@google.com>
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

On 10/2/23 8:38 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    ec8c298121e3 Merge tag 'x86-urgent-2023-10-01' of git://gi..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=16ef0ed6680000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3be743fa9361d5b0
> dashboard link: https://syzkaller.appspot.com/bug?extid=2113e61b8848fa7951d8
> compiler:       arm-linux-gnueabi-gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> userspace arch: arm

I tried the syz repro in the console output, but can't trigger it. It
also makes very little sense to me... For when there is a reproducer,
the below would perhaps shed some light on it. We have bl->is_mapped ==
1, yet bl->buf_ring is NULL. Probably some artifact of 32-bit arm?


diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 556f4df25b0f..d5133ac8005f 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -504,6 +504,9 @@ static int io_pin_pbuf_ring(struct io_uring_buf_reg *reg,
 		return -EINVAL;
 	}
 #endif
+	WARN_ON_ONCE(!pages);
+	WARN_ON_ONCE(!nr_pages);
+	WARN_ON_ONCE(!br);
 	bl->buf_pages = pages;
 	bl->buf_nr_pages = nr_pages;
 	bl->buf_ring = br;
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

