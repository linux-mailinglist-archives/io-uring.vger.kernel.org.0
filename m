Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F26B46CAE59
	for <lists+io-uring@lfdr.de>; Mon, 27 Mar 2023 21:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232590AbjC0TPm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Mar 2023 15:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232656AbjC0TPa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Mar 2023 15:15:30 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E3740D4
        for <io-uring@vger.kernel.org>; Mon, 27 Mar 2023 12:15:22 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id ca18e2360f4ac-7585535bd79so5618439f.0
        for <io-uring@vger.kernel.org>; Mon, 27 Mar 2023 12:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1679944522;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AxJtvRm/oA5rdtabYLY8xzs3tJ3uj0S2RlqD8Wobqpo=;
        b=bu69+M7+/mfXjfM8XmI5XROwrpi9VexIMtEWIxj8dcI/qFrXSkfYabJTOI8TQvOGTG
         dxFo6dF8QnxmR2on/iKywM5hnbK1u4mrLrau9DERI3xG28mImR3oNPljuK+0qnfLkmiV
         fwJxFWWZxZDOiWfpTzygmCCwhAmU+h4Vx0fDjpEwXHkG/AI+ZO+TNV4biUh0tscKOuFM
         PoCd9cxcVRnYInzS9d48iMU2G/anEPnwESKFyWwTSDpv9CLjy4Pw7EDRlMBP+UzQ5ACM
         OhlABANaEtPhbFq8xrHZPprNFO0MJFCjqVyEEWrRzTM9fWlM0TXni0D7zhA6sjyfj3Tv
         laAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679944522;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AxJtvRm/oA5rdtabYLY8xzs3tJ3uj0S2RlqD8Wobqpo=;
        b=edW7nmXmXideu1gY4DPlk8F2qObM1qmkLgyXjPsBU3QBFlLk7S3f1xNU8XZ45FUwmA
         P4MhlXweWhXomNzXiKnakbYCMGlTjAfFxXKNO76BIqLwAKVYJaAwmS1q7povtMpM0GCh
         PL2SH2N3WAoPnT0NBMYXwmuYtVFYckAv7PtETdCY90P0Hpnk9JW/WqaJS45jasZnRAOh
         eLGGTgPxVAbQTBlkyNEc7exyM+GtZWcAesEg9hteBNSZ+a8j9x5J1IyThjRk00Abz3HT
         Ba3kcRL59yyu92YCV26giQLwrLLP1RdzBE9r8anciVYc8x2e8VcQbmvgbN0xEC5l8hSt
         YCKQ==
X-Gm-Message-State: AAQBX9cdIytf2ACN+lScbwjXUDNypHi5tQZg2U8lJ2PLcgYNajFllVHP
        cXGn/UIHKQahRRB9l2DsYr9ipJEwdPlPcBhWdDQanQ==
X-Google-Smtp-Source: AKy350aPrj7lcIPMUfBnA/Ld9oGK0869ceNGlxK7T8Jm9IGxTDSCnFJyAbJOz0AXGgt0MCqRO38q9w==
X-Received: by 2002:a05:6e02:1c04:b0:325:e065:8bf8 with SMTP id l4-20020a056e021c0400b00325e0658bf8mr7193296ilh.0.1679944521809;
        Mon, 27 Mar 2023 12:15:21 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id q54-20020a056638347600b003c41434babdsm9194154jav.92.2023.03.27.12.15.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 12:15:21 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1679931367.git.asml.silence@gmail.com>
References: <cover.1679931367.git.asml.silence@gmail.com>
Subject: Re: [PATCH 0/2] introduce tw state
Message-Id: <167994452106.167981.16413364671187727702.b4-ty@kernel.dk>
Date:   Mon, 27 Mar 2023 13:15:21 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-20972
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Mon, 27 Mar 2023 16:38:13 +0100, Pavel Begunkov wrote:
> Add a task_work state instead of passing a raw bool pointer. This
> will better encapsulate it, e.g. to not expose too much to cmd
> requests, and may also be needed for further extensions.
> 
> Pavel Begunkov (2):
>   io_uring: remove extra tw trylocks
>   io_uring: encapsulate task_work state
> 
> [...]

Applied, thanks!

[1/2] io_uring: remove extra tw trylocks
      commit: f14d58928002ea2fac729531bdf5bc7b1b2fffd1
[2/2] io_uring: encapsulate task_work state
      commit: f14d58928002ea2fac729531bdf5bc7b1b2fffd1

Best regards,
-- 
Jens Axboe



