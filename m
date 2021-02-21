Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20DA1320DDF
	for <lists+io-uring@lfdr.de>; Sun, 21 Feb 2021 22:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbhBUVXg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Feb 2021 16:23:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbhBUVXf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Feb 2021 16:23:35 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A020C061574
        for <io-uring@vger.kernel.org>; Sun, 21 Feb 2021 13:22:55 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id t26so8957819pgv.3
        for <io-uring@vger.kernel.org>; Sun, 21 Feb 2021 13:22:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mouPQRfM19p8vHP5Tnph2d1M9LHaUd098MlUuEprpnc=;
        b=kQxjQGyQGPJlN5pFHbd6ef/Ly95b8HcS2U++VHd5l3M7dqQflcwjwhVNuxfejlg4kg
         sgdyy/w1ZK4LJv0BuRgqO/HJAbYOvWTJ7XbmTWFUnxCNFWZid66PMFGWU7whnURZ5ysj
         kcVFsLbPI3hxzT5y4rXKYSsB0XjmNrdarsthmckYkEJ5tk39K+AglxliKmzs9wj2zzdT
         ad2qijMLcQXdIaNTFbeiClNXcVSMqopwIZhNq21a4aI+q8seMtL5C6QHMpIQvTa8aMBW
         b7Ox64tRqdndZkt5H/3sfPz4n0vvkR5FTDAIQq4oSGBLDjiQAkItmCIv9bEs0RLyAOSd
         D+Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mouPQRfM19p8vHP5Tnph2d1M9LHaUd098MlUuEprpnc=;
        b=XGzEIr5mcODKQ34j9V6lioeoPwyiMlDcd098EEzROkcZxN+bXsG7EbXOXl7xQxBDJK
         o1xbS+yu1bUQpqOmnzVYM3V8ywn08gQAzbS4F16mRNTgSFmDLtfhlpIXgx6Zk3v3uZT1
         CVhEshnTMd8BS1u+PkFIXqzN0sIX+PRJHq+c5+SKTBKWf7Z9ifCat/Rz5wXmguOyjpDo
         4DdeUBsFnYgXfj+TTD9RbgL8fzwB8cesVL3n5Fqzv9aJQZpQYZDOZ/5iSnbSkurZcN8C
         niR/1lkJ17rhPriyJKzKtrNOJ4pPsCsqz7sADCMUKIfDBGQUbjFimzuuqR2wukbn/+yz
         gSlw==
X-Gm-Message-State: AOAM530SIWEh/iF4HTjGhfxVI79M7ipJxYEog0FCt7thi1p8tzkB9yO/
        /86JMbHGMExY3hAiv1cEhfWGcw==
X-Google-Smtp-Source: ABdhPJzgxU5QGFWnp8OjBEFVXDcYKU5abqSSEDCNINCWf3H2HsqqW9/3GR0XN8d8THK6CFw2InOUBw==
X-Received: by 2002:aa7:818c:0:b029:1e5:ad1f:f219 with SMTP id g12-20020aa7818c0000b02901e5ad1ff219mr18594289pfi.53.1613942574849;
        Sun, 21 Feb 2021 13:22:54 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id z10sm4074409pjq.5.2021.02.21.13.22.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Feb 2021 13:22:54 -0800 (PST)
Subject: Re: [PATCHSET RFC 0/18] Remove kthread usage from io_uring
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <20210219171010.281878-1-axboe@kernel.dk>
 <CAHk-=wgShFTn_BiVqtFrtL6xnJVUFJ5xFgVeWFHYs7P2ak_5zg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <084f0dda-797f-6c24-abe3-15df119e501a@kernel.dk>
Date:   Sun, 21 Feb 2021 14:22:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wgShFTn_BiVqtFrtL6xnJVUFJ5xFgVeWFHYs7P2ak_5zg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/20/21 10:04 PM, Linus Torvalds wrote:
> On Fri, Feb 19, 2021 at 9:10 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> tldr - instead of using kthreads that assume the identity of the original
>> tasks for work that needs offloading to a thread, setup these workers as
>> threads of the original task.
> 
> Ok, from a quick look-through of the patch series this most definitely
> seems to be the right way to go, getting rid of a lot of subtle (and
> not-so-subtle) issues.

Yeah, it's hard to find any downsides to doing this... FWIW, ran it
through prod testing and so far so good. I may actually push this for
5.12-rc1 if things continue looking good. As a separate pull request, so
you can make the call on whether you want it simmering for another
release or not.

-- 
Jens Axboe

