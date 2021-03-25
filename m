Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2F7C349391
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 15:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbhCYODG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 10:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbhCYOCr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 10:02:47 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DBE5C06174A
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 07:02:47 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id 19so2226356ilj.2
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 07:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uui5a2oxxV+bwHUJbRgbxWLfj5T7kr4j6jjOle6T7XI=;
        b=0TgDRLwmC8HDiV152IBCAqqdrtE24Y390ZTej2c2FnMRvBN7kPv3vMiIiSrNk8raxR
         Mna00pxYW2dtR/m18RR+u5h53l0uVLQlCZ3s2/Gj42lmOuQvwC4ujSwk6/xRWeQRKJ54
         bWbQBwt5HP/iR/VHNRQ8zcKsVDrvc1EVHgJzO053zodZtJ0B6/JH/9wXQZCIqawTHAhv
         f3kuyjKXWCqx7ol4c9w5/QTp4fQ3U2Fkc+G5/9IZguQZdv2aPFlUXKUozX9Wyp+AJLM+
         JfHn4XK5+d7awchuNTF/RL66kajhe15tIBtZCCvfOHvHzxHFVRqthl4LOMAKEMTrSmXl
         nySg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uui5a2oxxV+bwHUJbRgbxWLfj5T7kr4j6jjOle6T7XI=;
        b=fzCf7PA2Zyi9ZuwPVsV1YJuqjAV8KRtwhd7ysy/Hn6ClIINMjaUS8ABEuYStMeAXlv
         oWWyKAwuwwVWISdyyo+VsWZnVrVbVcZpQb+14UhBod9RtcK+9zApccAnuCUiclbvw1Db
         M1VapzFrRfLnkx8APj+VMduLa8VEsY17vrS1jMMfYbNbBtmUkF0+28355VCkk0WlWZAv
         WXG/LOnSoWQORBXrAyD1dxXbBATtOBEj+4YTS6N3dYcvq4x+A5M3b+Qr6Xrn29Lm7Za/
         t0yyZHbcP1WwoMbZM1q2BmTBFK0liIM1kozFj9ZWhLtPVILRPnOwMaReRmfcQPlUti4Y
         LigQ==
X-Gm-Message-State: AOAM530+n58LVjD06h6jvoyFehYdmC5KSE36Crk3zJ9cBYyEI8rtxt7M
        squY8+sxd6cNWydkfEBZwxLt/Q==
X-Google-Smtp-Source: ABdhPJxCmDscdqVLvLkVFtL37YbSiDv5nqipeM0bcr1okBhaoiMKNf3oPkrX4smPjOLRnP/ZORZJZA==
X-Received: by 2002:a05:6e02:d53:: with SMTP id h19mr6871217ilj.157.1616680966589;
        Thu, 25 Mar 2021 07:02:46 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o15sm2799441ils.87.2021.03.25.07.02.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Mar 2021 07:02:46 -0700 (PDT)
Subject: Re: Are CAP_SYS_ADMIN and CAP_SYS_NICE still needed for SQPOLL?
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210325113322.ecnji3xejozqdpwt@steredhat>
 <842e6993-8cde-bc00-4de1-7b8689a397a8@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <46016d10-7b87-c0f6-ed0f-18f89a2572d0@kernel.dk>
Date:   Thu, 25 Mar 2021 08:02:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <842e6993-8cde-bc00-4de1-7b8689a397a8@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/25/21 7:44 AM, Pavel Begunkov wrote:
> On 25/03/2021 11:33, Stefano Garzarella wrote:
>> Hi Jens, Hi Pavel,
>> I was taking a look at the new SQPOLL handling with io_thread instead of kthread. Great job! Really nice feature that maybe can be reused also in other scenarios (e.g. vhost).
>>
>> Regarding SQPOLL, IIUC these new threads are much closer to user threads, so is there still a need to require CAP_SYS_ADMIN and CAP_SYS_NICE to enable SQPOLL?
> 
> Hmm, good question. If there are under same cgroup (should be in
> theory), and if we add more scheduling points (i.e. need_resched()), and
> don't see a reason why not. Jens?
> 
> Better not right away though. IMHO it's safer to let the change settle
> down for some time.

Yes, agree on both counts - we are not going to need elevated privileges
going forward, but I'd also rather defer making that change until 5.13
so we have a bit more time on the current (new) base first.

-- 
Jens Axboe

