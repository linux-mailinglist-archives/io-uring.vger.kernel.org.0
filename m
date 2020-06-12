Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64A971F7A8C
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2020 17:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbgFLPQq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Jun 2020 11:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgFLPQp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Jun 2020 11:16:45 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97C36C03E96F
        for <io-uring@vger.kernel.org>; Fri, 12 Jun 2020 08:16:44 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id y17so3861323plb.8
        for <io-uring@vger.kernel.org>; Fri, 12 Jun 2020 08:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XkUMO20tZtFjfz5wv50vWP08nsmaeBFv5e51CYHkTzs=;
        b=y7lG7A7zq7JSR/iurJc+NYm0f5cWB7spRTM41fh1uRVXyeR/cHMrcqGDrELewuvR1H
         TpPUN+EKRxfJy/KlEpqreJ2db4edwsR5sFTdx0Jkhw0gJsH6qkHVgMvqZK/veJHXGeEu
         37akJgZUvn7jeVyfAdyrxH6QhfECwTSgD1dx1mKFSQigBKCuaL81FvlwPV2v5BdnNr2Y
         U+yDnVq3fIuj3dCuY1ZNzASmARXA5tSLGiey7zTk5EjDLzmK12CbZXxI64aYe1ErGRye
         /cx9tXtBRCUBNt4vpXdWBkq8gkOX+WmtRQBWF0jpyDvr039cz+dskAygyY/rUBAGjaHr
         u8mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XkUMO20tZtFjfz5wv50vWP08nsmaeBFv5e51CYHkTzs=;
        b=JLAy8SGR78sDKTHpMQVLH+hv97G8ORf28WcRxUlKM3wg45tMhUW7eUyi3Js7cqx5SW
         S9+1kdjGJpfGT5z6H9dTaLjCQe3SfVDPgHpcat61uAcMXseHKQZD4ASoKrx6f+5a6ti2
         ng3SGW1iCLB2GQ1zHsvRGtYzmce3gdipKRSWSOI+XX8bpTk4gdYV49HrXjRR9aFmkjia
         B2yBnuWtzc42Io85ndgdTqDFPvqXzYxoQVkT6dAWGXEk6yUtlZ187/15p+dI7JVfQPvj
         pIv9r4cshJBeuCsfM6bSkJYR28P6NJraB+3Z/b01/pXpd1SQgdMLGXQnmvWhSrR32Hde
         trTA==
X-Gm-Message-State: AOAM5328iYfEyuBO4G8WZcEnKf41lmsiet3aRRMbbsS00GPqNCJmTW9H
        o5O47lyNvA/fizIK5esjGbST7ZbiNJt4Vw==
X-Google-Smtp-Source: ABdhPJzjO7JCYjwR7AndRiaEVUELmLq8od9f+mRXtlQG/FUHQqUC1d9gbyzgvNNAHaZ5AIP9MhwE+Q==
X-Received: by 2002:a17:902:680d:: with SMTP id h13mr3002600plk.241.1591975003914;
        Fri, 12 Jun 2020 08:16:43 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id z14sm6533129pfj.64.2020.06.12.08.16.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2020 08:16:43 -0700 (PDT)
Subject: Re: [RFC 2/2] io_uring: report pinned memory usage
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Cc:     io-uring@vger.kernel.org
References: <1591928617-19924-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1591928617-19924-3-git-send-email-bijan.mottahedeh@oracle.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b08c9ee0-5127-a810-de01-ebac4d6de1ee@kernel.dk>
Date:   Fri, 12 Jun 2020 09:16:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1591928617-19924-3-git-send-email-bijan.mottahedeh@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/11/20 8:23 PM, Bijan Mottahedeh wrote:
> Long term, it makes sense to separate reporting and enforcing of pinned
> memory usage.
> 
> Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
> 
> It is useful to view
> ---
>  fs/io_uring.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 4248726..cf3acaa 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -7080,6 +7080,8 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
>  static void io_unaccount_mem(struct user_struct *user, unsigned long nr_pages)
>  {
>  	atomic_long_sub(nr_pages, &user->locked_vm);
> +	if (current->mm)
> +		atomic_long_sub(nr_pages, &current->mm->pinned_vm);
>  }
>  
>  static int io_account_mem(struct user_struct *user, unsigned long nr_pages)
> @@ -7096,6 +7098,8 @@ static int io_account_mem(struct user_struct *user, unsigned long nr_pages)
>  			return -ENOMEM;
>  	} while (atomic_long_cmpxchg(&user->locked_vm, cur_pages,
>  					new_pages) != cur_pages);
> +	if (current->mm)
> +		atomic_long_add(nr_pages, &current->mm->pinned_vm);
>  
>  	return 0;
>  }

current->mm should always be valid for these, so I think you can skip the
checking of that and just make it unconditional.

-- 
Jens Axboe

