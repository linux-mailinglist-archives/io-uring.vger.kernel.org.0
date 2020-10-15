Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 324D728FA89
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 23:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbgJOVSj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Oct 2020 17:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbgJOVSi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Oct 2020 17:18:38 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B4B4C061755
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 14:18:37 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id e18so221832wrw.9
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 14:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=p91IjCl3Yvs6cLdRURHhvvD5ih7E03rP2F1Ax9ev4E4=;
        b=viJIlngatmuj0GSrcy0t9Ubst6SzcJPEvZZExrAv0FZj4yTFAOyf64/UyX5EOKpnmt
         2gt9T0N8jSuPSXbdfzXgyB7tnyMji5VwPKklbCqAABXvL8s772+TyYzpbYLZGFE56pBg
         kL2YrAUasWqD2g9K3R5+P6zoBRJ9NhETMROiL5XXIJoMG9ArsG+DzL20mQVufpDYyS8Q
         wJbEd5rW1O1rJT/Y+wVZju4xppioKO58RQtLtUnSsDOL/DMqH7Yw8NbvXfZxCoW4WDlI
         IqBii2XUwBAF+t5T1HrKuqjD9MbIrJ5pNn3C/2lowOchPW2KzayHeeR+8Y2xXazlVz3u
         a2CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=p91IjCl3Yvs6cLdRURHhvvD5ih7E03rP2F1Ax9ev4E4=;
        b=dLEiYNefjlUcyD3TAeBrnhQ5yG+KdmGvqwk1a6NC+zXJjjim2F3wOFzmcfS3oAol5d
         BigjraShgBKX1g//xIzvAfnS6ivuTD8ER+dgpVoqXe2WdKRXxHw/vMSKiSAhibJSkwC3
         CM8E8OSR92tNDD52EOF6PrTXSv3RxAwcx8G2nDqpphNYTFWAawJuTj6iqM7NuPkPGvn1
         zyDR9rLh3SRvYdrGGoBcIgIuolKdAMRhWoEhAJoJObbxuPc52eUpud3L329sUFKpbeHf
         0ePyUN8lwi7fliIZbbr9GQ4ong0eFIDcLwQrR7zte5g1/DaIQ5Alv95T3/79z5QWWvkx
         0qBQ==
X-Gm-Message-State: AOAM533ZhynCFT1RCU0ko3eWpaGtLK0YilbX15UK8LqoU64E5xjfMzeD
        I92G/haYlB6dPxpI1M89KXENHmW7V8SJ/Q==
X-Google-Smtp-Source: ABdhPJzFUjiglujWJMOd642bkWSQbMOA3cAgpzMUxtlunNRVTHgofcmvsmdyrFHXHacVtbs6ql7bUg==
X-Received: by 2002:a5d:6ca6:: with SMTP id a6mr233645wra.348.1602796715531;
        Thu, 15 Oct 2020 14:18:35 -0700 (PDT)
Received: from [192.168.1.69] (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id n2sm717893wrt.82.2020.10.15.14.18.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2020 14:18:34 -0700 (PDT)
Subject: Re: [PATCH for-next 0/4] singly linked list for chains
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1602795685.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <1b66cef4-4dec-1bf3-84f5-c5030c9c1511@gmail.com>
Date:   Thu, 15 Oct 2020 22:15:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <cover.1602795685.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 15/10/2020 22:11, Pavel Begunkov wrote:
> see [3/4] and [4/4] for motivation, the other two are just preps.
> I wasn't expecting to find performance difference, but my naive nop
> test yeilds 5030 vs 5160 KIOPS, before and after [3/4] correspondingly.

Forgot to add that I want to review it thoroughly on silly bugs,
so until then it's more of RFC. 

> The test is submitting 32 linked nops and waits for them to complete.
> The testing is tuned for consistentcy, and the results are consistent
> across reboots.

The test was basically like the diff below.


diff --git a/tools/io_uring/io_uring-bench.c b/tools/io_uring/io_uring-bench.c
index 7703f0118385..84c4487c4d4e 100644
--- a/tools/io_uring/io_uring-bench.c
+++ b/tools/io_uring/io_uring-bench.c
@@ -96,13 +96,13 @@ static volatile int finish;
 /*
  * OPTIONS: Set these to test the various features of io_uring.
  */
-static int polled = 1;		/* use IO polling */
+static int polled = 0;		/* use IO polling */
 static int fixedbufs = 1;	/* use fixed user buffers */
 static int register_files = 1;	/* use fixed files */
 static int buffered = 0;	/* use buffered IO, not O_DIRECT */
 static int sq_thread_poll = 0;	/* use kernel submission/poller thread */
 static int sq_thread_cpu = -1;	/* pin above thread to this CPU */
-static int do_nop = 0;		/* no-op SQ ring commands */
+static int do_nop = 1;		/* no-op SQ ring commands */
 
 static int io_uring_register_buffers(struct submitter *s)
 {
@@ -149,6 +149,7 @@ static void init_io(struct submitter *s, unsigned index)
 
 	if (do_nop) {
 		sqe->opcode = IORING_OP_NOP;
+		sqe->flags = IOSQE_IO_LINK;
 		return;
 	}
 
-- 
Pavel Begunkov
