Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60CA054ADC0
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 11:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239637AbiFNJxB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 05:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240965AbiFNJw7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 05:52:59 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BAA71F61D
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 02:52:53 -0700 (PDT)
Message-ID: <659462b3-4fc7-12ed-f760-da0f222539a0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655200371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ctXmhXgvFDTZSyhrdBIuHSU7/aPKdHgKMEwt0ilpmek=;
        b=NZuYvd+KOCizZkIph0hs3v43Qz4EDXIghh2NCq7xIRCrAQoOA4Il43ovD6Fr0wqqBXWx7j
        9hQub1CuIOzLbECypvxkm85xsNbpWaGRsy8H/y4onxc0cAEtIPRLv3gwwu9JRWfM/wzQf9
        BbZ32XMD58vDq3/VhZ57vRKbaFOM/ps=
Date:   Tue, 14 Jun 2022 17:52:41 +0800
MIME-Version: 1.0
Subject: Re: [RFC] support memory recycle for ring-mapped provided buffer
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Cc:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>
References: <6641baea-ba35-fb31-b2e7-901d72e9d9a0@linux.dev>
 <4980fd4d-b1f3-7b1c-8bfc-6be4d31f9da0@linux.dev>
 <d4aada77-1dce-55e7-3a7c-bf4b3add3ac3@linux.dev>
 <a62d21cc5a3f9741673f9bf912d2ec4c97c4e193.camel@fb.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <a62d21cc5a3f9741673f9bf912d2ec4c97c4e193.camel@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Dylan,

On 6/14/22 16:38, Dylan Yudaken wrote:
> On Tue, 2022-06-14 at 14:26 +0800, Hao Xu wrote:
>> On 6/12/22 15:30, Hao Xu wrote:
>>> On 6/10/22 13:55, Hao Xu wrote:
>>>> Hi all,
>>>>
>>>> I've actually done most code of this, but I think it's necessary
>>>> to
>>>> first ask community for comments on the design. what I do is when
>>>> consuming a buffer, don't increment the head, but check the
>>>> length
>>>> in real use. Then update the buffer info like
>>>> buff->addr += len, buff->len -= len;
>>>> (off course if a req consumes the whole buffer, just increment
>>>> head)
>>>> and since we now changed the addr of buffer, a simple buffer id
>>>> is
>>>> useless for userspace to get the data. We have to deliver the
>>>> original
>>>> addr back to userspace through cqe->extra1, which means this
>>>> feature
>>>> needs CQE32 to be on.
>>>> This way a provided buffer may be splited to many pieces, and
>>>> userspace
>>>> should track each piece, when all the pieces are spare again,
>>>> they can
>>>> re-provide the buffer.(they can surely re-provide each piece
>>>> separately
>>>> but that causes more and more memory fragments, anyway, it's
>>>> users'
>>>> choice.)
>>>>
>>>> How do you think of this? Actually I'm not a fun of big cqe, it's
>>>> not
>>>> perfect to have the limitation of having CQE32 on, but seems no
>>>> other
>>>> option?
>>
>> Another way is two rings, just like sqring and cqring. Users provide
>> buffers to sqring, kernel fetches it and when data is there put it to
>> cqring for users to read. The downside is we need to copy the buffer
>> metadata. and there is a limitation of how many times we can split
>> the
>> buffer since the cqring has a length.
>>
>>>>
>>>> Thanks,
>>>> Hao
>>>
>>> To implement this, CQE32 have to be introduced to almost
>>> everywhere.
>>> For example for io_issue_sqe:
>>>
>>> def->issue();
>>> if (unlikely(CQE32))
>>>       __io_req_complete32();
>>> else
>>>       __io_req_complete();
>>>
>>> which will cerntainly have some overhead for main path. Any
>>> comments?

For this downside, I think there is way to limit it to only read/recv
path.

>>>
>>> Regards,
>>> Hao
>>>
>>
> 
> I find the idea interesting, but is it definitely worth doing?
> 
> Other downsides I see with this approach:
> * userspace would have to keep track of when a buffer is finished. This
> might get complicated.
This one is fine I think, since users can choose not to enable this
feature and if they use it, they can choose not to track the buffer
but to re-provide each piece immediately.
(When a user register the pbuf ring, they can deliver a flag to enable
this feature.)

> * there is a problem of tiny writes - would we want to support a
> minimum buffer size?

Sorry I'm not following here, why do we need to have a min buffer size?

> 
> I think in general it can be acheived using the existing buffer ring
> and leave the management to userspace. For example if a user prepares a
> ring with N large buffers, on each completion the user is free to
> requeue that buffer without the recently completed chunk.

[1]
I see, was not aware of this...

> 
> The downsides here I see are:
>   * there is a delay to requeuing the buffer. This might cause more
> ENOBUFS. Practically I 'feel' this will not be a big problem in
> practice
>   * there is an additional atomic incrememnt on the ring
> 
> Do you feel the wins are worth the extra complexity?

Personally speaking, the only downside of my first approach is overhead
of cqe32 on iopoll completion path and read/recv/recvmsg path. But looks
[1] is fine...TBH I'm not sure which one is better.

Thanks,
Hao

> 
> 

