Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D75C6AE53B
	for <lists+io-uring@lfdr.de>; Tue,  7 Mar 2023 16:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbjCGPp5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Mar 2023 10:45:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbjCGPpk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Mar 2023 10:45:40 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60CD2838B8
        for <io-uring@vger.kernel.org>; Tue,  7 Mar 2023 07:45:38 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id bo22so13602270pjb.4
        for <io-uring@vger.kernel.org>; Tue, 07 Mar 2023 07:45:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678203937;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+tuAKSjLmSekrz2ARkvc6YEQ/4uk4K08GbCmsJZcnXI=;
        b=qwQZRyUX6uO0xnXmVYkXwv6ysGAUmF6DrfVRKEh1lrZd4scXoO/AhTPR7TgNZX/TFF
         3t/jzZkSUiEFDFmNcXp1Qzj9gjoo9Fenns8u0nrRs+T9DTr0Z6JBsKfXS9QQajsE8Qs7
         SHjweGGQpJHOv9KMkWBNtGRTo5OrS0mxX0aUVAHczxURaw5uRslOv+qqBhBUh/ySdvd9
         pckdrf/AgWPbG75zuZe/k2253Rm1qxt55ixE6erRX1yAQNHKHKManhwvn3TlxJze6MU7
         MWeG8X9FRlZIRhNxfsqXjgqJGeX9erPaM4eML7IQ6bQWsJRDuTTWrWbh/udUyLmwF++6
         yP8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678203937;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+tuAKSjLmSekrz2ARkvc6YEQ/4uk4K08GbCmsJZcnXI=;
        b=XMjhRy8wPVCntlwDaVe9Ld911QRw2BaYF/vWeFa9rQdxHwOZJB3TiIAkdSMGIPTzZF
         cym9oF9A/XBOUAvfGomWIBmmTkLP3b8vDL3zzt9lXL/qStIl+In0P7YMVNsfILf3kkQy
         FG989vvgRE4JOCUPTkN246Ig+wisdlA1xs4O1W3AKZfB1lMgMnnLB5q6/Zpry35zqytd
         IFTKOwdRS8GjZ7HzQawZTYYfh3Fe3Z0qbe9YfxNkB3WChtklwi3sA1dQfXAAejOQTrY3
         zGdOCU9tMUvUHehbkkH2huJjq1Nu4N8dmQXn/+QUoRVyVX84pGeCWDNYz+vWYgblRBLf
         1s3g==
X-Gm-Message-State: AO0yUKXPqPig+dadhm5MN7AuQl0whSuMSn9BToBX+v53K4y8LLNjtkDp
        eNk9rsS/ZXpbPHOoNIuZPp4u6IK36iEJDbM2ftk=
X-Google-Smtp-Source: AK7set8C39CJgEF/FnbHs+EFkf2AdEyaA/dA9AeKcino6VCZChfnFF2+VVLNEhXdb6qu/czQ/eiF2w==
X-Received: by 2002:a17:903:2304:b0:19e:d6f2:fefd with SMTP id d4-20020a170903230400b0019ed6f2fefdmr5224005plh.0.1678203937489;
        Tue, 07 Mar 2023 07:45:37 -0800 (PST)
Received: from localhost.localdomain ([50.233.106.125])
        by smtp.gmail.com with ESMTPSA id kl15-20020a170903074f00b0019945535973sm8612359plb.63.2023.03.07.07.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 07:45:37 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     brauner@kernel.org
Subject: [PATCHSET for-next 0/2] Make pipe honor IOCB_NOWAIT
Date:   Tue,  7 Mar 2023 08:45:31 -0700
Message-Id: <20230307154533.11164-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

File types that implement read_iter/write_iter should check for
IOCB_NOWAIT in conjunction with O_NONBLOCK, so it can correctly bail
with -EAGAIN if we need to block for space/data. pipe doesn't currently
do that, and that's the primary reason for why io_uring needs to use
a slower path for it.

Add the appropriate check, and expand the io_uring "understands nonblock"
check so that we catch it.

-- 
Jens Axboe


