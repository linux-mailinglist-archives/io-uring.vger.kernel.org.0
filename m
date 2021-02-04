Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63DF430F89A
	for <lists+io-uring@lfdr.de>; Thu,  4 Feb 2021 17:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237133AbhBDQxk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Feb 2021 11:53:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238192AbhBDQwi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Feb 2021 11:52:38 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35118C0613D6
        for <io-uring@vger.kernel.org>; Thu,  4 Feb 2021 08:51:58 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id v15so4342669wrx.4
        for <io-uring@vger.kernel.org>; Thu, 04 Feb 2021 08:51:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hHsVyvfLdYO91mdKh8vfyno0dUQF8KrgzEVOarEyeIc=;
        b=j1b9rPTGi1P8wct43UxlQ+jDurknl4YM8gR8xfYWm01IToNfePH4VlGRocss2pej10
         zqp4A1eW7qYXWjo0vivhAjQFyQCL94wS2yaETxvtBbZfZdN38p72nJVomjjuAyw0XBEG
         lzcP2tyPh7tK2VaUY/ncVEfzbCLa3xm6wrZPL9ttUPnFbXEd56HSlLGeFCv3gQGdxCFg
         LCUlNkGyeqq0QKCUgcaHJ85klHqyAQZLZ1bXniiM0U9UHwYwQZv39QqrZBr3nAAbskTm
         g6fcIkXR1DMYxhsYNKYZf3eW1oX552v3pemRDB2EVKs2G/J98aex21wJpg+k3Csg2Cqk
         IUAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=hHsVyvfLdYO91mdKh8vfyno0dUQF8KrgzEVOarEyeIc=;
        b=VBjqWtxOyISdNHb41bYpLkuESyqMTHFtT2TvBWprLruwYkOx0ywR3v3hGU5QWypX9P
         y46yuTf0M05iTQcuQgWZK84N1eCIuhg53yGAfFI2Q5YMq1Iw/MvbIcFLCO5eLFm2LUF6
         eJ56+iuqRApDcqxflpr8y3VRjtz+vyFwFyWEYBUc5U2IyK46h+6baxylEBeeJ1hKScri
         GDThgYsffmMkrL8gTWPfROeoWU/Sjr+MIaUdi4c8+31ivYu9EA+dVCLqZIeGci0Va01J
         jV0oE/RN7TnET62HZjOdLevcUXeHYMDGCVF8JrY0oKhM/rL5vK7BKPAXcGK85sKid3rk
         FkLw==
X-Gm-Message-State: AOAM530jgJW5fXrPG8jiOpM1uecBSckHT9Sk7s7pEnVb5voiCoJyOr5C
        lrzIi/DLW4pCj9Yj3G1ofqQ=
X-Google-Smtp-Source: ABdhPJzw4DH5sUx8PEWK0AEsI8TMAt8SCMXEMONbzLJkJUaan5WnV567bRfse5V1+e0Im9jOWyCdwA==
X-Received: by 2002:a05:6000:10cd:: with SMTP id b13mr221832wrx.163.1612457517004;
        Thu, 04 Feb 2021 08:51:57 -0800 (PST)
Received: from [192.168.8.175] ([148.252.133.145])
        by smtp.gmail.com with ESMTPSA id y18sm8897158wrt.19.2021.02.04.08.51.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 08:51:56 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix possible deadlock in io_uring_poll
To:     Jens Axboe <axboe@kernel.dk>, Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1612295573-221587-1-git-send-email-haoxu@linux.alibaba.com>
 <9d60270f-993b-ba83-29a0-ce6582c383e0@gmail.com>
 <5f0db9bc-700a-e0f5-a77c-9acfe4e56783@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <0c7cfa8b-5c32-7b00-e312-936df68553a2@gmail.com>
Date:   Thu, 4 Feb 2021 16:48:13 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <5f0db9bc-700a-e0f5-a77c-9acfe4e56783@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 03/02/2021 01:48, Jens Axboe wrote:
> On 2/2/21 5:04 PM, Pavel Begunkov wrote:
>> On 02/02/2021 19:52, Hao Xu wrote:
>>> This might happen if we do epoll_wait on a uring fd while reading/writing
>>> the former epoll fd in a sqe in the former uring instance.
>>> So let's don't flush cqring overflow list when we fail to get the uring
>>> lock. This leads to less accuracy, but is still ok.
>>
>> if (io_cqring_events(ctx) || test_bit(0, &ctx->cq_check_overflow))
>>         mask |= EPOLLIN | EPOLLRDNORM;
>>
>> Instead of flushing. It'd make sense if we define poll as "there might
>> be something, go do your peek/wait with overflow checks". Jens, is that
>> documented anywhere?
> 
> Nope - I actually think that the approach chosen here is pretty good,
> it'll force the app to actually check and hence do what it needs to do.

Ok, seems we agree on that.

Hao, can you send an updated patch?

-- 
Pavel Begunkov
