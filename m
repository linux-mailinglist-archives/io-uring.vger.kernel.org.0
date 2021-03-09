Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD20E332750
	for <lists+io-uring@lfdr.de>; Tue,  9 Mar 2021 14:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhCINhc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Mar 2021 08:37:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbhCINhS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Mar 2021 08:37:18 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59505C06174A
        for <io-uring@vger.kernel.org>; Tue,  9 Mar 2021 05:37:18 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id t29so9366198pfg.11
        for <io-uring@vger.kernel.org>; Tue, 09 Mar 2021 05:37:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0LpKcdlt4z2mHhfXCoDQTVP3ekKi+fJkKB8E8fijylE=;
        b=X+aro9GjVSpNsj7BkLD6StoJpOOdDJoUiEp/FuDGgbajY+X8k+/p5vMWd6nolxbAZd
         Z65Fiag3CESq5fOk46Oniv+jhCoT2lVAbEjsq/PvF13zHlYQ139vdINQipIOBt6KJI4G
         ztkCPKJW8ZVBub7Sgqhp1krSBjteCdsw9n0OfqG08XOb3IYFZVc5OJoKKkGX+nRdOcGG
         D4ZlSIJyJZn9MQfRkAC8EASv+Own4Qe/YiVYuYKTcApg6JI1m0J3ucUL8nKj1SunkEFI
         txg6Q/4P8iOM+5L8OGD1ACGbhqXGaQTAYh2mPQ7rojKXOh3v9F+7OgZ7UfJvdqH0pX+n
         MwXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0LpKcdlt4z2mHhfXCoDQTVP3ekKi+fJkKB8E8fijylE=;
        b=f4Um/te/1htlodn+ivnoOe1eNEUL8yAoeeRTE2DqmQhlnH90b8xiQ8D2nWS1rWD86W
         ZG8T0JoCsKFiguWdHyGKl/M35t80LBppA5rKNm7fkqK+PMuhv5SQEEVkBB5rFZ9hy3WA
         NanDjtuSTCLpBFyaVtFK8glV5lepvjNWxcGHM4EP+DrUAe8uy1vti35EXjZI7dwQbf6y
         XWevXQ2v4R8dwNDd0mzFWLOMWRHNNz6zocXK88LNCwSQ54nION4oXO8B/WjYMgxO/+vp
         ot0M/3xWr7bssbNuwhR0EGujwvn6Ff4LkYUZwcyFmfeTd2oyuX3KsK1ijY+5hwFPNh0l
         ob2A==
X-Gm-Message-State: AOAM533ehPUAv7n6LQ9jYYDRv6WWXlIDrAptaOTWbkEiBU7vM40NyM3q
        xjRjJHLF9Q/CRbnO0i+KQRP+1w==
X-Google-Smtp-Source: ABdhPJybLH9mOcYpxIhlRdILqk2x7x0ukifgawiBD0zL75ZSMDyO9ed+GtrDc8aozARb2hcYGJoBCg==
X-Received: by 2002:aa7:8f31:0:b029:1f8:987a:53dc with SMTP id y17-20020aa78f310000b02901f8987a53dcmr3598969pfr.58.1615297037858;
        Tue, 09 Mar 2021 05:37:17 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id i10sm14955013pgo.75.2021.03.09.05.37.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Mar 2021 05:37:17 -0800 (PST)
Subject: Re: [PATCH 1/2] io-wq: fix ref leak for req
To:     yangerkun <yangerkun@huawei.com>, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, yi.zhang@huawei.com
References: <20210309030410.3294078-1-yangerkun@huawei.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <fff3e699-a8bd-eb8f-33ad-3c8f228ed302@kernel.dk>
Date:   Tue, 9 Mar 2021 06:37:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210309030410.3294078-1-yangerkun@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/8/21 8:04 PM, yangerkun wrote:
> do_work such as io_wq_submit_work that cancel the work will leave ref of
> req as 1. Fix it by call io_run_cancel.

Looks good, thanks.

-- 
Jens Axboe

