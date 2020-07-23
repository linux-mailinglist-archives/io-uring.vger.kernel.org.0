Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D2622B589
	for <lists+io-uring@lfdr.de>; Thu, 23 Jul 2020 20:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbgGWSTt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jul 2020 14:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbgGWSTt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jul 2020 14:19:49 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85152C0619DC
        for <io-uring@vger.kernel.org>; Thu, 23 Jul 2020 11:19:49 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id q17so2917047pls.9
        for <io-uring@vger.kernel.org>; Thu, 23 Jul 2020 11:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Yj0zSW8ul91gNCpk5XV+zW6Wxxm/10saKJvfZHpBTds=;
        b=IT9MzgB/yqUazfnTfCFk9/oIekyUw4r9dz1Sm66/hvIZhHPXFtRMIWeyZOfV6Os8Bk
         yK2ZNO9SELC3KwS39sIDWBkpOWodWwqIAkI+/0XVkzTDapaIh1fr1A3EunU0Iuk9em51
         IEA3Dobk1tIA+kKXGczVzGEDpqwtrSovQCzr2pGMXRFOUD1ZgVL8BoxDRaZAVFhywQRg
         y7NRYGtK0OOEhdopzy6alyHPHxygG+XSPm+pKkYEYyxcGjOhlFiG9/QeIf9G6+CR82ZA
         kQATpV98Y/31/Y55MMXBULSuzbpJ4Ngvs1ximZctBBLwIuMlv4l2pBiBRDngPIvs7Ffw
         dFpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Yj0zSW8ul91gNCpk5XV+zW6Wxxm/10saKJvfZHpBTds=;
        b=IO+oWYCYAG89rVk1pUh24fGwpw0lIXC0sPXSuIl9FY7RsOswfaZkW9lUNBiSTLMPSc
         h7sFUgHL3fit/LNeu5zF7Bwm0KaoyHLd1rbwPuT36BVRd7T9sRvghQcWcq57j9l7ixjC
         xAwAFIFZkJfVMvZ2iHWy0FHDYZemlCFOolAdStBembsU86wVCSyJB0C4knyiMPnSp4YU
         1nIAgzJiAh6S7j21trwtdF1MYC1mkzU32oQGDzY0aIlnNieTXCqdCprnGrFhrZ1TgSQ8
         XjvEsww/bMpXgRTFLfjRhnMWB6g20d1yHvWg3bMGJvIXb8FQ+2leASVMPiuoNZl48xgb
         sU+g==
X-Gm-Message-State: AOAM5331s8uodHfpZA/Zj7b/S4lBwJ9LR1Vr3W7OdCXo6zLRjljrmVsO
        UJCYNlAEg1y5Rrocrg/018ZWxK4n41YvDQ==
X-Google-Smtp-Source: ABdhPJzzG+el6VR+JA4WnXsxxPixXHPBS0tDLxcCW9s1zhycgK7JawT3QfJW6f3je8bpnYhzTX/sHg==
X-Received: by 2002:a17:90a:71c4:: with SMTP id m4mr1637735pjs.178.1595528388720;
        Thu, 23 Jul 2020 11:19:48 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 193sm3599287pfz.85.2020.07.23.11.19.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2020 11:19:48 -0700 (PDT)
Subject: Re: [RFC][BUG] io_uring: fix work corruption for poll_add
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <eaa5b0f65c739072b3f0c9165ff4f9110ae399c4.1595527863.git.asml.silence@gmail.com>
 <e42e74bd-6220-c933-fce1-4005c3c7b2dd@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ecb56297-ec6d-de6f-a619-6d19549d2272@kernel.dk>
Date:   Thu, 23 Jul 2020 12:19:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <e42e74bd-6220-c933-fce1-4005c3c7b2dd@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/23/20 12:15 PM, Pavel Begunkov wrote:
> On 23/07/2020 21:12, Pavel Begunkov wrote:
>> poll_add can have req->work initialised, which will be overwritten in
>> __io_arm_poll_handler() because of the union. Luckily, hash_node is
>> zeroed in the end, so the damage is limited to lost put for work.creds,
>> and probably corrupted work.list.
>>
>> That's the easiest and really dirty fix, which rearranges members in the
>> union, arm_poll*() modifies and zeroes only work.files and work.mm,
>> which are never taken for poll add.
>> note: io_kiocb is exactly 4 cachelines now.
> 
> Please, tell me if anybody has a good lean solution, because I'm a bit
> too tired at the moment to fix it properly.
> BTW, that's for 5.8, for-5.9 it should be done differently because of
> io_kiocb compaction. 

Do you have a test case that leaks the reference?

-- 
Jens Axboe

