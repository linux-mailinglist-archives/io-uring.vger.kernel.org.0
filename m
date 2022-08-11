Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA4D58FEB8
	for <lists+io-uring@lfdr.de>; Thu, 11 Aug 2022 17:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235477AbiHKPCz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Aug 2022 11:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235497AbiHKPCw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Aug 2022 11:02:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4961124BEA
        for <io-uring@vger.kernel.org>; Thu, 11 Aug 2022 08:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660230169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6N6QzuAYNcLuvbpFNhmVVtzYHNHNp9A+IUqAPQVfJJk=;
        b=aHsmr/cjc/q9DTAfHTwpQuK23E3Di07nzH483P+GdumK+BruaxWsvZiJkfNeP9q3csQEai
        jd04e5MH66/t8IqiHteKew0RDEmo5/7G1WPzUCtmjBZbuOpDo1gZ9BHAQZaTZu0YxnhAGZ
        mMlDeYfh1G4G53V8f6QsSi5BqfoHKYE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-554-ln5M9pFCPO65bxzyOXCsGw-1; Thu, 11 Aug 2022 11:02:47 -0400
X-MC-Unique: ln5M9pFCPO65bxzyOXCsGw-1
Received: by mail-wm1-f69.google.com with SMTP id a17-20020a05600c349100b003a545125f6eso2770602wmq.4
        for <io-uring@vger.kernel.org>; Thu, 11 Aug 2022 08:02:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=6N6QzuAYNcLuvbpFNhmVVtzYHNHNp9A+IUqAPQVfJJk=;
        b=BgnsNNrLuCN8FvS56f9AIJqQQKTX/W80AlGeTqPAqD/MZnWjqMEd1QpGSeWVkL4yiP
         n7pKuD7/b6O22plGPK0m2exJlCIoPa9q+UlNBlurSjtrGt1y0kQYgY6roE5cjFRDumLx
         ltr3bcwOF+uG387svUJwZaCa5VaoExk24C1vy2BHQ1GpLpszAWW93VHL81EVOgnlU5qJ
         U+Yupd7k48J6IX2kPkkyLBX6KZiA2zBOo1SAWySGuVJLwxLmVhBEgfkfxR9JA2n7Wb/p
         0fkkjvhZDU/j7hbiaZANdaZfVLolJ6iKTQB8UFBzTq/M5+7JxW3GOeUhtw2AbKZlTDjQ
         t2RQ==
X-Gm-Message-State: ACgBeo0WEUnjxiL2RWCByg3X0XkOgwfDMhxYvqH26lKlbXjSWzBnPNpA
        AoNCyoLJRwDcuONjXahNQq7ZPQwO6YKjV6sA2eZ1Ys+JVKDzErmZ2IqA5f6GB8zheJceV2moQCh
        9i1ZIYTiYP6toKK7TNDE=
X-Received: by 2002:a05:6000:178e:b0:220:635f:eb13 with SMTP id e14-20020a056000178e00b00220635feb13mr20336490wrg.634.1660230166541;
        Thu, 11 Aug 2022 08:02:46 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5tCrS0IgLCyaY/OlcjExUFb573b9yp/DOgUwEtknZbmCtvPzB2Ff5feMuGpmbMfL96S+/nwQ==
X-Received: by 2002:a05:6000:178e:b0:220:635f:eb13 with SMTP id e14-20020a056000178e00b00220635feb13mr20336469wrg.634.1660230166294;
        Thu, 11 Aug 2022 08:02:46 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-178.retail.telecomitalia.it. [79.46.200.178])
        by smtp.gmail.com with ESMTPSA id p3-20020a05600c1d8300b003a50924f1c0sm6664611wms.18.2022.08.11.08.02.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 08:02:45 -0700 (PDT)
Date:   Thu, 11 Aug 2022 17:02:42 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Zhang chunchao <chunchao@nfschina.com>
Cc:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@nfschina.com
Subject: Re: [PATCH] Modify the return value ret to EOPNOTSUPP when
 initialized to reduce repeated assignment of errno
Message-ID: <20220811150242.giygjmy4vimxtrzg@sgarzare-redhat>
References: <20220811075638.36450-1-chunchao@nfschina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220811075638.36450-1-chunchao@nfschina.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Aug 11, 2022 at 03:56:38PM +0800, Zhang chunchao wrote:
>Remove unnecessary initialization assignments.
>
>Signed-off-by: Zhang chunchao <chunchao@nfschina.com>
>---
> io_uring/io_uring.c | 3 +--
> 1 file changed, 1 insertion(+), 2 deletions(-)
>
>diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>index b54218da075c..8c267af06401 100644
>--- a/io_uring/io_uring.c
>+++ b/io_uring/io_uring.c
>@@ -3859,14 +3859,13 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
> 		void __user *, arg, unsigned int, nr_args)
> {
> 	struct io_ring_ctx *ctx;
>-	long ret = -EBADF;
>+	long ret = -EOPNOTSUPP;
> 	struct fd f;
>
> 	f = fdget(fd);
> 	if (!f.file)
> 		return -EBADF;
>
>-	ret = -EOPNOTSUPP;
> 	if (!io_is_uring_fops(f.file))
> 		goto out_fput;
>

What about remove the initialization and assign it in the if branch?
I find it a bit easier to read.

I mean something like this:

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3859,16 +3859,17 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
                 void __user *, arg, unsigned int, nr_args)
  {
         struct io_ring_ctx *ctx;
-       long ret = -EBADF;
+       long ret;
         struct fd f;

         f = fdget(fd);
         if (!f.file)
                 return -EBADF;

-       ret = -EOPNOTSUPP;
-       if (!io_is_uring_fops(f.file))
+       if (!io_is_uring_fops(f.file)) {
+               ret = -EOPNOTSUPP;
                 goto out_fput;
+       }

         ctx = f.file->private_data;


Otherwise remove the initialization, but leave the assignment as it is 
now.

Thanks,
Stefano

