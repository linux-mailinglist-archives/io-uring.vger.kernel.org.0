Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21F284BF29E
	for <lists+io-uring@lfdr.de>; Tue, 22 Feb 2022 08:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbiBVHVO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Feb 2022 02:21:14 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:43742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbiBVHVM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Feb 2022 02:21:12 -0500
Received: from out30-45.freemail.mail.aliyun.com (out30-45.freemail.mail.aliyun.com [115.124.30.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6003EDEA07;
        Mon, 21 Feb 2022 23:20:47 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R281e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V5CE4Mj_1645514444;
Received: from 30.226.12.35(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V5CE4Mj_1645514444)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 22 Feb 2022 15:20:45 +0800
Message-ID: <54b21f27-2c0d-1b3d-b35f-a88bdb766c54@linux.alibaba.com>
Date:   Tue, 22 Feb 2022 15:20:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 4/4] io_uring: pre-increment f_pos on rw
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Dylan Yudaken <dylany@fb.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, kernel-team@fb.com
References: <20220221141649.624233-1-dylany@fb.com>
 <20220221141649.624233-5-dylany@fb.com>
 <ec1647f3-2c37-04be-bdbd-ab78b9f07a03@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
In-Reply-To: <ec1647f3-2c37-04be-bdbd-ab78b9f07a03@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 2/22/22 02:00, Pavel Begunkov wrote:
> On 2/21/22 14:16, Dylan Yudaken wrote:
>> In read/write ops, preincrement f_pos when no offset is specified, and
>> then attempt fix up the position after IO completes if it completed less
>> than expected. This fixes the problem where multiple queued up IO 
>> will all
>> obtain the same f_pos, and so perform the same read/write.
>>
>> This is still not as consistent as sync r/w, as it is able to advance 
>> the
>> file offset past the end of the file. It seems it would be quite a
>> performance hit to work around this limitation - such as by keeping 
>> track
>> of concurrent operations - and the downside does not seem to be too
>> problematic.
>>
>> The attempt to fix up the f_pos after will at least mean that in 
>> situations
>> where a single operation is run, then the position will be consistent.
>>
>> Co-developed-by: Jens Axboe <axboe@kernel.dk>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> Signed-off-by: Dylan Yudaken <dylany@fb.com>
>> ---
>>   fs/io_uring.c | 81 ++++++++++++++++++++++++++++++++++++++++++---------
>>   1 file changed, 68 insertions(+), 13 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index abd8c739988e..a951d0754899 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -3066,21 +3066,71 @@ static inline void io_rw_done(struct kiocb 
>> *kiocb, ssize_t ret)
>
> [...]
>
>> +            return false;
>>           }
>>       }
>> -    return is_stream ? NULL : &kiocb->ki_pos;
>> +    *ppos = is_stream ? NULL : &kiocb->ki_pos;
>> +    return false;
>> +}
>> +
>> +static inline void
>> +io_kiocb_done_pos(struct io_kiocb *req, struct kiocb *kiocb, u64 
>> actual)
>
> That's a lot of inlining, I wouldn't be surprised if the compiler
> will even refuse to do that.
>
> io_kiocb_done_pos() {
>     // rest of it
> }
>
> inline io_kiocb_done_pos() {
>     if (!(flags & CUR_POS));
>         return;
>     __io_kiocb_done_pos();
> }
>
> io_kiocb_update_pos() is huge as well
>
>> +{
>> +    u64 expected;
>> +
>> +    if (likely(!(req->flags & REQ_F_CUR_POS)))
>> +        return;
>> +
>> +    expected = req->rw.len;
>> +    if (actual >= expected)
>> +        return;
>> +
>> +    /*
>> +     * It's not definitely safe to lock here, and the assumption is,
>> +     * that if we cannot lock the position that it will be changing,
>> +     * and if it will be changing - then we can't update it anyway
>> +     */
>> +    if (req->file->f_mode & FMODE_ATOMIC_POS
>> +        && !mutex_trylock(&req->file->f_pos_lock))
>> +        return;
>> +
>> +    /*
>> +     * now we want to move the pointer, but only if everything is 
>> consistent
>> +     * with how we left it originally
>> +     */
>> +    if (req->file->f_pos == kiocb->ki_pos + (expected - actual))
>> +        req->file->f_pos = kiocb->ki_pos;
>
> I wonder, is it good enough / safe to just assign it considering that
> the request was executed outside of locks? vfs_seek()?
>
>> +
>> +    /* else something else messed with f_pos and we can't do 
>> anything */
>> +
>> +    if (req->file->f_mode & FMODE_ATOMIC_POS)
>> +        mutex_unlock(&req->file->f_pos_lock);
>>   }
>
> Do we even care about races while reading it? E.g.
> pos = READ_ONCE();
>
>>   -    ppos = io_kiocb_update_pos(req, kiocb);
>> -
>>       ret = rw_verify_area(READ, req->file, ppos, req->result);
>>       if (unlikely(ret)) {
>>           kfree(iovec);
>> +        io_kiocb_done_pos(req, kiocb, 0);
>
> Why do we update it on failure?
It seems like a fallback, if no pos change, fallback file->f_pos to the 
original place
>
> [...]
>
>> -    ppos = io_kiocb_update_pos(req, kiocb);
>> -
>>       ret = rw_verify_area(WRITE, req->file, ppos, req->result);
>>       if (unlikely(ret))
>>           goto out_free;
>> @@ -3858,6 +3912,7 @@ static int io_write(struct io_kiocb *req, 
>> unsigned int issue_flags)
>>           return ret ?: -EAGAIN;
>>       }
>>   out_free:
>> +    io_kiocb_done_pos(req, kiocb, 0);
>
> Looks weird. It appears we don't need it on failure and
> successes are covered by kiocb_done() / ->ki_complete
>
>>       /* it's reportedly faster than delegating the null check to 
>> kfree() */
>>       if (iovec)
>>           kfree(iovec);
>
