Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3AD424988
	for <lists+io-uring@lfdr.de>; Thu,  7 Oct 2021 00:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbhJFWW4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Oct 2021 18:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbhJFWW4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Oct 2021 18:22:56 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18A95C061746
        for <io-uring@vger.kernel.org>; Wed,  6 Oct 2021 15:21:03 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id qe4-20020a17090b4f8400b0019f663cfcd1so5482971pjb.1
        for <io-uring@vger.kernel.org>; Wed, 06 Oct 2021 15:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VR3m3Z9i/FqjIVRW11mH0YC8p944hXvuAisUepkPmMI=;
        b=GIBCuFTvyVGVwmuqdkfIecxbtlykZyTRmJjTfD2EDLkMuMsNumvcVSNdVchnKtdJeC
         9hexapntaeX7Q7whvBWbc3+8ljQr9BODleWUyoY3u/ytr5HTlGqXWR1oOVLIjx2tuN1C
         pDS73gyRzMZySYj/aseUVqxuoQVvRBfwr/MyLnuniDB5n4Aoq7Db8Fb7/XLbtbdbPDph
         X94OGQg1zgV61TlT4v+54ZNOu4Gq3dAiJme5YJEMTlqHTjrlnVYP5SM+GZDBQH+qiMYp
         +/5iT3eXgKDzpgAG0cAiVCyWlSNi3Ox1DQ3mJ3oimUJTeJO37E2VHuQd4QBPniHMi1dA
         8ClQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VR3m3Z9i/FqjIVRW11mH0YC8p944hXvuAisUepkPmMI=;
        b=nuyiveGuO7mim7eZ/qp7ex9KcHSOBk5xmbJyHO+XfvPXUwwVK1KvFDFFeHdblvZTsf
         7/cog9f2mucAQ9XnZ6pvJ+3i5cKuNN1fhdNBs97pIwZNwvH5ixxd65WghDIsK2YD4z81
         5JdbGqCnoYfzmUWfo2GluMiBtpxC8yOeUd7LIUhOsNZInL2end13W+GCpVIimVNg0XOq
         MOnBsoOfuy67zcI/x6prFsQv0+hliabIJKeiiRhPPZmWWZe/M6t++wULPpVxm9s4FZco
         PhDYMN06ZshCK5V/c3kg6nmAcYBuvPcTm7SYHNsEFXp3aDN4al50jNTjtNcHGZs+ab0A
         cJwQ==
X-Gm-Message-State: AOAM532iGm7sJhY7kfua/nVvk2PnQAlp8TpMCMgowYY2Uh0JY4yeobUc
        4rln6Tn7HDTPT3QLEbxrHKjDNA==
X-Google-Smtp-Source: ABdhPJxmQDVPEDs6YZ/bblYg5i6CgGQZwSiyZgH8gpiIuHglI24L4VRf3ie+RcMoeqIDw8Vq1FSA8Q==
X-Received: by 2002:a17:90b:3782:: with SMTP id mz2mr1412212pjb.160.1633558862489;
        Wed, 06 Oct 2021 15:21:02 -0700 (PDT)
Received: from integral.. ([182.2.71.97])
        by smtp.gmail.com with ESMTPSA id t1sm21022904pgf.78.2021.10.06.15.20.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 15:21:02 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: Re: [PATCHSET v1 RFC liburing 0/6] Add no libc support for x86-64 arch
Date:   Thu,  7 Oct 2021 05:20:30 +0700
Message-Id: <20211006222030.1208080-1-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <efeb2d62-e963-6373-79ae-f8aa2d3bae1c@kernel.dk>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Oct 7, 2021 at 1:48 AM Jens Axboe <axboe@kernel.dk> wrote:
>On 10/6/21 8:49 AM, Ammar Faizi wrote:
>> Hi everyone,
>> 
>> This is the v1 of RFC to support build liburing without libc.
>> 
>> In this RFC, I introduce no libc support for x86-64 arch. Hopefully,
>> one day we can get support for other architectures as well.
>> 
>> Motivation:
>> Currently liburing depends on libc. We want to make liburing can be
>> built without libc.
>> 
>> This idea firstly posted as an issue on the liburing GitHub
>> repository here: https://github.com/axboe/liburing/issues/443
>> 
>> The subject of the issue is: "An option to use liburing without libc?".
>
>This series seems to be somewhat upside down. You should fix up tests
>first, then add support for x86-64 nolibc, then enable it. You seem to
>be doing the opposite?
>
>-- 
>Jens Axboe

Yes, that's what I am doing.

I agree with add support for x86-64 nolibc, then enable it. However,
the tests fixes happened very naturally.

I would not be able to caught those broken tests if I didn't add the
nolibc support.

There are two main problems with the tests, all of them are caught
after adding no libc support.

  1) The test uses `errno` to check error from liburing functions,
     this is only problematic with no libc build. I wouldn't be able
     to caught this without adding no libc support. I caught several
     tests failed after added no libc support, then investigated the
     failure causes and found the culprit (it's errno from the libc).

  2) The test uses `free()` to free the return value of
     `io_uring_get_probe{,_ring}` functions
     from liburing. This causes invalid free only for nolibc build.
     So it does really make sense to add no libc support first, then
     fix up the tests. Because there is no way I can know this broken
     situation earlier.

Since now I know everything about the situation, I can do so. So I
will send the RFC v2 and rebase everything based on your order.

Thanks for the comment.

-- 
Ammar Faizi
