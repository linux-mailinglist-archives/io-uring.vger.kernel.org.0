Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8765020A7B0
	for <lists+io-uring@lfdr.de>; Thu, 25 Jun 2020 23:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407409AbgFYVod (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Jun 2020 17:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406795AbgFYVoc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Jun 2020 17:44:32 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4F93C08C5C1
        for <io-uring@vger.kernel.org>; Thu, 25 Jun 2020 14:44:32 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id i4so3969015pjd.0
        for <io-uring@vger.kernel.org>; Thu, 25 Jun 2020 14:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=74rAvOM4C+wfdNBI3YIbIOX1N2TdkWayq5hI6CuUM2Y=;
        b=cmep0gkEMN/m40ArYj9fJh9v7AM04pBxjDZcWc39mvVwSw0trmaCLYmXMcDeiyzkcc
         czyZPHpA/Aw0/DlfkeI57wNsrK2aN3nP/SiY4ohXB9e7dKccF3dBhRs5O21gqDSfWqup
         GArG8mszuLd3mBPjgcyJl6bAqdHlQg8l/ENOd35nbtg138p0j+IPDaEvzk9xBUpCvByM
         nhU86h33wpkVV5ehKhOgpNJgj09AERitLuF6Xg0v6akISqsN+nDNQmiI5ysmHvXLQgHl
         X3fvoYNOlir1uiJdhz8IS2viJYCrpotjHErPpZR4TEyqAEO8EybD9ZkS3gnddvAsg4W2
         RRzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=74rAvOM4C+wfdNBI3YIbIOX1N2TdkWayq5hI6CuUM2Y=;
        b=tR4SsAyUaqAWOCL0J39uIPMnqzbio2jipwYyfDCkxgS2E2lej4bVUlQ5jJgV6WXEDl
         jn3amM9ZYPTHufeT9WqbLUCTqcthmiDJNiqAq0fPdS0YTGGYRgAUAaDXgOTYBTQyY+Mc
         VDa/ltNucPqfOP7VvujAuwuEACVnhpcYPtnKKe7Z7hK5N62mda5685X5LcSf6Z7QOfQH
         CGH3Viv9sbfdBmxW5mM9e9mk2qPrRp0M8R3L6Czf/8OSsE6MtoxWc715x4WKgMY8Qn/L
         Vim3chDnBjG9PxBH0en1UbsF5fF2XzVAMWkJPMq05TzR93D71IWyf8yKtiCY+OwvVWDD
         M3lw==
X-Gm-Message-State: AOAM532o9+N4MaMIusfyVyJdTa9TePst/lh0IF3qiRiumAYlGiQQkAWr
        dfLbrxmDMUMwuk5icP+knj3A4w==
X-Google-Smtp-Source: ABdhPJx6E/D/8Yhp8Sp3AaHh/xulaBOHcDcxcXdWEp2Jen0Fg+GN5OeUVmVQ/6p0H6n4RdhMLs76pQ==
X-Received: by 2002:a17:90a:218c:: with SMTP id q12mr22138pjc.116.1593121472435;
        Thu, 25 Jun 2020 14:44:32 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j17sm20263449pgn.87.2020.06.25.14.44.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2020 14:44:31 -0700 (PDT)
Subject: Re: [PATCH for-5.9 0/2] clean io_wq->do_work()
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1593095572.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a8f4695f-9c80-2577-e48f-b3316d6b5f9d@kernel.dk>
Date:   Thu, 25 Jun 2020 15:44:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <cover.1593095572.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/25/20 9:20 AM, Pavel Begunkov wrote:
> Small io-wq cleanups after getting rid of per-work callbacks.
> 
> Pavel Begunkov (2):
>   io-wq: compact io-wq flags numbers
>   io-wq: return next work from ->do_work() directly
> 
>  fs/io-wq.c    |  8 +++-----
>  fs/io-wq.h    | 10 +++++-----
>  fs/io_uring.c | 53 ++++++++++++++++++++-------------------------------
>  3 files changed, 29 insertions(+), 42 deletions(-)

Applied, thanks.

-- 
Jens Axboe

