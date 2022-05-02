Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A212B517042
	for <lists+io-uring@lfdr.de>; Mon,  2 May 2022 15:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354928AbiEBN3s (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 May 2022 09:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385267AbiEBN3m (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 May 2022 09:29:42 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E8012AD8
        for <io-uring@vger.kernel.org>; Mon,  2 May 2022 06:26:02 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id r9so12668041pjo.5
        for <io-uring@vger.kernel.org>; Mon, 02 May 2022 06:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=u1bDTYTZw1pMjI7Gqthg6fqrtoSnEG5Dk6/Cva86VCI=;
        b=J8Zdfqky2G1V8EPU1ecXE3UoyFHfxsLoaZAqG1MZpJBsvn3p/pzvopC7EtHDzygAzv
         WD3/uf9+OzfoKTnviGt0r3Wf9rA3sBjvr6JQ34+f2CZqLVAu3nCeEV6HQq0OXGPtBap+
         WaZAaLCC0IXSkD0EcLYc7qX5h3MpjEoBY/Xd3bH4olmsTKKcEulfGRHQmB4ZfIhiYfqK
         SSPMfQv4pFCtmO17HeunMnDleLR/4yhC/Untzzc5EWObwKj3ToOw0qGR2Jf9jtXM7imX
         SW5LG9+WIexO9pvqe4S3Pp0Gr39wvgtlcSq4aFpbqOyk0Msg0XRXTREEnLeAhq7EoiF8
         9w4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=u1bDTYTZw1pMjI7Gqthg6fqrtoSnEG5Dk6/Cva86VCI=;
        b=pKRHZdwiAkHVfSlNdyFFlXxNLwfaxm2w3g3VLUHp16CRPXJZCnsKLsuhI4PzSgE2Vh
         RrdT7LlpEbjj3KhhW1rkcRVNmH24PLkiEbBrG7QWX9IfWtJ/bylGLaBP7Mvftl2lH3QV
         mXLJ5+zqzsPxta5gaAX2owzhQiDQv1hr3AzhUEy+7FyIQsYifxOuHyylunlWV7vak60L
         SIRLBb82xYL0Eyfr2npC0cpUrg5ero+Gqjnx6+obQ7O3RutpWsROrlgL/Khd0CzGKCCw
         FLXTqZbY5b7iAdgIWuep2wc4i9KMhvYb2iG6BuXRnH6ooVmuYVlmL1WFiC2niZl1uIAG
         UbGw==
X-Gm-Message-State: AOAM532PEFq3rz1cWUTcPTRgXQLM5sTa8TItLmpq/+q+F9OXX7sEO49a
        5bFE8AXE09SWCegYdy+547+ZOg==
X-Google-Smtp-Source: ABdhPJzQTiuO7lIQ/FePbEmWbZv+DY73/I4ctb8nms0SxtRXkj+EdjJSmDi2u1196zt5vr0VCWjOpA==
X-Received: by 2002:a17:90b:3b4c:b0:1da:2001:a222 with SMTP id ot12-20020a17090b3b4c00b001da2001a222mr13020897pjb.84.1651497962364;
        Mon, 02 May 2022 06:26:02 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id m10-20020a170902db0a00b0015e8d4eb2dbsm4627740plx.293.2022.05.02.06.26.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 May 2022 06:26:01 -0700 (PDT)
Message-ID: <6ad38ecc-b2a9-f0e9-f7c7-f312a2763f97@kernel.dk>
Date:   Mon, 2 May 2022 07:26:00 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [REGRESSION] lxc-stop hang on 5.17.x kernels
Content-Language: en-US
To:     Daniel Harding <dharding@living180.net>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     regressions@lists.linux.dev, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <7925e262-e0d4-6791-e43b-d37e9d693414@living180.net>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <7925e262-e0d4-6791-e43b-d37e9d693414@living180.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/2/22 7:17 AM, Daniel Harding wrote:
> I use lxc-4.0.12 on Gentoo, built with io-uring support
> (--enable-liburing), targeting liburing-2.1.  My kernel config is a
> very lightly modified version of Fedora's generic kernel config. After
> moving from the 5.16.x series to the 5.17.x kernel series, I started
> noticed frequent hangs in lxc-stop.  It doesn't happen 100% of the
> time, but definitely more than 50% of the time.  Bisecting narrowed
> down the issue to commit aa43477b040251f451db0d844073ac00a8ab66ee:
> io_uring: poll rework. Testing indicates the problem is still present
> in 5.18-rc5. Unfortunately I do not have the expertise with the
> codebases of either lxc or io-uring to try to debug the problem
> further on my own, but I can easily apply patches to any of the
> involved components (lxc, liburing, kernel) and rebuild for testing or
> validation.  I am also happy to provide any further information that
> would be helpful with reproducing or debugging the problem.

Do you have a recipe to reproduce the hang? That would make it
significantly easier to figure out.

-- 
Jens Axboe

