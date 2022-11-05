Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12FE861DBAA
	for <lists+io-uring@lfdr.de>; Sat,  5 Nov 2022 16:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbiKEPcC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 5 Nov 2022 11:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbiKEPcA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 5 Nov 2022 11:32:00 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B241BBC9F
        for <io-uring@vger.kernel.org>; Sat,  5 Nov 2022 08:31:59 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id y4so7444713plb.2
        for <io-uring@vger.kernel.org>; Sat, 05 Nov 2022 08:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u6qHbmDTzsFmp0X86fW394d4Fwkk/f/BlwJbwOKkJEU=;
        b=i6jdgsdIaozM/Ndg7HHs9a8asuJEhQrKcH7/ZbsijD/G5ocezII3lfuke4ykFge+kE
         uAuU8mZfBZUOwrLK74eJzJwnTk09emA/v/qI8aoqFRDxjjWKqxnJ6Dx3lPv3U8aFhp9d
         vijTSBBBDJfFB5TRvzYWVu92i3y+ejyi6E5lWjl2ahZE8tOUTx7JyAmE8k8WQGR+ZISu
         GIIC0nw8JFdXCS3aUsCedwnrUv0I64g7UV6Ir9vVES/msUmyxTDR350i9RlRzjHzCz+z
         2qpvg3sItCrOJluRsUSWNXr4Rnvdja0HFBB0K0lFBXsMaG/gvubbyZH7hrYsBUs7eGLR
         u4HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u6qHbmDTzsFmp0X86fW394d4Fwkk/f/BlwJbwOKkJEU=;
        b=JtU3MzDRDf66kBJeIVAC2VexeIZM/3bNvsfOOmi8TQhISNDzkx1BdYIdG9DjSZqfqy
         1W4WmklMkvI4KGfrr5ew2igJQQcQDGJS14ubQBw2pdBc5u699KVoZIf0PZfYalxWnnc9
         h1kKtkBz6ecePG7PFP7zbs3umb5AFAnQ1Lsnfm2twaIfi3lqmHvwUcx3Rez2ZhKcsu/Z
         qrY7AXYK5s/2WEb0H60+1kDnQnLdq9ma1XxsS0jlZXghkt0T7QuQydwJy3wHDb3U17ib
         3kOxMu6WM0wGsHQLdiSM36+tBcLV1StyJ1R1XPgowtAVjAql0dKoIx3tOW7wEJZJtWfL
         5VTw==
X-Gm-Message-State: ACrzQf09jQ1J0y86ixfpyf/2QNaXEw/GdUXe9ckI0tEBPDRtOtsAEdsw
        kPrwnu92mHIhkstRuQ63cm2Xi5YJBLZnnDQ3
X-Google-Smtp-Source: AMsMyM5fLVSDupJM7RFe24UvkrkX++qSvGpFZItF7SUA6ls9jpfTXzUUCD2kNUDQ5DklR8OlP1TJiQ==
X-Received: by 2002:a17:902:d48d:b0:186:cf83:4be3 with SMTP id c13-20020a170902d48d00b00186cf834be3mr40775011plg.22.1667662319226;
        Sat, 05 Nov 2022 08:31:59 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id z2-20020a17090a540200b0020af2bab83fsm1402635pjh.23.2022.11.05.08.31.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Nov 2022 08:31:58 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     korantwork@gmail.com, asml.silence@gmail.com
Cc:     kernel test robot <lkp@intel.com>, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, Xinghui Li <korantli@tencent.com>
In-Reply-To: <20221102082503.32236-1-korantwork@gmail.com>
References: <20221102082503.32236-1-korantwork@gmail.com>
Subject: Re: [PATCH v2] io_uring: fix two assignments in if conditions
Message-Id: <166766231805.14409.16784497219898130071.b4-ty@kernel.dk>
Date:   Sat, 05 Nov 2022 09:31:58 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-d9ed3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 2 Nov 2022 16:25:03 +0800, korantwork@gmail.com wrote:
> From: Xinghui Li <korantli@tencent.com>
> 
> Fixs two error:
> 
> "ERROR: do not use assignment in if condition
> 130: FILE: io_uring/net.c:130:
> +       if (!(issue_flags & IO_URING_F_UNLOCKED) &&
> 
> [...]

Applied, thanks!

[1/1] io_uring: fix two assignments in if conditions
      commit: c71afa164bfe91f0825c359940899e539abcb6b7

Best regards,
-- 
Jens Axboe


