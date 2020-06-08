Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D36CD1F2076
	for <lists+io-uring@lfdr.de>; Mon,  8 Jun 2020 22:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgFHUJB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Jun 2020 16:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726415AbgFHUJB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Jun 2020 16:09:01 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8403C08C5C2
        for <io-uring@vger.kernel.org>; Mon,  8 Jun 2020 13:08:59 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id i12so305032pju.3
        for <io-uring@vger.kernel.org>; Mon, 08 Jun 2020 13:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZPvSD/cn68eT7ifSRbFfuqF7ROIGVDjaPDhEcabaPfo=;
        b=bzZPidJY3f90PkBU6ueydiCkInHmyXvA6ohF/lt4qY0QA82DINQu/OBBOE/6AUC15V
         PLYn0pjc9VpIqZDN1DjYN2QbmNh3XKP5V6sfxEEVWSLzt2ctNODKKKix4xB9p8HHGvPc
         xd+KiEGbSgX9g23dKjqqKfoWVCqGi20SPYVLTUetMsett6dbgMlAU1zEXSQ/j2nMqlv4
         weTEz70E+FRftXJbX02AH3vw6JB3w5sjeRTBdjY2jPdIENtSof7JAcrI9/f9Tx8COpSz
         SfZlK4qDjVTW8H5B1YusiFMbWDdlApc50cQ2ns62CuTyRgp8f0dhfF419UcgNtbow+ZO
         IOww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZPvSD/cn68eT7ifSRbFfuqF7ROIGVDjaPDhEcabaPfo=;
        b=W/gqlLnIf+qoiPzJL59uz7HTVt9AFYqK60KYU5In/4Vcx47i3aTy6tyvFCrCjzKKnm
         vQZvVT0Tn4gDcqCTmCE4Jo+zYbGMbu6k9wmrpuLsHuThWTYWh8O9Y8SepCW1CRLJCmyh
         NJGQhZt872nYImfp+Id1fmdWEE9PPHsaBpOQVSRgnfL6jxohWDlMSd30k+UagqPRAFvl
         kzQ3Lp5+rP8xhQ3yNy0VokvaAjC/0dHy0fOyPrlFhAPQlr5CfKhLnPIpdrHLEi2ZKdxJ
         CeIBq2gh4FtUKHBrr7nHXHFw7Ip9LMhxozg9qJB79Cb+e4hizR8x33R4edw3bwPZkbP2
         BKmQ==
X-Gm-Message-State: AOAM530ozxrZLOUh4uoiGFUFVkS0qHmotgF4lkl5LOg+SiVsY/3WXdSi
        x2AgIfblZ711RZ9AubqUbLNEeUTX9jDtxQ==
X-Google-Smtp-Source: ABdhPJz1iVJuVsue6w5LXDgJdHTV+Fn81m7eGSn5v76FAIa4on3b4cgtjfyd3MsVBPJSgYmQhRYBgw==
X-Received: by 2002:a17:90a:f0cb:: with SMTP id fa11mr912377pjb.113.1591646939350;
        Mon, 08 Jun 2020 13:08:59 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id j1sm308206pjv.21.2020.06.08.13.08.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2020 13:08:58 -0700 (PDT)
Subject: Re: [PATCH v5 2/2] io_uring: avoid unnecessary io_wq_work copy for
 fast poll feature
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <a2184644-34b6-88a2-b022-e8f5e7def071@gmail.com>
 <20200601045626.9291-1-xiaoguang.wang@linux.alibaba.com>
 <20200601045626.9291-2-xiaoguang.wang@linux.alibaba.com>
 <f7c648e7-f154-f4eb-586f-841f08b845fd@linux.alibaba.com>
 <8accdc46-53c9-cf89-1e61-51e7c269411c@gmail.com>
 <9f540577-0c13-fa4b-43c1-3c4d7cddcb8c@kernel.dk>
 <13c85adb-6502-f9c7-ed66-9a0adffa2dc8@gmail.com>
 <570f0f74-82a7-2f10-b186-582380200b15@gmail.com>
 <35bcf4cb-1985-74aa-5748-6ee4095acb20@kernel.dk>
 <820263b3-b5e5-bca9-eedb-4ee4e23be2b7@gmail.com>
 <276f5b33-8adc-a664-2490-8d237b719d28@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9db576f8-645f-8c20-e955-a4a701b704e5@kernel.dk>
Date:   Mon, 8 Jun 2020 14:08:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <276f5b33-8adc-a664-2490-8d237b719d28@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/8/20 6:14 AM, Xiaoguang Wang wrote:
> hi,
> 
>> On 08/06/2020 02:29, Jens Axboe wrote:
>>> On 6/7/20 2:57 PM, Pavel Begunkov wrote:
>>>> -#define INIT_IO_WORK(work, _func)				\
>>>> +#define INIT_IO_WORK(work)					\
>>>>   	do {							\
>>>> -		*(work) = (struct io_wq_work){ .func = _func };	\
>>>> +		*(work) = (struct io_wq_work){};		\
>>>>   	} while (0)						\
>>>>   
>>>
>>> Would be nice to optimize this one, it's a lot of clearing for something
>>> we'll generally not use at all in the fast path. Or at least keep it
>>> only for before when we submit the work for async execution.
>>
>> Let's leave it to Xiaoguang and the series of the topic.
> Yeah, I'd be glad to continue this job, thanks.

Perfect! I think io_uring-5.8 (as of now) will be a great base for
that.

-- 
Jens Axboe

