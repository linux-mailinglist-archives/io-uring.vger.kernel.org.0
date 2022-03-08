Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4BE4D2483
	for <lists+io-uring@lfdr.de>; Tue,  8 Mar 2022 23:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235509AbiCHWxc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Mar 2022 17:53:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbiCHWxc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Mar 2022 17:53:32 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9113A111D
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 14:52:31 -0800 (PST)
Received: from [192.168.43.69] (unknown [182.2.69.180])
        by gnuweeb.org (Postfix) with ESMTPSA id 7A9247E6CA;
        Tue,  8 Mar 2022 22:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1646779951;
        bh=nehLnrEfoT879t+O/sDoMW4Zuj0TJc1qG45TqPBARGQ=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=NJeiK6UqoCuwe2689+eilK2EuVy4a6mUC+nI1TJoiH+u22psi51aagu5rOFVnvSV+
         Eb0ZoKvR0h8OTFE2qpJRwOXHj/xksEcNTi0b+pIn1kkO+FydSXNt5i8TAC+HIDhfe2
         fisAMRZdgOnlTSID5roG/JDpflAYueeRYUQXznqKLQ2r14sKh6l6vPike4FhZLHDqC
         /FGEMaYEacVemp1HJX738aqRTNeBsBe3PWipshstnwwgwqt8L7e5FwaoSH+6fkzq0/
         dzWxoAiAMgVNUIcXKPur/cWfLPvbwwa0kVk3TeR9SAxqVtCyQpAVqKZwi5sHNUPhZh
         dGqYTU6QixK7w==
Message-ID: <acccd7d5-4570-1da3-0f27-1013fb4138ab@gnuweeb.org>
Date:   Wed, 9 Mar 2022 05:52:24 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        io-uring@vger.kernel.org, gwml@vger.gnuweeb.org
References: <20220308224002.3814225-1-alviro.iskandar@gnuweeb.org>
 <20220308224002.3814225-3-alviro.iskandar@gnuweeb.org>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH liburing 2/2] src/Makefile: Add header files as dependency
In-Reply-To: <20220308224002.3814225-3-alviro.iskandar@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/9/22 5:40 AM, Alviro Iskandar Setiawan wrote:
> When the header files are modified, the compiled object are not going
> to be recompiled because the header files are not marked as dependency
> for the objects. Add those header files as dependency so it is safe
> not to do "make clean" after changing those files.
> 
> Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
> ---
>   src/Makefile | 15 ++++++++++-----
>   1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/src/Makefile b/src/Makefile
> index f19d45e..b9428b7 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -46,9 +46,16 @@ endif
>   liburing_objs := $(patsubst %.c,%.ol,$(liburing_srcs))
>   liburing_sobjs := $(patsubst %.c,%.os,$(liburing_srcs))
>   
> -$(liburing_srcs): syscall.h lib.h
> -
> -$(liburing_objs) $(liburing_sobjs): include/liburing/io_uring.h
> +$(liburing_objs) $(liburing_sobjs): \
> +	syscall.h \
> +	lib.h \
> +	arch/syscall-defs.h \
> +	arch/x86/syscall.h \
> +	arch/x86/lib.h \
> +	arch/aarch64/syscall.h \
> +	arch/generic/syscall.h \
> +	arch/generic/lib.h \
> +	include/liburing/io_uring.h

This is ugly, it blindly adds all of them to the dependency while
they're actually not dependencies for all the C files here. For
example, when compiling for x86, we don't touch aarch64 files.

It is not a problem for liburing at the moment, because we don't
have many files in the src directory now. But I think we better
provide a long term solution on this.

For the headers files, I think we should rely on the compilers to
generate the dependency list with something like:

    "-MT ... -MMD -MP -MF"

Then include the generated dependency list to the Makefile.

What do you think?

-- 
Ammar Faizi

