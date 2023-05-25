Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6591710F97
	for <lists+io-uring@lfdr.de>; Thu, 25 May 2023 17:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234226AbjEYPaZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 May 2023 11:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231344AbjEYPaY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 May 2023 11:30:24 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A979B99
        for <io-uring@vger.kernel.org>; Thu, 25 May 2023 08:30:23 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id ca18e2360f4ac-7748ca56133so10207439f.0
        for <io-uring@vger.kernel.org>; Thu, 25 May 2023 08:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1685028623; x=1687620623;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NO/OjaZZkozkYUICrpEnXJ+3mPmRp9wHJW5eza3zhm0=;
        b=erylhx312fUfI7Gcfihuoe/SbaI4hqSTSYGd2Eswq9BrXpPSGiPPcjfK+QDhYJD08N
         3GejBg2UmSrqQjqwkkPxzpkLERLmCVYNrQtvpTBu8DC8M7sYzqb3JHr2GTFxI5kCtrbK
         8gpHmS0IxflC7jxvWnrMG8JsI1wLtoOW7/u3kTUSjsKkAE52BFGAH3zBhAcMDN7Zlf8v
         8VqyJCyssR8xwr7TGbGHOSh4S3cFcjQ8qHPmYfsG7AT+ciC7syfZ2dYkm1lpM+MJttNO
         edp7fvmY5/FtOnw0hpCNybwjhWdjlIffieI9bpY/iEnrvm8ziRdZrV59dXRjmfi7cBpw
         rPmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685028623; x=1687620623;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NO/OjaZZkozkYUICrpEnXJ+3mPmRp9wHJW5eza3zhm0=;
        b=IeI5z0ZOUKU/6Ohg/PBfVpdBYEuX8CM0ASAsWKHflMVvNq4yV2DB6oUkn4L8R3VYRZ
         KSQGUCkqvYMdvWPP9bCakciP64tLZkbgzpgqkC4Ld0xyMQQmrJNBLO7u/aKEy4ndSaD9
         PVTeSUHkcckRG4zKg5VD0GZpOXeu7+4SyCDbTmZJF2j2jsC2GBqIEzNErVDQYUwTvdzX
         5RBRtU2BqpDw2bVu0D2vMLTpeSYMv6o5rfrp5og8GTqxdKnfncMam/Lz2CFE4cVitDQj
         3WUSqK48evvdFxnT8jH/gPtUVXL7mpq2pbk4jw5oVbCVlxGAktrXzrAsTdqsYAmS8pC6
         wFeQ==
X-Gm-Message-State: AC+VfDxbwFRmAAa4aW6iPvYU4sjrk1glMomru+SPkf1aFOMiebWIlMwp
        hR4fHfOGPm/3anUASkBlkDM8tA==
X-Google-Smtp-Source: ACHHUZ6iVqkA+85KikwAfFYdPQucFqBuL0C/nFvYwv86f2qZue9SwWSBlGUvm/P4XD7wDw7Z7EBi0A==
X-Received: by 2002:a6b:3b85:0:b0:774:8d63:449c with SMTP id i127-20020a6b3b85000000b007748d63449cmr3908373ioa.0.1685028622900;
        Thu, 25 May 2023 08:30:22 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id w189-20020a022ac6000000b0040fa5258658sm459300jaw.77.2023.05.25.08.30.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 08:30:22 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     asml.silence@gmail.com, Wenwen Chen <wenwen.chen@samsung.com>
Cc:     io-uring@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20230525082626.577862-1-wenwen.chen@samsung.com>
References: <CGME20230525082004epcas5p1d05da68508feff3f9dd82646a0b40aff@epcas5p1.samsung.com>
 <20230525082626.577862-1-wenwen.chen@samsung.com>
Subject: Re: [PATCH v2] io_uring: unlock sqd->lock before sq thread release
 CPU
Message-Id: <168502862159.719490.14979738745453090363.b4-ty@kernel.dk>
Date:   Thu, 25 May 2023 09:30:21 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-00303
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Thu, 25 May 2023 16:26:26 +0800, Wenwen Chen wrote:
> The sq thread actively releases CPU resources by calling the
> cond_resched() and schedule() interfaces when it is idle. Therefore,
> more resources are available for other threads to run.
> 
> There exists a problem in sq thread: it does not unlock sqd->lock before
> releasing CPU resources every time. This makes other threads pending on
> sqd->lock for a long time. For example, the following interfaces all
> require sqd->lock: io_sq_offload_create(), io_register_iowq_max_workers()
> and io_ring_exit_work().
> 
> [...]

Applied, thanks!

[1/1] io_uring: unlock sqd->lock before sq thread release CPU
      commit: 533ab73f5b5c95dcb4152b52d5482abcc824c690

Best regards,
-- 
Jens Axboe



