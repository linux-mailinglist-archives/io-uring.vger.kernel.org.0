Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A1C32F5A0
	for <lists+io-uring@lfdr.de>; Fri,  5 Mar 2021 22:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbhCEV67 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Mar 2021 16:58:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbhCEV6g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Mar 2021 16:58:36 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF80C06175F
        for <io-uring@vger.kernel.org>; Fri,  5 Mar 2021 13:58:34 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id a13so4195946oid.0
        for <io-uring@vger.kernel.org>; Fri, 05 Mar 2021 13:58:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5VazXI00bF5c+J+wMiwuu3xgTzYkXZmsmioyHbQWS1U=;
        b=QgXYEls0R76KlziFTFsVJzJBPeBJWwiWDshmUKDgIJHdpU00g6ZhWdDaE96M4polph
         22vXvgd3NBtpgKmULj/SlcAPFs2J9QUx2sLOCTlkohhSGyMhqwOYGoFNCOlE7ID5kEbr
         2T9VFG5SJTldRYLkVWzH8/F9IFArOGFFGcZnE6CJub9NLo2yDa4bWUkvCtgyHYlJarbj
         8YvOwXCuDm9jqIlLOMFb1RokD3S9TTgHteCP/St2ooToGVRmp7kq84QDSkMCNorPB0eH
         vXcbi8qesEQxr/bImDJTBNsYxBHizmbZHMx3IaVoYguy0Lohikju/JCJseYkMF2rpVQD
         JUfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5VazXI00bF5c+J+wMiwuu3xgTzYkXZmsmioyHbQWS1U=;
        b=NCGzzuiRtT8tTnigKtM/xLKXHHJHvCiuUm8TUs//l8VSUnpIQiED0zp2zgisCDTBT2
         E3C0S3Hers2+1YF8/xYJEPub7WckNqo3iqxXsDdxMuyUTYylqUKhlBXEPYgm+EtqU/vy
         1PWjh2vyXZuCCRlvIXgGokB96DHqhGR/Hs3PBcp/8kKRKD6KDwzZea8uk4wShyYSyLbH
         Ec9tXQvXCldKK7psBdfH85UhgiPGZb6NQQZvjruWMZF0QCOJtSIoF2r8fgIZMKZ/idKz
         Sa5knQVg/2+YP2ZxGEVxCsQ8FXO4G8T2+ZESYOZXtaDcJPYMA66GMGUtlj0MokP4PgXo
         GSLg==
X-Gm-Message-State: AOAM5327Tel0dh+bddojINnnGwDf8r0Kh9K30kVNYV9KYoOcyjwF9UcH
        FXaEVnCkTSMUZEQngS/T/hx12VUfpwgGTA==
X-Google-Smtp-Source: ABdhPJzlulbbPUnMV5x/J2oB7BK9gNNFsiOTz2ZzE8izaT+8kcaVM+oyLGLpHiwc59aEd7R4cVwjHQ==
X-Received: by 2002:aca:3dd7:: with SMTP id k206mr8641590oia.10.1614981513482;
        Fri, 05 Mar 2021 13:58:33 -0800 (PST)
Received: from [192.168.1.30] ([207.135.233.147])
        by smtp.gmail.com with ESMTPSA id f29sm817520ook.7.2021.03.05.13.58.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Mar 2021 13:58:33 -0800 (PST)
Subject: Re: [GIT PULL] io_uring fixes for 5.12-rc2
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <88ef6732-3800-a563-868d-8c1e5545c8fa@kernel.dk>
 <CAHk-=wjAASE-FhpGqrDoa-u5gktgW0=4q2V9+i7B93HTEf3cbg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7018071c-6f63-1e8c-3874-8ad643bad155@kernel.dk>
Date:   Fri, 5 Mar 2021 14:58:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wjAASE-FhpGqrDoa-u5gktgW0=4q2V9+i7B93HTEf3cbg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/5/21 1:54 PM, Linus Torvalds wrote:
> On Fri, Mar 5, 2021 at 10:09 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> - Implement unshare. Used for when the original task does unshare(2) or
>>   setuid/seteuid and friends, drops the original workers and forks new
>>   ones.
> 
> This explanation makes no sense to me, and I don't see any commit that
> would remotely do what I parse that as doing.

Hah, good catch... I actually wrote this up as I sent out the series for
reviews the other day, and I dropped the unshare bit as it was
contentious and I think there are better ways to do it. But I obviously
forgot to drop it from the commit message.

But since I have you here, would love to hear your thoughts. For the
setuid/seteuid, io_uring actually has a mechanism for this already, so I
don't believe we _need_ to do anything. You can register creds and use a
specific one for requests, this is what samba does for example.

But it pertains to the problem in general, which is how do we handle
when the original task sets up a ring and then goes and does
unshare(FILES) or whatever. It then submits a new request that just
happens to go async, which is oblivious to this fact. Same thing that
would happen in userspace if you created a thread pool and then did
unshare, and then had your existing threads handle work for you. Except
here it just kind of happens implicitly, and I can see how that would be
confusing or even problematic.

The patch mentioned above basically just did a cancel across that, like
we do for exec. If you go async after that, you get a new manager then
new threads, which takes care of it. But it's also very brutal and not
necessarily all that useful for the application.

-- 
Jens Axboe

