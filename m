Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4C5A1C54F7
	for <lists+io-uring@lfdr.de>; Tue,  5 May 2020 14:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbgEEMAv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 May 2020 08:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728180AbgEEMAu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 May 2020 08:00:50 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF37C061A0F;
        Tue,  5 May 2020 05:00:50 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id g13so2381601wrb.8;
        Tue, 05 May 2020 05:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tF3WbB2pv4eRwvX7f/qk4r+/L1hFqCVu/L56E4P64sY=;
        b=TgBIuwg2scO0J8QIMsG2fUNN4bv+/vDjSCNGd1ukU1fzhIYqpyxpTNF6XCAVjbNxRU
         CGo2AM3OfLY5F9jiD0Ha10k+Pne1TWW1mnnpV/PtIjh5BueAdNV031SL3vKCM9jPqwBb
         cREP+tgbdGATYjsqizfreaKB3k22UP/6M28opYUi0hNc/oW4a3wsaM3vq6qwUcTm/dtV
         kp9mKz6FVQuymsvWoOXgc9Xc7S4gWkIjvuETGlwOV7+zAbPnye3NhoGcRtxL6EI/8nOl
         6qIonOM2ChIVf5UeAzumwJLEyTZ54snD8rFKyeZSRmu+FTpd6EbO7UmrduZcqxZMAvbQ
         PlVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=tF3WbB2pv4eRwvX7f/qk4r+/L1hFqCVu/L56E4P64sY=;
        b=XtY2pJ0FbsU1kJYOS3lo1UeS6kitvGkPy+9qH6jLLntCdpOOAsqveER1pisjgoStfP
         GIT2QdWf34heewC/FtQC4b+PQIYhcjbo+SnoL0zfnELGCbYWbJE3/ugapXGndSK6n4Zn
         2aANud86xHQl7m/6Mz9kF8hg+lGXG8CqPz4eM8oQt/6jNbZ/Ln0OFtD7uctaeSQb5Tei
         sItItzQ9tKxKgyzzf5E8pRetZwhDckU6VcS6gP++7WRUrwLJNz7xBavFS25BLIbUUonj
         PmH/ogk9yzjtRV03M/pdq20yCTi8b0CWUZb5SEppWJP6DjU0tohY+MHo/XDjIpPeADin
         1hXQ==
X-Gm-Message-State: AGi0Pua5IOpvoE+wb8flUFuiUJgF+72YiperFrIwOkE36QDBoZ8RKfMS
        uj1PInZQSoPgpivIXjTVC91aS3HDpys=
X-Google-Smtp-Source: APiQypLSkPprqka8DbMhUNfoxV6nS5KtvoWUJKlJnVHmtkez8kHXJLy9dAs/Nb8wZyoBk34tWzOCLg==
X-Received: by 2002:a5d:6742:: with SMTP id l2mr3115009wrw.138.1588680048537;
        Tue, 05 May 2020 05:00:48 -0700 (PDT)
Received: from [192.168.43.168] ([109.126.133.135])
        by smtp.gmail.com with ESMTPSA id u2sm3477113wrd.40.2020.05.05.05.00.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2020 05:00:48 -0700 (PDT)
To:     Colin King <colin.king@canonical.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200505093343.41869-1-colin.king@canonical.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH]i[next] io_uring: remove redundant check on force_nonblock
Message-ID: <250ed09d-ee20-3903-b766-97ef12011de6@gmail.com>
Date:   Tue, 5 May 2020 14:59:41 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200505093343.41869-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 05/05/2020 12:33, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The check on force_nonblock is redundant as this is performed
> several statements earlier and also returns with -EAGAIN. Remove
> the redundant check.

It's kind of scary that such simple transformation is repeatedly done wrongly.
In short, because force_nonblock is always false there, the equivalent
transformation would be to delete it altogether.

Kudos to Jens for his thoroughness. See
https://lore.kernel.org/io-uring/529ea928-88a6-2cbe-ba8c-72b4c68cc7e8@kernel.dk/T/#u

> 
> Addresses-Coverity: ("Logicall dead code")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
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
>  
>  	io_put_file(req, in, (sp->flags & SPLICE_F_FD_IN_FIXED));
> 

-- 
Pavel Begunkov
