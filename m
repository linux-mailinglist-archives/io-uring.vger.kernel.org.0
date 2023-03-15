Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E46A6BBA51
	for <lists+io-uring@lfdr.de>; Wed, 15 Mar 2023 17:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbjCOQ4m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Mar 2023 12:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232238AbjCOQ4i (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Mar 2023 12:56:38 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537BB1E9C4;
        Wed, 15 Mar 2023 09:56:36 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id h8so34326753ede.8;
        Wed, 15 Mar 2023 09:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678899395;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9TQxcK9OaPYsertMuppkBMhe3ksHgbNWBHBNJuD/3SM=;
        b=bf++em/WSxTAwx8Jt2VK4uGWuaZuyXvqcOVhTxis3lSgx7N5+fkXw9aYA85T5G/g6X
         IaRhtYqMS5V29bctv8MUwIyDFms+yIOwvicMa6Xu3cUBmsLFDGOgT445O1I9KAg7tQ6w
         LW7aPN2n0Ig4nt6ecB0pyx7QhcxJMMyjPeRIaNxTwzldk/Gu0RsuBK3jFMrVW+jXp7rH
         H0x4yEkFvfZYOso0rpDbu2qqVUdS21oyMgYdAVa4hLmkyCDlu2Plzj+g+uPPThHSxQJt
         Vk5jzt/UdIbS7tAa4OOaGKx42DEath5a9JUmzLWavHBVyCG8o45tsbgl9FT4XML7wuep
         8GKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678899395;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9TQxcK9OaPYsertMuppkBMhe3ksHgbNWBHBNJuD/3SM=;
        b=VtutT1pJUiiN4lukpSQa/tzNrhgvQP/Crd/uRzzkuEA8urSxeWdf6chLfplkhjzmDw
         KE+IKX9QtTiCDtdquPfPpG/q//L5ckV5PY31zooZNM+BOWXgykCx3hW4EO6AOvKOfuLy
         gxPrmyKxxUwuCLe8w2TfWFi6v3RPx5uneq/bXQaxCij5lZgIYWUVCExzc17DgCht6fI5
         H3dZXpmS0SQZFfTTzr7mfkJ8zYE8Gbj306hbhG8l9otKlAd/83hPgtydHQCnRrUXjeyO
         3Xdb9N6yCM9bGoD3quR0+CSN/LZhKVymh3yX/QKl9IO3E29kzrtiip1VkXxAK5YBeUCY
         aooQ==
X-Gm-Message-State: AO0yUKXHqDj3i2EIHKh9Rd7uzB22yaZd263hVXo4D6a2Uyvsd7af6zXj
        k9Hp7bHSP2mfINpp9gKDhVd6ZcP7Tmw=
X-Google-Smtp-Source: AK7set/pn6NtBkwziMZ2k+MPhC4lRt2y2JTW+VqQug37QPJA/AWaL0QGO1soOyI/zun5Tooo0/dchg==
X-Received: by 2002:a17:907:20f1:b0:924:943d:7181 with SMTP id rh17-20020a17090720f100b00924943d7181mr6198534ejb.51.1678899394771;
        Wed, 15 Mar 2023 09:56:34 -0700 (PDT)
Received: from [192.168.8.100] (94.196.116.3.threembb.co.uk. [94.196.116.3])
        by smtp.gmail.com with ESMTPSA id u21-20020a170906409500b00928de86245fsm2729586ejj.135.2023.03.15.09.56.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 09:56:34 -0700 (PDT)
Message-ID: <f3d1faef-dc0e-48e2-ab08-3ac1c7e7bcbb@gmail.com>
Date:   Wed, 15 Mar 2023 16:53:09 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [RFC 0/2] optimise local-tw task resheduling
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
References: <cover.1678474375.git.asml.silence@gmail.com>
 <ZBEvD04sH/JzN7MJ@ovpn-8-22.pek2.redhat.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZBEvD04sH/JzN7MJ@ovpn-8-22.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/15/23 02:35, Ming Lei wrote:
> Hi Pavel
> 
> On Fri, Mar 10, 2023 at 07:04:14PM +0000, Pavel Begunkov wrote:
>> io_uring extensively uses task_work, but when a task is waiting
>> for multiple CQEs it causes lots of rescheduling. This series
>> is an attempt to optimise it and be a base for future improvements.
>>
>> For some zc network tests eventually waiting for a portion of
>> buffers I've got 10x descrease in the number of context switches,
>> which reduced the CPU consumption more than twice (17% -> 8%).
>> It also helps storage cases, while running fio/t/io_uring against
>> a low performant drive it got 2x descrease of the number of context
>> switches for QD8 and ~4 times for QD32.
> 
> ublk uses io_uring_cmd_complete_in_task()(io_req_task_work_add())
> heavily. So I tried this patchset, looks not see obvious change
> on both IOPS and context switches when running 't/io_uring /dev/ublkb0',
> and it is one null ublk target(ublk add -t null -z -u 1 -q 2), IOPS
> is ~2.8M.

Hi Ming,

It's enabled for rw requests and send-zc notifications, but
io_uring_cmd_complete_in_task() is not covered. I'll be enabling
it for more cases, including pass through.

> But ublk applies batch schedule similar with io_uring before calling
> io_uring_cmd_complete_in_task().

The feature doesn't tolerate tw that produce multiple CQEs, so
it can't be applied to this batching and the task would stuck
waiting.

btw, from a quick look it appeared that ublk batching is there
to keep requests together but not to improve batching. And if so,
I think we can get rid of it, rely on io_uring batching and
let ublk to gather its requests from tw list, which sounds
cleaner. I'll elaborate on that later

-- 
Pavel Begunkov
