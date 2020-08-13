Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85F75243D01
	for <lists+io-uring@lfdr.de>; Thu, 13 Aug 2020 18:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbgHMQJZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Aug 2020 12:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726249AbgHMQJY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Aug 2020 12:09:24 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A20C061757
        for <io-uring@vger.kernel.org>; Thu, 13 Aug 2020 09:09:24 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id z3so6009966ilh.3
        for <io-uring@vger.kernel.org>; Thu, 13 Aug 2020 09:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NdS9w7PkEEsdQFKsh6kciz0K10Kas7ggz9J7x3UjBY0=;
        b=OEDsnwUvH38ukKP7VZE/BiuidLSK0QXGRQyy1oPp8jqKytsXgoUnvTGGucNlyN/wyu
         Z8BCgzYh0uaZ83qslFJAy1hfQ5sAFNOgPHAAt9uHOFHluKyi5yP1qK0MO2t9kDFhZKYc
         osdbiVZXgCKcBIlO4qqFAgYrgePkeqI1Zyylzja3NQDwqUF3R3n+oGDVlDcsQHvU0Dee
         50hLgSL0ETtU6oYzWRccUrb5lbLHpJiNs8ofmHHAVeORotht8/Fz1oEcwT2lH913RbMa
         FCrgNtFt092uAq2B+GEdoNg2N3qN0aH6jFy6UyzCJ0Tu+S9nq24tSiQOn9qLsS8h3R/O
         Dt0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NdS9w7PkEEsdQFKsh6kciz0K10Kas7ggz9J7x3UjBY0=;
        b=EKZ4ItEObR+MWgzyKAW7dDNBz8v2bJ0Fhrz0sQJB7RCOeUJYvlvyHEx7pu3QWdVXGv
         x53k2vKclYwEXUQO+FA70cLFgAtT7/ZfBDeEZgoOrNGndePskeEIPOFCZ5Pyrso35lPE
         QpUEYzaY5ZYagD47j9vzZIAyF/bQWnfgNIAZSnhavwW8RgNLS1QbfoUkPP4nuPC7Qhgc
         ePz2yOB0MqLUKMOUWPSZfgAL4gefsIOyefJiPy7Hvq7UltGCRrsnetdTH2N3y3cvj7US
         biqFkr/elEGgPe2p1chvD9yp2qC+KS2ySRDlatS/CcT7nqH1cOz7wUHqYjKfYxJXXCb3
         dlPQ==
X-Gm-Message-State: AOAM532nxvKGtODIDmzqu19YFLT2NjgU0iqS/FH68zl4jZX+z4S9xamQ
        vWrgS11Nkv1Y99O8a35hg9mLOA==
X-Google-Smtp-Source: ABdhPJypqy/CmAC9tsWeeXM2e6PDVaah9SbFdEXU8uI0dDdFTJj1zvVZdFN35gnUq6EhKPZ3kmjALg==
X-Received: by 2002:a92:6d0c:: with SMTP id i12mr4836294ilc.37.1597334963883;
        Thu, 13 Aug 2020 09:09:23 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id s6sm2944692ilq.73.2020.08.13.09.09.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Aug 2020 09:09:23 -0700 (PDT)
Subject: Re: io_uring process termination/killing is not working
To:     Josef <josef.grieb@gmail.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        norman@apache.org
References: <CAAss7+pf+CGQiSDM8_fhsHRwjWUxESPcJMhOOsDOitqePQxCrg@mail.gmail.com>
 <dc3562d8-dc67-c623-36ee-38885b4c1682@kernel.dk>
 <8e734ada-7f28-22df-5f30-027aca3695d1@gmail.com>
 <5fa9e01f-137d-b0f8-211a-975c7ed56419@gmail.com>
 <d0d1f797-c958-ac17-1f11-96f6ba6dbf37@gmail.com>
 <d0621b79-4277-a9ad-208e-b60153c08d15@kernel.dk>
 <CAAss7+rk5jH5Peov-Scffp3cmRpk3=0suBZvw1RFTEc7a6Rstw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e0387a97-0b3c-fd41-8060-3f118221bba6@kernel.dk>
Date:   Thu, 13 Aug 2020 10:09:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAAss7+rk5jH5Peov-Scffp3cmRpk3=0suBZvw1RFTEc7a6Rstw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/13/20 10:07 AM, Josef wrote:
> On Thu, 13 Aug 2020 at 01:32, Jens Axboe <axboe@kernel.dk> wrote:
>> Yeah I think you're right. How about something like the below? That'll
>> potentially cancel more than just the one we're looking for, but seems
>> kind of silly to only cancel from the file table holding request and to
>> the end.
>>
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 8a2afd8c33c9..0630a9622baa 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -4937,6 +5003,7 @@ static bool io_poll_remove_one(struct io_kiocb *req)
>>                 io_cqring_fill_event(req, -ECANCELED);
>>                 io_commit_cqring(req->ctx);
>>                 req->flags |= REQ_F_COMP_LOCKED;
>> +               req_set_fail_links(req);
>>                 io_put_req(req);
>>         }
>>
>> @@ -7935,6 +8002,47 @@ static bool io_wq_files_match(struct io_wq_work *work, void *data)
>>         return work->files == files;
>>  }
>>
>> +static bool __io_poll_remove_link(struct io_kiocb *preq, struct io_kiocb *req)
>> +{
>> +       struct io_kiocb *link;
>> +
>> +       if (!(preq->flags & REQ_F_LINK_HEAD))
>> +               return false;
>> +
>> +       list_for_each_entry(link, &preq->link_list, link_list) {
>> +               if (link != req)
>> +                       break;
>> +               io_poll_remove_one(preq);
>> +               return true;
>> +       }
>> +
>> +       return false;
>> +}
>> +
>> +/*
>> + * We're looking to cancel 'req' because it's holding on to our files, but
>> + * 'req' could be a link to another request. See if it is, and cancel that
>> + * parent request if so.
>> + */
>> +static void io_poll_remove_link(struct io_ring_ctx *ctx, struct io_kiocb *req)
>> +{
>> +       struct hlist_node *tmp;
>> +       struct io_kiocb *preq;
>> +       int i;
>> +
>> +       spin_lock_irq(&ctx->completion_lock);
>> +       for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
>> +               struct hlist_head *list;
>> +
>> +               list = &ctx->cancel_hash[i];
>> +               hlist_for_each_entry_safe(preq, tmp, list, hash_node) {
>> +                       if (__io_poll_remove_link(preq, req))
>> +                               break;
>> +               }
>> +       }
>> +       spin_unlock_irq(&ctx->completion_lock);
>> +}
>> +
>>  static void io_uring_cancel_files(struct io_ring_ctx *ctx,
>>                                   struct files_struct *files)
>>  {
>> @@ -7989,6 +8097,8 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
>>                         }
>>                 } else {
>>                         io_wq_cancel_work(ctx->io_wq, &cancel_req->work);
>> +                       /* could be a link, check and remove if it is */
>> +                       io_poll_remove_link(ctx, cancel_req);
>>                         io_put_req(cancel_req);
>>                 }
>>
>>
> 
> btw it works for me thanks

Thanks for testing, I've committed an updated version that also ensures
we find timeout based links:

https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.9&id=f254ac04c8744cf7bfed012717eac34eacc65dfb

-- 
Jens Axboe

