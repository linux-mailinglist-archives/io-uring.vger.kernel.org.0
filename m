Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D22B519223
	for <lists+io-uring@lfdr.de>; Wed,  4 May 2022 01:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238125AbiECXJo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 May 2022 19:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233290AbiECXJn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 May 2022 19:09:43 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB5A41F87
        for <io-uring@vger.kernel.org>; Tue,  3 May 2022 16:06:09 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id t6so25227092wra.4
        for <io-uring@vger.kernel.org>; Tue, 03 May 2022 16:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=rvnjZjCG8/Vmvsykd+1B09qYGTKc0L0K8lar5vH9pgQ=;
        b=e2T27ph+PvTCyTxW3qZCvijfNtPxBuhJkxf0gx2B8Q+QcgWKW9sCokFA0Lx/zVTH/h
         9WZpLEDmWulsHc/Tsz3n49nE03ScF5pDeBpKCIwIHEZ3EwTBoOBYh59pBDkM2cDEyIB/
         tyJpkIP0sj4qS41CFQBuCi3HhKvfncuekxOXQVBqdbjnDiCxaBSrTqvyV/ngoqEZrpaw
         xwKdq/1WiZhP+lzR7iXtX7KqKfx5sstDRUo7psCAtoAUigNP+PBsvLJ96lq6CuDhPRd0
         u8pJaj8wdGdRrqPVZa5mjF+K/cYKzAFDG99q7ah3tdQcBxjUR6zPUrft2Wn4zkd7vlsw
         nnSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=rvnjZjCG8/Vmvsykd+1B09qYGTKc0L0K8lar5vH9pgQ=;
        b=j0m+7pmBkfzk1XD5NQp65ZaflWyTyYZuDaqtcqQ1xEJmM7eqgB7huGE2S6XAVLs5DM
         rBogbqYHaHO5PMyq4weFOAr+3GMmYSPWnjnZCbiV/OQNSXlhhUaQGHVZ7tKpNmMgHlUT
         kj4IHhrrPOXih2mQ9hJHh1LL7yfGH8+kKVnfmyA6bHyMR+H+j80oa9k+stUGq2A3V564
         uKvQQBHI9Q+uyouwfJF8swC4lfX6vwORIooztr09iWd68C1m46oA7fXWendQ9SwW/Rvs
         Cdm6A4wkgpSImAHFgsd273XVDlOoUIi4homVRVycfwCIRQgcTAm4w2R/6YirGzdGURUJ
         LJNA==
X-Gm-Message-State: AOAM531E3HApbRf+yXFo2AbEdRBAAt5G+XNz862Zr7MJPqmK548CiFlJ
        hkVXg+52mHpnUi6Ux4YOus29LVCa0NuBrDnX2ctTmhHkwPFx5w==
X-Google-Smtp-Source: ABdhPJzid1uVYJc+ww9l5ofL2OVqWFhJAO9k2ac0+HmG80xC704J8qGy8SwwGMMFG1mAnUgea35YanTiLNnMVWBONz0=
X-Received: by 2002:a5d:44cf:0:b0:20a:c5d2:b6c3 with SMTP id
 z15-20020a5d44cf000000b0020ac5d2b6c3mr14092510wrr.177.1651619167906; Tue, 03
 May 2022 16:06:07 -0700 (PDT)
MIME-Version: 1.0
From:   Constantine Gavrilov <constantine.gavrilov@gmail.com>
Date:   Wed, 4 May 2022 02:05:56 +0300
Message-ID: <CAAL3td0UD3Ht-rCpR5xUfmOLzeEzRSedCVXH4nTQKLR1b16+vA@mail.gmail.com>
Subject: Short sends returned in IORING
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens:

This is related to the previous thread "Fix MSG_WAITALL for
IORING_OP_RECV/RECVMSG".

We have a similar issue with TCP socket sends. I see short sends
regarding of the method (I tried write, writev, send, and sendmsg
opcodes, while using MSG_WAITALL for send and sendmsg). It does not
make a difference.

Most of the time, sends are not short, and I never saw short sends
with loopback and my app. But on real network media, I see short
sends.

This is a real problem, since because of this it is not possible to
implement queue size of > 1 on a TCP socket, which limits the benefit
of IORING. When we have a short send, the next send in queue will
"corrupt" the stream.

Can we have complete send before it completes, unless the socket is
disconnected?


-- 
----------------------------------------
Constantine Gavrilov
Storage Architect
Master Inventor
Tel-Aviv IBM Storage Lab
1 Azrieli Center, Tel-Aviv
----------------------------------------
