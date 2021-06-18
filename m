Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 381DF3ACF2A
	for <lists+io-uring@lfdr.de>; Fri, 18 Jun 2021 17:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233070AbhFRPft (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Jun 2021 11:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbhFRPfj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Jun 2021 11:35:39 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 364FBC06175F
        for <io-uring@vger.kernel.org>; Fri, 18 Jun 2021 08:33:30 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id t4-20020a1c77040000b029019d22d84ebdso8972441wmi.3
        for <io-uring@vger.kernel.org>; Fri, 18 Jun 2021 08:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=XyHjpdkfVh7G0zoKhUHHm5DkjpzbfaJNHAXUVAkl7hs=;
        b=R8RkpfqskdF7ENCdLdElKel0VV3URSjEgw3fQC5ZR5MinY8ghykFdrs9sfQzGNtyPF
         CS6pLtNf4m0VGcgo8I4dPVszPMqFWR9dTVfy+qaJYs81V9mqtiksKwsf6Tc/GEZWkH9c
         XM3oUSBwhk/fJ9zyKR/RQu+0klCmnW8TlL9FNg/zts0MEl/25nVDDQA8rL+HI7s98Bj3
         HOwvEr4xD7yuMruSzmpJMy6BbzOIjAwoQ7f2Pj6HpnibIwoISCeX2gcjbqB+j7WZjpQ9
         T/86dU8ja3Nhipd9HOm/zdIb5p3jfpyrtV8HmgH0HPzbffcbkrHY+hDJyzGqcjeHZk95
         uBnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XyHjpdkfVh7G0zoKhUHHm5DkjpzbfaJNHAXUVAkl7hs=;
        b=LDgTO6B7PAmxRNi85JiksKVwVGVyfuD/BA77pzrJb4GJorpzp+NFZ1jXHRVyRaZMex
         TG68kYpv29a93i0XE0NBf5PM5U71KS/XUKJ25ov7IPiHQ/M0kGNqt5PTjEY+suuU4nM4
         aLHInZ72oAi4v34cdNRdbftvwLxcsFgDvYXQtXdODq2Qbm81JoAeAOKDX2W3pzjWgSMJ
         L8cNGEkzbmqd+MNHP2IvrARxIm7pH50s9dpDwsDExcX4B4bVbWyCYNLbYFaxoIHUsEnW
         TiC49Qylmyq7ChZoBUyMsCnjkV1febvUOoQhJrM3FPPnPQMD/8MAkznHUchv+l62+gg0
         /fwg==
X-Gm-Message-State: AOAM532S/XCAex7f+q0cvpJbxvpiTuD7oz7go9Kg8ONsyu1M1UMsuaGU
        /s8xV3sXxu4DhlCbIKy0/bq+b7uStr2nlQ==
X-Google-Smtp-Source: ABdhPJwWBu9fcFooCnw/17z02BJ8aQvSJiaz9dR6p+hEQTjuKLmgTcWiP+RcZ5k5OTpyfX1BhSoFsQ==
X-Received: by 2002:a1c:4682:: with SMTP id t124mr8462218wma.161.1624030408620;
        Fri, 18 Jun 2021 08:33:28 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.93])
        by smtp.gmail.com with ESMTPSA id p11sm8960829wrx.85.2021.06.18.08.33.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jun 2021 08:33:28 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1623949695.git.asml.silence@gmail.com>
 <1ef72cdac7022adf0cd7ce4bfe3bb5c82a62eb93.1623949695.git.asml.silence@gmail.com>
 <c8a55ff7-6e90-c6df-1f68-3ed1a58da6c5@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 12/12] io_uring: improve in tctx_task_work() resubmission
Message-ID: <507b0fa2-da08-fc77-5a2f-414040740655@gmail.com>
Date:   Fri, 18 Jun 2021 16:33:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <c8a55ff7-6e90-c6df-1f68-3ed1a58da6c5@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/18/21 4:23 PM, Jens Axboe wrote:
> On 6/17/21 11:14 AM, Pavel Begunkov wrote:
>> If task_state is cleared, io_req_task_work_add() will go the slow path
>> adding a task_work, setting the task_state, waking up the task and so
>> on. Not to mention it's expensive. tctx_task_work() first clears the
>> state and then executes all the work items queued, so if any of them
>> resubmits or adds new task_work items, it would unnecessarily go through
>> the slow path of io_req_task_work_add().
>>
>> Let's clear the ->task_state at the end. We still have to check
>> ->task_list for emptiness afterward to synchronise with
>> io_req_task_work_add(), do that, and set the state back if we're going
>> to retry, because clearing not-ours task_state on the next iteration
>> would be buggy.
> 
> Are we not re-introducing the problem fixed by 1d5f360dd1a3c by swapping
> these around?

if (wq_list_empty(&tctx->task_list)) {
	clear_bit(0, &tctx->task_state);
	if (wq_list_empty(&tctx->task_list))
		break;
	... // goto repeat
}

Note  wq_list_empty() right after clear_bit(), it will
retry splicing the list as it currently does.

There is some more for restoring the bit back, but
should be fine as well. Alternatively, could have
been as below, but found it uglier:

bool cleared = false;
...
if (wq_list_empty(&tctx->task_list)) {
	if (cleared)
		break;
	cleared = true;
	clear_bit(0, &tctx->task_state);
	if (wq_list_empty(&tctx->task_list))
		break;
	goto repeat;
}

-- 
Pavel Begunkov
