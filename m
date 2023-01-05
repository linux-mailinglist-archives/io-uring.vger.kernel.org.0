Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 849A765EFA3
	for <lists+io-uring@lfdr.de>; Thu,  5 Jan 2023 16:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbjAEPFc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Jan 2023 10:05:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232584AbjAEPF2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Jan 2023 10:05:28 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0FCE4EC8B
        for <io-uring@vger.kernel.org>; Thu,  5 Jan 2023 07:05:26 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id m15so21109608ilq.2
        for <io-uring@vger.kernel.org>; Thu, 05 Jan 2023 07:05:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RjFHSmhmP7qZE+kuqTzJ8NUR8Lw44t+ev+pW8/oN6Os=;
        b=iep6lfO3qGHRC1iHX0G8XgfWCEF+Pm4q9sQyoPDYTfm61DmBSI9B3BdjFAkgYyqrn7
         FC4rAtkhP74GIocxYNR+HZzevYtvBEgnerQRalnplGCJF2g8ZTk204ObroxfPQavUJQR
         S2hS28kPPWaBXBef7SdE5EJDsd8ZM6/yOkcFJHYPbInC0C36fpO7ehsyFaHN59OX1WvK
         DGbhZPnvnHP7Jj6qvQs2SCKKGbnBSrWE2ES5xQm9tq6j/6fxg/Gln6BkRID82xExDIiP
         3BA75IF3thCVVTJCUYPcS7vdnSrktzR83TTaFbenc32G6h0e7SlkpgMqeXNpsyanZD0r
         NE1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RjFHSmhmP7qZE+kuqTzJ8NUR8Lw44t+ev+pW8/oN6Os=;
        b=TZdrvVVujMesDzdbP21sLmx/jMXBEdhgidl4jVONvVKIPk7P0XIwKjldE8zraeMPej
         lVmSDXeMuy/9Nq6/T4P4YSGhIBV1WX0ZFRVEqDFTj0KYrfUsMX/JLQaN+DI81Ku88aVI
         bEimVkOXmBSf7imOXSZOdYSqn4FDK7f2xidXZshWQL0IAL7ZcH+iH/0lZMZ16pZBk7ug
         hBbDxOEbb1qfAAXj1SmrvgLWpI38QfmnEAFfI8qNJ3+MbGp1w6GHCZmilvfLnP4Yx6xo
         slhgToaEur1CGdkfmWv2RzYztKXz0A0DozzXG8N+1Na0vOqoahENflnGamwMROeosOcu
         WBpg==
X-Gm-Message-State: AFqh2kpMCpYbbwBcYRta2Or7JUiBXFRol0Fn+Qc5tzDASjIoeeedhBka
        AyYwXglIYaZ0suu8SxX0pYKVYqbMLqudr2Cv
X-Google-Smtp-Source: AMrXdXvodB2dAbU7SWnTtVDaxShP6fHUGw4vT+TBeMk+S3GGleWxbX6bivetni3nAJZleyplChKE/w==
X-Received: by 2002:a92:d307:0:b0:30b:d947:6bc8 with SMTP id x7-20020a92d307000000b0030bd9476bc8mr7061648ila.1.1672931125681;
        Thu, 05 Jan 2023 07:05:25 -0800 (PST)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id b12-20020a92670c000000b002f1378de8d5sm11250156ilc.40.2023.01.05.07.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 07:05:24 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: =?utf-8?q?=3Cf7bffddd71b08f28a877d44d37ac953ddb01590d=2E1672915?=
 =?utf-8?q?663=2Egit=2Easml=2Esilence=40gmail=2Ecom=3E?=
References: =?utf-8?q?=3Cf7bffddd71b08f28a877d44d37ac953ddb01590d=2E16729156?=
 =?utf-8?q?63=2Egit=2Easml=2Esilence=40gmail=2Ecom=3E?=
Subject: Re: [PATCH v2] io_uring: fix CQ waiting timeout handling
Message-Id: <167293112468.3865.7616323451687769851.b4-ty@kernel.dk>
Date:   Thu, 05 Jan 2023 08:05:24 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-7ab1d
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Thu, 05 Jan 2023 10:49:15 +0000, Pavel Begunkov wrote:
> Jiffy to ktime CQ waiting conversion broke how we treat timeouts, in
> particular we rearm it anew every time we get into
> io_cqring_wait_schedule() without adjusting the timeout. Waiting for 2
> CQEs and getting a task_work in the middle may double the timeout value,
> or even worse in some cases task may wait indefinitely.
> 
> 
> [...]

Applied, thanks!

[1/1] io_uring: fix CQ waiting timeout handling
      commit: 12521a5d5cb7ff0ad43eadfc9c135d86e1131fa8

Best regards,
-- 
Jens Axboe


