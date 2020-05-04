Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18F621C3F0E
	for <lists+io-uring@lfdr.de>; Mon,  4 May 2020 17:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729075AbgEDPxo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 May 2020 11:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725941AbgEDPxn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 May 2020 11:53:43 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A7FC061A0E
        for <io-uring@vger.kernel.org>; Mon,  4 May 2020 08:53:42 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id c2so12814803iow.7
        for <io-uring@vger.kernel.org>; Mon, 04 May 2020 08:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lx7Wc0Zdb4PinBRTDIFbjVTEN5O86pFRibO907vY4jY=;
        b=MBYwksPP2XS1ZKlsfSCFPVvjsIx06mxeVUSVNP9f0DjG6OE8hK/8gHe9+lnbdsoEN0
         VMrOVm237hbaAQaw/HDBKNPA0YsyXxtSiXRYJ27cfBE5AXe6rPM/s7J0BTSKFBARWkSJ
         S3uffDjaUW2+MfHUsHg8s8YGg6zjKZRw2OofYT/YdbeYdaFSZRAljUJ2xPAqEdA72X/d
         EEVofckYGNmFkBWNQ3kqSIJzlh6hgjALTPV8CefW94UlFxbeC4/hKM7haXPvZAJX4+3W
         x4qfHWHH/b68poYwLMNlHPtnvrbETRSq/N+bmG5Cses0nHDkCzU+ivTLVRRUMwsKV/a7
         7Uzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lx7Wc0Zdb4PinBRTDIFbjVTEN5O86pFRibO907vY4jY=;
        b=jUknXjShuISOPx9/Wrm3KcTifQA9aCm+2ZtOYzv977wJQ5KAxikxnGxkrrgkuOm0If
         GlLS10rmN8TzdkDTohL+DWEo3UQ9k610qypcTXTl2jnQV2Eeqr5kTvK6XSSI1H2thG4h
         fI0MrhiGyifQxV1KRtAH+4OoSSw1XUGAn8mNHfAcpaB6JSgAVd8qcJmeczKNoOzkbn4g
         jKoypJWa97z6R/+MDAr9+CIJ4I7Jj32APWL7+2TUT1lWkjwsZHBtTeD0V1TQcvrf6Fc9
         sC9YoSQCaX933OSNsg56jHCkndMb9wHtAeRfY/PJsy2fq3jJc/Q4391ZwI92fEDl6rko
         WByw==
X-Gm-Message-State: AGi0PuZJ/fhI+euqSGwNZ1ia3AcVHVJrjUtJyLomKXXcSIxGVS3banCW
        esl7tsz8v6OvXlTFaykEGP+27A==
X-Google-Smtp-Source: APiQypJPBxZF0MaHh3YC0vXo4cmg+YXN31B0Ad71dLNdMP1A7xM8cwZ+TCZmXZEwfDUFKC/QTX65zA==
X-Received: by 2002:a02:a60b:: with SMTP id c11mr15044467jam.45.1588607621828;
        Mon, 04 May 2020 08:53:41 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id z3sm4282814ior.45.2020.05.04.08.53.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 08:53:41 -0700 (PDT)
Subject: Re: [PATCH] io_uring: handle -EFAULT properly in io_uring_setup()
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200504135328.29396-1-xiaoguang.wang@linux.alibaba.com>
 <8f6b82d4-7e52-e25a-4f05-f16e51854df1@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8f75fc56-03c7-7763-cbf8-787aae0901b5@kernel.dk>
Date:   Mon, 4 May 2020 09:53:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <8f6b82d4-7e52-e25a-4f05-f16e51854df1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/4/20 9:40 AM, Pavel Begunkov wrote:
> On 04/05/2020 16:53, Xiaoguang Wang wrote:
>> If copy_to_user() in io_uring_setup() failed, we'll leak many kernel
>> resources, which could be reproduced by using mprotect to set params
> 
> At least it recycles everything upon killing the process, so that's rather not
> notifying a user about a successfully installed fd. Good catch

Let me revise the simpler version, so we error before doing the fd install
at least. Still untested...


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6d52ff98279d..8eea54197489 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7760,7 +7760,8 @@ static int io_uring_get_fd(struct io_ring_ctx *ctx)
 	return ret;
 }
 
-static int io_uring_create(unsigned entries, struct io_uring_params *p)
+static int io_uring_create(unsigned entries, struct io_uring_params *p,
+			   struct io_uring_params __user *params)
 {
 	struct user_struct *user = NULL;
 	struct io_ring_ctx *ctx;
@@ -7852,6 +7853,15 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p)
 	p->cq_off.overflow = offsetof(struct io_rings, cq_overflow);
 	p->cq_off.cqes = offsetof(struct io_rings, cqes);
 
+	p->features = IORING_FEAT_SINGLE_MMAP | IORING_FEAT_NODROP |
+			IORING_FEAT_SUBMIT_STABLE | IORING_FEAT_RW_CUR_POS |
+			IORING_FEAT_CUR_PERSONALITY | IORING_FEAT_FAST_POLL;
+
+	if (copy_to_user(params, p, sizeof(*p))) {
+		ret = -EFAULT;
+		goto err;
+	}
+
 	/*
 	 * Install ring fd as the very last thing, so we don't risk someone
 	 * having closed it before we finish setup
@@ -7860,9 +7870,6 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p)
 	if (ret < 0)
 		goto err;
 
-	p->features = IORING_FEAT_SINGLE_MMAP | IORING_FEAT_NODROP |
-			IORING_FEAT_SUBMIT_STABLE | IORING_FEAT_RW_CUR_POS |
-			IORING_FEAT_CUR_PERSONALITY | IORING_FEAT_FAST_POLL;
 	trace_io_uring_create(ret, ctx, p->sq_entries, p->cq_entries, p->flags);
 	return ret;
 err:
@@ -7878,7 +7885,6 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p)
 static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 {
 	struct io_uring_params p;
-	long ret;
 	int i;
 
 	if (copy_from_user(&p, params, sizeof(p)))
@@ -7893,14 +7899,7 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ))
 		return -EINVAL;
 
-	ret = io_uring_create(entries, &p);
-	if (ret < 0)
-		return ret;
-
-	if (copy_to_user(params, &p, sizeof(p)))
-		return -EFAULT;
-
-	return ret;
+	return io_uring_create(entries, &p, params);
 }
 
 SYSCALL_DEFINE2(io_uring_setup, u32, entries,

-- 
Jens Axboe

