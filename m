Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B72D53768C2
	for <lists+io-uring@lfdr.de>; Fri,  7 May 2021 18:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238165AbhEGQ3S (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 May 2021 12:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238170AbhEGQ3H (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 May 2021 12:29:07 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 593B2C061574
        for <io-uring@vger.kernel.org>; Fri,  7 May 2021 09:28:06 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id n10so8452865ion.8
        for <io-uring@vger.kernel.org>; Fri, 07 May 2021 09:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=OurAtuFxhVcKb9kgPOXijmZfrIqjlRTSao7Fvj7KiGo=;
        b=EtpzyvWAzG1Ci/iCyGeHSHbzwAzHfFlHSymyyPrSVOf/HNwb9NedFXy51cqCGtBcFh
         yMP8dI+TQKxAHxNy/HtFWQ1BOTIzEta3XA0RLHI68icTp20JSnikiUENwGQv3U5bYWgl
         QNS4o0U2+R4mtcyNcUj2nsM1whE4+xuD6S8sHene/qFJtLLmVSSd/bw5p+JU5iHqiAki
         fdgTa7VC5etwz4kjtBV9NerpD0IShXYyg9tRgozUnU3cPZA89EtadNU7TUISPdnW93gi
         pJo3U2+B/bBEPk4Y4j2Kt+gTCzRA9r+3cQy9ejMZOkEuUhkaJSO5CdfvEqWecNf02p4l
         9Rlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OurAtuFxhVcKb9kgPOXijmZfrIqjlRTSao7Fvj7KiGo=;
        b=Ha3sTlSvBp30XPgMr8WSxeIgBjYkzdjGHBh0BwDVMLHy/JIcqHZMvDE8AmHDm23Xbv
         Y8JeMn8chghYrotQkDClStVoYd16X9W1t07th1obg8b9PI7pjeeoVv6h3iOvQSJ3d4d8
         jtUjyJtoBLIMP0dLaPp+8mgw2r/7zLgAPe63dvDbC0DLnyI2EahhLvKDBkZxRLvdeAGO
         amFZdjsXbZNwYZUkpK+NdbKCf4QFZ4LwtvWikKSZjkuX+kAXrqOGHvPcbtl0TjxdhEKk
         XCcZttH7FhBe5q59xct630+PpRijsI6zUx2yR91WfbLeVkKlPWe3oXYSpkOjYVOGAGOk
         aJUA==
X-Gm-Message-State: AOAM532N491Aiwd+9FD4i1vZxi1MXtrcv0JC1f0ftqfDQZOL1zXMNKrX
        hYWgD1//C9G+3AHLG9uwmFCf1abMFpwl/Q==
X-Google-Smtp-Source: ABdhPJxHKhbSmCYQXXxcqjtMP2eoW0g18QmxLhvs6lTY5Zjl0xnX8U5q3IvKAeFeOHEasWOduL7UTg==
X-Received: by 2002:a05:6638:3f2:: with SMTP id s18mr9725557jaq.63.1620404885428;
        Fri, 07 May 2021 09:28:05 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id n4sm3092945ilm.39.2021.05.07.09.28.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 May 2021 09:28:05 -0700 (PDT)
Subject: Re: [PATCH liburing 0/4] rsrc tests and fixes
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1620404433.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b36f35f7-941c-77fe-4db3-7a3b89614a76@kernel.dk>
Date:   Fri, 7 May 2021 10:28:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1620404433.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/7/21 10:22 AM, Pavel Begunkov wrote:
> 1-2: rsrc tagging, buffer update, rsrc register, etc. tests
> 3-4: small tests fixes
> 
> Pavel Begunkov (4):
>   sync io_uring.h API file with Linux 5.13
>   tests: add rsrc tags tests
>   tests: fix timeout-new for old kernels
>   tests: fix minor connect flaws
> 
>  src/include/liburing/io_uring.h |  41 ++-
>  test/Makefile                   |   2 +
>  test/connect.c                  |   8 +-
>  test/rsrc_tags.c                | 431 ++++++++++++++++++++++++++++++++
>  test/timeout-new.c              |   2 +-
>  5 files changed, 471 insertions(+), 13 deletions(-)
>  create mode 100644 test/rsrc_tags.c

Applied, thanks.

-- 
Jens Axboe

