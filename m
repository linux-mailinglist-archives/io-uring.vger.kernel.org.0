Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB0B2779B0
	for <lists+io-uring@lfdr.de>; Thu, 24 Sep 2020 21:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbgIXTtc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Sep 2020 15:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgIXTtc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Sep 2020 15:49:32 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 014A6C0613CE
        for <io-uring@vger.kernel.org>; Thu, 24 Sep 2020 12:49:32 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id t14so323764pgl.10
        for <io-uring@vger.kernel.org>; Thu, 24 Sep 2020 12:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=y5W836wtbTs87UYBF49QKgnNIBYbATbwce80l2Ei6IM=;
        b=yQ3Ukqh7iIz9d3v/RM8+isMYkqmjzLbzN7/0zMG0qe3y3bBZmcuqpeh0sNq4mvHSim
         RZ1F+LNmNajABdBNarKhYc5g4m448UBidZERF1wSC7cj6xxU1gwrYNbBucMseQmrYu1M
         FowmsmYnKybfZtSNTxG4x8rMClx3bVb5ThUG5k/Pu6EtiMDliCP5Uc0HJC4cBMtqn+zj
         7+NCIsTV973NTIh6GL5TA4/+PKYu83sFY1ISvV2myJLApmIIpPhHSsFHhHhph4+2RAX5
         A/J2J4sX7pLHgCWkjbjR/fhp8J0YVioXmuTn/M51Bd3mmdjafewcApemEDvRaSHQLhs4
         n9RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y5W836wtbTs87UYBF49QKgnNIBYbATbwce80l2Ei6IM=;
        b=hSdCec+VO8sk3AQzLZIdtYkb2a0OIbbjpr2pzXwibzOSDO2Fq+kq64ynt8oyQSI7ro
         EvYtIBgr5wPcGxFt6AQG36a/uDXyYzWF9v2rauNxU0Ay06eAcYbtCZThGvmgpuk1NEoD
         op3HT2fJTLya+W7w184pV8k7W7+oFexMXnme5PeOebnULodGBBGL4Hh34Mm6zydmbjX+
         /n439w89oYOWx4a0SthVuEwo6z0kesVPKr4aUm9mjtn+Z4uWjT0pd+YjWp6eyOzzBcNi
         qKm+IJyzIu6LYYMq9fqqNLc2XSnsn7luQM01Id5YYPFvbijbsT7e07lLK7iOIH0zt6Qj
         nGIg==
X-Gm-Message-State: AOAM532/mvZX3AGAoAa8Xn08nL1/Oh8jnfDF2Mj9YPzcBL84jjvsb7aV
        pFgHffBxjDvgPdk/ne7BKdY4LmX2QeOkLg==
X-Google-Smtp-Source: ABdhPJwL5Wwn3+akMCW6ktChr8/F8nbWG8m8LJC4A1lpQdB5UAsByGnQfhDkqtJiR5BkVj1poVRTJA==
X-Received: by 2002:a63:4945:: with SMTP id y5mr537839pgk.181.1600976971495;
        Thu, 24 Sep 2020 12:49:31 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21d6::1911? ([2620:10d:c090:400::5:d63d])
        by smtp.gmail.com with ESMTPSA id i62sm274848pfe.140.2020.09.24.12.49.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2020 12:49:30 -0700 (PDT)
Subject: Re: [PATCH RESEND] io_uring: show sqthread pid and cpu in fdinfo
To:     Joseph Qi <joseph.qi@linux.alibaba.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
References: <1600916124-19563-1-git-send-email-joseph.qi@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6b67447d-122e-f68a-32fc-f36f51419449@kernel.dk>
Date:   Thu, 24 Sep 2020 13:49:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1600916124-19563-1-git-send-email-joseph.qi@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/23/20 8:55 PM, Joseph Qi wrote:
> In most cases we'll specify IORING_SETUP_SQPOLL and run multiple
> io_uring instances in a host. Since all sqthreads are named
> "io_uring-sq", it's hard to distinguish the relations between
> application process and its io_uring sqthread.
> With this patch, application can get its corresponding sqthread pid
> and cpu through show_fdinfo.
> Steps:
> 1. Get io_uring fd first.
> $ ls -l /proc/<pid>/fd | grep -w io_uring
> 2. Then get io_uring instance related info, including corresponding
> sqthread pid and cpu.
> $ cat /proc/<pid>/fdinfo/<io_uring_fd>

Applied, thanks.

-- 
Jens Axboe

