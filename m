Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A312F6B6167
	for <lists+io-uring@lfdr.de>; Sat, 11 Mar 2023 23:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbjCKWOB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Mar 2023 17:14:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjCKWN7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Mar 2023 17:13:59 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5B444D2BD
        for <io-uring@vger.kernel.org>; Sat, 11 Mar 2023 14:13:57 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id a7so5652646pfx.10
        for <io-uring@vger.kernel.org>; Sat, 11 Mar 2023 14:13:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678572837;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YYjk3cJH8tEOs5ozbUpfr8oFA9o81HoYVh9AIBzXHFg=;
        b=8TQE9D+xWvmMCQ9jenP/l8YinpsjW8h9nNlyAmTtBePF1nGidvBdYymQXDLf8cR1jZ
         VtSbkF3Pl5ISrxFh2JnhAeaV29VIreJs0uYLfQ12/qy6ecT81sr1ao2jUcTbgPh/+j25
         xeBc8WAt/+cJWUdBNR5svqLYiX5IH8PNuQ3J843y+kTq14h1VCnstd4IgbX30OSe9KUH
         cvqQWyTXhWl165jo64IcHDB76tFcgkDKb95Y1mFZgtVQzwj+WZHdgY0LCZw+u0behFvm
         QOeUr8gB98jU0q2f+K6ur1GDK+hNodHpc7ml6fc7UY1aafrlvq5RxFxee2KvuMSeLGof
         Tt4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678572837;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YYjk3cJH8tEOs5ozbUpfr8oFA9o81HoYVh9AIBzXHFg=;
        b=sou1uUwdGDrBWzVW6YabJa8004XVezjMWfYQbB+rPCTVwHOl9USWg9KV4b2u9P4Es9
         9PovqU4ilOT7kE5CGPKB1oC7qB5XgA8wMCEkeXIOYCwbjYs6VcB8oVcU3HiDD6uwzC8O
         zRBTRcTBC+V12Def8I4M41hF9auoWH9PCX4CqJQr9KcQVbwmwGnsZlpTRlzdbu2JOsOb
         UjB41yFbw2meiQDGNyGaxaOs/MWwkrDAHIuHAF4nzSjv0gYHbIRkmfgG79ABir28hpbl
         BhcqGNBlcF3b/C5vsSIQ6QhxY3Ie2RpfQr7VF/55t8J0xrJaWTk5jh8090c470NHGMlF
         B/NA==
X-Gm-Message-State: AO0yUKUUIhcnShijKE3IvmRQ1jXZanY0ETVeQLxKTfbFBP4UrQc8CR7s
        9oK+evfw1dtg+A8+ar98AXmQnw==
X-Google-Smtp-Source: AK7set9gpZ68NKoc9U+dktiUG4mYAhdlMAMuZoJ+hQ2hoW6ixwL2/6x9oE5iKSv/243gwjfJIce1rQ==
X-Received: by 2002:a05:6a00:1d1c:b0:5d1:f76:d1d7 with SMTP id a28-20020a056a001d1c00b005d10f76d1d7mr10133794pfx.1.1678572836767;
        Sat, 11 Mar 2023 14:13:56 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id h14-20020a62b40e000000b0056283e2bdbdsm1866013pfn.138.2023.03.11.14.13.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Mar 2023 14:13:56 -0800 (PST)
Message-ID: <3dd54b5c-aad2-0d1c-2f6a-0af4673a7d00@kernel.dk>
Date:   Sat, 11 Mar 2023 15:13:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] io_uring: One wqe per wq
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Breno Leitao <leitao@debian.org>, io-uring@vger.kernel.org
Cc:     leit@fb.com, linux-kernel@vger.kernel.org
References: <20230310201107.4020580-1-leitao@debian.org>
 <ac6a2da7-aa88-b119-6a44-01d2f2ec9b6d@kernel.dk>
 <94795ed1-f7ac-3d1c-9bd6-fcaaaf5f1fd4@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <94795ed1-f7ac-3d1c-9bd6-fcaaaf5f1fd4@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/11/23 1:56 PM, Pavel Begunkov wrote:
> On 3/10/23 20:38, Jens Axboe wrote:
>> On 3/10/23 1:11 PM, Breno Leitao wrote:
>>> Right now io_wq allocates one io_wqe per NUMA node.  As io_wq is now
>>> bound to a task, the task basically uses only the NUMA local io_wqe, and
>>> almost never changes NUMA nodes, thus, the other wqes are mostly
>>> unused.
>>
>> What if the task gets migrated to a different node? Unless the task
>> is pinned to a node/cpumask that is local to that node, it will move
>> around freely.
> 
> In which case we're screwed anyway and not only for the slow io-wq
> path but also with the hot path as rings and all io_uring ctx and
> requests won't be migrated locally.

Oh agree, not saying it's ideal, but it can happen.

What if you deliberately use io-wq to offload work and you set it
to another mask? That one I supposed we could handle by allocating
based on the set mask. Two nodes might be more difficult...

For most things this won't really matter as io-wq is a slow path
for that, but there might very well be cases that deliberately
offload.

> It's also curious whether io-wq workers will get migrated
> automatically as they are a part of the thread group.

They certainly will, unless affinitized otherwise.

-- 
Jens Axboe


