Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB99D1A2519
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2020 17:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbgDHP1V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Apr 2020 11:27:21 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36875 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727192AbgDHP1V (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Apr 2020 11:27:21 -0400
Received: by mail-pl1-f195.google.com with SMTP id x1so2628389plm.4
        for <io-uring@vger.kernel.org>; Wed, 08 Apr 2020 08:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=O7WfNhI8f1lb6PW5kXHujbQHVLkGUotMPukmCgQtvWY=;
        b=TkbTZ3imLDeHFL3w/n+tfMNRMwjwa9tuBACNwAjcNUWZMbOLPIyh7bEByUqixcSOXC
         xkZpVv5LVlFb7bI8auY0NpFtQ82qWf6Y5Zm19IQMAk22dNFw09zwOGJS7J03vbbTIP3E
         FYsi8YR2gA18/wCGK34SabV2govLlWbwYmf1xK0NpZ4Jaai3nYmumE5PeCeWs6knoE5y
         n45xkh2LgxK4toUsFztNtAqfmApl04H5V8U2dKOHI/GdL1BQ9jM8dle4UgVBvHSBRn5u
         wdYZKqIBhSLrS5POZknxoFrhC5/oCI5l2NrCEKnbmI2JyEgLvCdqv+RNIrysz+9W15bo
         MNVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O7WfNhI8f1lb6PW5kXHujbQHVLkGUotMPukmCgQtvWY=;
        b=kTK7b9Gwtdya795PkduCX58LY0ECWfQHCA2vwtlxTPOQv3nej9+mliVmuY9kYuBEXT
         uisjGIxLbSwrBZay/lnJ+suvb8pgcHv+k+6e5qV62xHQk44pqdlCqGE0bsnZ7gftiuUN
         1mLCP4Mf6CzMFbGwUld+hxUnsBPiPV174YElzYizhUyFRuUBWbWUbWsRUykykBUVTRgT
         SgAFxXdsu6XsL/AYOMDgGh9hKtkh2AiRGw4JW1QGqMDeVxo0j+LES/xl5WOWNt+D1rIi
         aYWi6FdMeqwi5G+n9pwXR/A+n4cyFcelDcwvrgR4y5mjUUVIcFjXf/X6QMrhZUrvE+oA
         XmRQ==
X-Gm-Message-State: AGi0PubLAL0ndrlqDvP2NoWNMXCvE6IDzMclq6gwYkHUQLW1z0mFNdiR
        im51oefFHEalKzgj6yqxw3YYdA==
X-Google-Smtp-Source: APiQypJUFFNkq129tV80J9L/1WuNm/ssIiTfXEAk1yXAaUS/SUq8LNfYq7xWZ4+kPLlPTgl+51rlFw==
X-Received: by 2002:a17:90b:3656:: with SMTP id nh22mr6013366pjb.71.1586359638209;
        Wed, 08 Apr 2020 08:27:18 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:4466:6b33:f85b:7770? ([2605:e000:100e:8c61:4466:6b33:f85b:7770])
        by smtp.gmail.com with ESMTPSA id b68sm1314338pfb.134.2020.04.08.08.27.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2020 08:27:17 -0700 (PDT)
Subject: Re: [PATCH 0/4] clean early submission path
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1586325467.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0dffba9d-d320-0412-f17d-cc6a19f39772@kernel.dk>
Date:   Wed, 8 Apr 2020 08:27:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <cover.1586325467.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/7/20 10:58 PM, Pavel Begunkov wrote:
> This is mainly in preparation for future changes, but looks nice
> by itself. The last patch fixes a mild vulnerability.
> 
> Pavel Begunkov (4):
>   io_uring: simplify io_get_sqring
>   io_uring: alloc req only after getting sqe
>   io_uring: remove req init from io_get_req()
>   io_uring: don't read user-shared sqe flags twice
> 
>  fs/io_uring.c | 113 ++++++++++++++++++++++++--------------------------
>  1 file changed, 54 insertions(+), 59 deletions(-)

Looks good to me, applied. Thanks!

-- 
Jens Axboe

