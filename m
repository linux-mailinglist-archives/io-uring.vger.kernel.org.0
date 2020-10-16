Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6B8290648
	for <lists+io-uring@lfdr.de>; Fri, 16 Oct 2020 15:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408014AbgJPN1z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Oct 2020 09:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407838AbgJPN1y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Oct 2020 09:27:54 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC60C061755
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 06:27:54 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id g16so1393033pjv.3
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 06:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5ueuZkZOgN8M9UjSK5GxnmzgiAAnh9hwi0TcaPWgiKg=;
        b=ll7zKeQHP2tzgB622Vh8SREPYddeTWjcyLjrhTljuSB/RiZEXexTuxUrVXm3t/M2g7
         /2LY/T5C/iylyv988XIFKSrVefFGyTiko/vg+vU82M8zGWVHI4bCRF19tA043RvthRDB
         t9eTAWPj7afxt2L3BHNFztIB2J2nJ75+xOKIJ59HZ9LXfNVoxGXj/JprIPYqMTMVYWHV
         54ufaGpoBhJivc6psteCVBj6q5cw5KkOAZafnEluRWkc92oMP9V4V3Ht9Cv6oFltBqzC
         Marf4zLXRZKSJ8YEEfA9sUVz+dv2YrmO7jAb3Ll2hi0nmyTP8MQ6gzZQMLMEX2NmN6/5
         ijqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5ueuZkZOgN8M9UjSK5GxnmzgiAAnh9hwi0TcaPWgiKg=;
        b=hgIsz7u13PCm4iyFTjeV3I21d0eQAA30j0iOTpicBEL64shWBae0nwO8EZYpmgDmZB
         YgaBixjtcTAg6MDMIfeg62HmPg3IprQu0v0pyBhWAbTMMO1dsNKLvKRIJcAMXuSrnPhJ
         0O3Ehq/JWkSXV7Isj15p0JfmgkonWakdbD4yQrH8ixhTCLUk8ZFbjXOrQeQiyqCjtgYP
         CHFz+xntEK+fJf9CQwyJiznnKn4RDJgKLpmLxKWnJVobP7lXL6w3uP8+OnDWFlOWchCH
         mEBGb0VsrEdi46JYRztp3bndtEe2hMhhJ+UEy2m9t017kYfuEIR2wi+PrcIVtYHvlB/v
         oqNQ==
X-Gm-Message-State: AOAM5333zYLig4TnSGRbVsfoXYR4jrwM5zZRix6PH5l56EKHr4doFktD
        D1/HI7t6pPafjWAzsdGGPsKs2A==
X-Google-Smtp-Source: ABdhPJw+5K59XhvHvLAgYIL5rrfS3JVa0lgjEKyJD4bADfXovqXIa6H0ebpvJcY+SfCA/R7lO/Rv/g==
X-Received: by 2002:a17:90b:4b08:: with SMTP id lx8mr4031198pjb.204.1602854873620;
        Fri, 16 Oct 2020 06:27:53 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id nh4sm3116093pjb.1.2020.10.16.06.27.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2020 06:27:52 -0700 (PDT)
Subject: Re: Question about patch "io_uring: add submission polling"
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Stefano Garzarella <sgarzare@redhat.com>
References: <635218e1-da08-4ab5-7a95-fb74de46c741@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0b7d845c-0566-2786-2f74-22e6a31016bd@kernel.dk>
Date:   Fri, 16 Oct 2020 07:27:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <635218e1-da08-4ab5-7a95-fb74de46c741@linux.alibaba.com>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/16/20 2:55 AM, Xiaoguang Wang wrote:
> hi£¬
> 
> I have questions about below code comments, which was included in patch
> "io_uring: add submission polling",
> ------------------------------------------------------------
>      /*
>       * Drop cur_mm before scheduling, we can't hold it for
>       * long periods (or over schedule()). Do this before
>       * adding ourselves to the waitqueue, as the unuse/drop
>       * may sleep.
>       */
>      if (cur_mm) {
>              unuse_mm(cur_mm);
>              mmput(cur_mm);
>              cur_mm = NULL;
>      }
> 
>      prepare_to_wait(&ctx->sqo_wait, &wait, TASK_INTERRUPTIBLE);
> -------------------------------------------------------------
> Stefano submited a patch "io_uring: prevent sq_thread from spinning when it should stop",
> I understand what issue Stefano fixed, but don't understand below comments.
> 
> Can anyone help to explain why we need to rop cur_mm before scheduling, or
> why we can't hold it for long periods (or over schedule()), and if we
> unuse/drop mm after adding ourselves to the waitqueue, what issue will
> happen when unuse/drop sleeps, thanks.

The not holding it too long it just trying to be nice. But we can't drop
it after we've done prepare_to_wait(), as that sets our task runstate to
a non-running state. This conflicts with with mmput(), which might
sleep.

-- 
Jens Axboe

