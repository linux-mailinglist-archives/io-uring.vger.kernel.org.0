Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A93EC6BD2E3
	for <lists+io-uring@lfdr.de>; Thu, 16 Mar 2023 16:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbjCPPCn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Mar 2023 11:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbjCPPCm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Mar 2023 11:02:42 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3406DC09F
        for <io-uring@vger.kernel.org>; Thu, 16 Mar 2023 08:02:39 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id o12so911767iow.6
        for <io-uring@vger.kernel.org>; Thu, 16 Mar 2023 08:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678978959; x=1681570959;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vuAPzOCuYYJDA+FmSjp4s7iqOZ9Yxi4WeqZLC5ABfZo=;
        b=sOt6q/awPP1uS1aLXmnYbJ0HZ+H5BqzfXdtdzyz7xw89iOprT0hbE9XxV7Q1V09cLO
         lFRs83RlJi46RwS87boIEqdTK/ADHpiVzsg36DK8m0iwpgFGT91C8Q45J6fAUHzPdXo0
         hbMruEEML1AtJiEizloj3DeTETYYDPDfjsgGLqA8aj+qRn/KoljNylkAo4tGB+vHG8GU
         qhFXwvAZ5NCfQRQWn6sE9MgaxMguGf+/mQV/noyVP+c8LznkNrohgzbiz7JeDRB+7WCo
         58lazVKldkQWb484pi4eAbBLd5B1Pa1/nK5lkCwZq2gCpiEX1LYOvQshUX+WpiSMiSH0
         Ul+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678978959; x=1681570959;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vuAPzOCuYYJDA+FmSjp4s7iqOZ9Yxi4WeqZLC5ABfZo=;
        b=16UsOPoPHAUOU2rDjhTpUhXSqUf6BR0aGOw2Do6o5RrTeLFitEYGr4I6z/CZdXTLj9
         5QgoE3LXLRzqwBySzuC5JHK5QkkNOSgqKMX4fE+szIDgb6Usq7UsHACe2gQHIxq145dD
         o2ewf/Y0sWeW6ZI3SnIa7T1M8gPlORsCq51S19VPpXXROiz0Ev6LaGttC/w8VS7qJ1i+
         A0s8+LaZ1z6czXhTxFIbSrUMJzkaj0BsMXCBtOWYyXLLjj2VNz2v6qiyPTapsiKduy+2
         bNdPKm7jQWbgRwv0Y06DDGs7jPoHF9L06blrBjzetSL5nsexotetY2D8dJH77vjPThIO
         Lhmw==
X-Gm-Message-State: AO0yUKUgBS8tX/7HwT2vfSqqw+ZQHHSEIGdUCynaQUZDWqoHryGjV1cZ
        6a7CciMxIWyJtqwoW1c/abFWO5y+YoOET2h+RQVVNw==
X-Google-Smtp-Source: AK7set92llsHCCsfvWCHDHacugIC6Aymt8Nq2AoLr0XJsKBxlRgW+eFaWw/VOvtr3FZezrKNvc0QnA==
X-Received: by 2002:a6b:6e08:0:b0:74e:8718:a174 with SMTP id d8-20020a6b6e08000000b0074e8718a174mr3705267ioh.1.1678978958520;
        Thu, 16 Mar 2023 08:02:38 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id m6-20020a056602314600b0073fe9d412fasm2641614ioy.33.2023.03.16.08.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 08:02:38 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1678968783.git.asml.silence@gmail.com>
References: <cover.1678968783.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing for-next 0/2] fd msg-ring slot allocation
 tests
Message-Id: <167897895800.18202.8078270205894550412.b4-ty@kernel.dk>
Date:   Thu, 16 Mar 2023 09:02:38 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-2eb1a
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Thu, 16 Mar 2023 13:09:19 +0000, Pavel Begunkov wrote:
> Add a helper for fd msg-ring passing a file and auto allocating the
> target index, and test it.
> 
> Pavel Begunkov (2):
>   Add io_uring_prep_msg_ring_fd_alloc() helper
>   test: test fd msg-ring allocating indexes
> 
> [...]

Applied, thanks!

[1/2] Add io_uring_prep_msg_ring_fd_alloc() helper
      commit: ab9113c58b43c33f305822739abd6084e02c8a63
[2/2] test: test fd msg-ring allocating indexes
      commit: ab9113c58b43c33f305822739abd6084e02c8a63

Best regards,
-- 
Jens Axboe



