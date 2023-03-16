Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C06F86BD87D
	for <lists+io-uring@lfdr.de>; Thu, 16 Mar 2023 20:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjCPTBs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Mar 2023 15:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbjCPTBq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Mar 2023 15:01:46 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C62BEE20FB
        for <io-uring@vger.kernel.org>; Thu, 16 Mar 2023 12:01:45 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id bp11so1552168ilb.3
        for <io-uring@vger.kernel.org>; Thu, 16 Mar 2023 12:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678993305; x=1681585305;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dr0JenSZTfgvBDt5ctYqmIxEaiHBoB1L+lvdc14PxbY=;
        b=MszB2l6uewYnYB3bGQR6Var1AkaWqVhjrkkcWL6rM2OFCuLjRck4SX01SS3EEmNTOt
         byhJ7zAtLOOgsRblJIVQbqJNstY7LEp2EiVsVLPtbjv+h6dLd8zurljNUHH+Nz+FvJLB
         kj55yvHNA674x53Ol40bMGPt/Av7Wn4mIqKsCyQ8mWDZTPt5Rtbjs58atYrsfgMICgGP
         5lBkM6J6niVpFe87vYNFmNtHJOpA0gtu+Hvy8eGM6uslMvOYIwp2NgqVRk3D0Icjq/qu
         K53Y9Lcj1fGRjWTrtKmawrhTjIooo5oVOt2+iyXqOmQ9ASbeQKBHP9Urq2Muq5AGMkBM
         hj5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678993305; x=1681585305;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dr0JenSZTfgvBDt5ctYqmIxEaiHBoB1L+lvdc14PxbY=;
        b=UwmYrtZnaXUOkTRDVtsxsUaEXOCM+JyI7Y2KMjbQmu9R6XnIniN5x6EIcFP8j4zhF4
         ilJnSEgKM7+k+hnM1azAHvIKwZe9TZerSKeJw3nG8SKWJvPolRn17C5i2+2sCjQX95uu
         nE10g0koOMrdRehKUQ8rbP7KzdnU/DDhx7yVZzwNfgTrMSjisjzXVO/3EFZfDUbB6yfC
         g46OGcJL4WcYMGPWNhPTU8VLP0zbCX4bh6EdCd7eN/bgPEQESmw86l2n1DuSH9p1/+nq
         IAcDthWRF3BxCDZ8Axd3cg170YRHvqFc/JCdSsv5lEfVbOCdQXOudNbBre/vrLameQfo
         lBwA==
X-Gm-Message-State: AO0yUKUCaAF2To2cSdir5aQCXuLjzAyovMWIjlvhLEurNW/MlQCfV9cQ
        oeeOMhM+NLn5xWFmkpyv+43o3IKPg8erIo38ABBKig==
X-Google-Smtp-Source: AK7set+ww9TnAgxPUQjcYjCw4hqV863M7VN4ZqZy09GZ2y4iLJ+p2cy+vYhxEmACwDzyl7QQzw8h8Q==
X-Received: by 2002:a05:6e02:dd3:b0:317:2f8d:528f with SMTP id l19-20020a056e020dd300b003172f8d528fmr2084878ilj.2.1678993304850;
        Thu, 16 Mar 2023 12:01:44 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 71-20020a020a4a000000b004040f9898ebsm6279jaw.148.2023.03.16.12.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 12:01:44 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     asml.silence@gmail.com, io-uring@vger.kernel.org,
        Breno Leitao <leitao@debian.org>
Cc:     linux-kernel@vger.kernel.org, gustavold@meta.com, leit@meta.com,
        kasan-dev@googlegroups.com
In-Reply-To: <20230223164353.2839177-1-leitao@debian.org>
References: <20230223164353.2839177-1-leitao@debian.org>
Subject: Re: [PATCH v3 0/2] io_uring: Add KASAN support for alloc caches
Message-Id: <167899330412.128512.9758823252493186358.b4-ty@kernel.dk>
Date:   Thu, 16 Mar 2023 13:01:44 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-2eb1a
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Thu, 23 Feb 2023 08:43:51 -0800, Breno Leitao wrote:
> This patchset enables KASAN for alloc cache buffers. These buffers are
> used by apoll and netmsg code path. These buffers will now be poisoned
> when not used, so, if randomly touched, a KASAN warning will pop up.
> 
> This patchset moves the alloc_cache from using double linked list to single
> linked list, so, we do not need to touch the poisoned node when adding
> or deleting a sibling node.
> 
> [...]

Applied, thanks!

[1/2] io_uring: Move from hlist to io_wq_work_node
      commit: 80d5ea4e019d5ac0257c9bf06a7bcf30c9500adc
[2/2] io_uring: Add KASAN support for alloc_caches
      commit: 80d5ea4e019d5ac0257c9bf06a7bcf30c9500adc

Best regards,
-- 
Jens Axboe



