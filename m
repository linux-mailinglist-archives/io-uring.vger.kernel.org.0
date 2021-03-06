Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE53532FDB9
	for <lists+io-uring@lfdr.de>; Sat,  6 Mar 2021 23:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbhCFW30 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 6 Mar 2021 17:29:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbhCFW2s (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 6 Mar 2021 17:28:48 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB206C06174A
        for <io-uring@vger.kernel.org>; Sat,  6 Mar 2021 14:28:48 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id y67so4752494pfb.2
        for <io-uring@vger.kernel.org>; Sat, 06 Mar 2021 14:28:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zCyAmtq8S4Fc2F5Erj+qgOcVPlZpVp/yKPnFRDHqQT0=;
        b=IA8mBXp8xYqgm5xyJl83QURTDu2Jg4RVHt0YGCGr1SqiVKijj263nYNX4stBGIMc+r
         D1BtvLn1w0mKYQ0/xRvYYfLJ5rItb2OG1i7cawjmhrv4rsVx9iHhCyuefrBxUdEahvgm
         M4slDb2NypgcsBCMkzeeR964x8VhzpwzQTRXVW2E4YryQOnyJZ8TE6fisqcNo5ns00vX
         k/0ZAQP34OD/0gatQzm0WErc7/vJCVvsAogPOXqYQznUypwPMrpYhwrNlQGPEGvXgcYG
         yqI3TKT3bCnQXRaQCvRuzBAWoMVVRvFMms5tOM8CrYP+pCtK5yMToTK+c7HhBgA6kubI
         lKaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zCyAmtq8S4Fc2F5Erj+qgOcVPlZpVp/yKPnFRDHqQT0=;
        b=Hp6ABNsidctcXPJK3CUIFaKnP4W6ale09P7ztcRet+dJnivuGnH5EREMlrYb71vOta
         PgrapDmwGdGM9CmUoEwR910lenhv5YpLSelnrYt5D3KsN7cKZ5C9UP0lobOxTT/hzOzW
         b8sVa46f48TrWRFpoJGEb/1VbBPG42Lx5GPdtngz8L8pvIfoT5g8p8IL9XMeewgO0MJV
         m4PsJ5nySeydEQlJfcm+a73wvN4fIymMnfPAqsYUbBqJqDp5FPFf10EnKfOiv4g/gnHA
         XU6aeD0IwHX+9ssmxfOVxbCCA/dhbVKzpInOqi1aUP/AfFkoww/9iIx2GtNnG87UgCFL
         6ZKQ==
X-Gm-Message-State: AOAM531Hn7lGCSOZbUXzIpnANj57/nnuD3ddokgyduzoF22HjqDVINfo
        rp4bsQ91o0oL4SOC+bwJ2TlIxRI9jgesSg==
X-Google-Smtp-Source: ABdhPJwV56OvRfXnOFJ3L1cN8/6vIo6HBDNSIKPzwYA5xPSMe/Th3EbBJBLLfw2y56yOLWeG16GU5Q==
X-Received: by 2002:a63:f921:: with SMTP id h33mr14162553pgi.419.1615069727559;
        Sat, 06 Mar 2021 14:28:47 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id t17sm6098964pjo.0.2021.03.06.14.28.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Mar 2021 14:28:46 -0800 (PST)
Subject: Re: [GIT PULL] io_uring fixes for 5.12-rc2
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <88ef6732-3800-a563-868d-8c1e5545c8fa@kernel.dk>
 <CAHk-=wjAASE-FhpGqrDoa-u5gktgW0=4q2V9+i7B93HTEf3cbg@mail.gmail.com>
 <7018071c-6f63-1e8c-3874-8ad643bad155@kernel.dk>
 <CAHk-=whjh_cow+gCQMCnS0NdxTqumtCgEDth+QLTjpYpOaOETQ@mail.gmail.com>
 <31785b03-93dd-d204-dcf6-dd6b6546cbb6@kernel.dk>
 <CAHk-=wg_D4Mobaj9mff2PEy+Qm67kGTP3kxo2=Aoa_UTc1k-_A@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <affef016-a1ee-d472-77db-057c2b7b93c3@kernel.dk>
Date:   Sat, 6 Mar 2021 15:28:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wg_D4Mobaj9mff2PEy+Qm67kGTP3kxo2=Aoa_UTc1k-_A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/6/21 2:14 PM, Linus Torvalds wrote:
> On Sat, Mar 6, 2021 at 8:25 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> You're not, but creds is just one part of it. But I think we're OK
>> saying "If you do unshare(CLONE_FILES) or CLONE_FS, then it's not
>> going to impact async offload for your io_uring". IOW, you really
>> should do that before setting up your ring(s).
> 
> Yeah, I think that one is solidly in a "don't do that then" thing.
> 
> Changing credentials is "normal use" - if you are a server process,
> you may want to just make sure that you use different credentials for
> different client requests etc.
> 
> But doing something like "I set up an io_uring for async work, and
> then I dis-associated from my existing FS state entirely", that's not
> normal. That's just a "you did something crazy, and you'll get crazy
> results back, because the async part is fundamentally different from
> the synchronous part".

I agree, just wanted to make sure I wasn't the odd one out here...

> It might be an option to just tear down the IO uring state entirely if
> somebody does a "unshare(CLONE_FILES)", the same way unsharing the VM
> (ie execve) does. But then it shouldn't even try to keep the state in
> sync, it would just be "ok, your old io_uring is now simply gone".
> 
> I'm not sure it's even worth worrying about. Because at some point,
> it's just "garbage in, garbage out".

I'd rather not worry about it. It's perfectly legit, and lots of uses
cases do this, to use a ring and never have any work that uses the
io-wq thread helpers. For those cases, there's never any concern
with having moved to a different fs or files. So I'd rather just
put that one in the category of "don't do weird stuff, or you'll
get unexpected results".

-- 
Jens Axboe

