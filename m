Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7EDD1A6380
	for <lists+io-uring@lfdr.de>; Mon, 13 Apr 2020 09:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729194AbgDMHVc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Apr 2020 03:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:59310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727654AbgDMHVb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Apr 2020 03:21:31 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC28C008651
        for <io-uring@vger.kernel.org>; Mon, 13 Apr 2020 00:21:29 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id f8so5818387lfe.12
        for <io-uring@vger.kernel.org>; Mon, 13 Apr 2020 00:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=vJLyzwquU4bH8B/1Yc1je5myAVPWwM9NWSS7391JUgI=;
        b=T9qENQ8YL1rNhPvIKM0MpOltDLykpyC1He5Gb60QAE9LdFj8eG7M3Ue+n3rJo1hI//
         UlJlIJkUKeaWgGaE18ldQFM6KHXovD3TC5wOOkF3HntjcUJVgXqnF9H1ESLrT9kKwvU4
         65J1wojS+DysIgm11tkH7FW0VF4+AoJwHnsokMWYhQjHRVGOnlUd7F7N6BDAKgSHPxDA
         0Zkt55aFGVtnNcHjSE2sPT8+OZhw2YhhhbHGuE792BIrr/jEoMotJRQMnqkHywka9zeK
         3iuW3ADgeWEUEH+/eN24J4q6ob0Vb064luO0/M0DoLp91HmaCOSDz5dYriqUe1s3DGzq
         g7qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vJLyzwquU4bH8B/1Yc1je5myAVPWwM9NWSS7391JUgI=;
        b=JjShvmkoFASrTqmcffcJfcB3xp6gM/qktxd6KpL3GwTJ0h8WpJtbK8lGB7wxw46PtZ
         ZXAITNtphLwfWN/LZC3UfMmgw7yXNKTrCGF9roGuELyxqJ9kNQJfNaaRCRe+Nrxao6Uq
         q9/pXP1bcYi77UUWTj8nJCi0ghNyJfVI7+RRwIybMo87/ed8I38amMSlnv7Km5e9v6Ge
         99DNIF/p0RkxozR6Nwcaff35buVWz0tBAQjTy8V/iq5pzv1c1xsDEHMzARvRoLC4AfvW
         nA+mpaBg9Pn63uJz5eMsqGdR2D3lPLFuPpMHZsN0bVD6uSmrHgDKnA/eP/e51PfR3TcR
         eL0A==
X-Gm-Message-State: AGi0Pua62TAeAuwm6NGqv938roPtXwjTjZAMJCTbA4+QUQ0ShuNpxEj6
        ZwfUscQnXXYLb0Y7BKoLDemsGtff
X-Google-Smtp-Source: APiQypLL7S2SqWsTI+Qn/HQ1O0hci163C8rVKkWrH5lnb5DT3prZaKnW3KysEXXnLFXTB/FUvN1yGw==
X-Received: by 2002:ac2:4d12:: with SMTP id r18mr9578169lfi.181.1586762488035;
        Mon, 13 Apr 2020 00:21:28 -0700 (PDT)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id v4sm311500ljj.104.2020.04.13.00.21.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Apr 2020 00:21:27 -0700 (PDT)
Subject: Re: [PATCH] io_uring: correct O_NONBLOCK check for splice punt
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <947c5026-cfa3-5a48-701c-28e46ac061bf@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <5b4abfcc-771e-3b32-9b5b-23d7a68de322@gmail.com>
Date:   Mon, 13 Apr 2020 10:21:26 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <947c5026-cfa3-5a48-701c-28e46ac061bf@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/13/2020 6:16 AM, Jens Axboe wrote:
> The splice file punt check uses file->f_mode to check for O_NONBLOCK,
> but it should be checking file->f_flags. This leads to punting even
> for files that have O_NONBLOCK set, which isn't necessary. This equates
> to checking for FMODE_PATH, which will never be set on the fd in
> question.

My bad, thanks


> Fixes: 7d67af2c0134 ("io_uring: add splice(2) support")
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 68a678a0056b..0d1b5d5f1251 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2763,7 +2763,7 @@ static bool io_splice_punt(struct file *file)
>  		return false;
>  	if (!io_file_supports_async(file))
>  		return true;
> -	return !(file->f_mode & O_NONBLOCK);
> +	return !(file->f_flags & O_NONBLOCK);
>  }
>  
>  static int io_splice(struct io_kiocb *req, bool force_nonblock)
> 

-- 
Pavel Begunkov
