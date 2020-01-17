Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8E4140320
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2020 05:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgAQErc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jan 2020 23:47:32 -0500
Received: from mail-pg1-f175.google.com ([209.85.215.175]:45466 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgAQErc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jan 2020 23:47:32 -0500
Received: by mail-pg1-f175.google.com with SMTP id b9so11017384pgk.12
        for <io-uring@vger.kernel.org>; Thu, 16 Jan 2020 20:47:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=A+4aYu/f+LLI3Jw91RLfV6RdAoA39tW2N/DHyvDL3Ik=;
        b=sxc0BE3OoszJC5FcjG40xTs59ymbvxykkUk8mBvmvm13L2O1sRFFxW7xoQbhpSHgf5
         zBpes8RCdcKhjcpAYj+e1ZpMYfNZb+V3G9DsJxiAOG7j3D06dMgyaXqV6aXcGkpliwi3
         +O7pml11pdBF8JcPPKcJ5hhqz53FCSgApNqw1/SVeIJFPNbpz+SBuBC3cD8mtpZwOewv
         FmCsN7Y72mFfR7chMz/5lm3hczCSBAA81+964CHZyVYUER3aw2clkom8/7Ul9tP2abxW
         c6A37jME6MCwBQ4tjff8WLidrVhe/bqqnDNBYqfQMtgGA8zhJBp6z6SfrQxSpSBPAYpp
         vzRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A+4aYu/f+LLI3Jw91RLfV6RdAoA39tW2N/DHyvDL3Ik=;
        b=YCMpI2l4DbSBXIcGw/wKPuPSig1FTWpcaBlRbWzJmcCddYLhkAHuBOhugqWd+GTWOp
         8Y5eCUSybxYsPIaAvh2vNyv3T3B+GTFbwSgohOtd7pI3NSxTpwD47Pm5D43DqlQJPSPk
         lPPAUsQ/2L0UAPKLYGeHciYWSglhK+XU5bgCPWntQJQxqni17LQXBm3OG4XQecU1piIu
         t4CW5xTCr247juSootxgj1yYI9r1Iqt+A0sRH2PVI3omyG4ql+8X2LXGMTDgdbaTvfKx
         PimuYzfBFlNTkUow+2+9XhAlhq6PJePzMR0rOGWr91H2QeuOw0sPDsTOCXQEiSL37I1H
         A7GQ==
X-Gm-Message-State: APjAAAXGT8R7rCO1bM5ZZ32WyDRyGHsNIJkITtwACSondLq0u8EFOKYO
        8WLnOiT2xOd0t/Hb+ZiOln3WdQ==
X-Google-Smtp-Source: APXvYqzvatyId/eBVFoH3KLoXBu5HUCClzB9UM6crG/QSDY1KoMfVERKvTxmUsdwdnzcWDs810WGXw==
X-Received: by 2002:a63:d906:: with SMTP id r6mr43590024pgg.440.1579236451548;
        Thu, 16 Jan 2020 20:47:31 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id z26sm28299448pfa.90.2020.01.16.20.47.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2020 20:47:31 -0800 (PST)
Subject: Re: [PATCH] io_uring: hide uring_fd in ctx
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <2aefced4902f33f2b70aaedc32bc8d60a20efd7a.1579225489.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e0d0eaea-3bda-ec22-0da5-8cfbeaf3f42d@kernel.dk>
Date:   Thu, 16 Jan 2020 21:47:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <2aefced4902f33f2b70aaedc32bc8d60a20efd7a.1579225489.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/16/20 6:45 PM, Pavel Begunkov wrote:
> req->ring_fd and req->ring_file are used only during the prep stage
> during submission, which is is protected by mutex. There is no need
> to store them per-request, place them in ctx.

Thanks, applied.

-- 
Jens Axboe

