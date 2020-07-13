Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 982A121D7F6
	for <lists+io-uring@lfdr.de>; Mon, 13 Jul 2020 16:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730028AbgGMOLh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jul 2020 10:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729782AbgGMOLg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jul 2020 10:11:36 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E2FCC061755
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 07:11:36 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id k5so6313911pjg.3
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 07:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=E5YrUYeH9bksQKwP5x56t7ynpO3MqgPfl74AqooGFcU=;
        b=BkS2knp5aUVmo+4oB0268gcWsFQfpDwcHln51KJOKsJ51OFiNUc23lvOIV90VISu7Q
         +/muUatgcm5uMhLAX5+aXhPJavUoFEcDRMzxsoPEj/HEXALNbtSqu8UJfQj5YxItuco9
         XYIOTzBLb23N8ZwjTMs2o+HX86H+bzytQFdAN4IOy/wDJe5FT/xzN0rhqUH/qLOa8tfI
         JEawTdj7Iyllxn4Qfh2cKer1Rgy1MfjiFkNCFaVFacXd6FweKHkF5Sx1oCYYDBbI7N0Y
         uLR7y5L6hisqRd+MYBLYFdimalnHFrKie89aPhfseRGOkXN4Y0fIfKd+3tTRrWvKKO9z
         7qiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E5YrUYeH9bksQKwP5x56t7ynpO3MqgPfl74AqooGFcU=;
        b=LpjlSDLWyy++FbFkJIi3xJGIY/X8CYHELtTVnmXNB164R/nH3EMsAEEJEhM6LZsUPl
         LABtcZE0zR71dEG8ao4fRdCR12qNweGGnsXLldcPgkQGPvNbwUC7xrYRCH1wV+MX6wOl
         flB88bxEHKNt/SyMLTT6H0BFSb1gpF7qgfllpoGiaJOx7Je9lrpPUCuOLpkc1CK2Bvcm
         GEOt1rCqkQvB45m6/mDgsWX0ZxZpt16hRgtD/azlR2OPS8XvUoXUM4G+QO5Oo/6v9e3g
         lWox/XcwWFuvSJ7oNd+5dk6dx1azefxAlngDVnQ/Fc1LnFqP5px/6vzTkYiEqRJ1joLS
         e77w==
X-Gm-Message-State: AOAM533FA3Lb+w4RZDH1GaRCrElwtkQtpVFnDYAPPQAt3rVRwbfGkG9e
        dCwmnyTuAUMXpMbGPEXu7vBnTTC4lGOErQ==
X-Google-Smtp-Source: ABdhPJweycGIhhHPcOK71W/c7YvAPgcEBp43V9whEzDZy6IZyIRZptRAocyOTcMOCIsf9kLmUzAMyA==
X-Received: by 2002:a17:90b:3750:: with SMTP id ne16mr20174354pjb.6.1594649495461;
        Mon, 13 Jul 2020 07:11:35 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id z11sm14736823pfk.46.2020.07.13.07.11.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2020 07:11:34 -0700 (PDT)
Subject: Re: [PATCH 5.9] io_uring: replace rw->task_work with rq->task_work
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <6cd829a0f19a26aa1c40b06dde74af949e8c68a5.1594574510.git.asml.silence@gmail.com>
 <5356a79b-1a65-a8bb-2f21-a416566bad1a@kernel.dk>
 <494e8054-38dc-4987-e82b-00edeb70400c@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9a16ad22-bdf6-45b4-f6bc-803719d86a94@kernel.dk>
Date:   Mon, 13 Jul 2020 08:11:32 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <494e8054-38dc-4987-e82b-00edeb70400c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/13/20 2:03 AM, Pavel Begunkov wrote:
> On 12/07/2020 23:29, Jens Axboe wrote:
>> On 7/12/20 11:42 AM, Pavel Begunkov wrote:
>>> io_kiocb::task_work was de-unionised, and is not planned to be shared
>>> back, because it's too useful and commonly used. Hence, instead of
>>> keeping a separate task_work in struct io_async_rw just reuse
>>> req->task_work.
>>
>> This is a good idea, req->task_work is a first class citizen these days.
>> Unfortunately it doesn't do much good for io_async_ctx, since it's so
>> huge with the msghdr related bits. It'd be nice to do something about
>> that too, though not a huge priority as allocating async context is
> 
> We can allocate not an entire struct/union io_async_ctx but its particular
> member. Should be a bit better for writes.

Right, we probably just need to turn req->io into a:

	void *async_ctx;

and have it be assigned with the various types that are needed for
async deferral.

> And if we can save another 16B in io_async_rw, it'd be 3 cachelines for
> io_async_rw. E.g. there are two 4B holes in struct wait_page_queue, one is
> from "int bit_nr", the second is inside "wait_queue_entry_t wait".

An easy 8 bytes is just turning nr_segs and size into 32-bit types. The
size will never be more than 2G, and segs is limited at 1k iirc.

-- 
Jens Axboe

