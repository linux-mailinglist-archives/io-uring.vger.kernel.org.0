Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B22269B41
	for <lists+io-uring@lfdr.de>; Tue, 15 Sep 2020 03:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbgIOBfw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Sep 2020 21:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbgIOBfu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Sep 2020 21:35:50 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D7AC06174A
        for <io-uring@vger.kernel.org>; Mon, 14 Sep 2020 18:35:50 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id fa1so925828pjb.0
        for <io-uring@vger.kernel.org>; Mon, 14 Sep 2020 18:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/hyiLfxwKKD7LHwDVBxJisVr6uWuWEUmiDno8KhH8LY=;
        b=M10GlsiJnTZjSzHKEmgPGpWZn1EemhaR8PKcDOyrwLEmnkn7pvvCsOvcsa0+9z/qJq
         /bzUcGIvdu7DLhXp0HN/sIQ07x5sBpio5ReSGiRU2udb5B4tJ3YTT+3qb0CPHQVVv1XR
         d4PqgroW6JP8oRBfDkukLv0Z99SVOdRlySegvCqUfTB2XxLnOCHkfizNaZUEwpThgdbM
         kKvvkm3K/aId80ofgrNGUpxkEBz94MHD4zD79zXlAJNExRaY6WuqUXOmgHBxcFxQZXLv
         rXdpvsVZw0nnTZp4Bgy5O5o6L3NadZDSmvOkB2HRaWjyKewCfSFeBWvioxoY3p141JJo
         6Uow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/hyiLfxwKKD7LHwDVBxJisVr6uWuWEUmiDno8KhH8LY=;
        b=fO5mZ9kBeQCcDzT4jr1q057hnQyXLXwGfZ+6O3XMjZYekXmFYMRWeorN6aumUw4pl9
         88xARrA/ALY8FOVsSQ44haze+IZ4XZ4/NQcvHknUxGfNIoC0RB1YIHQMnGzTXrztPhtw
         26iK0gYTIORsb/+zw+CyzbRx6Fav62SFwoSxvnkErYElY1+EQTCVc0uvab8XFj96JbwX
         nSX8+LYj4tFVzQaOgCTQRkcT9IwE5LICGmUZwYXwsFBbiobtCBx9Yi7BsFiixPyBjqeM
         VPcJsog+RAH9i3uk31R2BEUfsfiryMiYf3MtY1HdcsyvaaYe12E4T4pKv4z5FPcdYkRW
         YcBg==
X-Gm-Message-State: AOAM532QayMvky2RtR6CMadOSC2ZCcz4B+oSMWLCacU0RxFEAsrn5zZT
        voxRkV2iaM6/jrwfckRUQPU+DlksqFEdWaZL
X-Google-Smtp-Source: ABdhPJyBbX7l9YeJvC7ZsJcJ0jbYVl3K1B39vz8ECIr/jILcQAPUQOR3So3zps7Nooq8PKfwwMWvWg==
X-Received: by 2002:a17:90a:bc8d:: with SMTP id x13mr1957351pjr.229.1600133749741;
        Mon, 14 Sep 2020 18:35:49 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id y202sm11714540pfc.179.2020.09.14.18.35.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2020 18:35:49 -0700 (PDT)
Subject: Re: [PATCH liburing 3/3] man/io_uring_enter.2: add EACCES and EBADFD
 errors
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     io-uring@vger.kernel.org
References: <20200911133408.62506-1-sgarzare@redhat.com>
 <20200911133408.62506-4-sgarzare@redhat.com>
 <d38ae8b4-cb3e-3ebf-63e3-08a1f24ddcbb@kernel.dk>
 <20200914080537.2ybouuxtjvckorc2@steredhat>
 <dc01a74f-db66-0da9-20b7-b6c6e6cb1640@kernel.dk>
 <20200914160243.o4vldl5isqktrvdd@steredhat>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5796f215-f259-6833-ae39-e3a341cedf8f@kernel.dk>
Date:   Mon, 14 Sep 2020 19:35:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200914160243.o4vldl5isqktrvdd@steredhat>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/14/20 10:02 AM, Stefano Garzarella wrote:
> On Mon, Sep 14, 2020 at 09:38:25AM -0600, Jens Axboe wrote:
>> On 9/14/20 2:05 AM, Stefano Garzarella wrote:
>>> On Fri, Sep 11, 2020 at 09:36:02AM -0600, Jens Axboe wrote:
>>>> On 9/11/20 7:34 AM, Stefano Garzarella wrote:
>>>>> These new errors are added with the restriction series recently
>>>>> merged in io_uring (Linux 5.10).
>>>>>
>>>>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>>>>> ---
>>>>>  man/io_uring_enter.2 | 18 ++++++++++++++++++
>>>>>  1 file changed, 18 insertions(+)
>>>>>
>>>>> diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
>>>>> index 5443d5f..4773dfd 100644
>>>>> --- a/man/io_uring_enter.2
>>>>> +++ b/man/io_uring_enter.2
>>>>> @@ -842,6 +842,16 @@ is set appropriately.
>>>>>  .PP
>>>>>  .SH ERRORS
>>>>>  .TP
>>>>> +.B EACCES
>>>>> +The
>>>>> +.I flags
>>>>> +field or
>>>>> +.I opcode
>>>>> +in a submission queue entry is not allowed due to registered restrictions.
>>>>> +See
>>>>> +.BR io_uring_register (2)
>>>>> +for details on how restrictions work.
>>>>> +.TP
>>>>>  .B EAGAIN
>>>>>  The kernel was unable to allocate memory for the request, or otherwise ran out
>>>>>  of resources to handle it. The application should wait for some completions and
>>>>> @@ -861,6 +871,14 @@ field in the submission queue entry is invalid, or the
>>>>>  flag was set in the submission queue entry, but no files were registered
>>>>>  with the io_uring instance.
>>>>>  .TP
>>>>> +.B EBADFD
>>>>> +The
>>>>> +.I fd
>>>>> +field in the submission queue entry is valid, but the io_uring ring is not
>>>>> +in the right state (enabled). See
>>>>> +.BR io_uring_register (2)
>>>>> +for details on how to enable the ring.
>>>>> +.TP
>>>>
>>>> I actually think some of this needs general updating. io_uring_enter()
>>>> will not return an error on behalf of an sqe, it'll only return an error
>>>> if one happened outside the context of a specific sqe. Any error
>>>> specific to an sqe will generate a cqe with the result.
>>>
>>> Mmm, right.
>>>
>>> For example in this case, EACCES is returned by a cqe and EBADFD is
>>> returned by io_uring_enter().
>>>
>>> Should we create 2 error sections?
>>
>> Yep, I think we should. One that describes that io_uring_enter() would
>> return in terms of errors, and one that describes cqe->res returns.
> 
> Yeah, that would be much better!
> 
>>
>> Are you up for this? Would be a great change, making it a lot more
>> accurate.
> 
> Sure! I'll prepare a patch with this change, and I'll also try to catch
> all possible return values, then I'll rebase this series on top of that.

Awesome! It'll be a really nice improvement.

-- 
Jens Axboe

