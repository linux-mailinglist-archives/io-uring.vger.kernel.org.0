Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70A5C7CB7DF
	for <lists+io-uring@lfdr.de>; Tue, 17 Oct 2023 03:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234325AbjJQBN5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Oct 2023 21:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233972AbjJQBN4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Oct 2023 21:13:56 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C65A7
        for <io-uring@vger.kernel.org>; Mon, 16 Oct 2023 18:13:54 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1ca79b731f1so3274855ad.0
        for <io-uring@vger.kernel.org>; Mon, 16 Oct 2023 18:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1697505234; x=1698110034; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h8XXZAg8Y8R2xNXTg80HN8Iawj+RtpWcUU0FSf2sNEs=;
        b=zAZiveIX5jCVcDrU/48KHTv9efvq5Cfs6iZT1daGvrAsS/hxOtJ0/shiS6T6gjM6AL
         6WXAGaqtXiyBpfwmacxoSXzURhhKj2MIV1BblSFqenpwqj3IU8XqherfPGi7qY2/rMbD
         qMkk6cCQOOPoQ89XLDt+7JKZr92Pt6hp7CfRVhpXxJha1C/c/JXQVpuvpOC8xitsTLoc
         wPEiRvs9dMpVkytn1ilX2Ejnu9yBB2YPwpci4OVLwKoEL/AUZ5jf5U9fPlKAzrXbbkTT
         8DGkQHKYln//C3mDJ2SFwv6iHEj9bcna28qNYOkmO1ZYJ09dQig5vaMYiYbLvSkJ9wUC
         bH9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697505234; x=1698110034;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h8XXZAg8Y8R2xNXTg80HN8Iawj+RtpWcUU0FSf2sNEs=;
        b=xCzW18VqKYltGYuM9zexCTPPuA68KPPd+QIblMRKwqDFOq7ftPU70ewxhON3PTXkM2
         Qr0CRFx3vuAfhdwrUEbft2xeU2UIiPOlhfSy+oCxGXeCjvkyaJOC4+8bJUH6EAh7sMC6
         yZYMs4rPisbYXIuugW5s42Z4d+GjmlACP3db0uXwhP0+ICgTOydPTUdwe8Gv1BJ0xHj5
         ooSWuQsmGci2vTsBHChtPQAaxB0UDQrNXQqUziXilQV2a/6nNS1wV9zFFuT9odVgxPD/
         dp2gmUp4BJbt9pTVDAzqdXgajKlcxncx7mnbWcXQqeSMIovUTzayyskdl/rXvgaIvgs/
         UfLw==
X-Gm-Message-State: AOJu0YwcTxRRnPlr31qUcw2db9CGq6wY0Os7zHKpFhWu7R1w3rW3xWWN
        vNcR4amTAhxyBDBPObY2f1WJYt2aLoeJJfSdqzOPAQ==
X-Google-Smtp-Source: AGHT+IH676W+YZThA5g6JGJql6BmeUBN5fnZgt8nqzBRWdc3cTvb5MshHqkBpaWTJ2fuwIQyFwXM4Q==
X-Received: by 2002:a17:902:bd07:b0:1ca:28f3:569a with SMTP id p7-20020a170902bd0700b001ca28f3569amr877236pls.5.1697505233984;
        Mon, 16 Oct 2023 18:13:53 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id iy10-20020a170903130a00b001c9b35287aesm229774plb.88.2023.10.16.18.13.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 18:13:53 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>
In-Reply-To: <20231009093324.957829-1-ming.lei@redhat.com>
References: <20231009093324.957829-1-ming.lei@redhat.com>
Subject: Re: [PATCH for-6.7/io_uring 0/7] ublk: simplify abort with
 cancelable uring_cmd
Message-Id: <169750523303.2166768.9866448914806482249.b4-ty@kernel.dk>
Date:   Mon, 16 Oct 2023 19:13:53 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-034f2
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Mon, 09 Oct 2023 17:33:15 +0800, Ming Lei wrote:
> Simplify ublk request & io command aborting handling with the new added
> cancelable uring_cmd. With this change, the aborting logic becomes
> simpler and more reliable, and it becomes easy to add new feature, such
> as relaxing queue/ublk daemon association.
> 
> Pass `blktests ublk` test, and pass lockdep when running `./check ublk`
> of blktests.
> 
> [...]

Applied, thanks!

[1/7] ublk: don't get ublk device reference in ublk_abort_queue()
      commit: a5365f65ea2244fef4d6b5076210b0fc4fe5c104
[2/7] ublk: make sure io cmd handled in submitter task context
      commit: fad0f2b5c6d8f4622ed09ebfd6c08817abbfa20d
[3/7] ublk: move ublk_cancel_dev() out of ub->mutex
      commit: 95290eef462aaec33fb6f5f9da541042f9c9a97c
[4/7] ublk: rename mm_lock as lock
      commit: 9b8ce170c0bc82c50bf0db6187e00d3a601df334
[5/7] ublk: quiesce request queue when aborting queue
      commit: e4a81fcd73422bdee366c3a076826d92ee8f2669
[6/7] ublk: replace monitor with cancelable uring_cmd
      commit: 3aa8ac4a0c293fcc1b83c4f1a515b66f1f0123a0
[7/7] ublk: simplify aborting request
      commit: ac7eb8f9b49c786aace696bcca13a60953ea9b11

Best regards,
-- 
Jens Axboe



