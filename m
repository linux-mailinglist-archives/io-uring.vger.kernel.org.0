Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 356B01F4AFC
	for <lists+io-uring@lfdr.de>; Wed, 10 Jun 2020 03:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbgFJBk7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Jun 2020 21:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbgFJBk6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Jun 2020 21:40:58 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44ED5C05BD1E
        for <io-uring@vger.kernel.org>; Tue,  9 Jun 2020 18:40:57 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id p21so230719pgm.13
        for <io-uring@vger.kernel.org>; Tue, 09 Jun 2020 18:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YMtySUO7w/K0f9BgAi8dXMeTGvk44AxpPJFXfAyxd5s=;
        b=yMOfqkxVX8YmgCuCApay3UL5588vDuFycjTziNhEfAn70laTKprRwb92NEARCnwFM/
         huHxFeNk1Vh11w7Evrxa66EV2xQLFC5Qf7iAbAs3odNHYwfhdNuATn5hapzc6k/Dwuzy
         KofZ1ZJvreXzVPoJyKLDNo0pUOyfOe+uSbpNUnwzVp7O6+ZNmdxcBcgw4uT8tyubwTX5
         Ww3xDAVN63nF+Fo/3LsrxWU+0euBpWPDN2DEQQmgsNAyoJnzHWo36FTrUbFAqUcIBczK
         h8xY9BHCKNowX7Rm3bxnuZSmuGUN2ScLibWdwlwP+XmoIXBBHlIcQk92gb7zK5zPwfPx
         J1ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YMtySUO7w/K0f9BgAi8dXMeTGvk44AxpPJFXfAyxd5s=;
        b=ULmHqQnMujGHVK+iKNKhv2CYyLc82k4A7v1iJoJpa7G/Ds2c3yaQGkC6KcXSM0LXde
         ehgEXCDG6m4Oazr45WUIMRKNY3K0/XM5NDXVRE6PF+9SwyeNt7lSwdDgN9apJvLwFxOQ
         pUz4MyD2y2n8w6tA6S/YhRGR6CVxbS8hNYNIVNOmIvOe1RGT0g1HOtUb65zi9BvbEGdl
         UZeszh1+cD0wsRjMZUZXt3k3Tda9HSfMuAPYSTIsY1mNBOSo5tGQJUnZHZGdrsW/knmt
         ZqVTRuk6ztGDuPX0dr/mDa/8qcF/7UN5LDkU+mKfv4lN7SvvwkYONZ+E2h9rzekQJYKF
         AAyg==
X-Gm-Message-State: AOAM531lVOzEJcUh099+eimlC59eXlRP1ffzFIXmubI+u5fiKmdAtKbt
        D926FYjP15GyX9YcO/Gy2e9stR7zy+N8FQ==
X-Google-Smtp-Source: ABdhPJyh43O/cNt427KUR/80QXOQVUNHdCuxiTQJfajiyqQyPrTkniEg7EaomJ4m713M4wNzO+JN+Q==
X-Received: by 2002:a63:d850:: with SMTP id k16mr671298pgj.136.1591753256314;
        Tue, 09 Jun 2020 18:40:56 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id z23sm9085907pga.86.2020.06.09.18.40.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jun 2020 18:40:55 -0700 (PDT)
Subject: Re: [PATCH v6 1/2] io_uring: avoid whole io_wq_work copy for requests
 completed inline
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200609082512.19053-1-xiaoguang.wang@linux.alibaba.com>
 <c4f10448-0199-85d3-3ab5-b5931dad00f0@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3803a578-a13c-07e7-37f1-fee691dd888f@kernel.dk>
Date:   Tue, 9 Jun 2020 19:40:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <c4f10448-0199-85d3-3ab5-b5931dad00f0@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/9/20 10:44 AM, Pavel Begunkov wrote:
> On 09/06/2020 11:25, Xiaoguang Wang wrote:
>> If requests can be submitted and completed inline, we don't need to
>> initialize whole io_wq_work in io_init_req(), which is an expensive
>> operation, add a new 'REQ_F_WORK_INITIALIZED' to control whether
>> io_wq_work is initialized.
> 
> Basically it's "call io_req_init_async() before touching ->work" now.
> This shouldn't be as easy to screw as was with ->func.
> 
> The only thing left that I don't like _too_ much to stop complaining
> is ->creds handling. But this one should be easy, see incremental diff
> below (not tested). If custom creds are provided, it initialises
> req->work in req_init() and sets work.creds. And then we can remove
> req->creds.
> 
> What do you think? Custom ->creds (aka personality) is a niche feature,
> and the speedup is not so great to care.

Thanks for reviewing, I agree. Xiaoguang, care to fold in that change
and then I think we're good to shove this in.

-- 
Jens Axboe

