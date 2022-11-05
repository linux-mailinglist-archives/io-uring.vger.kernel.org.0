Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7E861DB9E
	for <lists+io-uring@lfdr.de>; Sat,  5 Nov 2022 16:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiKEPUo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 5 Nov 2022 11:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbiKEPUn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 5 Nov 2022 11:20:43 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED32A20358
        for <io-uring@vger.kernel.org>; Sat,  5 Nov 2022 08:20:41 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id m14-20020a17090a3f8e00b00212dab39bcdso10813698pjc.0
        for <io-uring@vger.kernel.org>; Sat, 05 Nov 2022 08:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8dAzt0gCITt0NfDYGyZJKp9ZMRsvEdBDLmIo1AJ69Ps=;
        b=6GKH72RUW3bNnJ41A+EaDWu+BLREXpc8WVBpZQU6xLlNJSKwK8Y+eMEN3VWb6A0LnY
         egbmEKI7Hq5l7MCiY9odb5gKw85ew/uXypMcD6QMcU5NJH799dxEp/j29HhCRcUZ3oXA
         9cUZzLFC9C/rC3GDQj1qMauu5YuFKWQeaJLNQsh/kCba/oThDro5OH3SmdNxMRmD8JPb
         u2vEnl2n/EjDovHfH/bPJIrX06ahe8e/q+TOB4F/77Dwn60XB+7RrEfUIPx+XwF0Rhci
         t3eYI06wdsOOwQ9lLNIp9pSgoiUgi2pqw/+Z67MUTF7Apku3ll00miy+QgGYC2BU2IEf
         Tjtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8dAzt0gCITt0NfDYGyZJKp9ZMRsvEdBDLmIo1AJ69Ps=;
        b=rbntQmvoZyYVTZwKNs2j++90WVuXkVNg8FQB/fLgngrrzFsTqtuCTk9+5TGSYhZNx1
         U2umgTpav60uPxiL9nNjCf6ncYMRpBk+GtBNOISkoYtl2b9s2nQgIBb9P6GUwRjhQL58
         GuFMAh2tRAJkRazj6YSnVlSr8rcHE1mr4JN6dlWTPYSxtTqSUAaWrpaIrBpSL3EtCdsX
         5JLOKdbFO3HB7t2EfrTNcbBpCcGbEeXhEqmja7pmgp9zj9mQxB3inHZglhg2pb6yv5H5
         z2c5cwBGEUGqp2NLN/bTKIlJ10DsjAeR32cs3LxGdYyAxO82eFNwzYTDSq1AyDHzXzsD
         2f4g==
X-Gm-Message-State: ACrzQf1yVrBoSnO5TvXH9oEN76utQ1VjIU5YCiDNNaT4xzsRiqcLYC7I
        4H4n9Fpe24A1/PgcIrKciAosbA==
X-Google-Smtp-Source: AMsMyM4JG68/6TXDR1X2K3aJEFhL3Rus/Ba+pmRyzV4dpJuN8EwqR7zu3PvvUBU/lha5iLNt9WMB+A==
X-Received: by 2002:a17:902:ce88:b0:186:b345:97c0 with SMTP id f8-20020a170902ce8800b00186b34597c0mr41872192plg.13.1667661641408;
        Sat, 05 Nov 2022 08:20:41 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i9-20020a17090332c900b0017a09ebd1e2sm1806153plr.237.2022.11.05.08.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Nov 2022 08:20:40 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
In-Reply-To: <cover.1667557923.git.asml.silence@gmail.com>
References: <cover.1667557923.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next 0/7] small zc improvements
Message-Id: <166766164059.10668.7316229816240622883.b4-ty@kernel.dk>
Date:   Sat, 05 Nov 2022 09:20:40 -0600
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

On Fri, 4 Nov 2022 10:59:39 +0000, Pavel Begunkov wrote:
> Remove some cycles in a couple of places for zc sends. Touches a bunch of
> bits here and there but the main theme is adding additional set of callbacks
> for slower path and move in there some optional features.
> 
> Pavel Begunkov (7):
>   io_uring: move kbuf put out of generic tw complete
>   io_uring/net: remove extra notif rsrc setup
>   io_uring/net: preset notif tw handler
>   io_uring/net: rename io_uring_tx_zerocopy_callback
>   io_uring/net: inline io_notif_flush()
>   io_uring: move zc reporting from the hot path
>   io_uring/net: move mm accounting to a slower path
> 
> [...]

Applied, thanks!

[1/7] io_uring: move kbuf put out of generic tw complete
      commit: 4b72e6e5396b5b49b6a58fe6d674326375f0e0c5
[2/7] io_uring/net: remove extra notif rsrc setup
      commit: 69a47aaa5c9ad309c09c9a24a1045ca733f72a41
[3/7] io_uring/net: preset notif tw handler
      commit: b96a61e0a4dda80faef4cc553a97828915edfd60
[4/7] io_uring/net: rename io_uring_tx_zerocopy_callback
      commit: d546548227976445133ee229ab99c7b2ad933712
[5/7] io_uring/net: inline io_notif_flush()
      commit: 1e52225edde1cfbd764b61f0aa07e77372b2717c
[6/7] io_uring: move zc reporting from the hot path
      commit: 02912499a7a43c4d6ee3cfb164a9dd509c1f7f18
[7/7] io_uring/net: move mm accounting to a slower path
      commit: 1cc5a56e4b4cf4dbe1a7497e4bf9e0b92ff4803f

Best regards,
-- 
Jens Axboe


