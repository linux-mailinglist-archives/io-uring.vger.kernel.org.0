Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 970CF776404
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 17:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234527AbjHIPhm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 11:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234533AbjHIPhZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 11:37:25 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6823B35A4
        for <io-uring@vger.kernel.org>; Wed,  9 Aug 2023 08:36:52 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1bb91c20602so36495ad.0
        for <io-uring@vger.kernel.org>; Wed, 09 Aug 2023 08:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691595411; x=1692200211;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xZmvLqSc1ZMqwRzEtiOyZYHzr51FwH1sV1e8XSQpWg4=;
        b=dQM9QbRO+gu/f0S0uELWRWVR1GhNH5RzUAhHmnqb4dQr2h68BbeQbGNuKSO4pbYwa/
         Cw5IWAGT652HfaPz3s/DlKnH7cD7i1uxvYqTMAlHqTV5HayE2Bb/qLCtgvuQpV3GsMpB
         PlTI/k5N6tcU/MM8DYsofH2e/nlx8AvO9RUiLWZ1ifX2vz19CgJ5XyRwKER0V4UrUgAx
         2VIcZZhiYJFRVT46j0UVtnO1dVfE1aUThDtDQm+TcMp/eD+dqO9micWin3hoS7Xva6zM
         mtSZrYb+KYChgikg17YqaPZA3ZQ4osbhv4HbRvWkMwCksem1xN8ZErcOQuKgaP/WAjM+
         Zm7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691595411; x=1692200211;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xZmvLqSc1ZMqwRzEtiOyZYHzr51FwH1sV1e8XSQpWg4=;
        b=LLTow9wBhUY0yrDM3TmNqWw1pWcwRhMjmOJhC88jnWWJm21NHN8lDuk/h1j5RporKr
         TD3JrdiiCZXhSXQ7Fwb9vjHYs9FHCXh5TEwth6LNE18lpxHngoR5uSZdpgGIOniyFCyG
         +BYBwxZYKAgbGUagZPnQ6UE/qpMlw+mIeWohhpCBPRaSXLp4mZGEHxzdWAKuQUEYoppo
         tqO9WlXfv4D91xAPz9DMN6uEjIycPGAgnxSbJW4OBsuih+n2OWEBMtS+GRvdzkSB7BDO
         LOyHLW6W/yDjuFTXA588rUrRGqqbrCaz4Axa/+Z2OcVqKtEnjBzf6wFSKnU9sfL/O+BB
         NsJg==
X-Gm-Message-State: AOJu0YyT+OlaSel8kRPC9w9VfLGaP7hLn4mgqru+70irsiYzmX+J7K3q
        S0DgkhXyHSIqjKCOXdv99d+1HpKZux73lIIdSio=
X-Google-Smtp-Source: AGHT+IE4qpX1WxiVWqvRGf6XVQ7QhVuw1vh+PGULHU2OjgAH4RLjdH1PyMVIv70WLuHGBf83u5Qmog==
X-Received: by 2002:a17:902:c941:b0:1b8:9fc4:2733 with SMTP id i1-20020a170902c94100b001b89fc42733mr3823094pla.3.1691595411399;
        Wed, 09 Aug 2023 08:36:51 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id m1-20020a170902d18100b001b9d7c8f44dsm11403977plb.182.2023.08.09.08.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 08:36:50 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <66096d54651b1a60534bb2023f2947f09f50ef73.1691538547.git.asml.silence@gmail.com>
References: <66096d54651b1a60534bb2023f2947f09f50ef73.1691538547.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: fix drain stalls by invalid SQE
Message-Id: <169159541042.37442.15459865071355763105.b4-ty@kernel.dk>
Date:   Wed, 09 Aug 2023 09:36:50 -0600
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


On Wed, 09 Aug 2023 13:21:41 +0100, Pavel Begunkov wrote:
> cq_extra is protected by ->completion_lock, which io_get_sqe() misses.
> The bug is harmless as it doesn't happen in real life, requires invalid
> SQ index array and racing with submission, and only messes up the
> userspace, i.e. stall requests execution but will be cleaned up on
> ring destruction.
> 
> 
> [...]

Applied, thanks!

[1/1] io_uring: fix drain stalls by invalid SQE
      commit: 5e7d637400a25141e330c3c3b0a73440d58e194d

Best regards,
-- 
Jens Axboe



