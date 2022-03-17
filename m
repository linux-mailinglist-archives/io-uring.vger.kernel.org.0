Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3D7F4DC5DE
	for <lists+io-uring@lfdr.de>; Thu, 17 Mar 2022 13:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233576AbiCQMdB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Mar 2022 08:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233578AbiCQMdA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Mar 2022 08:33:00 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10EE1EB814
        for <io-uring@vger.kernel.org>; Thu, 17 Mar 2022 05:31:43 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id n18so4316180plg.5
        for <io-uring@vger.kernel.org>; Thu, 17 Mar 2022 05:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=ITuWcQTZUUHxYZKQG+yikYNAyM57saBDq+q1IdGti5k=;
        b=AWdgK1dE1r/15dw/3zZyn4TEakvTFaYJzYeg6vbAarmSFdZecxy3q82w4f7xmkyUGQ
         /HOjrHRpwE/GtnyOo9rejxrHRO1hdBfkVSy3KEmfka/uTzv4KdINaa7zrO1AIojDvuFk
         N7o3ZKZ6BVlHhctgS1g34X+GXpWEap8XYwl1n6QB6m479IdGPKih6/AFlaadJYge4mDY
         4CnVLTkjCHabPzNDZtfRMyxINDCBJTwxwKJhKlX/FCgPJPPtj9bK3bJHpXzHUcZ3dYDw
         ricvq+CoDgbpCTTLvOKX7Q8ndqqHyf7MFhdOKQSVujmodrqQZ0xIUdEbIgvd/C+j9Sxb
         Ee2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=ITuWcQTZUUHxYZKQG+yikYNAyM57saBDq+q1IdGti5k=;
        b=A5t0L/GGwECnFQxgvFFU10/2NR6wkaiQJQ0nhPSkS9j8JztrMtnCG9yHO4idn5hlEQ
         ESV4DPG7C5nsAX60QxiKBezGy2xCGy5Phdgar8o4cePydSjM7uyqT5i3DXVGYpUEqpTt
         lhFXRxWJcWteF9eZKisLCjz0KKGicac/+QbrKTX81sQj45A3+ANYqEpBxylZlQuz+kex
         8GpmbnkZrmvI43kzPVTr0sMzyd/wGxS0lYfnK5DgovoPc7GYbZLfA9x5kwTm+ByIFySe
         3xR70Wqxo5zr4h/1VhZZYN9H2FmbOsfXRE68VlUEAWhf60ybHRgibin98GJzu4VL9Fbh
         qE3w==
X-Gm-Message-State: AOAM531ZtaqZDKq8x1GoE8c5HVIspqcnDZkLGT5ZyHfGRt5SSrsdEhI+
        BpWCp18bwLHEKisc2Q23/VsDtMcM7NQY6O7L
X-Google-Smtp-Source: ABdhPJypmO1sBMQZ984dFWDSDRIVFbpYadkG7aFbAOx5TteG1Tv0uJ9twnYj8DLCepglAQnsJMrv3A==
X-Received: by 2002:a17:902:8a91:b0:14f:969b:f6be with SMTP id p17-20020a1709028a9100b0014f969bf6bemr4573655plo.161.1647520302371;
        Thu, 17 Mar 2022 05:31:42 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id kb10-20020a17090ae7ca00b001bfad03c750sm10301511pjb.26.2022.03.17.05.31.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 05:31:41 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1647481208.git.asml.silence@gmail.com>
References: <cover.1647481208.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next 0/7] completion path optimisations
Message-Id: <164752030091.31627.8845796970959443213.b4-ty@kernel.dk>
Date:   Thu, 17 Mar 2022 06:31:40 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 17 Mar 2022 02:03:35 +0000, Pavel Begunkov wrote:
> A small series that for me prepares the code for further work but is
> also adds some nice optimisations for completion path, including
> removing an extra smp_mb() from the iopoll path.
> 
> Pavel Begunkov (7):
>   io_uring: normilise naming for fill_cqe*
>   io_uring: refactor timeout cancellation cqe posting
>   io_uring: extend provided buf return to fails
>   io_uring: remove extra barrier for non-sqpoll iopoll
>   io_uring: shuffle io_eventfd_signal() bits around
>   io_uring: thin down io_commit_cqring()
>   io_uring: fold evfd signalling under a slower path
> 
> [...]

Applied, thanks!

[1/7] io_uring: normilise naming for fill_cqe*
      commit: ae4da18941c1c13a9bd6f1d39888ca9a4ff3db91
[2/7] io_uring: refactor timeout cancellation cqe posting
      commit: 6695490dc85781fe98b782f36f27c13710dbc921
[3/7] io_uring: extend provided buf return to fails
      commit: b91ef1872869d99cd42e908eb9754b81115c2c05
[4/7] io_uring: remove extra barrier for non-sqpoll iopoll
      commit: 0f84747177b962c32243a57cb454193bdba4fe8d
[5/7] io_uring: shuffle io_eventfd_signal() bits around
      commit: 66fc25ca6b7ec4124606e0d59c71c6bcf14e05bb
[6/7] io_uring: thin down io_commit_cqring()
      commit: 9333f6b4628c8037a89ed23e1188d4b7dc5d74e4
[7/7] io_uring: fold evfd signalling under a slower path
      commit: 9aa8dfde4869ccdec0a7290b686dbc10e079e163

Best regards,
-- 
Jens Axboe


