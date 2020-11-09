Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADECA2ABEE9
	for <lists+io-uring@lfdr.de>; Mon,  9 Nov 2020 15:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729854AbgKIOl1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Nov 2020 09:41:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729850AbgKIOl0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Nov 2020 09:41:26 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A781DC0613CF
        for <io-uring@vger.kernel.org>; Mon,  9 Nov 2020 06:41:26 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id u19so10018684ion.3
        for <io-uring@vger.kernel.org>; Mon, 09 Nov 2020 06:41:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JhZOVWatsy639F6RTDZhSbbbaMM1EfIgQ+DydkW4KKc=;
        b=A59upxkRmY0+1p8sJgD+dIYtaWdbr8uR4RTeAn+sSma3eNyIIg6OKN+uwETIbFvyOH
         rlnqdls9AGJb9kr4HCRWwyDJhPtABUBIITwTs/xOnxPJPF3JOARTekBqK1Y/HIyr95ym
         RPfkSXh3Sl44lH84bSh8G1Nkvrp4TPJveKqKSZng8K+tKMWQ8gE7qlFnYM68HJR8H2Fs
         +HezZbjncK7VA3JM6lDPZHqTYd/YOTZIRqGRu33+XS0OG+u2+AlyIv+0LZ8EvwMKR9dE
         i/Vayc2DHf7dITPFmcSrC3dHks6RSbkK3xa7mUu9pJ+eWR8rbcE6ggZ41SIw0MWEvy6v
         ly2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JhZOVWatsy639F6RTDZhSbbbaMM1EfIgQ+DydkW4KKc=;
        b=oo1CXqFHomjXqDVNyUPrt7BVXU8lm1yVT6R44qolaGcCiRCQ95fHL/e95FALexPHTc
         BXNQCVTSfEtcwtHatjpFcwgYOKVCvcCnUXNBjhFRRAqQgwKpSI6uwsTXhbgartryIhZD
         rhCOqIRXbhYbpNdKw1BnQB3BeKa67eBUXrMiKTjh51185FVgLPF8Sb0wKLGN64irW/D9
         uxkziI2SLGBnJveESi2G6jKg//NG1t2RCKAd/ipP3M7sXvkM0QL/AQngFMhbGjevRp9Y
         spJv3K/wcdpvb0Mw+OiEy7bEz3r79j+rB0L1w0xMpMYhMeGvfNQp/8GaxSKWbFB0K1iU
         vvPQ==
X-Gm-Message-State: AOAM531yPpjDfDSTqqaKGJbfZV6WpFIXQSNZRXEfQBTvBZ1hfptqbfLn
        oaQt8hzfwPH7oUVchtBmCRDf+1ds3c8xJw==
X-Google-Smtp-Source: ABdhPJzVk13eUojZJobNU8UKPPIXsEnDIDiyVbNMzjaD8+otc6IJgu45FJ7okRIyhR2NJw9pI13Rlw==
X-Received: by 2002:a05:6602:14c3:: with SMTP id b3mr10151840iow.100.1604932886028;
        Mon, 09 Nov 2020 06:41:26 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id b9sm3088303ila.51.2020.11.09.06.41.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2020 06:41:25 -0800 (PST)
Subject: Re: [PATCH] io_uring: don't take percpu_ref operations for registered
 files in IOPOLL mode
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200902050538.8350-1-xiaoguang.wang@linux.alibaba.com>
 <2eb73693-9c40-d657-b822-548ddd92b875@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <764234cf-ab08-7ccf-f4b6-b0a2f5ae6cbc@kernel.dk>
Date:   Mon, 9 Nov 2020 07:41:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2eb73693-9c40-d657-b822-548ddd92b875@linux.alibaba.com>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/4/20 8:20 PM, Xiaoguang Wang wrote:
> hi,
> 
>> In io_file_get() and io_put_file(), currently we use percpu_ref_get() and
>> percpu_ref_put() for registered files, but it's hard to say they're very
>> light-weight synchronization primitives, especially in arm platform. In one
>> our arm machine, I get below perf data(registered files enabled):
>> Samples: 98K of event 'cycles:ppp', Event count (approx.): 63789396810
>> Overhead  Command      Shared Object     Symbol
>>     ...
>>     0.78%  io_uring-sq  [kernel.vmlinux]  [k] io_file_get
>> There is an obvious overhead that can not be ignored.
>>
>> Currently I don't find any good and generic solution for this issue, but
>> in IOPOLL mode, given that we can always ensure get/put registered files
>> under uring_lock, we can use a simple and plain u64 counter to synchronize
>> with registered files update operations in __io_sqe_files_update().
>>
>> With this patch, perf data show shows:
>> Samples: 104K of event 'cycles:ppp', Event count (approx.): 67478249890
>> Overhead  Command      Shared Object     Symbol
>>     ...
>>     0.27%  io_uring-sq  [kernel.vmlinux]  [k] io_file_get
> The above %0.78 => %0.27 improvements are observed in arm machine with
> 4.19 kernel. In upstream mainline codes, since this patch
> "2b0d3d3e4fcf percpu_ref: reduce memory footprint of percpu_ref in
> fast path", I believe the io_file_get's overhead would be further
> smaller. I have same tests in same machine, in upstream codes with my
> patch, now the io_file_get's overhead is %0.44.
> 
> This patch's idea is simple, and now seems it only gives minor
> performance improvement, do you have any comments about this patch,
> should I continue re-send it?

Can you resend it against for-5.11/io_uring? Looks simple enough to me,
and it's a nice little win.

-- 
Jens Axboe

