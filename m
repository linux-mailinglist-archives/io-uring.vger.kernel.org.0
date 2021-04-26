Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB28B36B381
	for <lists+io-uring@lfdr.de>; Mon, 26 Apr 2021 14:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbhDZMw1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Apr 2021 08:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231876AbhDZMw0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Apr 2021 08:52:26 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7194EC061574
        for <io-uring@vger.kernel.org>; Mon, 26 Apr 2021 05:51:45 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id e8-20020a17090a7288b029014e51f5a6baso5138115pjg.2
        for <io-uring@vger.kernel.org>; Mon, 26 Apr 2021 05:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ie15wHFE76bzG+Wxt/79MF6wdJrWeejBS8p/vm45PF4=;
        b=gPNn9QbO/x2+6+ep8RdXTKii7vY3o891ydwruA9Mm6Egq1iofqvwrGDQGksONOmTYT
         5v3k+HL9xqzifguqnNkHS+barYyarLAA2VzXbA6EYbXg/XnjeofqJNlUbOcVtBNwjq4l
         jJYYs/3rMbFtfzs3GB9HDme0TmX2IeJUY3c9IKhj9dQ1CUAXkpNdMhA0UAkMwl/KBXoY
         xVL21lI7A5dx9B1U3AxhZ0qz9BVbrpqtaY0ZxiKLEdalJwvl+L9ZtgkksI35u5WdnPhf
         B2Z6122xu3wCBnD22Gi6hr+l6+O0E6RYapnEAcLO/HaoapheFN9dVpvhYsnK7jMx628t
         AoOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ie15wHFE76bzG+Wxt/79MF6wdJrWeejBS8p/vm45PF4=;
        b=PJy72sW+BLxKMQVcJ5y5eq3joZqgG3KYlkUnXGVd8gWEYDJI9FOpXwrcykYMPQB9uz
         9qwCQv44/7NIkliSDm07dH9Nh6bkdzbbAqpNUiftl2JqcB0mLvtSLFTg/gYHB2G8FBD5
         RPZ5IMVtIoIrdxzwyjxv9c6vAWI8ytgdXQs8YnrbeoLtL8F8ndPL9vdpNjj2gbQ1xmU9
         6cm3ASFZ3Zq0rknSxwFk1iEFutCrd1rRrkW8QnnCysUtvm+OWW/EJUCjn+bA6JF2+SEw
         KQx67tXyKkCVRyKb9DHhWw+c6DhbRcKo8e8dY3oub2q5Y67ZYpBbewrc9kCTq38Yz/Nd
         DdrQ==
X-Gm-Message-State: AOAM530/4EGcYVQn0K5KteRqfg6iFF/GFnPdhuBgUTeJscVkAPBmrSPp
        kCSnCAxfzfmd44hb2XLlPfSfCA==
X-Google-Smtp-Source: ABdhPJycZeWxEAEMvutxAr4Nn+NLUpl9AyywYZpRHWrQ7XW+sELMqfLQLPVrKb5fPV4AKGvJR4VwCQ==
X-Received: by 2002:a17:90a:9409:: with SMTP id r9mr21154964pjo.157.1619441504978;
        Mon, 26 Apr 2021 05:51:44 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id u17sm11156058pfm.113.2021.04.26.05.51.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 05:51:44 -0700 (PDT)
Subject: Re: [PATCH][next] io_uring: Fix uninitialized variable up.resv
To:     Colin King <colin.king@canonical.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210426094735.8320-1-colin.king@canonical.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d65b1763-ac78-acd6-3b92-e28bd4402a75@kernel.dk>
Date:   Mon, 26 Apr 2021 06:51:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210426094735.8320-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/26/21 3:47 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable up.resv is not initialized and is being checking for a
> non-zero value in the call to _io_register_rsrc_update. Fix this by
> explicitly setting the pointer to 0.

Thanks Colin, applied. I changed the pointer to variable while doing
so.

-- 
Jens Axboe

