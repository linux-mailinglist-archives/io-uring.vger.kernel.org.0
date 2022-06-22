Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9555D555295
	for <lists+io-uring@lfdr.de>; Wed, 22 Jun 2022 19:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346568AbiFVRjM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jun 2022 13:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359148AbiFVRjL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jun 2022 13:39:11 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 191762CE23
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 10:39:05 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id i17so1925888ils.12
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 10:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=tniyHrkptaYKvg4Ol/1p8UsRi6NA6Dt9LAfYmIuM8tc=;
        b=MP9Xru+1ahR/Jygi1m3WMgJgWgZNjBFAz+DgKhGv3wVyhvIHpksyAfvoG0AV9HukEc
         vIxv0JS27cubXfc+ELw4edubMbRWsn6ulMngm9NQqXuSPXiUF89hc9MWMQaZY+KzEisc
         SgCdwiE43iWyOseI0yAR/ajHyqCr3IYLdH5zPkV3YSR1Ry/0pwJJ8A7NfPfdqNDViMIY
         QhiSfrMMp9lSwiiQz7tMQm8i9sIIQ3Oy6HbBEURpQhiD6NWuFF4Z8/BCGSlBt+IG3wvz
         UfNQHpFS8Ikr8T2qiTt+DrXc81tXbtr06h9anvMctYdsHhe9hQ7P0qDuGGEuScsoNHut
         DF3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=tniyHrkptaYKvg4Ol/1p8UsRi6NA6Dt9LAfYmIuM8tc=;
        b=lbiG+uRpxp8aTeZFsFS7F/rP0CyZadRvBVIAD4MMX3Ljt/sSZUtQ2vZ9BlzvqpHp11
         cPuuwIjx/+GPZAMVfdBYaprPtBYYpYtYq6tsKSpOtPaVXG8ApS71qNp9nJFfv814zstV
         Z7hWA9cuT+i3XH4u+t79VmSMdjvK18W3Th6JkmwegAbcOsc1xuzeSY77oefZZS0+htLL
         6nrEP7qjgKqnTV7dMmQpyKWTlZOnyMarlxvvc0lqrZlLVYqkFC4p5VvFP45J95VwxBIV
         AJZEppca3cy/q9dz5TZ893kl1mf6xyZZpClCbLm6/P02G56IQLz22XAEMZs70oUW1vyG
         VqWQ==
X-Gm-Message-State: AJIora/wD2BtDiaOk0MG6po4p4DPAia1IdWqBXy3DE0ndK4Kkd8Ge9/W
        ZFA99k8xaZWJCymCZVYYQ+PtGw==
X-Google-Smtp-Source: AGRyM1sZ9yg3L2y/1vtosbS4R8jd/YidrVyNAmKc1Dz4L7wb3c8eweylCT10Q5ldzNHq7+b6+iZ7Dg==
X-Received: by 2002:a05:6e02:1a0d:b0:2d9:367e:2b6f with SMTP id s13-20020a056e021a0d00b002d9367e2b6fmr2849214ild.260.1655919544377;
        Wed, 22 Jun 2022 10:39:04 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id p13-20020a92d48d000000b002d9302a9d31sm1988039ilg.29.2022.06.22.10.39.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 10:39:03 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     dylany@fb.com, asml.silence@gmail.com, io-uring@vger.kernel.org
Cc:     Kernel-team@fb.com
In-Reply-To: <20220622134028.2013417-1-dylany@fb.com>
References: <20220622134028.2013417-1-dylany@fb.com>
Subject: Re: [PATCH v2 for-next 0/8] io_uring: tw contention improvments
Message-Id: <165591954334.72162.14221912486832222726.b4-ty@kernel.dk>
Date:   Wed, 22 Jun 2022 11:39:03 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 22 Jun 2022 06:40:20 -0700, Dylan Yudaken wrote:
> Task work currently uses a spin lock to guard task_list and
> task_running. Some use cases such as networking can trigger task_work_add
> from multiple threads all at once, which suffers from contention here.
> 
> This can be changed to use a lockless list which seems to have better
> performance. Running the micro benchmark in [1] I see 20% improvment in
> multithreaded task work add. It required removing the priority tw list
> optimisation, however it isn't clear how important that optimisation is.
> Additionally it has fairly easy to break semantics.
> 
> [...]

Applied, thanks!

[1/8] io_uring: remove priority tw list optimisation
      commit: bb35381ea1b3980704809f1c13d7831989a9bc97
[2/8] io_uring: remove __io_req_task_work_add
      commit: fbfa4521091037bdfe499501d4c7ed175592ccd4
[3/8] io_uring: lockless task list
      commit: f032372c18b0730f551b8fa0a354ce2e84cfcbb7
[4/8] io_uring: introduce llist helpers
      commit: c0808632a83a7c607a987154372e705353acf4f2
[5/8] io_uring: batch task_work
      commit: 7afb384a25b0ed597defad431dcc83b5f509c98e
[6/8] io_uring: move io_uring_get_opcode out of TP_printk
      commit: 1da6baa4e4c290cebafec3341dbf3cbca21081b7
[7/8] io_uring: add trace event for running task work
      commit: d34b8ba25f0c3503f8766bd595c6d28e01cbbd54
[8/8] io_uring: trace task_work_run
      commit: e57a6f13bec58afe717894ce7fb7e6061c3fc2f4

Best regards,
-- 
Jens Axboe


