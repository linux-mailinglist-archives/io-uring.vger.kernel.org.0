Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79B0A1DB4B4
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2020 15:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbgETNOJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 May 2020 09:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbgETNOI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 May 2020 09:14:08 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F0D4C061A0E
        for <io-uring@vger.kernel.org>; Wed, 20 May 2020 06:14:08 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id a13so1314475pls.8
        for <io-uring@vger.kernel.org>; Wed, 20 May 2020 06:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=itYQ9Ad5DlZ53sgnqKZUBDjddneQB2MMq6HEh5Hrogo=;
        b=jksE4XwiYjUhV09Sz7Eu6a4F5lv5JsKXWwIfHpwM6d8/OJDLVT8x91ZQf6or6s8e/0
         GT92RIa3s/QSak0WOdurffKm+gZrt9/TVV68j0sdIZu02NLShY5wNI3CGHIt2sERiM/L
         phwsGAmUnbLfef27qwNsmFkNIoW8rWUIp7dfdHlTi/mczdCBnKZP3WRidm1Qzys1H7Gs
         4RNh+CZ4q5NiVkZmCPJhmW051y6AjxrtziXMLfbsXtm/s6y2rM9h+KDv2plsRUtlYu8m
         lrcm0abWZpJgxQqsmKQ9wpWtylpxViRTZFl4lm4Q16wc6x3zmrB5at8P6HiL0kRr0oXK
         NMuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=itYQ9Ad5DlZ53sgnqKZUBDjddneQB2MMq6HEh5Hrogo=;
        b=lwSu2Yn1qEEGQsmxrjWeGdnisXgnEzilcjPnrL8Ed/+L2mDizRFHg1kjFNyxIE3Fpy
         k2LRrpWusAi1xDVCikHJLO5PGTlUXvqdi1qZMnl69OQcrvcYgjBwGBmbS/AadoWWgnVi
         npmNWusrBgrHjkC/goWU2efxnMKqkB2ezqWDAjJq96UyRQrFwQYTOO+57+i2joT4wMVF
         XDabseUSakBwhwfDME6M7yHVsnEBIYeBD/Kzc40GXYulx5+uxTgkbXj20IfOUQR5nVJQ
         wPqlBPgKxZ4JtaAU3G70pOXZTt1PcEwIFHSZE/Stv0QJnGLrKX+pQ8fJnCLvBMuo/sZ3
         NbTg==
X-Gm-Message-State: AOAM533Wr8x3KssVDLkUVNV0opwPhODKiOWP6pGlMrui3STTJiYcfvRc
        UsUI2opcOm9qTjpzZc5YUMrCoLAqTcY=
X-Google-Smtp-Source: ABdhPJwVSKOwl+5YC20UlxnpAOxr4ZLiPdd3DHbtsSFaGjP4dONE24aTClK/aOpQIJKylcMLsOOayQ==
X-Received: by 2002:a17:902:8546:: with SMTP id d6mr4265505plo.164.1589980447832;
        Wed, 20 May 2020 06:14:07 -0700 (PDT)
Received: from [192.168.86.156] (cpe-75-85-219-51.dc.res.rr.com. [75.85.219.51])
        by smtp.gmail.com with ESMTPSA id c14sm2110311pfp.122.2020.05.20.06.14.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2020 06:14:07 -0700 (PDT)
Subject: Re: [PATCH v2] io_uring: don't submit sqes when ctx->refs is dying
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200520073503.19087-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <35f7dafb-fdff-15f5-94aa-6f1efef5eadd@kernel.dk>
Date:   Wed, 20 May 2020 07:11:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200520073503.19087-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/20/20 1:35 AM, Xiaoguang Wang wrote:
> When IORING_SETUP_SQPOLL is enabled, io_ring_ctx_wait_and_kill() will wait
> for sq thread to idle by busy loop:
>     while (ctx->sqo_thread && !wq_has_sleeper(&ctx->sqo_wait))
>         cond_resched();
> Above codes are not friendly, indeed I think this busy loop will introduce a
> cpu burst in current cpu, though it maybe short.
> 
> In this patch, if ctx->refs is dying, we forbids sq_thread from submitting
> sqes anymore, just discard leftover sqes.

Applied for 5.8, thanks.

-- 
Jens Axboe

