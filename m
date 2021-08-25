Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC8F73F7BE2
	for <lists+io-uring@lfdr.de>; Wed, 25 Aug 2021 19:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235093AbhHYSAX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Aug 2021 14:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbhHYSAX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Aug 2021 14:00:23 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C965C061757
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 10:59:37 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id a13so124685iol.5
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 10:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=R7VOAKmwKeZYVTtp1HJbccPPcjbe0Bt15sKijUUr5qE=;
        b=uY4/cmN//BUKWMG5rA+gF8KUSrRN/ucD1pVl+jcLzRZQUr+RyffRuyiogN7JUFVJlE
         EKoMBfiAqDUuZ5g3LPoKl6cHQhj7UZczG1N/3KOOaPJtrLyYKi0JSRqHG6x8XTql+cHa
         PByJWX48xf7SPbS2xVtaiNsFsjhOJES2aMMGgASPJqUZN0/5s4hRPL+5nWRUO4gJO2xS
         tZkz8ka6aVTKZavIzoztF8gjQCQSBN8Vbg3MJCL1IwEFTuTekQ/eq4daCkROarQrYoOO
         wwNQQF3FBDfjbKHVkvD2PZZzuzXDgFOyoPh3jIJadJZTIk3yaNUU9zYVk9SvhZGXngL1
         XEcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R7VOAKmwKeZYVTtp1HJbccPPcjbe0Bt15sKijUUr5qE=;
        b=a3cc5ExOKnSFSZF3GiW+cmH2442n+kcDR91yoXXPCVlDDpcVNU021aK74GJucjsJoe
         C5shXdheLCzWXJlb4FelhiN5saucPjTkbQYAcVQ4tiPGis/006FsSSPK1EXCSngrSROU
         btdp/qZberJ+NLnWkNP6EL+VGFlTqK8nzwgi3y3TilZYe+iN3mQr5x58fw/1aTGuSEbx
         Ho+gc4pFc06Pq1soVyeR/e2ZkRP6BGsCPIeTeoDYAvC2+nVNdebkGbrN00VaThWMCkut
         slrgeQjw1sgfe2QxCp3Ji8VLDiH7Slt1NcSq5JyPpLwJ+EInIBSBpIENVRq0/sXU3SPX
         nL5g==
X-Gm-Message-State: AOAM532meC2PT1Wi/uw47T5Gpxe6OYUbciNlcNnq0G+aDwiVLHYJSVDy
        sqAk6H5usuZ9RtUphsrG+KuP7KJSR+WCgQ==
X-Google-Smtp-Source: ABdhPJxFgxQV5hjRKSabCABto6GhiB4PczdO9gkGSg3eep+fE6s71s0HiYIPAZJixflw5CARwzwiUg==
X-Received: by 2002:a05:6638:168f:: with SMTP id f15mr40703532jat.85.1629914376302;
        Wed, 25 Aug 2021 10:59:36 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id v15sm339188ilq.2.2021.08.25.10.59.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 10:59:35 -0700 (PDT)
Subject: Re: [PATCH liburing 0/2] non-root tests
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1629913874.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c7ad24e9-9e77-3faf-10b6-d55ee4aaf5d6@kernel.dk>
Date:   Wed, 25 Aug 2021 11:59:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1629913874.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/25/21 11:53 AM, Pavel Begunkov wrote:
> With 2/2 tests pass with non-root users. Tested with 5.15,
> most probably would need more work for older kernels.
> 
> Pavel Begunkov (2):
>   tests: don't skip sqpoll needlessly
>   tests: skip when large buf register fails
> 
>  test/d4ae271dfaae-test.c |  5 -----
>  test/helpers.c           | 19 +++++++++++++++++++
>  test/helpers.h           |  4 ++++
>  test/iopoll.c            | 24 ++++++++++++------------
>  test/read-write.c        | 26 +++++++++++---------------
>  test/sq-poll-kthread.c   | 14 ++++++--------
>  6 files changed, 52 insertions(+), 40 deletions(-)

Thanks, applied.

-- 
Jens Axboe

