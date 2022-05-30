Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F38D6538909
	for <lists+io-uring@lfdr.de>; Tue, 31 May 2022 00:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236615AbiE3W4C (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 May 2022 18:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234309AbiE3W4C (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 May 2022 18:56:02 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62BD6344E8
        for <io-uring@vger.kernel.org>; Mon, 30 May 2022 15:56:00 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id el14so4360621qvb.7
        for <io-uring@vger.kernel.org>; Mon, 30 May 2022 15:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=EUgk0vWcshq6YnMpZN7jx877fDVZaQy12ezYaUTsUxs=;
        b=3anMRBiwApLpCP82HO23yWVL+Ac3cSd5T36FlE40yquLhdcJ7fsURaOS6sk4SXDOWn
         U9hgfO0HEMsj8CqAUKiVDNZdyfYvJmhG+l7h5XL5l/BpTZORtlyzsdgdtMq75D817qNd
         bzi/ckp8YNZoCwerMqruX1Lgx6A/y3Oj/maIinyaDNBwZ9vM6xD9GUns9AZV8Q6228kV
         HLMyPQ0TmfYTYg4INFjsJdcVqIP8m+mxAaZ0k/2XcKdMPakcml9leRL3rzEZvTyRMdJv
         z0UQjFmVlO3ocDVmj7jqGznpJDZNR1RM2ST4eEWclGmLqTX307Tr+YaB0eJ+sJM+I3zb
         Hy3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=EUgk0vWcshq6YnMpZN7jx877fDVZaQy12ezYaUTsUxs=;
        b=JQZirwbYJagL50Zpysx6HZpMnqukBeEZZfodjO5nSEj84XU6je1AH9hrkAvH9wF2OM
         g689wJJRItjwlt+MWJqaESfs3HCt70s5/YnlgKaA9Irh+u02/jSbyGWJ53iC1xxpoRVC
         Y2wshTS9hSqNS9mbGwsKcq1K4fhnlc9ePbBbKFqHKJ1lGQAv5IE8HT+O5YXmGP9B1Q9z
         SWv6fMtYck8xAVhNAw43TTMIPW+yHWChrdwFDU7JSz2XQh0LxhNL2x79JHSsVOdveHtb
         YKXsb4MG9oXCE52KKj7077ITG+hEBp6XoGKlLVqfBpOfVBViLeTSy9v86hjzO4YWgH8W
         ccPA==
X-Gm-Message-State: AOAM532pFh7+Gw5HtZlYCeYkNn/Y672inFoey2xB7yARnjghN4t+P7/e
        eBGzvfefu/T5G1/dCn/66T05/WF2pPu8jQ==
X-Google-Smtp-Source: ABdhPJyu2p6CNMsm54aZUoFM/PQjrld5zm3kgKMLwK1u+wqlr075iY9pnsRQnH8dEP9hpwYvZDQqmw==
X-Received: by 2002:a05:6214:149:b0:462:60fc:ad8a with SMTP id x9-20020a056214014900b0046260fcad8amr25664126qvs.131.1653951359313;
        Mon, 30 May 2022 15:55:59 -0700 (PDT)
Received: from [172.19.130.177] ([8.46.76.77])
        by smtp.gmail.com with ESMTPSA id 22-20020a05620a079600b0069fe1dfbeffsm7983084qka.92.2022.05.30.15.55.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 May 2022 15:55:58 -0700 (PDT)
Message-ID: <50c38579-c8de-6f23-d24b-1450123a7517@kernel.dk>
Date:   Mon, 30 May 2022 16:55:45 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [LIBURING PATCH v2] Let IORING_OP_FILES_UPDATE support to choose
 fixed file slots
Content-Language: en-US
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220530173604.38000-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220530173604.38000-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/30/22 11:36 AM, Xiaoguang Wang wrote:
> Allocate available direct descriptors instead of having the
> application pass free fixed file slots. To use it, pass
> IORING_FILE_INDEX_ALLOC to io_uring_prep_files_update(), then
> io_uring in kernel will store picked fixed file slots in fd
> array and let cqe return the number of slots allocated.

Thanks, applied and made a few tweaks. Most notably renaming
the helper to io_uring_prep_close_direct_unregister() which
is pretty long but more descriptive than _all() which doesn't
really tell us anything useful I think.

Please check and see if you agree with that, and the man page
tweak as well.

-- 
Jens Axboe

