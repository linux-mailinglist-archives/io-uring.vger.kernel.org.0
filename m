Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C11A73FCE22
	for <lists+io-uring@lfdr.de>; Tue, 31 Aug 2021 22:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233641AbhHaUFF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Aug 2021 16:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240532AbhHaUE7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Aug 2021 16:04:59 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC8B4C061575
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 13:04:03 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id i13so482159ilm.4
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 13:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=fOnmtR2ApV++9WH/erdVockbUtTw1uw8PSHhe/rtbtM=;
        b=PgYFhq5EcsauOmzvYVN4l75HlNk0qGL6jQqcUy1bfAA0T+HcWQIQxca6OuMzS0G93f
         8OMkr0U0thkwF+CTI3ZsRubiiUe8wXz+/ZkpPgk5n20KTRmQSqVF2h0Omlb/GGdzIYGy
         VZyFPv0akRlqMbmEKtwV6DS3f+TSlhMIIBBu961+hJkPX1/45N0AQ/IG2Evy1mOr3gLT
         l8TeP68VEQlM9KkGFvcpttojsSRXcZXq0MXEAkh0gm3mRff5/hQGp7YxGaYWEVdPPcx0
         WTDJ22E3PMTmACdqNjReV+HgXYMHNjtextjvmHui3Q14CQqF2/lRfWSmulkRJfYLFGGx
         Pncg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fOnmtR2ApV++9WH/erdVockbUtTw1uw8PSHhe/rtbtM=;
        b=PSDhNsVJIZXQG28k7I9M64dvxTU/5CZVTvZKmbmiryCIrEEurseuupWDv/DZTQSnWI
         8k1eYiXnKGAeZOiPcQqxfjOMmTkbOjsU4WDmQHUOWdbsRqQo0HW0TT/HaWYxEf5XVpo7
         ZxCpx5RCs7e8bq5WEvMoiNoi6OwNafqrPXkEOJx76i61kM/V105Gd9s1ZamR0MnoOJ76
         VXsZmDyhxKF4cR61YWkq0bTAGrlWqGbCiDVXWoogX6vX6CTpVHcFX3SolrWjhdltQlH8
         JuIu+rbOUwHwD2MpxLYQuTGv6RuAYFVudw4Go5XnNEKvbdwL9dZnv3Jb9igqnTUC6gjz
         phpQ==
X-Gm-Message-State: AOAM532T34qfmV9f6q9hWO+C2qbq1jkSaG+e8ilmzeKp2/ZvxNi5WPSO
        4ZPrBI3NKVU4upt37j/AWn/1FNytjICMag==
X-Google-Smtp-Source: ABdhPJyPr5bKzB74s6YqJHwIIi7p61aRXz48ssra8I2UdzoR0DY0oVhs4WBAVCtjmjW2anl+Bv0Hqw==
X-Received: by 2002:a05:6e02:1354:: with SMTP id k20mr20570333ilr.133.1630440242954;
        Tue, 31 Aug 2021 13:04:02 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id x12sm10455817ill.6.2021.08.31.13.04.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 13:04:02 -0700 (PDT)
Subject: Re: [PATCH liburing] man/io_uring_enter.2: add notes about direct
 open/accept
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <e4b7c0f9b585307ac542470c535ef54e419157e0.1630439510.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8f82a074-1597-1796-2e26-da3abe722806@kernel.dk>
Date:   Tue, 31 Aug 2021 14:04:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <e4b7c0f9b585307ac542470c535ef54e419157e0.1630439510.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/31/21 1:52 PM, Pavel Begunkov wrote:
> Add a few lines describing openat/openat2/accept bypassing normal file
> tables and installing files right into the fixed file table.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  man/io_uring_enter.2 | 36 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
> 
> diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
> index 9ccedef..52a5e13 100644
> --- a/man/io_uring_enter.2
> +++ b/man/io_uring_enter.2
> @@ -511,6 +511,18 @@ field. See also
>  .BR accept4(2)
>  for the general description of the related system call. Available since 5.5.
>  
> +If the
> +.I file_index
> +field is set to a non-negative number, the file won't be installed into the
> +normal file table as usual but will be placed into the fixed file table at index
> +.I file_index - 1.
> +In this case, instead of returning a file descriptor, the result will contain
> +0 on success or an error. If there is already a file registered at this index,

I don't think non-negative is correct, it has to be set to a positive
number. non-negative would include 0, which isn't correct.

Should also include a note on if these types of file are used, they
won't work in anything but io_uring. That's obvious to us, but should be
noted that they then only live within the realm of the ring itself, not
the system as a whole.

-- 
Jens Axboe

