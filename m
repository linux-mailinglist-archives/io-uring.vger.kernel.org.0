Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB082F9318
	for <lists+io-uring@lfdr.de>; Sun, 17 Jan 2021 15:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbhAQOxn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 Jan 2021 09:53:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729202AbhAQOxl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 Jan 2021 09:53:41 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE84C061573
        for <io-uring@vger.kernel.org>; Sun, 17 Jan 2021 06:53:00 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id cq1so7821078pjb.4
        for <io-uring@vger.kernel.org>; Sun, 17 Jan 2021 06:53:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qIkxR6ZlazhWRSFmEQgZfcSwNQK1J2uWe9Ybv2+Uv6g=;
        b=UFk+VKbjYySq4j3+7p5GrFYjjk0UnMSVJiCyKn7u7o1llJiKCIH633TX9lVoyS60iv
         4hsEl/JQrhXCC/FXtdEhNw6KEmjasEezVSTgapUQdZvFyrN62fvGjuhvRlzuwO1PvfjY
         sI3U0oW1IB+9Y/VYr7lWM87ocS/XJcmp943yU3iPZ3l0mTcWlh20mTBqZhLVa2yt46Py
         s/eYH0XbWFFT7fZVAWCWjx1FaS8ZTm1Kc2UQGbcqw7aajdNKtveLtlZLVmyaoZnSEtN9
         3Szqyz76A7faWgpET+EobbBBzQ3TcgVKNurvQG9go7Ghf2f4rh3MDManj6WozzVZqydx
         2v5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qIkxR6ZlazhWRSFmEQgZfcSwNQK1J2uWe9Ybv2+Uv6g=;
        b=IuT448s1dTt2duw8bGBd4y4KvFu1MbryH1yxzKbm2dsYeCoRGXO+tmRHk5nlbK2QcG
         NDmynnhZxzJIVBT5svgalz1BuKks4t0CkydF37A9DQVL7X7+8z+h5NDRzKB8FD0l1xB4
         kzyYlTsSSCDNWsihtYfwAYxKZGvMsz/ZENsFziLZ9iQ5bnKvnIF3bf4OAEtvaBaZTWkz
         WHPGu95unF1kENc08e/pYfN/9RDLriNDAuvkMHjWtmSLy+u19kTo0i/SFSF293zKomOd
         luErWYB9MXbDK5DgFXnrBaGbpZS87VGaU/jkmzEua4y7umr1itSgTvimZHTb+b9nJwk+
         EK+A==
X-Gm-Message-State: AOAM532fnDaxuhPPNUr/J+7mat7sMzPSUDjD61yxOzVshtR96u8WRwP6
        LDSTfg/yT/QTUmzjJIsli6cRBhMslq8WEQ==
X-Google-Smtp-Source: ABdhPJwmoeM/ORCCGoMkPqDcaIf04pE71grUqcglpn/gLA5CA+fK4H2LCOTspd6x+bJFnoHBoffvNA==
X-Received: by 2002:a17:90a:708b:: with SMTP id g11mr20695884pjk.23.1610895180045;
        Sun, 17 Jan 2021 06:53:00 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id z23sm14369289pfj.143.2021.01.17.06.52.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Jan 2021 06:52:59 -0800 (PST)
Subject: Re: [PATCH] io_uring: cancel all requests on task exit
To:     Josef <josef.grieb@gmail.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <4d22e80b-0767-3e14-fc13-5eca9b1816fc@kernel.dk>
 <c41079a5-5f5f-ac58-e01d-792e4f007611@gmail.com>
 <CAAss7+q5=W94YF+6Ts+jyJSNbs=2hD+OMbY5zZtZNkrJfMWjpw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f2429b7b-eb85-ed3a-6fb3-835b02e65b26@kernel.dk>
Date:   Sun, 17 Jan 2021 07:52:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAAss7+q5=W94YF+6Ts+jyJSNbs=2hD+OMbY5zZtZNkrJfMWjpw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/17/21 5:51 AM, Josef wrote:
> thanks :) I ran several tests, I can confirm this fixed the issue.
> Tested-by: Josef Grieb <josef.grieb@gmail.com>

Awesome, thanks!

-- 
Jens Axboe

