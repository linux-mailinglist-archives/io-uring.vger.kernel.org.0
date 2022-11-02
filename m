Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9AA6164A2
	for <lists+io-uring@lfdr.de>; Wed,  2 Nov 2022 15:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbiKBOM2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Nov 2022 10:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231446AbiKBOMU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Nov 2022 10:12:20 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C18524F22
        for <io-uring@vger.kernel.org>; Wed,  2 Nov 2022 07:12:14 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id z9so9502410ilu.10
        for <io-uring@vger.kernel.org>; Wed, 02 Nov 2022 07:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DlnQsOClEBUJVN0/ohDEkHqZLSQwR8y0xAS4Ky1zPUU=;
        b=P9SKfU/25OdFNdxILCIqfY9BJKhyL9iRMbXG80pZMJp6axowJn/BXgcAGvlqFgixn8
         4X/DeOkksWmyE+OQwW8MvuHXaJaUY1vTsoDiWUemz37vwbd08KO/ZxvGdvIs0U+73pEl
         9eh8fEb6sxifvIdcC4t5JLIWjrsvKTk1pNdiYq2yaw/2KgpCEhgr12nzZqPPIK1AelE+
         qwFcuAyWx04hYkWEmUx5INGq7qfbThZKWdIo67ETAJqn0//dVlWFM5LFKoE04Lm1XSM9
         23CJGSfLh/pqnVzh987q38DnxOwiR3QVfrke51YHbYUCdOgc6GU3vJUoS1zqSHOU2D5m
         XmfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DlnQsOClEBUJVN0/ohDEkHqZLSQwR8y0xAS4Ky1zPUU=;
        b=Q1M+G7FXywTyBqDtzicLj53sYjBkixkoH/7/1KtEl7Vxpig449j/E+sY8e+9DHTuCD
         3QXCRDMqJzGDsTCKZ0BHS94Dlk8dwzcWrtSezgHnb06nO5wL/F1IyBnD5rwwJXAEmK2x
         RbYEdRrT/PtMwByRaly1NvvXHSm5IQKOmrqYG35aUMezvZEi7VSp3pnzEOSSog2xeOc0
         pRJ7e3V6dkNPuWACC1CYJh0IJ51T5zUuLqGZUx441bf+NekBW1LrwTg9IHCMyUykeez7
         kLr7Vf/gVFgaZO16vxJSFazvwmrLhM029oQo2PimErtnyX6C1oXku4YeehkOun2sBvdX
         Uj8A==
X-Gm-Message-State: ACrzQf2t6yMKBz03UjjD088qsaDcEm8Uq90APnMtJiDPRprIZMWuYDWt
        xmWlmckYn0J3s4hZusLMVs/DpNlD1mILfTQx
X-Google-Smtp-Source: AMsMyM7HYOfNzUC9EpkqQAjeW8htBZzuhgJBg/bRJ4ch48hZE8C9USv35a/DKvbLgYifFfMSs+2IOw==
X-Received: by 2002:a92:6a09:0:b0:2f9:939e:85a9 with SMTP id f9-20020a926a09000000b002f9939e85a9mr7356204ilc.111.1667398333496;
        Wed, 02 Nov 2022 07:12:13 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id l83-20020a6b3e56000000b006d2d993c75dsm2097558ioa.7.2022.11.02.07.12.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 07:12:12 -0700 (PDT)
Message-ID: <13f3c7b6-cf28-f323-2e5e-dd38da4d75dd@kernel.dk>
Date:   Wed, 2 Nov 2022 08:12:10 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH for-next 07/12] io_uring: split send_zc specific struct
 out of io_sr_msg
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Dylan Yudaken <dylany@meta.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com
References: <20221031134126.82928-1-dylany@meta.com>
 <20221031134126.82928-8-dylany@meta.com>
 <76be6e82-7aa4-b35e-5a8c-ee259af8ec41@gmail.com>
 <a3b03991-f599-375d-6eaa-704af9aa88c0@kernel.dk>
 <d2e90603-192b-402b-e5a0-9ce4668714cf@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <d2e90603-192b-402b-e5a0-9ce4668714cf@gmail.com>
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

On 11/2/22 8:09 AM, Pavel Begunkov wrote:
> On 11/2/22 13:45, Jens Axboe wrote:
>> On 11/2/22 5:32 AM, Pavel Begunkov wrote:
>>> On 10/31/22 13:41, Dylan Yudaken wrote:
>>>> Split out the specific sendzc parts of struct io_sr_msg as other opcodes
>>>> are going to be specialized.
>>>
>>> I'd suggest to put the fields into a union and not splitting the structs
>>> for now, it can be done later. The reason is that the file keeps changing
>>> relatively often, and this change will add conflicts complicating
>>> backporting and cross-tree development (i.e. series that rely on both
>>> net and io_uring trees).
>>
>> Not super important, but I greatly prefer having them split. That
>> way the ownership is much clearer than a union, which always
>> gets a bit iffy.
> 
> I'd agree in general, but I think it's easier to do in a few releases
> than now.

I'd rather just deal with that pain, in reality it'll be very minor. And
if lots of churn is expected there, it'll be the most trivial of rejects
for this particular area.

> And this one is nothing in levels of nastiness comparing to
> req->cqe.fd and some cases that we had before.

I agree, but that's not a reason to allow more of it, quite the
contrary.

-- 
Jens Axboe
