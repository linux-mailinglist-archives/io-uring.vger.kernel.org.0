Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30A132195A1
	for <lists+io-uring@lfdr.de>; Thu,  9 Jul 2020 03:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgGIBaa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jul 2020 21:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgGIBaa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jul 2020 21:30:30 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 464EFC061A0B
        for <io-uring@vger.kernel.org>; Wed,  8 Jul 2020 18:30:30 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id k5so129344plk.13
        for <io-uring@vger.kernel.org>; Wed, 08 Jul 2020 18:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s2VLmt5UILI0YSnU9jcy5GC7UnpfeV/yUhE320FmhFU=;
        b=SEMAglTFtYxo8xWZciMe5hUI7bgmaigJZJ5W9CGm/0qrCPIXHHlzekDA4uxlzk+6CW
         pBC5WT/Lfc6S/KQlOjSb3326hG0roC9/7Qyq/39QQwtAEmsxjyLhY4Y8wZMy4qLDPgCB
         Pex1UtiBPCAs+nYQLuxcTaUmgInX6Qc5cN0rwibLH+Vs5UhwKU6fPjWF9VCwxDUcnXLI
         pv3DJYHdrEm2uKIekIl/IzfMSlogZA3bBt/n/hMdMS83/fp6zsGViBEp1xpg0idGNH3N
         gmPnmuck+ZxEHPydVwickpwOfuNEn6AdOf74+xTtpMNR/IkJphwkode8KjUD2D8nRSqK
         /zZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s2VLmt5UILI0YSnU9jcy5GC7UnpfeV/yUhE320FmhFU=;
        b=YqdDOkVAnGv3AzAFBpptlQmbV90H0fegHZ2skju1/cNDtxtYbhX3I5Q6zfqFolWaRT
         NwKgGXUsQsuk1OfX2ZdsLv2ndML9dykfyZoIbjNnmLiT6Irp7tkEUtdAqf3yBr/PXDc9
         USKTIUGsGXBq4lYIKGIsAh4+DrdCon0OTq6hkuJVW74JQ9uWHX2ScZqiK68hwGXH3SwF
         SLk3AEVwk+yEZBsSen+T04sirhN4zwqYRuBijCY/8VFW+BXzBIFmBTV0RBvBFsoQrW74
         XQoMWGW1ih3/fbdT0uDKNeITtK34YieaMDMk2o8gnIweZ4U+V2Bt+t9rNnO3HZrVdIcY
         zGaw==
X-Gm-Message-State: AOAM531IndgC3nznRRQGzvnP+4B/HetAVxf2xSQ7Ugjh6Yn2LAuldX3C
        IF0AqXqZxMKteSeBBt9s3YQIw55rbWnpSA==
X-Google-Smtp-Source: ABdhPJz8+ol8wENnuzitPX17A2C4OXHndW9CBGu6Ef1hr7gbcuJFxFja4N0+0FCKg318M6tDtIKpsw==
X-Received: by 2002:a17:902:8204:: with SMTP id x4mr47333685pln.16.1594258229530;
        Wed, 08 Jul 2020 18:30:29 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 202sm841989pfw.84.2020.07.08.18.30.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 18:30:28 -0700 (PDT)
Subject: Re: [PATCH v2] io_uring: export cq overflow status to userspace
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200709011529.13605-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a00f6b31-5fbe-12e6-855d-c8217809b342@kernel.dk>
Date:   Wed, 8 Jul 2020 19:30:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200709011529.13605-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/8/20 7:15 PM, Xiaoguang Wang wrote:
> For those applications which are not willing to use io_uring_enter()
> to reap and handle cqes, they may completely rely on liburing's
> io_uring_peek_cqe(), but if cq ring has overflowed, currently because
> io_uring_peek_cqe() is not aware of this overflow, it won't enter
> kernel to flush cqes, below test program can reveal this bug:
> 
> static void test_cq_overflow(struct io_uring *ring)
> {
>         struct io_uring_cqe *cqe;
>         struct io_uring_sqe *sqe;
>         int issued = 0;
>         int ret = 0;
> 
>         do {
>                 sqe = io_uring_get_sqe(ring);
>                 if (!sqe) {
>                         fprintf(stderr, "get sqe failed\n");
>                         break;;
>                 }
>                 ret = io_uring_submit(ring);
>                 if (ret <= 0) {
>                         if (ret != -EBUSY)
>                                 fprintf(stderr, "sqe submit failed: %d\n", ret);
>                         break;
>                 }
>                 issued++;
>         } while (ret > 0);
>         assert(ret == -EBUSY);
> 
>         printf("issued requests: %d\n", issued);
> 
>         while (issued) {
>                 ret = io_uring_peek_cqe(ring, &cqe);
>                 if (ret) {
>                         if (ret != -EAGAIN) {
>                                 fprintf(stderr, "peek completion failed: %s\n",
>                                         strerror(ret));
>                                 break;
>                         }
>                         printf("left requets: %d\n", issued);
>                         continue;
>                 }
>                 io_uring_cqe_seen(ring, cqe);
>                 issued--;
>                 printf("left requets: %d\n", issued);
>         }
> }
> 
> int main(int argc, char *argv[])
> {
>         int ret;
>         struct io_uring ring;
> 
>         ret = io_uring_queue_init(16, &ring, 0);
>         if (ret) {
>                 fprintf(stderr, "ring setup failed: %d\n", ret);
>                 return 1;
>         }
> 
>         test_cq_overflow(&ring);
>         return 0;
> }
> 
> To fix this issue, export cq overflow status to userspace by adding new
> IORING_SQ_CQ_OVERFLOW flag, then helper functions() in liburing, such as
> io_uring_peek_cqe, can be aware of this cq overflow and do flush accordingly.

Applied, thanks.

-- 
Jens Axboe

