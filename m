Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 357D84BE2E9
	for <lists+io-uring@lfdr.de>; Mon, 21 Feb 2022 18:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241364AbiBUQdA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Feb 2022 11:33:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232001AbiBUQc7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Feb 2022 11:32:59 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404F31DA71
        for <io-uring@vger.kernel.org>; Mon, 21 Feb 2022 08:32:35 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id ay3so4484854plb.1
        for <io-uring@vger.kernel.org>; Mon, 21 Feb 2022 08:32:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9p9UW1ztCFicl4wOWM1XmJ1UIygmRbUNF3ZrGCMsB54=;
        b=RvGVcJIpDoAbqeo+wRu4a9HBSsA6WfZNvT54dKmZTS5kHfraG6Ovauc5/MVe0+IGko
         Rlw4Nl+GtgY/amZ2tKmNyePOAOQbSr/9YiOiXMiVIEgRd2Yxjx7X0Q0X4LqPI6SXgnVM
         GfIVkld6jJ07wMROX8rskmHCQOycRP6kLZjCnNv8iRV13lyyhq8Y9RBhNxlVBjxLmjk/
         FNz7DSxW8zns76NCZCUvmAaZwTi5wclz/Vj3/OHcjA158M78lU+HcRUue4j8ZO7JOs1q
         Fjt/6Uhl0JWDGN350Da0BFXj+v3EulC0rwRkIQUiSYM+THlyZgvNBJLCKgkRBsuh4PdJ
         bW+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9p9UW1ztCFicl4wOWM1XmJ1UIygmRbUNF3ZrGCMsB54=;
        b=i1Gc8S8o13mQEaHS23h6ujnSRx+ZlK/Dyfh4Z0UfDOyj7FPre2H0qJZRZ9ZWv5pNXr
         62gnTi7EP8J3vsXG1QTcIzXYLRJKMe7CsvUOth0rnHIIcbHyCQ089ZpTHjbfwU8zcZDW
         i9lS9mXR9WCTS1GtsmOKTCKsONbUZorAEu59zqvbB2wsmhXo99wKiG3WvfwBesenx0oY
         MCGSNT45Wgm7VAq5CJwddMR5LdkZAaZEGeZzh286jVAwi+tbRZMVeQWqyPLwTpgWcv0I
         gfLqlZIniGdPW7qt8MnhmGNqut7oOyBuFC9oSO6hC/xIy+4TIBQReDMVv3kAsqaRYk3S
         JSnA==
X-Gm-Message-State: AOAM533TfgjWLBmV+TxKdBNsiA+l/VEKCh1rq4dYXNw02H5CZkjrUvLw
        dQLKikJl0l+BJ29tGMehGdMS9w==
X-Google-Smtp-Source: ABdhPJwlTU+2aKKFbkkqE+oFyktV5D+caaKuDnY7RVSBS9lqdTYgr6jLTDq4s2e55uoX2ugaLsg5eg==
X-Received: by 2002:a17:902:ccc1:b0:14f:b686:e6ff with SMTP id z1-20020a170902ccc100b0014fb686e6ffmr5876342ple.45.1645461154640;
        Mon, 21 Feb 2022 08:32:34 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id o14sm8297884pfw.121.2022.02.21.08.32.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 08:32:34 -0800 (PST)
Message-ID: <50f407fd-d4e3-7c3f-5e8b-1f7fc366216d@kernel.dk>
Date:   Mon, 21 Feb 2022 09:32:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v2 2/4] io_uring: update kiocb->ki_pos at execution time
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kernel-team@fb.com
References: <20220221141649.624233-1-dylany@fb.com>
 <20220221141649.624233-3-dylany@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220221141649.624233-3-dylany@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/21/22 7:16 AM, Dylan Yudaken wrote:
> Update kiocb->ki_pos at execution time rather than in io_prep_rw().
> io_prep_rw() happens before the job is enqueued to a worker and so the
> offset might be read multiple times before being executed once.
> 
> Ensures that the file position in a set of _linked_ SQEs will be only
> obtained after earlier SQEs have completed, and so will include their
> incremented file position.
> 
> Signed-off-by: Dylan Yudaken <dylany@fb.com>
> ---
>  fs/io_uring.c | 25 +++++++++++++++++--------
>  1 file changed, 17 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 1f9b4466c269..50b93ff2ee12 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -3000,14 +3000,6 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  		req->flags |= io_file_get_flags(file) << REQ_F_SUPPORT_NOWAIT_BIT;
>  
>  	kiocb->ki_pos = READ_ONCE(sqe->off);
> -	if (kiocb->ki_pos == -1) {
> -		if (!(file->f_mode & FMODE_STREAM)) {
> -			req->flags |= REQ_F_CUR_POS;
> -			kiocb->ki_pos = file->f_pos;
> -		} else {
> -			kiocb->ki_pos = 0;
> -		}
> -	}
>  	kiocb->ki_flags = iocb_flags(file);
>  	ret = kiocb_set_rw_flags(kiocb, READ_ONCE(sqe->rw_flags));
>  	if (unlikely(ret))
> @@ -3074,6 +3066,19 @@ static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
>  	}
>  }
>  
> +static inline void
> +io_kiocb_update_pos(struct io_kiocb *req, struct kiocb *kiocb)
> +{
> +	if (kiocb->ki_pos == -1) {
> +		if (!(req->file->f_mode & FMODE_STREAM)) {
> +			req->flags |= REQ_F_CUR_POS;
> +			kiocb->ki_pos = req->file->f_pos;
> +		} else {
> +			kiocb->ki_pos = 0;
> +		}
> +	}
> +}


static inline void io_kiocb_update_pos(struct io_kiocb *req,
				       struct kiocb *kiocb)
{
}

Can we just drop the kiocb argument? It'll always be req->rw.kiocb.
Should generate the same code if you do:

static inline void io_kiocb_update_pos(struct io_kiocb *req)
{
	struct kiocb *kiocb = &req->rw.kiocb;

	...
}

Apart from that minor thing, looks good to me.

-- 
Jens Axboe

