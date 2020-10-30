Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE142A1040
	for <lists+io-uring@lfdr.de>; Fri, 30 Oct 2020 22:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgJ3Vdy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Oct 2020 17:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbgJ3Vdy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Oct 2020 17:33:54 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D67EC0613CF
        for <io-uring@vger.kernel.org>; Fri, 30 Oct 2020 14:33:53 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id k9so4593942pgt.9
        for <io-uring@vger.kernel.org>; Fri, 30 Oct 2020 14:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fdf7qrE9V7oCaKCcaO9rE+bG/iAkzbTW68RAqydwWQw=;
        b=TP29Zcjf+YvoqX14Sok7M7vdkeuq1bEBkeSOP8tlDOVzQaezvzOjhIVKzJ4VxPwnLX
         S2Hba7YXMcG8Vij1cCyb2fGdF0EbgHK0+xb0FMKc4IRWkr9lCQAZpy9GqOzH5XmzsA6F
         KJgB6lVvyVDOZXYwSGfpTtxtdhScyvfDbBa4JSfWdGL24hXmZulg1BB9AcHHbtwLSuMj
         P6LI6jthQ+3QSzT1TFv+gU81cybZu0krA1vDxyJwGvOxWSkoui8YQHAUavozX2RirTrH
         4/0wXLlVBlbuY+U2IwauXUtwX+GILdhZhRYycd9KW/6QqOesw39lNwdYsMDKt8muBPeK
         RfgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fdf7qrE9V7oCaKCcaO9rE+bG/iAkzbTW68RAqydwWQw=;
        b=UnG6lwekvEF4gdBbnpyyRU5ZeY631tRBNenXDMb02XFkcfxv/FvR2KGo34bChmd4PL
         pYV5MF18Eo1p5e85zvyXv2aEiZFvIPIF4nnH/Fuj5SjyX+zbyoT42MQ416znGYudzqsJ
         /3emN+564KzohZzeIoeM7cq6RaoUapG30qWUhP+kDGIUjScO5MKtULvotqPM2yaOARc2
         NMVS3bUg98FAQ9GEOFSL8xztkpDzRzZyQqd9jQVS0y9ZEpZ/Yf+Sod0um0PC/INQpi+S
         y/THVQxvMOlLboCjzh1gzQxVeSw7mvAyvPOuXkq0MT2oLe2QG03h/9rFn+oQuGJhEB1Q
         n4Xw==
X-Gm-Message-State: AOAM533lK92MHJX1Vrq7SHfvOotI/iXmO4p7MfTHrkrZNvcWxmfgAFMy
        F63cW+TJ8g8DycPXhUgH+duHoQ==
X-Google-Smtp-Source: ABdhPJwJ56HdPwz3dIqJIOqHhgqY+f6Gw1g6sKSQGNNOxTO45GK8YjtogqlTRNioF5FRlzanH8Xnew==
X-Received: by 2002:a17:90b:150a:: with SMTP id le10mr5346214pjb.86.1604093632677;
        Fri, 30 Oct 2020 14:33:52 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id f8sm6256661pga.78.2020.10.30.14.33.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2020 14:33:52 -0700 (PDT)
Subject: Re: [PATCH v2] io_uring: add timeout support for io_uring_enter()
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jiufei Xue <jiufei.xue@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, metze@samba.org
References: <1596533282-16791-1-git-send-email-jiufei.xue@linux.alibaba.com>
 <1311456d-6d12-03e4-3b3b-ff9ab48495d2@linux.alibaba.com>
 <65e1658a-af29-2042-3235-d29fdf5857fe@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b1eac2a5-307a-6248-1589-59e5d13e5c29@kernel.dk>
Date:   Fri, 30 Oct 2020 15:33:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <65e1658a-af29-2042-3235-d29fdf5857fe@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/30/20 6:50 AM, Pavel Begunkov wrote:
> On 24/08/2020 02:49, Jiufei Xue wrote:
>> ping...
>>
>> On 2020/8/4 下午5:28, Jiufei Xue wrote:
>>> Now users who want to get woken when waiting for events should submit a
>>> timeout command first. It is not safe for applications that split SQ and
>>> CQ handling between two threads, such as mysql. Users should synchronize
>>> the two threads explicitly to protect SQ and that will impact the
>>> performance.
>>>
>>> This patch adds support for timeout to existing io_uring_enter(). To
>>> avoid overloading arguments, it introduces a new parameter structure
>>> which contains sigmask and timeout.
>>>
>>> I have tested the workloads with one thread submiting nop requests
>>> while the other reaping the cqe with timeout. It shows 1.8~2x faster
>>> when the iodepth is 16.
> 
> What happened with this? I thought there were enough people wanting
> such a thing.

I think there are, feel free to run with it. The patch looks reasonable
to me. Jiufei, I'm assuming you guys are already using something like
this?

-- 
Jens Axboe

