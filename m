Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBAB159AD9
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2020 21:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729213AbgBKU71 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Feb 2020 15:59:27 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:43979 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728624AbgBKU71 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Feb 2020 15:59:27 -0500
Received: by mail-io1-f66.google.com with SMTP id n21so13402318ioo.10
        for <io-uring@vger.kernel.org>; Tue, 11 Feb 2020 12:59:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=aBmOqLH1PZiFTOFcGqDZh0Dx5zViJtKjdR8Za6YFAus=;
        b=RZXwnueiFOQ2Vf+tKDg+B+Uev1it96O0IUJDh9R1bQyR0+ak9Dssh/ddGPvF5lVm3q
         nmiC1cXE16tJgM3RfZx9lxRF9ZxbRbpq27hm9Il2WxLH2EBSYMZsKZ4F2rHEk1uefYDB
         mtt5lUNt9nue5gZBaRxGw1FV2a8RaIHeZ06UrLAlgvpOq2R4kRHT8JA0OS4BLetuFuR8
         JSvJtqbpDT7awWyh/HxqOuwCgrBwF6t+/qB3/OlOSiJkcpGJgtdOutFZlVAvPZZVP5eg
         kH3Ursuv1/G2DwDFNlDZwCtreOx4DaGPQQOm1mb0zDd3yseu5feQAoZPNz56+dMhTO7/
         UJDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aBmOqLH1PZiFTOFcGqDZh0Dx5zViJtKjdR8Za6YFAus=;
        b=Qydw7ZAYtf+mOseRGZrUCfCEWNjr59z+cJAEbQVVVsKqR/fOGvdhM4dfqx1OljO8kY
         t/t2LCnprpa9h/cnis8X15Ud9hgwnXVX8RMS/YPyyPoRwTqG3Y2g8IqzGvrwnPTVygCz
         2EPu+l/Bu2emBMGSP01JHYZXyrJWDtzAZSBUhNjle9Vq4IGXg9MbIIetCLlEi2Rj6XFi
         8H6Z8FcKsObEe8f+RgjznaAhLIYlkVxs5AuPnyd24uUg/iUyxMs8f7XDeZiyTynSO/Za
         826f8BLxhOedx08dN424ziGPSX/HOlvPvV/IZoybZfqNql0LMjOvjAUu9wuHES/FOhwC
         hUkA==
X-Gm-Message-State: APjAAAWPqKS/nYlqDmtx38QglxvhGk5SbSdTnO6DHOo+g/8aMx1N9cN0
        hKMTkRCv0oi1z0mV7vdzIYRGJg==
X-Google-Smtp-Source: APXvYqxkwPPDOptyox7XmE/lCLxP8AujzfTr+EZ40zj7c/nzlgkdK9x+bGuWaPNnrb+xsIqFfYBqNQ==
X-Received: by 2002:a05:6638:81:: with SMTP id v1mr16179966jao.143.1581454764728;
        Tue, 11 Feb 2020 12:59:24 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h6sm1308495iom.43.2020.02.11.12.59.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2020 12:59:24 -0800 (PST)
Subject: Re: [PATCH 3/5] io_uring: fix reassigning work.task_pid from io-wq
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1581450491.git.asml.silence@gmail.com>
 <728f583e7835cf0c74b8dc8fbeddb58970f477a5.1581450491.git.asml.silence@gmail.com>
 <4a08cc5a-2100-3a31-becb-c16592905c86@kernel.dk>
 <e60026f7-8e8f-7133-57e3-762a1d84269b@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <82bef6dc-608e-6fde-44fb-58ee517d234d@kernel.dk>
Date:   Tue, 11 Feb 2020 13:59:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <e60026f7-8e8f-7133-57e3-762a1d84269b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/11/20 1:57 PM, Pavel Begunkov wrote:
> On 11/02/2020 23:21, Jens Axboe wrote:
>> On 2/11/20 1:01 PM, Pavel Begunkov wrote:
>>> If a request got into io-wq context, io_prep_async_work() has already
>>> been called. Most of the stuff there is idempotent with an exception
>>> that it'll set work.task_pid to task_pid_vnr() of an io_wq worker thread
>>>
>>> Do only what's needed, that's io_prep_linked_timeout() and setting
>>> IO_WQ_WORK_UNBOUND.
>>
>> Rest of the series aside, I'm going to fix-up the pid addition to
>> only set if it's zero like the others.
> 
> IMO, io_req_work_grab_env() should never be called from io-wq. It'd do nothing
> good but open space for subtle bugs. And if that's enforced (as done in this
> patch), it's safe to set @pid multiple times.

I agree, it'd be an issue if we ever did the first iteration through the
worker. And it'd be nice to make the flow self explanatory in that
regard.

> Probably, it worth to add the check just to not go through task_pid_vnr()
> several times.

Good point, that is worth it on its own.

-- 
Jens Axboe

