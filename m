Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36B673ACF01
	for <lists+io-uring@lfdr.de>; Fri, 18 Jun 2021 17:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235325AbhFRPcM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Jun 2021 11:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235293AbhFRPba (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Jun 2021 11:31:30 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18666C061145
        for <io-uring@vger.kernel.org>; Fri, 18 Jun 2021 08:24:00 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id 102-20020a9d0eef0000b02903fccc5b733fso10030044otj.4
        for <io-uring@vger.kernel.org>; Fri, 18 Jun 2021 08:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Mv13JEj53e6qcenwkEJ/6iOn/RbrphcPr/wpBBr1o6Q=;
        b=fLQrdm3rGidqoiYdti3SZwsHavEm/Te937m+l119/C9hCBcQvqcHMdCNoNUdXIT3u4
         Vb0KqseVaYUJ2dlY/TD44tsj+fl9clX0uLph1r8I0n6xF74ZLOcNaUYIUeL9AN5Xwxrq
         WJAaeBVIB0GHiLAukVq9O742g0uBAY5FZH+aukcFxYCXRif5JYvZQJikUGJ5CTQdwHrG
         c0Lwdv3PIlN6Zrx/dKcWoQphT3bcncsd3iOLc6AhG3UHxCPO9MII2dPglwg30+yJ6fz5
         ysz1i4bcM4OZyxqzjj9rvzTIsaM7Xo254q1RnniUHvko6QU+wAV9OTdCQtuBhYTd5GRW
         p/dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Mv13JEj53e6qcenwkEJ/6iOn/RbrphcPr/wpBBr1o6Q=;
        b=X9wMh2XX7LHviMFgn1elZQXMzF2sB2QHTJ09qgFhNf3wTci2pbIabbY1gqV4OZjL4W
         3Pjcwt/WBXU3z8ajb3T3dGjso4n/dkcyKcg5tgLWpRmPzZ06FSoO2Emj7prphqwEpy+8
         o03Lsjl3Q0ufPBFXJ1EkYtl+8dxOI0jCV2QHGNnHReVnMGBtsC82X1xsXn1N0j8hBb7V
         4Xje8UeHhwYVhUFGgeIALzU5C4YiA23PfuxB4z5cdSHw0uF+4b2ao40NBNSyHRVkBjq6
         HOPr5vbK0RvyHhmGbGGJsmLVwKMrQM5u5ClKd70nP7s+E7/tDplNP6UfT2r5wg6k54JB
         U8qA==
X-Gm-Message-State: AOAM530brNOu7Z1VOCxUg1PtZWZbr5D+yOztCnp0Vm43xoDDf5qzx0pA
        FRziXFN53qYmq5JjRLzN7zvmbKDV5qxU9A==
X-Google-Smtp-Source: ABdhPJxlpixUFr6T6bsUXICfzWbaKxZzfdbXyfzm+E7N3MLrjqU/e5SU/Jpf6ButkrV+hhVL2MM8zA==
X-Received: by 2002:a9d:6f93:: with SMTP id h19mr9858612otq.292.1624029839210;
        Fri, 18 Jun 2021 08:23:59 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id u17sm970083otk.15.2021.06.18.08.23.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jun 2021 08:23:58 -0700 (PDT)
Subject: Re: [PATCH 12/12] io_uring: improve in tctx_task_work() resubmission
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1623949695.git.asml.silence@gmail.com>
 <1ef72cdac7022adf0cd7ce4bfe3bb5c82a62eb93.1623949695.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c8a55ff7-6e90-c6df-1f68-3ed1a58da6c5@kernel.dk>
Date:   Fri, 18 Jun 2021 09:23:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1ef72cdac7022adf0cd7ce4bfe3bb5c82a62eb93.1623949695.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/17/21 11:14 AM, Pavel Begunkov wrote:
> If task_state is cleared, io_req_task_work_add() will go the slow path
> adding a task_work, setting the task_state, waking up the task and so
> on. Not to mention it's expensive. tctx_task_work() first clears the
> state and then executes all the work items queued, so if any of them
> resubmits or adds new task_work items, it would unnecessarily go through
> the slow path of io_req_task_work_add().
> 
> Let's clear the ->task_state at the end. We still have to check
> ->task_list for emptiness afterward to synchronise with
> io_req_task_work_add(), do that, and set the state back if we're going
> to retry, because clearing not-ours task_state on the next iteration
> would be buggy.

Are we not re-introducing the problem fixed by 1d5f360dd1a3c by swapping
these around?

-- 
Jens Axboe

