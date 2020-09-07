Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 733AB25FAB0
	for <lists+io-uring@lfdr.de>; Mon,  7 Sep 2020 14:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728952AbgIGMu2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Sep 2020 08:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729323AbgIGMtU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Sep 2020 08:49:20 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18026C061574
        for <io-uring@vger.kernel.org>; Mon,  7 Sep 2020 05:49:19 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 7so7983527pgm.11
        for <io-uring@vger.kernel.org>; Mon, 07 Sep 2020 05:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/FT3DK5/DRgJdcSvbKMRfPnmG4IGGEzwPZHckueGfdk=;
        b=rRznSopRp9lSmZylDd6EredVu9ECo4XUIL2QDFrvaNEimzfQGgxopisoahiKQx9x1d
         xCcpurTievHqgH9APR/jY8h05QqOPF361F9v1byc7QzC/tWR3LBf3OMCEi0/eDU5ZlAN
         LltGOxlQFR3wtm4KMv2GsPniAh/v1xSF1UTw2WxifLsRrC5KVgK9sGc2MO1Q/AzrDT9d
         jA7QgkfRJwxvh+5y67b0CpeK8HMN41U0VtAp+G8qIvB7bVzHiB6qYVsnuKvmxudWrda6
         gyGhipxXoYIQH8GEm7mKtVi3iyWJyrzuplSHWnEp9SixVMa+yqgXKI+Z/KaWxcibl3EQ
         c2fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/FT3DK5/DRgJdcSvbKMRfPnmG4IGGEzwPZHckueGfdk=;
        b=s6wUU3vC6YnW426zlJ1XcGV35z8DUooQhyCi3kElDaFwhdUw6TWpTH9y9kMcG4scER
         yXEYZgEcF5Hog4dT2/OEGLFQS9OiHf6DHhgjU4oU3jWYULJEkuAeGrVHoxGhC3Gxi/zj
         TzPAj7y6RsNLu7H80IjqjPVgfetLHLv1kbntg88REoIvYQoyEl3twVjZL3RXb2cyOYxF
         24pG51su1R6HpThuEAQc0iiXGunE3KDpqMfAEQt6r1s2A5y/4LOYh7hAXkvHMrbV2hiZ
         KlkkQD9ACSig9GM4RtHAUx/u+SBDB5N4WiWyRdJ9gnISF85NLBv+Rn0c7DDd36yNg8k6
         yJ3Q==
X-Gm-Message-State: AOAM533GW8kZ5khLAS/zCcNhphdlYCKJXp5Scouo+7Z9QmZrJqfUJ5yv
        DAgjlddNsowOPeoAI45HYnWoeQ==
X-Google-Smtp-Source: ABdhPJyj/vWX9V8xmSfTbagiSHihgX1MbkYcA9HFQbPh1R8mPm1rp2TrvdirJOcRFW5zILOmW4JYFg==
X-Received: by 2002:a63:cd4f:: with SMTP id a15mr14685112pgj.416.1599482955189;
        Mon, 07 Sep 2020 05:49:15 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id k24sm15003449pfg.148.2020.09.07.05.49.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2020 05:49:14 -0700 (PDT)
Subject: Re: SQPOLL question
To:     Josef <josef.grieb@gmail.com>, io-uring@vger.kernel.org
Cc:     norman@apache.org
References: <CAAss7+p8iVOsP8Z7Yn2691-NU-OGrsvYd6VY9UM6qOgNwNF_1Q@mail.gmail.com>
 <68c62a2d-e110-94cc-f659-e8b34a244218@kernel.dk>
 <CAAss7+qjPqGMMLQAtdRDDpp_4s1RFexXtn7-5Sxo7SAdxHX3Zg@mail.gmail.com>
 <711545e2-4c07-9a16-3a1d-7704c901dd12@kernel.dk>
 <CAAss7+rgZ+9GsMq8rRN11FerWjMRosBgAv=Dokw+5QfBsUE4Uw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <93e9b2a2-b4b4-3cde-b5a7-64c8c504848d@kernel.dk>
Date:   Mon, 7 Sep 2020 06:49:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAAss7+rgZ+9GsMq8rRN11FerWjMRosBgAv=Dokw+5QfBsUE4Uw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/7/20 4:23 AM, Josef wrote:
>> On top of that, capabilities will also be reduced from root to
>> CAP_SYS_NICE instead, and sharing across rings for the SQPOLL thread
>> will be supported. So it'll be a lot more useful/flexible in general.
> 
> oha that's nice, I'm pretty excited :)
> 
> I'm just wondering if all op are supported when the SQPOLL flag is
> set? the accept op seems to fail with -EINVAL, when I enable SQPOLL
> 
> to reproduce it:
> https://gist.github.com/1Jo1/accb91b737abb55d07487799739ad70a
> (just want to test a non blocking accept op in SQPOLL mode)

Yes, that is known, you cannot open/close descriptors with the
SQPOLL that requires fixed files, as that requires modifying the
file descriptor. 5.10 should not have any limitations.

-- 
Jens Axboe

