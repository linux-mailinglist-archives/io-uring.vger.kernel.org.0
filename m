Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 566A765D86D
	for <lists+io-uring@lfdr.de>; Wed,  4 Jan 2023 17:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239442AbjADQOI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Jan 2023 11:14:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235344AbjADQNz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Jan 2023 11:13:55 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F1021BE89
        for <io-uring@vger.kernel.org>; Wed,  4 Jan 2023 08:13:54 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id c20so15852319ilj.10
        for <io-uring@vger.kernel.org>; Wed, 04 Jan 2023 08:13:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S5HrMmszeCkakWjTp/dqbpB08LRxXrxzuzEiOMptf+I=;
        b=wAJSTowZo0FPkHg3k6fzXi8P8od/f1xRyttf3aLl7mkeFkN7Pv63FcCENr7p275HKu
         HfQ5/DTrsQ4oWZg/8Eyeci/UKbP3HBY6AmFgDtwwqzzerl8CCJGR+vm94d35VeUXQbXK
         AYlNxR+Fo54BVsTdvJlG74N5xo9rSIcF+o7mEFuF+V325GTaB1ebC7Ca6JLQRijG7xfL
         /xVtHnG7fpWe28whmCLqbSQPSRtF1CrjXRNnxhb1rS5aqYzbakXKQSa4ZIsLb1CZEIQN
         pzWkGszBg6bV25lVm7Hbq92hopytXO/brz1OTmfJJYE2pjo8YoFX8h87uFN4rKJIb++3
         aUZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S5HrMmszeCkakWjTp/dqbpB08LRxXrxzuzEiOMptf+I=;
        b=BuGQhZZefd3NPiM8Z5fJduFUJNN/pxghyQg45hCC5sUNyhjyUUPwG62v3yNhO/H/Py
         j8lOMVrGrah6Byi4BRxBgnIi3y2YumIhOrV+Jv/b7/UbTggHg/shj8VjF9L+FUWTsfAl
         he2MR4b464V7ZJNi6Ge4SwFwN9vaYZ7mMj06K+C56GKd8pr8EvHx+J0r3I7b8oP81Yvo
         U5jCK2cfaGhuVuPuOd21FV4XbNInnn657CxsFJSp3+zLRnC4g9jmFXl1yvoqmB066/QF
         em8v7TgS+lIHTkMWeXTKoAejSASXKXfTsELfr2yH6mPWvnBaTrshaLFHQAhEE5OohrZE
         /Q3w==
X-Gm-Message-State: AFqh2kpDhCJIh+QprCh1FVY+VAX503hfRQezvZZ36N37dDnARY+/x7r2
        oM6N4qI+OZ1PaM3fSpykXHNheIAw+deVa0MQ
X-Google-Smtp-Source: AMrXdXuOJgErIQSYrrt/dfHkCHvydqRs7d/TP9+/cHCG/9duA1WY+iPeG7TwPrIZsrXZGd790Cvkeg==
X-Received: by 2002:a92:d4ce:0:b0:30c:493e:ecf2 with SMTP id o14-20020a92d4ce000000b0030c493eecf2mr1650444ilm.0.1672848832978;
        Wed, 04 Jan 2023 08:13:52 -0800 (PST)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id i17-20020a056638381100b0039d8bcd822fsm11181349jav.166.2023.01.04.08.13.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 08:13:52 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: =?utf-8?q?=3Caa3770b4eacae3915d782cc2ab2f395a99b4b232=2E1672795?=
 =?utf-8?q?976=2Egit=2Easml=2Esilence=40gmail=2Ecom=3E?=
References: =?utf-8?q?=3Caa3770b4eacae3915d782cc2ab2f395a99b4b232=2E16727959?=
 =?utf-8?q?76=2Egit=2Easml=2Esilence=40gmail=2Ecom=3E?=
Subject: Re: [RFC 1/1] io_uring: lockdep annotate CQ locking
Message-Id: <167284883203.63338.1722306476820562568.b4-ty@kernel.dk>
Date:   Wed, 04 Jan 2023 09:13:52 -0700
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


On Wed, 04 Jan 2023 01:34:57 +0000, Pavel Begunkov wrote:
> Locking around CQE posting is complex and depends on options the ring is
> created with, add more thorough lockdep annotations checking all
> invariants.
> 
> 

Applied, thanks!

[1/1] io_uring: lockdep annotate CQ locking
      (no commit info)

Best regards,
-- 
Jens Axboe


