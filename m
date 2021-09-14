Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB95440B2F4
	for <lists+io-uring@lfdr.de>; Tue, 14 Sep 2021 17:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbhINPXs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Sep 2021 11:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233908AbhINPXr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Sep 2021 11:23:47 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB74C061762
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 08:22:30 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id g8so20518835edt.7
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 08:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RHp4g/tg++Wa6eX+kz7ObPwR8mr86BYBWnaCSVp1rmQ=;
        b=XR1rAJx/wi7XcnUagjkA1GhLo+/2jMWB1bv6lAuduopXbkivyzg8Rka0P4qT2SXebL
         CaTv8AjGiCuwjPoJVFUZParQBRPFOA6urKLj5U56Zi6PTy3dBKb2QBIePr0RTcHuBWwy
         ljD/WE/ANzxu6ziu0MtcOxRfug+wVnRUNeQsSCcX7yCmlSm0b4N2RZP5xijBH6/7h55p
         nuISMhRy0eyw02oXHJxm3Tx1V7tZi4IhRXO+VYclckbi1oDmZtF7mWER+wjHVFFsNKKg
         ujIG78ZUNhYtVl4+0v2G+GiJgxWn7c8oZRGuuND6TOjWSS5N9ky2+xZJbNUu03xE/n6x
         OplA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RHp4g/tg++Wa6eX+kz7ObPwR8mr86BYBWnaCSVp1rmQ=;
        b=pIdUp4dQERCqKUAw0ya3trpml2ZJ6ygUIBlj277AHPYxCuYZSNdAqikQbJLjp+FwWv
         ujq+SjFONbB8GxlNW5qm7BLQFO82m3i+YTFka4sNhWZtxUjLiPkh8zIj3QGTWLlegJyx
         XJYpalbRBaFyxyjIUQpSO+OyDXbHuerNrNY4e+9s92o1sWytl5vxGGmlG9IPIyzGqBXT
         vmCBb8KVsxYBmCcInf/4/m8dFbhge4wMFOCDDTI1Mz1ihQonKRfqAgz0Er1uAU1FqNTT
         R5S3L+o0bfJMJrjp10KeIJzaelPjI1r8cxocBPqjSnAmOAZo/ywop45JxKsuUso9M/3q
         9sbQ==
X-Gm-Message-State: AOAM533owBLOwcJgHiho+CBOtkJjWkM9/WI1bz7DLrxs5JcsFDI8gbpT
        NiFBlHnE1JAtWj+kicKwwx0=
X-Google-Smtp-Source: ABdhPJx4IAB0tmeMP+DWAGSUmHAg0ny87lDnBjP3LxHbhNMS1DnrsQGllETNtXGA1/lF+6H+IYPsDw==
X-Received: by 2002:a50:c006:: with SMTP id r6mr7327288edb.289.1631632948751;
        Tue, 14 Sep 2021 08:22:28 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.232.220])
        by smtp.gmail.com with ESMTPSA id i26sm5570297edj.88.2021.09.14.08.22.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 08:22:28 -0700 (PDT)
Subject: Re: [PATCH v2 5.15] io_uring: auto-removal for direct open/accept
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     "Franz-B . Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>
References: <c896f14ea46b0eaa6c09d93149e665c2c37979b4.1631632300.git.asml.silence@gmail.com>
 <de129f22-1a44-8ddf-ec42-fa6fba85d7fe@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <5fddec32-ae75-aca9-1b67-78c91f789b74@gmail.com>
Date:   Tue, 14 Sep 2021 16:21:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <de129f22-1a44-8ddf-ec42-fa6fba85d7fe@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/14/21 4:14 PM, Jens Axboe wrote:
> On 9/14/21 9:12 AM, Pavel Begunkov wrote:
>> It might be inconvenient that direct open/accept deviates from the
>> update semantics and fails if the slot is taken instead of removing a
>> file sitting there. Implement this auto-removal.
>>
>> Note that removal might need to allocate and so may fail. However, if an
>> empty slot is specified, it's guaraneed to not fail on the fd
>> installation side for valid userspace programs. It's needed for users
>> who can't tolerate such failures, e.g. accept where the other end
>> never retries.
> 
> Can you submit a liburing test case for this too?

Made some for v1, I just sent out them.

-- 
Pavel Begunkov
