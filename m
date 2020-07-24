Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CACD322C784
	for <lists+io-uring@lfdr.de>; Fri, 24 Jul 2020 16:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgGXOMb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Jul 2020 10:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbgGXOMb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Jul 2020 10:12:31 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A1D1C0619D3
        for <io-uring@vger.kernel.org>; Fri, 24 Jul 2020 07:12:31 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id j19so5268972pgm.11
        for <io-uring@vger.kernel.org>; Fri, 24 Jul 2020 07:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=m9crPKesbqeAkyTDPl21XkEJqF6PZXZDZ6hfOgj3USg=;
        b=q6UFAf7qdQ6KbGgdbzSk5BPUFGPFhrhN9Mez4N3b41twvXw3zVTRoCKWlLr4ISwKCU
         JOHR4FNGTxhSf9119/1N5PattfRtFFFqksj9OwiKQZ9wDGdry2uzbkR/20agaZ2b8R2e
         ORX2IgMubBF9bNZ1DxPY44aJN9aNt2sLQu8IYYPTaLc8/8yQx1akiwUmz5TR9f8H5IyB
         NLx9zqeux9341oeISmc0roFfg17DAsNBcEFU8vJIENqCTUk5mATLIhe6joG5hSS9cNSs
         Ff6bYVCZK/yeVW0DXUu3t9pnM4TteYJU8ZIEfiYIE24BoCe9cWnMuocCE5OWT4Sah0VA
         YdJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m9crPKesbqeAkyTDPl21XkEJqF6PZXZDZ6hfOgj3USg=;
        b=QNjBpktr7Lppw7asGGqo1vL38SMErb642nWAWekTXL80EPNvf72O3IZ2lj2Vcq61AI
         3pa90RuvM+AS1zJED0qy7RwLejE+CmoRB+CbdgzmnYhtK9ousx/L/XV9145+FlAUz7LZ
         WvOx7yuy+I9CSLKzD1THtJK98/oBsffwiOZFTE/eGhGI1itbvcAMIo2ZRzw22+G1ogNd
         r9H8abKDUZPBZ6Ru6vwySgU799fwe6fyYj/lncXCUH13KDEGiXZDKyVhDDnTzNiwtj27
         YzSLOnVKPNAVwfYE+HAndz0+NCLXAHATEOPJGHD9o+uhoNpHS/7eoHcAf+H+bN/S3ltq
         MFBw==
X-Gm-Message-State: AOAM5329lOnSKX+gHiwP0iPm+gR8hrvwQ54oRqDB/+t1nXUJ3QkrFOOl
        9xu6iZS8m7D+Bmy/C3kz/fMkmsFWpVU=
X-Google-Smtp-Source: ABdhPJwZZtutr76w4VUS0TeULN+n22hfFCik4L0L2tEe7NCkRFfmPuFIVzaKUKwVIq1Wdyvid933NA==
X-Received: by 2002:a63:e617:: with SMTP id g23mr8533026pgh.102.1595599950342;
        Fri, 24 Jul 2020 07:12:30 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id d37sm6230774pgd.18.2020.07.24.07.12.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jul 2020 07:12:29 -0700 (PDT)
Subject: Re: [RFC][BUG] io_uring: fix work corruption for poll_add
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <eaa5b0f65c739072b3f0c9165ff4f9110ae399c4.1595527863.git.asml.silence@gmail.com>
 <57971720-992a-593c-dc3e-9f5fe8c76f1f@kernel.dk>
 <0c52fec1-48a3-f9fe-0d35-adf6da600c2c@kernel.dk>
 <ae6eca27-c0e2-384f-df89-2cd8b46bd6e6@gmail.com>
 <209efa89-fb7f-3be3-4be1-f67477b220f1@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2563f701-8bac-b2b0-f3fa-420af545ef26@kernel.dk>
Date:   Fri, 24 Jul 2020 08:12:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <209efa89-fb7f-3be3-4be1-f67477b220f1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/24/20 6:52 AM, Pavel Begunkov wrote:
> On 24/07/2020 15:46, Pavel Begunkov wrote:
>> On 24/07/2020 01:24, Jens Axboe wrote:
>>> On 7/23/20 4:16 PM, Jens Axboe wrote:
>>>> On 7/23/20 12:12 PM, Pavel Begunkov wrote:
>>>>> poll_add can have req->work initialised, which will be overwritten in
>>>>> __io_arm_poll_handler() because of the union. Luckily, hash_node is
>>>>> zeroed in the end, so the damage is limited to lost put for work.creds,
>>>>> and probably corrupted work.list.
>>>>>
>>>>> That's the easiest and really dirty fix, which rearranges members in the
>>>>> union, arm_poll*() modifies and zeroes only work.files and work.mm,
>>>>> which are never taken for poll add.
>>>>> note: io_kiocb is exactly 4 cachelines now.
>>>>
>>>> I don't think there's a way around moving task_work out, just like it
>>
>> +hash_node. I was thinking to do apoll alloc+memcpy as for rw, but this
>> one is ugly.
>>
>>>> was done on 5.9. The problem is that we could put the environment bits
>>>> before doing task_work_add(), but we might need them if the subsequent
>>>> queue ends up having to go async. So there's really no know when we can
>>>> put them, outside of when the request finishes. Hence, we are kind of
>>>> SOL here.
>>>
>>> Actually, if we do go async, then we can just grab the environment
>>> again. We're in the same task at that point. So maybe it'd be better to
>>> work on ensuring that the request is either in the valid work state, or
>>> empty work if using task_work.
>>>
>>> Only potential complication with that is doing io_req_work_drop_env()
>>> from the waitqueue handler, at least the ->needs_fs part won't like that
>>> too much.
>>
>> Considering that work->list is removed before executing io_wq_work, it
>> should work. And if done only for poll_add, which needs nothing and ends up
>> with creds, there shouldn't be any problems. I'll try this out
> 
> Except for custom ->creds assigned at the beginning with the personality
> feature. Does poll ever use it?

It's kind of annoying how we don't have a def->needs_creds, because lots
of things would never use it. For poll, it wouldn't be used at all,
which makes this issue doubly annoying.

-- 
Jens Axboe

