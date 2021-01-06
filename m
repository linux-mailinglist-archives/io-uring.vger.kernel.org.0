Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8AE52EC352
	for <lists+io-uring@lfdr.de>; Wed,  6 Jan 2021 19:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725890AbhAFSlb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Jan 2021 13:41:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbhAFSlb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Jan 2021 13:41:31 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2469AC061357
        for <io-uring@vger.kernel.org>; Wed,  6 Jan 2021 10:40:51 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id o6so3624466iob.10
        for <io-uring@vger.kernel.org>; Wed, 06 Jan 2021 10:40:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=KZXmFaGJjRbITKxUn90tKihenoPGIZf2v+/o+706vpU=;
        b=oIrW+lcHK10l0jNBJS6PtnPczl6QvIyiP/CIpbP/FeLqo7NrL0iAiN/Bf/f65SNvei
         NM93WjHETUs3zKj7LBNUpIpYrO4Zw7HvmdSE/cHo5iPzsjHYJHuoxyWDFbl3DU+DuSHO
         a9K4GdCzrfNXXlwq6cFLyIuiLb1YEX1AnUJd9YROc8Viyd+lWaPT3FmlXvaF/+JS4cqM
         xnkVvDPizAsJjtTEgiAez53mkF3X5+51/5HhLCLqDhcSkmFqfQKd87xvOoIWBa/wE49I
         jcnscn9fBwkQeQwC9oKfW6UGdOQkFNYPd5SO1YViCdEgYwsNfFBPvW2uBLBqriu9rmw0
         cQVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KZXmFaGJjRbITKxUn90tKihenoPGIZf2v+/o+706vpU=;
        b=ZVlDyiLAQ5ILbW8XRhlng7krHBb3ig1Ruru/vEQN7gytC0LHzxVYdMXSLHR6qFYjnb
         HStZPanc4+zd9SdLRyU8XOjXczPSjaVaKAymsxEXDmjCi1Fgnk3Z1uX7sTJ6zIHe17i3
         qkxIopKKeLzqcBdX0R7o1YsdyjtJhIpGEaQbmWnfn9L4zuquPhN4+JYjxKiC9wSWLPSn
         p2sLADJ1oUjjubV+F5IBp+Z5o5Gqlc+D2AWkwCJswi6MJTem5P6czHKeopWMezBdQj3y
         iN6bU1vT+wk8rqTOS0vkzXb+FTYtBVtdBH7zAR47S5OhTWQ1V/p4IQjANsw1lnPW1Gk3
         z8DQ==
X-Gm-Message-State: AOAM533H5KsIvgH5b4WYczBH5O3HztCYQxf/YgomgmL0uMfevAfkDjRp
        ggPtMgAurFyvuGMdAHmOBu8wXEmpkXbUcA==
X-Google-Smtp-Source: ABdhPJx41Edv6g9/vOlFnRY6Eh8DW2P5pbmDeIj8i0q5VRa0EriM2K04F/TjEuR7hVAM3TfFclVzXw==
X-Received: by 2002:a02:b02:: with SMTP id 2mr4800100jad.15.1609958450276;
        Wed, 06 Jan 2021 10:40:50 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o62sm1805264iof.5.2021.01.06.10.40.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 10:40:49 -0800 (PST)
Subject: Re: [PATCH liburing] tests: identify timed out tests correctly
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <324adc3c4d04f890932cb7b2fd8a0ff183f9ff48.1609792468.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <174ba2e8-de1f-f40f-25d1-d41d4bb5d6a9@kernel.dk>
Date:   Wed, 6 Jan 2021 11:40:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <324adc3c4d04f890932cb7b2fd8a0ff183f9ff48.1609792468.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/4/21 1:34 PM, Pavel Begunkov wrote:
> We want to get a stable status (i.e. -124) when a test has timed out,
> but --preserve-status makes it to return whatever the process got.
> Remove the flag, it behaves same but if timed out passes back -124.

Applied, thanks.

-- 
Jens Axboe

