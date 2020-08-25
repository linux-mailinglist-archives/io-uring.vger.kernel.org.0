Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1652D251998
	for <lists+io-uring@lfdr.de>; Tue, 25 Aug 2020 15:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbgHYN2h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Aug 2020 09:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbgHYN2d (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Aug 2020 09:28:33 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F88C061574
        for <io-uring@vger.kernel.org>; Tue, 25 Aug 2020 06:28:33 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id w20so9104275iom.1
        for <io-uring@vger.kernel.org>; Tue, 25 Aug 2020 06:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4LfcM0Vj7+BoAatRL8zG+OxKSsjIhu6dkepwvpEanm4=;
        b=USjeTBPK5KJEsGWJam7S/O54tpyJ4nAyXNLp7OYnUsyWnnuqYXsQHO4/JS1pyS8+pm
         gHER5/1xP44L3u1l2RupNb16V244G4HSIoePOglpO08IvOh9xgehrZ+uAurimKVyX91E
         U4zpTg1C1AGxfr0VqEe6AxHmeV4jG+A48/kGEIas4ucKR0BHoAvLB9Toj+iH2tPnmDYW
         Z+WCKmHdEGt/4mbwMRrJdvFxCcmKPp9mPoUM70qH4uecyrmN7IY7e3VdGKbx3qjnNXoa
         9qNQYIqDoVErNWVS8WLFKGrP5b5569JEseK4rRQhgCUyFm/QR46ng+AEqUoR6D5sdMWl
         lcnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4LfcM0Vj7+BoAatRL8zG+OxKSsjIhu6dkepwvpEanm4=;
        b=tUmO2+PRfk9cdLiw2DNr8qjNUcJSD5ld5pEKCUvCgmU2jRICC4XtYC4/ydmVYvB8Dd
         5gTcBU8tDe0WdKQ0BWjNHDFjqM5kU5SJEyadroAhHgrnTYWSUlFUR3FUhjUAnvMMaYjp
         fEhQbF9RnWcMwM0f9IdV3LRM0t19nLevMAUXKkkVEldX0mzREbw1J5nTj6XHNvTs8omZ
         IBZR0p2YtAF62nnUdgqI+kDBVZhpX2VAsvcbS6JF9YDxX68Sy6/ZPQfZ5btqhAwcUcUa
         W+ME/gcWAlu6rMlA2R1FazGe9KPPh817aAoltpnC9a8/GN+Bodu81AGGrHKzCY5xKdhu
         dkag==
X-Gm-Message-State: AOAM533d1LEqx3oJkMBLvqb3xMi6ByjpIPU9qLQMGP/gZYG2rXgaoYpI
        Dj/sy6Obtm/7bTUQ6QeGfPMfDZzWyx/VNhox
X-Google-Smtp-Source: ABdhPJwVe3elKyIoBK5CUNWZKYI9QZDShEa/Og8cQNHbSo3udlLhlC9ThP/HTBcG915yWj8YwhgYeQ==
X-Received: by 2002:a5d:871a:: with SMTP id u26mr8587762iom.92.1598362110319;
        Tue, 25 Aug 2020 06:28:30 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id s21sm8673928ios.48.2020.08.25.06.28.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2020 06:28:29 -0700 (PDT)
Subject: Re: [PATCH] io_uring: revert consumed iov_iter bytes on error
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <a2e5bc52-d31a-3447-c4be-46d6bb1fd4b8@kernel.dk>
 <20200825123332.lb3o5ah53jar7mbw@steredhat>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <70fdcdf4-3e57-0913-04d5-beab4fec6f91@kernel.dk>
Date:   Tue, 25 Aug 2020 07:28:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200825123332.lb3o5ah53jar7mbw@steredhat>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/25/20 6:33 AM, Stefano Garzarella wrote:
> On Mon, Aug 24, 2020 at 11:48:44AM -0600, Jens Axboe wrote:
>> Some consumers of the iov_iter will return an error, but still have
>> bytes consumed in the iterator. This is an issue for -EAGAIN, since we
>> rely on a sane iov_iter state across retries.
>>
>> Fix this by ensuring that we revert consumed bytes, if any, if the file
>> operations have consumed any bytes from iterator. This is similar to what
>> generic_file_read_iter() does, and is always safe as we have the previous
>> bytes count handy already.
>>
>> Fixes: ff6165b2d7f6 ("io_uring: retain iov_iter state over io_read/io_write calls")
>> Reported-by: Dmitry Shulyak <yashulyak@gmail.com>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> ---
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index c9d526ff55e0..e030b33fa53e 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -3153,6 +3153,8 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
>>  	} else if (ret == -EAGAIN) {
>>  		if (!force_nonblock)
>>  			goto done;
>> +		/* some cases will consume bytes even on error returns */
>> +		iov_iter_revert(iter, iov_count - iov_iter_count(iter));
>>  		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);
>>  		if (ret)
>>  			goto out_free;
>> @@ -3294,6 +3296,8 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
>>  	if (!force_nonblock || ret2 != -EAGAIN) {
>>  		kiocb_done(kiocb, ret2, cs);
>>  	} else {
>> +		/* some cases will consume bytes even on error returns */
>> +		iov_iter_revert(iter, iov_count - iov_iter_count(iter));
>>  copy_iov:
>>  		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);
>>  		if (!ret)
>>
> 
> What about moving iov_iter_revert() in io_setup_async_rw(), passing
> iov_initial_count as parameter?
> 
> Maybe it's out of purpose since we use it even when we're not trying
> again.

The read side looks a little nicer, since we keep it close to where the
-EAGAIN happened. And as you mention, we don't need it for all the async
setup cases, only the ones where we tried to do IO first.
io_setup_async_rw is already pretty busy with arguments, so I think
that'd just make it harder to follow.

> Anyway the patch LGTM:
> 
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks, added.

-- 
Jens Axboe

