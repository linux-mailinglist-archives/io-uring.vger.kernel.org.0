Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFB43D414B
	for <lists+io-uring@lfdr.de>; Fri, 23 Jul 2021 22:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbhGWTaK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jul 2021 15:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbhGWTaK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jul 2021 15:30:10 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C69C061575
        for <io-uring@vger.kernel.org>; Fri, 23 Jul 2021 13:10:43 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id f1so4407257plt.7
        for <io-uring@vger.kernel.org>; Fri, 23 Jul 2021 13:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6j3jQyhScfoP16cST3l8x4oQrf6kP/yRdLm1yZkDhM4=;
        b=gwp+CmqQ+wjzFbfP/GzmwyfcAn8o7oWp6CjK5oyBcrVFIXidHz6N5nH69hJlYcJlk3
         nrbokqlnacoVgGAXa4UqxYUv1RC5t5ttMYY4A1+zblmv4vrlaej5v/TUu2SXw46Lj34l
         aC7BWUu+mdeHMhZjIFIKKsAfyhIg8ehDnFDxNY9rmD0O8CMBEQyTavBLNwkbUi+EDNgv
         DP3ObdeyxU6gO58Ms2tXTUNNk7l4qNMnW2DvOIe5rXOwCpEXwO+0XkVrUhpKX+S/hm8j
         XAJ4ee3RhP9NdA5cOdDBfsE2deunUENhm7A2TSJ1PPSBl/vDhkZZ9BCiGSZoRA14x7jt
         pL7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6j3jQyhScfoP16cST3l8x4oQrf6kP/yRdLm1yZkDhM4=;
        b=gQyQ6mb2N54JB+7rMquIZip+pGnyB0vqBwH7hT9/GyAjPwM2YMRZIXCCJKwwytu3Id
         4+hKgKW5aHmH7VpXGeBn/Xi6lWLokI8fVtJWTQT1RWuy1b4Y+5HvECOn1A4+a6xumGJn
         8UNFp2qRaMwO3rmKrxDCRwji06RbSOy/5pzP9RLHtxkhPuuWWJBCpOg0Kw9Ui9QoZ6B5
         O74/wU4V9Mx43l/+2OCvh0HK9FBhN1Q4SuA7nWqrnGwwMeki8+Fefg4w+mLys6L5RajD
         NnzxtkPLNjI3/PmwPx7wiDVNiQjWfDU8MOFqSXYmMis8lFYSZ1LKsWkNFfoK/lHX+tnO
         F4Ag==
X-Gm-Message-State: AOAM531/aX14QjYALC9KSL0N1+5Zh2fbHdHGeBhDkqPUE53VcxDoAIPQ
        +05puVssyOuDDMs1T1Y1n/s9TYcO64HBhRYF
X-Google-Smtp-Source: ABdhPJxWDPhO0SgOSdWH2ix+jdwxw/0cuL5zySQ4AF3IZtWR6juc/q9w6Bli4YRy7SVHO4Bwu1g1dw==
X-Received: by 2002:a17:90b:209:: with SMTP id fy9mr5856453pjb.187.1627071042551;
        Fri, 23 Jul 2021 13:10:42 -0700 (PDT)
Received: from [192.168.1.187] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id m2sm15360492pja.52.2021.07.23.13.10.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jul 2021 13:10:41 -0700 (PDT)
Subject: Re: [PATCH 3/3] io_uring: refactor io_sq_offload_create()
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <YPnqM0fY3nM5RdRI@zeniv-ca.linux.org.uk>
 <57758edf-d064-d37e-e544-e0c72299823d@kernel.dk>
 <YPn/m56w86xAlbIm@zeniv-ca.linux.org.uk>
 <a85df247-137f-721c-6056-a5c340eed90e@kernel.dk>
 <YPoI+GYrgZgWN/dW@zeniv-ca.linux.org.uk>
 <8fb39022-ba21-2c1f-3df5-29be002014d8@kernel.dk>
 <YPr4OaHv0iv0KTOc@zeniv-ca.linux.org.uk>
 <c09589ed-4ae9-c3c5-ec91-ba28b8f01424@kernel.dk>
 <591b4a1e-606a-898c-7470-b5a1be621047@kernel.dk>
 <640bdb4e-f4d9-a5b8-5b7f-5265b39c8044@kernel.dk>
 <YPsR2FgShiiYA2do@zeniv-ca.linux.org.uk>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3f557a2b-e83c-69e6-b953-06d0b05512ae@kernel.dk>
Date:   Fri, 23 Jul 2021 14:10:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YPsR2FgShiiYA2do@zeniv-ca.linux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/23/21 1:00 PM, Al Viro wrote:
> On Fri, Jul 23, 2021 at 11:56:29AM -0600, Jens Axboe wrote:
> 
>> Will send out two patches for this. Note that I don't see this being a
>> real issue, as we explicitly gave the ring fd to another task, and being
>> that this is purely for read/write, it would result in -EFAULT anyway.
> 
> You do realize that ->release() might come from seriously unexpected
> places, right?  E.g. recvmsg() by something that doesn't expect
> SCM_RIGHTS attached to it will end up with all struct file references
> stashed into the sucker dropped, and if by that time that's the last
> reference - welcome to ->release() run as soon as recepient hits
> task_work_run().
> 
> What's more, if you stash that into garbage for unix_gc() to pick,
> *any* process closing an AF_UNIX socket might end up running your
> ->release().
> 
> So you really do *not* want to spawn any threads there, let alone
> possibly exfiltrating memory contents of happy recepient of your
> present...

Yes I know, and the iopoll was the exception - we don't do anything but
cancel off release otherwise.

-- 
Jens Axboe

