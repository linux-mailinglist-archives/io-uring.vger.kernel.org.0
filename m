Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2397C5FAAC7
	for <lists+io-uring@lfdr.de>; Tue, 11 Oct 2022 04:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiJKCzA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Oct 2022 22:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbiJKCy7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Oct 2022 22:54:59 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE18F11833
        for <io-uring@vger.kernel.org>; Mon, 10 Oct 2022 19:54:47 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id 67so12282792pfz.12
        for <io-uring@vger.kernel.org>; Mon, 10 Oct 2022 19:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+FgNNXlCiUicoezSxpnxF8vkD9vtUqAzzBYNmVEcZzM=;
        b=i8A5dqmBsTNxnvtHWYTb5pKH7x0GKxTgav73mRgY8mkAvEmYjQBYJw0tQiaUtP+xLX
         Gr5or/rfJ2kdVNObAfWU2ifEznjVsu1ssqR7WYNjd68K9nJ6ikQQJMXa6MOVHUUDLJdf
         5WlL29J0rv/E8qTOgwPSGVM1fu9GUe5wtV69Vh6gTqWFu/jSEoEzbgqvevoiD/q0BqWp
         bsYXXaB1zg1aMnKDo8VUucPDmDb4YgvqtwAAtw+R8m5JA/ysAlNtZna6xi90D0QjzN4Y
         gIZdsj2Xj/+b0J5H3QLWfqFTRiC5F+9KWGc/nE3pvKArfxkzFrRv05B7D9ZaTuw9/ZkA
         ob8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+FgNNXlCiUicoezSxpnxF8vkD9vtUqAzzBYNmVEcZzM=;
        b=EEdofFrIiO4Oaq2O+D8/K8GknI1sVSZ7I7bSalCh31YI44FAl2UHShGVY3DOHN12y2
         VApto0ZLF2LN3Bct/usFgoFbpx29zlWKaELXrAZ4S0JIz3bu7daNZTpGZ1ESbPdbj5i/
         H6AP3nDSa+ITL213GDeBbMSDoHMTUFCDjeRPwxmAxct0X3WTj3WFh+yahpRb0wZKt2R/
         uO48+ER3cLbW0Ffa5tvRY9c18FVRh+J2e/ynKcCb/RIG7OS9u9SSlwTevT2ktE0AkS0A
         cjh0mvLZDLQHVlvEExLs8Mf1BsVIwMTq379dPtxEmGrM6aecD00uNp/6QoFsOjhXx1j3
         meKA==
X-Gm-Message-State: ACrzQf3v8UBeeJzWkgyf0Q7XFS8Z+FVGoxrYz2GbIR+Pf5NcaNVX/1xo
        Sckdr979sKB9FnLVAznOOfAcTAp9yyELV13f
X-Google-Smtp-Source: AMsMyM7ChN3euMUx7llvJKxXzgahroXI38OZ7Y6a9PmbaMVtLzcnCfEzqU9/GLdBn9OS5YP+L41ZwQ==
X-Received: by 2002:a05:6a00:1a04:b0:52a:d4dc:5653 with SMTP id g4-20020a056a001a0400b0052ad4dc5653mr22997089pfv.69.1665456886733;
        Mon, 10 Oct 2022 19:54:46 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id z10-20020a63c04a000000b004561e7569f8sm6931709pgi.8.2022.10.10.19.54.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 19:54:46 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc:     syzbot+e5198737e8a2d23d958c@syzkaller.appspotmail.com
In-Reply-To: <8b41287cb75d5efb8fcb5cccde845ddbbadd8372.1665449983.git.asml.silence@gmail.com>
References: <8b41287cb75d5efb8fcb5cccde845ddbbadd8372.1665449983.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: fix fdinfo sqe offsets calculation
Message-Id: <166545688578.43404.7690238453501271177.b4-ty@kernel.dk>
Date:   Mon, 10 Oct 2022 20:54:45 -0600
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

On Tue, 11 Oct 2022 01:59:57 +0100, Pavel Begunkov wrote:
> Only with the big sqe feature they take 128 bytes per entry, but we
> unconditionally advance by 128B. Fix it by using sq_shift.
> 
> 

Applied, thanks!

[1/1] io_uring: fix fdinfo sqe offsets calculation
      commit: 9af3f837a9bf59ede807303831892448eaa2ed0b

Best regards,
-- 
Jens Axboe


