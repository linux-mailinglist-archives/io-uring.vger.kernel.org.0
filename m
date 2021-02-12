Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7407D319F0C
	for <lists+io-uring@lfdr.de>; Fri, 12 Feb 2021 13:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbhBLMrR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Feb 2021 07:47:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231706AbhBLMp1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Feb 2021 07:45:27 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC394C061574
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 04:44:47 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id z15so463216pfc.3
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 04:44:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=08rpPvPv/F7sTkGyoMitePJjicuCmtmCycbsidCjq/4=;
        b=xAEQKrKP+Bg/iRqC3l+4wdNuUlmL9Sa7TF5adfBx69JAlNEwshV4/hBLyV32m68wmh
         pMUDpqb4s4j06Ry2fOjmORnH8fLUYjqMeMx7pRty0MIRSbQ7MmFOEv7Hi7OG5+dNE9XI
         JCpmWkp/V0FK/+eKd80QuRNNeLSpeCSJpPVllJI3H/teqjj2r+VgI/h5ZYHFWIbioV7z
         r7szkdOOZgYYnluoN+SCrB402KxQ6P+fjMwWs6iPe6iqTzPilDb2qlOpz/PJLmsJqrWO
         SqI0RRGdbsNqwElPU46dMIeHt935BZRWAzv/NAhiwrmPcYwLrCNE/AE2cZJNGsvS3puh
         mBZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=08rpPvPv/F7sTkGyoMitePJjicuCmtmCycbsidCjq/4=;
        b=Csvs1071UuuriC24Q+6sf2QJYQeu/tosHxmJ1BQ96oCZc0DNjZegzlf2mgDeFmx5Bd
         Ccea+XfQwIysziXricWpC7tbhgCLkLZXjeFyFR9rB32uGo6tin5aKbYvamcGOqX1RHAE
         3LpZn03/XpF339jdSf+C3RSNkLXKL6Jq7rXHslwJYTSPZjjXM3B8j5JYp2AbAoqMBiSy
         D+8KF1ifpfl4tvRFBR7G463LEQNm+It7dqjW0WBQpZ83MxKzeYKoyBSNiHkulUBcUQCk
         QvUK+3dljd9pt3Ni8E4855+s2ehSXigxWvBznMDWFa15O5iQk9x+n4Fdx1S574EYN+48
         XK9A==
X-Gm-Message-State: AOAM531rezCrZ+q0G1ZouuXQTwo7uEmJHDG1LAcNx0VzXV77fnwflM6X
        3rvvr886JgM+T6pRNU9V0JOTcIdZrYFuXw==
X-Google-Smtp-Source: ABdhPJx+Aud6169g8uB74cYcLZGvT37EW9DFSKCtTP4u4CB1+4QNMHAoBK2eahPZYmwBsrAaUBu7UA==
X-Received: by 2002:a62:ae08:0:b029:1e3:28c6:7bc with SMTP id q8-20020a62ae080000b02901e328c607bcmr2864139pff.67.1613133887177;
        Fri, 12 Feb 2021 04:44:47 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id z4sm9234222pgv.73.2021.02.12.04.44.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Feb 2021 04:44:46 -0800 (PST)
Subject: Re: [PATCH 0/5] another round of small tinkering
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1613099986.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9de39795-3f8d-63d1-7f8b-4d437269ffa4@kernel.dk>
Date:   Fri, 12 Feb 2021 05:44:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1613099986.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/11/21 8:23 PM, Pavel Begunkov wrote:
> Some other small improvements with negative diffstat.
> 2-3 are to address acquire_mm_files overhead
> 
> Pavel Begunkov (5):
>   io_uring: take compl state from submit state
>   io_uring: optimise out unlikely link queue
>   io_uring: optimise SQPOLL mm/files grabbing
>   io_uring: don't duplicate io_req_task_queue()
>   io_uring: save ctx put/get for task_work submit
> 
>  fs/io_uring.c | 103 +++++++++++++++++++-------------------------------
>  1 file changed, 39 insertions(+), 64 deletions(-)

LGTM, applied, thanks.

-- 
Jens Axboe

