Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6655C75ECA1
	for <lists+io-uring@lfdr.de>; Mon, 24 Jul 2023 09:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbjGXHjO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Jul 2023 03:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjGXHjN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Jul 2023 03:39:13 -0400
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 647E9180;
        Mon, 24 Jul 2023 00:39:10 -0700 (PDT)
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3163eb69487so3145192f8f.1;
        Mon, 24 Jul 2023 00:39:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690184349; x=1690789149;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r3c21fZlC0KRnz3kLqOIBEGeprFwWXQT2AytBpy+S6I=;
        b=MDiGT45Jia46d6K2KpnrPiUmazseorqGszvr7897suhMdjh717FcYZKoibKuEOwRSU
         WvECIP+C+ogPc3ygH5VzZcO3LsNsnYWnFOSG3+vFfOtDjxqeFbAE15Bc1iclFK+q1HRf
         TLquOVunDTav8mz1Rfupc2E0vb2+PzOf2Vp6JtZYLWm0l+Ba6wOCRRHMRc5GIaA4Up5i
         UVAavWPEAVG1Ot2pXPb6xnkpeiYvlGCpXnXZIPREzqjEKvxZr4a52sLBsgFYYEbhfLSq
         /NoTtKjoUcZRR9Wc6neK2M5yMhFSGPQt+RKO3Kr4uBXkOSalOi1xb3GK1sSCJJMTivSD
         qz8g==
X-Gm-Message-State: ABy/qLar+LZ6/55TWzc67qKdF8Zf2OrMHlEyWZMeb2gFDyx65/4gTql1
        CvMG6+kabsUwNgZ9XG8BgGLNOv/zkALXpw==
X-Google-Smtp-Source: APBJJlFc+I0Ove3B+q7CdMlUexJdLMe/NJNkJeHcnmrXtpPsJgnPW2/z3WAEKsY02B7RJKRdXQMhBg==
X-Received: by 2002:adf:eec2:0:b0:317:417e:a467 with SMTP id a2-20020adfeec2000000b00317417ea467mr5085884wrp.6.1690184348831;
        Mon, 24 Jul 2023 00:39:08 -0700 (PDT)
Received: from [192.168.1.58] (185-219-167-24-static.vivo.cz. [185.219.167.24])
        by smtp.gmail.com with ESMTPSA id w2-20020a5d4b42000000b0030ae53550f5sm11918440wrs.51.2023.07.24.00.39.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jul 2023 00:39:08 -0700 (PDT)
Message-ID: <047346f8-9ac4-4990-2885-8bfac47b83a3@kernel.org>
Date:   Mon, 24 Jul 2023 09:39:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 1/2] io_uring: Fix io_uring mmap() by using
 architecture-provided get_unmapped_area()
Content-Language: en-US
To:     Helge Deller <deller@gmx.de>, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-ia64@vger.kernel.org, linux-parisc@vger.kernel.org
Cc:     matoro <matoro_mailinglist_kernel@matoro.tk>
References: <20230721152432.196382-1-deller@gmx.de>
 <20230721152432.196382-2-deller@gmx.de>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20230721152432.196382-2-deller@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 21. 07. 23, 17:24, Helge Deller wrote:
> The io_uring testcase is broken on IA-64 since commit d808459b2e31
> ("io_uring: Adjust mapping wrt architecture aliasing requirements").
> 
> The reason is, that this commit introduced an own architecture
> independend get_unmapped_area() search algorithm which finds on IA-64 a
> memory region which is outside of the regular memory region used for
> shared userspace mappings and which can't be used on that platform
> due to aliasing.
> 
> To avoid similar problems on IA-64 and other platforms in the future,
> it's better to switch back to the architecture-provided
> get_unmapped_area() function and adjust the needed input parameters
> before the call. Beside fixing the issue, the function now becomes
> easier to understand and maintain.
> 
> This patch has been successfully tested with the io_uring testcase on
> physical x86-64, ppc64le, IA-64 and PA-RISC machines. On PA-RISC the LTP
> mmmap testcases did not report any regressions.
> 
> Signed-off-by: Helge Deller <deller@gmx.de>
> Cc: Jens Axboe <axboe@kernel.dk>
> Reported-by: matoro <matoro_mailinglist_kernel@matoro.tk>
> Fixes: d808459b2e31 ("io_uring: Adjust mapping wrt architecture aliasing requirements")

Tested-by: Jiri Slaby <jirislaby@kernel.org>

thanks,
-- 
js
suse labs

