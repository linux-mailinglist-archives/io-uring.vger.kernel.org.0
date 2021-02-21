Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD5203207E2
	for <lists+io-uring@lfdr.de>; Sun, 21 Feb 2021 02:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhBUBFh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Feb 2021 20:05:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbhBUBFe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Feb 2021 20:05:34 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167E6C061574
        for <io-uring@vger.kernel.org>; Sat, 20 Feb 2021 17:04:54 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id v15so15122573wrx.4
        for <io-uring@vger.kernel.org>; Sat, 20 Feb 2021 17:04:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vGYzj+Mz5FkDOdwdzjfp0viD35YoNVYK5jdlPchtTwA=;
        b=CVgnu2N6HsD4/w4GabpsT42XJ1/NpBumeO52Qn7tSbglW/ytpBVLoPrZBvLLYhRkXC
         peAOtogHDt3QeULVH59pL1gWzZwEvAdeZQ375Jf/Q6YIiLnE5XAHdGDXC9Q9wo1DSvTQ
         Wh5KIcqD4Q6Z8KRYXWL7DTLvQQcUgfBj2w03bdOGENCsLaY/310VOqxq4i1csqFjbDEM
         tSVIwyCiCksZmhcinrXwxs+eh5AK8L/+xOcRPPlft7emRy7PrHKbsQe/DZb2erFIO1qO
         MoE3bCtpwLrDS3FiTghCYsWlDsqocyp8gZvwSlnvFTotSaLL2JeXnxBqFcSgr/hNmbIc
         MBEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vGYzj+Mz5FkDOdwdzjfp0viD35YoNVYK5jdlPchtTwA=;
        b=VDG5uOcbXAlqEXwfPy/LEPNNkyMJGBxhx2VmhEytyMHdc7iXVmNYj1mCWAG4fRzVJC
         W9D4ZjASSHJqyu3NBgnt2SoI//pQxVUbvogtSbGnerbX5ONYxgCGtDu9LkvO0nzTragZ
         mJy9qG4wQXJqtMu/1BjX/3s/7AiTryfAlM03mkp90orMDOSVwsdtXQkFZohO9V6oO7AF
         x1HMXwLNuBFBENgOc5i2B7Q2ZN8THdlB1mv/pYOPrzbuNFt3jGI4P4WB012GqNbfIerl
         H7IIzvY0DczIJBg4IazAU8eS6NaPsFv2dVa9rW+2N5mNcwvLJL+v/IfVEOd2yTOZ1lu5
         2UMg==
X-Gm-Message-State: AOAM533rqWMvb3or4QOEyZ4t7CT/aTqzT5S8dM9SogADJ9pNJKeMAapS
        R64V4TMvaCvYA0I9L4fCwJth0fng1hCK6Q==
X-Google-Smtp-Source: ABdhPJxukg2Spd8u69l8qrX3AyAMoCW+B8BL/9EBHEDA5sUXy7I6qgggK0M9X/adOLZuCNZG54PpZQ==
X-Received: by 2002:adf:9031:: with SMTP id h46mr15566717wrh.19.1613869492620;
        Sat, 20 Feb 2021 17:04:52 -0800 (PST)
Received: from [192.168.8.144] ([148.252.132.56])
        by smtp.gmail.com with ESMTPSA id w81sm19415662wmb.3.2021.02.20.17.04.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Feb 2021 17:04:52 -0800 (PST)
Subject: Re: [PATCH 2/3] io_uring: fail io-wq submission from a task_work
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1613687339.git.asml.silence@gmail.com>
 <ae6848eec1847ff3811f13363f15308f033e7d41.1613687339.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <66ba85b1-090e-0765-2dec-776c4f7e0634@gmail.com>
Date:   Sun, 21 Feb 2021 01:01:01 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <ae6848eec1847ff3811f13363f15308f033e7d41.1613687339.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 18/02/2021 22:32, Pavel Begunkov wrote:
> In case of failure io_wq_submit_work() needs to post an CQE and so
> potentially take uring_lock. The safest way to deal with it is to do
> that from under task_work where we can safely take the lock.
> 
> Also, as io_iopoll_check() holds the lock tight and releases it
> reluctantly, it will play nicer in the furuter with notifying an
> iopolling task about new such pending failed requests.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
> @@ -2371,11 +2371,22 @@ static void io_req_task_queue(struct io_kiocb *req)
>  	req->task_work.func = io_req_task_submit;
>  	ret = io_req_task_work_add(req);
>  	if (unlikely(ret)) {
> +		ret = -ECANCELED;

That's a stupid mistake. Jens, any chance you can fold in a diff below?

>  		percpu_ref_get(&req->ctx->refs);
>  		io_req_task_work_add_fallback(req, io_req_task_cancel);
>  	}
>  }

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1cb5e40d9822..582306b1dfd1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2371,7 +2371,7 @@ static void io_req_task_queue(struct io_kiocb *req)
 	req->task_work.func = io_req_task_submit;
 	ret = io_req_task_work_add(req);
 	if (unlikely(ret)) {
-		ret = -ECANCELED;
+		req->result = -ECANCELED;
 		percpu_ref_get(&req->ctx->refs);
 		io_req_task_work_add_fallback(req, io_req_task_cancel);
 	}
