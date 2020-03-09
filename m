Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D15917EB2B
	for <lists+io-uring@lfdr.de>; Mon,  9 Mar 2020 22:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgCIV3h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Mar 2020 17:29:37 -0400
Received: from mail-pg1-f172.google.com ([209.85.215.172]:45521 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbgCIV3h (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Mar 2020 17:29:37 -0400
Received: by mail-pg1-f172.google.com with SMTP id m15so5288249pgv.12
        for <io-uring@vger.kernel.org>; Mon, 09 Mar 2020 14:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MMkIprq2SZ0L02DCjpFKiyzt2eWc7wcnOULMXKnRe80=;
        b=SqgIxfE0g5J+GdvvB5lbFrbQDzhR8oKssQxw7qmms5y8uKTCs0POCYz8yD04XJ3J8w
         3J6TQt8mD58munFdG7XfbXl6k05mJqM+nn4RjmRhXcL646S3fKIkfnkGCYyXgie/+l7z
         8q5jf4bMVTh7CYWT45dRO2yLQlXvx+IIhuWSuZXDlpsXSBg5/raTxdCw0slIVWlzMRYa
         NHsGLS4/FwaI1JA+eutMZTqrL2a/uxk8XC0cJer0Ghj9T1Ktdqjf8wlT8R3eZfKi5p9y
         onOpC2ZxlS4sgm8stZkhDzhkZvgWTrv1Zd79zks8o0AZa7sRO7Tt+1h/WvmWgiE9fA1C
         9Pdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MMkIprq2SZ0L02DCjpFKiyzt2eWc7wcnOULMXKnRe80=;
        b=mP8WuqtwwEOrKrS8UT2DSLerwORAYhCa3zx22cXv4WvEb0d9Watab4UaMMfuM90h50
         QpqdpmMOq4TVdgZl2+p1ON/z9b8mtx3+BL/PeDa522Pj4/l653VQY1UfjhqmrFVdkmyG
         EJe6INtutkLBwl/Kivjxm/OMQyUb19nJA7FRm6Dl2HRreAseZi+3HuwtqZmOtXuNxG0s
         BlnazvuR5C1Nav47JgdkNL3GS1wk712jqxEn68K/UkxEW8zOwY1SgGbiumnposHhLHBN
         Lg336aLvbpL2O2QwW5wtjH6Yzvwoynz5FSCCLpTRbAapwaxMJh98g+YzjLRLkRBeLbCi
         xeJw==
X-Gm-Message-State: ANhLgQ2yeIahTQW9s4xtTVch7CMdRa3BQEvLoRtT4F4Q/mZ6KwQvo3io
        pI7OCJZGMxEDDXfvlBniWEYrwN9AZM4=
X-Google-Smtp-Source: ADFU+vufw1cLiLbRG7BiSQevyMyd1jWZPl0OcZl81UYbMkpKg0g87kmbHkJawi/TfXnmtKK1IMwB2g==
X-Received: by 2002:a63:e5d:: with SMTP id 29mr17949542pgo.124.1583789373966;
        Mon, 09 Mar 2020 14:29:33 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21c8::16c3? ([2620:10d:c090:400::5:3275])
        by smtp.gmail.com with ESMTPSA id l13sm462423pjq.23.2020.03.09.14.29.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2020 14:29:33 -0700 (PDT)
Subject: Re: Buffered IO async context overhead
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Andres Freund <andres@anarazel.de>
Cc:     io-uring@vger.kernel.org
References: <20200214195030.cbnr6msktdl3tqhn@alap3.anarazel.de>
 <c91551b2-9694-78cb-2aa6-bc8cccc474c3@kernel.dk>
 <20200214203140.ksvbm5no654gy7yi@alap3.anarazel.de>
 <4896063a-20d7-d2dd-c75e-a082edd5d72f@kernel.dk>
 <20200224093544.kg4kmuerevg7zooq@alap3.anarazel.de>
 <0ec81eca-397e-0faa-d2c0-112732423914@kernel.dk>
 <9a7da4de-1555-be31-1989-e33f14f1e814@gmail.com>
 <d704bbee-c50a-ab99-bed3-17a93e06ddeb@kernel.dk>
 <e50a7340-845d-6261-b070-74bdf34aeab6@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <73a0b90b-6871-0948-fc85-705387c453dc@kernel.dk>
Date:   Mon, 9 Mar 2020 15:29:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <e50a7340-845d-6261-b070-74bdf34aeab6@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/9/20 3:02 PM, Pavel Begunkov wrote:
> On 09/03/2020 23:41, Jens Axboe wrote:
>> On 3/9/20 2:03 PM, Pavel Begunkov wrote:
>>> On 24/02/2020 18:22, Jens Axboe wrote:
>>> A problem here is that we actually have a 2D array of works because of linked
>>> requests.
>>
>> You could either skip anything with a link, or even just ignore it and
>> simply re-queue a dependent link if it isn't hashed when it's done if
>> grabbed in a batch.
>>
>>> We can io_wqe_enqueue() dependant works, if have hashed requests, so delegating
>>> it to other threads. But if the work->list is not per-core, it will hurt
>>> locality. Either re-enqueue hashed ones if there is a dependant work. Need to
>>> think how to do better.
>>
>> If we ignore links for a second, I think we can all agree that it'd be a
>> big win to do the batch.
> 
> Definitely
> 
>>
>> With links, worst case would then be something where every other link is
>> hashed.
>>
>> For a first patch, I'd be quite happy to just stop the batch if there's
>> a link on a request. The normal case here is buffered writes, and
>> that'll handle that case perfectly. Links will be no worse than before.
>> Seems like a no-brainer to me.
> 
> That isn't really a problem, just pointing that there could be
> optimisations for different cases.

Definitely, in case it wasn't clear, my suggestion was merely to go for
the main win and ignore the link side for now. It's best done separately
anyway, with the link stuff tweaking the batch behavior.

-- 
Jens Axboe

