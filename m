Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 143776E70CB
	for <lists+io-uring@lfdr.de>; Wed, 19 Apr 2023 03:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbjDSBjN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Apr 2023 21:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbjDSBjM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Apr 2023 21:39:12 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA6BB19A4
        for <io-uring@vger.kernel.org>; Tue, 18 Apr 2023 18:39:11 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 41be03b00d2f7-51f64817809so116494a12.1
        for <io-uring@vger.kernel.org>; Tue, 18 Apr 2023 18:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1681868351; x=1684460351;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iStr2CWKcIHP/EfwpfiQnvtHa3I9vc6AAzZzGrSo0Vs=;
        b=IcaaBkxXnmhLDAVbBe3OYMHUrpqZedJ52XcIO7EfOVX3dt+bKuEuJdqakVwDsENeoH
         1RXYjr+Tv+V2YHPSq+Lhk1pnVYgjjsVOpPwuXZL+QqWaMieSMA+bEcmy86TwrtlcMNJf
         pIn5Zq3+LJXHLYGvobzq12F+J4QxjbUV6n4ldcNR/++tk+rtDFt1jVT15MNkGlCP7WAl
         4YWey+VRQo6V0tnHaAqYoLhiUy070Uqt/kdfbBylrFSuEVOJFD3cvIfmZVrgicV1mIeF
         DaWOuuJb2SevEUVDyrJ4uJ6jS6kIxd0KaHTFz2l8y/L3Fbzj65g5048gKzWXuwLSNR0v
         fN3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681868351; x=1684460351;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iStr2CWKcIHP/EfwpfiQnvtHa3I9vc6AAzZzGrSo0Vs=;
        b=kRO1yxnDILwn+bPtrZtesorQd9t3PZbXe4lSVHevHUr33X5+9eTkI0g2BjZuy/lw9B
         5h0IpDMmZhAczQ/NCZYpQmusXRAzMUs5j/A5h4wpu9qIb1EOc3Ga++aARZTjanaQhjZ0
         ycraqSNUwaGabx/eLiqTUmGuiSbX5a6jfeZQzsL6d7twIZ0E2dyRE0H2YTbP/wlXEed8
         FOEp6cHBYR1R2ulceSJO8VQZlBxaftMhkxUIVL3+vo8JCvAoBA7EYyKW/P/ex/iJuuNv
         rMO8LWaB2znlR5qbkuc8zBEG2WrS6xkM71xHs5FPtXMpNvzE/mxOnK7Mf+gs0BtwZlwH
         8rNQ==
X-Gm-Message-State: AAQBX9fBwIODqIT3k0/XvLNO1as9Y2d+7pc2cILsq98eKRlGbLnePMWD
        spannHhLjBpeHG7138L6S+Ojf3H55P9HCdvDOBY=
X-Google-Smtp-Source: AKy350Zps9ioR73Ti22EJBqS2qxGdiSbGBDxyzlIMCdTPyIAPzmYnWfC/GRbsG94SXWos+wCV9IOlQ==
X-Received: by 2002:a17:90a:52:b0:246:fbef:790e with SMTP id 18-20020a17090a005200b00246fbef790emr14515598pjb.3.1681868351087;
        Tue, 18 Apr 2023 18:39:11 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b6-20020a170902d88600b001a64851087bsm10242007plz.272.2023.04.18.18.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 18:39:10 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1681822823.git.asml.silence@gmail.com>
References: <cover.1681822823.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next 0/8] another round of rsrc refactoring
Message-Id: <168186835047.340981.1138610123036067847.b4-ty@kernel.dk>
Date:   Tue, 18 Apr 2023 19:39:10 -0600
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


On Tue, 18 Apr 2023 14:06:33 +0100, Pavel Begunkov wrote:
> Further simplify rsrc infrastructure, and make it a little bit
> faster.
> 
> The main part is Patch 3, which establishes 1:1 relation between
> struct io_rsrc_put and nodes, which removes io_rsrc_node_switch() /
> io_rsrc_node_switch_start() and all the additional complexity with
> pre allocations. Note, it doesn't change any guarantees as
> io_queue_rsrc_removal() was doing allocations anyway and could
> always fail.
> 
> [...]

Applied, thanks!

[1/8] io_uring/rsrc: remove unused io_rsrc_node::llist
      commit: 2e6f45ac0e640bbd49296adfa0982c84f85fa342
[2/8] io_uring/rsrc: infer node from ctx on io_queue_rsrc_removal
      commit: 63fea89027ff4fd4f350b471ad5b9220d373eec5
[3/8] io_uring/rsrc: merge nodes and io_rsrc_put
      commit: c376644fb915fbdea8c4a04f859d032a8be352fd
[4/8] io_uring/rsrc: add empty flag in rsrc_node
      commit: 26147da37f3e52041d9deba189d39f27ce78a84f
[5/8] io_uring/rsrc: inline io_rsrc_put_work()
      commit: 4130b49991d6b8ca0ea44cb256e710c4e48d7f01
[6/8] io_uring/rsrc: pass node to io_rsrc_put_work()
      commit: 29b26c556e7439b1370ac6a59fce83a9d1521de1
[7/8] io_uring/rsrc: devirtualise rsrc put callbacks
      commit: fc7f3a8d3a78503c4f3e108155fb9a233dc307a4
[8/8] io_uring/rsrc: disassociate nodes and rsrc_data
      commit: 2236b3905b4d4e9cd4d149ab35767858c02bb79b

Best regards,
-- 
Jens Axboe



