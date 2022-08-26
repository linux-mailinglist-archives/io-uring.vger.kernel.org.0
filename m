Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6352E5A2F3C
	for <lists+io-uring@lfdr.de>; Fri, 26 Aug 2022 20:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238115AbiHZSr1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Aug 2022 14:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbiHZSqf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Aug 2022 14:46:35 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE2CFEEF26
        for <io-uring@vger.kernel.org>; Fri, 26 Aug 2022 11:42:57 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id x26so2328023pfo.8
        for <io-uring@vger.kernel.org>; Fri, 26 Aug 2022 11:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc;
        bh=fjyjS0gBKRdFwH9IFueUA4SimHhGKvVMtpr2iqklhLo=;
        b=kHVB8o32jBxp9iPYuzfI2dr0EmZwxyMqC+GIwpmGii2JQ/9e5GlY5aiWiBHWBDXkFn
         QIpm6ldV2bxJzGG5MfeM9zdKCJCJ4aIOeCI87I6nnAd5dXZLFkY13JLQKs5wjG8NksHH
         INpuQ1dAnn95JGcebN9y0EhgoKEYDcKNPFaSULMZDp08MsOcNEJZZ4JJc/iFjPMgAJRa
         xjUM0njc+73Dn3pYPPyjSxotlQn0qKa7AHu0o1Qf1GhTOs+5BBUUZwqTSD2YazV90Z3E
         4VcgPMnwHKRatqp6ljZpilxcrCYUzSIsLE81d8h4K6tUrvXGDcYRceoWZIvJhN+I323i
         HO6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc;
        bh=fjyjS0gBKRdFwH9IFueUA4SimHhGKvVMtpr2iqklhLo=;
        b=trObIjPocb6m8NUwgN+wB+lS7lHv9kcWkfmhonfghPrK+nDCSHMdgO67ovLAfFy5mD
         PVWH5+jOM3JOWLuGwlQoTDCYRe9CvGqXZrqnMics3CbGuTS28cYpYN2AzruhMEkwdnzN
         gLgBR7LRJ7SG+6UZUO3iTpl77Ms1hf1AERKfT6rs8EumpcDUjbhTkOL7up/67ycP+K9p
         DzotGZhnyGZTowbm4NAoiAL36VnblOvhz6IX6tiz3P3SVTHstvvMwF/Rpc7EKKFvybfK
         rcoEDX5sz3f4jE1BOPL+W3VJj/UdnFDai2eEDzivRKCHXSBqy9P4EtEjg5p13qbWbjiV
         FJIg==
X-Gm-Message-State: ACgBeo1DJDWm1YmZHYibc8o3pxi9TQNSWCFAQRwVqfPqsz1hrPNSsTI7
        Q/vfTszl9aAkcMwbgNODmh+JHegaNCut9Q==
X-Google-Smtp-Source: AA6agR60rit9TB7KiswDQmqXgxuBX7cxc+1XpuaAAkd0KsGTHHDWXdRD4NMhGHMAdepQXfknwE3rmg==
X-Received: by 2002:a05:6a00:230f:b0:52f:6734:90fe with SMTP id h15-20020a056a00230f00b0052f673490femr5178892pfh.67.1661539377003;
        Fri, 26 Aug 2022 11:42:57 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b5-20020a1709027e0500b0016c1b178628sm1892282plm.269.2022.08.26.11.42.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Aug 2022 11:42:56 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>
Cc:     eschwartz93@gmail.com
In-Reply-To: <x49fshiq56k.fsf@segfault.boston.devel.redhat.com>
References: <x49fshiq56k.fsf@segfault.boston.devel.redhat.com>
Subject: Re: [patch] liburing: fix return code for test/hardlink.t
Message-Id: <166153937630.3366.5648352027619350618.b4-ty@kernel.dk>
Date:   Fri, 26 Aug 2022 12:42:56 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.10.0-dev-65ba7
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 26 Aug 2022 13:34:59 -0400, Jeff Moyer wrote:
> Commit a68c88a093719 ("tests: mark passing tests which exit early as
> skipped") changed the return code for this test from success to skip for
> the case where the test successfully runs to completion.  Fix it.
> 
> 

Applied, thanks!

[1/1] liburing: fix return code for test/hardlink.t
      commit: 8af924d6d3ac6a92c4af1df847cf713e4d2b67e3

Best regards,
-- 
Jens Axboe


