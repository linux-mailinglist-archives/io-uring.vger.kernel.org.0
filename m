Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8916A36218E
	for <lists+io-uring@lfdr.de>; Fri, 16 Apr 2021 15:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235527AbhDPN7A (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Apr 2021 09:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbhDPN7A (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Apr 2021 09:59:00 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B11AC061574
        for <io-uring@vger.kernel.org>; Fri, 16 Apr 2021 06:58:34 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id p67so13460470pfp.10
        for <io-uring@vger.kernel.org>; Fri, 16 Apr 2021 06:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=czgpvmgZPJ3O+tyPYJ2X0jNeQZ0QvhuXu8guxQyVg6g=;
        b=VcSha7JFHjWMIhwEN+hdWH1Ds9J5JUm2JX4MdBpzHITW9Po2GRFAOGDofheXPU3lzH
         vjFkcJ1d+wDYFtQ344kRCqcp9I30pcD1nfKz9RDmijysy9n6ArmRDWfXfcx2rYd2RNa6
         JEwc28L7pJor9joehsNeGlhnSTlSDDZcGwpwzYQmsIdOMtWYyF7qdNWcfpsPow5jTB29
         WSTVoQxToNSvlhD1aIXbWWyS8mjtHo7caF8w5W6GQhay+SMFmHDC8LHIPQU08ZDJDSDg
         JhRWyCuM3LQEbQRIelU0ZP22a7HnJzS8VOUYO6Sjq+frpJQekJITP7NW3XKD1BDwQqDL
         bFXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=czgpvmgZPJ3O+tyPYJ2X0jNeQZ0QvhuXu8guxQyVg6g=;
        b=UyKUmKZbSZKQbgiy7aTPFtIpMVRwPzyUO+3SqYa1AULmuIK9G0EqHT1PePVCVSJz2q
         Em7Ud2b2keN4pDgJkvq1SoHhzCaUc+EM68fcmfHftPFG0LMJCuCIyABKkDyDQKsj/Bwt
         3p9Xh/9TT9hFnl/h/ZxDv9uhZSuxG/A8+yWm3YlaNCKkN1MeK35w3zuuPkqAE9oXlzAA
         NKDD9Z2j7TuHxIt3JHtcLsOv6wa8++2hJ3lGfWGvCmt1i37tvGAehHgDNlUfJEtMvWJ5
         kdnnyEcmP1nXofNdwxYHe623fhe/Z1eget3GNy05I3SCuNIAlSZZlgV3ypVHmZmW/mLk
         o/xg==
X-Gm-Message-State: AOAM532IorVcupJ+nOHvklpmM26HGG9kSqps+iyh6ll+b/eTGdOA/6pk
        vTYTJ+FX42o0Wq+odIa+DsXrDA==
X-Google-Smtp-Source: ABdhPJxIFdnLsddE6DCRbNfzdlQyWwtEFkPXzKIQ0qFSj6KmMWra2muHYgLOGn97wyIkZOdz65W4pA==
X-Received: by 2002:aa7:9571:0:b029:259:1f95:27db with SMTP id x17-20020aa795710000b02902591f9527dbmr5293907pfq.54.1618581513676;
        Fri, 16 Apr 2021 06:58:33 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id q63sm6185164pjq.17.2021.04.16.06.58.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Apr 2021 06:58:33 -0700 (PDT)
Subject: Re: [PATCH 0/2] fix hangs with shared sqpoll
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>, Joakim Hassila <joj@mac.com>
References: <cover.1618532491.git.asml.silence@gmail.com>
 <8d04fa58-d8d0-8760-a6aa-d2bd6d66d09d@gmail.com>
 <36df5986-0716-b7e7-3dac-261a483d074a@kernel.dk>
 <dd77a2f6-c989-8970-b4c4-44380124a894@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <dabc5451-c184-9357-c665-697fe22c2e9e@kernel.dk>
Date:   Fri, 16 Apr 2021 07:58:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <dd77a2f6-c989-8970-b4c4-44380124a894@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/16/21 7:12 AM, Pavel Begunkov wrote:
> On 16/04/2021 14:04, Jens Axboe wrote:
>> On 4/15/21 6:26 PM, Pavel Begunkov wrote:
>>> On 16/04/2021 01:22, Pavel Begunkov wrote:
>>>> Late catched 5.12 bug with nasty hangs. Thanks Jens for a reproducer.
>>>
>>> 1/2 is basically a rip off of one of old Jens' patches, but can't
>>> find it anywhere. If you still have it, especially if it was
>>> reviewed/etc., may make sense to go with it instead
>>
>> I wonder if we can do something like the below instead - we don't
>> care about a particularly stable count in terms of wakeup
>> reliance, and it'd save a nasty sync atomic switch.
> 
> But we care about it being monotonous. There are nuances with it.

Do we, though? We care about it changing when something has happened,
but not about it being monotonic.

> I think, non sync'ed summing may put it to eternal sleep.

That's what the two reads are about, that's the same as before. The
numbers are racy in both cases, but that's why we compare after having
added ourselves to the wait queue.

> Are you looking to save on switching? It's almost always is already
> dying with prior ref_kill

Yep, always looking to avoid a sync switch if at all possible. For 99%
of the cases it's fine, it's the last case in busy prod that wreaks
havoc.

-- 
Jens Axboe

