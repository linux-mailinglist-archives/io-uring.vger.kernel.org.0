Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D96102A8068
	for <lists+io-uring@lfdr.de>; Thu,  5 Nov 2020 15:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbgKEOJY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Nov 2020 09:09:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgKEOJX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Nov 2020 09:09:23 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33346C0613CF
        for <io-uring@vger.kernel.org>; Thu,  5 Nov 2020 06:09:22 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id s24so1873202ioj.13
        for <io-uring@vger.kernel.org>; Thu, 05 Nov 2020 06:09:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=VZA/J1Tvui2qTb89P7Ipq2V8epA23peMfNOB//cuO4g=;
        b=N2syPlJXh4GQVBtmHAMmFnOB8FbBhjsHXOrAjd7Cck3OXs8wn7WJK9loFlUUzb1TNS
         xpUrdpZn3jtNfaHYEE2+p8jlW/h3tky7s9WiR0YXfgTI+xG+/+QHI70UubAMa3WNHawb
         rkG9V+tOczfTdxnEGnqEMVf1PuXK3H4SBgWrjW0MScwGE+OXUP2DhXqXMVR8Q3X6lufw
         1pFKo6iMeGcWJo1C6Fe5kCt4nxxFUtLN8EikXz3vOt1MH4WmDnW0JWqD9mvK78eNVVqs
         4jarRoAMuCi2oEneI9tjFy5BAOe+Gjgxqj+UWsC2d5vjKSrL2g48c97jjJvER9mYQb3X
         Kulw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VZA/J1Tvui2qTb89P7Ipq2V8epA23peMfNOB//cuO4g=;
        b=G5Q6aa20MAe8VdLfes0cOnTgw5Xlkz3sjxFXrA8+suW2MKZV0KPV01j4cP64IB535w
         +QWMuBVV5lr6RSpTOBDWZPx9qlI55piiTjllGiXDvGCb66Vy7IZPi1NzNUjvyA3X8gzJ
         6P32xZHVsJEp8BShjYuhSDmGl+3JysN9qIWp5oTtIXz1yleQEGhPIGxflQIEkRfkaDnF
         +Q5EaI5HEQiAueFbCcFY4lbTvryqGkhVoLGLkj+E8qPFTSoMug5Qm1+GxLYfQurhwXQR
         2KlhkkqkUUGauXq/BuozFwDRQa9LX5afc80jSNBykv0FpcqNCr5+YAZQs3EqsvnzmZLA
         4VAQ==
X-Gm-Message-State: AOAM5329AP39VKvFGJukB7Nxj88fjjiCIOsDoE7ERwmycQHnGoc8dBaV
        50xyJjuUZKhICKSGtlJrE9nHkkzq0TtTnA==
X-Google-Smtp-Source: ABdhPJx9KlXPzL5+KcQX5sOX3355WpXlz7PnOteM0H3fltvg/eIJPuIGIz+YINM5octLakULs3tzPg==
X-Received: by 2002:a5d:8e12:: with SMTP id e18mr1621911iod.99.1604585361301;
        Thu, 05 Nov 2020 06:09:21 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r14sm1326700ilc.78.2020.11.05.06.09.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 06:09:20 -0800 (PST)
Subject: Re: relative openat dirfd reference on submit
To:     Stefan Metzmacher <metze@samba.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Vito Caputo <vcaputo@pengaru.com>, io-uring@vger.kernel.org
References: <20201102205259.qsbp6yea3zfrqwuk@shells.gnugeneration.com>
 <d57e6cb2-9a2c-86a4-7d64-05816b3eab54@kernel.dk>
 <0532ec03-1dd2-a6ce-2a58-9e45d66435b5@gmail.com>
 <c7130e35-6340-5e0b-f0d9-3c8465d0eaf9@kernel.dk>
 <efe65885-6bf3-a3d1-5c67-dc7b34dd96c2@gmail.com>
 <c97e1b84-9c48-fe91-7c79-57de98c7fc0a@kernel.dk>
 <d7850258-1d18-9eae-97f5-c96c6a8a6dd3@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f7de9e9a-9f19-5824-01a9-9e143b801d92@kernel.dk>
