Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D036506B49
	for <lists+io-uring@lfdr.de>; Tue, 19 Apr 2022 13:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349594AbiDSLnS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Apr 2022 07:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351996AbiDSLmj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Apr 2022 07:42:39 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ADC738D93
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 04:38:05 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id q3so15508659plg.3
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 04:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=6GFQOE1YeR9sSITNeLz+gFk0oDCAu4A6itQhrZvxCRk=;
        b=AOk6EYOZsfJFoIcNMhVaje4rJ7b0C2cnLD/k0JgySyT7wG9qvt0Fy4eWd/vuS9wcG4
         bQnFYMhjkIyzP88iVgP5b2jfTY7Nlago56AATp2XMOqCw4oymYlGK96QzALvps3vmjjO
         BsZheFlknBxZp4YuyhJgAKhN6yqX9pnmdEaaxlMsTGhQGoVvf5yVmejoOwYlCY99gzqI
         UMaIB54+vnGa+FCFwDSYkNQbUUuq3/qQdSGcP+GCNthJaUygx9Q4qSoFVMyi1k435w/H
         CIV4+/Gap6G1wR8Iwjlen1sVfgMFjVUV1ZGyRriDUJ9kh1b9bGhyBBXNDtMIvVf4Cvmf
         arSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6GFQOE1YeR9sSITNeLz+gFk0oDCAu4A6itQhrZvxCRk=;
        b=MSenjmB7GhNUOV960cCXUBusQf7RxLu34CXNksoXT/DtvVIa+Pxwuljf3f2+44WE0I
         qVIqEzB6fcK/t5Lm9Q75P2IZqQfrg4w7pQeMTjqLH9TIkXscub7Yja5Xq+3GG7a5vTPy
         eIOV470tLl3opPRQu8Opk2J+6Lnl3Wskftslf66d8gkXoXXWvltA7vMTeS+6fwaLYTdx
         Cd5k0GiRbu+YJwQKHKYQmFgHcveQXOk8oITpr7UQy6dcVxuEEae42IaFIJy8UFZiMPfr
         6RvCH3/3f9QMuvgXcP/Axl8zFz2L4c2wp2mgZbvZq5Id2FDbG0hLSixj+XiHqyVEkyDV
         VtfA==
X-Gm-Message-State: AOAM532/nrZ1TiBKq5KLf+9yFKrqg6ogwFU423BuGC2uN7eRKDrkyEcV
        qfgd5Ia4jDkSpe0AafWjfcuX9+V1LBCJvQ1b
X-Google-Smtp-Source: ABdhPJwDS9JqV2rhOY3Fo7UhGzZ8iE3vs/d5glEdnr/YCUyruIuOlVW+d4Gwa8EcdFOGmAQAyYXyiQ==
X-Received: by 2002:a17:90b:4d0a:b0:1d1:7bd:cb00 with SMTP id mw10-20020a17090b4d0a00b001d107bdcb00mr21474954pjb.242.1650368283458;
        Tue, 19 Apr 2022 04:38:03 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id l8-20020a17090a150800b001cbaf536a3esm20277622pja.18.2022.04.19.04.38.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Apr 2022 04:38:02 -0700 (PDT)
Message-ID: <9e277a23-84d7-9a90-0d3e-ba09c9437dc4@kernel.dk>
Date:   Tue, 19 Apr 2022 05:38:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: IORING_OP_POLL_ADD slower than linux-aio IOCB_CMD_POLL
Content-Language: en-US
To:     Avi Kivity <avi@scylladb.com>, io-uring@vger.kernel.org
References: <9b749c99-0126-f9b2-99f5-5c33433c3a08@scylladb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <9b749c99-0126-f9b2-99f5-5c33433c3a08@scylladb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/19/22 5:07 AM, Avi Kivity wrote:
> A simple webserver shows about 5% loss compared to linux-aio.
> 
> 
> I expect the loss is due to an optimization that io_uring lacks -
> inline completion vs workqueue completion:

I don't think that's it, io_uring never punts to a workqueue for
completions. The aio inline completions is more of a hack because it
needs to do that, as always using a workqueue would lead to bad
performance and higher overhead.

So if there's a difference in performance, it's something else and we
need to look at that. But your report is pretty lacking! What kernel are
you running?

Do you have a test case of sorts?

For a performance oriented network setup, I'd normally not consider data
readiness poll replacements to be that interesting, my recommendation
would be to use async send/recv for that instead. That's how io_uring is
supposed to be used, in a completion based model.

-- 
Jens Axboe

