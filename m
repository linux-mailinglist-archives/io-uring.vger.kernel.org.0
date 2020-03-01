Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41774174E8C
	for <lists+io-uring@lfdr.de>; Sun,  1 Mar 2020 17:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbgCAQmS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 Mar 2020 11:42:18 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42909 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgCAQmS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 Mar 2020 11:42:18 -0500
Received: by mail-wr1-f68.google.com with SMTP id z11so696608wro.9;
        Sun, 01 Mar 2020 08:42:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bbKHxflMjsgqF1ooVb0LYJao+ZmBpD8MpwmE6/bKXGo=;
        b=s+j3ZwetR4lyJq3YAPwl+zPqbZbEwBilpinVE3tnK55BdMpGGyQfTNW5KzjzgFhKl0
         WWsum7w57YEjzKde6T6Y2J7ZyhVNKW5kDrnJ/Bl41rV7nt4K1XsrD3rpksFcoGQFYzaM
         6Vz5j0bOtWI4quGilr5SJnb1WW09I/fJDCxQXNw6bbsoH/MU+kUKaJIDafiFpIn+edsi
         E+ePXuPVTjrGHvjg7CANtVqjn4ckXnZIpn95z/+rKkSNPi80UeuWIhkEiIg5hcwftcR1
         PmrJEHADTsPjtq8Mi5pdNW5GrHUGg840jOPS1FwdqHmjaIvOt4/pHBaZKKEDPc2Tz5oG
         I9tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bbKHxflMjsgqF1ooVb0LYJao+ZmBpD8MpwmE6/bKXGo=;
        b=N4CYxYRXKZbhrTT0M29O5bspQCB/aPRyM59/J/e+M6dozfMekplcmTF/VFLy+3KSzj
         nl8FybiAK+18t14hSpnogj1OLxZgDPa9f6rl4OWb/BOhM3/9IiwaR3Tdt7Z6ECrIOgVj
         T7Zkzcw3qiacRljpNhRoyQHfLXvtETC3m66d0tTrg70Ou616m0oMO4NUHqrSlZh4zGAk
         ySvVTRVU+ZTTH+RsyTvwqnXQ60iq7HMVqD4iNcL52jfPSdjic5TicQIdfZbKBBn456Lh
         FVB9b5qBJGUAcQcl+Mp7kVsENiWshsCbiBL1thZTtGxDBZUOH3ZepLjofDjTHnKb1ajG
         ajUA==
X-Gm-Message-State: APjAAAWSn3KGtgi/7TpevGM4bx1D7xUpuHk35T/cxLGsJkO4PUHpeP/2
        v1QmDb9KE4rXfVTe+xWMclo4b560
X-Google-Smtp-Source: APXvYqzEd+vSlq0bBHGPFQ6mwF/Xs7DMOzjVexkZwciQljNG4UQZ/lRpH7OsD5he5hRr7nUoxxPNow==
X-Received: by 2002:a5d:42c8:: with SMTP id t8mr16823096wrr.261.1583080933776;
        Sun, 01 Mar 2020 08:42:13 -0800 (PST)
Received: from [192.168.43.139] ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id l4sm6061454wmf.38.2020.03.01.08.42.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Mar 2020 08:42:13 -0800 (PST)
Subject: Re: [PATCH RFC 0/9] nxt propagation + locking optimisation
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1583078091.git.asml.silence@gmail.com>
 <fe4cb05b-2fd0-25dd-e120-9a9d57659008@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <101bed21-670c-4ade-e513-b15848ef1361@gmail.com>
Date:   Sun, 1 Mar 2020 19:41:27 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <fe4cb05b-2fd0-25dd-e120-9a9d57659008@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 01/03/2020 19:23, Pavel Begunkov wrote:
> On 01/03/2020 19:18, Pavel Begunkov wrote:
>> There are several independent parts in the patchset, but bundled
>> to make a point.
>> 1-2: random stuff, that implicitly used later.
>> 3-5: restore @nxt propagation
>> 6-8: optimise locking in io_worker_handle_work()
>> 9: optimise io_uring refcounting
>>
>> The next propagation bits are done similarly as it was before, but
>> - nxt stealing is now at top-level, but not hidden in handlers
>> - ensure there is no with REQ_F_DONT_STEAL_NEXT
>>
>> [6-8] is the reason to dismiss the previous @nxt propagation appoach,
>> I didn't found a good way to do the same. Even though it looked
>> clearer and without new flag.
>>
>> Performance tested it with link-of-nops + IOSQE_ASYNC:
>>
>> link size: 100
>> orig:  501 (ns per nop)
>> 0-8:   446
>> 0-9:   416
>>
>> link size: 10
>> orig:  826
>> 0-8:   776
>> 0-9:   756
> 
> BTW, that's basically QD1, and with contention for wqe->lock the gap should be
> even wider.

And another notice: "orig" actually includes [1-5], so @nxt propagation was
working there.

>>
>> Pavel Begunkov (9):
>>   io_uring: clean up io_close
>>   io-wq: fix IO_WQ_WORK_NO_CANCEL cancellation
>>   io_uring: make submission ref putting consistent
>>   io_uring: remove @nxt from handlers
>>   io_uring: get next req on subm ref drop
>>   io-wq: shuffle io_worker_handle_work() code
>>   io-wq: io_worker_handle_work() optimise locking
>>   io-wq: optimise double lock for io_get_next_work()
>>   io_uring: pass submission ref to async
>>
>>  fs/io-wq.c    | 162 ++++++++++++----------
>>  fs/io_uring.c | 366 ++++++++++++++++++++++----------------------------
>>  2 files changed, 258 insertions(+), 270 deletions(-)
>>
> 

-- 
Pavel Begunkov
