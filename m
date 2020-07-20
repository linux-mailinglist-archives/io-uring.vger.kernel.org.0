Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC1222670C
	for <lists+io-uring@lfdr.de>; Mon, 20 Jul 2020 18:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733290AbgGTQIY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Jul 2020 12:08:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733287AbgGTQIX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Jul 2020 12:08:23 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9FAFC061794;
        Mon, 20 Jul 2020 09:08:22 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id g75so54914wme.5;
        Mon, 20 Jul 2020 09:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3IpgMenHTL8Cl1UPyNDJ0zP8AHlKOb8wvprdOdLQu58=;
        b=g9rn+ph/hicjFxOLjwquSxqsQSHdDBnsgCYSArLG3tpaMYFuwxgm+VDHmFx4U1fG39
         GscQ7HSqxTyxuGOkIq3bbjGtjPIHx4RYXQMSu6eceoqfvYnw+TsgE4R5Zg2DOHT/cwaq
         tiWuveh2bX4GchalokQl9AAAdaBI1Fy6mdTEAyUsDA91jv7LLUftnCJqLtlnIZrSqUZk
         V+FQKGYPDeIq8i+O1ibvKdlo+AuQB+qelotwLgnycAU39884gji+5q7iV58ZoM70Dfxe
         1eajuexZnT/rifuzEI+w/b4ba/O/lDMud3j126oH2L/rEeP5o/VeTrNVb6sevz8u/avb
         +fKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3IpgMenHTL8Cl1UPyNDJ0zP8AHlKOb8wvprdOdLQu58=;
        b=N81vIXYAMLnEY0rJBoDURXBs7Cy4CnG75Kzw4rwzib9tVAr8phOEtqH/wVv68AeX0U
         kqIH3Nvkz1XQBVADqXvpTI2VZWPyWSAoRUzpWsipHJrWJfteN1W2GUvP+8tR9Q8qW5lR
         eh+zytHw3AwB7hFa3lSFaJDOSQFWOSMjoeF8JEEs3TY8C+U1ZVteotf3lyiYhP7DJbIx
         0bukUG0hs1gQ40QLubuL0DqadiwTKJjbQlBQrBc+2NQbRXrwfLRJFnHYCS5J1Aa8/QTM
         xishKHmuk9KLEbyWuSowBQVzVmF1QXJifECZVAak9dErxuIdEcVoEwXaxHUDX+ErfwT/
         92tQ==
X-Gm-Message-State: AOAM533EbeCAyIhHbWStYK2If/YJwju7TzwL6qHUeotGvDzN72DpGtNb
        m1r3I32nSc5iLtnCNWa//8mUduQx
X-Google-Smtp-Source: ABdhPJwav/UKUFxTpObUSYrThh77uN1R2vaNIw6l6wZVEUFhjBnraCHFsEUDYI2fusEauVFgmtqXxQ==
X-Received: by 2002:a1c:ed01:: with SMTP id l1mr80943wmh.33.1595261299543;
        Mon, 20 Jul 2020 09:08:19 -0700 (PDT)
Received: from [192.168.43.17] ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id p29sm35098861wmi.43.2020.07.20.09.08.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jul 2020 09:08:19 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1595021626.git.asml.silence@gmail.com>
 <cf209c59-547e-0a69-244d-7c1fec00a978@kernel.dk>
 <b01e7f2d-d9a6-5593-3afb-5008d96695c6@gmail.com>
 <a2aa8de0-a2d0-3381-3415-4b523c2b66a5@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 0/2] task_put batching
Message-ID: <5b20b94d-13f7-66ee-610a-6f37ec8caa8d@gmail.com>
Date:   Mon, 20 Jul 2020 19:06:28 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <a2aa8de0-a2d0-3381-3415-4b523c2b66a5@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 20/07/2020 18:49, Jens Axboe wrote:
> On 7/20/20 9:22 AM, Pavel Begunkov wrote:
>> On 18/07/2020 17:37, Jens Axboe wrote:
>>> On 7/18/20 2:32 AM, Pavel Begunkov wrote:
>>>> For my a bit exaggerated test case perf continues to show high CPU
>>>> cosumption by io_dismantle(), and so calling it io_iopoll_complete().
>>>> Even though the patch doesn't yield throughput increase for my setup,
>>>> probably because the effect is hidden behind polling, but it definitely
>>>> improves relative percentage. And the difference should only grow with
>>>> increasing number of CPUs. Another reason to have this is that atomics
>>>> may affect other parallel tasks (e.g. which doesn't use io_uring)
>>>>
>>>> before:
>>>> io_iopoll_complete: 5.29%
>>>> io_dismantle_req:   2.16%
>>>>
>>>> after:
>>>> io_iopoll_complete: 3.39%
>>>> io_dismantle_req:   0.465%
>>>
>>> Still not seeing a win here, but it's clean and it _should_ work. For
>>> some reason I end up getting the offset in task ref put growing the
>>> fput_many(). Which doesn't (on the surface) make a lot of sense, but
>>> may just mean that we have some weird side effects.
>>
>> It grows because the patch is garbage, the second condition is always false.
>> See the diff. Could you please drop both patches?
> 
> Hah, indeed. With this on top, it looks like it should in terms of
> performance and profiles.

It just shows, that it doesn't really matters for a single-threaded app,
as expected. Worth to throw some contention though. I'll think about
finding some time to get/borrow a multi-threaded one.

> 
> I can just fold this into the existing one, if you'd like.

Would be nice. I'm going to double-check the counter and re-measure anyway.
BTW, how did you find it? A tool or a proc file would be awesome.

-- 
Pavel Begunkov
