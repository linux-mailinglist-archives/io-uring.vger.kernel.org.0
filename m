Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E66B516AA90
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 16:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727693AbgBXP5o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 10:57:44 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:41822 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727359AbgBXP5n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 10:57:43 -0500
Received: by mail-il1-f195.google.com with SMTP id f10so8101416ils.8
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 07:57:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=6RNKxFKRNBa2Nu1EEDxGB0OsiQZyYDVlLFoQrqcaEbQ=;
        b=JMWJJ8tTIofT/fZvPdQqL+nEzp86ORvrBzMpdTSBX3OKSpCtrN8dwqqBsYndlXz78H
         2Ds0qot3ncd8hSfA9d1A6aMY1yImsPUTbvzXQAzmHfBm3uYeJZmPVuCQRbFQJSKhcwzX
         wsqpAhQuHli3v/G/UNKjc206KnBHx1m+4qyHUhdi0R0kONkkuLFPkZmBSzlUgkImEM4a
         DP2P0/GFHK+HQHjjhq0dQG78Oclo4+ave0jDlcC5Dtn4FcCdORItPtGnOy8bg4XACVrw
         f/VRFji6uKbO2YAcB9Uqo+00A39ZByxQdiOEaqcnkIiEw5ia/RLUiznq3AD+rL7ZeJpT
         o9jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6RNKxFKRNBa2Nu1EEDxGB0OsiQZyYDVlLFoQrqcaEbQ=;
        b=pjKhprBqwoXiPzGVWFBv36PEsNcMWGHUGdWHxqtl/EtndMYasr25ywDObMBuOqSGPa
         Gy3xCFh/IPd/qj2E27a3C1SYRIADbnbwASHaQkOboYfDvJDjJeA2hoXTJJodHAYF53rH
         FZLmnP0Ifaj/bdOGfREl0kvGC4J4BO1jslTwk+qQ6kFFEv8yZpC94BFejs88NYOwb3SI
         NSQDzuvMmDxa2J+oFUI7vK3ThiPjMnz0u5s4Mj7lf3PLHc0dRpVmB5WP16nt7syEfcej
         uxEe5QB881tBpGppHmUV4gfII576kzh8rTcF4gh7iS/McNXkUfYoiZNd2Uw1W3oG3gSi
         naTg==
X-Gm-Message-State: APjAAAVUCWKyKt7Oiir/78IpVw5Pd2FQVumFSGCRSod4+YkTNyJu8Io9
        QXlkAgu3XjOrkjwEBbQgiWRZ7s0bIu0=
X-Google-Smtp-Source: APXvYqwXz6mWpOhbfnMV+lE0QCqMFdfk8CJxaAlXuahY6srTrjUK01bpcvlT+kxzcST5ryiQvd6Tsw==
X-Received: by 2002:a92:413:: with SMTP id 19mr58540537ile.117.1582559861556;
        Mon, 24 Feb 2020 07:57:41 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id u20sm3060915iom.27.2020.02.24.07.57.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 07:57:41 -0800 (PST)
Subject: Re: [PATCH v3 2/3] io_uring: don't do full *prep_worker() from io-wq
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1582530396.git.asml.silence@gmail.com>
 <ca345ead1a45ce9d2c4f916b07a4a2e8eae328e8.1582530396.git.asml.silence@gmail.com>
 <8c439182-008b-dfe6-82e7-487c849a2092@kernel.dk>
 <1f2860f8-aff5-972d-a399-6b0f10fd2373@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b7789d5f-07a2-f8de-2590-400466340446@kernel.dk>
Date:   Mon, 24 Feb 2020 08:57:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1f2860f8-aff5-972d-a399-6b0f10fd2373@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/24/20 8:48 AM, Pavel Begunkov wrote:
> On 24/02/2020 18:30, Jens Axboe wrote:
>> On 2/24/20 1:30 AM, Pavel Begunkov wrote:
>>> io_prep_async_worker() called io_wq_assign_next() do many useless checks:
>>> io_req_work_grab_env() was already called during prep, and @do_hashed
>>> is not ever used. Add io_prep_next_work() -- simplified version, that
>>> can be called io-wq.
>>>
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>  fs/io_uring.c | 13 ++++++++++++-
>>>  1 file changed, 12 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 819661f49023..3003e767ced3 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -955,6 +955,17 @@ static inline void io_req_work_drop_env(struct io_kiocb *req)
>>>  	}
>>>  }
>>>  
>>> +static inline void io_prep_next_work(struct io_kiocb *req,
>>> +				     struct io_kiocb **link)
>>> +{
>>> +	const struct io_op_def *def = &io_op_defs[req->opcode];
>>> +
>>> +	if (!(req->flags & REQ_F_ISREG) && def->unbound_nonreg_file)
>>> +			req->work.flags |= IO_WQ_WORK_UNBOUND;
>>
>> Extra tab?
> 
> Yep. Would resending [2/3] be enough?

No need, I just did a hand edit of the patch before applying.

-- 
Jens Axboe

