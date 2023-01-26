Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9782567D2E3
	for <lists+io-uring@lfdr.de>; Thu, 26 Jan 2023 18:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbjAZRRk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 26 Jan 2023 12:17:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbjAZRRk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 26 Jan 2023 12:17:40 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 484556B9A6
        for <io-uring@vger.kernel.org>; Thu, 26 Jan 2023 09:17:26 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id e204so846137iof.1
        for <io-uring@vger.kernel.org>; Thu, 26 Jan 2023 09:17:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d65C3NcgzBKAAQzc/NiXnM7pfBTeaiLiyZz+vukzBhk=;
        b=ObnxRW6pVE23/JBWWZC5CmAM7B6tq6PByIKJ3IPEv1Yg0I6FeEA+sF8i+UMofj+DkT
         agcimeXlgmoDXYbXUIC9BJDCV+VY0F5Z7lYW1M5QiR3WkuMTsDhPTXAGztJ1drB4r1Ye
         eLECcitNVjVCXV+NQDsMwF7pTnBIpILLqI27Eg7lgGK41Ap0Gb2V4WZeW9CagEJOaLfV
         g2pB005uZlhQ2cZWsT/BoqvGbOkPAeXWLUXYjyM/vP0yq9QLTznpmPf7DJV82uO9C6qF
         Ho2PxIsaUNDLEqcCjVe4wmeTUxlGQb59wsoh70wHYgci79M3gSjeeld1AZC5GdBS//M5
         FFyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d65C3NcgzBKAAQzc/NiXnM7pfBTeaiLiyZz+vukzBhk=;
        b=snI7CWb10n6ao2t11aLvRYGhMd5nOsbLxDkiL647/mJ5atuV6Ina48PIAQOrQSDu7e
         Dw7P+H+tiCZk8OmCicZT/yq+nOm0wAjFRg8J9saoG2rnUI4lCoP48WAmrWa8bUQ6BBZA
         m9A74G0uGMFLj9Xpx5CL5tx4/wDT+n3MGLrJmGDPFJ/4fyov7zCKGjPBBg9a2EFi3MP9
         CqNncLb67Yvw90Xf2qrL9uL38vwLudTswdHy6brrfgW8GDZf9bDi8+HmfPFSqXZwwQxo
         RrCVxintZDmlVc/BZP/AwdOh+5POWgEOAGdAkYYtnpCW92Dt/fH+yIb3F9dw/ZSqkwHa
         novg==
X-Gm-Message-State: AFqh2koMASjEZGO2IbcIIfyD1JX7NuhiD7nPMSXcvr7XKmwdjD6N3kf9
        j3D9jhvT0uOuMuXLkZZbXMprCquffSCkYTwC
X-Google-Smtp-Source: AMrXdXvr757LzrTQwmBNdQofudeOlvxcZi0fPwy8HEUx1D/pSqPUdWNebDtXuWKwzjPsvSrc+/RVHA==
X-Received: by 2002:a5d:875a:0:b0:707:d0c0:1bd6 with SMTP id k26-20020a5d875a000000b00707d0c01bd6mr2018102iol.1.1674753445600;
        Thu, 26 Jan 2023 09:17:25 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id cn16-20020a0566383a1000b0038a06a14b37sm625597jab.103.2023.01.26.09.17.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 09:17:25 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc:     Dylan Yudaken <dylany@meta.com>
In-Reply-To: <a8ab36c6126de3a0595c1b27e610fc203d076461.1674750570.git.asml.silence@gmail.com>
References: <a8ab36c6126de3a0595c1b27e610fc203d076461.1674750570.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 1/1] test: fix parallel send-zerocopy
Message-Id: <167475344496.701288.14317477182188459302.b4-ty@kernel.dk>
Date:   Thu, 26 Jan 2023 10:17:24 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Thu, 26 Jan 2023 16:29:46 +0000, Pavel Begunkov wrote:
> Dylan reported that running send-zerocopy in parallel often fails,
> seems to trigger regardless whether it's zc or not. The problem here
> is using the same port for all programs, let the kernel to select it.
> 
> 

Applied, thanks!

[1/1] test: fix parallel send-zerocopy
      commit: 3832ea016fe119488812205aae758ab720fc4ef5

Best regards,
-- 
Jens Axboe



