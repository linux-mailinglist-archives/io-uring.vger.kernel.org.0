Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D17934B943
	for <lists+io-uring@lfdr.de>; Sat, 27 Mar 2021 21:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbhC0UJd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 27 Mar 2021 16:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbhC0UJB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 27 Mar 2021 16:09:01 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7BEDC0613B1
        for <io-uring@vger.kernel.org>; Sat, 27 Mar 2021 13:09:00 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so4064823pjv.1
        for <io-uring@vger.kernel.org>; Sat, 27 Mar 2021 13:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gl6K4yhW13Kr5byLAjtw6msM95S/bPbif0F7bCXuCTo=;
        b=ZpvGQmlVQNUjvDss7S/A9WVts56Zf4zThRGYI9SAPgvunBjxgkFZpvbhbiOPuf/6Sa
         UD/fxTC2ivppYJgO/Zw8j2E26D9DyvyagID+wZz9SzfvyE2Vgqnyg2pOzDeVyCarcQO6
         dq+cMKSjVktyzgf8uW8HIXr+1aRcrV1sxP/7nONAVQDIdH/MA4MCvQChMj/UfHkLBmNJ
         i3Fqpg1y0W8L6KLDFPP8CiabZ7S0j0rrhL8y5Bg0dYqRfGlcOS2fUZ6bx2CyyfavWtZ1
         J2BdmG+G3f3Vd50ky0Ku97VBEwMlSHt/6wbPn2+6qIFIVjhAAxWo+2I5gyQo3pJKdgf3
         spFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gl6K4yhW13Kr5byLAjtw6msM95S/bPbif0F7bCXuCTo=;
        b=eAEbZ+mOnXg9ePVUmzw/Cdxh7hL4fFGaQeKOrML/ihtzPwYIANdcArH8YRmQbsP4gP
         g5ae/D+KLk4WtfBqTygoGFoaCVQPMiF8o4j7lonL2iBwYoWygNjRdbnGqKeRlmxi7Qa/
         kSQO+QMUhii1b/OTveI4Nq6Qqjc2pqnokcFXxqewDP5I98RvPoC5EerWDlZRLYKYovPH
         PS7uMrvMy0Dvf3PFtQ0dSwL+F63juxAwfmzRRB4/fZULnSBTPmoJmsGvAs6T3/7z52P+
         IbKByThCkaQOIkz0l56ZOngIaXY6n5l61hJFJzn2L6nrISz+cpOVxjLbEzwckHDHM+VQ
         b7fA==
X-Gm-Message-State: AOAM533GB4hmSwmLuQjAxMyL+Y6FAIL8EZ5NoWQUXAI9BY1hlgKUrTfe
        nO6mA6wvMxl34CSnl9u20nSWog==
X-Google-Smtp-Source: ABdhPJyVHitKFRyW/+b4BAAeB3N1iyPYrhNX834K0F8siBnRjW6ZeSZra2xjQkXQiLobUcYQaIx13w==
X-Received: by 2002:a17:902:c48c:b029:e4:c093:593a with SMTP id n12-20020a170902c48cb02900e4c093593amr21093127plx.1.1616875740033;
        Sat, 27 Mar 2021 13:09:00 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 193sm13445271pfa.148.2021.03.27.13.08.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Mar 2021 13:08:59 -0700 (PDT)
Subject: Re: [PATCH 2/7] io_uring: handle signals for IO threads like a normal
 thread
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     io-uring@vger.kernel.org, torvalds@linux-foundation.org,
        metze@samba.org, oleg@redhat.com, linux-kernel@vger.kernel.org
References: <20210326155128.1057078-1-axboe@kernel.dk>
 <20210326155128.1057078-3-axboe@kernel.dk> <m1wntty7yn.fsf@fess.ebiederm.org>
 <106a38d3-5a5f-17fd-41f7-890f5e9a3602@kernel.dk>
 <m1k0ptv9kj.fsf@fess.ebiederm.org>
 <01058178-dd66-1bff-4d74-5ff610817ed6@kernel.dk>
 <m18s69v8zb.fsf@fess.ebiederm.org>
 <7a71da2f-ca39-6bbf-28c1-bcc2eec43943@kernel.dk>
 <387feabb-e758-220a-fc34-9e9325eab3a6@kernel.dk>
 <m1zgyotrz7.fsf@fess.ebiederm.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c0888c0f-4490-227a-645b-f3664aaef642@kernel.dk>
Date:   Sat, 27 Mar 2021 14:08:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <m1zgyotrz7.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/27/21 11:40 AM, Eric W. Biederman wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> On 3/26/21 4:38 PM, Jens Axboe wrote:
>>> OK good point, and follows the same logic even if it won't make a
>>> difference in my case. I'll make the change.
>>
>> Made the suggested edits and ran the quick tests and the KILL/STOP
>> testing, and no ill effects observed. Kicked off the longer runs now.
>>
>> Not a huge amount of changes from the posted series, but please peruse
>> here if you want to double check:
>>
>> https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-5.12
>>
>> And diff against v2 posted is below. Thanks!
> 
> That looks good.  Thanks.
> 
> Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Thanks Eric, amended to add that.

-- 
Jens Axboe

