Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C99402C02
	for <lists+io-uring@lfdr.de>; Tue,  7 Sep 2021 17:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345588AbhIGPiR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Sep 2021 11:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345456AbhIGPiN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Sep 2021 11:38:13 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F93C06175F
        for <io-uring@vger.kernel.org>; Tue,  7 Sep 2021 08:37:07 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id q3so13404518iot.3
        for <io-uring@vger.kernel.org>; Tue, 07 Sep 2021 08:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KsuXzBmPfVajtVJ/Rd1XoqqEntzzcw9VBlIq5V0DkPY=;
        b=w8fSh/Kt1mL9GzuzQ+pb2sgc0Yzy4T8QY8278cmUqsAtbQADeqK1Y9HPdWOdcdfBha
         j6soU1dCK8jTmK7sRFxWt3HvGtpoq6AlLVe/GsMZu78+8YsRVPAjW5bqujJ59K5tcHti
         qCJOO0pwhtX0x22K7P93oJ5Zv3g0PdDYUGBRcI9Lx9WSoUCPSBhGp/ghdtNGB91utE64
         GApyXGoFpksNd2UG9c4oAAtXjfzzrIZLNW1zRWM9AZnN/iUh4rMN0AnvTBXDw0D6pdJa
         6JI3JM92yjt+odbAWIPOH2f69H8VwhQ6fiJ8/IdLtQiNwMEuUjgvzmqH4LRcRZjzG22m
         Y37A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KsuXzBmPfVajtVJ/Rd1XoqqEntzzcw9VBlIq5V0DkPY=;
        b=IuyUtMszCcfMpQ+MSCgB5kepsMXcuFL33jDMw3QdDcrVN0X7uBAAo3+0icmQKfgMtz
         hNR5FRYW63357EW8JHD90/hVfA4FnvVMKuRa4CilVrTJ7tI1UnnsCtMlsNrExydvswlr
         FazACNiYx7r9pJ5lj/9mmaQDerHUdqii3q7GA3rUcLXFKS0DuReFTKrUwFxS4q94U0tH
         Yp5cs+7/Na+D2bEGXFXi5bdmz5aaj/t69ZkO8KYGgjs7bnkhsfhWECGAECN5X4X84I2G
         ByKpyQEG4fMbbzn+ykX+W3GDO1MG10p1B+4e903BQIk8oWlII6d9M+kb69yn3GB/0Fs3
         Vj8A==
X-Gm-Message-State: AOAM5309Rsgo7dhe/NrCowWcC22XZuyEDLfGUPIeO9lTKfeN7SHWNQxH
        It3u7YumnywMbtNrAisuqEIIKgh64iUiNw==
X-Google-Smtp-Source: ABdhPJy9TIx8DeYEikYAU7Xjo18xUVAwAu1/8+ktEKEhnVPoBNDCuSFXNZvNMRp1lgHcdcf3ej+38g==
X-Received: by 2002:a6b:7106:: with SMTP id q6mr14994380iog.174.1631029026756;
        Tue, 07 Sep 2021 08:37:06 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id s18sm7341404iov.53.2021.09.07.08.37.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Sep 2021 08:37:06 -0700 (PDT)
Subject: Re: [PATCH] io_uring: check file_slot early when accept use fix_file
 mode
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210907151653.18501-1-haoxu@linux.alibaba.com>
 <3ca81c51-87fb-2f1d-f3f7-92abafdd5cca@kernel.dk>
 <1cff2f6f-d979-f667-180f-b09d548aa640@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <bce206fe-46d9-7c84-c18c-68ef6210aa35@kernel.dk>
Date:   Tue, 7 Sep 2021 09:37:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1cff2f6f-d979-f667-180f-b09d548aa640@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/7/21 9:32 AM, Hao Xu wrote:
> 在 2021/9/7 下午11:24, Jens Axboe 写道:
>> On 9/7/21 9:16 AM, Hao Xu wrote:
>>> check file_slot early in io_accept_prep() to avoid wasted effort in
>>> failure cases.
>>
>> It's generally better to just let the failure cases deal with it instead
>> of having checks in multiple places. This is a failure path, so we don't
>> care about making it fail early. Optimizations should be for the hot path,
>> which is not a malformed sqe.
> I have a question here: if we do do_accept() and but fail in
> io_install_fixed_file(), do we lose the conn_fd return by do_accept()
> forever?

We do. The file is put and everything, so we're not leaking anything.
But the actual connection is lost as the accept request failed.

-- 
Jens Axboe