Date:   Thu, 5 Nov 2020 07:09:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d7850258-1d18-9eae-97f5-c96c6a8a6dd3@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/5/20 1:45 AM, Stefan Metzmacher wrote:
> Am 05.11.20 um 00:43 schrieb Jens Axboe:
>> On 11/2/20 5:41 PM, Pavel Begunkov wrote:
>>> On 03/11/2020 00:34, Jens Axboe wrote:
>>>> On 11/2/20 5:17 PM, Pavel Begunkov wrote:
>>>>> On 03/11/2020 00:05, Jens Axboe wrote:
>>>>>> On 11/2/20 1:52 PM, Vito Caputo wrote:
>>>>>>> Hello list,
>>>>>>>
>>>>>>> I've been tinkering a bit with some async continuation passing style
>>>>>>> IO-oriented code employing liburing.  This exposed a kind of awkward
>>>>>>> behavior I suspect could be better from an ergonomics perspective.
>>>>>>>
>>>>>>> Imagine a bunch of OPENAT SQEs have been prepared, and they're all
>>>>>>> relative to a common dirfd.  Once io_uring_submit() has consumed all
>>>>>>> these SQEs across the syscall boundary, logically it seems the dirfd
>>>>>>> should be safe to close, since these dirfd-dependent operations have
>>>>>>> all been submitted to the kernel.
>>>>>>>
>>>>>>> But when I attempted this, the subsequent OPENAT CQE results were all
>>>>>>> -EBADFD errors.  It appeared the submit didn't add any references to
>>>>>>> the dependent dirfd.
>>>>>>>
>>>>>>> To work around this, I resorted to stowing the dirfd and maintaining a
>>>>>>> shared refcount in the closures associated with these SQEs and
>>>>>>> executed on their CQEs.  This effectively forced replicating the
>>>>>>> batched relationship implicit in the shared parent dirfd, where I
>>>>>>> otherwise had zero need to.  Just so I could defer closing the dirfd
>>>>>>> until once all these closures had run on their respective CQE arrivals
>>>>>>> and the refcount for the batch had reached zero.
>>>>>>>
>>>>>>> It doesn't seem right.  If I ensure sufficient queue depth and
>>>>>>> explicitly flush all the dependent SQEs beforehand
>>>>>>> w/io_uring_submit(), it seems like I should be able to immediately
>>>>>>> close(dirfd) and have the close be automagically deferred until the
>>>>>>> last dependent CQE removes its reference from the kernel side.
>>>>>>
>>>>>> We pass the 'dfd' straight on, and only the async part acts on it.
>>>>>> Which is why it needs to be kept open. But I wonder if we can get
>>>>>> around it by just pinning the fd for the duration. Since you didn't
>>>>>> include a test case, can you try with this patch applied? Totally
>>>>>> untested...
>>>>>
>>>>> afaik this doesn't pin an fd in a file table, so the app closes and
>>>>> dfd right after submit and then do_filp_open() tries to look up
>>>>> closed dfd. Doesn't seem to work, and we need to pass that struct
>>>>> file to do_filp_open().
>>>>
>>>> Yeah, I just double checked, and it's just referenced, but close() will
>>>> still make it NULL in the file table. So won't work... We'll have to
>>>> live with it for now, I'm afraid.
>>>
>>> Is there a problem with passing in a struct file? Apart from it
>>> being used deep in open callchains?
>>
>> No technical problems as far as I can tell, just needs doing...
> 
> That would also allow fixed files to be used as dirfd, correct?

Correct

> If that's the case it would be great to have a way to install the resulting
> fd also (or maybe only) as fixed file.

That might be handy, yes.

-- 
Jens Axboe

