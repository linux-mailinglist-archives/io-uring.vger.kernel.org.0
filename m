Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B59F7337CE3
	for <lists+io-uring@lfdr.de>; Thu, 11 Mar 2021 19:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbhCKSrO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Mar 2021 13:47:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbhCKSqt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Mar 2021 13:46:49 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97254C061574
        for <io-uring@vger.kernel.org>; Thu, 11 Mar 2021 10:46:49 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id p10so240163ils.9
        for <io-uring@vger.kernel.org>; Thu, 11 Mar 2021 10:46:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=P+SMdHkWjNske5F9ITT8zL7uXv1IJqgB3DJOVsHPtL8=;
        b=VQmM9b2YT0YbNw8vrHICogVsuuKiVYoWx6rfeosh0ECY78oSRy+DRBCGWRdRAiPF+n
         zHU1iOmcxLyatk20Xr3TeLeZ1eZEbLGLWndCg07zIJ7RRR5cbFmUOqRAVwnGRmXHkrTC
         hxjgyJn9x2ZsM20DNeF859J2lnz6IQWm1mw0c2V6fENjjiAHrJJi3i3WjQcrmGVS7qfT
         aWYm9YF8vK1TEBhay8lFQkZhr1Yu+fz2ReTcL5uyOVm1Pte2JtMtyTpzgAB/OvZ58xT/
         Ox/YOOWMSHc4pMD5TFWqEPX/pkpx8eJdGPB0pFoxXRBVRBaFHOd/Wk01j6wtHeG2mpNH
         Aknw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P+SMdHkWjNske5F9ITT8zL7uXv1IJqgB3DJOVsHPtL8=;
        b=M9OwA8uk82w7OPOoCMlbJIGAOugHA+y15H6WFmLhvwPk+zTkTcI1N1shDDAdD39Wc+
         c+B796gO3aGkA6CSQHIQAMNxfzU6NvJ/Lu4/W4ydzK0oVGLXNU0Js0D7uyfyI1MSRErz
         1aOm8QnroatZngDYKkQCHrduqWFr44yYsyzXZUBsKTOJYl4oBnTQlOcpGtjkZJ5mOrhx
         Tku8a4c6vS7R0cL4jX2dpBdTQ3rcMzqzosxntp1Rs06fDqMaFGQSI+KlNgPQOS2Ppq51
         5JxPs9ZBwuoIg+TY7/7xNtNX5iMxGXuDRm7OL9e1o+rpi07KXi6OObqwLxSm4lrIeQtV
         dMaQ==
X-Gm-Message-State: AOAM533dFXXFsusN9CjxfPwxJN1V9EF2nPR3qie0C9FLqUUXupK1yE2p
        JmHT07g9Q1YJ3P/FK+Pr7fyyCzk92fcRGQ==
X-Google-Smtp-Source: ABdhPJzsMiSn9hDO3lHG6cLLos+RzezamQRoeQT7fUtY70OoH1OkWkQUrlamKBFCmZETR1nibJWZZQ==
X-Received: by 2002:a92:c641:: with SMTP id 1mr8396927ill.94.1615488408809;
        Thu, 11 Mar 2021 10:46:48 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id g11sm1701772iom.23.2021.03.11.10.46.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 10:46:48 -0800 (PST)
Subject: Re: Backporting to stable... Re: [GIT PULL] io_uring thread worker
 change
To:     Stefan Metzmacher <metze@samba.org>, torvalds@linux-foundation.org
Cc:     io-uring@vger.kernel.org
References: <0c142458-9473-9df3-535f-34c06957d464@kernel.dk>
 <adb0cce8-0533-b7b0-d12c-9beb9e28f81a@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <78f5accb-1b4a-6a30-fa1b-a675c8aec469@kernel.dk>
Date:   Thu, 11 Mar 2021 11:46:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <adb0cce8-0533-b7b0-d12c-9beb9e28f81a@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/11/21 3:43 AM, Stefan Metzmacher wrote:
> Hi Jens,
> 
>> I'm sure we're going to find little things to patch up after this
>> series, but testing has been pretty thorough, from the usual regression
>> suite to production. Any issue that may crop up should be manageable.
>> There's also a nice series of further reductions we can do on top of
>> this, but I wanted to get the meat of it out sooner rather than later.
>> The general worry here isn't that it's fundamentally broken. Most of the
>> little issues we've found over the last week have been related to just
>> changes in how thread startup/exit is done, since that's the main
>> difference between using kthreads and these kinds of threads. In fact,
>> if all goes according to plan, I want to get this into the 5.10 and 5.11
>> stable branches as well.
> 
> That would mean that IORING_FEAT_SQPOLL_NONFIXED would be implicitly
> be backported from 5.11 to 5.10, correct?

Right, that would happen by default if we moved the new worker code back
to 5.10 and 5.11.

> I'm wondering if I can advice people to move to 5.10 (as it's an lts
> release) in order to get a kernel that is most likely very useful to
> use in combination with Samba's drafted usage of io_uring, where I'd
> like to use IORING_FEAT_SQPOLL_NONFIXED and IORING_FEAT_NATIVE_WORKERS
> in order to use SENDMSG/RECVMSG with msg_control buffers (where the
> control buffers may reference file descriptors).

Understandable! It's worth nothing that 5.10 would also need a backport
of the TIF_NOTIFY_SIGNAL change - could be done without, but then we'd
have diverging code bases to some degree, which would be something I'd
love to avoid.

-- 
Jens Axboe

