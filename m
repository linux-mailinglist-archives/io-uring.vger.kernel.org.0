Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 304AB2DF1E4
	for <lists+io-uring@lfdr.de>; Sat, 19 Dec 2020 22:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgLSVzO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 19 Dec 2020 16:55:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgLSVzN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 19 Dec 2020 16:55:13 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BE5C0613CF
        for <io-uring@vger.kernel.org>; Sat, 19 Dec 2020 13:54:26 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id 15so3659818pgx.7
        for <io-uring@vger.kernel.org>; Sat, 19 Dec 2020 13:54:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JduuHvufwsJPpxPvxDBxonFgau3CbRfkXZVEmDVWGmc=;
        b=dylsBhRb4XFbrc5Ygn6EkhrOBJ0WLJMRiu6qq3lcuPVF4u0BZVPeDSb6QXte+Bzob6
         zV4MzTImrF4rH4ZrLHE7eHAN3ZLhU0TItYeVTtu6WEMZwUOQDoFdl9UkBH7B3c+8jTjs
         4XvfrpwWT7Opcrfp2gym1qpvLLfDCWCePBBkgtq9k7jAUWjRWE85Yj5GnOtY3NU+3LCL
         BQPbGasRRnemTkgPYUoH2tiz1mt/0NemmMAsLtrcs6czenJSBXheFGKxp1GdzaRM86mS
         /URkjoU1X7zw31LOFA8otRTpucSxksnKB9C0qvnI1FvXgPP01EwlgJeJnPiyl+w8r/jn
         JFew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JduuHvufwsJPpxPvxDBxonFgau3CbRfkXZVEmDVWGmc=;
        b=V1LKsofchif6BeaJihlHX7BMdmoaPHGroMRknPMWg0c+gYCEp/jXOPwRISgsygFBAD
         3RwT4KxuAhDcHrqUbRddkk3P92B6M8xmjRp4uioiYaN9YPlBz0oUysuo+8TBWIV3CNKk
         2fXeyEoT0HhU9d0GEr2rtnQ4mHLMroIzOAB2BGo59CYvvLgOJ3q0RdEW4GM5nqoTGO+Y
         j2W8UaoOj79YA0Tv2pWqqd6wgvThx2++FqxXHqt/59FcVw5qNeUEB3rnM5/GiqE6A15U
         y34SHIHURX8KTPhAOgMob3b3q+LyK6xI9W/Xaimcsbu0Co3NHySrgRmmtbyde/WQrfUC
         D1Dg==
X-Gm-Message-State: AOAM531PmCokPPGk9TBOm/Fb91fPOu3vjOOU8A7DViMrd/rwuRrnSwTU
        N84YpUmYr8bqkaxh0uScjVqDSTg0umIEbg==
X-Google-Smtp-Source: ABdhPJwFgWgtNrTwdBgyWq2EbZlIPEcZIWYWmmKYkHRMvhPeQQSCaj7nsQPs0gB9hcJFn0YPelFAjA==
X-Received: by 2002:a63:1805:: with SMTP id y5mr9538663pgl.27.1608414866087;
        Sat, 19 Dec 2020 13:54:26 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id z5sm12219753pff.44.2020.12.19.13.54.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Dec 2020 13:54:25 -0800 (PST)
Subject: Re: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
To:     Josef <josef.grieb@gmail.com>
Cc:     Norman Maurer <norman.maurer@googlemail.com>,
        Dmitry Kadashev <dkadashev@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <4dc9c74b-249d-117c-debf-4bb9e0df2988@kernel.dk>
 <2B352D6C-4CA2-4B09-8751-D7BB8159072D@googlemail.com>
 <d9205a43-ebd7-9412-afc6-71fdcf517a32@kernel.dk>
 <CAAss7+ps4xC785yMjXC6u8NiH9PCCQQoPiH+AhZT7nMX7Q_uEw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0fe708e2-086b-94a8-def4-e4ebd6e0b709@kernel.dk>
Date:   Sat, 19 Dec 2020 14:54:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAAss7+ps4xC785yMjXC6u8NiH9PCCQQoPiH+AhZT7nMX7Q_uEw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/19/20 1:51 PM, Josef wrote:
>> And even more so, it's IOSQE_ASYNC on the IORING_OP_READ on an eventfd
>> file descriptor. You probably don't want/mean to do that as it's
>> pollable, I guess it's done because you just set it on all reads for the
>> test?
> 
> yes exactly, eventfd fd is blocking, so it actually makes no sense to
> use IOSQE_ASYNC

Right, and it's pollable too.

> I just tested eventfd without the IOSQE_ASYNC flag, it seems to work
> in my tests, thanks a lot :)
> 
>> In any case, it should of course work. This is the leftover trace when
>> we should be exiting, but an io-wq worker is still trying to get data
>> from the eventfd:
> 
> interesting, btw what kind of tool do you use for kernel debugging?

Just poking at it and thinking about it, no hidden magic I'm afraid...

-- 
Jens Axboe

