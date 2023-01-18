Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B769567206D
	for <lists+io-uring@lfdr.de>; Wed, 18 Jan 2023 16:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbjARPCF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Jan 2023 10:02:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231574AbjARPBi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Jan 2023 10:01:38 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341746A57
        for <io-uring@vger.kernel.org>; Wed, 18 Jan 2023 06:57:11 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id j1so8256441iob.6
        for <io-uring@vger.kernel.org>; Wed, 18 Jan 2023 06:57:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ub1olwoCkB/tkNbcG1M9BPQHo+bSSvBkfTAu5QGk9b0=;
        b=i4hc7tPiKWZDNp4wQo4OVXPd7w8hyV5o2Wa2kBQinyATlOOvcaQ2i4A8npkcLSWpzv
         Ez1Ac08rO64w60rUEBZ8/Myt+NA97T8+IAfWLcbxxxuhrvqGcyVU1YQbXc0fdfrDoLXH
         JnUEolA3DiAFSgOOPjtw+u7Kw5qmf8lk+fYvL0vTcdinBrXnEgekGRDKuQ9RBP8RMqx1
         4zOsOfgQtf485Y4sdiA9yPbIawe7Vm5wgW32V3jWoQg+mp2KeyzZw5qRKu1/oxl+Kir2
         bo8BwgaCAYE7OMvmdKv6MD8xR87dZ6Jq9VDMpunFi+9g1est+JSPltKpj8nXjfnDNbyT
         B/ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ub1olwoCkB/tkNbcG1M9BPQHo+bSSvBkfTAu5QGk9b0=;
        b=a5k47tLlp2I1EJgQJJR45pJL+Hy97cvBn2PVZiNVeb0PFYYGe46ANMszrNVC4eFKSI
         /53jX6xycV8qPRCn/6/nbwkgpAC2eKo44Fc4fCxjiTTh9doOVtBYyIBY9aVtKejvcBGi
         ZnlB52xmPdzXqZHSlrIU43HPmnzP4gpbGl6Fmf0gh5v2ax0fDFto1134nb/1RyQw7awk
         GdQoAJIATUgCQA9hKjH8mboN+gPfuPRN9L/ruBsEcukR76U1SndzIBu2cT8oMUALmZaw
         g3wixV9KBstm52kX44sKsjcaQrZsdZp22TSFiY9nR5c8po700tWP4GbZRl1KiSWYxwHI
         7WsQ==
X-Gm-Message-State: AFqh2kpgE+v4yk1v0ZzYDPlO+PYq4ZqBVqAbEYJfaZExbH4GHXM0vvl7
        GErWfAGAKPG4zqSy0JRlliPuN8FBY+5nR1/7
X-Google-Smtp-Source: AMrXdXseOQ3gSa/HhYTWzTN0pPeB+ni/totlPwPNTPLJ50/VpCkD1KqDFni+ZX+PGdG1aMipsah4GQ==
X-Received: by 2002:a6b:7a4c:0:b0:704:eeae:67c7 with SMTP id k12-20020a6b7a4c000000b00704eeae67c7mr591684iop.2.1674053829762;
        Wed, 18 Jan 2023 06:57:09 -0800 (PST)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id g11-20020a02a08b000000b0038a3b8aaf11sm8769049jah.37.2023.01.18.06.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 06:57:08 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Gabriel Krisman Bertazi <krisman@suse.de>
Cc:     io-uring@vger.kernel.org
In-Reply-To: <20230118144806.18352-1-krisman@suse.de>
References: <20230118144806.18352-1-krisman@suse.de>
Subject: Re: [PATCH liburing] test/helpers: fix socket length type
Message-Id: <167405382855.134458.8843645998540843384.b4-ty@kernel.dk>
Date:   Wed, 18 Jan 2023 07:57:08 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-78c63
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Wed, 18 Jan 2023 11:48:06 -0300, Gabriel Krisman Bertazi wrote:
> t_create_socket_pair uses size_t for paddrlen, which is uint64 on 64-bit
> architecture, while the network syscalls expect uint32.  The implicit
> cast is always safe for little-endian here due to the structure format,
> its small size and the fact it was previously zeroed - so the test
> succeeds.
> 
> Still, on BE machines, our CI caught a few tests crashing on
> connect(). For instance:
> 
> [...]

Applied, thanks!

[1/1] test/helpers: fix socket length type
      commit: b5caa618565c0c6d0053f7b1bae2423cd317660c

Best regards,
-- 
Jens Axboe



