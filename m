Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A110613AF3
	for <lists+io-uring@lfdr.de>; Mon, 31 Oct 2022 17:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbiJaQEz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 Oct 2022 12:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbiJaQEy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 Oct 2022 12:04:54 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D50EB1C
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 09:04:52 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id b185so11055655pfb.9
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 09:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rSxb84llw5POmmDA6ANBBpK1C+wa4yK5aiX+cAdV+hQ=;
        b=wfc3Jrq74YPfGpzxtxUmtyS4g4tEsefyYpaaeP/m8Y6g1TK40zlXsPBMYLtut1z1Xc
         Xgw8QBUCSE0Pa+/+qnzzAIY9ONtjsoGuFvD6cxf2SpCvXRe/LUNzTb5LKKVCBUqWTXhw
         6fB2UXh6NJ9ExCQR0TPti3l8soQqsZkrGU9gTFuWXVj3kzANF4j5ODiwyv44XqyhPjFb
         7JrW4wCYNpHc7Gejfi+P49slp4LQ+bhB4Ae9r0rF5UbWYhMtMrdCSgycWrf4iMDhUIPW
         qudbCRBUBZ5hL4LgTv0oFIResTiL/+8PIc0VgDwfKood+OvJrTbTQdyC2BoWWWbIArmC
         q0bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rSxb84llw5POmmDA6ANBBpK1C+wa4yK5aiX+cAdV+hQ=;
        b=dj5/wyTyyJAWRXflNnDZCCQgA4m1drSg14ri5AyyI6W06yYb7pUUSF5rV02CDykX+V
         83rT/lkMlifeN9Buvifsq/NUgNzAWzOFATrmB7G23MXbPSb0WrJ7qWttmku2Opf7Iaos
         YmI7TvZxGL+ELZsjQd+s5DY2ce9t0aHhSJScBF7/Ps5gKyOPKZCvK8Wze+b6FrIJ/7FY
         pzK/HA8AJMHHRtVQ2Xhzlv5OMGNVu2RZTaYYLl3M7Ye2RwTTxb57maa37aS45IFP1+Up
         zQk7F7cg148QmJrbLm7NIMO2DL3yRwP60Lnp9Ghec3CKwgn827vgR7zXqW2DuGr+2FxS
         yp5g==
X-Gm-Message-State: ACrzQf0mEZCzRnBII/Z09WVt4Ianb56cfH3ftcfRpQJsRZULWCALqe+O
        1bdq/syGXl5Au+8EfZ4lLT8lrA==
X-Google-Smtp-Source: AMsMyM4Q1mux/0uAFUByTW1nXvkrB3s3i6oh+BGSkusb61cT0gx2djrwLat5ngHoi/zskMgAX7sqzg==
X-Received: by 2002:a63:1349:0:b0:44b:2240:b311 with SMTP id 9-20020a631349000000b0044b2240b311mr13013766pgt.405.1667232291619;
        Mon, 31 Oct 2022 09:04:51 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 2-20020a620502000000b0056203db46ffsm4908543pff.172.2022.10.31.09.04.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Oct 2022 09:04:51 -0700 (PDT)
Message-ID: <a482ab89-37af-2df7-1863-438a7615c905@kernel.dk>
Date:   Mon, 31 Oct 2022 10:04:50 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH for-next 06/12] io_uring: add fixed file peeking function
Content-Language: en-US
To:     Dylan Yudaken <dylany@meta.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com
References: <20221031134126.82928-1-dylany@meta.com>
 <20221031134126.82928-7-dylany@meta.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20221031134126.82928-7-dylany@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/31/22 7:41 AM, Dylan Yudaken wrote:
> @@ -1849,17 +1866,14 @@ inline struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
>  	unsigned long file_ptr;
>  
>  	io_ring_submit_lock(ctx, issue_flags);
> -
> -	if (unlikely((unsigned int)fd >= ctx->nr_user_files))
> -		goto out;
> -	fd = array_index_nospec(fd, ctx->nr_user_files);
> -	file_ptr = io_fixed_file_slot(&ctx->file_table, fd)->file_ptr;
> +	file_ptr = __io_file_peek_fixed(req, fd);
>  	file = (struct file *) (file_ptr & FFS_MASK);
>  	file_ptr &= ~FFS_MASK;
>  	/* mask in overlapping REQ_F and FFS bits */
>  	req->flags |= (file_ptr << REQ_F_SUPPORT_NOWAIT_BIT);
>  	io_req_set_rsrc_node(req, ctx, 0);
> -out:
> +	WARN_ON_ONCE(file && !test_bit(fd, ctx->file_table.bitmap));
> +
>  	io_ring_submit_unlock(ctx, issue_flags);
>  	return file;
>  }

Is this WARN_ON_ONCE() a leftover from being originally based on a tree
before:

commit 4d5059512d283dab7372d282c2fbd43c7f5a2456
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Sun Oct 16 21:30:49 2022 +0100

    io_uring: kill hot path fixed file bitmap debug checks

got added? Seems not related to the changes here otherwise.

-- 
Jens Axboe
