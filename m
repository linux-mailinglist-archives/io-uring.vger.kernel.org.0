Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E21B02ABEF8
	for <lists+io-uring@lfdr.de>; Mon,  9 Nov 2020 15:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729454AbgKIOmM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Nov 2020 09:42:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731542AbgKIOmM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Nov 2020 09:42:12 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3BA4C0613CF
        for <io-uring@vger.kernel.org>; Mon,  9 Nov 2020 06:42:11 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id s24so9956525ioj.13
        for <io-uring@vger.kernel.org>; Mon, 09 Nov 2020 06:42:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=8k53XswKPYw4AOWwjpamRMFPI0qeV6Lvs8hWXNrliJk=;
        b=pEWV4X5ETNA1XikDk1gN29e1GWBRpHzrAsWpxlT2RFs7p0aVjMgwPnudZJHlGoPYn4
         Fasc86jOSCf6C/4HEqzrogA9zym/iS2P1FSZCq0eQEnXBwiJ0YrjGfXqm48QT66MrFbE
         K1iUHHt6rb2jhf4OZMnxMA1CaYfUs/9c5nbN2gCzLgG3hVQxnTrGLgAzKXN5IBO4T8N0
         PRLLzi6bD+ciF7jnG3LINQulp/fptTpVEYqzrX8RghVjSrgpOeT6+P15OjQbYWZ0kXSN
         vE+Ba7kPypZFFpLPvFqEREf/Nz8X83NMNOdC+EG0etYBwN7PKxGUcGlgEXj3+ceaTLId
         +6qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8k53XswKPYw4AOWwjpamRMFPI0qeV6Lvs8hWXNrliJk=;
        b=lQPKr/9ZVNrdEgSsqEUSjnFQJHu2PyNMI5Wg2i9hcB2VxXIgZTx2HXl9ZHVFV5sT+a
         s7PQn7sSVJU2JYCX1x2sgdXNFGLPoA7p0vzdBHZ8D/pzqacykXg2Y8mp1N/Y4LgR+DrZ
         goLrsX2RoLkJ3lb25EDGj/+UB6l9FheSVWKZ9R6oI6Q6kdGGw+7+M40l1nrU/aXIT9UC
         s1rmOq2LmqO0mZHO0M+PfR889kBXVuulVU/OP7suTnLt30NP5Rzi0G6EUQv2SnPiIsLA
         mw2mO4mTnF8cszi531LT8mYY0gNqACouPnB4UFbjPOkduOU1q2IjxM+rPcrH0eukYYtv
         MJZg==
X-Gm-Message-State: AOAM5339LcGHc+IMn7OOEs6NrN5YtrGEMou4h4DQyiyzRdgfxr2bQ9kC
        4F3baLzRzW6veKRhNxbF85xhZN7YutMcQg==
X-Google-Smtp-Source: ABdhPJztCDhVa7hVet7pHtuMYKv50cUDkaRmKcT4WnN/AdL22TGyeyor3X+xNXge1wBXJnJkzkiAdQ==
X-Received: by 2002:a02:ba90:: with SMTP id g16mr11037282jao.96.1604932930993;
        Mon, 09 Nov 2020 06:42:10 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id f77sm7349020ilf.40.2020.11.09.06.42.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2020 06:42:10 -0800 (PST)
Subject: Re: [PATCH 5.11 0/3] rw import_iovec cleanups
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        David Laight <David.Laight@ACULAB.COM>
References: <cover.1604754823.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8c69974a-27c0-c426-c72c-26a6e6511731@kernel.dk>
Date:   Mon, 9 Nov 2020 07:42:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1604754823.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/7/20 6:16 AM, Pavel Begunkov wrote:
> There are a couple of things duplicated, it's how we get
> len after import, vars in which we keep it, etc. Clean
> this up.

Applied, thanks.

-- 
Jens Axboe

