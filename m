Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20CAB34462F
	for <lists+io-uring@lfdr.de>; Mon, 22 Mar 2021 14:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbhCVNtS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Mar 2021 09:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbhCVNtN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Mar 2021 09:49:13 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B087C061574
        for <io-uring@vger.kernel.org>; Mon, 22 Mar 2021 06:49:13 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id g10so6611110plt.8
        for <io-uring@vger.kernel.org>; Mon, 22 Mar 2021 06:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=4uhVMeQrNJsh8he0ZChdwyQ6hvs0OQDby+oyyHh+9uE=;
        b=fioRRRqkuH+g3CK3QwFVfcJAafpZ1qgutZo6kfsPEwUQt9WPyqR1qcJyErKAHrCk0J
         MZeCSpGIiyZG7UgoSaC2LSSftj5LcKwZEnK0QyI2e9QHZscY3xpWih/BrctndTY6u8LZ
         Wj+ZNqPZsZ1CIKjP+kAizxw9Md+1XHdQibIqHxW5ApAc0ZOegAD3JERYg1a+A/F2LPRg
         OgYA2RhNeKaCBGghTUOAbisdcYIiSOj29LtBod7zxJwIwmm8sGCeSJreAA+QtIKwap0Y
         B5Cf76MwYhGDIAY8vVnd+gRmXLRC5+IGk3ziLpWcqH8fipiNYcVhidWNAk1e2LWmfoo8
         2TqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4uhVMeQrNJsh8he0ZChdwyQ6hvs0OQDby+oyyHh+9uE=;
        b=TiY3y67h48vwWgsOghEhq+PrN52gIOq+s2/dJ2naTg+zJ8I8B8NuVKfPAX3HtddTmb
         cwnd/+ePXHegBD+RZYGTOKJxozckppdBV0ggyqc4jEAxtrdfTkiJ7KMOdIPszjzyvKPa
         taiClFN+Cjvti+MgUfhYzAFeFRBI64pKJsCLrAeCUxWUFFM2jl0vL8pxT4wHPfUwxNd2
         UdonO2j9wytd1PoCR+KFfrjFtcNlcPzhljb5vrLbi7KJ1pSthE+hULSJNg5DplkfzwN3
         rtIhOh2Fs9P1kkgqgCOLVC4dzZVDMtMInmqq57fAOOLjWqFkIuKd06Zk2eqF9gMN+ifM
         3FNQ==
X-Gm-Message-State: AOAM532SLrR44KeWGZ2fJwHCZ47YgwYTXSMNCcl8vKbo/uonbFIUZ8N7
        zTZYxyBroDkbyuZRYk0IGBGKuy+7LnYfIQ==
X-Google-Smtp-Source: ABdhPJzGJMalb4xEX69zXBay3WOm5E8lkj1rzRVUjzhxcDAu3ASid4hL/vCJzj4subVt71fIfyvDEQ==
X-Received: by 2002:a17:902:bd0b:b029:e5:f913:8c95 with SMTP id p11-20020a170902bd0bb02900e5f9138c95mr27064968pls.84.1616420952664;
        Mon, 22 Mar 2021 06:49:12 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id g18sm13825612pfb.178.2021.03.22.06.49.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Mar 2021 06:49:12 -0700 (PDT)
Subject: Re: [PATCH 5.13 00/11] yet another series of random 5.13 patches
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1616378197.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3c370b2e-7ad7-9bf9-3afc-07f32d824c6f@kernel.dk>
Date:   Mon, 22 Mar 2021 07:49:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1616378197.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/21/21 7:58 PM, Pavel Begunkov wrote:
> Random improvements for the most part, 8-11 are about optimising rw and
> rw reissue.
> 
> Pavel Begunkov (11):
>   io_uring: don't clear REQ_F_LINK_TIMEOUT
>   io_uring: don't do extra EXITING cancellations
>   io_uring: optimise out task_work checks on enter
>   io_uring: remove tctx->sqpoll
>   io-wq: refactor *_get_acct()
>   io_uring: don't init req->work fully in advance
>   io_uring: kill unused REQ_F_NO_FILE_TABLE
>   io_uring: optimise kiocb_end_write for !ISREG
>   io_uring: don't alter iopoll reissue fail ret code
>   io_uring: hide iter revert in resubmit_prep
>   io_uring: optimise rw complete error handling
> 
>  fs/io-wq.c    |  17 +++----
>  fs/io_uring.c | 128 +++++++++++++++++++++++++-------------------------
>  2 files changed, 72 insertions(+), 73 deletions(-)

Applied - apart from 3/11, which I think is a bit silly.

-- 
Jens Axboe

