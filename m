Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A74EA2506C5
	for <lists+io-uring@lfdr.de>; Mon, 24 Aug 2020 19:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgHXRoz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Aug 2020 13:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbgHXRox (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Aug 2020 13:44:53 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A46EC061573
        for <io-uring@vger.kernel.org>; Mon, 24 Aug 2020 10:44:53 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id c6so7981844ilo.13
        for <io-uring@vger.kernel.org>; Mon, 24 Aug 2020 10:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=76ZRRv/9zXrx7IX7RJ7YwmpW1Qr4VucHp1pYnesDFCg=;
        b=B9VDU0ryyzZ9XgagxKOi7ErnCwyQMZT8dPHlF0MiFlbXckX5GjirY+tbL/GTKoylGO
         Z0orq3c7EE9QFZA8x1ds4XyWuZ8XHnHWuFwAxjvONicKnRJj22jAoMhcl1uzMmY2P5zW
         M9KfEozsnHsIr7q58tsp9PZ92wXJH7/XhBlCslbXXThXPJ6dhk1jfK1vTYAj7DDuW1eH
         nab/ZiQ0bmlUWGXf1gzm9U/CcNOx0wtVJ2Jlo6S0+c6JgolNtbleoPKgQwkHksvUyOdS
         c3X/zEdbjgnpcOYeOX8oc5Jp81Cl2ze2gXOGFt8Z4d0tekDTA/y2OX2bl6jgti3aDxYH
         ycxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=76ZRRv/9zXrx7IX7RJ7YwmpW1Qr4VucHp1pYnesDFCg=;
        b=ers3Hz6k146T1vMzZ2kHz91HuTcuxFIlBH4Fvb5NJ6h+jeTeW3KugBVXsgpsOGvAx9
         M13E+G5I3moN//9LBeTeYQ8Gx2hD4fzguFk8lHtqoU7I7H4tjdlaGXfeoPiW0zcfChD/
         S9hso+o5Wpkdo+GFtPubEck6rthlTxBPxvU0j8gl9iFSLPVRt1cZrG+uHCotCsJWgQ2W
         p74h0BTv9qY8WA4sAiOBiMzzq+BZFTCHwCaJ/GafdXKQnu+bmlD2szDQkVaD/uViBS9p
         3DdyrrCR9PwR9EfafE+DzqqTXss2jG7dfin3zpJXJGzXGjDiHeOJKYTtBQwOmY1ccWzZ
         CKMw==
X-Gm-Message-State: AOAM533cr7/54MfPSydllzXaV52tZDKXAKq4j1rnOYV7SVkFxSnRYOqe
        PzKKAiubRkxGnQki4hF7aqmABwTMPnIstC9U
X-Google-Smtp-Source: ABdhPJzVFlQd1TD1xd9lsoKz0yDi262KBolN+Mgp1MTicX/zFNu+qHfUxOz8SkugB6xmPvhv972dRw==
X-Received: by 2002:a92:9a94:: with SMTP id c20mr5289559ill.37.1598291087881;
        Mon, 24 Aug 2020 10:44:47 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id u4sm4457802iol.17.2020.08.24.10.44.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Aug 2020 10:44:47 -0700 (PDT)
Subject: Re: Large number of empty reads on 5.9-rc2 under moderate load
From:   Jens Axboe <axboe@kernel.dk>
To:     Dmitry Shulyak <yashulyak@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <CAF-ewDqBd4gSLGOdHE8g57O_weMTH0B-WbfobJud3h6poH=fBg@mail.gmail.com>
 <7a148c5e-4403-9c8e-cc08-98cd552a7322@kernel.dk>
 <CAF-ewDpvLwkiZ3sJMT64e=efCRFYVkt2Z71==1FztLg=vZN8fg@mail.gmail.com>
 <06d07d6c-3e91-b2a7-7e03-f6390e787085@kernel.dk>
 <da7b74d2-5825-051d-14a9-a55002616071@kernel.dk>
 <CAF-ewDrMO-qGOfXdZUyaGBzH+yY3EBPHCO_bMvj6yXhZeCFaEw@mail.gmail.com>
 <282f1b86-0cf3-dd8d-911f-813d3db44352@kernel.dk>
 <CAF-ewDrRqiYqXHhbHtWjsc0VuJQLUynkiO13zH_g2RZ1DbVMMg@mail.gmail.com>
 <ddc3c126-d1bd-a345-552b-35b35c507575@kernel.dk>
Message-ID: <42573664-450d-bfe4-aa96-ca1ae0704adb@kernel.dk>
Date:   Mon, 24 Aug 2020 11:44:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <ddc3c126-d1bd-a345-552b-35b35c507575@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/24/20 10:18 AM, Jens Axboe wrote:
> On 8/24/20 10:13 AM, Dmitry Shulyak wrote:
>> On Mon, 24 Aug 2020 at 19:10, Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> On 8/24/20 9:33 AM, Dmitry Shulyak wrote:
>>>> On Mon, 24 Aug 2020 at 17:45, Jens Axboe <axboe@kernel.dk> wrote:
>>>>>
>>>>> On 8/24/20 8:06 AM, Jens Axboe wrote:
>>>>>> On 8/24/20 5:09 AM, Dmitry Shulyak wrote:
>>>>>>> library that i am using https://github.com/dshulyak/uring
>>>>>>> It requires golang 1.14, if installed, benchmark can be run with:
>>>>>>> go test ./fs -run=xx -bench=BenchmarkReadAt/uring_8 -benchtime=1000000x
>>>>>>> go test ./fs -run=xx -bench=BenchmarkReadAt/uring_5 -benchtime=8000000x
>>>>>>>
>>>>>>> note that it will setup uring instance per cpu, with shared worker pool.
>>>>>>> it will take me too much time to implement repro in c, but in general
>>>>>>> i am simply submitting multiple concurrent
>>>>>>> read requests and watching read rate.
>>>>>>
>>>>>> I'm fine with trying your Go version, but I can into a bit of trouble:
>>>>>>
>>>>>> axboe@amd ~/g/go-uring (master)>
>>>>>> go test ./fs -run=xx -bench=BenchmarkReadAt/uring_8 -benchtime=1000000x
>>>>>> # github.com/dshulyak/uring/fixed
>>>>>> fixed/allocator.go:38:48: error: incompatible type for field 2 in struct construction (cannot use type uint64 as type syscall.Iovec_len_t)
>>>>>>    38 |  iovec := []syscall.Iovec{{Base: &mem[0], Len: uint64(size)}}
>>>>>>       |                                                ^
>>>>>> FAIL  github.com/dshulyak/uring/fs [build failed]
>>>>>> FAIL
>>>>>> axboe@amd ~/g/go-uring (master)> go version
>>>>>> go version go1.14.6 gccgo (Ubuntu 10.2.0-5ubuntu1~20.04) 10.2.0 linux/amd64
>>>>>
>>>>> Alright, got it working. What device are you running this on? And am I
>>>>> correct in assuming you get short reads, or rather 0 reads? What file
>>>>> system?
>>>>
>>>> Was going to look into this.
>>>> I am getting 0 reads. This is on some old kingston ssd, ext4.
>>>
>>> I can't seem to reproduce this. I do see some cqe->res == 0 completes,
>>> but those appear to be NOPs. And they trigger at the start and end. I'll
>>> keep poking.
>>
>> Nops are used for draining and closing rings at the end of benchmarks.
>> It also appears in the beginning because of the way golang runs
>> benchmarks...
> 
> OK, just checking if it was expected.
> 
> But I can reproduce it now, turns out I was running XFS and that doesn't
> trigger it. With ext4, I do see zero sized read completions. I'll keep
> poking.

Can you try with this? Looks like some cases will consume bytes from the
iterator even if they ultimately return an error. If we've consumed bytes
but need to trigger retry, ensure we revert the consumed bytes.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 91e2cc8414f9..609b4996a4e9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3152,6 +3152,8 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	} else if (ret == -EAGAIN) {
 		if (!force_nonblock)
 			goto done;
+		/* some cases will consume bytes even on error returns */
+		iov_iter_revert(iter, iov_count - iov_iter_count(iter));
 		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);
 		if (ret)
 			goto out_free;
@@ -3293,6 +3295,8 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 	if (!force_nonblock || ret2 != -EAGAIN) {
 		kiocb_done(kiocb, ret2, cs);
 	} else {
+		/* some cases will consume bytes even on error returns */
+		iov_iter_revert(iter, iov_count - iov_iter_count(iter));
 copy_iov:
 		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);
 		if (!ret)

-- 
Jens Axboe

