Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8580A6E2676
	for <lists+io-uring@lfdr.de>; Fri, 14 Apr 2023 17:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbjDNPIk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Apr 2023 11:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbjDNPIj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Apr 2023 11:08:39 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052739EF7
        for <io-uring@vger.kernel.org>; Fri, 14 Apr 2023 08:08:36 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id dx24so2293549ejb.11
        for <io-uring@vger.kernel.org>; Fri, 14 Apr 2023 08:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681484914; x=1684076914;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WCgh2O+B+9xTWY4B0XY0XI2R1sdvl0r43wAc4/gWIRA=;
        b=HifsedI0epnXvkQj5v1V176j1wM8VtkEC3VIBpP6hxUIQC5hwzm30ZH4sjBPLTYqLT
         OqzGeO67Pox1FGzdhP+4bAFdreMLHefDv1InpshF57igu8t1NRJWxi6VjiuxdzWPud5C
         HPEFa2ZE3YkSJetoYBJS2w+WVW2yd5GOWL+6ybnuPAMnRSJ38ZdTQW84VW7Xv9b5sXBb
         EBe8nNCWW0okzR9V1fBqa0ugrCy6q2bOpONOEmeft/U6rZ4OFx/JCbWBaYpik3jv2cUf
         dXYIBd5QJUw8GSgVRuJMyJ3eQd4okY+N8HL4bF/lYmCSo1N8cq+dMwb+kGqQzgCeILt6
         Y7Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681484914; x=1684076914;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WCgh2O+B+9xTWY4B0XY0XI2R1sdvl0r43wAc4/gWIRA=;
        b=i4xvD6A7UNpRELySZH5SR8py9uGN5dd3+COj5koceuKZ9y/aJJ9jkxIxvDA1jtBiS4
         NhobPzQO54qG1KENid5fP2H/mXr1woalVPhnhV7uYZVkXN7TRtAV6tp5U/mVWDxAwSbe
         fka3wNjyqwNH1YMEkW9oWxidg/lwnRIqoFJXanU9Gvc35ChjiUlIxKExIzJFjIzOjPFi
         pv/edO4u86Ni8GINfw+R6wq14kdZWLJaoMkoQ1T6cYK7o9x8+JB2FPz6fRs/4MEzhQLT
         Zgi7djOqpT++4vBJzLGsc7rHLiHxDkNT81YTvlDQKpLw53Y5SOpAJGjcnMwQj7pDrffu
         oESA==
X-Gm-Message-State: AAQBX9cGhhAEAVUHfk8ldwNLRNFDYtGNB8L+2BpKD4pm/oQV0papKA6X
        zujDFJ53mSTP665EvARrY3oEgOc7F/c=
X-Google-Smtp-Source: AKy350ZGieSRCn6BzchPO6lTwobHzsZM8smUp0LyJATN1LBTqoYF/Gmx6H6iVDN01VWiqsDV8FLg2w==
X-Received: by 2002:a17:906:7c46:b0:94d:20d2:47ce with SMTP id g6-20020a1709067c4600b0094d20d247cemr6328213ejp.14.1681484914142;
        Fri, 14 Apr 2023 08:08:34 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::26ef? ([2620:10d:c092:600::2:b2ce])
        by smtp.gmail.com with ESMTPSA id p24-20020a170906615800b00923f05b2931sm2554526ejl.118.2023.04.14.08.08.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Apr 2023 08:08:33 -0700 (PDT)
Message-ID: <9d5d57ec-c76a-754b-1f33-7557b2443d5c@gmail.com>
Date:   Fri, 14 Apr 2023 16:07:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH] io_uring: complete request via task work in case of
 DEFER_TASKRUN
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Kanchan Joshi <joshi.k@samsung.com>
References: <20230414075313.373263-1-ming.lei@redhat.com>
 <68ddddc0-fb0e-47b4-9318-9dd549d851a1@gmail.com>
 <ZDlay1++tidiKv+n@ovpn-8-21.pek2.redhat.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZDlay1++tidiKv+n@ovpn-8-21.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/14/23 14:53, Ming Lei wrote:
> On Fri, Apr 14, 2023 at 02:01:26PM +0100, Pavel Begunkov wrote:
>> On 4/14/23 08:53, Ming Lei wrote:
>>> So far io_req_complete_post() only covers DEFER_TASKRUN by completing
>>> request via task work when the request is completed from IOWQ.
>>>
>>> However, uring command could be completed from any context, and if io
>>> uring is setup with DEFER_TASKRUN, the command is required to be
>>> completed from current context, otherwise wait on IORING_ENTER_GETEVENTS
>>> can't be wakeup, and may hang forever.
>>
>> fwiw, there is one legit exception, when the task is half dead
>> task_work will be executed by a kthread. It should be fine as it
>> locks the ctx down, but I can't help but wonder whether it's only
>> ublk_cancel_queue() affected or there are more places in ublk?
> 
> No, it isn't.
> 
> It isn't triggered on nvme-pt just because command is always done
> in task context.
> 
> And we know more uring command cases are coming.

Because all requests and cmds but ublk complete it from another
task, ublk is special in this regard.

I have several more not so related questions:

1) Can requests be submitted by some other task than ->ubq_daemon?
Looking at

static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
{
     ...
     if (ubq->ubq_daemon && ubq->ubq_daemon != current)
        goto out;
}

ublk_queue_cmd() avoiding io_uring way of delivery and using
raw task_work doesn't seem great. Especially with TWA_SIGNAL_NO_IPI.

2) What the purpose of the two lines below? I see how
UBLK_F_URING_CMD_COMP_IN_TASK is used, but don't understand
why it changes depending on whether it's a module or not.

3) The long comment in ublk_queue_cmd() seems quite scary.
If you have a cmd / io_uring request it hold a ctx reference
and is always allowed to use io_uring's task_work infra like
io_uring_cmd_complete_in_task(). Why it's different for ublk?

>>
>> One more thing, cmds should not be setting issue_flags but only
>> forwarding what the core io_uring code passed, it'll get tons of
>> bugs in no time otherwise.
> 
> Here io_uring_cmd_done() is changed to this way recently, and it
> could be another topic.

And it's abused, but as you said, not particularly related
to this patch.


>> static void ublk_cancel_queue(struct ublk_queue *ubq)
>> {
>>      ...
>>      io_uring_cmd_done(io->cmd, UBLK_IO_RES_ABORT, 0,
>>                        IO_URING_F_UNLOCKED);
>> }
>>
>> Can we replace it with task_work? It should be cold, and I
>> assume ublk_cancel_queue() doesn't assume that all requests will
>> put down by the end of the function as io_uring_cmd_done()
>> can offload it in any case.
> 
> But it isn't specific for ublk, any caller of io_uring_cmd_done()
> has such issue since io_uring_cmd_done() is one generic API.

Well, fair enough, considering that IO_URING_F_UNLOCKED was
just added (*still naively hoping it'll be clean up*)

-- 
Pavel Begunkov
