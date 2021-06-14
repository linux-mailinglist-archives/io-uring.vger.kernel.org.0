Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD6B3A5F29
	for <lists+io-uring@lfdr.de>; Mon, 14 Jun 2021 11:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbhFNJeH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Jun 2021 05:34:07 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]:43590 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232630AbhFNJeG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Jun 2021 05:34:06 -0400
Received: by mail-wr1-f50.google.com with SMTP id r9so13760475wrz.10
        for <io-uring@vger.kernel.org>; Mon, 14 Jun 2021 02:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:references:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cgPRu2LXEF+HaKQ42TbtdRNmAzLjQr+eL+5uyFEEACY=;
        b=n2+xYTaLaANCexsrA0QF0Fp35aQthdri4IPlePLb9QX8lN8hprIlRKCblIJavGkOa6
         V5Mn94OnfU2mKXkHnp3rB42cuFjsnN9p9UbVlRXrzY6ubXJByx4TYX/Ydn+Z+U0gx3IB
         0x+8TZztVQ+lKBNIWizKWjm0knnN14Y/pD+/W1dA+YvS1oW4ZTv9Huz/X1WuE4V5wC5E
         NQLHKNvj46C9gG0Tj7bhs6gYwRRssvgVO5JU2qrRyCoZavop+oQAQ8FHexxZuqbha0NQ
         bXM3rUP7dy+ya5Ryb19zmnCxovAEMktmyv+PN3/N5HLsdyJ4ViL4+thXpLsBYYO5/Zu6
         0YzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:references:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cgPRu2LXEF+HaKQ42TbtdRNmAzLjQr+eL+5uyFEEACY=;
        b=gTipfPRj4AfMlMO9DA1JZtaa1W6GeyZp+bW0pYH8j3hvM6dHkCugwxefYN9mWu8eY/
         3QxZOXpbGEDwgXeNf9RjdCgc9bIdOfxIzIYwacL9PU1h6jf881QBTWkiYemtY4G60VFb
         016wz/ubfOctQQPIA3sAMXP3ifGs5NFVpmoYWNhvj0P8USrdfmG57+9Gf/9RVO7u17sj
         0kr5/AQ2nJc4+aNGbuLZb8X3Lds/C1UOXT4MS03bNpb521n7241tllgDEaoPFr0FD3nZ
         wgxgouXAyYh0Uu8kF9cxRMCFIzvXiqGuc3CFgkpYA2VeDo8ADyzIM5Dx5l7Sv2PrPcCF
         3ZTw==
X-Gm-Message-State: AOAM532ix96H1+1EwdimdUKR+LXhNTZ8AC6nLl2SVOmIiilnm4ZPDi3B
        yWBtKOInkFcTF2wN2avUF6M=
X-Google-Smtp-Source: ABdhPJzRaqMDOk2e2BgLydwGZ7OBYthPunOYVm8DVX1rk514MeMgHGSsjcohGu0Ni201lU5zicyCXw==
X-Received: by 2002:a5d:6584:: with SMTP id q4mr17491743wru.230.1623663063423;
        Mon, 14 Jun 2021 02:31:03 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.237.119])
        by smtp.gmail.com with ESMTPSA id r3sm12272613wmq.8.2021.06.14.02.31.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jun 2021 02:31:02 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     lonjil@gmail.com
References: <d60270856b8a4560a639ef5f76e55eb563633599.1623236455.git.asml.silence@gmail.com>
 <e3edab99-624d-6f24-a6ba-63589d00eeee@kernel.dk>
 <e6283f40-52ab-ddcc-131c-309e34321613@gmail.com>
 <cb972cf9-c35b-51f3-7216-13437285cda2@kernel.dk>
 <a61a3394-0e18-ec9a-5674-dd4439c6b041@gmail.com>
 <05dff9bd-a928-e49b-f1e1-945a1f513c37@kernel.dk>
 <a396b8f6-d9d8-ef26-438f-2f67cc30dea0@gmail.com>
Subject: Re: [PATCH] io_uring: fix blocking inline submission
Message-ID: <024ea4e1-43bf-099e-0b7a-c4d8fa3bc6b2@gmail.com>
Date:   Mon, 14 Jun 2021 10:30:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <a396b8f6-d9d8-ef26-438f-2f67cc30dea0@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/9/21 4:47 PM, Pavel Begunkov wrote:
> On 6/9/21 4:43 PM, Jens Axboe wrote:
>> On 6/9/21 9:41 AM, Pavel Begunkov wrote:
>>> On 6/9/21 4:36 PM, Jens Axboe wrote:
>>>> On 6/9/21 9:34 AM, Pavel Begunkov wrote:
>>>>> On 6/9/21 4:07 PM, Jens Axboe wrote:
>>>>>> On 6/9/21 5:07 AM, Pavel Begunkov wrote:
>>>>>>> There is a complaint against sys_io_uring_enter() blocking if it submits
>>>>>>> stdin reads. The problem is in __io_file_supports_async(), which
>>>>>>> sees that it's a cdev and allows it to be processed inline.
>>>>>>>
>>>>>>> Punt char devices using generic rules of io_file_supports_async(),
>>>>>>> including checking for presence of *_iter() versions of rw callbacks.
>>>>>>> Apparently, it will affect most of cdevs with some exceptions like
>>>>>>> null and zero devices.
>>>>>>
>>>>>> I don't like this, we really should fix the file types, they are
>>>>>> broken if they don't honor IOCB_NOWAIT and have ->read_iter() (or
>>>>>> the write equiv).
>>>>>>
>>>>>> For cases where there is no iter variant of the read/write handlers,
>>>>>> then yes we should not return true from __io_file_supports_async().
>>>>>
>>>>> I'm confused. The patch doesn't punt them unconditionally, but make
>>>>> it go through the generic path of __io_file_supports_async()
>>>>> including checks for read_iter/write_iter. So if a chrdev has
>>>>> *_iter() it should continue to work as before.
>>>>
>>>> Ah ok, yes then that is indeed fine.
>>>>
>>>>> It fixes the symptom that means the change punts it async, and so
>>>>> I assume tty doesn't have _iter()s for some reason. Will take a
>>>>> look at the tty driver soon to stop blind guessing.
>>>>
>>>> I think they do, but they don't honor IOCB_NOWAIT for example. I'd
>>>> be curious if the patch actually fixes the reported case, even though
>>>> it is most likely the right thing to do. If not, then the fops handler
>>>> need fixing for that driver.
>>>
>>> Yep, weird, but fixes it for me. A simple repro was attached
>>> to the issue.
>>>
>>> https://github.com/axboe/liburing/issues/354
>>
>> Ah ok, all good then for now. I have applied the patch, and added
>> the reported-by as well.
> 
> Great, thanks. Will check what's with the tty part

Apparently, they have *_iter but reasonably don't set FMODE_NOWAIT.
Similar goes for /dev/null and others, either they don't have
*_iter or don't set FMODE_NOWAIT and ignore IOCB_NOWAIT.

Bottom line, we need to tinker cdevs that we're interested to
be efficient.

-- 
Pavel Begunkov
