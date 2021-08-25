Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66D063F77E3
	for <lists+io-uring@lfdr.de>; Wed, 25 Aug 2021 17:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbhHYPAm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Aug 2021 11:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240656AbhHYPAm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Aug 2021 11:00:42 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68399C061757
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 07:59:56 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id h29so24295473ila.2
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 07:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=pn2T8nnqeeTym3MPxFgMRnCCpQHrRZZxfRr3jFLJDO0=;
        b=fh5mYuMmDJeegsFjXN4YGhoOyypEKN4TLoV3o7cQ7UGPWW/F+PrZmtQDN+CiniKooP
         MNRATjUjVNvxRcKqtiNowYv9z/6GV7tVhppcoTyxLcJi2PRIE3sQb8LUmSuNwvAM+pR3
         3lPaQrvGeekP7DT9QDWYDgPncs1SCBWy/lNVPPuZ9IumpD4Bb6zg7Bla+D4Zc4Inyvvf
         GTlVIgRBu857MCPomo8PFCt41Q9+/YGe6KgSooIlCTNjHYBvtWG4BbOPzdxwZ7hVuLEF
         NxTcEKq+TR2gJzO69iqM5GedFS0zKQ9+4zn732cMyu6JrEVk7usJ8vs1lvURhtXQhMv0
         GAVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pn2T8nnqeeTym3MPxFgMRnCCpQHrRZZxfRr3jFLJDO0=;
        b=P6mrg2OH0+Zg0YOnMUEYcuBg+aIAclvW0564VW3MkQdPOORUmhQ4hfjK27j0kI/jmm
         8yB+lAE/EXjhzGL2DMyC573CKJQ/BGSxYAwOSX5xQ3li4xhx1iUmFEiFpeW622CGwgNw
         Cit4Gfa3se7TMo2qP1eu2rGA8ZATZght70C8D/R8AazDEazo8gKbXAjM+o0kjD2CEQEs
         usno3ov+S8CxyburCtnCb3UNAmzzj2Fg0ZCXjbXfgv9LwfQkoH7t2NensPQoyzzWf7fG
         ESbWaULGRpOtwVXuQHxDGvm9pmMF/69gsQLjbf95AaqbTAmIKSUX9gol1mIIdvXdRJz+
         iHSg==
X-Gm-Message-State: AOAM532CROixBvz2dy9KIy1GdPa4Ge6ePUOkYkkkqb6vTqGf6F+/ZjTm
        FUwpDg9HiJOofgwrEcQ054SHrJuLwNBW9w==
X-Google-Smtp-Source: ABdhPJwQaK7NPIK5Cl+kyr5zxV3jPSS5RMC84v0uvyH+84lvqui/L9fItnLdLH1PD7PhESlD5QjJEw==
X-Received: by 2002:a92:d0cc:: with SMTP id y12mr13420789ila.38.1629903595615;
        Wed, 25 Aug 2021 07:59:55 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id h10sm97954ilj.71.2021.08.25.07.59.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 07:59:55 -0700 (PDT)
Subject: Re: [PATCH liburing 0/2] liburing.h helpers cleanup
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1629893954.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <24ab359a-8ea0-82cf-eaf1-8f0c5284013f@kernel.dk>
Date:   Wed, 25 Aug 2021 08:59:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1629893954.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/25/21 6:23 AM, Pavel Begunkov wrote:
> Add a helper for preparing multishot poll requests + a poll mask
> conversion cleanup.
> 
> Pavel Begunkov (2):
>   liburing.h: add a multipoll helper
>   liburing.h: dedup poll mask conversion
> 
>  src/include/liburing.h   | 25 +++++++++++++++++--------
>  test/poll-mshot-update.c |  3 +--
>  2 files changed, 18 insertions(+), 10 deletions(-)

Applied, thanks.

-- 
Jens Axboe

