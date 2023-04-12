Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 658946DE927
	for <lists+io-uring@lfdr.de>; Wed, 12 Apr 2023 03:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjDLBxh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Apr 2023 21:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjDLBxh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Apr 2023 21:53:37 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5116469D
        for <io-uring@vger.kernel.org>; Tue, 11 Apr 2023 18:53:35 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-63b148e5612so18777b3a.0
        for <io-uring@vger.kernel.org>; Tue, 11 Apr 2023 18:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1681264415; x=1683856415;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0SnqQIljvz1tajKaEvbLAMwlyXQb8cIHckmA2OZDWW8=;
        b=CND9D0XmZP1gszIphTaSLP9DJoYMhlmH+DfxtECjOsBt7mr24xmb3S2koTvH0+Z+n3
         W800eQ3n93/13n9nkapdlgZ09fX8Ra8zOEiE3tqc0darBRD9AQ0cExU2fp6QkK6Tr9Jv
         ioSQAK5GC6unGVaGCh2JyAX90hEy+z5V/sNd45aNsGTaibvzKLc465mFnmhcfNHCHiW/
         wbR6N6oTtGdIHd09gheIS0Y5rG/w0uQ5Kk79V6OlRtfxaRSBg9SwIK1RFnUznA2uM9+b
         7D0/Wv8DR6lr4r/93Xt7+ixvAfZ7hswvOIXYkMuMNCZW72WdG2vWY5XdnHB9cJSx4gwl
         6vWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681264415; x=1683856415;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0SnqQIljvz1tajKaEvbLAMwlyXQb8cIHckmA2OZDWW8=;
        b=ihmshowjijPliPTBF/VHgulOdPbNZ4dPvSmzOim79c5LMymAVZBXTKGuD9A8alMsVd
         vcQsvI1Dj8lMBu6bF8BOo5Dk0xYx1SKSKhB+c5W38r66+PmjdDuhK4vZDA6mlQjPID2Z
         KSSJV7q2WD+NguDiGaqj4q8RnWM+cZb6Ip2f9oIrfG+4DcLIPYjyBImbrV+gA8fMNW2Y
         agF9jrnDqu0sGBrtDw3fBObPCaH3pwSSORJVCpgEHd8ZoOTpcINdupGgU+qhnIDcuisf
         up16miE6yXNxr1J/TNsCg9E/WHIxG+REcndqUkUt3EaBLgsLWzCB9gPTmyCeJR382et8
         zTZw==
X-Gm-Message-State: AAQBX9fT/9vlQT4CU/RdI53OdzQULeGCKHa4B6yRUGkMHrdXXjMkEFQr
        0meuIL5aGazUsR3P4f8aqfnxng==
X-Google-Smtp-Source: AKy350YfQjvaWZoeOEggrBvoc62fzGDf+FZD2kAzryoJLvRgLqpIl59sIs7h8FfU2bq3/YSSirbYAA==
X-Received: by 2002:a05:6a20:3c8b:b0:e9:1dd:dafc with SMTP id b11-20020a056a203c8b00b000e901dddafcmr20341955pzj.4.1681264415227;
        Tue, 11 Apr 2023 18:53:35 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 6-20020a630006000000b004fbd91d9716sm282807pga.15.2023.04.11.18.53.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 18:53:34 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc:     linux-kernel@vger.kernel.org
In-Reply-To: <cover.1680782016.git.asml.silence@gmail.com>
References: <cover.1680782016.git.asml.silence@gmail.com>
Subject: Re: [PATCH v2 0/8] optimise resheduling due to deferred tw
Message-Id: <168126441455.57506.14487418062992045458.b4-ty@kernel.dk>
Date:   Tue, 11 Apr 2023 19:53:34 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-00303
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Thu, 06 Apr 2023 14:20:06 +0100, Pavel Begunkov wrote:
> io_uring extensively uses task_work, but when a task is waiting
> every new queued task_work batch will try to wake it up and so
> cause lots of scheduling activity. This series optimises it,
> specifically applied for rw completions and send-zc notifications
> for now, and will helpful for further optimisations.
> 
> Quick testing shows similar to v1 results, numbers from v1:
> For my zc net test once in a while waiting for a portion of buffers
> I've got 10x descrease in the number of context switches and 2x
> improvement in CPU util (17% vs 8%). In profiles, io_cqring_work()
> got down from 40-50% of CPU to ~13%.
> 
> [...]

Applied, thanks!

[1/8] io_uring: move pinning out of io_req_local_work_add
      commit: ab1c590f5c9b96d8d8843d351aed72469f8f2ef0
[2/8] io_uring: optimie local tw add ctx pinning
      commit: d73a572df24661851465c821d33c03e70e4b68e5
[3/8] io_uring: refactor __io_cq_unlock_post_flush()
      commit: c66ae3ec38f946edb1776d25c1c8cd63803b8ec3
[4/8] io_uring: add tw add flags
      commit: 8501fe70ae9855076ffb03a3670e02a7b3437304
[5/8] io_uring: inline llist_add()
      commit: 5150940079a3ce94d7474f6f5b0d6276569dc1de
[6/8] io_uring: reduce scheduling due to tw
      commit: 8751d15426a31baaf40f7570263c27c3e5d1dc44
[7/8] io_uring: refactor __io_cq_unlock_post_flush()
      commit: c66ae3ec38f946edb1776d25c1c8cd63803b8ec3
[8/8] io_uring: optimise io_req_local_work_add
      commit: 360cd42c4e95ff06d8d7b0a54e42236c7e7c187f

Best regards,
-- 
Jens Axboe



