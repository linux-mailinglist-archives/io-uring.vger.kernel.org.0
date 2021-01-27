Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABC530514D
	for <lists+io-uring@lfdr.de>; Wed, 27 Jan 2021 05:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239537AbhA0Epe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jan 2021 23:45:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238211AbhA0EIy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jan 2021 23:08:54 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63BF3C061574
        for <io-uring@vger.kernel.org>; Tue, 26 Jan 2021 20:08:14 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id e9so322382plh.3
        for <io-uring@vger.kernel.org>; Tue, 26 Jan 2021 20:08:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=dLyCfl6iCIIkk0yBY2vHqjGKZ31t4a/+Ul/7AnsPjts=;
        b=Ien0qjbDATPCECLDNRvKnU3Ap3haj23K7w/Zo67Ju+ri1XOr6Xqr79NkYvXKzOZe2i
         p5VkmH4NrvMa7kJDpEj5zwJ1RqFwKVNyVTY4SUGKAESJeG6X9RjE/ix0zw5cH68OJpaH
         223l0HD8N7CZd2ZlmVlFKoGskBKkvjPL2wnNEsK3tg9J3VXGD17I0eXxzc3jHL5ntcaW
         fs7oBOHV9aeDFvzGgRvUePVMivys/nl6ZrQ37IULcRWsMqYrjbni5QYL7vH/oTrIb1nQ
         S6m+uJKWNTYTMLfetkonVmfiBQo3cf8mxVGuRQ4nKI2kStCwRe1zSoi94QzDY0ktIFgw
         rcUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dLyCfl6iCIIkk0yBY2vHqjGKZ31t4a/+Ul/7AnsPjts=;
        b=nWuJefLQpmwYo+VBQUN8K24tCYc/RPZhET/hzSMBbEtnwmnfc8ncy4vAF82hiO906Z
         b0DZHigd0I7wUpvsDtLk0g8d6qItK6ZoIhKYspXgKxZJkCiVQBAVzPpZ42Sb7WEsdmnB
         D0WheDHxpPqwQvMEhREmtic0iRK0yGhyEkFXSKh7m41Q7+fmHFb5lM1H4YGGPQk79avX
         QSMzkZp1omdbjOcQnqCGbQyZmyhPK/3dX78ESZNdKrtqFBOJ5r251QftUmgeHPybhKC+
         7pUP7yae5kkw0WM12bTjNdsYYxj3NOL6XfA8k7Obv/YGNiB5osL7iNWjJmPMAVpYMb5I
         C+IQ==
X-Gm-Message-State: AOAM533YBetRiy6vfnwRHyDDtHq9ADmYSdrGPKWXl8DEWi6yH9si4i15
        pLSebvkVQqeiL9IV1j59lyoOrkYMMD+wwg==
X-Google-Smtp-Source: ABdhPJzONkPoL+kKcLX7Brz2eobmqAhsoCBYoL5X5XHnxmCBKlYH1o8KNYRG6N7evXab/1LKaO6wrA==
X-Received: by 2002:a17:90a:4803:: with SMTP id a3mr3589425pjh.122.1611720493694;
        Tue, 26 Jan 2021 20:08:13 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id b6sm447734pgt.69.2021.01.26.20.08.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 20:08:12 -0800 (PST)
Subject: Re: [PATCH v2] MAINTAINERS: update io_uring section
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <4a6a96702bfef97cb5e6c8e7b5f05074d001a484.1611710680.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <37700cc3-88ef-4b57-2ad4-004c136dc68f@kernel.dk>
Date:   Tue, 26 Jan 2021 21:08:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <4a6a96702bfef97cb5e6c8e7b5f05074d001a484.1611710680.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/26/21 6:25 PM, Pavel Begunkov wrote:
> - add a missing file
> - add a reviewer
> - don't spam fsdevel

Applied, with an actual commit message :-)

-- 
Jens Axboe

