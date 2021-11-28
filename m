Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E79446071E
	for <lists+io-uring@lfdr.de>; Sun, 28 Nov 2021 16:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358104AbhK1Pei (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Nov 2021 10:34:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358053AbhK1Pch (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Nov 2021 10:32:37 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7653FC061574
        for <io-uring@vger.kernel.org>; Sun, 28 Nov 2021 07:29:19 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id v11so30950312wrw.10
        for <io-uring@vger.kernel.org>; Sun, 28 Nov 2021 07:29:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fOm81/G3fSjZlvypfH9ZARmztzXMFg6JzWtwqnfaxuQ=;
        b=JlzekC6VRwv00TlfDmgP0GLxzOMW3hfbmTEAXeOH/cQRXl7diMhrmGumZC13XYlK4w
         gViD/o+X5utRqTNLwdcQpFp2aKo1Mg2G/40KF9SZ8NUfTS/6LB4b4sTnr+E6GlbODiMe
         RdL4sLx4VRO1yOocS6nJHHXbWEC9pmNmsS2tI156YUnfZbChkKBl57lu/08PdrE8Zpnd
         pmKEYl7Hvs02RP67mNnnTnTv1XZppGCPywISQOqCTIjWmZkXaP+IVkfc6bl8zyGR32f9
         TQP3TKk9hLfs0ooT9+CWByG50Z3OJrYuurE2siVspr1uR8Qf8rOUNuoc6o3sK4FPSojT
         p4ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fOm81/G3fSjZlvypfH9ZARmztzXMFg6JzWtwqnfaxuQ=;
        b=QJOmPfqb32NHsQDO+KdyhtFooanO4tHQ1Gc9fizYsIaIN6jWfmNvHPcGHcXAvlrj6w
         0J0VzKw/MG2FcvF9j709bhim/L+0YnZsYkLQwf50JvGp72A4kzBUzL2R8ove1KR4Ovtc
         m4md3RkgJFX/xciqYsKjnOfFlamBvE1X0OPmUmygL4YS6it3d9AmlkNH8bL2tsa2b8LQ
         YwKmMxHgMsC0ym9GVWpdEn0hALMOUGrByebiAZ7sxW4hkgoJZr+kKY/X72ekBxMkyu2W
         w1j6x4IE/852DDY7U7zPSGoZmLYtxz8cxzX98wct2OCb62/QAyMEQ3wu94U6bB5m92P/
         WQGA==
X-Gm-Message-State: AOAM533No76FHcnlcfid3qoJ59kLYBEyZYAF4T8k1uDVLy4kay5Ufcvy
        aWugebG+d6ERevfeIyOwqqkncy0LNgk=
X-Google-Smtp-Source: ABdhPJw1Ck+dEIhWOeQYCGF8/SgXNZ+yVHlF7Ged/LaI3V8lirDYz55VJYrpb37dst7KgUqF9j5RmA==
X-Received: by 2002:a5d:4411:: with SMTP id z17mr27504435wrq.59.1638113356468;
        Sun, 28 Nov 2021 07:29:16 -0800 (PST)
Received: from [192.168.8.198] ([85.255.234.162])
        by smtp.gmail.com with ESMTPSA id bg12sm14848343wmb.5.2021.11.28.07.29.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Nov 2021 07:29:16 -0800 (PST)
Message-ID: <bc87a321-72bf-b24d-95c2-88d7c6d2e348@gmail.com>
Date:   Sun, 28 Nov 2021 15:28:57 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v7] io_uring: batch completion in prior_task_list
Content-Language: en-US
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211126133749.65516-1-haoxu@linux.alibaba.com>
 <20211127152412.232005-1-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211127152412.232005-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/27/21 15:24, Hao Xu wrote:
> In previous patches, we have already gathered some tw with
> io_req_task_complete() as callback in prior_task_list, let's complete
> them in batch while we cannot grab uring lock. In this way, we batch
> the req_complete_post path.
> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
> 
> v6->v7
> - use function pointer to reduce the if check everytime running a task
> work in handle_prior_tw_list()

Ifs are not a big problem, but retpolines may screw performance,
let's stay with v6.

-- 
Pavel Begunkov
