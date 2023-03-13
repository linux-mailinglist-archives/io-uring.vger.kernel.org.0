Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 699816B6E41
	for <lists+io-uring@lfdr.de>; Mon, 13 Mar 2023 04:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjCMD5n (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Mar 2023 23:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCMD5n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Mar 2023 23:57:43 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B45AD38651;
        Sun, 12 Mar 2023 20:57:41 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id y4so13920760edo.2;
        Sun, 12 Mar 2023 20:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678679860;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5q5lViZbu74yR6PQvQXCvRyrsQgiPFLDkCuO1oF3rFE=;
        b=nsE5lYqnLgZ4uTOC16jGRqHBvsY5AOjYOHuuYizpwszu+CwehYDZOTBtmX97fpsnZk
         cR6c2rUtAlbwRgMYs/X1sHlOsiNudk1f3WNGGczrbqI2jzaU/1AhjUdCFxA+jtw1HP2V
         goCGFDIJO4VMg9y4KRkyTg30SjlSAP/tRsaBpYjGFbD1/tFtfBTfUiCtw/vmaLQgULEI
         IP8GfxK5dehOdKuctBMtuNSvaWedJWRLuYdyEiUPTjAsLSHTHJL+KMXTtmpp21/4IOxh
         caaUVqY6U5i90Cme33nTZKvFzBeT2qI1/Yd/VtW+Dovx/xO9bmGzCTw1AFUp7Ux+2eg/
         19AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678679860;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5q5lViZbu74yR6PQvQXCvRyrsQgiPFLDkCuO1oF3rFE=;
        b=S0fPXIuhYLv1xcylc68tIcLiK4E3K7jmSZM+2xjXvfIp3uF3uX4ynaHRKF5VPvqVpT
         W5YSsZXFn4421uZB+ux+uL3utnAIwz4SY/8dKVFJ+bkbVZj48QJ+KeEK1vvslxmCnMHW
         Ec10POo8uXHp8FqR90xTopdZ3oI4XxXHHOTWj86GiyJvMh+1ZctbgqSTfUtKrGs0Kyfp
         uXRy26jtM9vviLvUi3gxt8qOGgfqI9gEYb7rRu731bTkmF2IKLM6cZ2C4Lf/3MIMAKWy
         3eCQjeM5rtFCrhYYfKMU5vIuUlhI5HQU9fIbWAWUg22Hz5C6sMTCuHR9Wt4MN65QIM54
         UkUA==
X-Gm-Message-State: AO0yUKXyeKPRyvdrS3ptC1A9y2loh6EzXFwmbchV01d8nhGKFxYMx2Nj
        2yPgAyXYK4FiTdC9nwyJzspuMgER2To=
X-Google-Smtp-Source: AK7set+mTbSgV7CwY55amnx9+eqX5svGOqh4IRwJBsGoaLq9TIpwEsUl2yEz6Les/2Y+6pOWtGVw4w==
X-Received: by 2002:a05:6402:3445:b0:4fa:bee3:d16c with SMTP id l5-20020a056402344500b004fabee3d16cmr5773926edc.17.1678679860040;
        Sun, 12 Mar 2023 20:57:40 -0700 (PDT)
Received: from [192.168.8.100] (188.30.129.33.threembb.co.uk. [188.30.129.33])
        by smtp.gmail.com with ESMTPSA id a30-20020a509ea1000000b004aef147add6sm2711966edf.47.2023.03.12.20.57.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Mar 2023 20:57:39 -0700 (PDT)
Message-ID: <a722515b-1311-2abc-c5ab-420609e7131b@gmail.com>
Date:   Mon, 13 Mar 2023 03:56:41 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH] io_uring: One wqe per wq
To:     Jens Axboe <axboe@kernel.dk>, Breno Leitao <leitao@debian.org>,
        io-uring@vger.kernel.org
Cc:     leit@fb.com, linux-kernel@vger.kernel.org
References: <20230310201107.4020580-1-leitao@debian.org>
 <ac6a2da7-aa88-b119-6a44-01d2f2ec9b6d@kernel.dk>
 <94795ed1-f7ac-3d1c-9bd6-fcaaaf5f1fd4@gmail.com>
 <3dd54b5c-aad2-0d1c-2f6a-0af4673a7d00@kernel.dk>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <3dd54b5c-aad2-0d1c-2f6a-0af4673a7d00@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/11/23 22:13, Jens Axboe wrote:
> On 3/11/23 1:56 PM, Pavel Begunkov wrote:
>> On 3/10/23 20:38, Jens Axboe wrote:
>>> On 3/10/23 1:11 PM, Breno Leitao wrote:
>>>> Right now io_wq allocates one io_wqe per NUMA node.  As io_wq is now
>>>> bound to a task, the task basically uses only the NUMA local io_wqe, and
>>>> almost never changes NUMA nodes, thus, the other wqes are mostly
>>>> unused.
>>>
>>> What if the task gets migrated to a different node? Unless the task
>>> is pinned to a node/cpumask that is local to that node, it will move
>>> around freely.
>>
>> In which case we're screwed anyway and not only for the slow io-wq
>> path but also with the hot path as rings and all io_uring ctx and
>> requests won't be migrated locally.
> 
> Oh agree, not saying it's ideal, but it can happen.
> 
> What if you deliberately use io-wq to offload work and you set it
> to another mask? That one I supposed we could handle by allocating
> based on the set mask. Two nodes might be more difficult...
> 
> For most things this won't really matter as io-wq is a slow path
> for that, but there might very well be cases that deliberately
> offload.

It's not created for that, there is no fine control by the user.
If the user set affinity solely to another node, then it will
be quite bad for perf, if the mask covers multiple nodes, it'll
go to the current node. Do you have plans on io-wq across
numa nodes?


>> It's also curious whether io-wq workers will get migrated
>> automatically as they are a part of the thread group.
> 
> They certainly will, unless affinitized otherwise.

-- 
Pavel Begunkov
