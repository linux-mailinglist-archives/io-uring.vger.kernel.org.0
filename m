Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94B955A664F
	for <lists+io-uring@lfdr.de>; Tue, 30 Aug 2022 16:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiH3Oa2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Aug 2022 10:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiH3Oa1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Aug 2022 10:30:27 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C54606BB
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 07:30:25 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id y187so9373944iof.0
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 07:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc;
        bh=iYPC8bM1Una8HAcigMeJNIZBEZxE0Qy4YLtjgyoCnog=;
        b=IVZ5qpN0M2x1tYAKu/b091AyY0UowiYvzcTvD2bidKz4TsmnSP8X7pt/qC0afMwKvD
         XrNW7Uz2T+A2Ln+uMA1JvgqJpEYNA8qGc18p4KrIFlwRMh3rT/2wTs2IuRcoE9r8ve4j
         uSMp8fEJzz5iDUAyxHByH3l2UKvhR0leJHURWtg7EFjb/XY0PI7xEWXmkBhD8tdID4C+
         T22EA87l8LsWt2xWV0L91ExO2rcsKhO8zJBKHlfDbVWDlta/ziADhzDXC4QamPfZdisk
         k7dEhW1UdBmCwC9lyDux8iD2QLPnL/nkScC62ElFV24nUW5CaaOGlQJCuFhwx/OmdXgd
         zESw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc;
        bh=iYPC8bM1Una8HAcigMeJNIZBEZxE0Qy4YLtjgyoCnog=;
        b=JGd7S/AtP2aCIbC5gnAqMPf/52NzAaX6Ol90khaYrfXV3Xnrde86ik0kwq4xgtB7dO
         qGRFID4XnoMMQO9SJHTnTy2HN/ZFFXA8xoO/wfwgln0Ivn/Gk79K/k+wfRQzYifzQldb
         QkWP3kETxWNNzfAJcNBpGUMVYyE3YSMoL0zdylrgqQeihSQCzUga4Mvy8MfG7Y1nEEiC
         dk9Nua6UOUohunGlnrHzh9RWpywcBOPYtTmhWRffF1+8AggwU5WICwpzyN7WZW7mm357
         3t06Nf2ETtyMezrcPufXIZKbdng5y7023aJg59Ch8cGAA/tFyxMAVBGKgPnJkAmTvUy5
         aEUA==
X-Gm-Message-State: ACgBeo0qpgaUOCFdDtKxKD1Xrf3FLDK/ev4IB8eR10KeodwfKriKB1QB
        xM0K/N3skBL6WSBtKFzdv87fwA==
X-Google-Smtp-Source: AA6agR44dDL/EtrroIUTFGz1IX3Uk3JJRgleJBODSY/VPDpRNT1to82V9uKelfBSzYu6+x1QKnrlkw==
X-Received: by 2002:a05:6638:138c:b0:349:b988:4486 with SMTP id w12-20020a056638138c00b00349b9884486mr12077088jad.315.1661869824902;
        Tue, 30 Aug 2022 07:30:24 -0700 (PDT)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id cs26-20020a056638471a00b0034c0a83be4dsm247002jab.2.2022.08.30.07.30.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 07:30:22 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Dylan Yudaken <dylany@fb.com>, io-uring@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Kernel-team@fb.com
In-Reply-To: <20220830125013.570060-1-dylany@fb.com>
References: <20220830125013.570060-1-dylany@fb.com>
Subject: Re: [PATCH for-next v4 0/7] io_uring: defer task work to when it is needed
Message-Id: <166186982233.41433.18357763965407387116.b4-ty@kernel.dk>
Date:   Tue, 30 Aug 2022 08:30:22 -0600
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

On Tue, 30 Aug 2022 05:50:06 -0700, Dylan Yudaken wrote:
> We have seen workloads which suffer due to the way task work is currently
> scheduled. This scheduling can cause non-trivial tasks to run interrupting
> useful work on the workload. For example in network servers, a large async
> recv may run, calling memcpy on a large packet, interrupting a send. Which
> would add latency.
> 
> This series adds an option to defer async work until user space calls
> io_uring_enter with the GETEVENTS flag. This allows the workload to choose
> when to schedule async work and have finer control (at the expense of
> complexity of managing this) of scheduling.
> 
> [...]

Applied, thanks!

[1/7] io_uring: remove unnecessary variable
      commit: e2f73811084cb6f4821cbe6e53bb0d9407af52f5
[2/7] io_uring: introduce io_has_work
      commit: cb0101159452eb63d0facf806e0a868963a11035
[3/7] io_uring: do not run task work at the start of io_uring_enter
      commit: 415f872f5f3aedb62bf857c6e315a88e26c08aaa
[4/7] io_uring: add IORING_SETUP_DEFER_TASKRUN
      commit: 2a23c7a52405c17183f36ef4aefb1fcf44425c2d
[5/7] io_uring: move io_eventfd_put
      commit: 488a41100f4b9d7e10f05edead4e4d6d1c0c85a9
[6/7] io_uring: signal registered eventfd to process deferred task work
      commit: 3403692af0c6d5ae826f536a2c08f4e7c0b8b163
[7/7] io_uring: trace local task work run
      commit: 73100da58e5b1f6d8ba85e134463fb2aaca59978

Best regards,
-- 
Jens Axboe


