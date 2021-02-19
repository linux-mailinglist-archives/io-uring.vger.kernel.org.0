Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBCF31FD46
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 17:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbhBSQjN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 11:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbhBSQjH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 11:39:07 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B4EC06178C
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 08:37:48 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id g9so4994802ilc.3
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 08:37:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QopIIrFF742BKqlOh4+TqmLjkxOTaJiQM9hc+/gnVxg=;
        b=xldRnNMtCqOBtzAdSkbWqDWK1ZbBF6xEYQZCfkn3Y7jcOIl3VVDqypJDMNaSi54KE1
         w5LVCAGlgEGfzdrZ86fr6IYN3EPax5C50K8P9YGyH/PbZ8Zx/hY+CcxcvvcchvODNXc2
         WyorXES1uKg5brfvrOuCQ9Ht4vWMeJGjFEO4hmvtMwWoEPHyuh1tfidic+3IF3ctBVet
         KDCu+30h/EzmrPC3/j8Sqjhcru3Z1CLS3vGB5FZryibLYYvzatBb7tPPkHfEUXFkobqm
         Q4nit8t2eBFzFSSdjciLL3gsu9vjwjHTERF2kHJrZViI4kb20kuxpp0LRFLcw/GBHMaD
         BUZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QopIIrFF742BKqlOh4+TqmLjkxOTaJiQM9hc+/gnVxg=;
        b=cTNH215yTheB5Ir6QAGkxsaJrbryx8/0GEHiVlKuwqhv74HNrkNnQbGMRbXo0dsH7J
         E8mBuY3uYria1wim9OYx4zQqH5zByBPyQkDNILOyfkfvFsBbFKYHRfmf1alldjUPSgCt
         WNfZJI3AsyG9q81MzLIfqgRMlY4qv8tb313CNpGM1o/6earndl0YxQQY2T96bgaZAge9
         gOSfIm1t4f53DnRJ0xmbq2Db7QaFbAg1mQAUoOce6felyz7TVtlFD0wntbEBdoS6YL2+
         IKT8ghiPn3IPGKbemfkYp+CybVMMoFuAF6+99BYvID37aqoMZVPYZ72boM9/NqeMalMm
         t3Fg==
X-Gm-Message-State: AOAM5334TbJ7VVc7jMDkl9M8pD4VaZQp6RN7pJvOGQRQa4LNXHa3IGya
        Peywz7PGrFpBL2BSuuK/ERSxHg==
X-Google-Smtp-Source: ABdhPJxaKeetAYFXJydsPreGczSfycYq3Pg3RINKEm67oHsdXLXdiZ/SpgwXBek/ZmbU589cfA+RMQ==
X-Received: by 2002:a05:6e02:13eb:: with SMTP id w11mr4524720ilj.103.1613752667719;
        Fri, 19 Feb 2021 08:37:47 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id g3sm6741393ile.10.2021.02.19.08.37.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Feb 2021 08:37:47 -0800 (PST)
Subject: Re: [next]: fs/io_uring.c:6171:10: error: implicit declaration of
 function 'io_sendmsg_prep_async'; did you mean 'io_req_prep_async'?
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        linux-mips@vger.kernel.org,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        io-uring@vger.kernel.org, open list <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        lkft-triage@lists.linaro.org
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <CA+G9fYt1Bk=DW1VoPgWe9ZHHoHu+6OyZi7ndMJHmoR14uJePyQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b4c660b0-ab0e-ec4c-2771-346ca164bf92@kernel.dk>
Date:   Fri, 19 Feb 2021 09:37:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CA+G9fYt1Bk=DW1VoPgWe9ZHHoHu+6OyZi7ndMJHmoR14uJePyQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/19/21 9:08 AM, Naresh Kamboju wrote:
> Linux next tag 20210219 arm and mips builds failed due to below error.
> 
> Following build configs failed
> arm (s3c6400_defconfig) with gcc-8
> arm (s3c6400_defconfig) with gcc-9
> arm (s3c6400_defconfig) with gcc-10
> 
> mips (e55_defconfig) with gcc-8
> mips (e55_defconfig) with gcc-9
> mips (e55_defconfig) with gcc-10
> 
> fs/io_uring.c:6171:10: error: implicit declaration of function
> 'io_sendmsg_prep_async'; did you mean 'io_req_prep_async'?
> [-Werror=implicit-function-declaration]
>    return io_sendmsg_prep_async(req);
>           ^~~~~~~~~~~~~~~~~~~~~
>           io_req_prep_async
> 
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

This should fix it, cleaning it up a bit at the same time.


commit b1c892df32ebf6f30c995e23dcafeae2392ad1bc
Author: Jens Axboe <axboe@kernel.dk>
Date:   Fri Feb 19 09:35:19 2021 -0700

    io_uring: make the !CONFIG_NET helpers a bit more robust
    
    With the prep and prep async split, we now have potentially 3 helpers
    that need to be defined for !CONFIG_NET. Add some helpers to do just
    that.
    
    Fixes the following compile error on !CONFIG_NET:
    
    fs/io_uring.c:6171:10: error: implicit declaration of function
    'io_sendmsg_prep_async'; did you mean 'io_req_prep_async'?
    [-Werror=implicit-function-declaration]
       return io_sendmsg_prep_async(req);
                 ^~~~~~~~~~~~~~~~~~~~~
                 io_req_prep_async
    
    Fixes: 93642ef88434 ("io_uring: split sqe-prep and async setup")
    Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b7bae301744b..c9a5c498dc3b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5127,56 +5127,32 @@ static int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 #else /* !CONFIG_NET */
-static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-{
-	return -EOPNOTSUPP;
-}
-
-static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
-{
-	return -EOPNOTSUPP;
-}
-
-static int io_send(struct io_kiocb *req, unsigned int issue_flags)
-{
-	return -EOPNOTSUPP;
-}
-
-static int io_recvmsg_prep(struct io_kiocb *req,
-			   const struct io_uring_sqe *sqe)
-{
-	return -EOPNOTSUPP;
-}
-
-static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
-{
-	return -EOPNOTSUPP;
-}
-
-static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
-{
-	return -EOPNOTSUPP;
-}
-
-static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-{
-	return -EOPNOTSUPP;
-}
-
-static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
-{
-	return -EOPNOTSUPP;
-}
-
-static int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-{
-	return -EOPNOTSUPP;
-}
-
-static int io_connect(struct io_kiocb *req, unsigned int issue_flags)
-{
-	return -EOPNOTSUPP;
-}
+#define IO_NETOP_FN(op)							\
+static int io_##op(struct io_kiocb *req, unsigned int issue_flags)	\
+{									\
+	return -EOPNOTSUPP;						\
+}
+
+#define IO_NETOP_PREP(op)						\
+IO_NETOP_FN(op)								\
+static int io_##op##_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe) \
+{									\
+	return -EOPNOTSUPP;						\
+}									\
+
+#define IO_NETOP_PREP_ASYNC(op)						\
+IO_NETOP_PREP(op)							\
+static int io_##op##_prep_async(struct io_kiocb *req)			\
+{									\
+	return -EOPNOTSUPP;						\
+}
+
+IO_NETOP_PREP_ASYNC(sendmsg);
+IO_NETOP_PREP_ASYNC(recvmsg);
+IO_NETOP_PREP_ASYNC(connect);
+IO_NETOP_PREP(accept);
+IO_NETOP_FN(send);
+IO_NETOP_FN(recv);
 #endif /* CONFIG_NET */
 
 struct io_poll_table {

-- 
Jens Axboe

