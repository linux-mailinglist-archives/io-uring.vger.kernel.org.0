Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8C6A68DAC4
	for <lists+io-uring@lfdr.de>; Tue,  7 Feb 2023 15:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbjBGO3B (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Feb 2023 09:29:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232136AbjBGO3B (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Feb 2023 09:29:01 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7262190
        for <io-uring@vger.kernel.org>; Tue,  7 Feb 2023 06:28:59 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id h15so8424794plk.12
        for <io-uring@vger.kernel.org>; Tue, 07 Feb 2023 06:28:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GVbHcngcrxb+EtKZ7t6pGqbRT5EixlZslzmjZrbJg0w=;
        b=aKxw9JI4eNRmyEHa8pZiz59fi5N4wmsEKjVGoh78GkaeojSICmHq3P/0QQJjtCGoWY
         tVUtigRisgv/MaRvcsGvEaqU5XmI7siMb3JEJnqmaq2u6k0l1sDvsFB15Cb3uF8PyZnT
         /lp77ze+OK18ZTdBsQRqjUyC9LLE2R/xvF10LbmVqHfJv+TZlYTm7yhVjWnSnaQ84Pyk
         dP7pEXBu+ifEiQwpYfRYaQau+ZxgsvtXeyCfxTRkBkXPmZVSeu9YejJ+1MaIfZBocaeo
         Nlz2geKB6sc8dNPfmPhlRaSX7xgjR7f/h34Q41hurGXg2yT6yNMdJQIYKFDQOqi2K+We
         zc4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GVbHcngcrxb+EtKZ7t6pGqbRT5EixlZslzmjZrbJg0w=;
        b=1aoP740/9RoJoM0hZDdPadMpNFxDxpapbF1PMR7iDQe7+Z8mkhAYjk5kD2reMUmdI8
         UAvYx64sRmnxqOOgE432E2aUBdUH6uPLKTAbyNKy/QdlyOTCPl+s8aImdBFoT16raYDT
         0aY9AO4uwcBKTux8p0IDjEe1dDiRozTr6Yg0MJf+P8JbGIZt+yKTg+7DnrjfAAPyGLn3
         eCFy1cZNSJkWWFwOKbkXKJsMQGWqy/0kSv8Hn/wYJlvbpGSeQxWgYSZMxyVbS6cN6y7n
         84VdN9m4tTBrUL6AtVq08ZA7jTcoy0dcHjWUBjPcwZ7x06L/NhvctZlnb8uRQZDwNI5Z
         8R/Q==
X-Gm-Message-State: AO0yUKXGZ1Zhoy8q+45IgDAZwh+J6H0QwmKw/LBA4ZQNX4pgNbc1QG3F
        kQnmx1/ggf4UEFMyDxENOcmagg==
X-Google-Smtp-Source: AK7set9MKzN9TnSmA0Lxp77fPjhgxhnGyzjVDYWLWGw+37wFdUVt/E4zaet+bYlKWvMXhVTK++Snvg==
X-Received: by 2002:a05:6a20:8f17:b0:b6:7df3:4cb2 with SMTP id b23-20020a056a208f1700b000b67df34cb2mr4265712pzk.4.1675780139269;
        Tue, 07 Feb 2023 06:28:59 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b205-20020a621bd6000000b0058bc37f3d1csm9279979pfb.44.2023.02.07.06.28.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Feb 2023 06:28:58 -0800 (PST)
Message-ID: <eff3cc48-7279-2fbf-fdbd-f35eff2124d0@kernel.dk>
Date:   Tue, 7 Feb 2023 07:28:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 09/19] io_uring: convert to use vm_account
Content-Language: en-US
To:     Alistair Popple <apopple@nvidia.com>
Cc:     linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com, jhubbard@nvidia.com,
        tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com,
        mkoutny@suse.com, daniel@ffwll.ch,
        "Daniel P . Berrange" <berrange@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
References: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
 <44e6ead48bc53789191b22b0e140aeb82459e75f.1675669136.git-series.apopple@nvidia.com>
 <52d41a7e-1407-e74f-9206-6dd583b7b6b5@kernel.dk> <87k00unusm.fsf@nvidia.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87k00unusm.fsf@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/6/23 6:03?PM, Alistair Popple wrote:
> 
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> On 2/6/23 12:47?AM, Alistair Popple wrote:
>>> Convert io_uring to use vm_account instead of directly charging pages
>>> against the user/mm. Rather than charge pages to both user->locked_vm
>>> and mm->pinned_vm this will only charge pages to user->locked_vm.
>>
>> Not sure how we're supposed to review this, when you just send us 9/19
>> and vm_account_release() is supposedly an earlier patch in this series.
>>
>> Either CC the whole series, or at least the cover letter, core parts,
>> and the per-subsystem parts.
> 
> Ok, thanks. Will be sure to add everyone to the cover letter and patch
> 01 when I send the next version.
> 
> For reference the cover letter is here:
> 
> https://lore.kernel.org/linux-mm/cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com/
> 
> And the core patch that introduces vm_account is here:
> 
> https://lore.kernel.org/linux-mm/e80b61561f97296a6c08faeebe281cb949333d1d.1675669136.git-series.apopple@nvidia.com/
> 
> No problem if you want to wait for the resend/next version before
> taking another look though.

Thanks, that helps. Like listed in the cover letter, I also have to
agree that this is badly named. It's way too generic, it needs to have a
name that tells you what it does. There's tons of accounting, you need
to be more specific.

Outside of that, we're now doubling the amount of memory associated with
tracking this. That isn't necessarily a showstopper, but it is not
ideal. I didn't take a look at the other conversions (again, because
they were not sent to me), but seems like the task_struct and flags
could just be passed in as they may very well be known to many/most
callers?

-- 
Jens Axboe

