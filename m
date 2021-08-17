Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C318B3EF56F
	for <lists+io-uring@lfdr.de>; Wed, 18 Aug 2021 00:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235588AbhHQWIJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Aug 2021 18:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbhHQWIF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Aug 2021 18:08:05 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94331C061764
        for <io-uring@vger.kernel.org>; Tue, 17 Aug 2021 15:07:31 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id x16so127112pfh.2
        for <io-uring@vger.kernel.org>; Tue, 17 Aug 2021 15:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=bzhCdDozz6j70cMa3skujn/4F6MExIoImgPBFFw5TRc=;
        b=jvExAioVTrT0+o/q6s2D5mHmt+5cD47RgSmTqU4cdVop7V30hD02vrBT8Ou5SAJEK2
         Me86C2NjdHEJJTyjT/aViZG2gPCSUni3TpviYiXxM710a7wHHUp7yiXCkplM3n5xrot0
         tcOF6QL4BLZWFNyGbJfW7uW0gSB3H8+URIkv1oFg0zf2unbD6gKy0H9lYA/ZHtmbNkxM
         F90zJ3AVNMpyU7N7lOHsmti2v820LQ8dZr6T8J6Tn2Uh+czCZaWg4TjmhnPl0kDYYyWw
         0U4IpZ2HN/MwVXrAChbny40kAz//PGV2vTVdiGThM+16lxrKFvhFcwzVSFBsRxmVcd6D
         b/Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bzhCdDozz6j70cMa3skujn/4F6MExIoImgPBFFw5TRc=;
        b=hia1ruNLVOfVq9sp1iVcWDkRCcwSbsZ+8HsXUHghTu6kpqTSyJ3F7F9NYXuZRvCdzh
         kIiabJR02WQHjasaJAxWV9zTSqtKE60JMEUX+0OBeXylrHEsJCjJBk63RsMhJ4yd5eQa
         SvukCvwzOInJh0pR1Sls8iUiHILvl5yXlI7MRxekUJtkBtdCojjvhLpdv6VLAayQDgg7
         60jT6cZc47cpYbDugLRodykW/KKKg3xNyQrd99dkwuQnbhksqz52nQ8RqOqNW1EItj5w
         F4czlGweoq7I736kdm/U0CJhua9PAlA1kMW+l0cn3OEDltZjCaMaGKmC3AHo4wo2A7G9
         2GCg==
X-Gm-Message-State: AOAM530T2KgeOSbttY4YFSuJ/pIA7DQjVyRvaSBQM0ehKHC7Wib6aB5z
        F+nQP8RRxaaq+gLRHDnyotBBdIrhSrFkO01X
X-Google-Smtp-Source: ABdhPJwcaDAOSWrxrSCJce32NVGfORpH86Z4wOxCWLN+cFmS5InpcgXe+eDgUlDmW3nmW6iX/r8bJw==
X-Received: by 2002:aa7:800b:0:b029:330:455f:57a8 with SMTP id j11-20020aa7800b0000b0290330455f57a8mr5705245pfi.7.1629238050924;
        Tue, 17 Aug 2021 15:07:30 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id o10sm4024172pgp.68.2021.08.17.15.07.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Aug 2021 15:07:30 -0700 (PDT)
Subject: Re: [PATCH for-5.15 0/4] not connected 5.15 patches
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1629228203.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <40c4f8a7-52cf-88c2-0916-cfb42333a64c@kernel.dk>
Date:   Tue, 17 Aug 2021 16:07:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1629228203.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/17/21 1:28 PM, Pavel Begunkov wrote:
> A set of not connected patches for 5.15.
> 
> Pavel Begunkov (4):
>   io_uring: better encapsulate buffer select for rw
>   io_uring: reuse io_req_complete_post()
>   io_uring: improve tctx_task_work() ctx referencing
>   io_uring: improve same wq polling
> 
>  fs/io_uring.c | 87 +++++++++++++++++----------------------------------
>  1 file changed, 29 insertions(+), 58 deletions(-)

Applied, thanks.

-- 
Jens Axboe

