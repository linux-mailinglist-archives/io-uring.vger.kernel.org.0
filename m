Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B43154A961
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 08:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237532AbiFNG0a (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 02:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiFNG03 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 02:26:29 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B035C275EA
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 23:26:27 -0700 (PDT)
Message-ID: <d4aada77-1dce-55e7-3a7c-bf4b3add3ac3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655187982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7BRz34s+AgBryQDGKllpATJKUB0YomQJlzZkzrvHfQE=;
        b=Y3/UL6yo5wL8seXUa7JtSokiGUcuSYr5Du85ZOpmo18a0cYaCvn+P6sHNKIbRc/xVQiI6C
        FN7xSwcRYyngrFQwo8LuafFVsxpbkkfKRqT17ID3g9R32hra1Kg1VZFFpk4BrYsYkp8cjl
        8hcILwF9VUlWnv7Egkbjv29bjgztuFM=
Date:   Tue, 14 Jun 2022 14:26:00 +0800
MIME-Version: 1.0
Subject: Re: [RFC] support memory recycle for ring-mapped provided buffer
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <6641baea-ba35-fb31-b2e7-901d72e9d9a0@linux.dev>
 <4980fd4d-b1f3-7b1c-8bfc-6be4d31f9da0@linux.dev>
In-Reply-To: <4980fd4d-b1f3-7b1c-8bfc-6be4d31f9da0@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/12/22 15:30, Hao Xu wrote:
> On 6/10/22 13:55, Hao Xu wrote:
>> Hi all,
>>
>> I've actually done most code of this, but I think it's necessary to
>> first ask community for comments on the design. what I do is when
>> consuming a buffer, don't increment the head, but check the length
>> in real use. Then update the buffer info like
>> buff->addr += len, buff->len -= len;
>> (off course if a req consumes the whole buffer, just increment head)
>> and since we now changed the addr of buffer, a simple buffer id is
>> useless for userspace to get the data. We have to deliver the original
>> addr back to userspace through cqe->extra1, which means this feature
>> needs CQE32 to be on.
>> This way a provided buffer may be splited to many pieces, and userspace
>> should track each piece, when all the pieces are spare again, they can
>> re-provide the buffer.(they can surely re-provide each piece separately
>> but that causes more and more memory fragments, anyway, it's users'
>> choice.)
>>
>> How do you think of this? Actually I'm not a fun of big cqe, it's not
>> perfect to have the limitation of having CQE32 on, but seems no other
>> option?

Another way is two rings, just like sqring and cqring. Users provide
buffers to sqring, kernel fetches it and when data is there put it to
cqring for users to read. The downside is we need to copy the buffer
metadata. and there is a limitation of how many times we can split the
buffer since the cqring has a length.

>>
>> Thanks,
>> Hao
> 
> To implement this, CQE32 have to be introduced to almost everywhere.
> For example for io_issue_sqe:
> 
> def->issue();
> if (unlikely(CQE32))
>      __io_req_complete32();
> else
>      __io_req_complete();
> 
> which will cerntainly have some overhead for main path. Any comments?
> 
> Regards,
> Hao
> 

