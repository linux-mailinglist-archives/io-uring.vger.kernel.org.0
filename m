Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573EB2FC452
	for <lists+io-uring@lfdr.de>; Wed, 20 Jan 2021 00:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728226AbhASXAc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Jan 2021 18:00:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727874AbhASW7z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Jan 2021 17:59:55 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D943C061757
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 14:59:15 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id w14so4217413pfi.2
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 14:59:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=oAVUaMO2wV0fXP5htKpj/7glD+whBsuGwUTvQMwFY+U=;
        b=AYVowC/iaTUeOXhPSPwYrSQOXqb5RNeHg/SItCiv9phRmVq06jYbKxDEPu0mmnHswB
         5lVpOGY7VLJErCUfNLvzJhtokvTwUHxiXb4zjvceUbEkxC8suI4g6Lh2+YGw0tmQMkpR
         EfC5vPxx7w1aLmBq76JlBBsIWBpRa84/SNuFKWnXzqQNwfFswoBCdsGBCWnhzEU01jQ8
         LmxrRDfWl3ny55HeI7cyleA6QqmMxBJDhl54fHWa2t8nUWd+jArfnOSeRLcKZqocKD/d
         fbsA7uMbYzzxnpK5TGvmj2wnNhuBxYlSSp7am5HDt09orrAmvVA2QFPe4Bg+zhlehvdv
         gdfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oAVUaMO2wV0fXP5htKpj/7glD+whBsuGwUTvQMwFY+U=;
        b=hDqY2ikQzzhqnrYDnAvYxmf5NTLEpcnxwgC6iUHwoeO5RGJ1Q+AtzU9bhij0raLpo8
         ymhVFa7ROpPTBDuLAvNIVxusyzs1/XLJYkx3UKcxcmfqzYZ2Jd+ZvIYVnZ6RapgIeaas
         cUA7QeOeumwhg236V4GeWaoMVvsbQ+K0kOIuwWSjCV1CKfdDvrSvBgI3Bxh3LQSLyN2R
         uYUa/3TjvYSKvdXAPWfwcZrCb6gGPijsKzz63CzyA7JalsVW8BaJuNnzVooEgtWi+dU4
         jB8eLIRECOG40Y19tSJRaYBAKywsC5lBMVX2AdInoRtCGYHBi5FQBiS9hEc2Bcr7pi4e
         68Tw==
X-Gm-Message-State: AOAM531Q4SbzGMCYvSvROzPKtbkOz6o/dC3vA1+qtafmtU5zlCKPJvuN
        ScExhJzLtyf9L+1ztP/y+JdFyFQofVlumQ==
X-Google-Smtp-Source: ABdhPJwPaL2C6SD1wBXNMXoBRYRx89udQ+HrKkLJBUrsSO6IqeQkj1z5Uz1IjzGgOBdHBTKM1mGUuA==
X-Received: by 2002:a63:4923:: with SMTP id w35mr6330338pga.404.1611097154511;
        Tue, 19 Jan 2021 14:59:14 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id b129sm127180pgc.52.2021.01.19.14.59.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jan 2021 14:59:13 -0800 (PST)
Subject: Re: [PATCH 10/14] io_uring: don't block resource recycle by oveflows
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1611062505.git.asml.silence@gmail.com>
 <f4332081e1c60460686075e16534ecf6a337cfc8.1611062505.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c18325d0-fa84-a40d-267b-cef83c84e12d@kernel.dk>
Date:   Tue, 19 Jan 2021 15:59:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f4332081e1c60460686075e16534ecf6a337cfc8.1611062505.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/19/21 6:32 AM, Pavel Begunkov wrote:
> We don't want resource recycling (e.g. pre-registered files fput) to be
> delayed by overflowed requests. Drop fixed_file_refs before putting into
> overflow lists.

I am applying this on top of the first 9 of the Bijan series, and
hence this one is borken now. I've applied the rest, please resend
if necessary

-- 
Jens Axboe

