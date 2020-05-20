Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 967ED1DB484
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2020 15:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgETNDl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 May 2020 09:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbgETNDk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 May 2020 09:03:40 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F99C061A0E
        for <io-uring@vger.kernel.org>; Wed, 20 May 2020 06:03:40 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id s10so1416773pgm.0
        for <io-uring@vger.kernel.org>; Wed, 20 May 2020 06:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KJjB71+S2wqYHlTWvhzVwaMWVDKryzNWi+ZqbyjjHM0=;
        b=IWa/HOPQHb+9sjwSxScjuPEXTBQajMrg64/vy+8zYWWR1CA5aFrPAJ7uab2QOWzvUd
         lvGh+X2bOqyWNPnRUY2xaLq4m8p13ILWOrb3ZSV0c/3QVpD4GPYEEQROyUOwqYwuwv8f
         mPGs9k/SnbwjSGD7mgg8Jf9PkL/NlafTMsay6gP2VsqcpBv63qwfuz4I0SEJtvISkbXn
         3J0HYSU4RZEBisC/qf8sd1gOiUMm3LcvS0V9esAo+xZEG7ea8Jc7cGxwxanAFSImbZau
         4bzRC1aMPI7UNlkyYq+E6SWLCrrl29i/3I4RZhB6XsRumMIoPls2FD2SFmJkISo0u9Em
         3EVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KJjB71+S2wqYHlTWvhzVwaMWVDKryzNWi+ZqbyjjHM0=;
        b=cvlOaeejvDRrzgUUsyLDbFDYewUrbSNxI9yXKF1lo4H6kF8Wwu4jjdEw8qg+tqJRor
         MGaM9yBUdIDZbk05I8FJidFV7IVmialcz0cGJ4CisqeHCMPiQxK1f5qe43wr3nj1Pvya
         LbZbiw+qSn997+QZD4XVOZ53HIBNm5TWRFDOcnphIzoOAv5R5hjFkDz4+3hSxVrk68ag
         8yw8PdhWQ7pS2v4OUL/Lq0FTInFw0AnMLCLSFFKqWmOe8aiuYMwD+NAo9VqDEz+Pkfld
         S3H9jszHNHueXaJ1ULVX21a/8vrkjw+Mo7tBJFEVGgrCPLX9HFbDKav+JdhnPxqD8lN2
         JRog==
X-Gm-Message-State: AOAM5339RGvgOmmFChdpR7r5Do4aBch6p0yasqap2BZPyIgyMWvrbyoM
        UacfyaHxIZd7xyC0GWlrPUIG2w==
X-Google-Smtp-Source: ABdhPJwlOmVRiJzXZj/TYBJmeeW4t3g9UcJ0zhx6ncb/esOi5Bau0O+s8KaVLghX3rJKCDz+6Peq+g==
X-Received: by 2002:a62:3856:: with SMTP id f83mr4291159pfa.2.1589979819932;
        Wed, 20 May 2020 06:03:39 -0700 (PDT)
Received: from [192.168.86.156] (cpe-75-85-219-51.dc.res.rr.com. [75.85.219.51])
        by smtp.gmail.com with ESMTPSA id 7sm2212321pfc.203.2020.05.20.06.03.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2020 06:03:39 -0700 (PDT)
Subject: Re: [PATCH] io_uring: reset -EBUSY error when io sq thread is waken
 up
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200520044059.2308-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5d119755-01dc-e3e5-f15c-8002e26a8487@kernel.dk>
Date:   Wed, 20 May 2020 07:03:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200520044059.2308-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/19/20 10:40 PM, Xiaoguang Wang wrote:
> In io_sq_thread(), currently if we get an -EBUSY error, we will
> won't clear it again, which will result in io_sq_thread() will
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
> 
> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> ---
>  fs/io_uring.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 6e51140a5722..747de5cdf38a 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6045,6 +6045,8 @@ static int io_sq_thread(void *data)
>  				finish_wait(&ctx->sqo_wait, &wait);
>  
>  				ctx->rings->sq_flags &= ~IORING_SQ_NEED_WAKEUP;
> +				if (ret == -EBUSY)
> +					ret = 0;
>  				continue;
>  			}
>  			finish_wait(&ctx->sqo_wait, &wait);

How about just unconditionally clearing it? There's nothing we
need to preserve at this point, it should just get set to zero
regardless of the value.

-- 
Jens Axboe

