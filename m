Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C342533978C
	for <lists+io-uring@lfdr.de>; Fri, 12 Mar 2021 20:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234326AbhCLTjg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Mar 2021 14:39:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233944AbhCLTj3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Mar 2021 14:39:29 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223F1C061761
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 11:39:29 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id j2so5428853wrx.9
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 11:39:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZlPO0gnquoshgdxJ5TlD0e+FBL1MocaQywVWyFDp/00=;
        b=JH3KrP2CZhztaWdfe2LHgDcAoK0IJo1yVoPlgaYgjAOYM1Sz9ex82PANVfU7vbV5PP
         yTv4EXD5SZa4CZXXC42iwMekKViSHJ6H/C/iHJxFu1TJJ50zPs39gWCtZ/tn8ZoDxGhg
         TY9R9HAff4wQD4iM54mDDhY9mZbW+mXErJssLna1C68m3eBcg/PiNbqnV2uAZCb/TH2K
         1pNKTAus7WQJarcXMsqHAATPWYaYokyPu4UdDw9NvoTU2GYFpa/G/tjH/xqQJ9lSPxEM
         r5V0Qj1eai6dfRNDzpOZIavf/Olag65Z1qujZmDJKTSR4pEyDi5ZwPjtSoHGl2T4Ty7x
         raGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZlPO0gnquoshgdxJ5TlD0e+FBL1MocaQywVWyFDp/00=;
        b=FKTHnBMBBb5vbRV2+LmB4Sd4koi1bEfhOXjJPfzsufeBQdqRbp08mhSjsegYNW2jFn
         bgOC1Kts3tsZMAO7RmaiRV+31FLCibM4i3tLh9HftGC+qfdzMDULsaHAFq5avppoiMVJ
         XJO22X4pRAY64yvOy6D4/2XSUGL2X/mpEt7wVn8bXm6NZNgXv7u+Wqe3J0CMqpF04pVc
         i3F75wjMkfQ348jCGZnJZlUO7sMGIxt1Rczhm/p2oswIxOfMpQ+syXD+m1DjihZoighg
         TMkf+wdCg3hoqMDpmr1DQMcf3g8EXu6Eky9g18yof1u9QIfvA9CF4a4MjTo3xs/GfBDp
         fiFg==
X-Gm-Message-State: AOAM531XBbt8x68SDUsCNHwpLkpPLG6am0y7mS8j5NnPtaV3OKgUi+F5
        dFJoiONMN38EYcmf860cZiJQsPydbYh6tg==
X-Google-Smtp-Source: ABdhPJwHYZwjQSzt58D7Fn1b52KBrIiQMJA5dCvyQqjdOdCqaDJX6CEZ8Oa1jL07P/Wx8LSwaRlzNw==
X-Received: by 2002:a5d:4148:: with SMTP id c8mr15456216wrq.91.1615577967607;
        Fri, 12 Mar 2021 11:39:27 -0800 (PST)
Received: from [192.168.8.141] ([185.69.144.203])
        by smtp.gmail.com with ESMTPSA id m10sm3328305wmh.13.2021.03.12.11.39.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Mar 2021 11:39:27 -0800 (PST)
Subject: Re: [PATCH 4/4] io_uring: cancel sqpoll via task_work
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1615504663.git.asml.silence@gmail.com>
 <6501248c79d9c73e0424cb59b74c03d72b30be62.1615504663.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <d7515d66-0ac7-ce48-7194-00e8bde0595b@gmail.com>
Date:   Fri, 12 Mar 2021 19:35:31 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <6501248c79d9c73e0424cb59b74c03d72b30be62.1615504663.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/03/2021 23:29, Pavel Begunkov wrote:
> 1) The first problem is io_uring_cancel_sqpoll() ->
> io_uring_cancel_task_requests() basically doing park(); park(); and so
> hanging.
> 
> 2) Another one is more subtle, when the master task is doing cancellations,
> but SQPOLL task submits in-between the end of the cancellation but
> before finish() requests taking a ref to the ctx, and so eternally
> locking it up.
> 
> 3) Yet another is a dying SQPOLL task doing io_uring_cancel_sqpoll() and
> same io_uring_cancel_sqpoll() from the owner task, they race for
> tctx->wait events. And there probably more of them.
> 
> Instead do SQPOLL cancellations from within SQPOLL task context via
> task_work, see io_sqpoll_cancel_sync(). With that we don't need temporal
> park()/unpark() during cancellation, which is ugly, subtle and anyway
> doesn't allow to do io_run_task_work() properly.> 
> io_uring_cancel_sqpoll() is called only from SQPOLL task context and
> under sqd locking, so all parking is removed from there. And so,
> io_sq_thread_[un]park() and io_sq_thread_stop() are not used now by
> SQPOLL task, and that spare us from some headache.
> 
> Also remove ctx->sqd_list early to avoid 2). And kill tctx->sqpoll,
> which is not used anymore.


Looks, the chunk below somehow slipped from the patch. Not important
for 5.12, but can can be folded anyway

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 9761a0ec9f95..c24c62b47745 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -22,7 +22,6 @@ struct io_uring_task {
 	void			*io_wq;
 	struct percpu_counter	inflight;
 	atomic_t		in_idle;
-	bool			sqpoll;
 
 	spinlock_t		task_lock;
 	struct io_wq_work_list	task_list;


-- 
Pavel Begunkov
