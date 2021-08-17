Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A107F3EF56C
	for <lists+io-uring@lfdr.de>; Wed, 18 Aug 2021 00:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235507AbhHQWHP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Aug 2021 18:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235557AbhHQWHP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Aug 2021 18:07:15 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB7EC061764
        for <io-uring@vger.kernel.org>; Tue, 17 Aug 2021 15:06:42 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id n13-20020a17090a4e0d00b0017946980d8dso7520244pjh.5
        for <io-uring@vger.kernel.org>; Tue, 17 Aug 2021 15:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=lZbYjc18nNihfpb0uZhRYK2Bl2q5s7goYVSXvHgfanU=;
        b=fmP8d2SqOEyt3+3QdAAWZtA6sxdS+4dZGc////Bdc5UWr3A58EQ7Up29psRXeys0JK
         R/taNoOc46HvFnYNkHo3z11RvU9Mkb2WSCMqKut4srUum8/0aQZN/OA2pLzkUuL3IB8c
         PyTu+5s62Y7ZNXtvNXn+YFDvA6raUFISRMM9W1Gw1SCakIcqqIt7pRqyjQ3t7WRthiQU
         AFg8tMaElNg9L9M8L3AutdxL47AtAIDTFHEH5bzMIhGXnZI7h4pITekrLikkcVJeVFJE
         r9Fv4gwFOGulVylFIQG9YgFPi7j7xPVZJIjsv2p6PQjwiQuyQImFaGH+NEfuMqKq7jhR
         PvNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lZbYjc18nNihfpb0uZhRYK2Bl2q5s7goYVSXvHgfanU=;
        b=mRx+axQFanpElWCEYVA5Rs4oZWayZowXW0cWsz4uZjUC7T/1t0KmpiqRo7n35OieF1
         Gkfm7CxKQXhoGxG3UjDck6MUr3iAsUmjLacJC5djiiirngWgwJ51ApmppzQl3GKwAw6X
         vHv54SlEroZ5gCPyUpNur9ozBCBaMQ11/6IOJLjQ5hy1vbbVvS/nxfFBctFPBzqM/hdo
         lJYYVWOty23KhliDT+MFOlcIrnko6kIkxD1kz7Wgo28QtwlKVkeyEjqlLyEYCkgwUf04
         bFKlErN5Rw3Z5pbSTXhNIs/B9ZyjiYv2ef6WKG6ehVGzwHmotrLRYmcUDVzIWvGcjmb0
         rKQA==
X-Gm-Message-State: AOAM530jalkypbsFSG8p483Daw55t3vy+05jQm//pOlxl/g1kavVnKVp
        vZMd/cj7WAnarc5cz6JoxmMo+RSvxEcU8S/q
X-Google-Smtp-Source: ABdhPJyo0iFMwC3xhkwspDoq4GwCNK1CzCu+zXeCG3NPl6VZGpUwwGclouHYH/6394vpoyAiq5jADw==
X-Received: by 2002:a17:90a:9511:: with SMTP id t17mr5820389pjo.194.1629238000918;
        Tue, 17 Aug 2021 15:06:40 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id v25sm3434337pfm.202.2021.08.17.15.06.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Aug 2021 15:06:40 -0700 (PDT)
Subject: Re: [PATCH 5.14] io_uring: pin ctx on fallback execution
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <833a494713d235ec144284a9bbfe418df4f6b61c.1629235576.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <93539b95-3bd8-f9dd-2bd5-3768bff7ee94@kernel.dk>
Date:   Tue, 17 Aug 2021 16:06:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <833a494713d235ec144284a9bbfe418df4f6b61c.1629235576.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/17/21 3:36 PM, Pavel Begunkov wrote:
> Pin ring in io_fallback_req_func() by briefly elevating ctx->refs in
> case any task_work handler touches ctx after releasing a request.

Applied, thanks.

-- 
Jens Axboe

