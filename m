Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90ACB40AF71
	for <lists+io-uring@lfdr.de>; Tue, 14 Sep 2021 15:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233445AbhINNoY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Sep 2021 09:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233695AbhINNoS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Sep 2021 09:44:18 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786C7C0617A7
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 06:42:06 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id m4so9010774ilj.9
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 06:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yT0Hj+KTZdXSroUBg7QXQjWe5/JN6EeSA7F81Tbx41w=;
        b=s6bTylrE0PPJrh7deyxvMVGhx1FDYrYCQb1CRuLZ0P2JdHMAx25w9fZDC6HAqzyB+Y
         w32h6aPioNYZZGDaxXn6KTibvuU9js2IcUWUdkdStwP+dO6UiaYh25dOpRKC/HkWIPGT
         Oh2yBmUG+jOCdI4A+SRxJr4H9AO2ZuFCTkc+ZASPtmr9F/+z2XRuWruI+zMj2AXZO+gm
         R1ze5Ez4foqhiUIfZKotOnkrP2LNB1EVxXx4K1w3yBxJM4mQQb4NPlPuyq/7T1SZ5WpD
         8uE1WkKUleIunjnHK/PH37RAk/QoC2pCzqHVkr/S+70zZc5BxNryhE9+JPkuKqO/8Yxl
         Jc2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yT0Hj+KTZdXSroUBg7QXQjWe5/JN6EeSA7F81Tbx41w=;
        b=S0xhHSH2+RWrzkbrOWSpxMl/UDi/tSDk5UNnLWv0R8xR0mZ94bcAjtQ8eETAWyRvrd
         zhvQfykVWe+hCrsfEFopk4ncWs7mLBjQydBtsvAfSQgg79IRXK302vtowH0hBYQUvQyX
         dNfDNAxnyWuT353I/vMKOImDRKoohPyAFQUfReT5u4DJ62X9lTy/KgAZbb8najVxEYSC
         yMBzEwhFT6ihhIfL1p9wYhDhGG2uURrOr3FRpsurwYV/55lEEd/K317FKFHuvERdoE2S
         FSk+RC2o/5WnWO38Xm3w0HxvRpPN6s7dTO9/0tpDN1Dtv3HfL1HJBjx+aYgUeH4VkL44
         wgfg==
X-Gm-Message-State: AOAM53105lnAecy5wOkHES90DI1vDx4277Gs0xFiIzgGNe9Z2VgUr10n
        TdjOjFC03Br1cNbbO0nbFKmpqZJ/LBff6pNpL6k=
X-Google-Smtp-Source: ABdhPJw77IyxsU/HCL9A99HJn+Jby5Oje7o2AFp1YQDsTDN3Tncpv/uAiPARUFISH5FPHDwya3CLng==
X-Received: by 2002:a92:6907:: with SMTP id e7mr12249235ilc.301.1631626925788;
        Tue, 14 Sep 2021 06:42:05 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id o15sm6932854ilj.69.2021.09.14.06.42.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 06:42:05 -0700 (PDT)
Subject: Re: [PATCH] io_uring: add missing sigmask restore in io_cqring_wait()
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20210914084139.8827-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <45cb9bb5-3132-6873-a423-d037e6db01a5@kernel.dk>
Date:   Tue, 14 Sep 2021 07:42:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210914084139.8827-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/14/21 2:41 AM, Xiaoguang Wang wrote:
> Found this by learning codes.

Does look like a real bug. But how about we move the get_timespec() section
before the sigmask saving?

-- 
Jens Axboe

