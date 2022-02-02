Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C48E74A764B
	for <lists+io-uring@lfdr.de>; Wed,  2 Feb 2022 17:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346060AbiBBQ5W (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Feb 2022 11:57:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346046AbiBBQ5T (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Feb 2022 11:57:19 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 312F4C061714
        for <io-uring@vger.kernel.org>; Wed,  2 Feb 2022 08:57:19 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id z199so26238658iof.10
        for <io-uring@vger.kernel.org>; Wed, 02 Feb 2022 08:57:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=f3xTneMDmwKwFiJ5DZ4c/4EmeFrIEMZ69GnKtNoTjL4=;
        b=fe68ejtsUGlKOYJZhSMW2vQAMayRFKiyp3Vx2uwztk7lG6+F0oONpuISm6pG/7Y2sP
         7oAxYnYSL3AJeCWL8lrjwUUOxtlQVIixL1fisGs5dvKYJqS+RANARaSPCZkPKPN4T60k
         vVvh+3a7qMq7omY81bqjP1/OrXHTk/hGxA1O3chJ/k7asa2L7ZRt2/mEAeBbzW5jSHm1
         Ma32p4yhb7mH0PBLRoKlIW6zKtCHu3tm+7q/nKgIMEWdqsE/uUo2ZDHYsE7JBgYzTPe+
         WsKWtOJwVCKYSQPTRLZJBJ9AGCNXhiSKwmAXuF8bIgd7vGLYXxO5c2GK9BGsnGaL0tpt
         4jyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f3xTneMDmwKwFiJ5DZ4c/4EmeFrIEMZ69GnKtNoTjL4=;
        b=Me6bzz4TqJ5P23KWtO2lL99ojkut1BxzqGa4lmaKZ0407WThHmkfM7kWOFOnqT5hJ6
         r3TYB70w0ScrNNZkuiw74mQHZOlgmKeCRxERDl93o2CgzMgzPyAea1QECj2MjAmNnE7/
         rrhZECFFLUv9Y233P837KWyN8HqVWjISK/jgxskP3d/TOQnJbW1X8ufKM4AFwDiaBIq2
         vDV5b8kiJnTITzlLr0R+LZMTYOb6auhp0A1HPZ9g2CUYH1LO2P9ftQSIEx/DGRpnqK0m
         cGOxv4vC1YydBKD5y5ttZOqZRV+Vvw6KWkme+ol9g1DrAUUQFM7Rkq3NKPcv50o8H2fO
         yFWg==
X-Gm-Message-State: AOAM530KzE/B4JIS8G9JK9odcpbpcA44M54YfnoQq32pLCQkP5UulRZ0
        UihT2kMddAADOmkh1LRR+vngow==
X-Google-Smtp-Source: ABdhPJxrpafYs4vr1leXMPDHpArxOQWaVeCVak5nhXCxMXIbkhZqJvCRICbt8mLHQfw2tLrWPiNj6Q==
X-Received: by 2002:a6b:7316:: with SMTP id e22mr16836408ioh.125.1643821038512;
        Wed, 02 Feb 2022 08:57:18 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id r15sm20980095ilo.25.2022.02.02.08.57.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Feb 2022 08:57:18 -0800 (PST)
Subject: Re: [RFC] io_uring: avoid ring quiesce while
 registering/unregistering eventfd
To:     Usama Arif <usama.arif@bytedance.com>, io-uring@vger.kernel.org,
        asml.silence@gmail.com, linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com
References: <20220202155923.4117285-1-usama.arif@bytedance.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <86ae792e-d138-112e-02bb-ab70e3c2a147@kernel.dk>
Date:   Wed, 2 Feb 2022 09:57:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20220202155923.4117285-1-usama.arif@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/2/22 8:59 AM, Usama Arif wrote:
> Acquire completion_lock at the start of __io_uring_register before
> registering/unregistering eventfd and release it at the end. Hence
> all calls to io_cqring_ev_posted which adds to the eventfd counter
> will finish before acquiring the spin_lock in io_uring_register, and
> all new calls will wait till the eventfd is registered. This avoids
> ring quiesce which is much more expensive than acquiring the spin_lock.
> 
> On the system tested with this patch, io_uring_reigster with
> IORING_REGISTER_EVENTFD takes less than 1ms, compared to 15ms before.

This seems like optimizing for the wrong thing, so I've got a few
questions. Are you doing a lot of eventfd registrations (and unregister)
in your workload? Or is it just the initial pain of registering one? In
talking to Pavel, he suggested that RCU might be a good use case here,
and I think so too. That would still remove the need to quiesce, and the
posted side just needs a fairly cheap rcu read lock/unlock around it.

-- 
Jens Axboe

