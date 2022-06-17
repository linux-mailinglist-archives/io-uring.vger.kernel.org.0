Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 648DC54EFEA
	for <lists+io-uring@lfdr.de>; Fri, 17 Jun 2022 05:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379667AbiFQD7X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jun 2022 23:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234061AbiFQD7U (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jun 2022 23:59:20 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A4A66693
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 20:59:18 -0700 (PDT)
Message-ID: <9d6add0d-9cf6-e617-76fa-c37e604635d5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655438356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+qfMGHltJ+YKR6ePS7kreeZa1OzX3siFMv207WEaVWI=;
        b=wXX8oZvA8fhB3Bx3qTZ4y6YWOalZGNIghazE7jBa41ZFNg4W3S9h49NDOVyZFRf5QEoU0P
        P6D+HWjXsX9tA2X0F8qrwRqA21SRI75P1nJfRYAqwCGeDpwqXXAiRRayOSfc9qdosz2KaH
        QF5odX9At2DrPwSka6Vpb0ZLpUrqev4=
Date:   Fri, 17 Jun 2022 11:59:09 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] io_uring: kbuf: add comments for some tricky code
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>
References: <20220614120108.1134773-1-hao.xu@linux.dev>
 <a3251a5e-d3cd-0fe2-db49-c81f177d534a@kernel.dk>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <a3251a5e-d3cd-0fe2-db49-c81f177d534a@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
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

On 6/17/22 04:37, Jens Axboe wrote:
> On 6/14/22 6:01 AM, Hao Xu wrote:
>> From: Hao Xu <howeyxu@tencent.com>
>>
>> Add comments to explain why it is always under uring lock when
>> incrementing head in __io_kbuf_recycle. And rectify one comemnt about
>> kbuf consuming in iowq case.
> 
> Was there a 1/2 patch in this series? This one has a subject of 2/2...

Apologize for this, 1/2 and this should be separate, and I'm not going
to send 1/2 for now for some reason. I should have change the subject.

> 
>> Signed-off-by: Hao Xu <howeyxu@tencent.com>
>> ---
>>   io_uring/kbuf.c | 20 ++++++++++++++------
>>   1 file changed, 14 insertions(+), 6 deletions(-)
>>
>> diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
>> index 9cdbc018fd64..37f06456bf30 100644
>> --- a/io_uring/kbuf.c
>> +++ b/io_uring/kbuf.c
>> @@ -50,6 +50,13 @@ void __io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
>>   	if (req->flags & REQ_F_BUFFER_RING) {
>>   		if (req->buf_list) {
>>   			if (req->flags & REQ_F_PARTIAL_IO) {
>> +				/*
>> +				 * if we reach here, uring_lock has been
>> +				?* holden. Because in iowq, we already
>> +				?* cleared req->buf_list to NULL when got
>> +				?* the buffer from the ring, which means
>> +				?* we cannot be here in that case.
>> +				 */
> 
> There's a weird character before the '*' in most lines? I'd rephrase the
> above as:
> 
> If we end up here, then the io_uring_lock has been kept held since we
> retrieved the buffer. For the io-wq case, we already cleared
> req->buf_list when the buffer was retrieved, hence it cannot be set
> here for that case.
> 
> And make sure it lines up around 80 chars, your lines look very short.

I'll do the change, as well as figuring out the weird char stuff.
Thanks.
> 
>> @@ -128,12 +135,13 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
>>   	if (issue_flags & IO_URING_F_UNLOCKED) {
>>   		/*
>>   		 * If we came in unlocked, we have no choice but to consume the
>> -		 * buffer here. This does mean it'll be pinned until the IO
>> -		 * completes. But coming in unlocked means we're in io-wq
>> -		 * context, hence there should be no further retry. For the
>> -		 * locked case, the caller must ensure to call the commit when
>> -		 * the transfer completes (or if we get -EAGAIN and must poll
>> -		 * or retry).
>> +		 * buffer here otherwise nothing ensures the buffer not being
>> +		 * used by others. This does mean it'll be pinned until the IO
>> +		 * completes though coming in unlocked means we're in io-wq
>> +		 * context and there may be further retries in async hybrid mode.
>> +		 * For the locked case, the caller must ensure to call the commit
>> +		 * when the transfer completes (or if we get -EAGAIN and must
>> +		 * poll or retry).
> 
> and similarly:
> 
> buffer here, otherwise nothing ensures that the buffer won't get used by
> others. This does mean it'll be pinned until the IO completes, coming in
> unlocked means we're being called from io-wq context and there may be
> further retries in async hybrid mode. For the locked case, the caller
> must call commit when the transfer completes (or if we get -EAGAIN and
> must poll of retry).
> 
Gotcha.

