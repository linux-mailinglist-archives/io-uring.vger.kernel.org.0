Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9E1D31691F
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 15:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbhBJO2g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Feb 2021 09:28:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbhBJO22 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Feb 2021 09:28:28 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6250AC061756
        for <io-uring@vger.kernel.org>; Wed, 10 Feb 2021 06:27:47 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id o7so1998197ils.2
        for <io-uring@vger.kernel.org>; Wed, 10 Feb 2021 06:27:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=oJGn0Ak2+r7oxIXmUeqqZJ08BN1OGrHs5ME8OVydxgE=;
        b=1a9Ly71UGzYX15xU4RpTjMT3b6U9oj0BCzwr1XIao7mD5oqNuOZCXReI0+KyKhfW2F
         RROydwwZj6so7aRdYzLii8ClAf472DTvRCgiBHjmKZOCJrH+hXTsxUPfM9guK89flI6R
         aij0XFvn9tFNN/QzsdjAmPVHEmo3PfX+8ThLhYhM3wSfl5k8mPE48vyotIuq9KSabY34
         aVZo3/Z6TddHqS0V4x88AS2lRvRU7fzrbLeOX7Y05IH1vxhZZTUGzgoHN9QG4wMMCYQ8
         9sdv7uHXhbYbbGeYKu0lI0IQxT9OWLJaGL0e9125Qo24GW3bOIMNkBCyXK23lNRwh3Zv
         Ci2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oJGn0Ak2+r7oxIXmUeqqZJ08BN1OGrHs5ME8OVydxgE=;
        b=fhCSADlZhZ95qDLHOu2OwLK+3bphRG4JRucuNBuKoeJKF1imOlpCyNdF6hpLSU60ih
         FFEdSphZC0ptlCj0QNOt1+Ci3dFXxlZwjmNwPqa8fusMibOP8DV8OumeTSxu6EapTYWI
         /LAklRERDBmpUq59k7QcPtUcZc7UHVdc57Wm/sdwBInuQbJzwILwiMzdffpwl4pjgESe
         pN+5+ziTZilzCFccPUlKe2Sd7zUnZIDyLklgYyQeLOn5P8DeX40Sqsw3jJVrZW5CMzTY
         LSCRhGnpHmewlJ6jTeiYqLIN2obqdIGwuR3NeUoQoVuVLibC7YYzqcbGY1G23HVNEXyy
         appQ==
X-Gm-Message-State: AOAM531lS1Smym4NKApwMNW4b2m8IezI13BK+m7R/I2joBCy3t+Qzddz
        s+Z2l4Y/0hYhoDAb/CGVqrOdpC+qUaWPmHjn
X-Google-Smtp-Source: ABdhPJwgaXVllFeUHIgelr0VuSgxpqdbkYuO6+HL9n/rgvxHVWbTFXgz4ekmfbjV0rKmoKAaztlo+w==
X-Received: by 2002:a05:6e02:1a03:: with SMTP id s3mr1341156ild.178.1612967266590;
        Wed, 10 Feb 2021 06:27:46 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o131sm1072428ila.5.2021.02.10.06.27.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Feb 2021 06:27:46 -0800 (PST)
Subject: Re: [PATCH 03/17] io_uring: don't propagate io_comp_state
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1612915326.git.asml.silence@gmail.com>
 <275f9bbb7d9a74b1912a51acb1f90c1f1a47594e.1612915326.git.asml.silence@gmail.com>
 <240e3851-0f37-72c4-7b32-2cfa567cab79@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3a62d7bf-7fd2-e5bf-fbee-a76e199df4e3@kernel.dk>
Date:   Wed, 10 Feb 2021 07:27:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <240e3851-0f37-72c4-7b32-2cfa567cab79@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/10/21 7:00 AM, Pavel Begunkov wrote:
> On 10/02/2021 00:03, Pavel Begunkov wrote:
>> There is no reason to drag io_comp_state into opcode handlers, we just
>> need a flag and the actual work will be done in __io_queue_sqe().
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> 
> Jens, can you fold it in? Doesn't build currently for !CONFIG_NET

Will do.

-- 
Jens Axboe

