Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91F3C6BD09A
	for <lists+io-uring@lfdr.de>; Thu, 16 Mar 2023 14:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbjCPNRw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Mar 2023 09:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbjCPNRq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Mar 2023 09:17:46 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B982CC319
        for <io-uring@vger.kernel.org>; Thu, 16 Mar 2023 06:17:16 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id qe8-20020a17090b4f8800b0023f07253a2cso1549176pjb.3
        for <io-uring@vger.kernel.org>; Thu, 16 Mar 2023 06:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678972635; x=1681564635;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VQrpQiiY9osW3DGUy6xD/lIDxf6jaTU5f3nsLOSXF7E=;
        b=dbARJCooJZ+TG3Rg4ulMWNIOrdWRrp7wnfCQ8/AIIinIFuc4pCXfhsPcE4VNMuj/w7
         fWbFKXkVjDfK7AORqsr9AqETVkmzEkWFKtW9nSgVHgWvswzV+msE4vaAzI1RmkUJHIMZ
         D35iU0Q7/IHJbVWlokVhAWTtOJgR7OdSV9eqAW0LooOsoTThmm0m+qxeNoxArRZRrUoL
         MdjyEunbw/6SjoqxtDSveDSgH98CMsrr+I3zlF1nIc7OkMFw3f8M7wEhT+uatXY61/V2
         1q3mLPXuMUhNM8zJhLuTMaZpF07Y6Ti9sXS5o2BUylOcNJNdJSFWAfSdsaM2oRwiNP9e
         qV4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678972635; x=1681564635;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VQrpQiiY9osW3DGUy6xD/lIDxf6jaTU5f3nsLOSXF7E=;
        b=5zBjM4rxeYpwAkkPo3fTkb9kwtLyHNILBqi65SpXufWSaiAx5d3vH63afeKqqKrXtW
         eYQf+Jnkgqes0C39K+8vLRqXt44dgoog/54q/G/09I9vMINP67bgreBUwgWvndzciGJi
         /JHykb9KIjiceM8ckVMcWzIbhJ5KrA7LOxM1YBBzvneePp+POnEWihs/EA2aZpDP3CqQ
         GahHymzCIQxLQfXvzh1CU5rIegDC9l12unAvQaUNW38TJWHtJ05dx1a6FpHYK++PxbgP
         1DLi1Ff5DCq11Vg6k7batLC/PffzoS/ujn273J5cEEo0eG7rQtUn7MVDOZ+TbO2vioKM
         CnNg==
X-Gm-Message-State: AO0yUKXo8xRhyh65nDJQc/ZVBOUYyIv9Z2lQ+HrEXKVGzw4PMmXyyjP6
        UWxsIPl+5lQTejlAllsEC2ZwtoqJG+pK7q/aCroNXg==
X-Google-Smtp-Source: AK7set/FXcvD6GJBcSLhFuVTZ10XHs2G6HgfCd4blhFaqm+OnnK4qlz2dF4obPG9yPBTF2odHs3tcQ==
X-Received: by 2002:a05:6a20:441f:b0:d4:faa7:be92 with SMTP id ce31-20020a056a20441f00b000d4faa7be92mr8200885pzb.6.1678972635153;
        Thu, 16 Mar 2023 06:17:15 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id j9-20020aa78dc9000000b00571f66721aesm5456108pfr.42.2023.03.16.06.17.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 06:17:14 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <4a5ba7d8d439f1942118f93b9be5c05d6a46f2cd.1678937992.git.asml.silence@gmail.com>
References: <4a5ba7d8d439f1942118f93b9be5c05d6a46f2cd.1678937992.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/msg_ring: let target know allocated index
Message-Id: <167897263453.230509.16555040754256867497.b4-ty@kernel.dk>
Date:   Thu, 16 Mar 2023 07:17:14 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-2eb1a
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Thu, 16 Mar 2023 12:11:42 +0000, Pavel Begunkov wrote:
> msg_ring requests transferring files support auto index selection via
> IORING_FILE_INDEX_ALLOC, however they don't return the selected index
> to the target ring and there is no other good way for the userspace to
> know where is the receieved file.
> 
> Return the index for allocated slots and 0 otherwise, which is
> consistent with other fixed file installing requests.
> 
> [...]

Applied, thanks!

[1/1] io_uring/msg_ring: let target know allocated index
      commit: 5da28edd7bd5518f97175ecea77615bb729a7a28

Best regards,
-- 
Jens Axboe



