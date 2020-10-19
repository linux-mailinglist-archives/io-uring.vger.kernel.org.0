Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0364292F2B
	for <lists+io-uring@lfdr.de>; Mon, 19 Oct 2020 22:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729419AbgJSUI3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Oct 2020 16:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727068AbgJSUI2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Oct 2020 16:08:28 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D7F0C0613CE
        for <io-uring@vger.kernel.org>; Mon, 19 Oct 2020 13:08:28 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id b23so637122pgb.3
        for <io-uring@vger.kernel.org>; Mon, 19 Oct 2020 13:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=2wZPpu0aGlbtm+XgcSDnaVdeFp3eHUKf8pNZgHdaOdk=;
        b=OI15J4ab6RHRWJiTz3XKYLXWlsy+gkwCc+AsVHZzFM0W6jh2qCINm4vl2uKHYGtyhp
         qDEnxw0NoRWnnLbjTGVk3LyYiwRDBCevKv+Iae0Itl0hPm2ogwpk7VBw0Cmx9czP4GaT
         heVLuGATmyAOfsicvX0Kp0uVbSegZf1l5noZmSCGFfy6VCr6lsgizlVjYmVPgM8KygNL
         E8e8Dh9MtTeMYRx5NMGQZ2JE91oU78dzF0bWGzi7hrEMNHG8nO9gU/jRFmctQR/eQ9Lr
         ABVB2grPvuqZ1nZIEdZZ25XPuFD+W1k6urFZlxS8h/m7uORKPCK3Yz49LtmCO340btPB
         pvrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2wZPpu0aGlbtm+XgcSDnaVdeFp3eHUKf8pNZgHdaOdk=;
        b=SrWIVS6Za/giL1Oco8UZiqrgCGBZUKHbcpJHO4SYhf9HKWcP8Dza1s37/NyBYYnWPY
         f3/euDp6o54Pujly3MnW0Sv0PVYiB3QPXug7YYBc4Hi01TdaCX471hk8RMh8/btfhwgQ
         fGF+vQZgm0Y9d8CFNKMd/n+zQmN25Xb6aGiC6C0iE6QkR78MopAdY0UsPix7aDox9i7J
         kZH4aWTVPNKQ/0pKqNW7bfOePNYY7DXVLM2/uQuXQu1Fw6jfr0sT9BCHVP/H9UHEtDFN
         zc+EFEuv2rMhhZOpksvCtgzoJ7BAc6QO38Pw59CRUtuEvYIDYJ9DHTkx3d0IDQ6HKVAq
         1F9g==
X-Gm-Message-State: AOAM533xXSh0vRaW9Jje9CESOFWwRpqQXUTayLJFALk5vqbRCe0q2Alf
        HNHmvc2DXnPKLE2joZUWYswUdMWQSJxqmglt
X-Google-Smtp-Source: ABdhPJxG1Nma6In5zCJdUtRXEmMiAap/Nbplaulz8bHyJUdGkW2yPYLFkLO8zjHwxi3V43mBoGfAmQ==
X-Received: by 2002:a63:c00c:: with SMTP id h12mr1155324pgg.237.1603138107183;
        Mon, 19 Oct 2020 13:08:27 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id q16sm597265pfj.117.2020.10.19.13.08.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2020 13:08:26 -0700 (PDT)
Subject: Re: [PATCH for-5.10] io_uring: remove req cancel in ->flush()
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <21aca47e03c82a06e4ea1140b328a86d04d1f422.1603122023.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ca4c9b80-78de-eae2-55cf-8d7c3f09ca80@kernel.dk>
Date:   Mon, 19 Oct 2020 14:08:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <21aca47e03c82a06e4ea1140b328a86d04d1f422.1603122023.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/19/20 9:45 AM, Pavel Begunkov wrote:
> Every close(io_uring) causes cancellation of all inflight requests
> carrying ->files. That's not nice but was neccessary up until recently.
> Now task->files removal is handled in the core code, so that part of
> flush can be removed.

It does change the behavior, but I'd wager that's safe. One minor
comment:

> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 95d2bb7069c6..6536e24eb44e 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -8748,16 +8748,12 @@ void __io_uring_task_cancel(void)
>  
>  static int io_uring_flush(struct file *file, void *data)
>  {
> -	struct io_ring_ctx *ctx = file->private_data;
> +	bool exiting = !data;
>  
> -	/*
> -	 * If the task is going away, cancel work it may have pending
> -	 */
>  	if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
> -		data = NULL;
> +		exiting = true;
>  
> -	io_uring_cancel_task_requests(ctx, data);
> -	io_uring_attempt_task_drop(file, !data);
> +	io_uring_attempt_task_drop(file, exiting);
>  	return 0;
>  }

Why not just keep the !data for task_drop? Would make the diff take
away just the hunk we're interested in. Even adding a comment would be
better, imho.

-- 
Jens Axboe

