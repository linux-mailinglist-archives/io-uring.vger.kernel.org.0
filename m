Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47AC11DB563
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2020 15:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgETNns (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 May 2020 09:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbgETNns (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 May 2020 09:43:48 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3204C061A0E
        for <io-uring@vger.kernel.org>; Wed, 20 May 2020 06:43:46 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id x15so1596671pfa.1
        for <io-uring@vger.kernel.org>; Wed, 20 May 2020 06:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GtMXJ8Nf0WVCEoZD1G/y/xw+6bCdGg1E+N3tCOQ4B64=;
        b=pfHBuS+prAGy3q7PQnQUX044KZkMn0nCrKd61zKL0YcORuFwESa45r7nn1b/1Cv98W
         V2+T+bbZS9sPUCznQCpKY50mBuuwtG0aUOcD0HSXbDg0alBsR0drnLoV2NQSe5ppHh01
         nOXVbygeyxYT43j2D/KxlDqyQtYr8CyxoKxG6yP6sWeE5LwfDsEACLjmwu4e3lxz21Eu
         3Tm//Q/YY4Z5iHEGmD5xa3JPjOglAA5XIL2FD7iOWE8zgCO0L4Z45EXSS28cKaIzEe8J
         c5XBuM18Yzsdt9FwQRe4tJiKa/iu6nEvqdN02DSt9ieW7twt2BvVNA26dNQY2uX9T+xp
         wUlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GtMXJ8Nf0WVCEoZD1G/y/xw+6bCdGg1E+N3tCOQ4B64=;
        b=fqnQQcm5G9afceGxqXDyjG1B/Fk4gIopYs6sg5oVkqwQDMmF2gNcNrEoU4df0e5L6D
         8GpaFyR02B4brJbn/t3hGTy6zCHKTZI0J4dmtK05+KvZ6xjGwM6UYRRGMwE/PN4zmN2g
         JBHLiJrlCTu7XbtT+31RqtxZ2COvTtpOe6FafmKKlgIqh1+FEr9znKa2+y2ikqfx6XlX
         ShhKsWL8AISiB9EN3uxMBW0/X4eJ5AAol7Vs+Cd3xe/Vd7yWUptr2veIzDGMAzXK47cw
         /ty2+xebK1QnCjeH2F82nvo6Pd2GC9UvlhUsQR84esJAxzXQZisyLOySw4MepxXTH9oN
         Btdw==
X-Gm-Message-State: AOAM533Z7t7YwoaYC+Una5nys9YT4A4Uuly8nBqnbNyPqlxTVQkgusZt
        HZsYIk2qiZXPEAktSz+OIVP92frlVXg=
X-Google-Smtp-Source: ABdhPJzgMvOfXPJyCV+rsngf3ZXqqHDrr2TwecPI26SIsc8pj61OkW72VBFs0VjD+8hiCOZd/f7Mhw==
X-Received: by 2002:a63:451c:: with SMTP id s28mr4281685pga.340.1589982225964;
        Wed, 20 May 2020 06:43:45 -0700 (PDT)
Received: from [192.168.86.156] (cpe-75-85-219-51.dc.res.rr.com. [75.85.219.51])
        by smtp.gmail.com with ESMTPSA id m12sm2011456pgj.46.2020.05.20.06.43.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2020 06:43:44 -0700 (PDT)
Subject: Re: [PATCH liburing 3/5] Add helpers to set and get eventfd
 notification status
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     io-uring@vger.kernel.org
References: <20200515164331.236868-1-sgarzare@redhat.com>
 <20200515164331.236868-4-sgarzare@redhat.com>
 <5bee86d5-f8bf-5b61-dd26-5e7d0448a217@kernel.dk>
 <20200515171111.zwgblergup6a23p2@steredhat>
 <20200520131221.rktn7dy42e633rvg@steredhat>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <dc504f4a-6fbf-114a-086a-f6392baac84e@kernel.dk>
Date:   Wed, 20 May 2020 07:43:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200520131221.rktn7dy42e633rvg@steredhat>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/20/20 7:12 AM, Stefano Garzarella wrote:
>>> The bigger question is probably how to handle kernels that don't
>>> have this feature. It'll succeed, but we'll still post events. Maybe
>>> the kernel side should have a feature flag that we can test?
>>
>> I thought about that, and initially I added a
>> IORING_FEAT_EVENTFD_DISABLE, but then I realized that we are adding
>> the CQ 'flags' field together with the eventfd disabling feature.
>>
>> So I supposed that if 'p->cq_off.flags' is not zero, than the kernel
>> supports CQ flags and also the IORING_CQ_EVENTFD_DISABLED bit.
>>
>> Do you think that's okay, or should we add IORING_FEAT_EVENTFD_DISABLE
>> (or something similar)?
> 
> Hi Jens,
> I'm changing io_uring_cq_eventfd_enable() to io_uring_cq_eventfd_toggle().

Sounds good.

> Any advice on the error and eventual feature flag?

I guess we can use cq_off.flags != 0 to tell if we have this feature or
not, even though it's a bit quirky. But at the same time, probably not
worth adding a specific feature flag for.

For the error, -EOPNOTSUPP seems fine if we don't have the feature. Just
don't flag errors for enabling when already enabled, or vice versa. It's
inherently racy in that completions can come in while the app is calling
the helper, so we should make the interface relaxed.

-- 
Jens Axboe

