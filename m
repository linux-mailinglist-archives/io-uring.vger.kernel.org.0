Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0456407F69
	for <lists+io-uring@lfdr.de>; Sun, 12 Sep 2021 20:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233568AbhILSa6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Sep 2021 14:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbhILSa6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Sep 2021 14:30:58 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF59C061574
        for <io-uring@vger.kernel.org>; Sun, 12 Sep 2021 11:29:43 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id a22so9164999iok.12
        for <io-uring@vger.kernel.org>; Sun, 12 Sep 2021 11:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3rarLVmhjlYCLBQP/dFIghpuLAWbLj88vP6T0e8keIE=;
        b=hLJBZhwubj3JFpf6gdUSuPJmM5Xmwh7RET4YKzt2SytNGLpRpOJ14lAHyDpi6j4WqQ
         tjBdsWafGKD1e5q5YmgdAYMJhQmein+qYM41GAeATMBt4Erj9jK5vRcswwWsRCdgA1Zw
         o/VEPFpZW119IBYPwQ8G4aYDv9rsY3mSYhA2bKMlBjCfBbTo0aywG+NwqCL7QFktudtr
         cNx3b+ewrzljtTpzD3veBLObjp2FNGcqrq2sQyGOdwHxG68yutrkclk06Rg20cVRroD3
         jY8jL0yXSs0aYVUDPUeAdJrARHPKRGEaKYZLdPtSOdRgAq+R9KR6iJ8ZrEaeIq7uGoGc
         Exrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3rarLVmhjlYCLBQP/dFIghpuLAWbLj88vP6T0e8keIE=;
        b=ekyx0AO+qUI9WR79XjaRllVQuF6orn7+t25Et/05UmtBMCNeBqbH1rXmR0Mvg8S+3o
         n3BgZ/Bs19zfrL3/eWFepPeVvQFbHFP1u1jlDNPFU14Fn1IKj4rOtOs6BYPA+6tLzri5
         GnU2Ce669rk2q2hXcLCixxXrw1OUPjJehfsYc8o84HFFIBVDXfrX6qiIoaVMxAoE8vrs
         ZpUrmFi5Q/fXyajtwEjannw27XiiuRoP1Nxm+VOYCRmMoCX5Z68GxL+uDvelk51+lySb
         rdrxu5ZcuFY+K7JhryydgjTuTvNeTQdKBmA9LXbQPR01I/2KlgAKiG6A/u7lmVP9lrhL
         m0fg==
X-Gm-Message-State: AOAM531Lw3mEcLVNSMRs6IfnkhDB4sscXZKtl2RZutIOCWKg62mk8Ve6
        COIidt/qTRG03aQVVMUz7YH+tg==
X-Google-Smtp-Source: ABdhPJwVwJgSLhPe0+BW+Sq74zac2nHWb5SRB41ZT3wL3Lu6eSg64DEbxo3/P7URMgWaWB9IesOyjg==
X-Received: by 2002:a5e:990e:: with SMTP id t14mr6060888ioj.75.1631471382926;
        Sun, 12 Sep 2021 11:29:42 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id b8sm3212270ilc.41.2021.09.12.11.29.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Sep 2021 11:29:42 -0700 (PDT)
Subject: Re: [PATCH] io-wq: expose IO_WQ_ACCT_* enumeration items to UAPI
To:     Eugene Syromiatnikov <esyr@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Dmitry V. Levin" <ldv@strace.io>, linux-api@vger.kernel.org
References: <20210912122411.GA27679@asgard.redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a6027db7-3ebc-6f12-2b58-4b068a346ee2@kernel.dk>
Date:   Sun, 12 Sep 2021 12:29:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210912122411.GA27679@asgard.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/12/21 6:24 AM, Eugene Syromiatnikov wrote:
> These are used to index aargument of IORING_REGISTER_IOWQ_MAX_WORKERS
> io_uring_register command, so they are to be exposed in UAPI.

Not sure that's necessary, as it's really just a boolean values - is
the worker type bounded or not. That said, not against making it
available for userspace, but definitely not IO_WQ_ACCT_NR. It
should probably just go in liburing, I guess.

-- 
Jens Axboe

