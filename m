Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7C34D44FD
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 11:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241410AbiCJKvy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 05:51:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241406AbiCJKvx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 05:51:53 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A9FF4ECEA
        for <io-uring@vger.kernel.org>; Thu, 10 Mar 2022 02:50:53 -0800 (PST)
Received: from [192.168.43.69] (unknown [114.10.7.234])
        by gnuweeb.org (Postfix) with ESMTPSA id 69BB37E2A8;
        Thu, 10 Mar 2022 10:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1646909452;
        bh=44z16Psp1/61+s0UDwU+Lqf5cI03j0t229G6p/Mvp9c=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=qqT7FG2gzhMt/C5dGSA/cdUbtDAWH70GO1c8rbQ0y7sfRMoLPuYEo51+XdM5bZq2G
         PwRmthKSmuTK/sZHLSvQA1MfQBSQPIVj8NvRVufuq9rW4/8LIqBhjfbphOWvQ+lrWX
         ylrsZz99YRL0FfXb3CKXBOMPHGsttDJYjSJczFYQzNNf4T2W8X8aXzEGMvrUc2hG6z
         86JIBDTlphNwRwuNeG5N6R2T/bg7n7nzOdgrPSI/IyAaggQyQtcJvRJbcZcUCkyA4q
         Vm4FJ1W0k8PADh6LSrTPpLskbBZn/GxeoPlcFKNQ83A/JhNWrS8oT84zbu/p6iFVgt
         3vKd9i51ta71g==
Message-ID: <628f2f77-b20c-ac5f-90cc-586a9939b6af@gnuweeb.org>
Date:   Thu, 10 Mar 2022 17:50:41 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        io-uring <io-uring@vger.kernel.org>, gwml <gwml@vger.gnuweeb.org>
References: <20220310103224.1675123-1-alviro.iskandar@gnuweeb.org>
 <20220310103224.1675123-3-alviro.iskandar@gnuweeb.org>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH liburing v2 2/4] src/Makefile: Add header files as
 dependency
In-Reply-To: <20220310103224.1675123-3-alviro.iskandar@gnuweeb.org>
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

On 3/10/22 5:32 PM, Alviro Iskandar Setiawan wrote:
> When the header files are modified, the compiled objects are not going
> to be recompiled because the header files are not marked as a dependency
> for the objects.
> 
>    - Instruct the compiler to generate dependency files.
> 
>    - Include those files from src/Makefile. Ensure if any changes are
>      made, files that depend on the changes are recompiled.
> 
> Suggested-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>

You should add the dependency files to .gitignore, otherwise we will have
these files untracked after build.

   Untracked files:
     (use "git add <file>..." to include in what will be committed)
           src/queue.ol.d
           src/queue.os.d
           src/register.ol.d
           src/register.os.d
           src/setup.ol.d
           src/setup.os.d
           src/syscall.ol.d
           src/syscall.os.d

Also, when doing `make clean`, the dependency files should be removed.

-- 
Ammar Faizi
