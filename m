Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE4FF2DAC4A
	for <lists+io-uring@lfdr.de>; Tue, 15 Dec 2020 12:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbgLOLpu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Dec 2020 06:45:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726951AbgLOLpM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Dec 2020 06:45:12 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF48C06179C;
        Tue, 15 Dec 2020 03:44:31 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id y23so18218419wmi.1;
        Tue, 15 Dec 2020 03:44:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OWwRZGVysOGW0Xc4n3DjuAEe5aIQZl9wIJ+AWET/hOI=;
        b=AMTXx6TTD352jGB3PrcCaEUiWdJOssWhewuqsduGuOThnSCQisHMFsZyAmf9shugqg
         7f+Fn+gtQt6d9DzpHbl4i125FZLTs+IFwStWEmYnOWee7YEHGIZzH8e1fTeSln0M/Z3r
         RAgikd05DcfIGb8X6fo0tFoVQGB9amDOkHABBfO4vafld96bwNPGQkbscaPJWwu9d3WQ
         etev0b7CCnBCptzleYf/IGvGcnP/Zb3mst6FzLAYlqBoauUdpk1FAeNQqH3GoFcNAmZm
         QRRwsh9PmutkLvBJuK5bXstcxKpB3+8nJbVWdZ94ZQVMGbhRdh4iDe2Zw7gb1ljUXdY9
         X9HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=OWwRZGVysOGW0Xc4n3DjuAEe5aIQZl9wIJ+AWET/hOI=;
        b=ap5bVjbqshVJCRXTSzHA1M+PphySxMD4SWjNZw+6KDYONjdwtkyCSgOid4B0gbHEy2
         q9xTIxUAqzcd8iuiZjEi2Bq2gWgXZpZm7MPdO4XrfEhbDCcXe7q4EIR5B3fGDyjd3hny
         DO5LVEoR6RB05ISi1e3HlRRq5SOoXPE2VJbFN3bSQD5KNT115eRC43kBzj+86mQ/eZuZ
         snvqURGK0psw2RFvw1/V7AGVTy4dSZm7trTD4/hM+9wk/t5zud1NB/CGZgAl1w/DRGK4
         yyDrOPe80/yj123XHT5pQq5mktmO6NrqycbOzbXwY2dHoFYhoGRN6CSOW3rr8iRNgFIw
         xVrQ==
X-Gm-Message-State: AOAM531iiSY0NUq6DpET1fto2ns0c7YAK+fdDuv/5olxfOfPBANf/yjT
        7Os+CiiCsQe6c0cd0/noQTgMgQQDiDT5bRaq
X-Google-Smtp-Source: ABdhPJxZhWNo4K56HmDD6LuDz+9jky+iOr3Bue398Aop8a3uegKgJUFzW4i5BXY8aVFtVsIW94CryA==
X-Received: by 2002:a7b:c145:: with SMTP id z5mr32397755wmi.164.1608032670438;
        Tue, 15 Dec 2020 03:44:30 -0800 (PST)
Received: from [192.168.8.128] ([185.69.145.6])
        by smtp.gmail.com with ESMTPSA id b14sm36954767wrx.77.2020.12.15.03.44.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 03:44:29 -0800 (PST)
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Ming Lei <ming.lei@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org
References: <cover.1607976425.git.asml.silence@gmail.com>
 <1d3cf86668e44b3a3d35b5dbe759a086a157e434.1607976425.git.asml.silence@gmail.com>
 <20201215005659.GF632069@dread.disaster.area>
 <e8adf941-9901-b54c-d7a0-b785923558fb@gmail.com>
 <20201215013312.GK632069@dread.disaster.area>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v1 4/6] block/psi: remove PSI annotations from direct IO
Message-ID: <d5c1203c-c4b0-2f3b-5dd8-56743b88a834@gmail.com>
Date:   Tue, 15 Dec 2020 11:41:11 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20201215013312.GK632069@dread.disaster.area>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 15/12/2020 01:33, Dave Chinner wrote:
> On Tue, Dec 15, 2020 at 01:03:45AM +0000, Pavel Begunkov wrote:
>> On 15/12/2020 00:56, Dave Chinner wrote:
>>> On Tue, Dec 15, 2020 at 12:20:23AM +0000, Pavel Begunkov wrote:
>>>> As reported, we must not do pressure stall information accounting for
>>>> direct IO, because otherwise it tells that it's thrashing a page when
>>>> actually doing IO on hot data.
>>>>
>>>> Apparently, bio_iov_iter_get_pages() is used only by paths doing direct
>>>> IO, so just make it avoid setting BIO_WORKINGSET, it also saves us CPU
>>>> cycles on doing that. For fs/direct-io.c just clear the flag before
>>>> submit_bio(), it's not of much concern performance-wise.
>>>>
>>>> Reported-by: Christoph Hellwig <hch@infradead.org>
>>>> Suggested-by: Christoph Hellwig <hch@infradead.org>
>>>> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>> ---
>>>>  block/bio.c    | 25 ++++++++++++++++---------
>>>>  fs/direct-io.c |  2 ++
>>>>  2 files changed, 18 insertions(+), 9 deletions(-)
>>> .....
>>>> @@ -1099,6 +1103,9 @@ static int __bio_iov_append_get_pages(struct bio *bio, struct iov_iter *iter)
>>>>   * fit into the bio, or are requested in @iter, whatever is smaller. If
>>>>   * MM encounters an error pinning the requested pages, it stops. Error
>>>>   * is returned only if 0 pages could be pinned.
>>>> + *
>>>> + * It also doesn't set BIO_WORKINGSET, so is intended for direct IO. If used
>>>> + * otherwise the caller is responsible to do that to keep PSI happy.
>>>>   */
>>>>  int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
>>>>  {
>>>> diff --git a/fs/direct-io.c b/fs/direct-io.c
>>>> index d53fa92a1ab6..914a7f600ecd 100644
>>>> --- a/fs/direct-io.c
>>>> +++ b/fs/direct-io.c
>>>> @@ -426,6 +426,8 @@ static inline void dio_bio_submit(struct dio *dio, struct dio_submit *sdio)
>>>>  	unsigned long flags;
>>>>  
>>>>  	bio->bi_private = dio;
>>>> +	/* PSI is only for paging IO */
>>>> +	bio_clear_flag(bio, BIO_WORKINGSET);
>>>
>>> Why only do this for the old direct IO path? Why isn't this
>>> necessary for the iomap DIO path?
>>
>> It's in the description. In short, block and iomap dio use
>> bio_iov_iter_get_pages(), which with this patch doesn't use
>> [__]bio_add_page() and so doesn't set the flag. 
> 
> That is not obvious to someone not intimately familiar with the
> patchset you are working on. You described -what- the code is doing,
> not -why- the flag needs to be cleared here.

It's missing the link between BIO_WORKINGSET and PSI, but otherwise
it describe both, what it does and how. I'll reword it for you next
iteration.

> 
> "Direct IO does not operate on the current working set of pages
> managed by the kernel, so it should not be accounted as IO to the
> pressure stall tracking infrastructure. Only direct IO paths use
> bio_iov_iter_get_pages() to build bios, so to avoid PSI tracking of
> direct IO don't flag the bio with BIO_WORKINGSET in this function.
> 
> fs/direct-io.c uses <some other function> to build the bio we
> are going to submit and so still flags the bio with BIO_WORKINGSET.
> Rather than convert it to use bio_iov_iter_get_pages() to avoid
> flagging the bio, we simply clear the BIO_WORKINGSET flag before
> submitting the bio."
> 
> Cheers,
> 
> Dave.
> 

-- 
Pavel Begunkov
