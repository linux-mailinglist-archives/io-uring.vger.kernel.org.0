Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3438A4A7809
	for <lists+io-uring@lfdr.de>; Wed,  2 Feb 2022 19:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346667AbiBBSfy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Feb 2022 13:35:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbiBBSfw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Feb 2022 13:35:52 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D02C061714;
        Wed,  2 Feb 2022 10:35:52 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id o30-20020a05600c511e00b0034f4c3186f4so5328689wms.3;
        Wed, 02 Feb 2022 10:35:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9u3C9hSFYYMAGadsDHWmNwfnI5O4YqeRxjZlStxOFX8=;
        b=W5fOlyfO5kNipI81WjccqfUb+uAGc0HvAWDMOcHfC1AiRy3wtntTEUVGBAbKtzou5S
         ZnK6An3bmddLSMk/ynsmMFUUL7gkVQ5dFRkRsIrC6nafH9qbuwmYQasqx8ReYxouFNvF
         bL8qb7aRoylYcXe02ksX/0oaEkNC1Qyk213boHwIH/njrnz6wl6/B9TOoR5jlMpvjuO9
         xuNwnkDKN286AI/yfqt/JSRBoOeeRjcWfBlBSmBATCVHzyujsLEthjvi6t77i1dY/hdY
         weKGUKJ9k1zWeJP7bh7ODFzZqn3k5bRDBLRGSpcnrlmueLEYLOcJn0mx304qmUicIn5w
         M99g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9u3C9hSFYYMAGadsDHWmNwfnI5O4YqeRxjZlStxOFX8=;
        b=EUw3SQRqzZyNhvYxsMBqZGX/riwh04/TdYX7BQtncXzbVLvLeqhCKleP3W++HyfFe1
         Zg+SSN3tqrRQN3mGdPL3pinzLnXnmTbCWGt3RjqT18Qo8Z4WCSbA8LesMMqBnveKU3x/
         +ih64GHV8GKW7q2UgnjEEKyEThhRhFTL+EsLagfmIE0IXy7YVdjS90/KTZMZcMKikVyv
         08nVbf0DLW99PFEPhpOR4vZOV4H51QQ+XN/Di2I9Gcs0LSGUW2XezN+etGbXMLxkP3I1
         10XfjjO1Lv96woKDVtcoThOgdT5Iw8jGGiT4WplA3gpQ5Q8VYgU2RNrJyGtn7wni9PR7
         5oIQ==
X-Gm-Message-State: AOAM530YfOK4lN71urEp8FgUgqKBmP90Zzuy6r8+PMqhg2JWShmvAT1N
        NSSLhWvcGF0RpwxX0oXKusY=
X-Google-Smtp-Source: ABdhPJwLN8tmhq+sh/GFaeW31rxeELJtwSpqWB5VDSkR1RSjpXRTDcxAskzvWFYOLB+TwEY8jq9rqg==
X-Received: by 2002:a1c:1f54:: with SMTP id f81mr7261619wmf.22.1643826950540;
        Wed, 02 Feb 2022 10:35:50 -0800 (PST)
Received: from [192.168.8.198] ([85.255.232.204])
        by smtp.gmail.com with ESMTPSA id i2sm6569354wmq.23.2022.02.02.10.35.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Feb 2022 10:35:50 -0800 (PST)
Message-ID: <1337e416-ef4d-8883-ab4f-b36dd88698d6@gmail.com>
Date:   Wed, 2 Feb 2022 18:32:52 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC] io_uring: avoid ring quiesce while
 registering/unregistering eventfd
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>,
        Usama Arif <usama.arif@bytedance.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com
References: <20220202155923.4117285-1-usama.arif@bytedance.com>
 <86ae792e-d138-112e-02bb-ab70e3c2a147@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <86ae792e-d138-112e-02bb-ab70e3c2a147@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/2/22 16:57, Jens Axboe wrote:
> On 2/2/22 8:59 AM, Usama Arif wrote:
>> Acquire completion_lock at the start of __io_uring_register before
>> registering/unregistering eventfd and release it at the end. Hence
>> all calls to io_cqring_ev_posted which adds to the eventfd counter
>> will finish before acquiring the spin_lock in io_uring_register, and
>> all new calls will wait till the eventfd is registered. This avoids
>> ring quiesce which is much more expensive than acquiring the spin_lock.
>>
>> On the system tested with this patch, io_uring_reigster with
>> IORING_REGISTER_EVENTFD takes less than 1ms, compared to 15ms before.
> 
> This seems like optimizing for the wrong thing, so I've got a few
> questions. Are you doing a lot of eventfd registrations (and unregister)
> in your workload? Or is it just the initial pain of registering one? In
> talking to Pavel, he suggested that RCU might be a good use case here,
> and I think so too. That would still remove the need to quiesce, and the
> posted side just needs a fairly cheap rcu read lock/unlock around it.

A bit more context:

1) there is io_cqring_ev_posted_iopoll() which doesn't hold the lock
and adding it will be expensive

2) there is a not posted optimisation for io_cqring_ev_posted() relying
on it being after spin_unlock.

3) we don't want to unnecessarily extend the spinlock section, it's hot

4) there is wake_up_all() inside, so there will be nested locks. That's
bad for perf, but also because of potential deadlocking. E.g. poll
requests do locking in reverse order. There might be more reasons.


But there will be no complaints if you do,

if (evfd) {
	rcu_read_lock();
	eventfd_signal();
	rcu_read_unlock();
}

+ some sync on the registration front

-- 
Pavel Begunkov
