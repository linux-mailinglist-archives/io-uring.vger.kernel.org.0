Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8CBB1C3E6D
	for <lists+io-uring@lfdr.de>; Mon,  4 May 2020 17:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729276AbgEDPZ3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 May 2020 11:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729265AbgEDPZ3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 May 2020 11:25:29 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A51FC061A0E
        for <io-uring@vger.kernel.org>; Mon,  4 May 2020 08:25:29 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id m5so11605684ilj.10
        for <io-uring@vger.kernel.org>; Mon, 04 May 2020 08:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1D6ZTlzAS5HkUezZq1d69+4ZI9fkn6KXF485uBa6Wb4=;
        b=vpCJWCcIJezmGQ/p3n8j3sNcRcaIqyVKXOJ7w7db8gP/UBvO5jIYrQE8TmB+ZbrVJ4
         yt7WQB29zl923U4tE4aW2wXa+oJILUBPFeI+PZ3Cc1MMK7Hrlnuz4v2s21a9fgXRrL91
         lsKc/wBzNJp7NV7lUp+hbdmHzTeT8TWzRbf42I9CfncjpZvyAq13woPfTGZvPaXbLsFg
         1Ypd6SD1Dln2/KB30PQcMJWtse0ybZgNIlCf9gDpbLMc7hZs9AE5skkqHbav6t8gwO9R
         bS5DfvH6DuhDoo/iRSGy2SimyuYdqWnVYwuK1yMBI3XWM0rMWz/0GqBoj673fbXVr/ZC
         fY3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1D6ZTlzAS5HkUezZq1d69+4ZI9fkn6KXF485uBa6Wb4=;
        b=UzQgu0zbW4HPwe8+a6pUKT5FEX9Id1XY1q7L9AOqF7vgXyvVAgY6EnK4dkGR6PWsFN
         rQ45zzbRDWOty4+vu6EPeusDt/4n1CePFLcwOYAZk3mvV6sDQ3y2rUsPTAiRFJ4eQiKR
         yIFGUwKkh7QLG5NC1/qR4pNgMsQ2wZXkooCIVFFOYEa1jUuj7etmmz4jtqUfUsJz95F+
         Qx/p4fHJvBA7tZWkqIJ+72qVrzGwf0LS1f0AskP/TMvOhe4G1lgzyp/5/H1tUK42BhZz
         40K8iZ1jRqc2JL9H/5UI7dfpYbQco+c1FMd/NJCSA4hLTWLF0L21zGvfjZtJaZhQZzl7
         fUZQ==
X-Gm-Message-State: AGi0PubYyS9CfW2Cp3FF9o9RaPFymz+sLo57BfRQQ0UeJaN7lVEi8+C5
        GtY1YX6qbG2hnLT8cZ63PuY3tw==
X-Google-Smtp-Source: APiQypJvJRK186D9XWYvVBKoUDgGWOQugwpDAZB2tbbwlSi7OBFGdZTUwIibCv0T3/bRtM9QcnRvew==
X-Received: by 2002:a92:898c:: with SMTP id w12mr17264192ilk.139.1588605928210;
        Mon, 04 May 2020 08:25:28 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id l14sm4084365ioj.12.2020.05.04.08.25.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 08:25:27 -0700 (PDT)
Subject: Re: [PATCH][next] io_uring: Remove logically dead code in io_splice
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200504151912.GA22779@embeddedor>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b26c33c8-e636-edf6-3d43-7b3394850d7a@kernel.dk>
Date:   Mon, 4 May 2020 09:25:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200504151912.GA22779@embeddedor>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/4/20 9:19 AM, Gustavo A. R. Silva wrote:
> In case force_nonblock happens to be true, the function returns
> at:
> 
>  2779         if (force_nonblock)
>  2780                 return -EAGAIN;
> 
> before reaching this line of code. So, the null check on force_nonblock
> at 2785, is never actually being executed.
> 
> Addresses-Coverity-ID: 1492838 ("Logically dead code")
> Fixes: 2fb3e82284fc ("io_uring: punt splice async because of inode mutex")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  fs/io_uring.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index e5dfbbd2aa34..4b1efb062f7f 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2782,7 +2782,7 @@ static int io_splice(struct io_kiocb *req, bool force_nonblock)
>  	poff_in = (sp->off_in == -1) ? NULL : &sp->off_in;
>  	poff_out = (sp->off_out == -1) ? NULL : &sp->off_out;
>  	ret = do_splice(in, poff_in, out, poff_out, sp->len, flags);
> -	if (force_nonblock && ret == -EAGAIN)
> +	if (ret == -EAGAIN)
>  		return -EAGAIN;

This isn't right, it should just remove the two lines completely. But
also see:

https://lore.kernel.org/io-uring/529ea928-88a6-2cbe-ba8c-72b4c68cc7e8@kernel.dk/T/#u

-- 
Jens Axboe

