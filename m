Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29C3718FA53
	for <lists+io-uring@lfdr.de>; Mon, 23 Mar 2020 17:49:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbgCWQtL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Mar 2020 12:49:11 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38270 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbgCWQtL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Mar 2020 12:49:11 -0400
Received: by mail-pg1-f195.google.com with SMTP id x7so7479750pgh.5
        for <io-uring@vger.kernel.org>; Mon, 23 Mar 2020 09:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=utUkpCNd7cXBI6alNjyuLGZlZfwXShYX8p/ucNj2ywI=;
        b=Zivq46lfSliHW7EbypV+SqZGQHWpjSdqSAiyQqTp713gjtKXi9uW6prIb33XE5ebUZ
         WZPeBeis6U87lX5e8BNrEDLuIvOGeSl+ZjOzqFHcxss0ml5WFRH7e43ZwG3sqx3UNXYn
         2651zfQEoOV6HNUq7XQTmgLRS7LzMGc5+B1D0m6q+EBg0VQXA3lPq4vWsqG2WZoTE+b8
         o+fRTDg/fD45PpB0vBiN1BnweEuufH9mUWJ2vnz6LUQb83TFnN7+rIHw+txSGUZisOjS
         AQnJWXkX6P+Ed14jTtYyC98hG3HCHBo6Ryo7SB6bg3B1ZbluLO0eB9bSa0KKAV37UwcV
         rEig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=utUkpCNd7cXBI6alNjyuLGZlZfwXShYX8p/ucNj2ywI=;
        b=ac3iopVqOi2f5E1xoSrth4Wi52+V6wirEa/wbV3AM2FEboPcwxAdAmtal9pJuH2jDE
         1dcwdceU6aXJvPVDtzlD4P/FzT6MWxkzpe2r3sgwlToq3t5lTQXTSIgzK6tRrjHhMlmO
         o++wT1bY0PjTb+vGtsTu1+LotVp/oi5tdQTjMkIHmgUL/cJEf4Ff9ZCidV8hffJoQFLu
         g6kY+7u/b14nBaidJ/ub01Dd8o/ZvqUa14vVfn1XYMfaMo3KJFZHMeDdDcVvu/EfqBGN
         Kf9rTLY6xBz3zp7y7vFj8m4PLhSOHtMMx1bnmnIL04qbw8El7pn4Wc6I2+0/qn/FPiXP
         VyRA==
X-Gm-Message-State: ANhLgQ23XYsgup5BxuGoJHdeoj/hmLrNW9PpI3M3a4RZBkFnU+Swwo+e
        xpvZ3q+WdFTEmbet1YiwWh7YhnKlYaQUhQ==
X-Google-Smtp-Source: ADFU+vsLRlgVVB8GcQ/DR9i5gh+b1vWr0JcHwDN2d2VqHfcq36a0gdLPas78O1P5NuQrO2+csGchdw==
X-Received: by 2002:a63:d311:: with SMTP id b17mr22182348pgg.407.1584982149883;
        Mon, 23 Mar 2020 09:49:09 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id j25sm13682563pfh.22.2020.03.23.09.49.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2020 09:49:09 -0700 (PDT)
Subject: Re: [PATCH] io_uring: refacor file register/unregister/update based
 on sequence
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200323115036.6539-1-xiaoguang.wang@linux.alibaba.com>
 <bf9c7c16-76bb-7fd5-7190-63d8c6bb430a@kernel.dk>
 <eeafad2e-afb1-a548-90a2-e021afa00e69@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a8d2f292-8e9e-6f8c-c885-69b9d52b126a@kernel.dk>
Date:   Mon, 23 Mar 2020 10:49:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <eeafad2e-afb1-a548-90a2-e021afa00e69@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/23/20 10:45 AM, Xiaoguang Wang wrote:
> hi,
> 
>> On 3/23/20 5:50 AM, Xiaoguang Wang wrote:
>>> While diving into iouring fileset resigster/unregister/update codes,
>>> we found one bug in fileset update codes. Iouring fileset update codes
>>> use a percpu_ref variable to check whether can put previous registered
>>> file, only when the refcnt of the perfcpu_ref variable reachs zero, can
>>> we safely put these files, but this do not work well. If applications
>>> always issue requests continually, this perfcpu_ref will never have an
>>> chance to reach zero, and it'll always be in atomic mode, also will
>>> defeat the gains introduced by fileset register/unresiger/update feature,
>>> which are used to reduce the atomic operation overhead of fput/fget.
>>>
>>> To fix this issue, we remove the percpu_ref related codes, and add two new
>>> counter: sq_seq and cq_seq to struct io_ring_ctx:
>>>      sq_seq: the most recent issued requset sequence number, which is
>>>              protected uring_lock.
>>>      cq_seq: the most recent completed request sequence number, which is
>>>              protected completion_lock.
>>>
>>> When we update fileset(under uring_lock), we record the current sq_seq,
>>> and when cq_seq is greater or equal to recorded sq_seq, we know we can
>>> put previous registered file safely.
>>
>> Maybe I'm misunderstanding the idea here, but what if you have the
>> following:
>>
>> - sq_seq 200, cq_seq 100
>>
>> We have 100 inflight, and an unregister request comes in. I then
>> issue 100 nops, which complete. cq_seq is now 200, but none of the
>> original requests that used the file have completed.
>>
>> What am I missing?
> No, you're right. I had thought requests will be completed in the order
> they are issued, thanks for pointing this.
> As for not using per percpu_ref per registered file, I also worry about
> the memory consume, because the max allowed registered files are 32768.

Yeah, I think we have to be a bit creative here with the solution...
Please continue to think about it, would be great to have a better
solution for this!

-- 
Jens Axboe

