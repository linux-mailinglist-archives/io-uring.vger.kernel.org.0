Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFD447DDD8
	for <lists+io-uring@lfdr.de>; Thu, 23 Dec 2021 03:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238520AbhLWCuI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Dec 2021 21:50:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238419AbhLWCuI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Dec 2021 21:50:08 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E49AC061574
        for <io-uring@vger.kernel.org>; Wed, 22 Dec 2021 18:50:08 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id w1so3189683ilh.9
        for <io-uring@vger.kernel.org>; Wed, 22 Dec 2021 18:50:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=rI2PeZX/qi7WydyYXC2Hd/Qm75b7XCkljw02r8ow3gw=;
        b=gxqANou86t+C55ON4G2ssnHMxyBWxTEnZe70+0nnvuBCvs3sMVD3se/CNmjDRH7YG1
         rpplYqM1J01Y067jEDN6tJFaOdgaqwe+ZKmFafC3K1Vf6fhWBMynipBJ+Qnw2qBFwS4H
         IOAZwtuZ0KCaaBepTir59Q4NcEvbXR9LUdZyFJzDP/J0oflhwyR53n28tADwdZ08zcyh
         x3Er1/VW3irjQMd8PfeoqGy3dlqlSc3DKxkAN8dL3JhVPvx8NzkrBzspbzoYMDjJaksM
         o7itjLFuNJY4lhRDJASxsmJiYXTuBiNRCKTw8xtWf8L/HKXuKFLQw1s+ZW6j2UnrON7X
         KRXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rI2PeZX/qi7WydyYXC2Hd/Qm75b7XCkljw02r8ow3gw=;
        b=mphUgyhnXbU4IBDwr9vFE+dbsjTcH0qzNOGvmgQ4p65dhe0lLnqVjv4MXrTKPGVP8f
         TGkYY2jpecABeXX/X30sPDmMubErfDYPQAy+EJu3zywH+0/0zrRKeuH9iY/8tl8juz+C
         yzxC4kjYRGvjhU0hiUCkuID10fkmFlukYLBwWDMnaIp910ADdMIgFxNd8cjvuEQKKJGF
         i/DSxszwZ+kdFlMBabCqjmUviJ0T0OY75pR97rPlN2463DrItLUxopNLnNffZt9snEiK
         N+ZyiV1ws9iYbVIedcjw+qNoJykp2Me9EHoU3xi/ENK7ngZ6d+Ru97xxWGAOza5oU/jm
         WurA==
X-Gm-Message-State: AOAM533kg8qSrpQ5YUmjbZmKjHrHe52o9BQe1c6CR6etSNoa4uoZIJt9
        fUQzJMO4mOq4b0jDQQmn8plDY4ahrpraTQ==
X-Google-Smtp-Source: ABdhPJwpFQteiVJY6nYRNJXHR8L6dBntJqZkTy3R/Ea/VqvxmPEHjF9zYroahVll1RBWsCFCGzzaTg==
X-Received: by 2002:a05:6e02:1a66:: with SMTP id w6mr160307ilv.209.1640227807291;
        Wed, 22 Dec 2021 18:50:07 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id h8sm2145682ila.81.2021.12.22.18.50.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Dec 2021 18:50:07 -0800 (PST)
Subject: Re: Beginner question, user_data not getting filled in as expected
To:     David Butler <croepha@gmail.com>, io-uring@vger.kernel.org
References: <CANm61jem0rMt75PuaK_+-suX_WRi+jXPy3BqHZjAR95vzP73Jg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ffed412f-ab0a-aed5-925c-7364df3af95a@kernel.dk>
Date:   Wed, 22 Dec 2021 19:50:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CANm61jem0rMt75PuaK_+-suX_WRi+jXPy3BqHZjAR95vzP73Jg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/22/21 7:48 PM, David Butler wrote:
> Hello,
> 
> I'm trying to learn the basics of io_uring.  I have this code `hello_uring.cpp':
> 
> // clang-13 -O0 -glldb -fsanitize=address -fno-exceptions -Wall
> -Werror -luring hello_uring.cpp -o build/hello_uring.exec
> #include <fcntl.h>
> #include <stdio.h>
> #include <assert.h>
> #include <liburing.h>
> 
> #define error_check(v) if ((u_int64_t)v == -1) {perror(#v);
> assert((u_int64_t)v != -1);}
> static int const queue_depth = 4;
> static int const buf_size = 1<<10;
> 
> char buffers[queue_depth][buf_size];
> 
> int main () { int r;
> 
>     {
>         // setup test
>         auto f = fopen("build/testfile2", "w");
>         for (unsigned long i = 0; i< 1024; i++) {
>             fwrite(&i, sizeof i, 1, f);
>         }
>         fclose(f);
>     }
> 
>     auto file_fd = open("build/testfile2", O_RDONLY);
> 
>     io_uring ring;
>     r = io_uring_queue_init(queue_depth, &ring, 0);
>     error_check(r);
> 
>     {
>         struct iovec vecs[queue_depth];
>         for (int veci = 0; veci < queue_depth; veci++) {
>             auto sqe = io_uring_get_sqe(&ring);
>             assert(sqe);
>             sqe->user_data = veci;
>             printf("submit: %d\n", veci);
>             vecs[veci] = { .iov_base = buffers[veci], .iov_len = buf_size};
>             io_uring_prep_readv(sqe, file_fd, &vecs[veci], 1, veci * buf_size);
>         }
>         r = io_uring_submit(&ring);
>         error_check(r);
>         assert(r == queue_depth);
>     }
> 
>     for (int done_count = 0; done_count < queue_depth; done_count++) {
> 
>         struct io_uring_cqe *cqe;
>         r = io_uring_wait_cqe(&ring, &cqe);
>         error_check(r);
> 
>         printf("got_completion: %lld, %d, %d\n", cqe->user_data,
> cqe->res, cqe->flags);
>         io_uring_cqe_seen(&ring, cqe);
>     }
> 
>     {
>         unsigned long next_value = 0;
>         for (int buf_i = 0; buf_i < queue_depth; buf_i++) {
>             for (auto buf_values = (unsigned long *)buffers[buf_i];
> (char*)buf_values < buffers[buf_i] + buf_size; buf_values++) {
>                 assert(*buf_values == next_value++);
>             }
>         }
>         assert(next_value == (1024/8) * 4);
>     }
> }
> 
> On execution, I get all zeros for user_data on the `got_completion'
> lines... I was expecting those to be 0, 1, 2, 3.... What am I missing
> here?

You're doing a prep command after filling in the user_data, the former
clears the sqe. Move the user_data assignment after
io_uring_prep_readv().

-- 
Jens Axboe

