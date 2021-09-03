Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A59B400728
	for <lists+io-uring@lfdr.de>; Fri,  3 Sep 2021 22:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235957AbhICU4b (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Sep 2021 16:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236839AbhICU4a (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Sep 2021 16:56:30 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5458C061575
        for <io-uring@vger.kernel.org>; Fri,  3 Sep 2021 13:55:29 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so358186pjr.1
        for <io-uring@vger.kernel.org>; Fri, 03 Sep 2021 13:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DJWNbah1vQRHs6Y2VZVGVoYhyj2trOxIMnnDdxrfdZw=;
        b=wP2IGzJzEHtLk8pslL2GlBpdmdQTvmt68Jp6xUeK5Ofa+gxxYt3loubGwsLb7ZaDem
         +uG9QHafPyZQcrGM6HUrOuoPcK70f6u+0tFJdr5uhrJFw0NeRTWqgZHqehDtO6bSnTOs
         3067J+ZHXzj3CSe7E0+Xvt1LfzCc+yLfEZJZ0w6jJdp2SB63OsauNpVLaBIBfHIpuVYZ
         X4FO7M8vjUQenUsB92CqRCZksqWm5Vpc7u4OL69M53vgwK22UB3wP6ozaxxBqYt9yuHH
         TfFR/lHo7Wqa13q4D/i4Uu3AxkOCFVCP7fcpwCaFFBYor2vK4M1oDafdGtyGI7iA40ZH
         /NCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DJWNbah1vQRHs6Y2VZVGVoYhyj2trOxIMnnDdxrfdZw=;
        b=Er9O9RnfFIqSPqOD0ZZJJ83FbpL/CmJUrXp7GQR+4jcXySxWmzqxbACCPnDKJDBmnl
         Aslud613/n03HwCvv4vnX0NoDFne2ZsgH/CtKzk4BEOvb0AXSTJ9qugut7yI06PJATiJ
         LwgRS0G8Hdic7j7Sa1rx2dRoo/bNEPBXRMzkPw1ZnDjbItulAXUsEAxyBDmbr1VTKgYU
         hTszwFSgSAAps6bz9xmS4nfSY5LqojPBrCU8dzDSM7eAgjhRhMEcC/Dr50Mu9TJzul+i
         W43Y02a8HQBVEcd4c3VBaPhFEmLk93pj6StRL8oAQrFPvA/DOtroNaFt1NKS4guadTMv
         eMIQ==
X-Gm-Message-State: AOAM530F+yBAvgF9Fgn6DatEEF68yPc/g70F7US7J2V5eSD4Ch0/6aLt
        a339frTuvt2uijcPN8aj5rsWxQ==
X-Google-Smtp-Source: ABdhPJxSKZZvEzoiBKtOJMsYAeeNgQzpmfzFds0q+qil8k3cdzIwypjxiJ67PupCJP3EAiFgdWnc4g==
X-Received: by 2002:a17:90a:d596:: with SMTP id v22mr822204pju.51.1630702529188;
        Fri, 03 Sep 2021 13:55:29 -0700 (PDT)
Received: from ?IPv6:2600:380:7567:4da9:ea68:953f:1224:2896? ([2600:380:7567:4da9:ea68:953f:1224:2896])
        by smtp.gmail.com with ESMTPSA id t9sm257946pfe.73.2021.09.03.13.55.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 13:55:28 -0700 (PDT)
Subject: Re: [PATCH v3 0/2] iter revert problems
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc:     Palash Oswal <oswalpalash@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        linux-kernel@vger.kernel.org,
        syzbot+9671693590ef5aad8953@syzkaller.appspotmail.com
References: <cover.1629713020.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <65d27d2d-30f1-ccca-1755-fcf2add63c44@kernel.dk>
Date:   Fri, 3 Sep 2021 14:55:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1629713020.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/23/21 4:18 AM, Pavel Begunkov wrote:
> iov_iter_revert() doesn't go well with iov_iter_truncate() in all
> cases, see 2/2 for the bug description. As mentioned there the current
> problems is because of generic_write_checks(), but there was also a
> similar case fixed in 5.12, which should have been triggerable by normal
> write(2)/read(2) and others.
> 
> It may be better to enforce reexpands as a long term solution, but for
> now this patchset is quickier and easier to backport.
> 
> v2: don't fail if it was justly fully reverted
> v3: use truncated size + reexapand based approach

Al, let's get this upstream. How do you want to handle it? I can take
it through the io_uring tree, or it can go through your tree. I really
don't care which route it takes, but we should get this upstream as
it solves a real problem.

-- 
Jens Axboe

