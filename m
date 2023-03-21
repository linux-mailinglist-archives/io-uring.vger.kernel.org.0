Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 273BF6C27A4
	for <lists+io-uring@lfdr.de>; Tue, 21 Mar 2023 02:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbjCUB5D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Mar 2023 21:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbjCUB5D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Mar 2023 21:57:03 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A42E23A4D
        for <io-uring@vger.kernel.org>; Mon, 20 Mar 2023 18:57:01 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id h12-20020a17090aea8c00b0023d1311fab3so14413069pjz.1
        for <io-uring@vger.kernel.org>; Mon, 20 Mar 2023 18:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1679363821; x=1681955821;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QZozUQhsFzQw76svoHiedNHX6ZiNGSCtjOQ+J93SY10=;
        b=NVwfYYn/X7EDOvRxrWnpucM6Qibdyvgs3FBjm03kPZNihhrqqnFt/vwDZ6xynyXFpU
         pXdO3grnrQ+ey6SD7/cHQadZC3z+SkE+R0xwufaMyFv26vUIhq7FSLqFURn5a7lOKSqU
         ozteEi7+ipZXnGYSPjSeYjt/UoBAtzvOd6W3bI+kLduJ8MQ236+6WrIibtpFtvRFSBvY
         Oz4lWSqNjHuEwcZV+T2lrCB6l6q7RqxHN/jUKEhCc9swPv6PcyWwx22vg1q5TCsf1T6r
         uzAwSl1JTgNyXi2fbZ197rpRz/G/kmTfq0YS8uRKPqXOdpfGM47ur9SsPNi2TEFy55dh
         X0bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679363821; x=1681955821;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QZozUQhsFzQw76svoHiedNHX6ZiNGSCtjOQ+J93SY10=;
        b=ZSK36PwXs/kVAdtsupJSl8qV/mqbU8eKV/w+QItz8hu7mjiVgjQ8aSGjoBZDPikdp9
         28UTnt6vIvQCEjVqstB2VsCQSOhZk2RPnCl+6HTBGENDyyMt2gTg4n6Ssje1i1qULq+7
         U54sTdb2wpMS5DHgO7NJPUT+egaScYS7R2y2JDIZMKZB38FqxTIqtVNCWt6wTKHf2zUm
         NGPGKgB4H1DoT8XaW1Knjc/hYGB7BN4LxU0DWhskfB11EEibacwI0Zsq9IdPRWozuvvo
         CbWXnvZkCttqIHdEmAsYo/Ui8aLBiilKTfd+bIN/jhX1c5Q0TDaGzx/9wHGT/hzri2QP
         6Y5Q==
X-Gm-Message-State: AO0yUKWRqaQFVHZwZ5b3KOf4ydW1VlkU+EytweiCNTrsXA0sI5Pe24ul
        gQsToi7miAVxG5T9dpMCfE+YoHXXn6uQ+oxxtuGp5A==
X-Google-Smtp-Source: AK7set+mo0XPxBkeHZHg1kKw38Ehzc6udt5EqcnesRnaec96nt8YotJ1B/lEV/7KAcrUXStYJxC7mA==
X-Received: by 2002:a17:902:7b86:b0:1a1:cbc1:a960 with SMTP id w6-20020a1709027b8600b001a1cbc1a960mr569546pll.2.1679363820725;
        Mon, 20 Mar 2023 18:57:00 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q20-20020a170902b11400b0019251e959b1sm7341056plr.262.2023.03.20.18.56.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 18:57:00 -0700 (PDT)
Message-ID: <7703b1ee-3c7f-d3a6-fa09-6ddcd3be5885@kernel.dk>
Date:   Mon, 20 Mar 2023 19:56:59 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] io_uring/uring_cmd: push IRQ based completions through
 task_work
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Kanchan Joshi <joshiiitr@gmail.com>,
        io-uring <io-uring@vger.kernel.org>,
        Kanchan Joshi <joshi.k@samsung.com>
