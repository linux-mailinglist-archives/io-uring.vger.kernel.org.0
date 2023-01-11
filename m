Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1B46665E6
	for <lists+io-uring@lfdr.de>; Wed, 11 Jan 2023 22:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235237AbjAKV6a (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Jan 2023 16:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232509AbjAKV63 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Jan 2023 16:58:29 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D14E33E0F5
        for <io-uring@vger.kernel.org>; Wed, 11 Jan 2023 13:58:25 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id s3so9925399pfd.12
        for <io-uring@vger.kernel.org>; Wed, 11 Jan 2023 13:58:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8Obkb0kzjvD/4Rh3qw6c/69fgaEhJbsYAq/Q6o2FDWQ=;
        b=HuuDX4tRBSTJnI+TIu8jzSsRF7dl6LoIO6huUTPB1oglJ+Q/xpRDxGkM88AO9Eqv9q
         jq42xRqQnU0fFyJReqLTrhoghELhEvuL/QHgumVvAiLYyiNF1/hWkUZpJglE0LopXv1w
         i+odRdzdU5XeRPqU4787IMalsxWpYhfOsyTB5MwAXqn/MMZoe6zxpze9+MNxAy2Qh9ix
         hHB+UPWTwoUtuOSRxGyMToOEJ7WcENuql09xWPt4vLsKgZFQiGDO3hOsC3nn/G4StOEL
         9Vc16MNUkXCTDJjFhXQ8FKUSnylUgct4p4QGUL5zXJWM0II68M3DN42L4KwbsrcWZlsb
         F0mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8Obkb0kzjvD/4Rh3qw6c/69fgaEhJbsYAq/Q6o2FDWQ=;
        b=hTIpGbOvwpB9PlfgmzWRoVPacqoGk8f61hqvVX2xXYQEe/16c4BmQBY4z+sai5tCyb
         W0K1TA101/AKjQIiVniZh+nh7MAeChxsKCzWQEbCzfjVxJmdd+9eNu/S/wb9naujyV62
         PYMkoAYWe9dqcEfnV36u9IZxqDBSvf+BR3TEkm7n4dtyVSPAtAPXOpbIvJnpI17+agL+
         aqW7gElwVlYJrwWaVgm4e4WCdwg+1x73aqwLRfHAYD5RWxv+zM2OmO06FT/SboSmmxSM
         RDyG5+wjdG3s0pTJ8G++b0/ftkNatd6He8lKXG8Z3xIrJ88c14twOMGgNU01Fg+LbwQ2
         ySWg==
X-Gm-Message-State: AFqh2krU+7L9Cte3rV9nEA2GJxxqNecjxh7Co6k6JHjaSCR8zaAPaNyj
        tiAGukhGm1NJjri+qAQulqGbhU/mffGmH+jN
X-Google-Smtp-Source: AMrXdXsIR82tbAtz9jygOyB/cpYtAQoBqPBu+GzWlRZYvwVPZLbir8tBLdXO7HHJIXbLe1BXNjVG4A==
X-Received: by 2002:a05:6a00:2a0b:b0:585:4ca7:5c4b with SMTP id ce11-20020a056a002a0b00b005854ca75c4bmr4234358pfb.2.1673474305267;
        Wed, 11 Jan 2023 13:58:25 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5-20020a621505000000b005772d55df03sm10447621pfv.35.2023.01.11.13.58.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jan 2023 13:58:24 -0800 (PST)
Message-ID: <507593a5-3606-8a92-e599-dd8711df519e@kernel.dk>
Date:   Wed, 11 Jan 2023 14:58:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] caif: don't assume iov_iter type
Content-Language: en-US
To:     Keith Busch <kbusch@meta.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, Keith Busch <kbusch@kernel.org>
References: <20230111184245.3784393-1-kbusch@meta.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230111184245.3784393-1-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/11/23 11:42 AM, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> The details of the iov_iter types are appropriately abstracted, so
> there's no need to check for specific type fields. Just let the
> abstractions handle it.
> 
> This is preparing for io_uring/net's io_send to utilize the more
> efficient ITER_UBUF.

Looks good to me - the correct return here would be -EFAULT as well,
not -EINVAL. Which is what will happen once memcpy_from_msg() is
called anyway.

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe


