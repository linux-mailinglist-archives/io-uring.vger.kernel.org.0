Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F065314F936
	for <lists+io-uring@lfdr.de>; Sat,  1 Feb 2020 18:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgBARwL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 1 Feb 2020 12:52:11 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37945 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726169AbgBARwL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 1 Feb 2020 12:52:11 -0500
Received: by mail-pf1-f194.google.com with SMTP id x185so5177005pfc.5
        for <io-uring@vger.kernel.org>; Sat, 01 Feb 2020 09:52:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=+fVxwzlubcd05e2l9uV6PXCL0eH9bMmXFZWolRJgtA8=;
        b=tuAnzpjJMk9mYHbyDlWMya+DupioVh6O8nQs2rZfhza1A8uV1MTO98H4vAjJZgtOsf
         7vBHDFNC70c0I9QRw1HU2F+2hKzUJ1Vc2nF6ZLXkVh8ZdDa4qprj2WtV1vzn9i3yCfJp
         w48O4XjoWqLe2MsZxlFDi2fWnQnZCjmpptQgqRtmlMCsLagpmK1O/oytVF+r+a2+vgKi
         BYvULA0T8m91edX7YdruRIAkG1jefGslXrTkvALd+lsR7gcfSWqEh5yiHz8Hm3MElPWh
         zo+D+zPF1hhJbVKWYz3gD3IwhKDBRG7xwouGUoS+IFJyJKbBIGuwl/oGe4QTFxY5kLbB
         VqNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+fVxwzlubcd05e2l9uV6PXCL0eH9bMmXFZWolRJgtA8=;
        b=oJ6Cxqa36B7+tJtnBNwNrpohJ54mBs0SWzv5PMFNUku1S2MMmJxS4y7Zm5jA1WGZuA
         QqselOMRgb2iwzjDwIr0CRat/gs8QDV2t8vbRs6G/YH1+C1Jt1ws/OlmXzmwjEJDz9M1
         oz+oYCHSnOb4Q0xkLM3qwRqNtqsUyEp2eaBdyVg/fL3pfeoxjlchHBIrsA7evRrJ+0V1
         jpmuzqfpzuP0OLSAKbtdc4XvPqrO4xu5biN/p61cyOBQBBMnLzhQTmD8oI9kPYluDhBW
         RFJGx9Xlqs9fz2AZhKo2iAO6/zkNRO22P0LSNT2zJ5390MOVp7wQqCwA8UoTko4n19Rf
         zD1w==
X-Gm-Message-State: APjAAAW7VgkTW8tBt2PmSQpxodZc8j8vn4wklTMbeJ6R9gBAJLYY70c4
        15SdjJ+NQW40uI4SGvh0uAdBKCNqHfM=
X-Google-Smtp-Source: APXvYqxHloPkjn/D+aiwt3oajqn6dbKaQZbiU7ARF/PzvKqYFgATh+B/qAk3zKOzHYL4Z0pkRcARaw==
X-Received: by 2002:a63:a543:: with SMTP id r3mr15929171pgu.244.1580579528418;
        Sat, 01 Feb 2020 09:52:08 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id n4sm14336734pgg.88.2020.02.01.09.52.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Feb 2020 09:52:08 -0800 (PST)
Subject: Re: liburing: expose syscalls?
To:     Andres Freund <andres@anarazel.de>, io-uring@vger.kernel.org
References: <20200201125350.vkkhezidm6ka6ux5@alap3.anarazel.de>
 <ed2fd00f-b300-6d9d-a6d5-f76bbc26435a@kernel.dk>
 <78A9EC3E-0961-4EF3-A226-1FCA34FAF818@anarazel.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <aac42d1e-24d5-4c2d-d1ce-eb8ceed48b1e@kernel.dk>
Date:   Sat, 1 Feb 2020 10:52:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <78A9EC3E-0961-4EF3-A226-1FCA34FAF818@anarazel.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/1/20 10:49 AM, Andres Freund wrote:
> Hi, 
> 
> On February 1, 2020 6:39:41 PM GMT+01:00, Jens Axboe <axboe@kernel.dk> wrote:
>> On 2/1/20 5:53 AM, Andres Freund wrote:
>>> Hi,
>>>
>>> As long as the syscalls aren't exposed by glibc it'd be useful - at
>>> least for me - to have liburing expose the syscalls without really
>> going
>>> through liburing facilities...
>>>
>>> Right now I'm e.g. using a "raw"
>> io_uring_enter(IORING_ENTER_GETEVENTS)
>>> to be able to have multiple processes safely wait for events on the
>> same
>>> uring, without needing to hold the lock [1] protecting the ring [2]. 
>> It's
>>> probably a good idea to add a liburing function to be able to do so,
>> but
>>> I'd guess there are going to continue to be cases like that. In a bit
>>> of time it seems likely that at least open source users of uring that
>>> are included in databases, have to work against multiple versions of
>>> liburing (as usually embedding libs is not allowed), and sometimes
>> that
>>> is easier if one can backfill a function or two if necessary.
>>>
>>> That syscall should probably be under a name that won't conflict with
>>> eventual glibc implementation of the syscall.
>>>
>>> Obviously I can just do the syscall() etc myself, but it seems
>>> unnecessary to have a separate copy of the ifdefs for syscall numbers
>>> etc.
>>>
>>> What do you think?
>>
>> Not sure what I'm missing here, but liburing already has
>> __sys_io_uring_enter() for this purpose, and ditto for the register
>> and setup functions?
> 
> Aren't they hidden to the outside by the symbol versioning script?

So you just want to have them exposed? I'd be fine with that. I'll
take a patch :-)

-- 
Jens Axboe

