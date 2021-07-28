Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 183C53D962D
	for <lists+io-uring@lfdr.de>; Wed, 28 Jul 2021 21:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbhG1Ttq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Jul 2021 15:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbhG1Ttq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Jul 2021 15:49:46 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98147C061757
        for <io-uring@vger.kernel.org>; Wed, 28 Jul 2021 12:49:43 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id u10so5182355oiw.4
        for <io-uring@vger.kernel.org>; Wed, 28 Jul 2021 12:49:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=xKgz8kPhjtET7bB+McdT7WrOzOxM4XsT800pjMb6mMI=;
        b=G765W3QSpmw+nUYKutLZXTQTMAfO0botcHM+sLnRhaWsl4GCZNAG34mIraYCX0LZ6/
         ZbucPtdMT7Jvsj4IE1avw9KrUdxBEVIpacuUzRiVY7LIWRuPdOw/efkj2vYio9/siUtr
         aAUIb+popJWWgUKdIgZmQEmYYDfEn7QA0oQNhvWpRLRfuSU7NYYKwm6vcULck1F070Pb
         DwpIwIdtygkKYpBujww7bcznUfeIdXBYzGMz8GeydQ5zD9d4zCOzdLqFSYOnl/J/SISm
         Z1J/s9U3/3I4dwVYXfE7KwwtvjPlBCqwXm0u8Xj4+3Rb0I44TfLMlgoOWl+/semQuMEr
         Q+Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xKgz8kPhjtET7bB+McdT7WrOzOxM4XsT800pjMb6mMI=;
        b=NklaCABwAC6jcbKB4cd0eeJoPR4ez6mqyjhEfCcNTsmFCTSbctLjthx2dMaRBtZYO5
         mOwtWT1FTANke5sjRRGfAU2GrEu2N5wF02E6rpOvRFfJepQ1Rk9oHGSNecc83tRADnOt
         6QqaiH/41MUrKF1TH8nONvZEdEcTvE25eKsNzxKIDkW56byBb1RLWHvAz5OBLELhVqOZ
         ZNWgDyOvgxPY/rx/K5tXQDoTTfRZDnjpTbQJMhIpEu/jHU6OkoBTUdp1y6YNyx8EJJ+v
         MPgmSEitMwwDw0ztB2gm0l7Jsxf+Qevz3Kkyzo0Eh4ZtdHdxpHPiRB49RQjmZ7W7y6Ri
         tGvg==
X-Gm-Message-State: AOAM532RB46XBoAurlcEzEgOXrJ4j7ZnM1l/DIpXpUP2fjUEj66hMWPM
        fKbmsYUT2z6/1kcmfu4u55HX1r6wN9O+e41B
X-Google-Smtp-Source: ABdhPJzhgaloc5LOKY471HEcQZcZnnedsjVKO/L2lKmlGRbc0HiqCpBm7vnwgTs6kXnDOEZiyqdJbA==
X-Received: by 2002:aca:fdc1:: with SMTP id b184mr703266oii.101.1627501782721;
        Wed, 28 Jul 2021 12:49:42 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id w207sm198461oie.42.2021.07.28.12.49.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jul 2021 12:49:42 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix io_prep_async_link locking
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <93f7c617e2b4f012a2a175b3dab6bc2f27cebc48.1627304436.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <bb914c80-0ff9-7e20-e5e9-96c90055e7e1@kernel.dk>
Date:   Wed, 28 Jul 2021 13:49:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <93f7c617e2b4f012a2a175b3dab6bc2f27cebc48.1627304436.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/26/21 7:14 AM, Pavel Begunkov wrote:
> io_prep_async_link() may be called after arming a linked timeout,
> automatically making it unsafe to traverse the linked list. Guard
> with completion_lock if there was a linked timeout.

Don't seem to have emailed this out, but I did apply this the other
day. Thanks!

-- 
Jens Axboe

