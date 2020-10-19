Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A413C292144
	for <lists+io-uring@lfdr.de>; Mon, 19 Oct 2020 04:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730551AbgJSCxP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 18 Oct 2020 22:53:15 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:45761 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730243AbgJSCxP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 18 Oct 2020 22:53:15 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R731e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UCPkx-h_1603075993;
Received: from 30.225.32.202(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UCPkx-h_1603075993)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 19 Oct 2020 10:53:13 +0800
Subject: Re: Question about patch "io_uring: add submission polling"
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Stefano Garzarella <sgarzare@redhat.com>
References: <635218e1-da08-4ab5-7a95-fb74de46c741@linux.alibaba.com>
 <0b7d845c-0566-2786-2f74-22e6a31016bd@kernel.dk>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <08f6e177-cc01-b412-0a45-7cf5ccb0de18@linux.alibaba.com>
Date:   Mon, 19 Oct 2020 10:52:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <0b7d845c-0566-2786-2f74-22e6a31016bd@kernel.dk>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> On 10/16/20 2:55 AM, Xiaoguang Wang wrote:
>> hi£¬
>>
>> I have questions about below code comments, which was included in patch
>> "io_uring: add submission polling",
>> ------------------------------------------------------------
>>       /*
>>        * Drop cur_mm before scheduling, we can't hold it for
>>        * long periods (or over schedule()). Do this before
>>        * adding ourselves to the waitqueue, as the unuse/drop
>>        * may sleep.
>>        */
>>       if (cur_mm) {
>>               unuse_mm(cur_mm);
>>               mmput(cur_mm);
>>               cur_mm = NULL;
>>       }
>>
>>       prepare_to_wait(&ctx->sqo_wait, &wait, TASK_INTERRUPTIBLE);
>> -------------------------------------------------------------
>> Stefano submited a patch "io_uring: prevent sq_thread from spinning when it should stop",
>> I understand what issue Stefano fixed, but don't understand below comments.
>>
>> Can anyone help to explain why we need to rop cur_mm before scheduling, or
>> why we can't hold it for long periods (or over schedule()), and if we
>> unuse/drop mm after adding ourselves to the waitqueue, what issue will
>> happen when unuse/drop sleeps, thanks.
> 
> The not holding it too long it just trying to be nice. But we can't drop
> it after we've done prepare_to_wait(), as that sets our task runstate to
> a non-running state. This conflicts with with mmput(), which might
> sleep.
I see, thanks.
Now I'm trying to improve io_sq_thread a bit and will send patches soon.

Regards,
Xiaoguang Wang
> 
