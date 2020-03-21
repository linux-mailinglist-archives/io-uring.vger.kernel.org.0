Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 129F318E423
	for <lists+io-uring@lfdr.de>; Sat, 21 Mar 2020 21:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbgCUUEY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Mar 2020 16:04:24 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33282 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbgCUUEY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 Mar 2020 16:04:24 -0400
Received: by mail-pf1-f194.google.com with SMTP id j1so2533505pfe.0
        for <io-uring@vger.kernel.org>; Sat, 21 Mar 2020 13:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0yWNdhbNqUfEkD37i7L/ncMrdRQ29Z5bEYy+5u8eoYQ=;
        b=HcVr5i9o5oCW01QPAvbEDNG324LociUR+9LKohOJ5IKS1mrjn1j5M8cHO2sySOpA20
         cx/Xn1TiutVOcrf85KmgfBjSXAp27Fd/hunCt8peBjZMBJjg542xv3DUvoaOjxMlk3FR
         Qd2jxLXqR6mgN47VRgD0Q8xTjHkMHbwoBrA/ScdrJXVKGLylwNEJGOeaG68rWx21UCFa
         jj68KvNncqmh1mLHZjT6xvHqaHH7tT5LrW2rOSwodapSb/cF+e19A7CWXtIGtpAmFdXm
         Fe6LRHS9z9j8pc3XreILTWTjPwDg/2K1gPB1VATzPR/1t9/Im7Svqv4w31ZRA7+BY1SM
         iwlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0yWNdhbNqUfEkD37i7L/ncMrdRQ29Z5bEYy+5u8eoYQ=;
        b=Pw3hnhWQ4zGCDx2SxtWien5DQAtXJMzrFxdgcqXNXZvXtfTgcCjatzlnyovmllelrX
         0sgU3aJpQAWfo1vfu0BNPc12FuSX0AluRZQGcuC8vCBuICpK8D82gKWQsD45V7sO5nS+
         wXPW4jktYj+v6zT5NDdv27pjWLJvRzZ/Ul9zqywwTx2nnbxsMkEhxG5VL6O/rq89oyRk
         OrSoNh61NtoJ91nlHrV4G3+x9s2eCuR89+bGnlW/aKTSHPaL3SyaO0Lgbypx10pcXyG0
         rRpL9WwceVtPhW/NMttnjhRCUl462sFKNvRGtqMpFaNWDjPEyMOOSzzfi7R+BUkwmiwK
         3RPQ==
X-Gm-Message-State: ANhLgQ1Nd8FNTN9370bRLpexHep6/r+gmeiVP4LRUYNI+5DZFeNbRPx6
        LLigwkOE0BFM/LCJZvtWuwzzBg==
X-Google-Smtp-Source: ADFU+vs74gsoENPjoVn6vbEMdqHzLNWCa20HEGJHf1sJUt1BCtuYcetvcTFyAOMetLNufk0xP7ENXg==
X-Received: by 2002:a63:1c4a:: with SMTP id c10mr15119782pgm.252.1584821063790;
        Sat, 21 Mar 2020 13:04:23 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id u3sm8023157pjv.32.2020.03.21.13.04.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Mar 2020 13:04:23 -0700 (PDT)
Subject: Re: [PATCH] io_uring: make spdxcheck.py happy
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>, io-uring@vger.kernel.org
Cc:     linux-spdx@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200321111907.6917-1-lukas.bulwahn@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <aa248c14-8e3d-50e8-0b54-8e807965f771@kernel.dk>
Date:   Sat, 21 Mar 2020 14:04:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200321111907.6917-1-lukas.bulwahn@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/21/20 5:19 AM, Lukas Bulwahn wrote:
> Commit bbbdeb4720a0 ("io_uring: dual license io_uring.h uapi header")
> uses a nested SPDX-License-Identifier to dual license the header.
> 
> Since then, ./scripts/spdxcheck.py complains:
> 
>   include/uapi/linux/io_uring.h: 1:60 Missing parentheses: OR
> 
> Add parentheses to make spdxcheck.py happy.

Thanks, applied.

-- 
Jens Axboe

