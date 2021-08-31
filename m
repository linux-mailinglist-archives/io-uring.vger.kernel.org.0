Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D950C3FC56D
	for <lists+io-uring@lfdr.de>; Tue, 31 Aug 2021 12:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234666AbhHaKIt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Aug 2021 06:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234016AbhHaKIs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Aug 2021 06:08:48 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1645C061575
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 03:07:53 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id c129-20020a1c35870000b02902e6b6135279so2119787wma.0
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 03:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=uGGr1DgQ80niTsgXGy3FejR0masKg7fMTkj440o4z44=;
        b=b8c1hOTNfLF4yJhQYKnfwS21NOhs6Fv4ilASG0LzoK6yHXSfPt+/jBDih6E13gTmaU
         0HZhXxbV+rPepDI+ME9HiIo1mhHJL/Cc2RS9T+n1Eet0QTNfuLjC4tfItID3Ube69sld
         /SV8TGvaEzAeFWCogl+3TIgEv2ezbLGvBUmIO5uxFKt8ni/zSHbwhIlQ4yDzvMThi+9L
         1wzwgNvKi922mpyxqsSOO0pbRQzVIMxsDk7CbNY2jY+T+Ihoz1H1mUbzEETHi30LTKBM
         m+3+DLLi88Rnpoq9Oqh64Q7dEG/gMP1bTAG7Jgd7AlivJo3e+OdhTc3Pv0pehKpY0W5f
         PgPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uGGr1DgQ80niTsgXGy3FejR0masKg7fMTkj440o4z44=;
        b=jeuVhEsvZe5gj01R6XawruICAIaspT8lMt3X0aGpYQKJ/NG0Sjdi1GCeWF2U9PKgJJ
         58uEhBbReiA+ph+2lxTpmiI2Fxi+YnkOHyFJqmVBUcQ50KTU/gsnXmTBR61DpQ8A/B94
         fHsxbZ+GNHjFbcRf9aQp6HjZq4Blr7dUZU43rme9xciBbPU0s8osVK+Zif0rvDhIKjbF
         RvsmvSv/bTEB2NlrSubAvlezB12Yu1X+KcP+3lDNfvozvc9PF8WufkASv9quP4A0TuMe
         lEo4rKcYEgU+PrPww3dEUDli8uQ6UUQafANivDDfTbEC6RxfTK4u+sSXeZPqJZDa8cam
         LZcg==
X-Gm-Message-State: AOAM532vrU2/JB0Wt1swAAj6+uSfZ9v5Rz/lybv5JcWWTqkBlXnop6l0
        om0AHwoNVjBz9h5NgN8hPusCCbwFbEM=
X-Google-Smtp-Source: ABdhPJyzRKjDqQMC59x9s7xutevGMdTIPp8VanAE9zqXbfdnihlkUpclv5aXX+L60+v+u4GNhLSCxQ==
X-Received: by 2002:a1c:2307:: with SMTP id j7mr3370614wmj.189.1630404472062;
        Tue, 31 Aug 2021 03:07:52 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.138])
        by smtp.gmail.com with ESMTPSA id u2sm2017820wmj.29.2021.08.31.03.07.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 03:07:51 -0700 (PDT)
Subject: Re: [PATCH] io_uring: retry in case of short read on block device
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
References: <20210821150751.1290434-1-ming.lei@redhat.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <0aeb5234-92a6-f21e-e502-9e41414087f6@gmail.com>
Date:   Tue, 31 Aug 2021 11:07:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210821150751.1290434-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/21/21 4:07 PM, Ming Lei wrote:
> In case of buffered reading from block device, when short read happens,
> we should retry to read more, otherwise the IO will be completed
> partially, for example, the following fio expects to read 2MB, but it
> can only read 1M or less bytes:
> 
>     fio --name=onessd --filename=/dev/nvme0n1 --filesize=2M \
> 	--rw=randread --bs=2M --direct=0 --overwrite=0 --numjobs=1 \
> 	--iodepth=1 --time_based=0 --runtime=2 --ioengine=io_uring \
> 	--registerfiles --fixedbufs --gtod_reduce=1 --group_reporting
> 
> Fix the issue by allowing short read retry for block device, which sets
> FMODE_BUF_RASYNC really.

Should note that overhead on touching inode shouldn't be of concern at
this point, so all looks good

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>


> Fixes: 9a173346bd9e ("io_uring: fix short read retries for non-reg files")
> Cc: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  fs/io_uring.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index bf548af0426c..bbcd1a9e75e5 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -3268,6 +3268,12 @@ static inline int io_iter_do_read(struct io_kiocb *req, struct iov_iter *iter)
>  		return -EINVAL;
>  }
>  
> +static bool need_read_all(struct io_kiocb *req)
> +{
> +	return req->flags & REQ_F_ISREG ||
> +		S_ISBLK(file_inode(req->file)->i_mode);
> +}
> +
>  static int io_read(struct io_kiocb *req, unsigned int issue_flags)
>  {
>  	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
> @@ -3322,7 +3328,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
>  	} else if (ret == -EIOCBQUEUED) {
>  		goto out_free;
>  	} else if (ret <= 0 || ret == io_size || !force_nonblock ||
> -		   (req->flags & REQ_F_NOWAIT) || !(req->flags & REQ_F_ISREG)) {
> +		   (req->flags & REQ_F_NOWAIT) || !need_read_all(req)) {
>  		/* read all, failed, already did sync or don't want to retry */
>  		goto done;
>  	}
> 

-- 
Pavel Begunkov
