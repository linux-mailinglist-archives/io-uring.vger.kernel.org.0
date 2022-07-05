Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 835B15670F2
	for <lists+io-uring@lfdr.de>; Tue,  5 Jul 2022 16:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbiGEOYm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Jul 2022 10:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231382AbiGEOYk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Jul 2022 10:24:40 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8292E2D
        for <io-uring@vger.kernel.org>; Tue,  5 Jul 2022 07:24:39 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id r1so11092187plo.10
        for <io-uring@vger.kernel.org>; Tue, 05 Jul 2022 07:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=61rL+HnsSSlqFnYLX20wuwootRYdjk0r+bRPV4nSTkk=;
        b=H/iupVZ67bS3d2WOutNpDoVSiWP0wfkKDf2RN0vuHAFAhAqLqI1Gwm/VMpgPQiutBn
         mDzoMUGjR0FtNBv3M3gj8HFY+MlxrdoSx6HNFD4O1qvn8rbrLFgtYu4uvWcP6rv0ijHK
         xiC6+V++iS2E32mTrg3kwYruPO3YmHMmL5HB6+ybkwrFiXRDLccQbdDlq46031ZjvHZu
         kv9Wn3ej9JO3ANvrPMZo1enjqQEO3iewS9sQySNmVsV4KREpOwJB8t++Raz+Yd7tyRDk
         TnLOFnqaNvpQ5CSVzv4y9WWD8cNohZNvMEVaYdL4QCP9VAvixPFkDkR5FzPWYRHUwE/4
         l1rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=61rL+HnsSSlqFnYLX20wuwootRYdjk0r+bRPV4nSTkk=;
        b=62q8ROu7PqD6IS/GqJCX67KHVpwW749rd8yWRgrDpfm8N5VB+XcHKqsi5+RPwsQBze
         dp0kvdCCDgzjnrISQ5kv8LqRghzfquDAxR1ooZG70nL2yrWfqkxpsWS8kBmZYb8KnIO8
         9th1FoEKSPNIyiMjM0QgKT2qEJ6v70wOVM7jIUBv0BblBCNm2FVMoETvv/IxJakZyBpG
         JWKxRQsjru0FBC8JmOkEPvQ8f71eELxXGYjB1FVEd9Pxvum78vTpAM1KZwB1/QMJsGah
         cmAyMMxNB41GYtkbJVGAA2LHieYC3VJK1EcztPq5O4e3BYW9dXo9lVmfCETQXixQfduQ
         Tcdg==
X-Gm-Message-State: AJIora9KXrGkekZRrmf2GrK0lB8EwRCZEf4cjJsgMFNfYHpR2odysq6H
        kog9gopaHrGzr5Mu8xAzsikkjpwSuRur8A==
X-Google-Smtp-Source: AGRyM1u00c1lc7doCoFqNJAXdb7/FoafMdh2rIF9LqxlYNwldOK1GQVr2+99AEFFSbw68HF0015qZQ==
X-Received: by 2002:a17:90b:3b92:b0:1ef:9234:399b with SMTP id pc18-20020a17090b3b9200b001ef9234399bmr7508581pjb.176.1657031079403;
        Tue, 05 Jul 2022 07:24:39 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id im22-20020a170902bb1600b0016be2bb8e68sm4705529plb.303.2022.07.05.07.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 07:24:39 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     dylany@fb.com, io-uring@vger.kernel.org, asml.silence@gmail.com
Cc:     Kernel-team@fb.com
In-Reply-To: <20220704140106.200167-1-dylany@fb.com>
References: <20220704140106.200167-1-dylany@fb.com>
Subject: Re: [PATCH] io_uring: disable multishot recvmsg
Message-Id: <165703107869.1916593.4750137653513375608.b4-ty@kernel.dk>
Date:   Tue, 05 Jul 2022 08:24:38 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 4 Jul 2022 07:01:06 -0700, Dylan Yudaken wrote:
> recvmsg has semantics that do not make it trivial to extend to
> multishot. Specifically it has user pointers and returns data in the
> original parameter. In order to make this API useful these will need to be
> somehow included with the provided buffers.
> 
> For now remove multishot for recvmsg as it is not useful.
> 
> [...]

Applied, thanks!

[1/1] io_uring: disable multishot recvmsg
      commit: abbbc92e2a398a6f8d50ed39f8a9efbd87edfdff

Best regards,
-- 
Jens Axboe


