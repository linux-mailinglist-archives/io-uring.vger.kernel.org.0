Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4843FA749
	for <lists+io-uring@lfdr.de>; Sat, 28 Aug 2021 21:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbhH1TQq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Aug 2021 15:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbhH1TQp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Aug 2021 15:16:45 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8EB1C061756
        for <io-uring@vger.kernel.org>; Sat, 28 Aug 2021 12:15:54 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id a15so13659354iot.2
        for <io-uring@vger.kernel.org>; Sat, 28 Aug 2021 12:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=OGfT/UsKh1KsHABmhkyKmMkCDljUEt1kyQbQ4dLdTZg=;
        b=ABodOiiTXOr53fPb9ZdKSBqxIInzfereADGmLBiuFxv1zU7yxybgJoBKzqKzcHgX2o
         WuI0hNEzr+vQRXiFmUknBbtcaIijqJ0YAxMUKzrpByBh+K2oHWpgrBDRz7FT5FuPvxt1
         U3m50qJdRVp/cpzl0tOZIVo3P3nxCXRF2eYgv2Ha6tJBXLSSfV0AGazTovzgOF4YygnN
         +1j0fY8/P2WFIjM53f+gFAofKinf9xhTznJ5KX6epgwEtNmax6pMqKOh4gQ7KGaKvkVH
         cVybDWAwNRL5xDqJ9g+Zjn30zUg8Tc8akl57U6iQpoU937U8OIhSV6WjBhggpQ/JqiD7
         3/Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OGfT/UsKh1KsHABmhkyKmMkCDljUEt1kyQbQ4dLdTZg=;
        b=Ucvc9MlmEJmaeouf9eQFJ3GtZexiLOUwNPUep1sWdQLibbJ5lk2OEMABlbbUR/bv8o
         NzQWL86+5LaEqkNLSTEH7J7H5R0AqT9Xp52LaFP4QVwWg1ACYJSDLxxDJ1PgSHsu2lIc
         /e+nXnqq8wRhjQ9nKsoMm7NW77/AXKMrnZAxLV5GzKDWpvKtuE4CMLO3oX4W3Ef1xk9b
         h6cqEWhcEXpfK01vs1yAYZyyCjLeXfWaEUo9KGRM/8DYykKU5rRwXosZStDKsm9NGroT
         I/xHBEo3ua3TV781tfH9//9OZlb+4nL5zq8u7KBG+SOGxWMaBOkkNa0/QYqQ2aNxL5NZ
         m0lw==
X-Gm-Message-State: AOAM530LKZbskz4l//6pJhrMbODukgLviycfeGu5ZzsthM/aOqbxiro/
        Pjfqmyz6+it7jLPi51Dvo0AwXb0UbTY7zQ==
X-Google-Smtp-Source: ABdhPJxuEy76SkeVlUVICIueS4nfNMmgAcB+No9UbA30P17sXHDd3PSWFa2dIp9eSJgb9jgaxsROxg==
X-Received: by 2002:a02:ba1a:: with SMTP id z26mr7970237jan.98.1630178152619;
        Sat, 28 Aug 2021 12:15:52 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id 7sm5637422ilx.16.2021.08.28.12.15.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Aug 2021 12:15:52 -0700 (PDT)
Subject: Re: [PATCH liburing 0/2] quick man fixes
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1630175370.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <55bf5ac9-6cd8-4245-f7a5-3dc482c3fed5@kernel.dk>
Date:   Sat, 28 Aug 2021 13:15:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1630175370.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/28/21 12:30 PM, Pavel Begunkov wrote:
> Clarify details on registration quiesce.
> 
> Pavel Begunkov (2):
>   man: fix io_uring_sqe alignment
>   man: update notes on register quiesce
> 
>  man/io_uring_enter.2    | 10 +++++-----
>  man/io_uring_register.2 | 12 ++++++------
>  2 files changed, 11 insertions(+), 11 deletions(-)

Applied, thanks.

-- 
Jens Axboe

