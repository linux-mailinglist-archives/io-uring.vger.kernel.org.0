Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8731E76571B
	for <lists+io-uring@lfdr.de>; Thu, 27 Jul 2023 17:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232402AbjG0PNi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Jul 2023 11:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233398AbjG0PNh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Jul 2023 11:13:37 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AEF719A1;
        Thu, 27 Jul 2023 08:13:33 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id 2adb3069b0e04-4fb7589b187so1881423e87.1;
        Thu, 27 Jul 2023 08:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690470811; x=1691075611;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vfc0j7nyCjPKr2vHL7OlpqXuJgbaIBdmBBJ7JUmGtbM=;
        b=Q88HS+AhGTpjfCkG7109/CnlQf91iFu74fj2D7pGAP9/ZVls3gfUpwRA4B0i1MEsDm
         YlDtrgJYIskzIqaRKLb5cQhyqRdA7gt6Ua/LLYNd/gCyScn/CVRZA8/IZ7JvFoKc36U2
         CvzvXqkjkYFpW7lUV7UEePHpdsjISRJVSp1m7MoGhcVyrE+0tShJWGA1rPSwWP5FkA2s
         Bc1TNa1HpNxMcuinxZZHodvkulHG3GHx8EKalAkXZJj8H8+nddlpBbmCYydsPq9jq8Lf
         YmJhUXeQYnAykP7Ovj+oBRkKI35EfPEcseeqEIDeltlZaNWYmBvYRGROM4vnKr9hlibk
         S+9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690470811; x=1691075611;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vfc0j7nyCjPKr2vHL7OlpqXuJgbaIBdmBBJ7JUmGtbM=;
        b=IvN6qG+H3fKiXEfoljmkTXfTb/aKcfXH8GeC997U1rS1vQ0daq6Qv4/sr2J51eti7m
         sQ7F25BwhpFeXqB6FGpoqUb2x2zQvAaLo0tIWh9CSYoLCY8B0uy1SoY0m9qIvLlDxEsC
         k6zonzshRzq3+I0OPpEajCWHsbOguZtpWu5nVqx0Wrm1xZrr5/4JZR1xRoc7E0PeTaeO
         m0bFwkBJPHjKyl4XwaGH5uuBoYm4rv2ZvyHgcbssVNWlkTDa1j3F0xYrb33dg8lI144M
         llJnwGiQwa8LOuhmcVj2YUwX/HUIke/2qardxlHIDpMpX0NaflAzb0GNvUqXmIo3S9bU
         FaWQ==
X-Gm-Message-State: ABy/qLZAreHltEOjCcmYFyiAVaedAhmZhnkhz9teoogY544hnVR0aQM1
        uaL+vmIOUASizNrAMpy46tlVJOm7PB4=
X-Google-Smtp-Source: APBJJlGHaU/nhUCPiwplpXtNOlpgfQGrWGo5aTi6okv7VWqeAq42rZHhAtxC792T+fT7eGJQDzvNNw==
X-Received: by 2002:a19:4341:0:b0:4fb:889c:c53d with SMTP id m1-20020a194341000000b004fb889cc53dmr1870820lfj.10.1690470810991;
        Thu, 27 Jul 2023 08:13:30 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:f735])
        by smtp.gmail.com with ESMTPSA id f1-20020a05640214c100b0052276921a28sm752518edx.78.2023.07.27.08.13.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jul 2023 08:13:30 -0700 (PDT)
Message-ID: <2785f009-2ebb-028d-8250-d5f3a30510f0@gmail.com>
Date:   Thu, 27 Jul 2023 16:12:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] io_uring: add support for getdents
Content-Language: en-US
To:     Christian Brauner <brauner@kernel.org>, Hao Xu <hao.xu@linux.dev>,
        djwong@kernel.org, Dave Chinner <david@fromorbit.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        josef@toxicpanda.com
References: <20230718132112.461218-1-hao.xu@linux.dev>
 <20230718132112.461218-4-hao.xu@linux.dev>
 <20230726-leinen-basisarbeit-13ae322690ff@brauner>
 <e9ddc8cc-f567-46bc-8f82-cf5ff8ff6c95@linux.dev>
 <20230727-salbe-kurvigen-31b410c07bb9@brauner>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20230727-salbe-kurvigen-31b410c07bb9@brauner>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/27/23 15:27, Christian Brauner wrote:
