Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7800B342590
	for <lists+io-uring@lfdr.de>; Fri, 19 Mar 2021 20:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbhCSS7j (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 14:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbhCSS7Q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 14:59:16 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88598C06174A
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 11:59:16 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id v17so7197557iot.6
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 11:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=8IKyNH67EimzqsQHRt2EcKZG5N53JSEbdBmk0DECGS8=;
        b=jwji7jvmiYIto2TjT9rCsBO3XvvcLSZ/obuk3qVC060Oasx7T5fHNNQ9fgdrATiq/q
         oIgLPqBUmvX7sbcwClY1OPIEtFD7/Gk61gjERPztFbPJT0aZhZlJ60DQfFkZXwAWMYgx
         Kkw5zuCam9zfHsjR33pjQg7hhhg12qj7k+winLnKVoq9futOG8tK9tNUS2kV9HRz5Ms5
         SjiNzedEqRgOIAH/7pnwoUM0V4qHja2sl6hCnavGRkfiwW3brJOrcE6RfSyKV1Un2UxP
         8aP2RJXyGgJ+yu1Hk+3sZpw0fa+5xx1U367IMYmdoQ+ZhkOpDdT1QP7tqBkTrLiRw7fv
         CEUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8IKyNH67EimzqsQHRt2EcKZG5N53JSEbdBmk0DECGS8=;
        b=QTza3xVX3P8VqZse6PjPutLjHjO9RGonA+h6qfBUPqCUQUcKXRkXq0manQD5lVIfjm
         16A0T6LIduZAepsNsqx0ywnB0uyhCBqO9UnPa9+RqFhVcWukUQEA8TUccr81Mdz5tEcv
         hOpc64H5sKQM81zJp5hvmbg6ctD77XXJB72p0hsN/bI45BLIGJX1TFtbeaXamh42V/Ae
         Z+6XwOZ6nXXMkWu8r2nmnczAJaaskJWQB15+1NMFym4M1TutxEzLlIGSTjvh9KbNRbvL
         mhHS01jjoI0tLBcm5RuGMBgHOrL6hJFL1kFuGCTnB7vYTrHHfMKh1iasImL9OfWFaqIl
         VB/A==
X-Gm-Message-State: AOAM531+DB7bIrbEPR0Je4WsJ52MuUrYRxKn+f8zbw1dfhOD6KUGVCel
        pA/ovTMrp31v61G7wF+vQpwOviHYxXj60w==
X-Google-Smtp-Source: ABdhPJyf9UigTdZVME1o8o9r9U2McMOZ7ThiQYQ1dbt3GFORZWokH2mYs1z8gE3BuqgBBGn2fD4T3g==
X-Received: by 2002:a6b:7f4d:: with SMTP id m13mr3750014ioq.134.1616180355720;
        Fri, 19 Mar 2021 11:59:15 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id m5sm2979605ilq.65.2021.03.19.11.59.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Mar 2021 11:59:15 -0700 (PDT)
Subject: Re: [PATCH 00/16] random 5.13 bits
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1616167719.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2fcae175-dff9-2a0b-84e1-f4dfc8d69d86@kernel.dk>
Date:   Fri, 19 Mar 2021 12:59:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1616167719.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/19/21 11:22 AM, Pavel Begunkov wrote:
> Random cleanups / small optimisations, should be fairly easy.
> 
> Pavel Begunkov (16):
>   io_uring: don't take ctx refs in task_work handler
>   io_uring: optimise io_uring_enter()
>   io_uring: optimise tctx node checks/alloc
>   io_uring: keep io_req_free_batch() call locality
>   io_uring: inline __io_queue_linked_timeout()
>   io_uring: optimise success case of __io_queue_sqe
>   io_uring: refactor io_flush_cached_reqs()
>   io_uring: refactor rsrc refnode allocation
>   io_uring: inline io_put_req and friends
>   io_uring: refactor io_free_req_deferred()
>   io_uring: add helper flushing locked_free_list
>   io_uring: remove __io_req_task_cancel()
>   io_uring: inline io_clean_op()'s fast path
>   io_uring: optimise io_dismantle_req() fast path
>   io_uring: abolish old io_put_file()
>   io_uring: optimise io_req_task_work_add()
> 
>  fs/io_uring.c | 358 ++++++++++++++++++++++++--------------------------
>  1 file changed, 169 insertions(+), 189 deletions(-)

Thanks added, all look pretty straight forward to me.

-- 
Jens Axboe

