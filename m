Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB835819B2
	for <lists+io-uring@lfdr.de>; Tue, 26 Jul 2022 20:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbiGZS3y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jul 2022 14:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiGZS3x (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jul 2022 14:29:53 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1063E14020
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 11:29:53 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id q7-20020a17090a7a8700b001f300db8677so1213532pjf.5
        for <io-uring@vger.kernel.org>; Tue, 26 Jul 2022 11:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=CSYpYENbk1uF7ZV+Dgrai+jK/64YP6z3b1wLCat9uPo=;
        b=2aBcf7If/nm1WOHNMfRlI+hmd2Zx2xpOAtvvckZzU2onVaAvpLkJCHaGLjx8ce8xLI
         9IG5rTK7a79YUxBGYZG0yMfPKMHcXcbkBptx2+9fIT4keryMXiwblt94biPj9F9Lj2gM
         gHUp8Bt5yhoqmoDiydqBOaXfzXt0vgcqVRkzFkEfbhr5lt5hV6Bc2nglnQwqorP0NZcK
         PxQk6yR/ICQE0oIHdCYS4B8BXwtmX5/axSnpsby4onify3ImrfL/ttU/OCwlDQkdriqI
         RefkcvwdenC0OgfTAcHaKsM72mQh0iDCnvTKGxXRx+112D0IAn9mh3AFbhz1D28Gmhyo
         AwHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=CSYpYENbk1uF7ZV+Dgrai+jK/64YP6z3b1wLCat9uPo=;
        b=POYx2YhX8YK71Gixzagla1F7iOacAPaKut3MCEeNIg9KclmbBL7+UMsdamSWDWLNgT
         UgJdRZV9CZZXhAEXkqTDsdeN7he6Dd0H1eQUIi8HK9F3EWTWiPDPHDKFzxWcgsFj3QRu
         I1PCgiHMwIZ4xesdqZwLRpoeCMzemaGBvvu1wyBlopOU1TK8yGd+ozn9WtswyhVwt3vR
         yiYfc9KRvQaWBcLn93KQM+R/IZ8RNZ+NG55hbqFYahdSuhLpyRekQRfGhyaqtEf3Yy7U
         qMPd0ZPhKEQYQtaio1WkZnNt3AVwinzx98cYWWLiy1am2Xd5OCngDvwQwO39oslXNq9V
         M5EQ==
X-Gm-Message-State: AJIora+OYd1K0+lrfqS8Np2JrhJ1AuysEemuNuweVSdEr6op3sbfA7RJ
        aOFGJ/H1I1nUv3RMi48rX4YphEFRQcgDdQ==
X-Google-Smtp-Source: AGRyM1vspqCdikl8GIj0QqimEp/ha3Y8lYy3uGln2+BuUgWPB2LQH1M068kgsQtqv+uu3B7zmMCGQw==
X-Received: by 2002:a17:90b:3a84:b0:1f2:8d9d:46f3 with SMTP id om4-20020a17090b3a8400b001f28d9d46f3mr480933pjb.174.1658860192575;
        Tue, 26 Jul 2022 11:29:52 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id c15-20020a631c0f000000b0040c74f0cdb5sm10482649pgc.6.2022.07.26.11.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 11:29:52 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     asml.silence@gmail.com, io-uring@vger.kernel.org
In-Reply-To: <9e010125175e80baf51f0ca63bdc7cc6a4a9fa56.1658838783.git.asml.silence@gmail.com>
References: <9e010125175e80baf51f0ca63bdc7cc6a4a9fa56.1658838783.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next] io_uring/zc: notification completion optimisation
Message-Id: <165886019187.1523978.7573816236813433809.b4-ty@kernel.dk>
Date:   Tue, 26 Jul 2022 12:29:51 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 26 Jul 2022 14:06:29 +0100, Pavel Begunkov wrote:
> We want to use all optimisations that we have for io_uring requests like
> completion batching, memory caching and more but for zc notifications.
> Fortunately, notification perfectly fit the request model so we can
> overlay them onto struct io_kiocb and use all the infratructure.
> 
> Most of the fields of struct io_notif natively fits into io_kiocb, so we
> replace struct io_notif with struct io_kiocb carrying struct
> io_notif_data in the cmd cache line. Then we adapt io_alloc_notif() to
> use io_alloc_req()/io_alloc_req_refill(), and kill leftovers of hand
> coded caching. __io_notif_complete_tw() is converted to use io_uring's
> tw infra.
> 
> [...]

Applied, thanks!

[1/1] io_uring/zc: notification completion optimisation
      commit: fbe6f6bc3210e853aab74f20da776c15c5b052fe

Best regards,
-- 
Jens Axboe


