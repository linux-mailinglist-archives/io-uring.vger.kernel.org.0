Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A52C14A53B
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2020 14:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbgA0Njt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jan 2020 08:39:49 -0500
Received: from mail-pl1-f180.google.com ([209.85.214.180]:44449 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgA0Njt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jan 2020 08:39:49 -0500
Received: by mail-pl1-f180.google.com with SMTP id d9so3754428plo.11
        for <io-uring@vger.kernel.org>; Mon, 27 Jan 2020 05:39:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sn5ISLNuICYIzfDbXjI/YCNPUj6XJ4qflUGig9Z6Uz4=;
        b=QA+2BJLUkioUm8ByjzfvHQBoxER8JhtveK12k5on6Q4mK8C1TmqTvGQ1rrS4OwvjFC
         jm4Mbaysq+8PfnJPVlAAOyo2inQkvPsB3KMwnlQIi4aLpzfsHghQagS8/7sFMymmtR4L
         1WhiGZbFKtrlXDCwmJ2Ak8dXRI/qfWq6+my14g+dvWmRCCfkH8Wd1Jsm9Ge2Ms4c1X9k
         4zxk4udvDTMuy6n/lVauUWSYUVTLHGm1Ilcw9OmlbFWeRG3S6mb0Vg5oFOEtdkkFxk1i
         jQ865p9kLH+c78FRAaX885TmOwaSWlYb3C7EGD/bgnLOJdLm1sVP+H21cb22HfE3hZHY
         GeTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sn5ISLNuICYIzfDbXjI/YCNPUj6XJ4qflUGig9Z6Uz4=;
        b=t+iTwEnkTNvKExPKCY57RTU9tHCviP5ZdZ0mfmIYJhJC/CdgwEPARetnJt+I4wVT4y
         jlraZ7sCk2oDgWuR12h7KwZSNDSaY5a4T0F/BDoyxvzCu84AlrskjSZCjBNvYZDzTb83
         mKdC0LDZwiZVAMC2Vu59zmefrDD/iGSMlfdbiAl6TXtdEEl6DurE11Mo9ZDeXNX0L4el
         NByW6Rn2suZI3bbFdA8EMd/cMUILuXgQcM+nyibizgBcZJqCP9cqr8lpZiEqzkcg4Lss
         Y9UUdK18FzuLysG5uLTme5brJuU/xWnaG3vNj7ijl/1lYbv+OhMbX8UBO4BsgP6sz9Mp
         F48g==
X-Gm-Message-State: APjAAAVPYlrwvGhbEuhdQEimKPf+r4jDZOyAyw1aa1p9Wja5uiF/FPmQ
        nYX58NGNLvx3HdRt6PDKxqgodqablWs=
X-Google-Smtp-Source: APXvYqzZOnv2HfZzzNFMdZ7kavgrNmYxO7dXwCPH5yftxHEZbK5r+tEE5W9ZGuXzrETPDO3JOCOTcg==
X-Received: by 2002:a17:902:7c02:: with SMTP id x2mr6378662pll.60.1580132388174;
        Mon, 27 Jan 2020 05:39:48 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id q63sm16440715pfb.149.2020.01.27.05.39.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jan 2020 05:39:47 -0800 (PST)
Subject: Re: [PATCHSET 0/4] Add support for shared io-wq backends
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Daurnimator <quae@daurnimator.com>
Cc:     io-uring@vger.kernel.org
References: <20200123231614.10850-1-axboe@kernel.dk>
 <CAEnbY+c34Uiguq=11eZ1F0z_VZopeBbw1g1gfn-S0Fb5wCaL5A@mail.gmail.com>
 <4917a761-6665-0aa2-0990-9122dfac007a@gmail.com>
 <694c2b6f-6b51-fd7b-751e-db87de90e490@kernel.dk>
 <a9fcf996-88ed-6bc4-f5ef-6ce4ed2253c5@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <92e92002-f803-819a-5f5e-44cf09e63c9b@kernel.dk>
Date:   Mon, 27 Jan 2020 06:39:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <a9fcf996-88ed-6bc4-f5ef-6ce4ed2253c5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/27/20 6:29 AM, Pavel Begunkov wrote:
> On 1/26/2020 8:00 PM, Jens Axboe wrote:
>> On 1/26/20 8:11 AM, Pavel Begunkov wrote:
>>> On 1/26/2020 4:51 AM, Daurnimator wrote:
>>>> On Fri, 24 Jan 2020 at 10:16, Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> I don't love the idea of some new type of magic user<>kernel
>>>> identifier. It would be nice if the id itself was e.g. a file
>>>> descriptor
>>>>
>>>> What if when creating an io_uring you could pass in an existing
>>>> io_uring file descriptor, and the new one would share the io-wq
>>>> backend?
>>>>
>>> Good idea! It can solve potential problems with jails, isolation, etc in
>>> the future.
>>>
>>> May we need having other shared resources and want fine-grained control
>>> over them at some moment? It can prove helpful for the BPF plans.
>>> E.g.
>>>
>>> io_uring_setup(share_io-wq=ring_fd1,
>>>                share_fds=ring_fd2,
>>>                share_ebpf=ring_fd3, ...);
>>>
>>> If so, it's better to have more flexible API. E.g. as follows or a
>>> pointer to a struct with @size field.
>>>
>>> struct io_shared_resource {
>>>     int type;
>>>     int fd;
>>> };
>>>
>>> struct io_uring_params {
>>>     ...
>>>     struct io_shared_resource shared[];
>>> };
>>>
>>> params = {
>>>     ...
>>>     .shared = {{ATTACH_IO_WQ, fd1}, ..., SANTINEL_ENTRY};
>>> };
>>
>> I'm fine with changing/extending the sharing API, please send a
>> patch!
>>
> 
> Ok. I can't promise it'll play handy for sharing. Though, you'll be out
> of space in struct io_uring_params soon anyway.

I'm going to keep what we have for now, as I'm really not imagining a
lot more sharing - what else would we share? So let's not over-design
anything.


-- 
Jens Axboe

