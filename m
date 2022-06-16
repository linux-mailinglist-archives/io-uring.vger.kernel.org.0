Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0D8D54E1BC
	for <lists+io-uring@lfdr.de>; Thu, 16 Jun 2022 15:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbiFPNSi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jun 2022 09:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233400AbiFPNSe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jun 2022 09:18:34 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F225A424B2
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 06:18:32 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id e9so1399879pju.5
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 06:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=/m20LVEN11NoAiHfEyHKT/uqmna9uj9Xqyx6iPI33u8=;
        b=tqsIB/L1axMP0vrVlK+0ceVFJnkcOBnqPU5Mo/2ZktCOKmtmU8U/ub+cpGYol8oxFp
         gfMZThKUUfEGcsLGwOX2vF433KgGhxiFVBSJOOiMv/EWyEJFEHpMx2rUr3uovUoqvvwc
         CwxRVWtviVRdGOh6eLtH0pUWF3sOU1xNadKxrf6kqQmojWk/5JhaRb91CYIdb6zYv6Zo
         ci8Nk5rYePA4VgvLiTSeWqZGUuM4QwRX3U55p7WaAXp3tqLUjF7Ly92fWZQ4t1ZGxQ9N
         ldf++pkHGPbK+G9B27Tn/uGYUzi+OqfXmW2SD3Y3+M4Pd8a4xVJEffSRGc1hFXiP4W7U
         ZoYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=/m20LVEN11NoAiHfEyHKT/uqmna9uj9Xqyx6iPI33u8=;
        b=diswi3Nv4mSNO4i6hYQe9tAFJr2OH7ydNKro3v7NYbiiwYRUoVejww/5upoYDWGFH0
         b/uc6bm6nC1dD9pGaq37w6i29RFoGxJZBzcjiv6AIhhSLA8otl724y5zNSOrad9H2Zwu
         WpWHYiKSMaSIYCS81sAAKYtEGy+FsC7Lfu+XlcZGN5LevsDxKjb3BO2gl6NJ14pp02Pb
         lF8buVvqLEpvIqw6dw9dT/iUDHt+ykm6cZz12tkratuBhoYccjPvSgQ6EFVDJR4ZbLAx
         J8PyA58JtSiFCr5wUwTMwDgUn52WtiqEVbLyRJBq9QvFKi8MR5u+ewvvDcJ7GV34d9tn
         zpUw==
X-Gm-Message-State: AJIora/6dcn3rkdF5P9ITv2uRnkKA0vgxmkVRbR95tPg5iw2ExdjvpSd
        S942JJuR5ISrd6V2v7fk3kqUasgS/GV4ig==
X-Google-Smtp-Source: AGRyM1tFnF+0+MkDjeEr+kIlv3Gc8s7d2b8vC7jArYbjpvkY14rQPS4UmC+VepKzlhNo1ISEJR48HA==
X-Received: by 2002:a17:90b:3845:b0:1e2:e175:be04 with SMTP id nl5-20020a17090b384500b001e2e175be04mr5094402pjb.50.1655385512183;
        Thu, 16 Jun 2022 06:18:32 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id fu13-20020a17090ad18d00b001cb6527ca39sm3804960pjb.0.2022.06.16.06.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 06:18:31 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, asml.silence@gmail.com
In-Reply-To: <cover.1655371007.git.asml.silence@gmail.com>
References: <cover.1655371007.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-next v3 00/16] 5.20 cleanups and poll optimisations
Message-Id: <165538551152.1334545.12393141471563842275.b4-ty@kernel.dk>
Date:   Thu, 16 Jun 2022 07:18:31 -0600
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

On Thu, 16 Jun 2022 10:21:56 +0100, Pavel Begunkov wrote:
> 1-4 kills REQ_F_COMPLETE_INLINE as we're out of bits.
> 
> Patch 5 from Hao should remove some overhead from poll requests
> 
> Patch 6 from Hao adds per-bucket spinlocks, and 16-19 do a little
> bit of cleanup. The downside of per-bucket spinlocks is that it adds
> additional spinlock/unlock pair in the poll request completion side,
> which shouldn't matter much with 20/25.
> 
> [...]

Applied, thanks!

[01/16] io_uring: rw: delegate sync completions to core io_uring
        commit: 45bfddb605aebe5298b054553ac8daa04bd73c67
[02/16] io_uring: kill REQ_F_COMPLETE_INLINE
        commit: c2399c806444c54c8414f2196e43ea22843e51a5
[03/16] io_uring: refactor io_req_task_complete()
        commit: a74ba63b8d9ed12fc06d6e122a94ebb53e8ae126
[04/16] io_uring: don't inline io_put_kbuf
        commit: 8fffc6537fb8d7e4e8901b0ca982396999c89c09
[05/16] io_uring: poll: remove unnecessary req->ref set
        commit: 0e769a4667807d1bb249b4bcd9cc6ac6cbdea3ab
[06/16] io_uring: switch cancel_hash to use per entry spinlock
        commit: 6c41fff4b73e393107a867c3259a7ce38e3d7137
[07/16] io_uring: pass poll_find lock back
        commit: 4488b60bf5d73e69c6e17f6296f71ab19f290fae
[08/16] io_uring: clean up io_try_cancel
        commit: 034c5701e192e9521dae1a60c295a3dea8bd9f07
[09/16] io_uring: limit the number of cancellation buckets
        commit: 8a0089110740eb78bb6592b12b73c15096cc5b41
[10/16] io_uring: clean up io_ring_ctx_alloc
        commit: 8797b59e7bd7463775690a0ee0de4c2121e39a90
[11/16] io_uring: use state completion infra for poll reqs
        commit: 60ad0a221eb26eb7c3babb000c9fe05f5f3f9231
[12/16] io_uring: add IORING_SETUP_SINGLE_ISSUER
        commit: d2fbea05a52db51e1939fe3f99fdc5086ff093c4
[13/16] io_uring: pass hash table into poll_find
        commit: fbd91877aac264a470b666fbd88a8a31d202993e
[14/16] io_uring: introduce a struct for hash table
        commit: 1aa9e1ce9887505ea87aa86128c1e0960e85e9dd
[15/16] io_uring: propagate locking state to poll cancel
        commit: 3f301363931da831687160817f4b31fad89b50de
[16/16] io_uring: mutex locked poll hashing
        commit: 154d61b44e7eee3b5db68d65d9cb7403c9f58e71

Best regards,
-- 
Jens Axboe


