Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA70A4C2042
	for <lists+io-uring@lfdr.de>; Thu, 24 Feb 2022 00:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244000AbiBWXvt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Feb 2022 18:51:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbiBWXvt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Feb 2022 18:51:49 -0500
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 667725D18F
        for <io-uring@vger.kernel.org>; Wed, 23 Feb 2022 15:51:20 -0800 (PST)
Received: by mail-qv1-xf34.google.com with SMTP id h13so910230qvk.12
        for <io-uring@vger.kernel.org>; Wed, 23 Feb 2022 15:51:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=5gg4vnO5fvCoFzchXk8UedfpIYu6olWOdtGlDVs8OG4=;
        b=Lz/iHobDnouq5uerVfNHAWRNIJzDrMYt80DZgrICu89Qw5Wq13SGQt2zwjQqfzzBAt
         4PH2/hWTfN+fIpyKs+L91Cz2b8oPTl3XASb/nojWolX5/q68V4G3L2lgHxeTkKCo2HsM
         TOkNXibpsdVOLeUd9ONQbv/cIzIrpmU+12Emw6OMSpkGFQN+EhQmXdvbonx8QvLSu4Ff
         w5AANHLmUygPmAbyogJF8/9u4AbP7uTAq4kDY+skCxChWhkkhYqrhSBdkiHSXpf0cnc2
         iYqmr+sDObNBBh3ttBpPDPPjVV6n/UUSjhXEBfehYbo81TdbTHo1I3MB+aizuTPLnvBb
         SW5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5gg4vnO5fvCoFzchXk8UedfpIYu6olWOdtGlDVs8OG4=;
        b=knc2ryV6ekq4YisWOjgpDvLK3C1IDwYxt5GX1MF3zc6jJAebmnpqFKY0zCnKBQwadr
         MjJOxGt9EfdeLKJT/tyfJcDn4XuTNRArrrjEORgCgX7S22oYh9sd4d+I1eaWt7HvE4dv
         3gV069BU+4Fh9d9T2QQ8bvRGt/R3Rm3ZKo65kXlcnSv+zEfVXO0Cm5Fu7YC0bcPMyifn
         VXfLUm/E+VjmeVIWbKRbKOrycNi5mOZXTgVcrP/I3g1hFQ2MFYpoQfoSdhhMkbZqR0pR
         OnpNwJaGtzWFFcN5aOE3wcBeN+r8lJ93l+L8FtEFfB+ThTTsxF9V6JTYuaFIfvUxR0X/
         ow+Q==
X-Gm-Message-State: AOAM5311XcLlYTPEt4uQ2bsZIIznIWPwnvxuABSPsOcoaoM2MMySnlNu
        8vM6knTFozo5JLATK7IGjERCYg==
X-Google-Smtp-Source: ABdhPJztfjpeMLDqH+umYTdXwU0vxlUjw5l+IeV7Ls4En2ujSxg2LJL6qSA0VmfTCYlBYtQAEWpZYQ==
X-Received: by 2002:a05:622a:1451:b0:2de:2c32:aeae with SMTP id v17-20020a05622a145100b002de2c32aeaemr186128qtx.129.1645660279427;
        Wed, 23 Feb 2022 15:51:19 -0800 (PST)
Received: from [172.19.131.148] ([8.46.73.115])
        by smtp.gmail.com with ESMTPSA id h4sm537487qkf.66.2022.02.23.15.51.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Feb 2022 15:51:19 -0800 (PST)
Message-ID: <568473ab-8cf7-8488-8252-e8a2c0ec586f@kernel.dk>
Date:   Wed, 23 Feb 2022 16:51:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v3 0/4] io_uring: consistent behaviour with linked
 read/write
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     kernel-team@fb.com
References: <20220222105504.3331010-1-dylany@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220222105504.3331010-1-dylany@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/22/22 3:55 AM, Dylan Yudaken wrote:
> Currently submitting multiple read/write for one file with offset = -1 will
> not behave as if calling read(2)/write(2) multiple times. The offset may be
> pinned to the same value for each submission (for example if they are
> punted to the async worker) and so each read/write will have the same
> offset.
> 
> This patch series fixes this.
> 
> Patch 1,3 cleans up the code a bit
> 
> Patch 2 grabs the file position at execution time, rather than when the job
> is queued to be run which fixes inconsistincies when jobs are run asynchronously.
> 
> Patch 4 increments the file's f_pos when reading it, which fixes
> inconsistincies with concurrent runs. 
> 
> A test for this will be submitted to liburing separately.

Applied 1-3 for now, as those are clean fixes and #4 is still being
debated. Thanks!

-- 
Jens Axboe

