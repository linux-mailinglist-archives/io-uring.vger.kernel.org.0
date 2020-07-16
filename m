Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1E9222CDF
	for <lists+io-uring@lfdr.de>; Thu, 16 Jul 2020 22:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgGPUbp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jul 2020 16:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbgGPUbp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jul 2020 16:31:45 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA5C0C061755
        for <io-uring@vger.kernel.org>; Thu, 16 Jul 2020 13:31:44 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id x9so6266601ila.3
        for <io-uring@vger.kernel.org>; Thu, 16 Jul 2020 13:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=erNl6hZDsGZx08fj3dVbVXSdNWT1MhkTq2CGdMmto4w=;
        b=bs/S3dI+wluetM4515KeV7CD9/piU8DXGOprnDLa+3bmzfW9Fj7EDZvVgMfpATZMww
         xs4KrvZiJtwfvdVVC+yVU1uL+QnYcLAn1HG2sXeJpWanydRcnQ3m9Jw5KfDBSxtQcUT5
         RQPcfiwdA/wXvg7FbCCJqSA23fOLIA5iAVM8jd0wNlKdWu4hW83WXJwCYDq/8rpdeAxo
         NVBphRic95oA4KtsPBraI9Cap9lWy1/PL9X8dMA5rOFDIU/q7iGmW+sBKUkx3VTA1igU
         kopf4NswyBF3oL7pNAMYnSdDp6JUnwp7ItY7R1is6YiJlc8lk5WaWepggtK0/IfbmINm
         eSZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=erNl6hZDsGZx08fj3dVbVXSdNWT1MhkTq2CGdMmto4w=;
        b=YJUAu0roIxeyCMKMnrzELgIDhLfx+3mUi/FQoLfgY8gqlXim+V5hCqNwrHCjIyyHJK
         r1hs3sbhuPM/pm/VN9VHInK1r0UH/hmn4mDK0ynKM+UV+yNF3WlcGMkZCurd6UibM6zn
         xSrSkF8WGqJ7ssQjaVGXi356sLJ6AhL6BJ9r/bmN99XkAuKGji4LWL6JxvLjkPrf2A5a
         ii6u4mDG7irphdVgYJljEEKrbrK7DDYjueHkA4R4MLjUeCZJGfSFCXtYXePA7kbws8fU
         4ytgdM9F+ZyEFP8fGoFIr2/VjcBBq0xXh9ze+y9wk8mSsOYCLgqo/8PQV7YeFTpCbb0v
         yc2Q==
X-Gm-Message-State: AOAM531UeI8E+KqUPdY7cfx2TIh5SrcP207J7kcTdM37YBekKvebo6N9
        022oa3yMFLX8B8QUBDNtln4pyChNECk1tQ==
X-Google-Smtp-Source: ABdhPJxPeXMbTQYTZdgrQBiE4chULZHCFEWtQECQWnz+ftsJ45fGbJsiVwcMdPdeQBz48ix9nFvteA==
X-Received: by 2002:a92:9f06:: with SMTP id u6mr6398955ili.29.1594931503887;
        Thu, 16 Jul 2020 13:31:43 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id e16sm3525135iow.37.2020.07.16.13.31.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2020 13:31:43 -0700 (PDT)
Subject: Re: io_uring_setup spuriously returning ENOMEM for one user
To:     Andres Freund <andres@anarazel.de>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <20200716200543.iyrurpmcvrycekom@alap3.anarazel.de>
 <af57a2d2-86d2-96f7-5f63-19b02d800e71@gmail.com>
 <20200716202002.ccuidrqbknvzhxiv@alap3.anarazel.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1ed06f59-5289-3caf-3b74-9ef216ac1b88@kernel.dk>
Date:   Thu, 16 Jul 2020 14:31:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200716202002.ccuidrqbknvzhxiv@alap3.anarazel.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/16/20 2:20 PM, Andres Freund wrote:
> Hi,
> 
> On 2020-07-16 23:12:41 +0300, Pavel Begunkov wrote:
>> On 16/07/2020 23:05, Andres Freund wrote:
>>> Hi,
>>>
>>> While testing the error handling of my uring using postgres branch I
>>> just encountered the situation that io_uring_setup() always fails with
>>> ENOMEN.
>>>
>>> It only does so for the user I did the testing on and not for other
>>> users. During the testing a few io_uring using processes were kill -9'd
>>> and a few core-dumped after abort(). No io_uring using processes are
>>> still alive.
>>>
>>> As the issue only happens to the one uid I suspect that
>>> current_user()->locked_mem got corrupted, perhaps after hitting the
>>> limit for real.
>>
>> Any chance it's using SQPOLL mode?
> 
> No. It's a "plain" uring. The only thing that could be considered
> special is that one of the rings is shared between processes (which all
> run as the same user).

Do you have this one:

ommit 309fc03a3284af62eb6082fb60327045a1dabf57 (tag: io_uring-5.8-2020-07-10)
Author: Jens Axboe <axboe@kernel.dk>
Date:   Fri Jul 10 09:13:34 2020 -0600

    io_uring: account user memory freed when exit has been queued

-- 
Jens Axboe

