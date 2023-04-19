Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49F866E710A
	for <lists+io-uring@lfdr.de>; Wed, 19 Apr 2023 04:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbjDSCQ4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Apr 2023 22:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbjDSCQ4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Apr 2023 22:16:56 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF4E358A
        for <io-uring@vger.kernel.org>; Tue, 18 Apr 2023 19:16:54 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-63b9f00640eso513716b3a.0
        for <io-uring@vger.kernel.org>; Tue, 18 Apr 2023 19:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1681870613; x=1684462613;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=muamLQ7BNDrYINnrrg/0xzuMSb3ugaWxyaTjmrCRNa8=;
        b=A8gxHOmUEOjuFSyBnaHQVrzHwfE/LVYkYPs9cpfwMfZVpntyFIH9J1LRxz9r5IEUsY
         lsi5h/hUY3bhyM/BrcUkqMAc1ZlmhVH49q/JoavUut0SfRyzZjkAaa7DMa896SvSoAi1
         yhCmkklNE8hPvnIWsb3IRxqOb65eO+0Fsf8xKiP7g7KWx61NfD7/Uh5svZ8Zwp5+V1v2
         pc5Uur0pzhP/fnUOLGjarV4c8SouFw95uqb4KWKa3dnzg12hbtsnNPssnqQuLQyH+KYn
         LPGXl5ddQMAcRDPeydWzlDLjHblm2Am1m4i9gIxgl1lecHTgLD99DqMUIgiM44N5OPVd
         uEKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681870613; x=1684462613;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=muamLQ7BNDrYINnrrg/0xzuMSb3ugaWxyaTjmrCRNa8=;
        b=B0+s4UKmdkTXsrs1XumUZFtdOoPHX3/D2kuEVsDjDM8LcuTsM8v/M5gFPIU2P4l04p
         2BVIws/RMni1CuyILr8afrqdkDhJvc2yK6LEvFOh86Krsi5NPbrpa4aa21izwdYW817B
         8ARI+WtqPVnCpn4649/+rsJm/6zpdYSG/CO/P8jw5VadjJMvGMPjx6hnApv97W2rEiA8
         PtyS6gJ9AHlWF3MI93AyS1DbH9Tt0DyhYHH0NoDlc17fmcHLQ0zh68JQu3m0DalIAJ6F
         t1vaW9m4/wQmSPlMHlR6y8sMGk+xv6drbPiz05ffXdnW0e6WZlwmXtAo527Q0Fy108Ps
         xDHQ==
X-Gm-Message-State: AAQBX9cP//iW0eKBzLnfzwKQph0SZiYUGtKzeGjiTabIHG+Wd0ywuI//
        ztEjzmUsp5KtgkRFdxiuUmjQkMhFLwuizAzijow=
X-Google-Smtp-Source: AKy350YpCFJD6aWEFIlJwZN2dhZYYgCgGHvOvi9D9wKoIO0LXZKa/ZkN+wLGze4y6zFfaJNAuGfUnw==
X-Received: by 2002:a17:902:db02:b0:1a6:cf4b:4d7d with SMTP id m2-20020a170902db0200b001a6cf4b4d7dmr11318264plx.2.1681870613484;
        Tue, 18 Apr 2023 19:16:53 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id g21-20020a170902869500b001a5260a6e6csm10210138plo.206.2023.04.18.19.16.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 19:16:53 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        David Wei <davidhwei@meta.com>
Cc:     io-uring@vger.kernel.org
In-Reply-To: <20230414225506.4108955-1-davidhwei@meta.com>
References: <20230414225506.4108955-1-davidhwei@meta.com>
Subject: Re: [PATCH v3 0/2] liburing: multishot timeout support
Message-Id: <168187061279.411072.10465891031145640627.b4-ty@kernel.dk>
Date:   Tue, 18 Apr 2023 20:16:52 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-00303
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Fri, 14 Apr 2023 15:55:04 -0700, David Wei wrote:
> Changes on the liburing side to support multishot timeouts.
> 
> Changes since v2:
> 
> * Edited man page for io_uring_prep_timeout.3
> 
> David Wei (2):
>   liburing: add multishot timeout support
>   liburing: update man page for multishot timeouts
> 
> [...]

Applied, thanks!

[1/2] liburing: add multishot timeout support
      (no commit info)
[2/2] liburing: update man page for multishot timeouts
      (no commit info)

Best regards,
-- 
Jens Axboe



