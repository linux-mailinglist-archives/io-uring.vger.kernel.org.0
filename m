Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8967B3E5C5B
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 15:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238662AbhHJN4f (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Aug 2021 09:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238215AbhHJN4f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Aug 2021 09:56:35 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E6C0C0613D3
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 06:56:07 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id f3so10448116plg.3
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 06:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=umoh5/6IQIa7zDuK80XEuvvA4ETsM1msFfzxzPHJkew=;
        b=yxIWO6J3RO5BHpkybfI3ZNP3WdHc7rBWlLZG2qqFwQk1ALcjJoTvFnrBkb1ZlX2Drh
         cR660SeL73pwDfSD9ImJ3i/w39gW7wRnDodpqf+Xuib0i4tvJ0v4+4dz50djr62L9mGz
         REfW6Em8h7Qz61wgh0a6qrsQ4AUFiA0+MGwQFv3lOHcG42E8IbJcFxBc36bzCWMGbd/o
         WM00w8yYOvbYm38NHszsdCrau0UGPk4xR0kTNqApAzRO8kDgVnww+FkAsUmh+AKOGJIZ
         tY4hTPIPT0GyGUFxpgKkSvTvDGkraqUIZQ/FwPqkUKMaq2HhDv0ZD0ZqEfprHqGLW/Br
         1omQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=umoh5/6IQIa7zDuK80XEuvvA4ETsM1msFfzxzPHJkew=;
        b=JUg8SDz76UtvGlRmafwfn9uvDOR4dU3HaDkXNraHbeCl/aQJXyH2PeIcKbm3f1xvwL
         buY7SukSRXDDkbrVLwDowR0CmfBQyaUkmttDRluFhL0YrPX0bSbQAv307rTP0XLDfOf1
         9PjXmbfnBmobrNNp2EYCLadnUdXU74XLsczeedVM2m0H2W0vvhRh2y3W3lyl1hG8pdT/
         awrCnfmM6cVzFF9exq8To5tof3lQRw+byG6U52Bwhwqf9RYNjmUOP7JWIDFcoOhayU9+
         5ySW6ASsrR6NEpA5qP+hDsQizJnPkNRYthFWwphOcbuf6eRzXXvA/NAyJf9o6nSlSsXx
         3KAg==
X-Gm-Message-State: AOAM530/VODtrnM48r/q41vQQGlMWoxRG3+m8Luk6evAKQIe3FlrXN7/
        eFrJRLzZay8/pp45r5Av0DTH2l3GbRkz5Rnr
X-Google-Smtp-Source: ABdhPJxv0udrj7CnLvtWWd62E0GYe6D5/3rPyadOkg9tPuF4naHjROKDDurBDFU66Z4tYEcEgfOvQQ==
X-Received: by 2002:a17:902:e786:b029:12d:2a7:365f with SMTP id cp6-20020a170902e786b029012d02a7365fmr15035087plb.21.1628603766879;
        Tue, 10 Aug 2021 06:56:06 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id mq7sm3577320pjb.50.2021.08.10.06.56.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 06:56:06 -0700 (PDT)
Subject: Re: [PATCH 4/4] block: enable use of bio allocation cache
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org
References: <20210809212401.19807-1-axboe@kernel.dk>
 <20210809212401.19807-5-axboe@kernel.dk>
 <CA+1E3rKS+m6kuci7PmRw7LUbwVmF-ge6AV78SSnAkdegK0__Gw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7557849c-c23b-a6c6-b542-2335f10eafb1@kernel.dk>
Date:   Tue, 10 Aug 2021 07:56:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CA+1E3rKS+m6kuci7PmRw7LUbwVmF-ge6AV78SSnAkdegK0__Gw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/10/21 6:39 AM, Kanchan Joshi wrote:
> On Tue, Aug 10, 2021 at 6:40 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> If a kiocb is marked as being valid for bio caching, then use that to
>> allocate a (and free) new bio if possible.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  fs/block_dev.c | 30 ++++++++++++++++++++++++++----
>>  1 file changed, 26 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/block_dev.c b/fs/block_dev.c
>> index 9ef4f1fc2cb0..36a3d53326c0 100644
>> --- a/fs/block_dev.c
>> +++ b/fs/block_dev.c
>> @@ -327,6 +327,14 @@ static int blkdev_iopoll(struct kiocb *kiocb, bool wait)
>>         return blk_poll(q, READ_ONCE(kiocb->ki_cookie), wait);
>>  }
>>
>> +static void dio_bio_put(struct blkdev_dio *dio)
>> +{
>> +       if (!dio->is_sync && (dio->iocb->ki_flags & IOCB_ALLOC_CACHE))
>> +               bio_cache_put(&dio->bio);
> 
> I think the second check (against IOCB_ALLOC_CACHE) is sufficient here.

Yes probably don't need the sync check here, I'll kill it.

-- 
Jens Axboe

