Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A576831E159
	for <lists+io-uring@lfdr.de>; Wed, 17 Feb 2021 22:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbhBQV3s (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Feb 2021 16:29:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231483AbhBQV3q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Feb 2021 16:29:46 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2287C061574
        for <io-uring@vger.kernel.org>; Wed, 17 Feb 2021 13:29:00 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id q20so9270528pfu.8
        for <io-uring@vger.kernel.org>; Wed, 17 Feb 2021 13:29:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=YLWNyBl0pPWxgFK/nYa7DkvSwZ6Ie9O4m7EExM+0IhA=;
        b=FI0NANj6RGQO+8JaH+6lhA2HXrTuu+TnW6Ii+xh0CpoHsP0rZLAypuukQLp/cq6BkY
         tUgWmby5g6mp5sKJQPPZ8PTPRgkx6DvFWW9ZKe/3Ll7QyULG8q5BfjxPaMzVS4NoYeUn
         eRC39kG+Q4aJBCmRCAfIPNHccTo/JbS4Cxoto6xCC/oKlneYNf8LYMioHALOd5adnKjZ
         79vIw14y3WCLu6wlDVf0zC9SKaZED8F0UATK5PzKQ7GlgMbAVjzgJ7qVNK7QF5AHWHTL
         68xL2HOC/TCAD4HCtrG45IQwMH+tFKu4UnQlWEW7n7Htg98k113xljf14GzhKjyKdCPU
         JmBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YLWNyBl0pPWxgFK/nYa7DkvSwZ6Ie9O4m7EExM+0IhA=;
        b=ZAduMqT0J1C5tNw37kl1umro/1EotCMxWyIXq77iFtciZn5csYy9M5lzaYw/87/hVr
         Yt2kpdUC6vcktWQj4tgHi7uOzuFQXbtmaZKnjbH9zpJXLpcc49EQCkz9fJMP50zE+u0q
         3kP1bWosYTYYoUPhICIvvGFjK4QJRgp5Iz7jfLV615LbYUVYiQJCWZidMXJQZ74cSnrb
         1FKMVD8XMuHjp62I2Ky2BR7j3hGiCrT2fLVs5Kq6reZZi/XEyel41aGKpxRy99JY0/F5
         9YO4MaEH2idoqPl4/3eTWWmVO3p2sv0Rxf1SyKu1CjOimSuWC3hV4W7aXekRYD9TrCqr
         aJSA==
X-Gm-Message-State: AOAM531dKcMSxOgLHpa9mWY+mft1w1AtQUT+3OiNx26wo/Ozj9v2adM4
        8hYFWg0MqG+zVROV7+k+SfAepArSTU4lQA==
X-Google-Smtp-Source: ABdhPJybe2sXayptmTDzA4ihqvbBYhdttDWK3V3puCR5ErhtZ8aNOt2OdSoG4MbS11h8ffFroNYjPQ==
X-Received: by 2002:a62:2981:0:b029:1d4:ebcc:5001 with SMTP id p123-20020a6229810000b02901d4ebcc5001mr1167236pfp.46.1613597339839;
        Wed, 17 Feb 2021 13:28:59 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id ml9sm3017795pjb.57.2021.02.17.13.28.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Feb 2021 13:28:59 -0800 (PST)
Subject: Re: [PATCH 1/1] io_uring: fix read memory leaks
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <b7fcc06fb191fe9f3ce90d4613985f04b8fa2304.1613595724.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <54f35c39-32c5-2778-eff6-77a3cd43b50c@kernel.dk>
Date:   Wed, 17 Feb 2021 14:28:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b7fcc06fb191fe9f3ce90d4613985f04b8fa2304.1613595724.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/17/21 2:02 PM, Pavel Begunkov wrote:
> Don't forget to free iovec read inline completion and bunch of other
> cases that do "goto done" before setting up an async context.

Applied, thanks.

-- 
Jens Axboe

