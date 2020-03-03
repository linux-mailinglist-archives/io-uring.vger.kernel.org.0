Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3B6177B87
	for <lists+io-uring@lfdr.de>; Tue,  3 Mar 2020 17:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729898AbgCCQES (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Mar 2020 11:04:18 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:43223 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729543AbgCCQES (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Mar 2020 11:04:18 -0500
Received: by mail-il1-f196.google.com with SMTP id o18so3189020ilg.10
        for <io-uring@vger.kernel.org>; Tue, 03 Mar 2020 08:04:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=XNptDHf3B9MrspnBaDkgfKgyPkZSg0/a7ZTbis3qJW4=;
        b=DTLtzuz7Dp0xKxV+FonbxARhkpLzpHhck+yNDuY7gHlYzctkaPgZqQJP/udCFnPwb4
         sHkly8itVnmxHs52SD803yQKTlfO4VqBM0hq42zIEhz6mL8ELRE/UsVSHsp/5HdgK9tx
         xUuAUdTvNIpafnczzNKn0yOEY8cs7NUc0orIgDf9XUSr0MhJA2NQGgIVkgb3h8JtR+F1
         uSKNe3KfTroRIHwmuU1xm2ABSfemzBy2nZQl+ysZc6RQkJ9n6iIImNpO8WIe2CEZLdGa
         HTtdvp6Uu5pbtdEOtRHRKJq/PJXLVRnqBRZbyvse3nPc8ltRUYsurqjDJTUsAk1ay39z
         f3GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XNptDHf3B9MrspnBaDkgfKgyPkZSg0/a7ZTbis3qJW4=;
        b=ghhr3Lk5AbOo1jxD8bh4fnd75TWV6kezQhsRhGqxYAlh0jVKukMicT6U6GkpNw9rIc
         w5jbpC12a1iS56ZfFbSEK4SdCje9fdv5RtXVNG9FWHqFfTo5RgQJTrfqlMu1ci62u/Sd
         I3aYCiqwlk4Z70hl/Cryojvl1mBG4BvOW2JE1fVd0dzsicq3LVbm2D4xjOLjYo9dYgga
         VL5Q/Hstfu5Frb0ctpGb4EghcmjnlkMyzpIST16JC2RcimVQXafH9SO7PpxmHJz3AMVR
         JSKQeoTOnEez2ldR1I1mfevIbLlLZBRlDd8evvDg2RcriTwXNS5kbPJLg/+cx6G1nz5G
         8nPQ==
X-Gm-Message-State: ANhLgQ1M5Xy2wyiHD7laPHgCHEGsZ22BXB4OK9SJsc0JTF/6QE18KeTW
        m2T821vFraa/KYV5GiC/hq8Klw==
X-Google-Smtp-Source: ADFU+vu6PipftNRJq0p/JIHkf9QKrsEkxQTEizleEIbWFUvIukFuGzs0v5q/jcYySuktXSmLO0DySg==
X-Received: by 2002:a92:9c52:: with SMTP id h79mr5150905ili.213.1583251457276;
        Tue, 03 Mar 2020 08:04:17 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id c12sm7991082ile.12.2020.03.03.08.04.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 08:04:16 -0800 (PST)
Subject: Re: [PATCH v2 4/4] io_uring: get next req on subm ref drop
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1583181841.git.asml.silence@gmail.com>
 <444aef98f849d947d7f10e88f30244fa0bc82360.1583181841.git.asml.silence@gmail.com>
 <3ab75953-ee39-2c4e-99e2-f8c18ceb6a8d@kernel.dk>
 <52b282f5-50f3-2ee6-a055-6ef0c2c39e93@gmail.com>
 <9ead66eb-cb5d-2dab-1a78-02466958674a@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <153662f4-0ab9-8dac-1577-0df1ce35f320@kernel.dk>
Date:   Tue, 3 Mar 2020 09:04:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <9ead66eb-cb5d-2dab-1a78-02466958674a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/3/20 3:46 AM, Pavel Begunkov wrote:
> On 3/3/2020 9:54 AM, Pavel Begunkov wrote:
>> On 03/03/2020 07:26, Jens Axboe wrote:
>>> On 3/2/20 1:45 PM, Pavel Begunkov wrote:
>>>> Get next request when dropping the submission reference. However, if
>>>> there is an asynchronous counterpart (i.e. read/write, timeout, etc),
>>>> that would be dangerous to do, so ignore them using new
>>>> REQ_F_DONT_STEAL_NEXT flag.
>>>
>>> Hmm, not so sure I like this one. It's not quite clear to me where we
>>> need REQ_F_DONT_STEAL_NEXT. If we have an async component, then we set
>>> REQ_F_DONT_STEAL_NEXT. So this is generally the case where our
>>> io_put_req() for submit is not the last drop. And for the other case,
>>> the put is generally in the caller anyway. So I don't really see what
>>> this extra flag buys us?
>>
>> Because io_put_work() holds a reference, no async handler can achive req->refs
>> == 0, so it won't return next upon dropping the submission ref (i.e. by
>> put_find_nxt()). And I want to have next before io_put_work(), to, instead of as
>> currently:
>>
>> run_work(work);
>> assign_cur_work(NULL); // spinlock + unlock worker->lock
>> new_work = put_work(work);
>> assign_cur_work(new_work); // the second time
>>
>> do:
>>
>> new_work = run_work(work);
>> assign_cur_work(new_work); // need new_work here
>> put_work(work);
>>
>>
>> The other way:
>>
>> io_wq_submit_work() // for all async handlers
>> {
>> 	...
>> 	// Drop submission reference.
>> 	// One extra ref will be put in io_put_work() right
>> 	// after return, and it'll be done in the same thread
>> 	if (atomic_dec_and_get(req) == 1)
>> 		steal_next(req);
>> }
>>
>> Maybe cleaner, but looks fragile as well. Would you prefer it?
> 
> Any chance you've measured your next-work fix? I wonder how much does it
> hurt performance, and whether we need a terse patch for 5.6.

Unless I'm missing something, the worker will pick up the next work
without sleeping, since the request will have finished. So it really
should not add any extra overhead, except you'll do an extra wqe lock
roundtrip.

But I'll run some testing to be totally sure.

-- 
Jens Axboe

