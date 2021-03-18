Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A75C34089E
	for <lists+io-uring@lfdr.de>; Thu, 18 Mar 2021 16:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbhCRPR7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Mar 2021 11:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbhCRPRu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Mar 2021 11:17:50 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE9F9C06174A
        for <io-uring@vger.kernel.org>; Thu, 18 Mar 2021 08:17:50 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id z3so2657445ioc.8
        for <io-uring@vger.kernel.org>; Thu, 18 Mar 2021 08:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ihNrz0h/E7nrUuPmEMnzLA2nKQkLdmZ+DkcUnEAKYxk=;
        b=IccZBqYR3ML/m3DSXzImbxOEYiqPjWLYNHT2R3ni3n8ZuEOfBpaAoTUPG9RZLk84u4
         ivfQLdqaViJUmwNuqRqDEw7LJO9XR3rNOjBa71JYYy0+C4Pg3Xxekz2IiOnvqP/IcbEN
         GeWyNGu5N13RiA6+ym/upRbcX1PATyvoi4NrA8rMQjFV6B6jP0FDCfMiEYnOUEGtkvUp
         5514STKDrNG/UJVxTxUCN0f0somakmpwrkDvtJvS2bzr2YVNYHge9cTSUDlUAcAPIZlP
         esyVR+04cpQUxArDEs+4UIY+vJ4qZ24HUkvaYaK/xnmNGBp955cJ9rlNVxILQB4/bbAD
         1jCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ihNrz0h/E7nrUuPmEMnzLA2nKQkLdmZ+DkcUnEAKYxk=;
        b=Sa0H0kvy3TrXV4t6Pcombon6xbLnq13Ll6yufH3KbhIDRKWeEWRsOhPppmtzhH9/qZ
         PuGX20FRtnR/BSAtvg5ETxoEgksh0qfiFAkuOsUPN+BfDq4vV8bYLaV9R0/+1wXYhP5A
         fiyjn7DIjplDq+pADj0cAn78bAbeqdYGXCwSVXmTVdtLZ/do4aSnTuDQdG20JQEHgeM5
         dyi8oQLlOVcL69Vciu1uOnpV126hUozVjmwJomlx7uwLeTToKQaa/JorzQHz5VmaWV3T
         ntci46MonIu4tZWWZR6PTZYy7548JYg33ZrBId2U4sG5ZBLmsYGR3W3uQLgpm9Kq2PuS
         LD5g==
X-Gm-Message-State: AOAM532Lrpq3EqnY7Si+hqsMS6FhMiyrvZWUkK31wnGHzX0Svb1tSnTd
        VaTPAge4iUts9CsA6NNEfTCV7YKqsipOLA==
X-Google-Smtp-Source: ABdhPJzArwDJOixhExYaS3oDMHHcSTvSIA/myqXeEv7anC2f3+85u/6SJG5jD4ep2baqpjzA3aTRUg==
X-Received: by 2002:a02:662b:: with SMTP id k43mr7168619jac.139.1616080669869;
        Thu, 18 Mar 2021 08:17:49 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id w6sm1235363ilm.38.2021.03.18.08.17.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 08:17:49 -0700 (PDT)
Subject: Re: [PATCH liburing 0/2] cancellation tests
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1615566409.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c9d0929b-454c-9429-184a-0f78dbfad750@kernel.dk>
Date:   Thu, 18 Mar 2021 09:17:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1615566409.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/12/21 9:28 AM, Pavel Begunkov wrote:
> resend 2/2 + two IORING_OP_ASYNC_CANCEL tests in 1/2
> 
> Pavel Begunkov (2):
>   tests: add more IORING_OP_ASYNC_CANCEL tests
>   tests: test that ring exit cancels io-wq
> 
>  test/io-cancel.c | 179 +++++++++++++++++++++++++++++++++++++++++++++++
>  test/ring-leak.c |  65 +++++++++++++++++
>  2 files changed, 244 insertions(+)

Applied, thanks.

-- 
Jens Axboe

