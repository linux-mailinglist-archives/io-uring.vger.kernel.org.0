Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63E47394EE9
	for <lists+io-uring@lfdr.de>; Sun, 30 May 2021 03:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbhE3B31 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 29 May 2021 21:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbhE3B31 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 29 May 2021 21:29:27 -0400
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 089B1C061574
        for <io-uring@vger.kernel.org>; Sat, 29 May 2021 18:27:49 -0700 (PDT)
Received: by mail-oo1-xc36.google.com with SMTP id f22-20020a4aeb160000b029021135f0f404so1925493ooj.6
        for <io-uring@vger.kernel.org>; Sat, 29 May 2021 18:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DPFdCCl/s2s6lbXPJyYAWv3Te0PvnT9TKjEFnvCftx8=;
        b=oT7b72aik5yVko6ga/CjdEaqeSnrdG2Q9O1qOcvqmLD0xaJRqXhZ+XGYZf4u4DE15a
         DUqSo+jnL0rMyd6hPyYXR7brf65GqVkPawDJktF/EZj+yq8YPpT79JRO2vRxqHCE0YwT
         f3V9Q/07E72PYHmzmQ1YKvZhaYLh9rFsofc4sfJ1vsr5mWkZAQRrQwcGXQUs9FutMAtH
         t4VRg2SM72501sl+hudG8nYytVDH1YFxZzCUoo6YDV7a4NULzSXzA6meS2MqLFIHBmjz
         5aIMniVW2yjdjaUVJt49IvqncPFMAwpAZ7S9IvnttuXVsVMIHgS7Ieg7rRaWoTNK90B6
         6nhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DPFdCCl/s2s6lbXPJyYAWv3Te0PvnT9TKjEFnvCftx8=;
        b=JqI27LdJF3QWnb1tSjnnVyn7nqB6WJbTels6cpceMlDfk+kmAhYOiaD+shyWGIdiZw
         7AehUSiYotx2iwsOuRGRx4mkZ5msoXHuACQto5xCPgE8EW7HHZpnyeJQPzBAmAWPZoPY
         3ICzY5Wxq8JSEJ9RIUTs14/KXtpnOYbus3U6jjtnhj7N9CbsRLJKRllR3uU1QDj9IT/y
         cE/4rBgUZB4AEqzB3LZexF5E/lhlSA10tmx/9xLZ9Zp8tlbhwNAdMei/lLeNAMLOC9SK
         8Mme8LPDWzkVN30/mpXXPjvch3kommWewLSVFuve3b3V1obVyFC5xkfAVJNd8b2HpXNK
         tPsQ==
X-Gm-Message-State: AOAM532M31BOxHocfcdg5M4q2/zM/lEoOVkYY3XTnVSeQPPBg+vnc+Uw
        J5eUtjBbZigZw2BTECidND3Er1KeblFQzw==
X-Google-Smtp-Source: ABdhPJzJ03ObC/X9hDRLFlCIz28fvut27nA2kZoz022Ik8bXvTgiB1fCh6+qoJs71KU9dacLcdZ80Q==
X-Received: by 2002:a4a:b785:: with SMTP id a5mr12112722oop.75.1622338068330;
        Sat, 29 May 2021 18:27:48 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id x3sm616521oov.7.2021.05.29.18.27.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 May 2021 18:27:47 -0700 (PDT)
Subject: Re: [PATCH 5.13] io_uring: fix misaccounting fix buf pinned pages
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Andres Freund <andres@anarazel.de>
References: <438a6f46739ae5e05d9c75a0c8fa235320ff367c.1622285901.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6aea2172-adc5-e1bd-1c53-b3beacc07fce@kernel.dk>
Date:   Sat, 29 May 2021 19:27:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <438a6f46739ae5e05d9c75a0c8fa235320ff367c.1622285901.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/29/21 5:01 AM, Pavel Begunkov wrote:
> As Andres reports "... io_sqe_buffer_register() doesn't initialize imu.
> io_buffer_account_pin() does imu->acct_pages++, before calling
> io_account_mem(ctx, imu->acct_pages).", leading to evevntual -ENOMEM.
> 
> Initialise the field.

Applied, thanks.

-- 
Jens Axboe

