Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF1242DB4F
	for <lists+io-uring@lfdr.de>; Thu, 14 Oct 2021 16:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbhJNOUi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Oct 2021 10:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbhJNOUh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Oct 2021 10:20:37 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B732BC061570
        for <io-uring@vger.kernel.org>; Thu, 14 Oct 2021 07:18:32 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id u18so20108537wrg.5
        for <io-uring@vger.kernel.org>; Thu, 14 Oct 2021 07:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=T0c2HX1dHIEYlaQ/l7IjldcFuUPf9MvDtxKJbA1LM0Q=;
        b=SSFub634F2fr7IU0XFmRhxo3uGin1Gkc6CLk4B1HCHIRrRxnYBKDXTcRiE+Ou6XYUb
         eQTl4r8JdHCWm1lHYsNq5mnrP/4+DGhPWA7pvAG7ZRmZIhnJbyrLwwGlmlK7rK0P5yS6
         2Kis8+dYjM4hEG3nPn22sCzLXPXTSr0M5UQewhgXCSKPiKd/wJKlXqLY+1NsvUf1G/gL
         CPKAhBCdYf9FkNk0n9P5UiBYfA+bZDjXv0GfohlffcGQOtcEYQjvpQd5zNXIBYxpa19/
         htrZ+ii6SENH8EzZZYxUHxeTzWcIqPr4tN6XZ+tW+4jozDhZBOnS9vVAPk48KgW+22Iq
         u89g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=T0c2HX1dHIEYlaQ/l7IjldcFuUPf9MvDtxKJbA1LM0Q=;
        b=ZZ9xGZZpmBIBUgjzDLNzAkf95yZMgbw4JdPjEKsvhPcx7t0tcbgRXISJzZTxTsr66V
         MnkD7HhrtJWvb2/y4OGCZwEp3Zgttz0ok8rklHjrbQWu08DfjAj0TbKp79B6yESaIqvZ
         HQUPLUtHmGl0cUZUEmHiuJNVLSe8vrv10U6aEWijL1kS0//uAwscedR1AWSoGBfTVxPl
         L1PiV+J25GURugVhETXrcMUbLTWSsfM0jH/0PJ76rqYkZQYpocVIcuzlw2rt+7GPbe2d
         TEjyHX7o8mppLCnXwtag/FvHtUzlnByp7rAAA7kFxD1R8uOxb/8pAiq2JpthTB8+s3Od
         qR/A==
X-Gm-Message-State: AOAM532SMDUL/bwJyOh+1cSUGzvPo/HHno2HwnRV5Ql/RkF+89qJZaL9
        QyUpHWRHFL5pYGE3HWeco7g=
X-Google-Smtp-Source: ABdhPJwpW6L9u2sAB2V0rz6SY3YNqOARwQ7YemavLISkCDnh46CKQ1n96kkhcPO4ifZSYTn/ypB9cQ==
X-Received: by 2002:a5d:5889:: with SMTP id n9mr7206419wrf.248.1634221110886;
        Thu, 14 Oct 2021 07:18:30 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.145.214])
        by smtp.gmail.com with ESMTPSA id o6sm3602719wri.49.2021.10.14.07.18.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 07:18:30 -0700 (PDT)
Message-ID: <fd338e32-3438-02bf-a7f2-47ce8803ffb5@gmail.com>
Date:   Thu, 14 Oct 2021 15:17:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [PATCH for-5.16 0/2] async hybrid, a new way for pollable
 requests
Content-Language: en-US
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211008123642.229338-1-haoxu@linux.alibaba.com>
 <57f4b76d-6148-98e2-3550-8fde5a4638f7@gmail.com>
 <c0602c8a-d08d-7a0d-0639-ac2ca8d836b1@linux.alibaba.com>
 <16da92ff-39a5-2126-0f12-225017d4d825@gmail.com>
 <9568b6b5-491b-977a-0351-36004a85bf4c@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <9568b6b5-491b-977a-0351-36004a85bf4c@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/14/21 09:53, Hao Xu wrote:
> 在 2021/10/12 下午7:39, Pavel Begunkov 写道:
>> On 10/11/21 04:08, Hao Xu wrote:
>>> 在 2021/10/9 下午8:51, Pavel Begunkov 写道:
>>>> On 10/8/21 13:36, Hao Xu wrote:
>>>>> this is a new feature for pollable requests, see detail in commit
>>>>> message.
>>>>
>>>> It really sounds we should do it as a part of IOSQE_ASYNC, so
>>>> what are the cons and compromises?
>>> I wrote the pros and cons here:
>>> https://github.com/axboe/liburing/issues/426#issuecomment-939221300
>>
>> I see. The problem is as always, adding extra knobs, which users
>> should tune and it's not exactly clear where to use what. Not specific
>> to the new flag, there is enough confusion around IOSQE_ASYNC, but it
>> only makes it worse. It would be nice to have it applied
>> "automatically".
>>
>> Say, with IOSQE_ASYNC the copy is always (almost) done by io-wq but
>> there is that polling optimisation on top. Do we care enough about
>> copying specifically in task context to have a different flag?
>>
> I did more tests in a 64 cores machine.
> test command is: nice -n -15 taskset -c 10-20 ./io_uring_echo_server -p 8084 -f -n con_nr -l 1024
> where -n means the number of connections, -l means size of load.
> the results of tps and cpu usage under different IO pressure is:
> (didn't find the way to make it look better, you may need a markdown
> renderer :) )
> tps
> 
> | feature | 1 | 2 | 1000 | 2000 | 3000 | 5800 |
> | -------- | -------- | -------- | -------- | -------- | -------- | -------- |
> | ASYNC     |  123.000    |  295.203    |  67390.432   | 132686.361   | 186084.114   | 319550.540    |
> | ASYNC_HYBRID     |   122.000   |  299.401    |  168321.092   | 188870.283  | 226427.166   |  371580.062   |
> 
> 
> cpu
> 
> | feature | 1 | 2 | 1000 | 2000 | 3000 | 5800 |
> | -------- | -------- | -------- | -------- | -------- | -------- | -------- |
> | ASYNC     |  0.3%    |   1.0%   |   62.5%  |  111.3%  |  198.3%  | 420.9%   |
> | ASYNC_HYBRID     |    0.3%  |   1.0%   |  360%   |  435.5%  |  516.6%  |   1100%  |
> 
> when con_nr is 1000 or more, we leveraged all the 10 cpus. hybrid is
> surely better than async. when con_nr is 1 or 2, in theory async should
> be better since it use more cpu resource, but it didn't, it is because
> the copying in tw is not a bottleneck. So I tried bigger workload, no
> difference. So I think it should be ok to just apply this feature on top
> of IOSQE_ASYNC, for all pollable requests in all condition.

Sounds great. And IOSQE_ASYNC is a hint flag, so if things change
we can return it back the behaviour of IOSQE_ASYNC and add that new
flag (or do something else).


-- 
Pavel Begunkov
