Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33BBA78CB6A
	for <lists+io-uring@lfdr.de>; Tue, 29 Aug 2023 19:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232927AbjH2RiA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Aug 2023 13:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238027AbjH2Rhb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Aug 2023 13:37:31 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF157E6B
        for <io-uring@vger.kernel.org>; Tue, 29 Aug 2023 10:37:10 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-68781a69befso757228b3a.0
        for <io-uring@vger.kernel.org>; Tue, 29 Aug 2023 10:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1693330630; x=1693935430;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ik9TJtFE3YEIUMCcxP8Lr5T0iL4PN7cYCqS29RKZ3lc=;
        b=2ThVKRX45HHni+r8xsfEJSi4hMvdn6NPMzQr/ggL0M548xSOTqK4zyuVvU/EVEoUJR
         wn7FSyfkDEfIVLLDgNVl40UTTSld/v6YTBycdhlOEyIoaqluZxAQrJpSAqJviojR8PYJ
         U6L7y2rCIUj3zsICkBssOmyRAXgXya1b2J4az2G0u1rimdSNsiIpBWZi39hTESgvhDmL
         Utt1iYVgx/FRfwtT+WMF3iKaAypABm9aa/V15A4njQC+5lX76VqRsXSzkHQb3UrlRdSf
         Hgr9oesm44Q21eq+KpFhCa6L1m48TwoM4MbuudalOFpsdAA9vIIwcMz9ZS8HZSEU0K+9
         Rc2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693330630; x=1693935430;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ik9TJtFE3YEIUMCcxP8Lr5T0iL4PN7cYCqS29RKZ3lc=;
        b=TJgsU9xjFk+tpeMfXNrOcQ7cCSdMtuErhWLqo6haVjxoFrNXUObL0wDgAMmgLyh/wL
         JbvEox0RISQrBGG+Ik2tGqnQuCIoxpYIbe2PH/1nKMtVroLsZb/ziwukNSPqOIv+hjt2
         rGDfsKJdINWR0r2tITzVA6oz7tOWUeTDulnkrAnpoGf4R6YKVRVZhsFu7Wn9bXYLBvf3
         6vwUnTfPDzIILnWuM23zJvrxPTb7UMhgFSDrbtYmJI5VurIUipV8cCRztksTGd8n76TL
         pckNJGZDEfdETSOH6o1SNLh6YyOAy/GybptaKpU0b3R64Bo5we98BKtn4pKM/OZdu+Tl
         eWBg==
X-Gm-Message-State: AOJu0YzHPIV4uQn5iRJsJ1yHkU5PhGeZA48S7zn4bLDLS+N+lfPUn/sk
        nBRLilUMObdVQpSjNrIvmd5mfuwVmHqDzv7EbMc=
X-Google-Smtp-Source: AGHT+IHf1zVzk8olCuf63PodVsBIOJYjsy/rXO66fzK5kZ8C8/NaEyEtTdbZLDUVzDrQWuS+HmxcGw==
X-Received: by 2002:a05:6a20:5485:b0:123:3ec2:360d with SMTP id i5-20020a056a20548500b001233ec2360dmr38257770pzk.5.1693330629874;
        Tue, 29 Aug 2023 10:37:09 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u14-20020a170902e5ce00b001bd41b70b60sm9656893plf.45.2023.08.29.10.37.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Aug 2023 10:37:08 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     syzbot <syzbot+c74fea926a78b8a91042@syzkaller.appspotmail.com>,
        Gabriel Krisman Bertazi <krisman@suse.de>
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
In-Reply-To: <87v8cybuo6.fsf@suse.de>
References: <000000000000753fbd0603f8c10b@google.com>
 <87v8cybuo6.fsf@suse.de>
Subject: Re: [PATCH] io_uring: Don't set affinity on a dying sqpoll thread
Message-Id: <169333062825.97232.1128295374932647568.b4-ty@kernel.dk>
Date:   Tue, 29 Aug 2023 11:37:08 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-034f2
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Mon, 28 Aug 2023 19:42:49 -0400, Gabriel Krisman Bertazi wrote:
> Syzbot reported a null-ptr-deref of sqd->thread inside
> io_sqpoll_wq_cpu_affinity.  It turns out the sqd->thread can go away
> from under us during io_uring_register, in case the process gets a
> fatal signal during io_uring_register.
> 
> It is not particularly hard to hit the race, and while I am not sure
> this is the exact case hit by syzbot, it solves it.  Finally, checking
> ->thread is enough to close the race because we locked sqd while
> "parking" the thread, thus preventing it from going away.
> 
> [...]

Applied, thanks!

[1/1] io_uring: Don't set affinity on a dying sqpoll thread
      commit: 37b1499057f61de370dbd8f0c296274ab7186605

Best regards,
-- 
Jens Axboe



