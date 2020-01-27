Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC1DF14A520
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2020 14:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725958AbgA0N30 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jan 2020 08:29:26 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:42392 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgA0N3Z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jan 2020 08:29:25 -0500
Received: by mail-lj1-f195.google.com with SMTP id y4so10650840ljj.9
        for <io-uring@vger.kernel.org>; Mon, 27 Jan 2020 05:29:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TM1LvMFUOJ3++8wIc6ydNYM0b6m+CTITY/Bgv2myZ3M=;
        b=FpND5ixysYqd3LNiZbzVZFOHIMv9Yp22IE6OQK3QfDxRgdfejX7rgyWr11FeqIHEM9
         r+6PgFZxwvB6Hqiz3ZaGeZK2EDHLzNq19gvDdXjtpDmabXNWLMNhXYTDmZ38i2WPsbSA
         hN+Qol/cPEHwnVBQYJWn9zKKMGj4m+Yhb59JrLra3AgvNQLMjksn0Jc44FiHaJIu1C+w
         /yQxCmtIEWB/etUZtJOqZ4yNuOu0aqegninxqsE0N72VX9LTUNs+XAbKwhpGylwAlGTG
         4ks+02Fs87J7kqcDabUxUZJyCVhVgmWWN66rPieEm9eAqNsBlLkd9MtI5MgnqW+ggaxb
         tW1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TM1LvMFUOJ3++8wIc6ydNYM0b6m+CTITY/Bgv2myZ3M=;
        b=Rjh3EYspBt/qAcafA7T+GmfjswGwK97mEMHMI1LH1mFTR0OXWbdG7hXJcOSPeNKhs/
         fXobYYM6L2UkyS9Dyh5s9e/rjSIEaUG7Yag3tjeejx9PQz7PaBI1SFqj7vJztkS6HmiF
         0warIT4oirb6gCuWQAcMgYvFpGBhL/ccF2xRXhUXOi6hjCX3umY4xFSNoesyiGCFYgLf
         067Mq8aOrKyHyDxllwmxZ4RO+64wC5eWM9jxMip4tVe/OAYs3NDX0/PtJ44YfjQpWhub
         8Xn/1aPxQkXiPRgXMc4AtgtC6EauK/MBf9zbuJL4o2n5Y45+Brt107VXHvqWYlByknlT
         sIRg==
X-Gm-Message-State: APjAAAXgTMrrb7q/ub/H8PqCIZwmPw/b7AKvfrKFWHcknGmD1wN+WyLQ
        IMSg9dgMgqWlOxi2DBx9BhYLiIuplU0=
X-Google-Smtp-Source: APXvYqxb9mV5/fo1vWwgAaa2iDMlxVLWhroq6JOYAB4s+sCkHLVGCk+1J6q6TDXkL0Wonu0ddvamGw==
X-Received: by 2002:a2e:a48a:: with SMTP id h10mr10347305lji.254.1580131763514;
        Mon, 27 Jan 2020 05:29:23 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id q13sm10047790ljj.63.2020.01.27.05.29.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jan 2020 05:29:22 -0800 (PST)
Subject: Re: [PATCHSET 0/4] Add support for shared io-wq backends
To:     Jens Axboe <axboe@kernel.dk>, Daurnimator <quae@daurnimator.com>
Cc:     io-uring@vger.kernel.org
References: <20200123231614.10850-1-axboe@kernel.dk>
 <CAEnbY+c34Uiguq=11eZ1F0z_VZopeBbw1g1gfn-S0Fb5wCaL5A@mail.gmail.com>
 <4917a761-6665-0aa2-0990-9122dfac007a@gmail.com>
 <694c2b6f-6b51-fd7b-751e-db87de90e490@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <a9fcf996-88ed-6bc4-f5ef-6ce4ed2253c5@gmail.com>
Date:   Mon, 27 Jan 2020 16:29:20 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <694c2b6f-6b51-fd7b-751e-db87de90e490@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/26/2020 8:00 PM, Jens Axboe wrote:
> On 1/26/20 8:11 AM, Pavel Begunkov wrote:
>> On 1/26/2020 4:51 AM, Daurnimator wrote:
>>> On Fri, 24 Jan 2020 at 10:16, Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> I don't love the idea of some new type of magic user<>kernel
>>> identifier. It would be nice if the id itself was e.g. a file
>>> descriptor
>>>
>>> What if when creating an io_uring you could pass in an existing
>>> io_uring file descriptor, and the new one would share the io-wq
>>> backend?
>>>
>> Good idea! It can solve potential problems with jails, isolation, etc in
>> the future.
>>
>> May we need having other shared resources and want fine-grained control
>> over them at some moment? It can prove helpful for the BPF plans.
>> E.g.
>>
>> io_uring_setup(share_io-wq=ring_fd1,
>>                share_fds=ring_fd2,
>>                share_ebpf=ring_fd3, ...);
>>
>> If so, it's better to have more flexible API. E.g. as follows or a
>> pointer to a struct with @size field.
>>
>> struct io_shared_resource {
>>     int type;
>>     int fd;
>> };
>>
>> struct io_uring_params {
>>     ...
>>     struct io_shared_resource shared[];
>> };
>>
>> params = {
>>     ...
>>     .shared = {{ATTACH_IO_WQ, fd1}, ..., SANTINEL_ENTRY};
>> };
> 
> I'm fine with changing/extending the sharing API, please send a
> patch!
> 

Ok. I can't promise it'll play handy for sharing. Though, you'll be out
of space in struct io_uring_params soon anyway.

-- 
Pavel Begunkov
