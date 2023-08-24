Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCD1C787BE8
	for <lists+io-uring@lfdr.de>; Fri, 25 Aug 2023 01:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240911AbjHXXRV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Aug 2023 19:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244065AbjHXXQy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Aug 2023 19:16:54 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 429F11FC9
        for <io-uring@vger.kernel.org>; Thu, 24 Aug 2023 16:16:42 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id 98e67ed59e1d1-26d144db2b4so48875a91.1
        for <io-uring@vger.kernel.org>; Thu, 24 Aug 2023 16:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1692919001; x=1693523801;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=liomoFKxr72M3yn2mrB/eGgXDB/ZSi+V0FGD2Jycn7I=;
        b=JXtpFlKTC1iALOnKMaJtK1HgcLv+xzlMhnfjYBNnTnmkvzx/Q84YV48fSLKpzvAm37
         vfA8lVUti8MRqj6Rz6OY5anOuzU1gAlAYBIUDop4QeQPdYR+3SsFMa/p7o7tt2Z0nbxz
         Kq985dhdtC9BOHjZULx99dZL8pUzJFSrTnQNF7Egs///X/WEiwbbpkO9lhi9FyY5mLew
         9Di4HoJXMnpilpnOsGjwrEom/EgV3zXkF+vfEbn7f/zBkP6rixRkLMh7ywxQ859+u9rA
         xbaW5CVPBmBv7nl7839YUeg3ODVY6J6fHjej18yFWosAX9TQ+AjIKv/7LCl828U1T56O
         /r9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692919001; x=1693523801;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=liomoFKxr72M3yn2mrB/eGgXDB/ZSi+V0FGD2Jycn7I=;
        b=k29WMg4QOzFOP4uJkr7ISZYANJiYaoUypxcOSp/PsujUP9czqRq375w+ZkDPV/ilOc
         6iPdhiL7GNIUOC9DyCgYvy2gx3+Xau4eeDhVSMsooshbwgrmiWH0yDhS6rrxKxGfdA/J
         aPFtXc+E7SGUoHZGBfZqbN/YGXqDrIe8DyF7YJCLaCg4BXl3lJ4koRcu6fx2kO+pW3+n
         IMi+8WBLvUMKvmlHM+GKVRW1vMP60ggdkPxzbAhY4jy/1FW7suADLXPpWiKploEgm3GV
         lb1NmI7qtwI9H9wlAHwj8GA3g2bQWZYadJsiG7qKBkfkz7CGkI11wYI/DDJyX80CRGpg
         8Xfg==
X-Gm-Message-State: AOJu0YyAjqcYih2UhJZoGIjXuZWXcazLZwbdOWZMi8TZ227XevDWLTLo
        A/L/zmBec9je7jDXeC5x/E0xYZ4LZY6zx/4DUMA=
X-Google-Smtp-Source: AGHT+IGLV2Zwtdj/O3T0JmoPk/i2Uamc2VVWSpqQ/RqNt75Bii9K663wVjIsNSXJAkbQZ+jODgwm9w==
X-Received: by 2002:a17:90a:7524:b0:26b:27f6:9027 with SMTP id q33-20020a17090a752400b0026b27f69027mr15360906pjk.1.1692919001324;
        Thu, 24 Aug 2023 16:16:41 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id h12-20020a17090adb8c00b00267b38f5e13sm255657pjv.2.2023.08.24.16.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 16:16:40 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1692916914.git.asml.silence@gmail.com>
References: <cover.1692916914.git.asml.silence@gmail.com>
Subject: Re: [PATCH v2 00/15] caching and SQ/CQ optimisations
Message-Id: <169291900002.174878.9330956471857542766.b4-ty@kernel.dk>
Date:   Thu, 24 Aug 2023 17:16:40 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-034f2
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Thu, 24 Aug 2023 23:53:22 +0100, Pavel Begunkov wrote:
> Patch 1-5 optimise io_fill_cqe_req
> 
> Patch 6-7 combine iopoll and normal completion paths
> 
> Patch 8 inlines io_fill_cqe_req.
> 
> Patch 9 should improve CPU caching of SQ/CQ pointers
> 
> [...]

Applied, thanks!

[01/15] io_uring: improve cqe !tracing hot path
        commit: a0727c738309a06ef5579c1742f8f0def63aa883
[02/15] io_uring: cqe init hardening
        commit: 31d3ba924fd86add6d14f9085fdd2f4ec0879631
[03/15] io_uring: simplify big_cqe handling
        commit: b24c5d752962fa0970cd7e3d74b1cd0e843358de
[04/15] io_uring: refactor __io_get_cqe()
        commit: 20d6b633870495fda1d92d283ebf890d80f68ecd
[05/15] io_uring: optimise extra io_get_cqe null check
        commit: 59fbc409e71649f558fb4578cdbfac67acb824dc
[06/15] io_uring: reorder cqring_flush and wakeups
        commit: 54927baf6c195fb512ac38b26a041ca44edb2e29
[07/15] io_uring: merge iopoll and normal completion paths
        commit: ec26c225f06f5993f8891fa6c79fab3c92981181
[08/15] io_uring: force inline io_fill_cqe_req
        commit: 093a650b757210bc856ca7f5349fb5a4bb9d4bd6
[09/15] io_uring: compact SQ/CQ heads/tails
        commit: e5598d6ae62626d261b046a2f19347c38681ff51
[10/15] io_uring: add option to remove SQ indirection
        commit: 2af89abda7d9c2aeb573677e2c498ddb09f8058a
[11/15] io_uring: move non aligned field to the end
        commit: d7f06fea5d6be78403d42c9637f67bc883870094
[12/15] io_uring: banish non-hot data to end of io_ring_ctx
        commit: 18df385f42f0b3310ed2e4a3e39264bf5e784692
[13/15] io_uring: separate task_work/waiting cache line
        commit: c9def23dde5238184777340ad811e4903f216a2d
[14/15] io_uring: move multishot cqe cache in ctx
        commit: 0aa7aa5f766933d4f91b22d9658cd688e1f15dab
[15/15] io_uring: move iopoll ctx fields around
        commit: 644c4a7a721fb90356cdd42219c9928a3c386230

Best regards,
-- 
Jens Axboe



