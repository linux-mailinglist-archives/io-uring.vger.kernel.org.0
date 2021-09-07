Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA5B402C16
	for <lists+io-uring@lfdr.de>; Tue,  7 Sep 2021 17:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345325AbhIGPpK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Sep 2021 11:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235162AbhIGPpK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Sep 2021 11:45:10 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4DDFC061575
        for <io-uring@vger.kernel.org>; Tue,  7 Sep 2021 08:44:03 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id b4so10481182ilr.11
        for <io-uring@vger.kernel.org>; Tue, 07 Sep 2021 08:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Z2yv1Gdemc/IZaLbpwK0cETDQmdaSuoMHc1tJKTVp4M=;
        b=dnfl21splvd5wknASWpMylanLJsB5q0m0YIrV0YbfAvTZwgCeYWREH4Tt9VmoDDGvp
         2g3JkeCdYtXUTPlnF4NSBY73SIZHvvuyH841x8vpjQ8emj8wfK3SNKWut4jg/75yoO5m
         fAPCIiVuSBiFJOTuNm0hAN7+9TYm9HkX0yXb6SFv8RERVLy4YUOdtkA+MA9J1YBg8cae
         +ve2NPO/KwVYZbIoBFzOhaM4Xg8W1Vib67qyQ6j0JBk4TF3HJMY1Jl03RfBiWU7PLWLS
         8DedXJJ+5ztMRzNnitkGvfJNFYJt8THCCq2+nOqcxBXLvMqUwDKGRvL+JLTr9gElCvWZ
         +wuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z2yv1Gdemc/IZaLbpwK0cETDQmdaSuoMHc1tJKTVp4M=;
        b=tomStd7Sn6TrB6hw4C8RvHYIX9QQdlrt5cv5FhV4f/TQuVfzVbElYthMwZZB8RY5uM
         OIGq0IuvpyrNZbpVHqp2hPoFeNfWtC9+llry1nYWw0tuUVHa4ikK6daXI/BfAtQgS6Kx
         M3oWXEcjb1TGgOJtnmUqcXrFCrb598wUEmjYDI87YiWD1mRI1dCsdMKDc1wd/sPrAGQp
         i7YHvrxaORjeUTECUUfC9MSnVjT9noO+4p+Xlvq0k58Ntq7M6fbrdNFYBVkKq3F77Hly
         OIaBWyFmF6CGnHrcvONQ6cxcIDsrRGgMlQgeExX8ISxFU5JnM7QOXfzUG2/gzBbLhH+V
         tA0w==
X-Gm-Message-State: AOAM531BgBCKbp2YeOw4TFZ9gbbTVsnA8262Cq/0B3DcVThaqRf9NCV4
        EXaFvWbTjizoiHM/X+PD9is4HPwW+VOdEw==
X-Google-Smtp-Source: ABdhPJzpgwncu1ouVc0XmnftV8RdVk8ATpmlKikhiOiKhad8wY5GseCGdvoJ0UEx3z6k7B6Nrxu1sA==
X-Received: by 2002:a92:d752:: with SMTP id e18mr13027105ilq.254.1631029443247;
        Tue, 07 Sep 2021 08:44:03 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id c5sm6455780ilk.48.2021.09.07.08.44.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Sep 2021 08:44:02 -0700 (PDT)
Subject: Re: [PATCH] io_uring: check file_slot early when accept use fix_file
 mode
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210907151653.18501-1-haoxu@linux.alibaba.com>
 <3ca81c51-87fb-2f1d-f3f7-92abafdd5cca@kernel.dk>
 <1cff2f6f-d979-f667-180f-b09d548aa640@linux.alibaba.com>
 <bce206fe-46d9-7c84-c18c-68ef6210aa35@kernel.dk>
 <4b31782a-dab8-3479-4f79-20d9dfed730e@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3616d177-effe-d567-9bb7-1d7ef62e8aed@kernel.dk>
Date:   Tue, 7 Sep 2021 09:44:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <4b31782a-dab8-3479-4f79-20d9dfed730e@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/7/21 9:42 AM, Hao Xu wrote:
> 在 2021/9/7 下午11:37, Jens Axboe 写道:
>> On 9/7/21 9:32 AM, Hao Xu wrote:
>>> 在 2021/9/7 下午11:24, Jens Axboe 写道:
>>>> On 9/7/21 9:16 AM, Hao Xu wrote:
>>>>> check file_slot early in io_accept_prep() to avoid wasted effort in
>>>>> failure cases.
>>>>
>>>> It's generally better to just let the failure cases deal with it instead
>>>> of having checks in multiple places. This is a failure path, so we don't
>>>> care about making it fail early. Optimizations should be for the hot path,
>>>> which is not a malformed sqe.
>>> I have a question here: if we do do_accept() and but fail in
>>> io_install_fixed_file(), do we lose the conn_fd return by do_accept()
>>> forever?
>>
>> We do. The file is put and everything, so we're not leaking anything.
>> But the actual connection is lost as the accept request failed.
> Does that cause any problem, since from client's perspective, connection
> is builded, and there is no way for the server to close it.

Maybe? But it's a program error, it's asking to accept a connection at a
slot which is invalid. It kind of gets to keep the pieces in that
particular case.

-- 
Jens Axboe

