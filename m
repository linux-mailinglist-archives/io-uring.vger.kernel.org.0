Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9F9C6EB990
	for <lists+io-uring@lfdr.de>; Sat, 22 Apr 2023 16:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjDVOIp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 22 Apr 2023 10:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjDVOIo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 22 Apr 2023 10:08:44 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A170128
        for <io-uring@vger.kernel.org>; Sat, 22 Apr 2023 07:08:43 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1a6a50dd62cso4265995ad.1
        for <io-uring@vger.kernel.org>; Sat, 22 Apr 2023 07:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1682172522; x=1684764522;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w5oXDhx4GQil44wHDs+IQBnwzAV6bOoQH+xu5ZU36KY=;
        b=Es6movJkF0QAwVFFbBer6YzFCe+ea4l4rfFhMvCZCRHT+jlMuwkn1l/whqgvNGtaeL
         UgeV6npxNlYx5IAiGha2cgebmwRpP/FVQr61i7hMpEPwn9r2fGOokyHA1NM7Lul52+RF
         3s8fbEnONmKOm1WfhjWl+354MBKYn8Rj2xazthk5tnZ8rgb1LiMLHuA/Tk8JM4eqm/fv
         O8vjNnm3vPFPUo8tkLhgHmJ9WfoLglM3yjiGO6TOFd4Adrtj8Qw5k3LhDoA4pzM8yPfJ
         5x+UQHXk18Und6UaGXfHScti0+Tmjrxm9/I3XpalkldzQZ9byeq29rq0CUmMnOk6vTXU
         /RQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682172522; x=1684764522;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w5oXDhx4GQil44wHDs+IQBnwzAV6bOoQH+xu5ZU36KY=;
        b=MW3O/HzbO4M1NS7jSccri85Yn/Hvx6o7jRd95UJK17RZVYkcqxhP0KS4NQkrXjM8qC
         CZA61Ljs15MwkBKoIDY9kF/KhNsUCOAO5zAelCr/MRy12OAfwnICNUyCn1qF0SSuR2Da
         FoSIswZBcz4a87I/0cq6OO+AbP9nPwhVCw2wUAsXVS1sWUQaTbWa5zcMObg6a7euLTYi
         gNEpJOnL7ABIlxQHT5KaEhb8KZVGWo41gKWC2/3XcG7fqY+xk2mPayqzawr78C+79zqK
         e7H3pzKg/gXu7AG8E1WLsSP5lvYeWDw+z4yteaPJKuKJjqOLuElT7BIJcfDhoNS6CV3W
         lNbw==
X-Gm-Message-State: AAQBX9cpVzoikAF8Q3GpPWWRUlrXbQaYG2jNEPr+9qHwqGdEtYlVdl0S
        9/f1PnuZ2b/lwNg6NWXCTdtW/A==
X-Google-Smtp-Source: AKy350Y5R0jvEruvYE+KmwaeJ6Woeqo0w73mj9XCAkgFRIBB8rhwglK9OaXE8wIqASWJJLnD2J9X7g==
X-Received: by 2002:a17:902:f685:b0:1a9:4167:5db7 with SMTP id l5-20020a170902f68500b001a941675db7mr7546811plg.4.1682172522546;
        Sat, 22 Apr 2023 07:08:42 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id c10-20020a170902848a00b001a95f632340sm900570plo.46.2023.04.22.07.08.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Apr 2023 07:08:42 -0700 (PDT)
Message-ID: <05ad98bb-0f03-d870-e975-a223205294c8@kernel.dk>
Date:   Sat, 22 Apr 2023 08:08:41 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: SQPOLL / uring_cmd_iopoll
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>, Bernd Schubert <bschubert@ddn.com>
Cc:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <cbfa6c3f-11bd-84f7-bdb0-4342f8fd38f3@ddn.com>
 <ZEPZJ2wEhumPbYOU@ovpn-8-21.pek2.redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZEPZJ2wEhumPbYOU@ovpn-8-21.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/22/23 6:55?AM, Ming Lei wrote:
> On Fri, Apr 21, 2023 at 10:09:36PM +0000, Bernd Schubert wrote:
>> Hello,
>>
>> I was wondering if I could set up SQPOLL for fuse/IORING_OP_URING_CMD 
>> and what would be the latency win. Now I get a bit confused what the 
>> f_op->uring_cmd_iopoll() function is supposed to do.
>>
>> Is it just there to check if SQEs are can be completed as CQE? In rw.c 
>> io_do_iopoll() it looks like this. I don't follow all code paths in 
>> __io_sq_thread yet, but it looks a like it already checks if the ring 
>> has new entries
>>
>> to_submit = io_sqring_entries(ctx);
>> ...
>> ret = io_submit_sqes(ctx, to_submit);
>>
>>    --> it will eventually call into ->uring_cmd() ?
>>
>> And then io_do_iopoll ->  file->f_op->uring_cmd_iopoll is supposed to 
>> check for available cq entries and will submit these? I.e. I just return 
>> 1 if when the request is ready? And also ensure that 
>> req->iopoll_completed is set?
>>
>>
>> I'm also not sure what I should do with struct io_comp_batch * - I don't 
>> have struct request *req_list anywhere in my fuse-uring changes, seems 
>> to be blk-mq specific? So I should just ignore that parameter?
>>
>>
>> Btw, this might be useful for ublk as well?
> 
> For the in-tree ublk driver, we need to copy data inside ->uring_cmd()
> between block request pages and user buffer, so SQPOLL may not be done
> because it isn't efficient for the kthread to copy on remote task mm
> space. However, ublk user copy feature[1](posted recently) doesn't
> need the copy in ->uring_cmd() any more, so SQPOLL becomes possible for
> ublk uring cmd.

That hasn't been true for a long time, and isn't even true in
5.10-stable anymore or anything newer. The SQPOLL thread is not a
kthread, and it doesn't need to do anything to copy the data that the
inline submission wouldn't also do. There is no "remote task mm". The
cost would be the same, outside of caching effects.

-- 
Jens Axboe

