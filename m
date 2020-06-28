Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D656420C859
	for <lists+io-uring@lfdr.de>; Sun, 28 Jun 2020 16:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgF1OMk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Jun 2020 10:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbgF1OMk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Jun 2020 10:12:40 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3293CC061794
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 07:12:40 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id f6so2886078pjq.5
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 07:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=nonF4G05NrcDS8+p5NU/H/QtiuPpa9KnfG/QTfy1SWQ=;
        b=AIU4eZ9Th1Lps4TibwQoA1w59vpVCDladel3/sSVYkjkgQaeGeuJxctzgEpYSEM/Ha
         hSarWVtRIPnGgaaga/fPyJpHGyUFKlQ1HxMy0M4p8leWnrFYyuNubxDPTd9TQVuq5ZyC
         hZlujAhFeLVfXtmY2uQ6OzkVBhgUF7mARXX2sQJIRqwr/nJEmBXYx97eGhwfqh1fB/kB
         5dff5rjsX7v3TxrqAaHClvOjR3hL4qZTxGz0EActooDOzcoJvTqD89DsTlZwLci00rK7
         n12Sc+naHOP4/Fy89WI8BkGhMnRhDlbDaN/kIXgT6FbMHv7CuQG7y2tSO3v9xUmpEqnY
         B6pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nonF4G05NrcDS8+p5NU/H/QtiuPpa9KnfG/QTfy1SWQ=;
        b=Mo4fBAMoDUeSArBxsJOWgKILOoxXNnArDA9StNb1QzIZYGC3Xk14q0cmXKhD3+LpgJ
         hfLxnkUMeSdavg2UCsaJ/PBWjl2Lz+HLCqardAmJB7jEZCFHg530GtKI44z5APaEO21C
         8tUkPtLD/xLJEgtqkxFpPF9gOHVITC/qLHMzHRhH6Dhba+VyP2gabqHKJA5EmzHxV1MT
         Me3LEPGcmy1Fiuyxb/zfQsDS522mkzR8XROQ7bYbNLiY0JzLkS5ef2e7AQEwphclueM4
         evQIdrhl5DyNMgH5d1M4WwdsstFxZQYiVv1E6bA2ealGNv5QhNPkUdMPT26ZP/P2XtuH
         LOvw==
X-Gm-Message-State: AOAM530shjNlH/0Jmlb/lpY2a+0zNyAYZOeWwje7dZOeMm8aprAcWhqn
        IcajrPVatCWpb2QkdNQpAjzCG71gL9IyLA==
X-Google-Smtp-Source: ABdhPJyX3NCxnoz34c9D0nDcToTT4i6BZF+qzpnOqQtlRlHRhfzXtk8FiKA5Ln/iwqi15jUDJvENwA==
X-Received: by 2002:a17:90a:7ac6:: with SMTP id b6mr3292698pjl.213.1593353559330;
        Sun, 28 Jun 2020 07:12:39 -0700 (PDT)
Received: from [192.168.86.197] (cpe-75-85-219-51.dc.res.rr.com. [75.85.219.51])
        by smtp.gmail.com with ESMTPSA id a68sm6516140pje.35.2020.06.28.07.12.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Jun 2020 07:12:38 -0700 (PDT)
Subject: Re: [PATCH 08/10] io_uring: fix missing wake_up io_rw_reissue()
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1593337097.git.asml.silence@gmail.com>
 <6a4a9caabaf6b74de7cd852d263c9eb284cd014b.1593337097.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <67a10cea-5ee5-ea23-42c5-0d2124df4efe@kernel.dk>
Date:   Sun, 28 Jun 2020 08:12:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <6a4a9caabaf6b74de7cd852d263c9eb284cd014b.1593337097.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/28/20 3:52 AM, Pavel Begunkov wrote:
> Don't forget to wake up a process to which io_rw_reissue() added
> task_work.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 5e0196393c4f..79d5680219d1 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2172,6 +2172,7 @@ static bool io_rw_reissue(struct io_kiocb *req, long res)
>  	ret = task_work_add(tsk, &req->task_work, true);
>  	if (!ret)
>  		return true;
> +	wake_up_process(tsk);
>  #endif
>  	return false;
>  }
> 

Actually, I spoke too soon, you'll want this wake_up_process() to be for
the success case. I've dropped this patch, please resend it.

-- 
Jens Axboe

