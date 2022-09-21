Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3F5C5BFD0C
	for <lists+io-uring@lfdr.de>; Wed, 21 Sep 2022 13:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbiIULln (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Sep 2022 07:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiIULlm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Sep 2022 07:41:42 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D2768FD43
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 04:41:40 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id fn7-20020a05600c688700b003b4fb113b86so711846wmb.0
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 04:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=S+H6APSHqVM2AIPJDe8gYnUPynY2uNhoU7l1CNcqn04=;
        b=SKr2reDscL/0NAnBMVvUsn7J7zmZ4pC1Z04GKN4tFNt7C9qTkRg+1JSrrqns1EtaXO
         K6Et6B8HYBndhJ6DTcKXJl6hSc8Z59OR+KZSjgsgI7Ew6gnKTAIwmVMcEPFN8VL3beaJ
         8rCPq1IAeJ4FHYgNGokLaQ6azkBJkubWGUAOJiPk/7zIu/uptx7ESU07OYUsp4Y7gWmN
         VkVZJxCI80KuLEkkncJ1lNRTXWDETIqBJ/Sf4ZouPFFmMft+RVuJilQ+s2CZGkKepxtQ
         5f/pziR54nrBZ+B9mT2k1siMmKcw5L1Ry9fGQo5QI1REJDMXLOKZ6j8bBBK56eYEZvcV
         poOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=S+H6APSHqVM2AIPJDe8gYnUPynY2uNhoU7l1CNcqn04=;
        b=r+3qDirPXItIQdKED3keI6/LXLRA61g5gJ9f1aUU6k6oqcBfQtiVNjOXByJvneOQvQ
         DBQCEZ9HfuaoKQwY4PYMlPWX++8VvW6iKKy77yhaIcuIuesFy5+Pvd2AWmsoXNs3FvkR
         DxtMubD8QqHVetopJDVcDL1G2ISI7F9liBY/D1BWBjJkREBj8VDxl5815hdYi/GOYFNT
         Gd0WRZ8LleUQ9D3LsXA8hD0cbLh9YRzl4QIDCAVZylZGhx6Kh0Rlzr0O+G1hCrJ9wY5S
         8vT1yieYf0RdBhB+GdXpyeSrMIGPP1yZVTm2/rkXSl23y0hOehVlYHAoPMenGC/ZUOY7
         PPuA==
X-Gm-Message-State: ACrzQf2mJnv23G9Ws7DtkI8nAbrvHcelfysOf6Ywsnee0UydlGcNTF2T
        qhGb1j4kxa+AIfdzRqX2zbE=
X-Google-Smtp-Source: AMsMyM6zKIx2+0dybY+cTnyd8f3vn7/yvx1PMzUt39U/i3JLfhxzN9rWfuGA/lp6CgR5tmw1Ur39Vw==
X-Received: by 2002:a05:600c:4c22:b0:3b4:766a:4f76 with SMTP id d34-20020a05600c4c2200b003b4766a4f76mr5313614wmp.101.1663760498586;
        Wed, 21 Sep 2022 04:41:38 -0700 (PDT)
Received: from [192.168.8.198] (188.28.205.62.threembb.co.uk. [188.28.205.62])
        by smtp.gmail.com with ESMTPSA id r123-20020a1c2b81000000b003a62052053csm3120019wmr.18.2022.09.21.04.41.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Sep 2022 04:41:38 -0700 (PDT)
Message-ID: <8b456f19-f209-a83e-a346-ff8ea7f190ac@gmail.com>
Date:   Wed, 21 Sep 2022 12:39:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH for-6.0 0/5] IORING_OP_SEND_ZC improvements
Content-Language: en-US
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org,
        axboe@kernel.dk
References: <cover.1663363798.git.metze@samba.org>
 <734a8945-3668-5aa8-df8a-a858213e73ed@gmail.com>
 <a5e2e475-3e81-4375-897d-172c4711e3d1@samba.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <a5e2e475-3e81-4375-897d-172c4711e3d1@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/17/22 11:44, Stefan Metzmacher wrote:
> Am 17.09.22 um 11:16 schrieb Pavel Begunkov:
>> On 9/16/22 22:36, Stefan Metzmacher wrote:
>>> Hi Pavel, hi Jens,
>>>
>>> I did some initial testing with IORING_OP_SEND_ZC.
>>> While reading the code I think I found a race that
>>> can lead to IORING_CQE_F_MORE being missing even if
>>> the net layer got references.
>>
>> Hey Stefan,
>>
>> Did you see some kind of buggy behaviour in userspace?

Apologies for the delay,

> No I was just reading the code and found it a bit confusing,
> and couldn't prove that we don't have a problem with loosing
> a notif cqe.
> 
>> If network sends anything it should return how many bytes
>> it queued for sending, otherwise there would be duplicated
>> packets / data on the other endpoint in userspace, and I
>> don't think any driver / lower layer would keep memory
>> after returning an error.
> 
> As I'm also working on a socket driver for smbdirect,
> I already thought about how I could hook into
> IORING_OP_SEND[MSG]_ZC, and for sendmsg I'd have
> a loop sending individual fragments, which have a reference,
> but if I find a connection drop after the first one, I'd
> return ECONNRESET or EPIPE in order to get faster recovery
> instead of announcing a short write to the caller.

I doesn't sound right for me, but neither I know samba to
really have an opinion. In any case, I see how it may be
more robust if we always try to push a notification cqe.
Will you send a patch?

> If we would take my 5/5 we could also have a different
> strategy to check decide if MORE/NOTIF is needed.
> If notif->cqe.res is still 0 and io_notif_flush drops
> the last reference we could go without MORE/NOTIF at all.
> In all other cases we'd either set MORE/NOTIF at the end
> of io_sendzc of in the fail hook.

I had a similar optimisation, i.e. when io_notif_flush() in
the submission path is dropping the last ref, but killed it
as it was completely useless, I haven't hit this path even
once even with UDP, not to mention TCP.

>> In any case, I was looking on a bit different problem, but
>> it should look much cleaner using the same approach, see
>> branch [1], and patch [3] for sendzc in particular.
>>
>> [1] https://github.com/isilence/linux.git partial-fail
>> [2] https://github.com/isilence/linux/tree/io_uring/partial-fail
>> [3] https://github.com/isilence/linux/commit/acb4f9bf869e1c2542849e11d992a63d95f2b894
> 
>      const struct io_op_def *def = &io_op_defs[req->opcode];
> 
>      req_set_fail(req);
>      io_req_set_res(req, res, io_put_kbuf(req, IO_URING_F_UNLOCKED));
>      if (def->fail)
>          def->fail(req);
>      io_req_complete_post(req);
> 
> Will loose req->cqe.flags, but the fail hook in general looks like a good idea.

I just don't like those sporadic changes all across core io_uring
code also adding some overhead.

> And don't we care about the other failure cases where req->cqe.flags gets overwritten?

We don't usually carry them around ->issue handler boundaries,
e.g. directly do io_post_aux_cqe(res, IORING_CQE_F_MORE);

IORING_CQE_F_BUFFER is a bit more trickier, but there is
special handling for this one and it wouldn't fit "set cflags
in advance" logic anyway.

iow, ->fail callback sounds good enough for now, we'll change
it later if needed.

-- 
Pavel Begunkov
