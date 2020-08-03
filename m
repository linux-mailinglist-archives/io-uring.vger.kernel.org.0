Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F144D23AAAC
	for <lists+io-uring@lfdr.de>; Mon,  3 Aug 2020 18:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgHCQlo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 Aug 2020 12:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbgHCQln (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 Aug 2020 12:41:43 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6B8C06174A
        for <io-uring@vger.kernel.org>; Mon,  3 Aug 2020 09:41:42 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id t4so31632289iln.1
        for <io-uring@vger.kernel.org>; Mon, 03 Aug 2020 09:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nhpLwpoY1AwwAZejk5x5rCVH7tFjBnZ3qS3GnDixwmU=;
        b=ouY6593saVhWYd7EgYfvC/YSGLatOfpXGNe3WfMNdA9c9PvHnCh3HCWL/r1Zy8AfJt
         fcMXLJ8qGHYK0IYKlIFXrP9VPAwpgyYL1GbVY2anVRWFmnku3Wm02Y9wq6ngARQ9erbl
         re5C+u234ukIRv24/2cn04md9BTZLArRoZ/dTVLMPLm2camDhJpOqXXbpbe9cfB9tzQ2
         6w18SPQtYwAKV82lHsvP03Q9jEBNyegRuQ9TXpPPGM/HJKnjghGilrQQB5ZgZXobZS5W
         tApzXvyWxzlVYpNbfsYkaWVohzfRI7WR4Wm0aFYUozxfQbnFX++kuzV55hUv0OGe4/Ek
         NP/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nhpLwpoY1AwwAZejk5x5rCVH7tFjBnZ3qS3GnDixwmU=;
        b=gAryNNdA+4tYhGggO5Z0yuy1W//EFzRObB2ZAkvvTNBVQ28ynI+8tjIS25ak2thhX1
         A/BCa+GOrQbV9KFDYNWvpUSvldLvpliIqRtJ7qWrfvnuYBtuSN0GYrGLW+xOE2H++e0a
         2Qvl99BdiZdz5h048RF+bmGuFK7sK+GANPbB4VldWe6nfE/FeSk3oMMUkp2WczmAmKgL
         TkM1Ff3EWblIPu73yznMlz5hL9c3q+DhrF2gHGW2p4duFYvbaT1dKIvkubUxpljEpbyL
         gDYBENIsPNe/hAZLdhFXEbEnxYlwGxfkuCAOb1JY0feENgGUo6+ApE5g3wN7SV85Qxs8
         O1KQ==
X-Gm-Message-State: AOAM533GdUgoTDAzn0dbBpgNLdJ5tr/NenEbinvGg+l4skaMbUQOxyb3
        kFq//QXQQLs+SPTtLCeEczx+7JexqCU=
X-Google-Smtp-Source: ABdhPJwprUfBIIxDylLHlRBF5w9DaUoYfJ+7sTODIAUSuH9+ZJzBWMV5EFik4Qasout11v5xXjdcqw==
X-Received: by 2002:a92:c78b:: with SMTP id c11mr229348ilk.133.1596472902009;
        Mon, 03 Aug 2020 09:41:42 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v63sm5467750ilk.67.2020.08.03.09.41.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 09:41:41 -0700 (PDT)
Subject: Re: [PATCH liburing 1/2] io_uring_enter: add timeout support
To:     Jiufei Xue <jiufei.xue@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org
References: <1596017415-39101-1-git-send-email-jiufei.xue@linux.alibaba.com>
 <1596017415-39101-2-git-send-email-jiufei.xue@linux.alibaba.com>
 <0f6cdf31-fbec-d447-989d-969bb936838a@kernel.dk>
 <0002bd2c-1375-2b95-fe98-41ee0895141e@linux.alibaba.com>
 <252c29a9-9fb4-a61f-6899-129fd04db4a0@kernel.dk>
 <cc7dab04-9f19-5918-b1e6-e3d17bd0762f@linux.alibaba.com>
 <e542502e-7f8c-2dd2-053b-6e78d49b1f6a@kernel.dk>
 <ec69d835-ddca-88bc-a97e-8f0d4d621bda@linux.alibaba.com>
 <253b4df7-a35b-4d49-8cdc-c6fa24446bf9@kernel.dk>
 <fccac1a9-17b6-28ac-728d-3c6975111671@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6b635544-6cd0-742b-896f-2a6bf289189c@kernel.dk>
Date:   Mon, 3 Aug 2020 10:41:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <fccac1a9-17b6-28ac-728d-3c6975111671@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/2/20 9:16 PM, Jiufei Xue wrote:
> Hi Jens,
> 
> On 2020/7/31 上午11:57, Jens Axboe wrote:
>> Then why not just make the sqe-less timeout path flush existing requests,
>> if it needs to? Seems a lot simpler than adding odd x2 variants, which
>> won't really be clear.
>>
> Flushing the requests will access and modify the head of submit queue, that
> may race with the submit thread. I think the reap thread should not touch
> the submit queue when IORING_FEAT_GETEVENTS_TIMEOUT is supported.

Ahhh, that's the clue I was missing, yes that's a good point!

>> Chances are, if it's called with sq entries pending, the caller likely
>> wants those submitted. Either the caller was aware and relying on that
>> behavior, or the caller is simply buggy and has a case where it doesn't
>> submit IO before waiting for completions.
>>
> 
> That is not true when the SQ/CQ handling are split in two different threads.
> The reaping thread is not aware of the submit queue. It should only wait for
> completion of the requests, such as below:
> 
> submitting_thread:                   reaping_thread:
> 
> io_uring_get_sqe()
> io_uring_prep_nop()     
>                                  io_uring_wait_cqe_timeout2()
> io_uring_submit()
>                                  woken if requests are completed or timeout
> 
> 
> And if the SQ/CQ handling are in the same thread, applications should use the
> old API if they do not want to submit the request themselves.
> 
> io_uring_get_sqe
> io_uring_prep_nop
> io_uring_wait_cqe_timeout

Thanks, yes it's all clear to me now. I do wonder if we can't come up with
something better than postfixing the functions with a 2, that seems kind of
ugly and doesn't really convey to anyone what the difference is.

Any suggestions for better naming?

-- 
Jens Axboe

