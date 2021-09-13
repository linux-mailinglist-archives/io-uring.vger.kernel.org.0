Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F76740946D
	for <lists+io-uring@lfdr.de>; Mon, 13 Sep 2021 16:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345144AbhIMObN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Sep 2021 10:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346866AbhIMO3x (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Sep 2021 10:29:53 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1104C0613AB
        for <io-uring@vger.kernel.org>; Mon, 13 Sep 2021 06:28:13 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id a15so12039365iot.2
        for <io-uring@vger.kernel.org>; Mon, 13 Sep 2021 06:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3vN9Wyfdy3B+3jKSNNbQuDbmy9ISudB6NcF4MytTblk=;
        b=jpzDoGuP/wSXHe0WqEmzabSx+dvjhnyfFogYYYQGZH68NdgavhywOFPo2DLzfABvCC
         /5FdzQWSrf7JrHRTEbfOrguym7OQZSOjDpTT2WDVBMSQkPqlxKm4DBNqo+lNWu/f+q5K
         o6RoAmj0iMNOlNWIvktciFnbS93hEgBE6GTkYZpxPTfdJbRN5K1cwfKjEIH1FkhnuatC
         mBZlqLEmfZvx0KLxzjcWUM3ZgvReF3iueVkrC38BcPVTlUS58WHmq/Nwd9+lV/IXQPmi
         fYDEJXLbGFoMeY3smdmCHxFmzS1sBHjpSUFSJxA2WjHkjxrz9uiuHDtLR3zuMay8ffag
         PHzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3vN9Wyfdy3B+3jKSNNbQuDbmy9ISudB6NcF4MytTblk=;
        b=ComCmahm6yJMrDhiAlRQThdtq0reT9Y7qmujjkcIp/tka+OFJ5pmpCrfM6IG8yfDjy
         jIRrvUMOP/KxV5U5ULWY1zgLI83uHSIcIKhjodjMMus7vDwAmGSGFhzSHM2NPGq34zNr
         nhEDWz/gpW6DugU+5CqWO74skXZjtSkl3QjgFa82dq9MXNBWqlY9/JL476HovpwQi0tO
         7eALYPqBHF0U22szfTPtisZRwurKEflvu26sbMd6wNwkrurIvHJhuJVLHXix0Iy0XtgA
         2gtkwoIg0H/6W5OmW+OvWN0q3BaBMgRgbDW74vko/kPNyZ2MflSiA68X6TWeSGfbLBrg
         /WMw==
X-Gm-Message-State: AOAM532yQBC3Ib4gHcQXJC1Bmrm7jGt4rgcT4AqNpAdbJa6jdUNQ6CGO
        jmJOq7z+NwQacWhlLhKZVd1wog==
X-Google-Smtp-Source: ABdhPJwlpCCBm0jBOd/op8tvfj2w7pmggym/wUZlWOPKQS65wEUgcW89MfQfiXFqMNCFeZqsH+q/pQ==
X-Received: by 2002:a5e:a913:: with SMTP id c19mr8795732iod.31.1631539693066;
        Mon, 13 Sep 2021 06:28:13 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id n2sm4701205ile.86.2021.09.13.06.28.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 06:28:12 -0700 (PDT)
Subject: Re: [PATCH v2] io-wq: expose IO_WQ_ACCT_* enumeration items to UAPI
To:     Eugene Syromiatnikov <esyr@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Dmitry V. Levin" <ldv@strace.io>, linux-api@vger.kernel.org
References: <20210913104101.GA29616@asgard.redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <872209f5-d11c-1b80-6146-5646206e22cb@kernel.dk>
Date:   Mon, 13 Sep 2021 07:28:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210913104101.GA29616@asgard.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/13/21 4:41 AM, Eugene Syromiatnikov wrote:
> These are used to index elements in the argument
> of IORING_REGISTER_IOWQ_MAX_WORKERS io_uring_register command,
> so they are to be exposed in UAPI.
> 
> Complements: 2e480058ddc21ec5 ("io-wq: provide a way to limit max number of workers")
> Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
> ---
> v2:
>  - IO_WQ_ACCT_NR is no longer exposed directly in UAPI, per Jens Axboe's
>    suggestion.
> 
> v1: https://lore.kernel.org/lkml/20210912122411.GA27679@asgard.redhat.com/
> ---
>  fs/io-wq.c                    | 5 ++---
>  include/uapi/linux/io_uring.h | 8 ++++++++
>  2 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index 6c55362..eb5162d 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -14,6 +14,7 @@
>  #include <linux/rculist_nulls.h>
>  #include <linux/cpu.h>
>  #include <linux/tracehook.h>
> +#include <uapi/linux/io_uring.h>
>  
>  #include "io-wq.h"
>  
> @@ -78,9 +79,7 @@ struct io_wqe_acct {
>  };
>  
>  enum {
> -	IO_WQ_ACCT_BOUND,
> -	IO_WQ_ACCT_UNBOUND,
> -	IO_WQ_ACCT_NR,
> +	IO_WQ_ACCT_NR = __IO_WQ_ACCT_MAX
>  };
>  
>  /*
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 59ef351..dae1841 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -324,6 +324,14 @@ enum {
>  	IORING_REGISTER_LAST
>  };
>  
> +/* io-wq worker limit categories */
> +enum {
> +	IO_WQ_ACCT_BOUND,
> +	IO_WQ_ACCT_UNBOUND,
> +
> +	__IO_WQ_ACCT_MAX /* Non-UAPI */
> +};

This is really the same thing as before, just the names have changed.
What I suggested was keeping the enum in io_uring, then just adding

enum {
	IO_WQ_BOUND,
	IO_WQ_UNBOUND,
};

to uapi header. The ACCT stuff is io-wq specific too, that kind of naming
shouldn't be propagated to userspace.

A BUILD_BUG_ON() could be added for them being different, but honestly
I don't think that's worth it.

-- 
Jens Axboe

