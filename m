Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1D141C390
	for <lists+io-uring@lfdr.de>; Wed, 29 Sep 2021 13:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245692AbhI2Ljy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Sep 2021 07:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245647AbhI2Ljy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Sep 2021 07:39:54 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1425DC06161C
        for <io-uring@vger.kernel.org>; Wed, 29 Sep 2021 04:38:13 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id x20so3683466wrg.10
        for <io-uring@vger.kernel.org>; Wed, 29 Sep 2021 04:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RdJNe1Yq7iF4k+jdNKcQvlZm3nbZyJM3+hjysZYasIM=;
        b=Ol7cGRq/GGY2owJpgEsB7XH9aEToNl3rEzpvdKx3q8lnYnVYn/rdJqB0d+bOEHKqn2
         +//Y0O6R/wfqLJcHNWTtiq8c9MIlqL+Si8f95bGvPY5ythIxsIcH/Up0XMN/rIAFHF+U
         kbavQ6kehKM4xNl/Z9XAuY2XE+vBCSGMvaTgO8xG1z9y8LdO+A+lxFUB+FqMvLdAMoYj
         mpMVw/1uevk/bUMvBMZUTXZT/r1Ncvg34GMV/4ZOpjNgLXABbV8jAPQjQDqe4Cg7k3KQ
         3wpdRXa2JsjqWXw+53bLynclrQ2QS3nPg2zJiHRjOa8iM9frRs6R3fhjZYu1Y7dJohU7
         4apA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RdJNe1Yq7iF4k+jdNKcQvlZm3nbZyJM3+hjysZYasIM=;
        b=akpd8qhPVLgG5iCi4wPs0gLQ+j4qGiStga73MRs74Fe828yyl8q+qCH3NTa6+AHbMQ
         1N1wnHJ/CWxd8wYPq3iwwD+jPE7dSA5QTfQtHzY1gUCpDacf9FGHSp6N7lUsXFlh2ZYy
         OL6bd0SLjxN/vIV8xss+a5B6sartfl1hl3FzaWfr40LLA9T/T7RR+/iDVuuaiyFI6EbF
         M9yzMDbGBqKTBdrZmcBPAakjI+iSgwz7cdyE6s2SluV8kJF3/qUh8gbOHdXWx+cHBif7
         OrHOvqTavDveLCGMoew0nvHsPBOy2WjK9hZBdN5E02gFVRALp0JT+VMVdliz3httAMDv
         uPSA==
X-Gm-Message-State: AOAM531q5Gwi6taZlyC6qZgAi7LoTnqiKP4C7BdSgvXTB6uRt8UENhI8
        NSOQxnUlgigccrnjZe5jgYI=
X-Google-Smtp-Source: ABdhPJxz2pUyoxOEBdu9Bf0BZbdrbpJpqsSANXohEdqkIdaGrv4v9Z32hYWyvcvHEIsZ11pfJHL5Ag==
X-Received: by 2002:a5d:4810:: with SMTP id l16mr6170829wrq.3.1632915491671;
        Wed, 29 Sep 2021 04:38:11 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.229])
        by smtp.gmail.com with ESMTPSA id f123sm1472363wmf.30.2021.09.29.04.38.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 04:38:11 -0700 (PDT)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1619616748-17149-1-git-send-email-haoxu@linux.alibaba.com>
 <1619616748-17149-2-git-send-email-haoxu@linux.alibaba.com>
 <7136bf4f-089f-25d5-eaf8-1f55b946c005@gmail.com>
 <51308ac4-03b7-0f66-7f26-8678807195ca@linux.alibaba.com>
 <96ef70e8-7abf-d820-3cca-0f8aedc969d8@gmail.com>
 <0d781b5f-3d2d-5ad4-9ad3-8fabc994313a@linux.alibaba.com>
 <11c738b2-8024-1870-d54b-79e89c5bea54@gmail.com>
 <10358b7e-9eb3-290f-34b6-5f257e98bcb9@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH RFC 5.13 1/2] io_uring: add support for ns granularity of
 io_sq_thread_idle
Message-ID: <f9c93212-1bc9-5025-f96d-510bbde84e21@gmail.com>
Date:   Wed, 29 Sep 2021 12:37:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <10358b7e-9eb3-290f-34b6-5f257e98bcb9@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/29/21 10:24 AM, Hao Xu wrote:
> 在 2021/9/28 下午6:51, Pavel Begunkov 写道:
>> On 9/26/21 11:00 AM, Hao Xu wrote:
[...]
>>> I'm gonna pick this one up again, currently this patch
>>> with ktime_get_ns() works good on our productions. This
>>> patch makes the latency a bit higher than before, but
>>> still lower than aio.
>>> I haven't gotten a faster alternate for ktime_get_ns(),
>>> any hints?
>>
>> Good, I'd suggest to look through Documentation/core-api/timekeeping.rst
>> In particular coarse variants may be of interest.
>> https://www.kernel.org/doc/html/latest/core-api/timekeeping.html#coarse-and-fast-ns-access
>>
> The coarse functions seems to be like jiffies, because they use the last
> timer tick(from the explanation in that doc, it seems the timer tick is
> in the same frequency as jiffies update). So I believe it is just
> another format of jiffies which is low accurate.

I haven't looked into the details, but it seems that unlike jiffies for
the coarse mode 10ms (or whatever) is the worst case, but it _may_ be
much better on average and feasible for your case, but can't predict
if that's really the case in a real system and what will be the
relative error comparing to normal ktime_ns().

-- 
Pavel Begunkov
