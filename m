Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D36B922FA25
	for <lists+io-uring@lfdr.de>; Mon, 27 Jul 2020 22:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729325AbgG0Ued (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jul 2020 16:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729266AbgG0Ued (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jul 2020 16:34:33 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1280C0619D6
        for <io-uring@vger.kernel.org>; Mon, 27 Jul 2020 13:34:32 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id t6so8774675plo.3
        for <io-uring@vger.kernel.org>; Mon, 27 Jul 2020 13:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1e9h0tE+ElK0HWRPXiuc5VM0AhTp1F0sLszAnPFX/o4=;
        b=ZafaxclzPZhVsXz8l83xVPlfPaaHGIsnBsq3YYS+6u818LolWPB9JvqcfE5gaa8xTt
         xMeKMiEUoOBjhQEN30y00OvB3GJvnZCmHen3WlDqQl1atnjPNZzXQnXq13xWBdO0RqDk
         UjBeZR8HAFCSn6EgK2imAOBWV4HTBBMGp+cS1LMXd97OoXjDVUB7TSQtJTGuKlyPFlGv
         47hzCZYu25rqnnw5lCBm48U/PxTUsLm9HQwDcpHJ8BS5Iqy1eq8Y1QSbIF+igXGeLiaw
         5kQb4Je9qd10su3MNHjyZt2WiZXA5AoXdEge+klxew2Fz7tViQhLADlu2el1GkI3bMX9
         ko6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1e9h0tE+ElK0HWRPXiuc5VM0AhTp1F0sLszAnPFX/o4=;
        b=OvO1cr++EO4rn2S09KTFnCoCJMoMZwvU/pCremDoTSwYJxgkoI3+5igqHuQD3l7irs
         buuB4Gv1pD2OlvEQCAq1RQvWDe54d2Renpp7HShuuNxhel1tnLblDwjsr0TV/tAoSUi0
         t5IGtkw/mbEug/TdsOmEKviyiyRtTSdTHETiTbHpGFt+Cb77QaG8eC+Z5Sih3ICJdSLI
         UV9hT/zx+lR2Zr51sTRlnKJGOt64Q7NaslZ/QLRq9CUwZQ0gK9U5Y8IobSPuI4WSijM1
         tV3oRHFtZW33T7TlYTlGVelL9MuJppK4UI9PSyjxPtC/rEgDmQaBVSjIA6OpRZFkWpVq
         bJVw==
X-Gm-Message-State: AOAM533qxhwULD94kp3KXh0I4gPCFEWX2Z7URIjjgzxf9SmjuJ02bpXn
        J2K5A1b9yxNQ+R6L9V6vtu8NQA==
X-Google-Smtp-Source: ABdhPJwgxPuj693Id+Oo3CVUmOizUrGVehGlzvteg1ajBPCJTwzcrqE4V3UY3qCfXHxGAvoiCewkzg==
X-Received: by 2002:a17:90b:120a:: with SMTP id gl10mr927614pjb.44.1595882072153;
        Mon, 27 Jul 2020 13:34:32 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id u26sm16345833pfn.54.2020.07.27.13.34.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jul 2020 13:34:31 -0700 (PDT)
Subject: Re: [PATCH v4 6/6] io_uring: add support for zone-append
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        asml.silence@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-api@vger.kernel.org, SelvaKumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
References: <1595605762-17010-1-git-send-email-joshi.k@samsung.com>
 <CGME20200724155350epcas5p3b8f1d59eda7f8fbb38c828f692d42fd6@epcas5p3.samsung.com>
 <1595605762-17010-7-git-send-email-joshi.k@samsung.com>
 <f5416bd4-93b3-4d14-3266-bdbc4ae1990b@kernel.dk>
 <CA+1E3rJAa3E2Ti0fvvQTzARP797qge619m4aYLjXeR3wxdFwWw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b0b7159d-ed10-08ad-b6c7-b85d45f60d16@kernel.dk>
Date:   Mon, 27 Jul 2020 14:34:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CA+1E3rJAa3E2Ti0fvvQTzARP797qge619m4aYLjXeR3wxdFwWw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/27/20 1:16 PM, Kanchan Joshi wrote:
> On Fri, Jul 24, 2020 at 10:00 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 7/24/20 9:49 AM, Kanchan Joshi wrote:
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 7809ab2..6510cf5 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -1284,8 +1301,15 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
>>>       cqe = io_get_cqring(ctx);
>>>       if (likely(cqe)) {
>>>               WRITE_ONCE(cqe->user_data, req->user_data);
>>> -             WRITE_ONCE(cqe->res, res);
>>> -             WRITE_ONCE(cqe->flags, cflags);
>>> +             if (unlikely(req->flags & REQ_F_ZONE_APPEND)) {
>>> +                     if (likely(res > 0))
>>> +                             WRITE_ONCE(cqe->res64, req->rw.append_offset);
>>> +                     else
>>> +                             WRITE_ONCE(cqe->res64, res);
>>> +             } else {
>>> +                     WRITE_ONCE(cqe->res, res);
>>> +                     WRITE_ONCE(cqe->flags, cflags);
>>> +             }
>>
>> This would be nice to keep out of the fast path, if possible.
> 
> I was thinking of keeping a function-pointer (in io_kiocb) during
> submission. That would have avoided this check......but argument count
> differs, so it did not add up.

But that'd grow the io_kiocb just for this use case, which is arguably
even worse. Unless you can keep it in the per-request private data,
but there's no more room there for the regular read/write side.

>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>> index 92c2269..2580d93 100644
>>> --- a/include/uapi/linux/io_uring.h
>>> +++ b/include/uapi/linux/io_uring.h
>>> @@ -156,8 +156,13 @@ enum {
>>>   */
>>>  struct io_uring_cqe {
>>>       __u64   user_data;      /* sqe->data submission passed back */
>>> -     __s32   res;            /* result code for this event */
>>> -     __u32   flags;
>>> +     union {
>>> +             struct {
>>> +                     __s32   res;    /* result code for this event */
>>> +                     __u32   flags;
>>> +             };
>>> +             __s64   res64;  /* appending offset for zone append */
>>> +     };
>>>  };
>>
>> Is this a compatible change, both for now but also going forward? You
>> could randomly have IORING_CQE_F_BUFFER set, or any other future flags.
> 
> Sorry, I didn't quite understand the concern. CQE_F_BUFFER is not
> used/set for write currently, so it looked compatible at this point.

Not worried about that, since we won't ever use that for writes. But it
is a potential headache down the line for other flags, if they apply to
normal writes.

> Yes, no room for future flags for this operation.
> Do you see any other way to enable this support in io-uring?

Honestly I think the only viable option is as we discussed previously,
pass in a pointer to a 64-bit type where we can copy the additional
completion information to.

>> Layout would also be different between big and little endian, so not
>> even that easy to set aside a flag for this. But even if that was done,
>> we'd still have this weird API where liburing or the app would need to
>> distinguish this cqe from all others based on... the user_data? Hence
>> liburing can't do it, only the app would be able to.
>>
>> Just seems like a hack to me.
> 
> Yes, only user_data to distinguish. Do liburing helpers need to look
> at cqe->res (and decide something) before returning the cqe to
> application?

They generally don't, outside of the internal timeout. But it's an issue
for the API, as it forces applications to handle the CQEs a certain way.
Normally there's flexibility. This makes the append writes behave
differently than everything else, which is never a good idea.

-- 
Jens Axboe

