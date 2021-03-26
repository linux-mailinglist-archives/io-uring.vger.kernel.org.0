Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4D7134AC02
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 16:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbhCZPyR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 11:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbhCZPyN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 11:54:13 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE97C0613AA
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:54:13 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id l5so5392819ilv.9
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hmKZXA8mj4z2Sn0NHF1dB2StCwX5I/Ah2+MSyhgR2YY=;
        b=zYiTc86pU51MTcqBFxpaU/Sd2COgU4Dmu4VyvQBTD970eIib2xKA34eL45fbrmug+M
         8lf7EveY8LnApuMB8KJ+GK6Wvg+U1ejvCac1bzJxMAFSWCNHv9Wnv2sLDsvK/uIFaT5x
         zyaezKHWg6+ri6yWnUJz0MJLaqWVpkGn8EIrbsHme5FxGESotrhrSeHVYRltvCeZNRfK
         dAR3KAcF2+Zn4jd3lhK8MwITlGXxas5TM3n19xXNwdXVOQexQfOXxHcaaMABPgZqMvfN
         /gSldH64oh2G7X/qFIszTXY32M1WOT7btpmUT4fwKCeY4KTUxdobLuZ6+v4IVOINEXWX
         TEaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hmKZXA8mj4z2Sn0NHF1dB2StCwX5I/Ah2+MSyhgR2YY=;
        b=lceifhBn672WZiScY3Q0DdYmcjN/UUjz3YGPXGYjpbZbWrhG3uC/gfLFrdLGsp8nGi
         c98WAuWCppZeibuNon4hJ7RR21InIp9Tv7C5XOieuCj2GODKY4bEcHkwvgYd6sWxEy7E
         EgkqXxW16ihshmL0PIPPPQzu1VKD/Xz4/z5d9jh7QVjDdrlF709ZQ+8n6v/4OqLJv8Wx
         e/XTIW3DginNAj7LCXByYOPYOf/o8kgpLHi1nKbJTwst6ON40ePaNXA+ZsunIUbYdIsY
         tpTfyGSw0gqnRtOVqOOvletYaGb9vbesipkoMF/u+1BQ3OoMEiijcX4MBRKOvJ3Jp2JM
         BZMQ==
X-Gm-Message-State: AOAM531wXbV59W/Cr0LHm75D2LWSNhztB7OWo60YML29y2A2zbuIyI0X
        1EzYwwM3MMfslxxUeHl4JMhZGg==
X-Google-Smtp-Source: ABdhPJzi6hlAERDYVoi4MIIMAiGygBCxqnc7RLVE+8vACOumfKUHb6kQh3nsN6p0QGTulNruW9MZvw==
X-Received: by 2002:a05:6e02:1546:: with SMTP id j6mr10820381ilu.75.1616774052468;
        Fri, 26 Mar 2021 08:54:12 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id w1sm4527876iom.53.2021.03.26.08.54.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Mar 2021 08:54:12 -0700 (PDT)
Subject: Re: [PATCHSET v2 0/7] Allow signals for IO threads
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, ebiederm@xmission.com,
        metze@samba.org, oleg@redhat.com, linux-kernel@vger.kernel.org
References: <20210326155128.1057078-1-axboe@kernel.dk>
Message-ID: <c9d2d005-5426-abb7-666c-488b83014924@kernel.dk>
Date:   Fri, 26 Mar 2021 09:54:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210326155128.1057078-1-axboe@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/26/21 9:51 AM, Jens Axboe wrote:
> Hi,
> 
> For the v1 posting, see here:

Sigh, just ignore the last 4 patches (07...10/10) in this series,
there are sitting on top of this series and I messed up the git send-email.
This patch series ends in the 4 reverts.

-- 
Jens Axboe