References: <4b4e3526-e6b5-73dd-c6fb-f7ddccf19f33@kernel.dk>
 <CA+1E3rKBNhmT63GMNpe-c+EVDpzvs4voTkL-efkdbJHdNZhZ7w@mail.gmail.com>
 <ZBjtuebXxIPpXoIG@ovpn-8-29.pek2.redhat.com>
 <149cd773-f302-faec-d77d-9db41be6744c@kernel.dk>
 <ZBkOWo1kE56q1QJ6@ovpn-8-18.pek2.redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZBkOWo1kE56q1QJ6@ovpn-8-18.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/20/23 7:54?PM, Ming Lei wrote:
> On Mon, Mar 20, 2023 at 07:39:30PM -0600, Jens Axboe wrote:
>> On 3/20/23 5:35?PM, Ming Lei wrote:
>>> On Mon, Mar 20, 2023 at 08:36:15PM +0530, Kanchan Joshi wrote:
>>>> On Sun, Mar 19, 2023 at 8:51?PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>
>>>>> This is similar to what we do on the non-passthrough read/write side,
>>>>> and helps take advantage of the completion batching we can do when we
>>>>> post CQEs via task_work. On top of that, this avoids a uring_lock
>>>>> grab/drop for every completion.
>>>>>
>>>>> In the normal peak IRQ based testing, this increases performance in
>>>>> my testing from ~75M to ~77M IOPS, or an increase of 2-3%.
>>>>>
>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>
>>>>> ---
>>>>>
>>>>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>>>>> index 2e4c483075d3..b4fba5f0ab0d 100644
>>>>> --- a/io_uring/uring_cmd.c
>>>>> +++ b/io_uring/uring_cmd.c
>>>>> @@ -45,18 +45,21 @@ static inline void io_req_set_cqe32_extra(struct io_kiocb *req,
>>>>>  void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2)
>>>>>  {
>>>>>         struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
>>>>> +       struct io_ring_ctx *ctx = req->ctx;
>>>>>
>>>>>         if (ret < 0)
>>>>>                 req_set_fail(req);
>>>>>
>>>>>         io_req_set_res(req, ret, 0);
>>>>> -       if (req->ctx->flags & IORING_SETUP_CQE32)
>>>>> +       if (ctx->flags & IORING_SETUP_CQE32)
>>>>>                 io_req_set_cqe32_extra(req, res2, 0);
>>>>> -       if (req->ctx->flags & IORING_SETUP_IOPOLL)
>>>>> +       if (ctx->flags & IORING_SETUP_IOPOLL) {
>>>>>                 /* order with io_iopoll_req_issued() checking ->iopoll_complete */
>>>>>                 smp_store_release(&req->iopoll_completed, 1);
>>>>> -       else
>>>>> -               io_req_complete_post(req, 0);
>>>>> +               return;
>>>>> +       }
>>>>> +       req->io_task_work.func = io_req_task_complete;
>>>>> +       io_req_task_work_add(req);
>>>>>  }
>>>>
>>>> Since io_uring_cmd_done itself would be executing in task-work often
>>>> (always in case of nvme), can this be further optimized by doing
>>>> directly what this new task-work (that is being set up here) would
>>>> have done?
>>>> Something like below on top of your patch -
>>>
>>> But we have io_uring_cmd_complete_in_task() already, just wondering why
>>> not let driver decide if explicit running in task-work is taken?
>>
>> Because it's currently broken, see my patch from earlier today.
> 
> OK, got it, just miss your revised patch.
> 
> Then I guess your patch needs to split into one bug fix(for backporting) on
> io_uring_cmd_done() and one optimization?

Yep, I think the backport fix patch actually takes care of most of it.
So it'll just be a tweak on top, if anything. I'll send it out shortly
so we can get it into 6.3.

-- 
Jens Axboe

