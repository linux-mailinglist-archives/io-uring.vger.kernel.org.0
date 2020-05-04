Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D55A11C3E39
	for <lists+io-uring@lfdr.de>; Mon,  4 May 2020 17:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbgEDPOV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 May 2020 11:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726509AbgEDPOU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 May 2020 11:14:20 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824D4C061A0E
        for <io-uring@vger.kernel.org>; Mon,  4 May 2020 08:14:19 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id w6so11596091ilg.1
        for <io-uring@vger.kernel.org>; Mon, 04 May 2020 08:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kTJsWf2wUvTUDTNdsC6joYCd14YIQe7Y+eiEFUUNYRk=;
        b=TJjR6/xrSes12YBJfChfY2uuDyxrT0DrlPVOlj57/0PpMAmHCjmS7qpo7PlkaWFfGO
         Ty4ASrilPZ3XOvJONEGrhWsFv1R2FSwQgDzW9NaGUg0tppal9/mEhQyXRYbeyABz4PLS
         neaapsDlo7BVAyeEuWM/9aescrTM7np84e++uGco6XgFy6TUdEwCR+Q2mqExSlOY9QO5
         eItDpmewRuMEk9abTtYtll3mkHR2ZdDZ0r4Wem7FRF0v84ELT82xbuEScton2L+AoxpN
         RKDwh3fg1SRlebI87fsIwqbNk8TEnCMw5jkTW/VqDVlDQEMfD8zPaCoRNNynI8AIAfZm
         HMeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kTJsWf2wUvTUDTNdsC6joYCd14YIQe7Y+eiEFUUNYRk=;
        b=F1tlw74fG+/PGnk6+7ffMXqGnFFvOVkGC61C/fisONkvc8wiQB36cyQUf4oL/qn40s
         59/kgEDT5nVXbhuo7Ornx+JtKRFiLu/u1smGCHeQVzNzvJYoSRgo4AbZYMUrWvNGlB2/
         SCsL0LE30Vndc9XOwIWndho9O3MzXT74pLX8UyRwjYsLlspmyoKrFUdVst3HRr538E99
         7ZQFf7DLVklJPsVeuQ7wURlLp/O6RoY1a7ueIO3yU9FyYy/mlgNLpUVJ7i+9oktb6iJD
         YPjOdBTn3CAaYD+geIPMWTh206qWJ4QQVPXTAIFSoV+8MnDIxND6u0ydR7rPedyvwoXp
         3JjA==
X-Gm-Message-State: AGi0PuYbhgMTjq7yz4vVfk4oFylmQL8Yg0aCpSMmKM+pW75Zarzi5Z2g
        csjm1yOXWz5XSHcudRi8CN5AEVv0yynGyQ==
X-Google-Smtp-Source: APiQypLudBUJTGkX9poOUZwnMWUHoasO5L/XqKVeVGul/STuHqgUFLWPnN1IMSEA+bX61Gj1rHUdmA==
X-Received: by 2002:a92:5c57:: with SMTP id q84mr16872840ilb.203.1588605258802;
        Mon, 04 May 2020 08:14:18 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id m22sm4135930iow.35.2020.05.04.08.14.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 08:14:17 -0700 (PDT)
Subject: Re: [PATCH] io_uring: handle -EFAULT properly in io_uring_setup()
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200504135328.29396-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b92af5ea-3cbe-a25f-7e49-8e7480bcba59@kernel.dk>
Date:   Mon, 4 May 2020 09:14:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200504135328.29396-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/4/20 7:53 AM, Xiaoguang Wang wrote:
> If copy_to_user() in io_uring_setup() failed, we'll leak many kernel
> resources, which could be reproduced by using mprotect to set params
> to PROT_READ. To fix this issue, refactor io_uring_create() a bit to
> let it return 'struct io_ring_ctx *', then when copy_to_user() failed,
> we can free kernel resource properly.

Might be simpler to just pass in the __user pointer for the copy,
ala the below. Totally untested...


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6d52ff98279d..70361f588c5b 100644
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
@@ -7863,6 +7864,12 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p)
 	p->features = IORING_FEAT_SINGLE_MMAP | IORING_FEAT_NODROP |
 			IORING_FEAT_SUBMIT_STABLE | IORING_FEAT_RW_CUR_POS |
 			IORING_FEAT_CUR_PERSONALITY | IORING_FEAT_FAST_POLL;
+
+	if (copy_to_user(params, p, sizeof(*p))) {
+		ret = -EFAULT;
+		goto err;
+	}
+
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

