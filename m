Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B14CC149BF7
	for <lists+io-uring@lfdr.de>; Sun, 26 Jan 2020 18:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbgAZRAs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 26 Jan 2020 12:00:48 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:54007 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725907AbgAZRAr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 26 Jan 2020 12:00:47 -0500
Received: by mail-pj1-f66.google.com with SMTP id n96so2017996pjc.3
        for <io-uring@vger.kernel.org>; Sun, 26 Jan 2020 09:00:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TrFshwMX3sLK7BOBqA2VJ29qR9X1r/JNaTWM7Oz0VQA=;
        b=jnWi3Yn2NMNOIwX2PJ4tOUcqZTqX5OR5JwlRXPoNGyNHX01sOirIgtEWYZRZWvJeTm
         GijpteuCf51TdsNDRzDyuqhadCJcW0tpB3IKSY+0aTmLzPPWeFWAEJY1LA9vbDKCAPfi
         olnSOVDYqGErWCEDpM1rVPXbcR2Flm+LYjdQ256mzNxkVa8m/nFXGiqaEkPlLcCZre0b
         T6SGWs/QVoWcUoKbnKq7zmrWge70eMtGMNI6wB5C+/y9akv+VAVXIBy2ivRdDFOYtP7a
         hJ2sCVli/r0zBc+zlE0nfBx3yGU74ugrLMJac5KV5VDiZIIS8S1bE7TsnoGFUkeXgAdl
         RTQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TrFshwMX3sLK7BOBqA2VJ29qR9X1r/JNaTWM7Oz0VQA=;
        b=jIXiwB3vkk1ukjM8a+UAIwXtmyftgmp79K5PZJNuB1OL1gTNNWM1IcCiryDXjwvZub
         yqh3Q5jXbTQOlBIidDsCXvH6TNA7roVvtfZE5b7PHuHSbvsQnO8fod15rC59Fc/KtNr+
         toGzVvnINeynFqyE/gOAX42WQXwiLzXXrRBs2IGdEHzQrKYnNiWbuOjTB6x8GtbRXqoV
         eT2tVHG050ZIDxHcHn89oObW/PuAV3nubFcxRBKVjG+mzLmg8JGvAr4KwzNg+i56p6vx
         oI0CDEsHTZQ8YyG7YIC1UCZxFSCOIG9m8k2AIdmLWOi4DyQVvQzRCrkx9XimCnAyFtwF
         kg7Q==
X-Gm-Message-State: APjAAAXyrbkZbgqlAdWJaWKmCwKvIiNWeRLxHLWfYThjB8Pd7kfj9xUJ
        jvAhoQxdKfkyFhJKhLUtKTZKCUnUIeg=
X-Google-Smtp-Source: APXvYqy8OkXpvY/EO7JJ8JrTwGu1cGTUbP5I6eRn6QR69XynaZ75aoXP1ZrYpUnlS6f6H1wvcRthDg==
X-Received: by 2002:a17:902:be06:: with SMTP id r6mr12572734pls.99.1580058047058;
        Sun, 26 Jan 2020 09:00:47 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id p3sm1629735pfg.184.2020.01.26.09.00.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2020 09:00:46 -0800 (PST)
Subject: Re: [PATCHSET 0/4] Add support for shared io-wq backends
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Daurnimator <quae@daurnimator.com>
Cc:     io-uring@vger.kernel.org
References: <20200123231614.10850-1-axboe@kernel.dk>
 <CAEnbY+c34Uiguq=11eZ1F0z_VZopeBbw1g1gfn-S0Fb5wCaL5A@mail.gmail.com>
 <4917a761-6665-0aa2-0990-9122dfac007a@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <694c2b6f-6b51-fd7b-751e-db87de90e490@kernel.dk>
Date:   Sun, 26 Jan 2020 10:00:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <4917a761-6665-0aa2-0990-9122dfac007a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/26/20 8:11 AM, Pavel Begunkov wrote:
> On 1/26/2020 4:51 AM, Daurnimator wrote:
>> On Fri, 24 Jan 2020 at 10:16, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> I don't love the idea of some new type of magic user<>kernel
>> identifier. It would be nice if the id itself was e.g. a file
>> descriptor
>>
>> What if when creating an io_uring you could pass in an existing
>> io_uring file descriptor, and the new one would share the io-wq
>> backend?
>>
> Good idea! It can solve potential problems with jails, isolation, etc in
> the future.
> 
> May we need having other shared resources and want fine-grained control
> over them at some moment? It can prove helpful for the BPF plans.
> E.g.
> 
> io_uring_setup(share_io-wq=ring_fd1,
>                share_fds=ring_fd2,
>                share_ebpf=ring_fd3, ...);
> 
> If so, it's better to have more flexible API. E.g. as follows or a
> pointer to a struct with @size field.
> 
> struct io_shared_resource {
>     int type;
>     int fd;
> };
> 
> struct io_uring_params {
>     ...
>     struct io_shared_resource shared[];
> };
> 
> params = {
>     ...
>     .shared = {{ATTACH_IO_WQ, fd1}, ..., SANTINEL_ENTRY};
> };

I'm fine with changing/extending the sharing API, please send a
patch!

-- 
Jens Axboe

