Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF6A233D84
	for <lists+io-uring@lfdr.de>; Fri, 31 Jul 2020 04:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731161AbgGaC4p (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jul 2020 22:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731124AbgGaC4p (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jul 2020 22:56:45 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5A8C061574
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 19:56:45 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id t15so6415055pjq.5
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 19:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Nl7p5DTpy6cC9DMAur5QHMp5d4uJ9dIHcTaFaVfLvZs=;
        b=U3achbOX5DbbWKd2uzXSef/vVV17zeClgGe5M8dpvIW9PUo3OeRrbKmIzZKWlpwmn9
         uc1qQLpwcDUdByaNaZ1gTvLImIOdNDq7SMhrsfkwwE32359l+HdhU74xrVJahctMH1Hf
         EbBYtPzg0k9VyXU/VdJycC7n8QCgjjcX92swUtxWqt5IvVWnqeYXdGiFzTj1xkJOTE2j
         4IPvxE9Rn+7ZRhUobfvkinmYZiIkKCRglI2JJwf/WnMs9d/HjWDjOs1xXVA8bHHRFomg
         IMLPN3GcdjoRmzUWwzpY+EiuPU1/oV9CcFf8qY7YzqiRIF/cGIlng9PY+BGBfVXlZ++d
         zCpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Nl7p5DTpy6cC9DMAur5QHMp5d4uJ9dIHcTaFaVfLvZs=;
        b=MZQDFUsLfq+f57YTRp2VGBXIn2vvsQr6AsfgMhIHAx6NhYbB7G7RPYkPKs0eMeWAEL
         vl0pWPLMhJopRm9HcffOM1G4tALKNjoSFwrkBqfBszPuAuc9CWJ26210Tbn/pAHH4WTO
         B1zbajJqdET7PX+BgThTXMLPVUj4AN2ZPaaUp9O6Ki9xYxY2K8n0TdS8um3tqD02eEsx
         2uYivv3L7JY3fzmPwxuoZFfZaZRXH/EDlScRQT1a5rci2/kLApEEwCyy9mdx9MjLI5wd
         cVZlf4mhfRNqXKsRz7JUtP30/V0Y2FOBKLm7MfDv6KbYrTQny3Mw/fWzdIySR56WIY23
         04tQ==
X-Gm-Message-State: AOAM531uUgH1b9VHJ8Qx0iMmDymhhOjrqKy6eowVRVsE19/jPEHMeuO/
        vh0rX2wkXXdK1IPP0rACIeos0xYf3To=
X-Google-Smtp-Source: ABdhPJziDbNBd39Ro3Jg6IDBNGsrLYN1oZQz7sWQtO8+YaOpc8HiR+87niSetzmgGB4kpiH8Fh1O8A==
X-Received: by 2002:a62:7705:: with SMTP id s5mr1740180pfc.52.1596164204340;
        Thu, 30 Jul 2020 19:56:44 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id w6sm7763747pgr.82.2020.07.30.19.56.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2020 19:56:43 -0700 (PDT)
Subject: Re: [PATCH liburing 1/2] io_uring_enter: add timeout support
To:     Jiufei Xue <jiufei.xue@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org
References: <1596017415-39101-1-git-send-email-jiufei.xue@linux.alibaba.com>
 <1596017415-39101-2-git-send-email-jiufei.xue@linux.alibaba.com>
 <0f6cdf31-fbec-d447-989d-969bb936838a@kernel.dk>
 <0002bd2c-1375-2b95-fe98-41ee0895141e@linux.alibaba.com>
 <252c29a9-9fb4-a61f-6899-129fd04db4a0@kernel.dk>
 <cc7dab04-9f19-5918-b1e6-e3d17bd0762f@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e542502e-7f8c-2dd2-053b-6e78d49b1f6a@kernel.dk>
Date:   Thu, 30 Jul 2020 20:56:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cc7dab04-9f19-5918-b1e6-e3d17bd0762f@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/30/20 8:12 PM, Jiufei Xue wrote:
> 
> 
> On 2020/7/30 下午11:28, Jens Axboe wrote:
>> On 7/29/20 8:32 PM, Jiufei Xue wrote:
>>> Hi Jens,
>>>
>>> On 2020/7/30 上午1:51, Jens Axboe wrote:
>>>> On 7/29/20 4:10 AM, Jiufei Xue wrote:
>>>>> Kernel can handle timeout when feature IORING_FEAT_GETEVENTS_TIMEOUT
>>>>> supported. Add two new interfaces: io_uring_wait_cqes2(),
>>>>> io_uring_wait_cqe_timeout2() for applications to use this feature.
>>>>
>>>> Why add new new interfaces, when the old ones already pass in the
>>>> timeout? Surely they could just use this new feature, instead of the
>>>> internal timeout, if it's available?
>>>>
>>> Applications use the old one may not call io_uring_submit() because
>>> io_uring_wait_cqes() will do it. So I considered to add a new one.
>>
>> Not sure I see how that's a problem - previously, you could not do that
>> either, if you were doing separate submit/complete threads. So this
>> doesn't really add any new restrictions. The app can check for the
>> feature flag to see if it's safe to do so now.
>> Yes, new applications can check for the feature flag. What about the existing
>
> apps? The existing applications which do not separate submit/complete
> threads may use io_uring_wait_cqes() or io_uring_wait_cqe_timeout() without
> submiting the requests. No one will do that now when the feature is supported.

Right, and I feel like I'm missing something here, what's the issue with
that? As far as the application is concerned, a different mechanism may be
used to achieve the timeout, but it should work in the same way.

So please explain this as clearly as you can, as I'm probably missing
something...

>>> Oh, yes, I haven't considering that before. So could I add this feature
>>> bit to io_uring.flags. Any suggestion?
>>
>> Either that, or we add this (and add pad that we can use later) and just
>> say that for the next release you have to re-compile against the lib.
>> That will break existing applications, unless they are recompiled... But
>> it might not be a bad idea to do so, just so we can pad io_uring out a
>> little bit to provide for future flexibility.
>>
> Agree about that. So should we increase the major version after adding the
> feature flag and some pad?

I think so, also a good time to think about other cases where that might be
useful.

But I think we need to flesh out the API first, as that might impact things.

-- 
Jens Axboe

