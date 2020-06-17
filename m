Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3455C1FD116
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2020 17:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgFQPfN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Jun 2020 11:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbgFQPfN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Jun 2020 11:35:13 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9454EC06174E
        for <io-uring@vger.kernel.org>; Wed, 17 Jun 2020 08:35:12 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id n2so1080235pld.13
        for <io-uring@vger.kernel.org>; Wed, 17 Jun 2020 08:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Tk0TvGFhZFPRqzY7q78VE+edqy3NZsXP9ABwm3yLluA=;
        b=WgfTX+Zh1917qaa5rZVX+Vx2IRjOPKFYE4Z9V7iZ4gXwMYBDipA1a2wXzf7jjoj/bC
         aVu/81GHaTYYfJ6RJotM9s8HP/AFya1wXNG4OiC8QIVebX1DYhK/iG7/m7T5ZUDswH13
         YOyyN9tI7T65xx5bVq+bCj0J6ajeBuVQTNROmBq4clc8pB/JpeCXVfTvN2/jDISDWKOR
         tUMkbj7JWk5rmj6a7j1b0F7SYrHHfVPS7B5Iy5ZlbpwJNRr7wZ9gehJADzOjS5snumdP
         0esgtFmCQrZYG0AgNl2ih1Vy1Q0tx/a2N2ABpPPEWBhY2Er89YO/3P8o+D30BUYYpIZk
         XdSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Tk0TvGFhZFPRqzY7q78VE+edqy3NZsXP9ABwm3yLluA=;
        b=lvm7/gt0VlsQfRHj3KVcawLmkC/nWZ7u2vFPYiwVt7FNHV86wCZ6K9EweRHz/8jkYP
         kl0rSXEpIaAGPF5r8/j3H86H0CfilyzHqo9RewApzuRgDGk2rWzY3OEzsawU/0XiyNLi
         A3oIwY/DI+KTmge/QET+y4+LE44AcLD7GitPLBJhsm+xoeRSRacM9OGJhjqipbpBzoTj
         LU1HOSnqTb//5gZ8E/3XPx9konbS83RK9uoHJrmePT8zbnfNPvG6QScHj/18swnO+QW7
         byce7iToLcNyIpMSoLuv8EWd3AQxbmr5tVo4zj5RuoMaULHI2u+7tuKtC5NojHgyJYeR
         Vn9g==
X-Gm-Message-State: AOAM530Dl2+yiG5HIEqtyQGV9lHa9eAi+Iul2fy/6WBr17S7OeHCI/vt
        7Iq6CXjX/gtOAs2SOktqoPd08lLVWlBvMw==
X-Google-Smtp-Source: ABdhPJwbfbmiBTiEKOIdwHcznHBCTx9IgtRk4Ri3xF//LhmGooV9vlpRSKJw//R472Y+7GakVIfpsw==
X-Received: by 2002:a17:90a:33aa:: with SMTP id n39mr9075812pjb.226.1592408111637;
        Wed, 17 Jun 2020 08:35:11 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id f3sm3392pjw.57.2020.06.17.08.35.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2020 08:35:10 -0700 (PDT)
Subject: Re: [PATCH 0/4] io_uring: report locked memory usage
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Cc:     io-uring@vger.kernel.org
References: <1592350570-24396-1-git-send-email-bijan.mottahedeh@oracle.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <79777f42-c291-deaf-7496-c7c729891613@kernel.dk>
Date:   Wed, 17 Jun 2020 09:35:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1592350570-24396-1-git-send-email-bijan.mottahedeh@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/16/20 5:36 PM, Bijan Mottahedeh wrote:
> This patch set adds support for reporting of locked memory usage.
> 
> Patches 1 and 2 are prep patches to facilitate the reporting.
> 
> Patch 3 reports all locked memory as pinned.
> 
> Patch 4 reports ring memory as locked and registered memory as pinned.
> This seems more appropriate but kept it a separate patch in case it
> should be dropped.
> 
> Bijan Mottahedeh (4):
>   io_uring: add wrappers for memory accounting
>   io_uring: rename ctx->account_mem field
>   io_uring: report pinned memory usage
>   io_uring: separate reporting of ring pages from registered pages
> 
>  fs/io_uring.c | 93 ++++++++++++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 66 insertions(+), 27 deletions(-)

Applied for 5.9, thanks.

-- 
Jens Axboe

