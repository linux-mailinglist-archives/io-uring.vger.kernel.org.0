Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D97014AD36
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2020 01:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgA1A3X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jan 2020 19:29:23 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33035 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgA1A3X (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jan 2020 19:29:23 -0500
Received: by mail-pg1-f196.google.com with SMTP id 6so6037379pgk.0
        for <io-uring@vger.kernel.org>; Mon, 27 Jan 2020 16:29:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=U91Hz0/lYI/n3Dw7PNbm4tKqVwXKnzCFxiEDM+SytAc=;
        b=UCFUHmfc6v/JRX0Qb9ELA/2JIJTO8BSKgTwXqqkF76uAHJaJPYVpYvmZXJN8euqWb3
         qFN77HQzxsZFMZVN1TZEaisb0t0eyYBTfZanth6pqlGx+y7toODk89yzbPATS0EKBxIb
         Q/CEm4YtPy2IE2c66zfikoEqSqg1wUuTTDgPwdr0vLzMiw1xr616DqbuQGcDXiU71Nau
         Jd52p0QPfl1mqcrst0QdhDzhZOJuezgKOV+fmwciHxyt4ISLmIFVzdGiy/HLNtLUd7Q3
         2yk8hslrjU5XPr7ELisLNPHMuDP6ltxJ2ytIMn2+ECvGF2gHQ8PhCaTj+TJOBC5DGh0G
         Z1NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U91Hz0/lYI/n3Dw7PNbm4tKqVwXKnzCFxiEDM+SytAc=;
        b=sz18kI0iFwr5ls6hqLz3pNAgXa6IIK2kBQ+Yzs2yJawI4/pOSxPr/KgB6za/qOxenC
         4n1SKCgMAi3idFPnVmxwaAvGEs0pre3YkDcO41un5hB/8QOpw8fa9hx6ZxRtcs4QsJf1
         ZGFMvQ1tskfkLiJA1osdr7vk1S+7EtiWFELIvJv7OnIS0MPHNOlj6lVOKpUlBc2iIfFR
         YBZdxQNA3srqwOo/N/BcdzfzQYUPeHuq+cqJrMnB1PL9X2FaPMJGcMwlYcdOS8j0GEPO
         NmbBJmVpB0crfFq6Cv86/PrUlrKdgpJ9yRI/7yJmSjc00sjTw94Cj+oxHdUgfkFpW1eG
         PWFQ==
X-Gm-Message-State: APjAAAWZvzR0g6X4mzNNxengbE8EbWO1y4s7s2Vu1FzqIaKePHva/gzn
        iy5wgyMGFngWm9+K8D3i96YkQg==
X-Google-Smtp-Source: APXvYqzemLISLBefJvaaqOU7JuquxtVC5RTyaiNPVjDMt+GGCIT5cZ287zomhRuum9B1VELnut4ctg==
X-Received: by 2002:a63:450:: with SMTP id 77mr22257009pge.290.1580171362744;
        Mon, 27 Jan 2020 16:29:22 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id 200sm17503369pfz.121.2020.01.27.16.29.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jan 2020 16:29:22 -0800 (PST)
Subject: Re: [PATCH v2 0/2] io-wq sharing
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1580169415.git.asml.silence@gmail.com>
 <cover.1580170474.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2b1e23c3-71a3-2d5c-05c5-4aa393aee19b@kernel.dk>
Date:   Mon, 27 Jan 2020 17:29:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <cover.1580170474.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/27/20 5:15 PM, Pavel Begunkov wrote:
> rip-off of Jens io-wq sharing patches allowing multiple io_uring
> instances to be bound to a single io-wq. The differences are:
> - io-wq, which we would like to be shared, is passed as io_uring fd
> - fail, if can't share. IMHO, it's always better to fail fast and loud
> 
> I didn't tested it after rebasing, but hopefully won't be a problem.
> 
> p.s. on top of ("io_uring/io-wq: don't use static creds/mm assignments")

Applied with the following changes:

- Return -EINVAL for invalid ringfd when attach is specified
- Remove the wq_fd check for attach not specified

Tested here, works for me. Pushing out the updated test case.

-- 
Jens Axboe

