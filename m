Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E257532931D
	for <lists+io-uring@lfdr.de>; Mon,  1 Mar 2021 22:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243001AbhCAVC2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Mar 2021 16:02:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243708AbhCAVA0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Mar 2021 16:00:26 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA979C061756
        for <io-uring@vger.kernel.org>; Mon,  1 Mar 2021 12:59:44 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id 81so15683317iou.11
        for <io-uring@vger.kernel.org>; Mon, 01 Mar 2021 12:59:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=48QB3AJchxjOuxFmO5Gex1OPGPdmgi/HQNmhW5ZsUsY=;
        b=UTZh2txlYKN2aLTXDEB+24h9eSo+Og7UB9bbT3MInzA3h7ZL0hmSdb3cuHX7WB9pBi
         tjsm50SW77ag8Qaq40XZPtyffTOdX1xcgeQNV5Wop2hVa84+3clSY+p2OoDeRmzmWVsk
         tDF+TkP649432JQyRzFU+ghw2+GavPjvGONh3wK9wztvZV6wZUAOZXXyqbK8A0hTuAU8
         m07CoLuMq15OK7FIIc2EYMnIw89ekrT2A8M935Hc4LkdF0bupjQ0Tvvx/Xg2lF7mnW9P
         RzfxNRD5r8SgtxMLnCLHrM5Fugo3dLLi2cedUc/a5xJCwWNZBbcCiQ6oVql7waNZ9Wh9
         uhXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=48QB3AJchxjOuxFmO5Gex1OPGPdmgi/HQNmhW5ZsUsY=;
        b=pbYo2MYfhduyqBiv7qjURaM1bDv5ZPYv5RwCSMahFQp6Ix19bwI2e2xIGS7toF6iVc
         Btirq8jVZQjIfzjKGz7Cu5fMKiYyGOQu/825mndyQZ97n15jLJhnE+DaJmsZFcpxvtRS
         bz0n+UztdYJva8bTe4a3ACALyzeAk6PxZERP9m+qpCfcXDbsZlrLI/tiguKJxDCHXsi6
         bVr71z0AIM2NDXFZ9rWhHYDcPFDlB/kM4vMNmlIxOLWrd1qdM7DDEslmyifN1ejE1LJb
         Ejqfc1tLOmJeygaVeagQ6i3dxaTWJ9f0PTrdXZhUtBGARs5FIz5Jm22D/ksopjCFZsAe
         +vWQ==
X-Gm-Message-State: AOAM530j1K+u54t3hksBQGI88Sxn1w/3dqJnGLDOunJJMpQ0AQKu17+2
        het4pTllf2FIJLmExSbpm5L+aubbFNsk3Q==
X-Google-Smtp-Source: ABdhPJzccbvTMDDUGnleP2Ltsc1zehdn7PXgn9efq36WWjXABK9AUex/pUnGawFAZ8rChefZCgDs+Q==
X-Received: by 2002:a6b:610d:: with SMTP id v13mr6799709iob.132.1614632384108;
        Mon, 01 Mar 2021 12:59:44 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id x17sm9777183ilm.40.2021.03.01.12.59.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Mar 2021 12:59:43 -0800 (PST)
Subject: Re: [PATCH 1/1] io-wq: deduplicate destroying wq->manager
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <d419494ff45686994526804a0b27e18f88da776b.1614629733.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6c13e952-d6fa-2595-255e-42444d380b44@kernel.dk>
Date:   Mon, 1 Mar 2021 13:59:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d419494ff45686994526804a0b27e18f88da776b.1614629733.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/1/21 1:15 PM, Pavel Begunkov wrote:
> Add a helper io_wq_destroy_manager(), for killing an io-wq manager and
> not repeating it three times.

Looks good, thanks. Might try and fold it in, but we'll see...

-- 
Jens Axboe

