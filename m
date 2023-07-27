Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6039765869
	for <lists+io-uring@lfdr.de>; Thu, 27 Jul 2023 18:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbjG0QSy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Jul 2023 12:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbjG0QSw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Jul 2023 12:18:52 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503FC2D4B;
        Thu, 27 Jul 2023 09:18:51 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-98dfb3f9af6so156008266b.2;
        Thu, 27 Jul 2023 09:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690474730; x=1691079530;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Xcec1jPjRxFJg5kObcCiqV46fo1UkCxtd/59TpJS7Kc=;
        b=oct+otYlabhspOjnKumKX/NpyZOsDuWsta5UdFUzr9wv1yD02OOxgLPnyGmT3n8YuK
         SYnkHZOlVt2rc4hOOdGODVyyYjix1LZFTAfoHCeFdCIlgU6FTvY7rj3bxgBbz96Y6Qa6
         oOXFJFz70VIzVaNLKtRO6jrrsk6Qm/OkfGeFvzLSGsLUIlEvJ2p/TKOaQEa2GbxcSB2S
         /YqGArNbVePLNM7Shd7kg6DGstBfLLE646x5+pirkyVEOL2IxjbnO1zoBVReZj4Opf9A
         0ef3Wl1KhCvd+3pxuJJZltaO0rBvHNEAGIJsDwsWgRv0GsXHkMSACkVvNplpG0jw3P4d
         LBCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690474730; x=1691079530;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xcec1jPjRxFJg5kObcCiqV46fo1UkCxtd/59TpJS7Kc=;
        b=X6ZGoJM2TcM8qaNXyDyxdilus1WcbZplMtaWzjzlqRHy/mbAzpe83ueJz1GCR5vwj4
         xmmbRvCoPw+ohP4JD62NQOjjGR8npHJSMGCL8ggthkuO0Y29wIYSw1yQKCYZwgxWSBWH
         g5g1nXXoD90dZzg3IEROGfiEmP6Sg43h3SGoucYt5+FcaXGVKBCrtpRKv2eRdEopKmgv
         BNxHikWlBnFk9qOugvHxlmFpJ+8sevIlJ0p/6DxFQeRGlur9avvCLaWIJJDeJWP6/x+h
         80eJ/mUjAen/JT701kYU8ZzLz6wJCNWNk380x/cHSgEdCbaPJiQpW/gm2N3Sf1saIk9v
         VrpQ==
X-Gm-Message-State: ABy/qLZJwyduX+N5IQW+RGFcz/QwptERANY67gEZlFM80DWIfbqFYmoM
        6VmNIhScPA+Q8MYzbAVyEtTzmRQfwQg=
X-Google-Smtp-Source: APBJJlGRN+Qa1njYJaf6G+Atwp8F5yH2hInLisfc4YQh8J1Ksu/C8JoNVHUcV0VGr5Hz4VB+IdFr+w==
X-Received: by 2002:a17:906:74d8:b0:99b:cb78:8537 with SMTP id z24-20020a17090674d800b0099bcb788537mr2418903ejl.11.1690474729564;
        Thu, 27 Jul 2023 09:18:49 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:f735])
        by smtp.gmail.com with ESMTPSA id t25-20020a1709066bd900b0098e2eaec395sm945373ejs.130.2023.07.27.09.18.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jul 2023 09:18:49 -0700 (PDT)
Message-ID: <77feb96e-adf7-56f2-dac5-ca5b075afa83@gmail.com>
Date:   Thu, 27 Jul 2023 17:17:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] io_uring: add support for getdents
Content-Language: en-US
To:     Christian Brauner <brauner@kernel.org>
Cc:     Hao Xu <hao.xu@linux.dev>, djwong@kernel.org,
        Dave Chinner <david@fromorbit.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
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
 <2785f009-2ebb-028d-8250-d5f3a30510f0@gmail.com>
 <20230727-westen-geldnot-63435c2f65ad@brauner>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20230727-westen-geldnot-63435c2f65ad@brauner>
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

