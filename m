Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCDB1E334E
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2020 00:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403828AbgEZW70 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 May 2020 18:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389565AbgEZW70 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 May 2020 18:59:26 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12FFCC061A0F
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 15:59:26 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id b190so10860156pfg.6
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 15:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NWH/bYqwmqs2OKbBy83G8CUstIAX/R+sCpdXcKp8K2o=;
        b=cISz+/DWehlz2iX68EEktvjQKyMzxosnFgNyMsQTZvJtexDiIxxRm5AqLb/3aDBRyj
         ENAhxzd2xY+ls+vwxqDYS49yTIOQy0ruH1IPMnh7RCLm/yH9aAVb5xDYMzTUg/IosPcX
         bKESdPnuGljJXpgGFkM9kctP9fJmGP9/dVMT+vnhCsSBYokWt2jEnmecGhK2hNRd5Y+p
         aUYKSXoSbkimzbAa/R7HaAknaDtC8eEfkSKL7avoMjezZxwiC3rbOS/ZENIp5WJW6+QC
         Y7Jt4xvUlPJ27PLQlnSevk+zjz3AOnAOkFhm9EmrFed7NNjwNzBFtLB4O20i+w6P1eEb
         uSRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NWH/bYqwmqs2OKbBy83G8CUstIAX/R+sCpdXcKp8K2o=;
        b=aHJUpIbCU2+7tcI2y+atfoWQwmHu7vbORJPncDfCl6vsFEN+R12V8AZQDbG2ESK217
         4CaJdOC9Dl81zrXx3prgquG6d1BaA8fLTimqWCZ2VHVrxF9YXay+yObGp4oZHljcQkgU
         Q7Y5vCaFfhs/XPibqwAqpV6ajggBI1rRbTNCiSZhcfnXF9oE5CeluNJW4HV9BvRfDWy8
         UdNMmXCBIwj1BNhB6cgEHXsVmWkwFyUazZ70YGFSaOCpkHEbeq1I0pfcNVT8KC5dTaqO
         GKZY2+6PjFlmGzICJ9sKfhDQA0IUdm2+50MoCNCEK/wirlYTuw8oKJ3HpMdjS6s2uT7X
         D1TQ==
X-Gm-Message-State: AOAM530/+ywtpYnhvM1WvMhc/RcrfCbQPBwai8epk0xrjnt2suY58cYJ
        kca8XNPftiMOxFf1bx9pZ9cww2IOiGDGIg==
X-Google-Smtp-Source: ABdhPJzFsoQO+WEvhxoeRSrqfrVCjOQJ/jFYdJ3sNTz59v4UKzTXrj9/1mNYUg6BZb66/muzN0wrWg==
X-Received: by 2002:a63:1066:: with SMTP id 38mr1087573pgq.207.1590533965315;
        Tue, 26 May 2020 15:59:25 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:4922:2226:8cd7:a61e? ([2605:e000:100e:8c61:4922:2226:8cd7:a61e])
        by smtp.gmail.com with ESMTPSA id h4sm489517pfo.3.2020.05.26.15.59.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 15:59:24 -0700 (PDT)
Subject: Re: [PATCH v2 0/4] io_uring: call statx directly
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <1590208279-33811-1-git-send-email-bijan.mottahedeh@oracle.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f00063b9-7926-9739-f599-603cdf052161@kernel.dk>
Date:   Tue, 26 May 2020 16:59:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1590208279-33811-1-git-send-email-bijan.mottahedeh@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/22/20 10:31 PM, Bijan Mottahedeh wrote:
> v1 -> v2
> 
> - Separate statx and open in io_kiocb 
> - Remove external declarations for unused statx interfaces
> 
> This patch set is a fix for the liburing statx test failure.
> 
> The test fails with a "Miscompare between io_uring and statx" error
> because the statx system call path has additional processing in vfs_statx():
> 
>         stat->result_mask |= STATX_MNT_ID;
>         if (path.mnt->mnt_root == path.dentry)
>                 stat->attributes |= STATX_ATTR_MOUNT_ROOT;
>         stat->attributes_mask |= STATX_ATTR_MOUNT_ROOT;
> 
> which then results in different result_mask values.
> 
> Allowing the system call to be invoked directly simplifies the io_uring
> interface and avoids potential future incompatibilities.  I'm not sure
> if there was other reasoning fort not doing so initially.
> 
> One issue I cannot account for is the difference in "used" memory reported
> by free(1) after running the statx a large (10000) number of times.
> 
> The difference is significant ~100k and doesn't really change after
> dropping caches.
> 
> I enabled memory leak detection and couldn't see anything related to the test.
> 
> Bijan Mottahedeh (4):
>   io_uring: add io_statx structure
>   statx: allow system call to be invoked from io_uring
>   io_uring: call statx directly
>   statx: hide interfaces no longer used by io_uring
> 
>  fs/internal.h |  4 ++--
>  fs/io_uring.c | 72 +++++++++++++++--------------------------------------------
>  fs/stat.c     | 37 +++++++++++++++++-------------
>  3 files changed, 42 insertions(+), 71 deletions(-)

Thanks, this looks better. For a bit of history, the initial attempt was
to do the statx without async offload if we could do so without blocking.
Without that, we may as well simplify it.

-- 
Jens Axboe

