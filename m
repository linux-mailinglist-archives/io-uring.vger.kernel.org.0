Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57B6C2D1519
	for <lists+io-uring@lfdr.de>; Mon,  7 Dec 2020 16:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbgLGPuU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Dec 2020 10:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgLGPuT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Dec 2020 10:50:19 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C574C061285
        for <io-uring@vger.kernel.org>; Mon,  7 Dec 2020 07:49:30 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id q22so10356891pfk.12
        for <io-uring@vger.kernel.org>; Mon, 07 Dec 2020 07:49:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=GMZk4uWjSWxVuxAWAv5DZAAbuWtvGkoWdt8CfIXmL8c=;
        b=mApGOVC73ydUBIjPNcVVHLHjPSP0Qp46zkzoq3H3gH+HIQsC2ou0auyCIAxHx0Pcl0
         +a9P9ud/WodkJjdcaE5VS+XNqjPFdq3c0zt1LqdmRk+bm90BM5zoQ3LIux080NSiyD4U
         NQr/XpJ0o/7CubvyARZxVCZpq6Pivy24yM/S/OXoRUrisumhUecn6gWQRn9p/MzHup2h
         Eomu305L6DypKSFnKqWS4kqxwoImEzFx1thKwCsT6IH/lvi0tXumRo+0Gd+NlmHm3Nvm
         dcHf+X2dTTL5uj/rCkubCJXHKbIAtvhwO3O2LnLQHpDsv7XJ65l75A6f0DSvvuh+9+7w
         KNfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GMZk4uWjSWxVuxAWAv5DZAAbuWtvGkoWdt8CfIXmL8c=;
        b=I5egX7XdBw1/mP48AZU2Dc0bOXN3tJJIk1sWHwAyHt55lxJ40x6VKtyVIH1YFsPSEF
         LxsCUIPnLqpaoDBUzww/duRrlsrV9tcdQh18QPMExAmKStdWbd9rZeVFbhagc7PXHX4C
         gGcgadCDSkcee5W7B7gC5YAhb7bfBBcxmQ3JfiAg0AswJs/gBxQcDFLEVRS2sdZ9SWbu
         /DGHs6od2+9Z1vU/Hrrfrp4+8AlLRqmn6L/UwqXSvcCB3L4cGyoDGSMuN2tJT4HEXl5z
         jSdO/xUtT0im8RmoHr4ZFKJADxsoRe0z5OlQPYrST8/YEepUdnv4sXrcYZ4h9q95oCPa
         sZKg==
X-Gm-Message-State: AOAM532o7JL2RBtnBlV3q/8kIEhUiBIKvCF7YT/si8Lnm9JW0OHwLC27
        EvXMZCKHw9aDAXUqacyDLw/cU261sa9NsA==
X-Google-Smtp-Source: ABdhPJyts6oP2Opl/JN3T1nWXOQByrqx1EqvThfaOPZ6lnCiNYzAxaAK61sQPnMW+Oi7xBDXpXCIjg==
X-Received: by 2002:a17:902:56e:b029:d5:d861:6b17 with SMTP id 101-20020a170902056eb02900d5d8616b17mr16604225plf.17.1607356169538;
        Mon, 07 Dec 2020 07:49:29 -0800 (PST)
Received: from ?IPv6:2620:10d:c085:21d6::120d? ([2620:10d:c090:400::5:8d80])
        by smtp.gmail.com with ESMTPSA id mv5sm11018995pjb.42.2020.12.07.07.49.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Dec 2020 07:49:28 -0800 (PST)
Subject: Re: [PATCH liburing 5.11] man/io_uring_enter.2: describe timeout
 updates
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <24c4f1133eb4dd3ff2e979a6a744ac0032fb7a2d.1607260546.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <315f0a2e-1ec7-fdf1-cf53-211f271447dc@kernel.dk>
Date:   Mon, 7 Dec 2020 08:49:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <24c4f1133eb4dd3ff2e979a6a744ac0032fb7a2d.1607260546.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/6/20 6:16 AM, Pavel Begunkov wrote:
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Applied, thanks.

-- 
Jens Axboe