On 7/27/23 16:52, Christian Brauner wrote:
> On Thu, Jul 27, 2023 at 04:12:12PM +0100, Pavel Begunkov wrote:
>> On 7/27/23 15:27, Christian Brauner wrote:
>>> On Thu, Jul 27, 2023 at 07:51:19PM +0800, Hao Xu wrote:
>>>> On 7/26/23 23:00, Christian Brauner wrote:
>>>>> On Tue, Jul 18, 2023 at 09:21:10PM +0800, Hao Xu wrote:
>>>>>> From: Hao Xu <howeyxu@tencent.com>
>>>>>>
>>>>>> This add support for getdents64 to io_uring, acting exactly like the
>>>>>> syscall: the directory is iterated from it's current's position as
>>>>>> stored in the file struct, and the file's position is updated exactly as
>>>>>> if getdents64 had been called.
>>>>>>
>>>>>> For filesystems that support NOWAIT in iterate_shared(), try to use it
>>>>>> first; if a user already knows the filesystem they use do not support
>>>>>> nowait they can force async through IOSQE_ASYNC in the sqe flags,
>>>>>> avoiding the need to bounce back through a useless EAGAIN return.
>>>>>>
>>>>>> Co-developed-by: Dominique Martinet <asmadeus@codewreck.org>
>>>>>> Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
>>>>>> Signed-off-by: Hao Xu <howeyxu@tencent.com>
>>>>>> ---
>> [...]
>>>> I actually saw this semaphore, and there is another xfs lock in
>>>> file_accessed
>>>>     --> touch_atime
>>>>       --> inode_update_time
>>>>         --> inode->i_op->update_time == xfs_vn_update_time
>>>>
>>>> Forgot to point them out in the cover-letter..., I didn't modify them
>>>> since I'm not very sure about if we should do so, and I saw Stefan's
>>>> patchset didn't modify them too.
>>>>
>>>> My personnal thinking is we should apply trylock logic for this
>>>> inode->i_rwsem. For xfs lock in touch_atime, we should do that since it
>>>> doesn't make sense to rollback all the stuff while we are almost at the
>>>> end of getdents because of a lock.
>>>
>>> That manoeuvres around the problem. Which I'm slightly more sensitive
>>> too as this review is a rather expensive one.
>>>
>>> Plus, it seems fixable in at least two ways:
>>>
>>> For both we need to be able to tell the filesystem that a nowait atime
>>> update is requested. Simple thing seems to me to add a S_NOWAIT flag to
>>> file_time_flags and passing that via i_op->update_time() which already
>>> has a flag argument. That would likely also help kiocb_modified().
>>
>> fwiw, we've just recently had similar problems with io_uring read/write
>> and atime/mtime in prod environment, so we're interested in solving that
>> regardless of this patchset. I.e. io_uring issues rw with NOWAIT, {a,m}time
>> touch ignores that, that stalls other submissions and completely screws
>> latency.
>>
>>> file_accessed()
>>> -> touch_atime()
>>>      -> inode_update_time()
>>>         -> i_op->update_time == xfs_vn_update_time()
>>>
>>> Then we have two options afaict:
>>>
>>> (1) best-effort atime update
>>>
>>> file_accessed() already has the builtin assumption that updating atime
>>> might fail for other reasons - see the comment in there. So it is
>>> somewhat best-effort already.
>>>
>>> (2) move atime update before calling into filesystem
>>>
>>> If we want to be sure that access time is updated when a readdir request
>>> is issued through io_uring then we need to have file_accessed() give a
>>> return value and expose a new helper for io_uring or modify
>>> vfs_getdents() to do something like:
>>>
>>> vfs_getdents()
>>> {
>>> 	if (nowait)
>>> 		down_read_trylock()
>>>
>>> 	if (!IS_DEADDIR(inode)) {
>>> 		ret = file_accessed(file);
>>> 		if (ret == -EAGAIN)
>>> 			goto out_unlock;
>>>
>>> 		f_op->iterate_shared()
>>> 	}
>>> }
>>>
>>> It's not unprecedented to do update atime before the actual operation
>>> has been done afaict. That's already the case in xfs_file_write_checks()
>>> which is called before anything is written. So that seems ok.
>>>
>>> Does any of these two options work for the xfs maintainers and Jens?
>>
>> It doesn't look (2) will solve it for reads/writes, at least without
> 
> It would also solve it for writes which is what my kiocb_modified()
> comment was about. So right now you have:

Great, I assumed there are stricter requirements for mtime not
transiently failing.


> kiocb_modified(IOCB_NOWAI)
> -> file_modified_flags(IOCB_NOWAI)
>     -> file_remove_privs(IOCB_NOWAIT) // already fully non-blocking
>     -> file_accessed(IOCB_NOWAIT)
>        -> i_op->update_time(S_ATIME | S_NOWAIT)
> 
> and since xfs_file_write_iter() calls xfs_file_write_checks() before
> doing any actual work you'd now be fine.
> 
> For reads xfs_file_read_iter() would need to be changed to a similar
> logic but that's for xfs to decide ultimately.
> 
>> the pain of changing the {write,read}_iter callbacks. 1) sounds good
>> to me from the io_uring perspective, but I guess it won't work
>> for mtime?
> 
> I would prefer 2) which seems cleaner to me. But I might miss why this
> won't work. So input needed/wanted.

Maybe I didn't fully grasp the (2) idea

2.1: all read_iter, write_iter, etc. callbacks should do file_accessed()
before doing IO, which sounds like a good option if everyone agrees with
that. Taking a look at direct block io, it's already like this.

2.2: Having io_uring doing file_accessed(). Since it's all currently
hidden behind {read,write}_iter() callbacks and not easily extractable,
it doesn't like a good option, unless I missed sth.
E.g. this ugliness comes to mind.

io_uring_read() {
	file_accessed();
	file->f_op->read_iter(DONT_TOUCH_ATIME);
	...
}

read_iter_impl() {
	// some pre processing

	if (!(flags & DONT_TOUCH_ATIME))
		file_accessed();
}

-- 
Pavel Begunkov
