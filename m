Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF9246050B6
	for <lists+io-uring@lfdr.de>; Wed, 19 Oct 2022 21:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbiJSTtX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Oct 2022 15:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbiJSTtW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Oct 2022 15:49:22 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F146EE81
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 12:49:19 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id c24so18257716pls.9
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 12:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DE+pC1xoa6jKzJgz9ssD3qXjzyl5nNC8ht+oyc3rAWU=;
        b=yUHzem6sIADgl8VuoSM7oJkVqb+B5GHyJmRtSkk0r+NAk9gYc798fS+bCXMzJ0sPqz
         gvhK1tXz6VWvJO1Aut71+PSwDju5EPluhhqCTyB9zoRDkmzWhYIiZJNVrEjApe8DORn8
         KcevE4cLtP5SHAZpXPXIFh4xUNN7j9hoL5P4wBDwwUNG4OFARL04b8gmHZGE5jbZZ/Ph
         AtWzdmd0UHVDDpgIdbRXMTQwQmEG7tr4dm2DJk2KynNJ1xzwv826mP1LceJ3JBfgdFYx
         PAvM2DUd4lH0lArT6GV6RokgNsDgwR1/9x8oR9ELO347v6rLm6YNmMTkiseODRtqZ+/3
         0WgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DE+pC1xoa6jKzJgz9ssD3qXjzyl5nNC8ht+oyc3rAWU=;
        b=zmDq6rUIpayvnazvM/8DlKv259dPmfFfxcMm6E7NYWPzz3d8LmcsmIvUDGRUN7Blhl
         RbUgJtNXxYJW/zZX3N787I3WLTMu/K5n07pUw4MAnEuFf/zx85pPE2uf8u+tyj5lQ2EN
         uVAukoNP59PBALrvRFwuaMnxfnSVPsWNNt+RCkbqKj6Qe6xlmX+1xpeshWcypUqbAMrq
         l4mEuzkUTu3r0H7fkuLb6beLPfPk7tWNFSwvLblqpJ+xsDMVXL4h2dCbJEPzpkJLpgP6
         aoxf9kOD3apT+R3TmOdQZk1hsOQu7AiNzEdaZ/qPJiWIt/e+WnXIU+NXjvYYowFre69k
         hiZQ==
X-Gm-Message-State: ACrzQf2QnGrhziJJ/m3CMj/t8TQxPr3nKZ064HR3jJifVDEfXpKQ8+af
        8fJE4S9Vd8K0pNxSLTAVw2p7Kw==
X-Google-Smtp-Source: AMsMyM7m5RpbE9FxNm/vTBWuqHTRCXyAoU5oSnqjcB5Qa4UB1SAgXCrRAktuhVVRZXJoQ6L3/ANkCw==
X-Received: by 2002:a17:90a:a088:b0:20d:67b7:546d with SMTP id r8-20020a17090aa08800b0020d67b7546dmr12127533pjp.6.1666208959487;
        Wed, 19 Oct 2022 12:49:19 -0700 (PDT)
Received: from [127.0.0.1] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id 72-20020a62194b000000b00562362dbbc1sm11531811pfz.157.2022.10.19.12.49.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 12:49:19 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org, vegard.nossum@oracle.com,
        io-uring@vger.kernel.org, harshit.m.mogalapalli@gmail.com,
        syzkaller <syzkaller@googlegroups.com>
In-Reply-To: <20221019171218.1337614-1-harshit.m.mogalapalli@oracle.com>
References: <20221019171218.1337614-1-harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH] io_uring/msg_ring: Fix NULL pointer dereference in io_msg_send_fd()
Message-Id: <166620895849.131373.4257100476341517725.b4-ty@kernel.dk>
Date:   Wed, 19 Oct 2022 12:49:18 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-d9ed3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 19 Oct 2022 10:12:18 -0700, Harshit Mogalapalli wrote:
> Syzkaller produced the below call trace:
> 
>  BUG: KASAN: null-ptr-deref in io_msg_ring+0x3cb/0x9f0
>  Write of size 8 at addr 0000000000000070 by task repro/16399
> 
>  CPU: 0 PID: 16399 Comm: repro Not tainted 6.1.0-rc1 #28
>  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.0-2.el7
>  Call Trace:
>   <TASK>
>   dump_stack_lvl+0xcd/0x134
>   ? io_msg_ring+0x3cb/0x9f0
>   kasan_report+0xbc/0xf0
>   ? io_msg_ring+0x3cb/0x9f0
>   kasan_check_range+0x140/0x190
>   io_msg_ring+0x3cb/0x9f0
>   ? io_msg_ring_prep+0x300/0x300
>   io_issue_sqe+0x698/0xca0
>   io_submit_sqes+0x92f/0x1c30
>   __do_sys_io_uring_enter+0xae4/0x24b0
> ....
>  RIP: 0033:0x7f2eaf8f8289
>  RSP: 002b:00007fff40939718 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
>  RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f2eaf8f8289
>  RDX: 0000000000000000 RSI: 0000000000006f71 RDI: 0000000000000004
>  RBP: 00007fff409397a0 R08: 0000000000000000 R09: 0000000000000039
>  R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004006d0
>  R13: 00007fff40939880 R14: 0000000000000000 R15: 0000000000000000
>   </TASK>
>  Kernel panic - not syncing: panic_on_warn set ...
> 
> [...]

Applied, thanks!

[1/1] io_uring/msg_ring: Fix NULL pointer dereference in io_msg_send_fd()
      (no commit info)

Best regards,
-- 
Jens Axboe


