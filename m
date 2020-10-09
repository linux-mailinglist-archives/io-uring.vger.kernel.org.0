Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8D2D288C5F
	for <lists+io-uring@lfdr.de>; Fri,  9 Oct 2020 17:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389214AbgJIPQX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Oct 2020 11:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388533AbgJIPQW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Oct 2020 11:16:22 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC710C0613D2
        for <io-uring@vger.kernel.org>; Fri,  9 Oct 2020 08:16:22 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id p11so4602817pld.5
        for <io-uring@vger.kernel.org>; Fri, 09 Oct 2020 08:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s/sPpyq4lTHRHob1KiXQqTKj8DhUh+ZWT1QGn6lwICM=;
        b=MA72PDCMnz5+Uq0lokZDZUEz3/+onI2Fuanfh7FHn4b+sxJa3oAafzDdytqYm9uG3e
         vhWLRkT7To8dAIcQbV+VFwgGVzkbXG212ZftJNXt4djRHHAD/pOIf+zIgN917a5R/HrG
         IakIlh1PEjZHtdzmVbVnz4uKPKRItJOQWtM8qq/fa3HeBItRx7oiY+qBDRIF1hNNxnf6
         vJoOcbbrqNYeBaMI92YHmfm1vnjx1PKLdN3fK2BGZzkK5uwaOc4jIIAvE4eQ6YW8OFyy
         v/AL6YmvrbYQIvl9EaDybCG2nuYnrCoKpkjJqtahDLXng75amzff3j2HVeYOAKiUVARZ
         dQRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s/sPpyq4lTHRHob1KiXQqTKj8DhUh+ZWT1QGn6lwICM=;
        b=Th7J7e/upCa1GvxlGb0VUyheOQ/eRz0sXlVfcmPvCGg5/vWSp1DP5hMQIL4Ffvhndk
         FO5UDDlw+QOS6lFcaQkxtUPnJERp5HLKGUEcf0cyhqaoYWr4eZ1K/nSLDp6nK56l9Q25
         prEiZSQ9x1oq2UrdIU7AU2h1DdGvV9JAuY32UHnaE20T837TsW7ErQLWN9kSce6SoIhI
         pLeLIVUYmL+oOua40sIzOE86jNMjco4q0RMpEaGUEYZ+a+Cy1j/cYvvUEfxGeYCSD40r
         JbYpNjTZFgMfAJaKxqpkUXg6caeiguyiNj1iEp8jpj0V65tiwwsImbxL9I3TZ9dvr3fN
         aYPg==
X-Gm-Message-State: AOAM5319EsTfK9WkPKIp4AhyxEG6LAy7a1VIpPpUrtgspvOVYcVpWPXQ
        Y6cvUOmyAB5vQFeYZa0BRSEiCw==
X-Google-Smtp-Source: ABdhPJy4sehD0xdkrNx3fIXPsV8QMpK1YcRBTKuxAUvdGBnKYWNpnzCG5Tp2QVxXB7EkHo2BnfMpUA==
X-Received: by 2002:a17:902:54e:b029:d2:ab75:3864 with SMTP id 72-20020a170902054eb02900d2ab753864mr12399618plf.50.1602256582273;
        Fri, 09 Oct 2020 08:16:22 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id n125sm11249062pfn.185.2020.10.09.08.16.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2020 08:16:21 -0700 (PDT)
Subject: Re: [PATCHSET v4] Add support for TIF_NOTIFY_SIGNAL
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
References: <20201008152752.218889-1-axboe@kernel.dk>
 <20201009143009.GA14523@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8f9d8948-7e20-f0f1-7722-e7c0c6531b6f@kernel.dk>
Date:   Fri, 9 Oct 2020 09:16:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201009143009.GA14523@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/9/20 8:30 AM, Oleg Nesterov wrote:
> On 10/08, Jens Axboe wrote:
>>
>> Changes since v3:
>>
>> - Drop not needed io_uring change
>> - Drop syscall restart split, handle TIF_NOTIFY_SIGNAL from the arch
>>   signal handling, using task_sigpending() to see if we need to care
>>   about real signals.
>> - Fix a few over-zelaous task_sigpending() changes
>> - Cleanup WARN_ON() in restore_saved_sigmask_unless()
> 
> Reviewed-by: Oleg Nesterov <oleg@redhat.com>

Thanks, added.

> but let me comment 3/4...

Updated for that one too, this is the current patch:

https://git.kernel.dk/cgit/linux-block/commit/?h=tif-task_work&id=b6d5da9ba8e31f7b222172c1626cfd0f5d035083

-- 
Jens Axboe

