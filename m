Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9384D6367AA
	for <lists+io-uring@lfdr.de>; Wed, 23 Nov 2022 18:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236185AbiKWRvn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Nov 2022 12:51:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239340AbiKWRvV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Nov 2022 12:51:21 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D970FAEA4D
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 09:51:19 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id o5-20020a17090a678500b00218cd5a21c9so2490467pjj.4
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 09:51:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IX8MPQZb+p0ztiFx79aytOjU1ucL+NbMiAFmt7h3v3Y=;
        b=zi78sUUawYCeJLb/2JrSdw0CnaBQVpDgMQYYZWD211+D26U+5WU6hOK0Lq1hGNkq7A
         OI3LCIpcWnELb7h42VBln6oqQKCHUx8U2pWfddK5cEOS+jxp4NQquTgabi5iD/M5sQYU
         MIpJJkWJqVHk/cLKad/il0PT518x4S5E8SYm+tEMrIQEQvg1L1/XgHCSETvwvvX3Js9n
         IjNwAHN+fDCE9eH67/7HZ02vJ0bmC7JsKd6G1NeWePev4/TW2aqToz07RJ9vRVZ/Uu9B
         0Ljp+ggLF88ct6CpoMgYN4wKTTVtnvDTTZnOin8fu3GPBOA3yKpqMUyj51SkjtdcPWk2
         hBEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IX8MPQZb+p0ztiFx79aytOjU1ucL+NbMiAFmt7h3v3Y=;
        b=zspjrCw2UL3z+iZI94zQZKqltv7oQocX2PAB1EHgXyeTLiKyEWUr4cVILLFwqv1iJd
         K/DlaKlIacQYXKU4tNDXFBoOy2tENIXetWMVkgOBX3jgtvN167u2kmdbZONwDla3vlf6
         Ai9vO0NIOv2PoEbFa4+B5Dae+8/yOW3xAQQIcSCGqPLJYiStOrIVdj5AQ+HiWUnqGSS1
         x8ALE1ymWH4MTq63ZLcln4JszuLuXfN6NzeJdIhahPUi8/KZk+bIkF7Sh2ilQ5OlerID
         1RnMmGVDbX1fNBrqjAH3O38JhOSn3tWCXNf8PlF5IaBv0177qClkVbevzeg3eW4Ov/jY
         H+1w==
X-Gm-Message-State: ANoB5pn2t1/LRODD8pGvanvPA6C/ejKxVL/QLD5uGG/8gOy6tarjaNDK
        OLj+Rzenzaym7ldUy7Kf7K71hLD/WmMcnA==
X-Google-Smtp-Source: AA0mqf5B+FVpBnwSqxoEjEcrt746Ygn9K/miXuRzdOQbhAhhWD6W4KVSxtivBBtGdZIKs/T6vBlMeg==
X-Received: by 2002:a17:90a:6c26:b0:218:f02a:f08f with SMTP id x35-20020a17090a6c2600b00218f02af08fmr2483564pjj.1.1669225879174;
        Wed, 23 Nov 2022 09:51:19 -0800 (PST)
Received: from [127.0.0.1] ([2600:380:4a4b:9d2c:aa9c:d2b:66c9:e23f])
        by smtp.gmail.com with ESMTPSA id jb11-20020a170903258b00b0017f72a430adsm4589544plb.71.2022.11.23.09.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 09:51:18 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1669203009.git.asml.silence@gmail.com>
References: <cover.1669203009.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next 0/7] iopoll cqe posting fixes
Message-Id: <166922587796.11363.1617487857460932211.b4-ty@kernel.dk>
Date:   Wed, 23 Nov 2022 10:51:17 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-28747
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 23 Nov 2022 11:33:35 +0000, Pavel Begunkov wrote:
> We need to fix up a few more spots for IOPOLL. 1/7 adds locking
> and is intended to be backported, all 2-5 prepare the code and 5/6,
> fixes the problem and 7/7 reverts the first patch for-next.
> 
> Pavel Begunkov (7):
>   io_uring: add completion locking for iopoll
>   io_uring: hold locks for io_req_complete_failed
>   io_uring: use io_req_task_complete() in timeout
>   io_uring: remove io_req_tw_post_queue
>   io_uring: inline __io_req_complete_put()
>   io_uring: iopoll protect complete_post
>   io_uring: remove iopoll spinlock
> 
> [...]

Applied, thanks!

[1/7] io_uring: add completion locking for iopoll
      commit: 2ccc92f4effcfa1c51c4fcf1e34d769099d3cad4
[2/7] io_uring: hold locks for io_req_complete_failed
      commit: e276ae344a770f91912a81c6a338d92efd319be2
[3/7] io_uring: use io_req_task_complete() in timeout
      commit: 624fd779fd869bdcb2c0ccca0f09456eed71ed52
[4/7] io_uring: remove io_req_tw_post_queue
      commit: 833b5dfffc26c81835ce38e2a5df9ac5fa142735
[5/7] io_uring: inline __io_req_complete_put()
      commit: fa18fa2272c7469e470dcb7bf838ea50a25494ca
[6/7] io_uring: iopoll protect complete_post
      commit: 1bec951c3809051f64a6957fe86d1b4786cc0313
[7/7] io_uring: remove iopoll spinlock
      commit: 2dac1a159216b39ced8d78dba590c5d2f4249586

Best regards,
-- 
Jens Axboe


