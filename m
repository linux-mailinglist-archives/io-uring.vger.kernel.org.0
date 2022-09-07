Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA4B5B0ACF
	for <lists+io-uring@lfdr.de>; Wed,  7 Sep 2022 18:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbiIGQ5o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Sep 2022 12:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbiIGQ5j (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Sep 2022 12:57:39 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E34BD1D7
        for <io-uring@vger.kernel.org>; Wed,  7 Sep 2022 09:57:31 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id q81so11971580iod.9
        for <io-uring@vger.kernel.org>; Wed, 07 Sep 2022 09:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date;
        bh=iEJ+Ajjl9N/7s7xBqcVQQRgxcDOg3e4kIU6TjS93Its=;
        b=qINhS9Y42383a8TQBLJNUYwk0cKvTuM9eTzLbh+VLUbhd5y2CuJ3oHZHTNruhRdKId
         sMX9dArunrVRNyWeqouxoJbQT1pkNMjY7LZtZVQPx6xlloXX4uPQCw7WmLQDz/pu0wnM
         TvQlDNkv3T7N9hVv28bz+ln7RTUwXQqalH1HJR2k+5rMVgJtMpEP4L4mFKGH5p5R83rf
         rB/1Bd7Xdw52dEO7xEWcrUCJ/eHs1r01vFfUbS/OcL94lO0ugAPy7gpdeQaJjV5BXjGJ
         SACWc7bdMsgiJbeu3r8uOc/tpTT071xNeOONkHW/dmVzbfn1vs6Oh6jDMpKsvyOlgNPZ
         KZMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=iEJ+Ajjl9N/7s7xBqcVQQRgxcDOg3e4kIU6TjS93Its=;
        b=g+seGMcB15dHoAGW2YgDHrGaq4NKffiT5ZqFmudZyxB86wMn0/I/WitfhfXjKEG0GH
         rhqkXkZkUiP5nRNLEAopSKpfgRIHsJd0hYsvTa466HG340/wn1960aXeyAjqIQCi+EAw
         72AgkKCdbkL3aIXVvjECcG/C22LKu034hyUk62aCJ3TbOZgNm5PBWd3+Dl21dnOmzmwq
         T0ZbsJKIaUyf3MUxLfYYfW8e1nEfpehyyE+Lc8P5dIvoa4HkMS+9cr4id0Yk7DCraql2
         UxWrPMcksdqDvfOr95rDNp3m/Y0oqTIcXFEz5a47XDfKSmPbJcqvFyAomcpHIzXyOJqt
         Ex9Q==
X-Gm-Message-State: ACgBeo0aGdDdyEsnmE1tQNqhb0o07zqU4SvsB9MKTF5r/D7kSGNijTay
        2Tx+s5pOvBdCMuzrKgE0w8yFag==
X-Google-Smtp-Source: AA6agR4Jda/RVn7M0fIhMC12ld7S5NVvqj/YWS7gpYtu8n1CWksCzdiJUBdzuiNP240pto6a950rcg==
X-Received: by 2002:a05:6638:2714:b0:356:74ed:a441 with SMTP id m20-20020a056638271400b0035674eda441mr2711670jav.250.1662569851090;
        Wed, 07 Sep 2022 09:57:31 -0700 (PDT)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id c17-20020a0290d1000000b00349e1922573sm7337677jag.170.2022.09.07.09.57.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 09:57:30 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Dylan Yudaken <dylany@fb.com>, io-uring@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Kernel-team@fb.com
In-Reply-To: <20220907165152.994979-1-dylany@fb.com>
References: <20220907165152.994979-1-dylany@fb.com>
Subject: Re: [PATCH for-next v2] io_uring: allow buffer recycling in READV
Message-Id: <166256985044.1932974.15663220087273783004.b4-ty@kernel.dk>
Date:   Wed, 07 Sep 2022 10:57:30 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.10.0-dev-65ba7
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 7 Sep 2022 09:51:52 -0700, Dylan Yudaken wrote:
> In commit 934447a603b2 ("io_uring: do not recycle buffer in READV") a
> temporary fix was put in io_kbuf_recycle to simply never recycle READV
> buffers.
> 
> Instead of that, rather treat READV with REQ_F_BUFFER_SELECTED the same as
> a READ with REQ_F_BUFFER_SELECTED. Since READV requires iov_len of 1 they
> are essentially the same.
> In order to do this inside io_prep_rw() add some validation to check that
> it is in fact only length 1, and also extract the length of the buffer at
> prep time.
> 
> [...]

Applied, thanks!

[1/1] io_uring: allow buffer recycling in READV
      commit: 8e966e46c38df6d4f45d2122e321b2d5982fcaf8

Best regards,
-- 
Jens Axboe


