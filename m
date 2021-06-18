Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4DBE3ACC26
	for <lists+io-uring@lfdr.de>; Fri, 18 Jun 2021 15:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbhFRNaN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Jun 2021 09:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232258AbhFRNaN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Jun 2021 09:30:13 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4751FC061574
        for <io-uring@vger.kernel.org>; Fri, 18 Jun 2021 06:28:04 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id 66-20020a9d02c80000b02903615edf7c1aso9618053otl.13
        for <io-uring@vger.kernel.org>; Fri, 18 Jun 2021 06:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=xO1yg9plBsVFJtg75Kkk+3CivSnwSot1St/UBMsYY+Q=;
        b=u8Ug5cyak6FJvF6/IoDIWiKynVDA3J8rXHEk1O/z/v3lt0Ia/hFR6Jmhb+3S37RXpJ
         DcoLG8+KXrdZUiIYNQ3j9LyJUzA7sUfqZgqyCA+G86u8rxXZCfEPxBHwkFPswAswNtB1
         31VB1GvhN8RMMmvSqmW4zIUh6jcfW/hkD5Y6ebzBrzh2aX29KpUFEX6DYTKuHiz4WX8m
         uwIiywqPv4mlBnkl+pScX5f/pyQSGkZQhYeolQIC+WlNmZ0/9O7JCRagAQv1O5eaZv+r
         QFET+YvosTrR2C4YgsfU4zekFlDhNncFX0EAGSHIH0c38ldqQU9+kemOLua8RR1X/jeN
         hRgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xO1yg9plBsVFJtg75Kkk+3CivSnwSot1St/UBMsYY+Q=;
        b=IMuq4n48KME9d6cXt2jp8jVssC1CTPLWXZEG4X3kIK065OZIxw2Y/3g2/xT/T4RHI3
         bMh+EljAKyefshdKqezxr9IXAOJ8eIi7Z4azTWHGQInNljVFOYCctLhLrnzud0rttI5Y
         dXKWsLKp5e9gZfHzXTXEKejCt4ULNVPAXN+DjC7k45PqLIZyJgqRk9ZsvFUsrfPWU5Go
         HPFt/WtM3piEGyW7YNb+64GJqOcQHy4W9Vzq2JfWNviE6XR4IWUoLntqGM04WGERf6t/
         93ELMFEauiPATaQ5EERbAa7Iflg3gHUbPGSRjiteKTG0g3wvETF5gffx4xzZ40mytLNF
         wlPA==
X-Gm-Message-State: AOAM531Z/IqzXErThM6iJpSThh82SzIunWkuiazRqWkjxnICJXU2VqA5
        i7yKuvIFfuBGuNmTdXRIlTdV7OLfQ8GFTQ==
X-Google-Smtp-Source: ABdhPJzRGJPAKyOagH4k9KcezrukdawVtP15GJPGqlmBpJb8VIXVHb2SEemC20lD7yMU7d+g4FjweA==
X-Received: by 2002:a9d:69c9:: with SMTP id v9mr9513900oto.89.1624022883393;
        Fri, 18 Jun 2021 06:28:03 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id c5sm1832705oiw.7.2021.06.18.06.28.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jun 2021 06:28:02 -0700 (PDT)
Subject: Re: [PATCH RESEND v2 liburing] update rsrc register/update ABI and
 tests
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <9d7b3a79c62f9867a89483933906dcec9993eb68.1624019347.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <50d69517-80ee-e595-54e1-fb741d6edb61@kernel.dk>
Date:   Fri, 18 Jun 2021 07:28:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <9d7b3a79c62f9867a89483933906dcec9993eb68.1624019347.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/18/21 6:32 AM, Pavel Begunkov wrote:
> There is an ABI change for not yet released buffer/files
> registration/update tagging/etc. support. Update the bits.

Applied, thanks.

-- 
Jens Axboe

