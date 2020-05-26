Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06FD11E298B
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2020 20:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728761AbgEZSDP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 May 2020 14:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728445AbgEZSDP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 May 2020 14:03:15 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6364C03E96D
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 11:03:13 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id q9so119614pjm.2
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 11:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=+3D93OdvzuNAS+/2pVk3LjUucF4nmiUUGgFK0NpFcMw=;
        b=u/ZRPnBTRQI4xng9kUTbPBygrFkOgmR+gilKAQglT/PMcwMAIpPff2+accAg07GIPs
         kONvnDsrwwCzXkYnYUHhkfqkGO26bQkCPaKt3/DPVWuVzasMnH7Uo9cNaU0BqcmLXj9z
         jnBtvfYnWEx29e6l/rmHGJ7PCyNK/OYUclekxMrbUAh5Ilh8PMuEneblUHlmjWSEyMxX
         C/9VTL/RZ9QLE7IOBg62OGhsxaT9cY9EvMBZY7crhviPo+aW9jXO8Quyl+l/wuRQwwLQ
         HyJAX0HhbVCfEwzbUubIGUO31TL5dxqCFtUGvDLllffArudoCfOIFhiTS6JsIEnFwhDt
         N7xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+3D93OdvzuNAS+/2pVk3LjUucF4nmiUUGgFK0NpFcMw=;
        b=dSHpWN8XvljZnfWpX3EqdDyr23V1exWthDJBmvLSam1MtVAFf88iFAi9qhpoA29FZB
         98xkARKwiHxgOYi3jkT535HVl4c+vldjj9EHOq/cRVnxNOjXtzWi2RqwJcbO5mAzwcM/
         XBM9PPqA7njpiF1eqyiakXJetzOsl1ufukmKq2vb41TyiXimRrzQks9XD5kjBE6SC2Fx
         yOn94ORr3A0De2fVBckitCEUL2gIoinbZECF5uSfprLDGTN4dfrLPQIoLJJbL1pfHHaw
         wo/rUHzeF6uauVhOM90gKegPl4kRT5FunLEPhA9kCsLIRoVjg702K1lkxWoHsBWAmBUx
         O7WA==
X-Gm-Message-State: AOAM530NB/Qvm8Jw4SADVBsF6ja9/YmYxfEO51iUpPSgog+Ce0TC5T+7
        P80dsUQYfe/t+ZWhpwWnbMAt4g==
X-Google-Smtp-Source: ABdhPJzQMLqb4bFrLyBbxKGDwPw9C8NipoMqeJ7xNPTsBkJi5NjPuG27JQYf1w7A/zdPoLEj/xRjMQ==
X-Received: by 2002:a17:90a:5d06:: with SMTP id s6mr513034pji.88.1590516193211;
        Tue, 26 May 2020 11:03:13 -0700 (PDT)
Received: from ?IPv6:2600:380:495a:792b:6476:7a3a:9257:12c7? ([2600:380:495a:792b:6476:7a3a:9257:12c7])
        by smtp.gmail.com with ESMTPSA id i197sm182611pfe.30.2020.05.26.11.03.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 11:03:12 -0700 (PDT)
Subject: Re: [PATCH 6/6] io_uring: let io_req_aux_free() handle fixed files
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1590513806.git.asml.silence@gmail.com>
 <3e06564a15ca706f5f71ed25e8e3f5ea1520117e.1590513806.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7c1727c0-43c2-b4dc-8093-55030ae49057@kernel.dk>
Date:   Tue, 26 May 2020 12:03:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <3e06564a15ca706f5f71ed25e8e3f5ea1520117e.1590513806.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/26/20 11:34 AM, Pavel Begunkov wrote:
> Remove duplicated code putting fixed files in io_free_req_many(),
> __io_req_aux_free() does the same thing, let it handle them.

This one is already changed in mainline:


> commit 9d9e88a24c1f20ebfc2f28b1762ce78c0b9e1cb3 (tag: io_uring-5.7-2020-05-15)
Author: Jens Axboe <axboe@kernel.dk>
Date:   Wed May 13 12:53:19 2020 -0600

    io_uring: polled fixed file must go through free iteration


-- 
Jens Axboe

