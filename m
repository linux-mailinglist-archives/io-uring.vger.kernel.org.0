Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 371D654A7A4
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 05:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238336AbiFNDre (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jun 2022 23:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbiFNDrd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jun 2022 23:47:33 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 975CEF6F
        for <io-uring@vger.kernel.org>; Mon, 13 Jun 2022 20:47:29 -0700 (PDT)
Message-ID: <78fd260d-f576-4ffa-5989-8d1e68fd4f35@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655178448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3fh8e38viRdV8bwFvHU+P2fD/SU7NwKaQYUl8Hle/2I=;
        b=xMCVyyR3ZFH1lbZAGO9zYpg9nH3VmyllC2+RVKu+ImrOeBE7kPdKpFIoq7Tx3Dk2GAsOp5
        AfzmW1sHewmwdMcAFXExKCvuliHbvjWx+njTg1JhtXuOO04YXDIB3B+fFvf0MNlFFgPxAH
        /QRN7WIL6+TbRQnAnH2tWSzkLmR6CBA=
Date:   Tue, 14 Jun 2022 11:47:04 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 0/3] io_uring: fixes for provided buffer ring
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Dylan Yudaken <dylany@fb.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Cc:     Kernel Team <Kernel-team@fb.com>
References: <20220613101157.3687-1-dylany@fb.com>
 <f2fddce1-bc25-183e-6095-bb5a70a57319@linux.dev>
 <de5e6f02-dcab-07df-7cc4-7f12885083e6@gmail.com>
 <265e0239ff5b6a8a4a6d91446c774549affb5191.camel@fb.com>
 <e609bd27-9a2e-f367-1ccb-bd93dc3a71e2@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <e609bd27-9a2e-f367-1ccb-bd93dc3a71e2@gmail.com>
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

On 6/13/22 22:05, Pavel Begunkov wrote:
> On 6/13/22 14:16, Dylan Yudaken wrote:
>> On Mon, 2022-06-13 at 13:59 +0100, Pavel Begunkov wrote:
>>> On 6/13/22 12:08, Hao Xu wrote:
>>>> On 6/13/22 18:11, Dylan Yudaken wrote:
>>>>> This fixes two problems in the new provided buffer ring feature.
>>>>> One
>>>>> is a simple arithmetic bug (I think this came out from a
>>>>> refactor).
>>>>> The other is due to type differences between head & tail, which
>>>>> causes
>>>>> it to sometimes reuse an old buffer incorrectly.
>>>>>
>>>>> Patch 1&2 fix bugs
>>>>> Patch 3 limits the size of the ring as it's not
>>>>> possible to address more entries with 16 bit head/tail
>>>>
>>>> Reviewed-by: Hao Xu <howeyxu@tencent.com>
>>>>
>>>>>
>>>>> I will send test cases for liburing shortly.
>>>>>
>>>>> One question might be if we should change the type of
>>>>> ring_entries
>>>>> to uint16_t in struct io_uring_buf_reg?
>>>>
>>>> Why not? 5.19 is just rc2 now. So we can assume there is no users
>>>> using
>>>> it right now I think?
>>>
>>> It's fine to change, but might be better if we want to extend it
>>> in the future. Do other pbuf bits allow more than 2^16 buffers?
>>>
> 
> might be better to leave it u32 *
> 
>> I guess with
>>
>> +    if (reg.ring_entries >= 65536)
>> +        return -EINVAL;
>>
>> it doesn't matter either way. we can always use those bits later if we
>> need?
> 
> I think so as well.
> 
> I was also wondering whether pbufs can potentially allow >16 bits,
> but taking a quick look IORING_CQE_BUFFER_SHIFT=16, so we only have
> 16 bits in cqe::flags for indexes we return.
> 

Yea, the 16 bits return index in cqe->flags is a hard limit for
pbuf ring feature, but I do think it's ok since 1<<16 is already big
