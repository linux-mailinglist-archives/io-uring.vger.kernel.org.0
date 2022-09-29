Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF415EF625
	for <lists+io-uring@lfdr.de>; Thu, 29 Sep 2022 15:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235240AbiI2NNN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Sep 2022 09:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235489AbiI2NNI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Sep 2022 09:13:08 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B21417CA0B
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 06:13:04 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id q15-20020a17090a304f00b002002ac83485so1311377pjl.0
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 06:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date;
        bh=JhWGil5Xcx6qP/B5pfB2Xdl/CbUiizvQnBivj/kQBZ8=;
        b=2IZ+zXG1ly5hiOUX9A484NdphFYTiQT6odEsteoqP7D4uzPjOECJVcT/Fe9fpisYBC
         hMUtFxHJkd/Pb3Qv1UnpbC89vGNu5LEl6geogkCJLXZH/Kwj8IepMqnSrzBIPSFBgcsP
         d+LvdPBcJW/8i6+ZdyhlH4YC6t9NZ9nEvDG1L5zRY3mTq9qXOPrsDeasVqqhh9OqA1Al
         Shp2Qsgndc6+xmkRokMxwTZJsExFc4oV4QNE6LeJcrCJ7JkuwOmrkkcrmHAUbvXvAftP
         saNVWvw0d9emNOZD4mcvCjYWK45DY4PZCmtCc5nyM1+I/9hYz5SmbldtIBynohPdIyi3
         3vbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=JhWGil5Xcx6qP/B5pfB2Xdl/CbUiizvQnBivj/kQBZ8=;
        b=dk7ud36R5XkUQuMy9RCnVxoxubPOgpvNmUaR4NPP0ibtKqC4sSDWhAVBPK/5NcM0Bx
         PYe1xwXYO8hxtZ1mvt6zkgWjPrS9qe/IUwG13fniWjOdWkyywGxIvYZJZHVWb2VEwF4o
         KxsTotJJeEu4NkAn26T3SCAh4SxvNM+8ghpnP0mZlrTL2LuLUq6ElfQ1m9LCKJhCunbZ
         nWG3JR0y0PKdVQT9utPaUaMI1UteSp6HUeCBzIpWzqU95Aq4VXlSMLuHnwy4jXfYExHW
         8VKJpKTynMx3A4msmC9us+N+WJkhTUfQHs93z8GHowivMR7CnBkZukpyx+Pc6NRvy9OF
         jWTA==
X-Gm-Message-State: ACrzQf3qxFR6fz2ZN9iW0TnIIFOyAH8IkqzfooC6lRHyGLutHRlOQEdF
        O5TryYJKKG+UhUkCEpjpSyBsmmORsA4f1A==
X-Google-Smtp-Source: AMsMyM4kAtn/YH7yBJrHFpNSwABgGb19+AgrvRqTJaeLRUUDGCwtGuooaOPFeM6f3jEQ7Z0HTWoV1A==
X-Received: by 2002:a17:90a:3b0a:b0:205:ec1b:9f37 with SMTP id d10-20020a17090a3b0a00b00205ec1b9f37mr3786311pjc.206.1664457183303;
        Thu, 29 Sep 2022 06:13:03 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id w207-20020a627bd8000000b005383988ec0fsm6102300pfc.162.2022.09.29.06.13.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 06:13:02 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Stefan Metzmacher <metze@samba.org>,
        asml.silence@gmail.com
Cc:     stable@vger.kernel.org
In-Reply-To: <b2e7be246e2fb173520862b0c7098e55767567a2.1664436949.git.metze@samba.org>
References: <cover.1664436949.git.metze@samba.org> <b2e7be246e2fb173520862b0c7098e55767567a2.1664436949.git.metze@samba.org>
Subject: Re: [PATCH 1/1] io_uring/net: fix fast_iov assignment in io_setup_async_msg()
Message-Id: <166445718246.10317.17940058168765174614.b4-ty@kernel.dk>
Date:   Thu, 29 Sep 2022 07:13:02 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-d9ed3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 29 Sep 2022 09:39:10 +0200, Stefan Metzmacher wrote:
> I hit a very bad problem during my tests of SENDMSG_ZC.
> BUG(); in first_iovec_segment() triggered very easily.
> The problem was io_setup_async_msg() in the partial retry case,
> which seems to happen more often with _ZC.
> 
> iov_iter_iovec_advance() may change i->iov in order to have i->iov_offset
> being only relative to the first element.
> 
> [...]

Applied, thanks!

[1/1] io_uring/net: fix fast_iov assignment in io_setup_async_msg()
      commit: 3e4cb6ebbb2bad201c1186bc0b7e8cf41dd7f7e6

Best regards,
-- 
Jens Axboe