> On Thu, Jul 27, 2023 at 07:51:19PM +0800, Hao Xu wrote:
>> On 7/26/23 23:00, Christian Brauner wrote:
>>> On Tue, Jul 18, 2023 at 09:21:10PM +0800, Hao Xu wrote:
>>>> From: Hao Xu <howeyxu@tencent.com>
>>>>
>>>> This add support for getdents64 to io_uring, acting exactly like the
>>>> syscall: the directory is iterated from it's current's position as
>>>> stored in the file struct, and the file's position is updated exactly as
>>>> if getdents64 had been called.
>>>>
>>>> For filesystems that support NOWAIT in iterate_shared(), try to use it
>>>> first; if a user already knows the filesystem they use do not support
>>>> nowait they can force async through IOSQE_ASYNC in the sqe flags,
>>>> avoiding the need to bounce back through a useless EAGAIN return.
>>>>
>>>> Co-developed-by: Dominique Martinet <asmadeus@codewreck.org>
>>>> Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
>>>> Signed-off-by: Hao Xu <howeyxu@tencent.com>
>>>> ---
[...]
>> I actually saw this semaphore, and there is another xfs lock in
>> file_accessed
>>    --> touch_atime
>>      --> inode_update_time
>>        --> inode->i_op->update_time == xfs_vn_update_time
>>
>> Forgot to point them out in the cover-letter..., I didn't modify them
>> since I'm not very sure about if we should do so, and I saw Stefan's
>> patchset didn't modify them too.
>>
>> My personnal thinking is we should apply trylock logic for this
>> inode->i_rwsem. For xfs lock in touch_atime, we should do that since it
>> doesn't make sense to rollback all the stuff while we are almost at the
>> end of getdents because of a lock.
> 
> That manoeuvres around the problem. Which I'm slightly more sensitive
> too as this review is a rather expensive one.
> 
> Plus, it seems fixable in at least two ways:
> 
> For both we need to be able to tell the filesystem that a nowait atime
> update is requested. Simple thing seems to me to add a S_NOWAIT flag to
> file_time_flags and passing that via i_op->update_time() which already
> has a flag argument. That would likely also help kiocb_modified().

fwiw, we've just recently had similar problems with io_uring read/write
and atime/mtime in prod environment, so we're interested in solving that
regardless of this patchset. I.e. io_uring issues rw with NOWAIT, {a,m}time
touch ignores that, that stalls other submissions and completely screws
latency.

> file_accessed()
> -> touch_atime()
>     -> inode_update_time()
>        -> i_op->update_time == xfs_vn_update_time()
> 
> Then we have two options afaict:
> 
> (1) best-effort atime update
> 
> file_accessed() already has the builtin assumption that updating atime
> might fail for other reasons - see the comment in there. So it is
> somewhat best-effort already.
> 
> (2) move atime update before calling into filesystem
> 
> If we want to be sure that access time is updated when a readdir request
> is issued through io_uring then we need to have file_accessed() give a
> return value and expose a new helper for io_uring or modify
> vfs_getdents() to do something like:
> 
> vfs_getdents()
> {
> 	if (nowait)
> 		down_read_trylock()
> 
> 	if (!IS_DEADDIR(inode)) {
> 		ret = file_accessed(file);
> 		if (ret == -EAGAIN)
> 			goto out_unlock;
> 
> 		f_op->iterate_shared()
> 	}
> }
> 
> It's not unprecedented to do update atime before the actual operation
> has been done afaict. That's already the case in xfs_file_write_checks()
> which is called before anything is written. So that seems ok.
> 
> Does any of these two options work for the xfs maintainers and Jens?

It doesn't look (2) will solve it for reads/writes, at least without
the pain of changing the {write,read}_iter callbacks. 1) sounds good
to me from the io_uring perspective, but I guess it won't work
for mtime?

-- 
Pavel Begunkov
