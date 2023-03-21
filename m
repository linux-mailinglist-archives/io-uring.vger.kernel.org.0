Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5659F6C3B17
	for <lists+io-uring@lfdr.de>; Tue, 21 Mar 2023 20:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbjCUT5c (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Mar 2023 15:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjCUT5b (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Mar 2023 15:57:31 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C2735245
        for <io-uring@vger.kernel.org>; Tue, 21 Mar 2023 12:57:27 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id o12so7484172iow.6
        for <io-uring@vger.kernel.org>; Tue, 21 Mar 2023 12:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1679428646;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bu8TWiTd+dMNCILBtuiLPgNBDvCUsOq7k0sSH9XLG5c=;
        b=fDO7rVZ4kVhfA3r1yoMxNoP1BgSc5EvM357TNcImMctUj33W/1yLQVVLHWrB1EZytj
         MYjwJZEL5mGhEg6xmGiLan7QogQom4BV8RJ6cm8d9WbKEy1cPgij8lUEW73VkII3uxIa
         UpV2Dg7AKvJk3qeF9MOOFogv1B2w8TCOIN4BMEneo0qe8aAFyt0pSFfp4h3ik5MFMo6D
         8Ru44i1cXfQaxnh3FwQrlAvTXKnMeBO9zprj2khNkjrsTLl1DaIsPtumLso5OZ0T5c4b
         Srl+74Qolqo6syxWSbo2rQxLW/QfrKpdI03IBJvF432ux8SCc1kY+qhtvtB4jmRyQI1e
         P19w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679428646;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bu8TWiTd+dMNCILBtuiLPgNBDvCUsOq7k0sSH9XLG5c=;
        b=caIoMg7B0QBBy2ueLaV0TIuKeFT42sl+LRU8kfpCQdsQzYC+Monf5vJplH6voc8URQ
         qyl8B0Bu61ZrYPbkJrsGcwKoPBqrSDQMPKDxIawd4a6mwE1YVAUPQbL7Nfkj/FfBpG6Q
         NHXYEqiIeI+RMTKSkFax5bavyFgRSBsuogvMIzw59luJXDflQDXL4q3V0/hbng/karXu
         PkNObsucq2Mp8fvqqItdoVe9KrcpJJwivBQV/8lxeuFLsYYxtEBdC+AT4EW3OZnFCnWg
         +ZARuXPmylKSoXDUI/Em7IQCbRXLdt1mGjyYxF/mtkUIOW4Eu3Vnvmaiu/sHEYQrmLtq
         HXzQ==
X-Gm-Message-State: AO0yUKVbrTgKAvkizBZaa2goXvuPbYYds+XYz2TmkoQ4g3s9r3jHsjzs
        /Pt3h9W6Cv6qYdaP3GPjYD8rYg==
X-Google-Smtp-Source: AK7set/zpjdCqTEKdTw5QHaECSLLoUvRjz/jHrW8DAwT+AJsGlKM+KVpSnxmkrQYffCGFrZYj9Qwow==
X-Received: by 2002:a05:6602:1228:b0:758:5405:7275 with SMTP id z8-20020a056602122800b0075854057275mr1558386iot.2.1679428646650;
        Tue, 21 Mar 2023 12:57:26 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id p36-20020a056638192400b004062f11d2d9sm4301494jal.130.2023.03.21.12.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 12:57:26 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Savino Dicanosa <sd7.dev@pm.me>
Cc:     asml.silence@gmail.com
In-Reply-To: <20230321194300.405130-1-sd7.dev@pm.me>
References: <20230321194300.405130-1-sd7.dev@pm.me>
Subject: Re: [PATCH] io_uring/rsrc: fix null-ptr-deref in
 io_file_bitmap_get()
Message-Id: <167942864607.555039.7575220089181396494.b4-ty@kernel.dk>
Date:   Tue, 21 Mar 2023 13:57:26 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-20972
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Tue, 21 Mar 2023 19:44:02 +0000, Savino Dicanosa wrote:
> When fixed files are unregistered, file_alloc_end and alloc_hint
> are not cleared. This can later cause a NULL pointer dereference in
> io_file_bitmap_get() if auto index selection is enabled via
> IORING_FILE_INDEX_ALLOC:
> 
> [    6.519129] BUG: kernel NULL pointer dereference, address: 0000000000000000
> [...]
> [    6.541468] RIP: 0010:_find_next_zero_bit+0x1a/0x70
> [...]
> [    6.560906] Call Trace:
> [    6.561322]  <TASK>
> [    6.561672]  io_file_bitmap_get+0x38/0x60
> [    6.562281]  io_fixed_fd_install+0x63/0xb0
> [    6.562851]  ? __pfx_io_socket+0x10/0x10
> [    6.563396]  io_socket+0x93/0xf0
> [    6.563855]  ? __pfx_io_socket+0x10/0x10
> [    6.564411]  io_issue_sqe+0x5b/0x3d0
> [    6.564914]  io_submit_sqes+0x1de/0x650
> [    6.565452]  __do_sys_io_uring_enter+0x4fc/0xb20
> [    6.566083]  ? __do_sys_io_uring_register+0x11e/0xd80
> [    6.566779]  do_syscall_64+0x3c/0x90
> [    6.567247]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
> [...]
> 
> [...]

Applied, thanks!

[1/1] io_uring/rsrc: fix null-ptr-deref in io_file_bitmap_get()
      commit: 761efd55a0227aca3a69deacdaa112fffd44fe37

Best regards,
-- 
Jens Axboe



