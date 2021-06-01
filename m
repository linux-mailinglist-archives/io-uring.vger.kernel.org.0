Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FAE03978D0
	for <lists+io-uring@lfdr.de>; Tue,  1 Jun 2021 19:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbhFARLs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 1 Jun 2021 13:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234628AbhFARLr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 1 Jun 2021 13:11:47 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B2BBC061756
        for <io-uring@vger.kernel.org>; Tue,  1 Jun 2021 10:10:05 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id h7so2040608iok.8
        for <io-uring@vger.kernel.org>; Tue, 01 Jun 2021 10:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=45uSmWB3uWjfQFFm8Ik60/wv/js4ZAF9ioh+YYIQHHs=;
        b=EwANWAVySyLBIX+OKTPeGFTI+eUgiWWB9Rc5THJROYlyib/Tf+LvLGxOZ3RN/hCkUN
         ata6Udvj8kpPIf/2cCDi8408VKge8mlS8wGw0xGxEAXyCls/St2Qa4WJeLj23rttmeRG
         YRVS1isrjIw3oilbISWwduIvARmrwqll53x00Vhu6I4Jf0lzpunLtLS2oVt0eUwkzhqw
         Ia12AiFPVD4XGtPPb7LyWfl68nXIYCpw+kimXAe0dQJA9Lh8XhuCUogOR9UTyP0ivgK7
         HdwgfSxyPfVh2Rjlimlc7kgQ9UZVkC+XKETtoWr0u7V+cGX3sVdNlmtAE2rvLz5em9Nn
         ziow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=45uSmWB3uWjfQFFm8Ik60/wv/js4ZAF9ioh+YYIQHHs=;
        b=K4NLJiqKYHQZuFrS23ezs0+hkn1G/UMnT5rawZ1fd7JKZ86A/ROlpnQ6ebN7zoCXSR
         1Iub0zoDUIFXkc3ik9nP0DJfFSzuj35gex+OpqmqRPLcBzSjsq3FdKKDU0OVFVs/ReTu
         brAxtlyS+K+YH56QZ2AwW4RJTo3BVdofRikr7Q77codahRTMYjFIWbbS48oSYL+l8NqP
         jm31+fsxLlsXOOifzdbafBQMzjb76n5NV3Bp+bMGWoJxh44i1LUn/nB83vejuVN58yVW
         7Qv1RLF4qV59wJFOLkPfv8Tkt9Ow/zqgJqlWPyLo1c99QmqOhDeavJvz2G/iDOcQQ8CI
         YG9g==
X-Gm-Message-State: AOAM531vU9TgLTMPZParZqPIkPueXqS+xvOKKhP3gByLQh0PV8bZgatb
        KhRkYGWyl7eOEii2tEWAyrDq3E0uTvOIDVG+
X-Google-Smtp-Source: ABdhPJyRQXln8B7bDAQCQaNWIpA6A/XaOLUTZxePnTGh/Hm340CfNeeLk39dYDZiKKWW15heeyPccQ==
X-Received: by 2002:a05:6602:242b:: with SMTP id g11mr21528226iob.105.1622567404667;
        Tue, 01 Jun 2021 10:10:04 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id k22sm7532584ioj.29.2021.06.01.10.10.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jun 2021 10:10:04 -0700 (PDT)
Subject: Re: [PATCH] io_uring_enter(2): Clarify how to read from and write to
 non-seekable files
To:     Alois Wohlschlager <alois1@gmx-topmail.de>,
        io-uring@vger.kernel.org
References: <2191760.Ec4jsOL7QN@genesis>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4161285a-5b8c-31d6-f4f7-1a7aa2c5356b@kernel.dk>
Date:   Tue, 1 Jun 2021 11:10:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2191760.Ec4jsOL7QN@genesis>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/31/21 6:38 AM, Alois Wohlschlager wrote:
> IORING_OP_READ* and IORING_OP_WRITE* all take a file offset. These
> operations can still be used with non-seekable files, as long as the
> offset is set to zero.

Applied, thanks.

-- 
Jens Axboe

