Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA09934C081
	for <lists+io-uring@lfdr.de>; Mon, 29 Mar 2021 02:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbhC2AMU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Mar 2021 20:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbhC2AMT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Mar 2021 20:12:19 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2E8CC061756
        for <io-uring@vger.kernel.org>; Sun, 28 Mar 2021 17:12:15 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id l1so3561128plg.12
        for <io-uring@vger.kernel.org>; Sun, 28 Mar 2021 17:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=1t48VipkRbtYNrjXF3vrvrQ/bA5UiJkWGk5pcek3Gns=;
        b=fW/1QX6AzV12g6nqTKHawDRyjDQCXJhmQxWuUJ0wwNTedidcfaUW787MgyucS9LrtV
         W1/SG8zlvO6tmRCp92USRALcPKZgAEe/ww37vKrmZt09LPK8Fk98B/6pcl5IYgPKYjc9
         G8u4vr5jWNsa6szarUtV5tz7b1+JyU+JBeoUg2AuMouk/qDEIdhsKug1yMvALIPtBsNE
         H1a0elI/mRw2dC2KL8kO/yxGJpnYjDgT6JDH17bhAeA9OwYlYifg8hHudu2/AJEGlf4U
         YhK9HHNn+3J0d1NrFioTZAQjUsjSOQ8rbGkRdAROLv7KWi/kRRqNk+7HKNYgJ8vsf2Bo
         bnsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1t48VipkRbtYNrjXF3vrvrQ/bA5UiJkWGk5pcek3Gns=;
        b=ope342c/LyeU5+OD5/ug398vmjX9pJ9Ocou2NsBWaET2DsC2djipm7hlLYeo6Vcbe1
         RsT2610iCPG2dpjdXnNky94FUsOfwt2H0Ckv2fosvX1DXhPZ+MTnwFQODU/RFuBMMRtL
         rL3cnyxliYgZdZMQhbmeEYDQ3Ku0Ym4kh53U4Dyfow06yqhZc3l4qP6CE1Hy4AKTxT3T
         NpYzC2AhaAmXSq4khmrU7p0t+uQJGsiomGMM9/VmcXGNgjLrvKDNjw3NJdoG5fW/FPLW
         3XPp6PEFfeDHmulEMMnCSm3vfQLanF6ZznGP/PF6moeNfA2OKZ/kpvfL/1WfOhaCSMy7
         z20A==
X-Gm-Message-State: AOAM533ep7YkPnv9V/etS+2mg2xjXwORMtHS9mdor1KojHMsEdzPik/k
        FhfzzolFESBiSy3dtdF+pfSMMgbv6FVo1w==
X-Google-Smtp-Source: ABdhPJz8fWRjhp+FCbfwSsK9dF+B3SPXWykQHlOjxSCRJ0yQjIHJ7LUcsRMvU4Jx5Q6oUdkFPPuSTg==
X-Received: by 2002:a17:902:e80e:b029:e4:b2b8:e36e with SMTP id u14-20020a170902e80eb02900e4b2b8e36emr26107048plg.45.1616976734224;
        Sun, 28 Mar 2021 17:12:14 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id g26sm14968596pge.67.2021.03.28.17.12.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Mar 2021 17:12:13 -0700 (PDT)
Subject: Re: [PATCH 5.12] io_uring: always go for cancellation spin on exec
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <0a21bd6d794bb1629bc906dd57a57b2c2985a8ac.1616839147.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <40f25e0d-6554-b9e4-4951-a407d6037543@kernel.dk>
Date:   Sun, 28 Mar 2021 18:12:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0a21bd6d794bb1629bc906dd57a57b2c2985a8ac.1616839147.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/27/21 3:59 AM, Pavel Begunkov wrote:
> Always try to do cancellation in __io_uring_task_cancel() at least once,
> so it actually goes and cleans its sqpoll tasks (i.e. via
> io_sqpoll_cancel_sync()), otherwise sqpoll task may submit new requests
> after cancellation and it's racy for many reasons.

Applied, thanks.

-- 
Jens Axboe

