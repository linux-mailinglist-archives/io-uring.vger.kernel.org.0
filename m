Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 054E3620CD0
	for <lists+io-uring@lfdr.de>; Tue,  8 Nov 2022 11:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbiKHKDo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Nov 2022 05:03:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232940AbiKHKDU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Nov 2022 05:03:20 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C90C2871E
        for <io-uring@vger.kernel.org>; Tue,  8 Nov 2022 02:03:19 -0800 (PST)
Received: from [10.7.7.5] (unknown [182.253.88.158])
        by gnuweeb.org (Postfix) with ESMTPSA id 61325814AD;
        Tue,  8 Nov 2022 10:03:17 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1667901799;
        bh=RsvE9uOmG0HFTpH75E9cs2nvEBlN95OddmTFCi0LW/I=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=nTWwAr+f3PoeDibRtQgAZ6azx3lcd/UN4VWcykaw4SXuZ27whq0yklr15uD3GilBf
         N19nzp+Dn/UxAoLHGG6dVZHlFz36oQQ0mieetfJAl/tXXdVyLd/iOYiZlB+gMfd7eM
         FS81OXPdVc+MutR6M0OiEI3aLQZEFQERb2fWEjaarjTE7AKSUGh04vME9aLgiYuEdx
         Nsh/MV9fuwngf7usR0VGahjtXRPVVR8d/HY+zNX4osPLPCS0aZooAIsk0cKRLEDbNt
         S1NvBUAzLj7/gagxu5YQPERXUz0hCaAxCi9ag0F67jIHRMLr/HGgYY/dvpIbt/IGBe
         mx3eilmicUSKg==
Message-ID: <ec9d2f60-5182-15f8-6648-8632d5b67698@gnuweeb.org>
Date:   Tue, 8 Nov 2022 17:03:15 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH liburing v2] test that unregister_files processes task
 work
Content-Language: en-US
To:     Dylan Yudaken <dylany@meta.com>
Cc:     Facebook Kernel Team <kernel-team@fb.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <20221108095347.3830634-1-dylany@meta.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <20221108095347.3830634-1-dylany@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/8/22 4:53 PM, Dylan Yudaken wrote:
> +	ret = io_uring_register_files(&ring, &fds[0], 2);
> +
> +	sqe = io_uring_get_sqe(&ring);
> +	io_uring_prep_read(sqe, 0, &buff, 1, 0);
> +	sqe->flags |= IOSQE_FIXED_FILE;
> +	ret = io_uring_submit(&ring);
> +	if (ret != 1) {
> +		fprintf(stderr, "bad submit\n");
> +		return 1;
> +	}

This assignment is meaningless:

    ret = io_uring_register_files().

It's overwritten by ret = io_uring_submit() anyway. I suppose we
should have an error handler right after register_files().

-- 
Ammar Faizi
