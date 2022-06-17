Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAAD754F91D
	for <lists+io-uring@lfdr.de>; Fri, 17 Jun 2022 16:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382626AbiFQOXX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jun 2022 10:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382694AbiFQOXT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jun 2022 10:23:19 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60BAD1EEF5
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 07:23:17 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id w19-20020a17090a8a1300b001ec79064d8dso1417679pjn.2
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 07:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=oWWaV2dFd7UACJ4qh730/E2oebUI5cxjGffr/saS9pw=;
        b=tOMEW52aSnWRzLj6GXF+hn05CLd0e/Wf8wUuLdBj31hfdHu5EHO2QfEiIh5lOe6UCa
         NNisDWkJeTimaxQf3oCtNDYbWWm7S9jcmx0ukOS8j1sc2J9l485nTZ+AfTF/oOBbFLmZ
         MPqCYI2KyjeFwgPTbyotST/I/7Q2IFS9wexh7IEin0YCeZDpnhy+/tbkgXQ1yUjS/EFp
         Hz/6wfEWyRDNG1cAy3oazcrLm5S/lLfbMYr1z39+wIQTdSCgNk8ZSx1IXgrE4HNoVfGQ
         zz6PonssLoGJRw1SK2fbyYMJBibyBg1Cw68QUAMFSw0aHHPdvhXdfNUjkYy9jvJHGzhl
         GMiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oWWaV2dFd7UACJ4qh730/E2oebUI5cxjGffr/saS9pw=;
        b=Y+9w7OzrzDo8hlcpnPAIppknJ8Ir/r/2vTtl7ACFRdig3VwaBa3u5Ag033yERUT7/z
         3XcpcCUBrwCaXaXUnmda7h8jINOHI+5W5lvWybGe726y+AJk/EQr8kg6yd2ukgmL264+
         D6VpvYpZCjFL2U3S5aJ20uIrx7mpQc4o/+xnptWclp1xgT53QzFJc0o2QJ2Z7/JLezzg
         n7DQcqWbc/htuqyPTJ8fEmNUoDKWkZQR+k5VZmHKDPDlz8Vfipx1IgZWYQKxT1jbK+1X
         Oc+oreJFEm+8iZdqyyMb31a24fMaTW4dbAEA/k0jUfZbSo3jBKZPpXveDzvch0051VCS
         BYBg==
X-Gm-Message-State: AJIora92PxETcbiZ5zdhZz669KE73EU5p8ZTDqCMzfYwwc37gArIr18s
        GtE8GPrFC980V6banCbJCLKboXH1azVEcg==
X-Google-Smtp-Source: AGRyM1tZroWgVp7vGFM8Z3GhoLmOnyFNwy9cCVuKqyDqT+RGlkGi8v1L+HZSCzSykZcKAyeVG3MY3g==
X-Received: by 2002:a17:903:1cb:b0:165:1055:a56 with SMTP id e11-20020a17090301cb00b0016510550a56mr9738563plh.150.1655475796782;
        Fri, 17 Jun 2022 07:23:16 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id m7-20020a62a207000000b005184031963bsm3792182pff.85.2022.06.17.07.23.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jun 2022 07:23:15 -0700 (PDT)
Message-ID: <6704dc2f-87dd-62d5-7f95-871b6db3a398@kernel.dk>
Date:   Fri, 17 Jun 2022 08:23:13 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] io_uring: net: fix bug of completing multishot accept
 twice
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>
References: <20220617141201.170314-1-hao.xu@linux.dev>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220617141201.170314-1-hao.xu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/17/22 8:12 AM, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> Now that we use centralized completion in io_issue_sqe, we should skip
> that for multishot accept requests since we complete them in the
> specific op function.
> 
> Fixes: 34106529422e ("io_uring: never defer-complete multi-apoll")
> Signed-off-by: Hao Xu <howeyxu@tencent.com>
> ---
> 
> I retrieved the history:
> 
> in 4e86a2c98013 ("io_uring: implement multishot mode for accept")
> we add the multishot accept, it repeatly completes cqe in io_accept()
> until get -EAGAIN [1], then it returns 0 to io_issue_sqe().
> io_issue_sqe() does nothing to it then.
> 
> in 09eaa49e078c ("io_uring: handle completions in the core")
> we add __io_req_complete() for IOU_OK in io_issue_sqe(). This causes at
> [1], we do call __io_req_complete().But since IO_URING_F_COMPLETE_DEFER
> is set, it does nothing.
> 
> in 34106529422e ("io_uring: never defer-complete multi-apoll")
> we remove IO_URING_F_COMPLETE_DEFER, but unluckily the multishot accept
> test is broken, we didn't find the error.
> 
> So it just has infuence to for-5.20, I'll update the liburing test
> today.

Do you mind if I fold this into:

09eaa49e078c ("io_uring: handle completions in the core")

as I'm continually rebasing the 5.20 branch until 5.19 is fully sorted?

-- 
Jens Axboe

