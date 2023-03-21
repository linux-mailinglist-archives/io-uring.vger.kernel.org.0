Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 027556C2784
	for <lists+io-uring@lfdr.de>; Tue, 21 Mar 2023 02:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjCUBje (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Mar 2023 21:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbjCUBjd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Mar 2023 21:39:33 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62DD1AD2C
        for <io-uring@vger.kernel.org>; Mon, 20 Mar 2023 18:39:32 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id gp15-20020a17090adf0f00b0023d1bbd9f9eso18587812pjb.0
        for <io-uring@vger.kernel.org>; Mon, 20 Mar 2023 18:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1679362771; x=1681954771;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VxrUENfG5viRiHVdgbuLiALShODhPLW7s2AptTS4/u0=;
        b=WdzBvhinbhc3VSd2GHh8rJAmeqDx+uqG499GXDhRK3MG+7mviTo4bxGnrdvizmZI/E
         qh/Bklm3bvDX53u4rypGhaZwnivb24g+3Gd3FpSBduaLZY+SdKs4WCFAononf6JigYiN
         K3q43SbolA1JDIES4tMQMl8xjTJqsCCI5K9GoT/FMPh/cFQzbWepEq1g2FxIEX1PmEOj
         Qg6Ro1vIretzVR4yAE/bwyy5j0kM/DeifjDUxyTZlYDPeLhx+/APXLDE/zgHoDEh9Dvq
         lHVdz88IwyzqG6hsDlLHPV6SL0hiC6mo2sDVKfa3vwcpf5LTCzshir7jcsT/tGO+YGOe
         YBOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679362772; x=1681954772;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VxrUENfG5viRiHVdgbuLiALShODhPLW7s2AptTS4/u0=;
        b=Yrr7NmWAeUWwSL67HHKu9fXMiZOjvhNm8llM7k07UBDdApJ6juRMXoSA2vabFZaBE1
         WxJyA61VlLOJtBaWbxNsD5fiU2tjbYfqCsJz9LriMXMH/MvEzDsorOew4thDbITnwaLy
         QIXLgUo8h8Vj9qknyP4LnaRcb8J+ZGrwo57HUWLE4QAskzn/CUyUuL0OtlLQqKm6r/WN
         T8yqvVvPYsJhBuOVU+e2hnmG5Shs0MMHo72WPEoCnFd/cIU1JNxGN7mcw0u63w1f1fcJ
         rZWBLkffUTQ+NYkemevg5ojzGCmiKBjKQCPz3w8arAFy3nMCAPdvs/lvt3uuSlObtM4v
         wvIQ==
X-Gm-Message-State: AO0yUKUm/zyl/NCLXrVg5MqD0uH2oFBaJQfUWSGhXVkihIRurTrgOjtM
        P+ykWnaFdmk2arpEwb/52L88lphYH50ZzUyYGgP3kg==
X-Google-Smtp-Source: AK7set9144R2qvJLqpCdlhzfI4USnvvRqna7pswhDosN1+RzLjuox2FOtMSMKF3RhQxK21oYCgGIMA==
X-Received: by 2002:a17:902:7b86:b0:1a1:cbc1:a960 with SMTP id w6-20020a1709027b8600b001a1cbc1a960mr522708pll.2.1679362771559;
        Mon, 20 Mar 2023 18:39:31 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 21-20020a170902ee5500b0019aafc422fcsm7314616plo.240.2023.03.20.18.39.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 18:39:31 -0700 (PDT)
Message-ID: <149cd773-f302-faec-d77d-9db41be6744c@kernel.dk>
Date:   Mon, 20 Mar 2023 19:39:30 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] io_uring/uring_cmd: push IRQ based completions through
 task_work
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>, Kanchan Joshi <joshiiitr@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Kanchan Joshi <joshi.k@samsung.com>
References: <4b4e3526-e6b5-73dd-c6fb-f7ddccf19f33@kernel.dk>
 <CA+1E3rKBNhmT63GMNpe-c+EVDpzvs4voTkL-efkdbJHdNZhZ7w@mail.gmail.com>
 <ZBjtuebXxIPpXoIG@ovpn-8-29.pek2.redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZBjtuebXxIPpXoIG@ovpn-8-29.pek2.redhat.com>
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

On 3/20/23 5:35?PM, Ming Lei wrote:
> On Mon, Mar 20, 2023 at 08:36:15PM +0530, Kanchan Joshi wrote:
>> On Sun, Mar 19, 2023 at 8:51?PM Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> This is similar to what we do on the non-passthrough read/write side,
>>> and helps take advantage of the completion batching we can do when we
>>> post CQEs via task_work. On top of that, this avoids a uring_lock
>>> grab/drop for every completion.
>>>
>>> In the normal peak IRQ based testing, this increases performance in
>>> my testing from ~75M to ~77M IOPS, or an increase of 2-3%.
>>>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>
>>> ---
>>>
>>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>>> index 2e4c483075d3..b4fba5f0ab0d 100644
>>> --- a/io_uring/uring_cmd.c
>>> +++ b/io_uring/uring_cmd.c
>>> @@ -45,18 +45,21 @@ static inline void io_req_set_cqe32_extra(struct io_kiocb *req,
>>>  void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2)
>>>  {
>>>         struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
>>> +       struct io_ring_ctx *ctx = req->ctx;
>>>
>>>         if (ret < 0)
>>>                 req_set_fail(req);
>>>
>>>         io_req_set_res(req, ret, 0);
>>> -       if (req->ctx->flags & IORING_SETUP_CQE32)
>>> +       if (ctx->flags & IORING_SETUP_CQE32)
>>>                 io_req_set_cqe32_extra(req, res2, 0);
>>> -       if (req->ctx->flags & IORING_SETUP_IOPOLL)
>>> +       if (ctx->flags & IORING_SETUP_IOPOLL) {
>>>                 /* order with io_iopoll_req_issued() checking ->iopoll_complete */
>>>                 smp_store_release(&req->iopoll_completed, 1);
>>> -       else
>>> -               io_req_complete_post(req, 0);
>>> +               return;
>>> +       }
>>> +       req->io_task_work.func = io_req_task_complete;
>>> +       io_req_task_work_add(req);
>>>  }
>>
>> Since io_uring_cmd_done itself would be executing in task-work often
>> (always in case of nvme), can this be further optimized by doing
>> directly what this new task-work (that is being set up here) would
>> have done?
>> Something like below on top of your patch -
> 
> But we have io_uring_cmd_complete_in_task() already, just wondering why
> not let driver decide if explicit running in task-work is taken?

Because it's currently broken, see my patch from earlier today.

-- 
Jens Axboe

