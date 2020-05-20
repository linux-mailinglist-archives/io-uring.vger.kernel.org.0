Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0F091DB51F
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2020 15:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgETNeq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 May 2020 09:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbgETNeq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 May 2020 09:34:46 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E356AC061A0E
        for <io-uring@vger.kernel.org>; Wed, 20 May 2020 06:34:44 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id w19so1328678ply.11
        for <io-uring@vger.kernel.org>; Wed, 20 May 2020 06:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=16LnBHZF+zxStGOjP0fNe1Er1jdEh4ZT6MKJIYpDgbM=;
        b=UrDTPsjue3SeKjrjZwaV98YXJKLasuhKw0tss53P5QFtOCrgElEYFZzrs8aPVFZHsi
         uNE1V9dAGvlBM/+yr/s7g4pbr7CWDj/pvm/oC5w+iW1kqzAVVSdvppjrIRWWF/Cs4XTB
         WC3zxz57b50/E7nJ+RdulgNfkRHXKsRRzBdib/OVkaCgQR5tFwMm1bv7ULLKeQgsMQag
         rvmOigC121md7QQhXu6/rbTHXI6nOMJSg6TbT61+zuXaUmeplNXw2KBbh5yeF5W9Nznz
         Mcr3/8F2nZjn6cPqWRoGnXnAx/RZFQexfONzGmj8w3t5DesYF3WvpfiefHGtxRlWeeCj
         Poew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=16LnBHZF+zxStGOjP0fNe1Er1jdEh4ZT6MKJIYpDgbM=;
        b=ZgEDwT0LX0/yL8PWXeHgphY/YBw53WfuWbGpbfAUElHXU1YYTj1hNM6szp3Z3xSD+Y
         SAiK7iGXeUbiznYj9YP9lnWzwzhEjsLm728FhimLv7ltraSOAFTXtyxcnub1m3Z39vgz
         hCWlIAr1teimP8n9xfuL9NFnOxsL/SWRDx2aziGC78fs3Lv55bWqlGSLCVc1Sl4rs+bo
         Is5RcA6RNWX4f7IuOKeBFLsoDm3pOKRgcFsMZXeYcP5b5Vk3qcylnbta7tb1z6uwISj4
         dUs6Rj+QVAQqzryE7LfOEAukn891nBF3tjejTX6L6M3D4xbsTPen56g96vHr9lMPySg2
         w4YA==
X-Gm-Message-State: AOAM533bXdTsA2R9a2xg1skVW3nmB/yQ7cI+QC4aOmOplTeKTwxVdC/m
        y1YMNHkYdQXBlvD2CjKUbymoTxFFu10=
X-Google-Smtp-Source: ABdhPJyNYKB7RX82CTHeG9Kli17jdA9wtow9N9CThs5DLhqe34IX974VKj/CXklw0QSOUJsBpa/i7w==
X-Received: by 2002:a17:90a:21cf:: with SMTP id q73mr5490047pjc.230.1589981684299;
        Wed, 20 May 2020 06:34:44 -0700 (PDT)
Received: from [192.168.86.156] (cpe-75-85-219-51.dc.res.rr.com. [75.85.219.51])
        by smtp.gmail.com with ESMTPSA id k29sm2022520pgf.77.2020.05.20.06.34.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2020 06:34:43 -0700 (PDT)
Subject: Re: [PATCH v2] io_uring: reset -EBUSY error when io sq thread is
 waken up
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200520132435.10473-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <55cb5804-595a-6cbd-9669-7280722a6a07@kernel.dk>
Date:   Wed, 20 May 2020 07:34:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200520132435.10473-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/20/20 7:24 AM, Xiaoguang Wang wrote:
> In io_sq_thread(), currently if we get an -EBUSY error and go to sleep,
> we will won't clear it again, which will result in io_sq_thread() will
> never have a chance to submit sqes again. Below test program test.c
> can reveal this bug:
> 
> int main(int argc, char *argv[])
> {
>         struct io_uring ring;
>         int i, fd, ret;
>         struct io_uring_sqe *sqe;
>         struct io_uring_cqe *cqe;
>         struct iovec *iovecs;
>         void *buf;
>         struct io_uring_params p;
> 
>         if (argc < 2) {
>                 printf("%s: file\n", argv[0]);
>                 return 1;
>         }
> 
>         memset(&p, 0, sizeof(p));
>         p.flags = IORING_SETUP_SQPOLL;
>         ret = io_uring_queue_init_params(4, &ring, &p);
>         if (ret < 0) {
>                 fprintf(stderr, "queue_init: %s\n", strerror(-ret));
>                 return 1;
>         }
> 
>         fd = open(argv[1], O_RDONLY | O_DIRECT);
>         if (fd < 0) {
>                 perror("open");
>                 return 1;
>         }
> 
>         iovecs = calloc(10, sizeof(struct iovec));
>         for (i = 0; i < 10; i++) {
>                 if (posix_memalign(&buf, 4096, 4096))
>                         return 1;
>                 iovecs[i].iov_base = buf;
>                 iovecs[i].iov_len = 4096;
>         }
> 
>         ret = io_uring_register_files(&ring, &fd, 1);
>         if (ret < 0) {
>                 fprintf(stderr, "%s: register %d\n", __FUNCTION__, ret);
>                 return ret;
>         }
> 
>         for (i = 0; i < 10; i++) {
>                 sqe = io_uring_get_sqe(&ring);
>                 if (!sqe)
>                         break;
> 
>                 io_uring_prep_readv(sqe, 0, &iovecs[i], 1, 0);
>                 sqe->flags |= IOSQE_FIXED_FILE;
> 
>                 ret = io_uring_submit(&ring);
>                 sleep(1);
>                 printf("submit %d\n", i);
>         }
> 
>         for (i = 0; i < 10; i++) {
>                 io_uring_wait_cqe(&ring, &cqe);
>                 printf("receive: %d\n", i);
>                 if (cqe->res != 4096) {
>                         fprintf(stderr, "ret=%d, wanted 4096\n", cqe->res);
>                         ret = 1;
>                 }
>                 io_uring_cqe_seen(&ring, cqe);
>         }
> 
>         close(fd);
>         io_uring_queue_exit(&ring);
>         return 0;
> }
> sudo ./test testfile
> above command will hang on the tenth request, to fix this bug, when io
> sq_thread is waken up, we reset the variable 'ret' to be zero.

Applied, thanks.

-- 
Jens Axboe

