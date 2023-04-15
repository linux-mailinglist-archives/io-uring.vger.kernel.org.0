Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64A666E33A2
	for <lists+io-uring@lfdr.de>; Sat, 15 Apr 2023 22:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbjDOUqo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Apr 2023 16:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbjDOUqn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Apr 2023 16:46:43 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD5DE77
        for <io-uring@vger.kernel.org>; Sat, 15 Apr 2023 13:46:42 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id d75a77b69052e-3e69924e0bdso13005051cf.1
        for <io-uring@vger.kernel.org>; Sat, 15 Apr 2023 13:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1681591601; x=1684183601;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XbC5zuntweD6WLh93ZLmw5gmLJik5+JvFlAkV2rYC5U=;
        b=GV36tOFVLYeJlEZa7QHMZT9vAR6foNvzLfYy0+rxPkYc0v0gkbQ3SgNGfTLZad2P7v
         8eYoZNDX/7L+yA9Y9+hfkO/A06U8iaE5+L/DKv+RDZ1cWccKYK3PBFKnrbAVMl0Haxlq
         E02HvKpzMmM4lvxq7wwkiuWC85zRWl/rGOwJ6uRKlp1HlRdZdc2/+NvOVDXWPqtgm+wv
         sBgTPdTV8f1gtcx8jE7sL7k7qYp6JbqZ59RSPsxBRUxdB3R+rAMd/scavTivV0CJ9G6/
         jTD0JlaGqIDSv9T881eJTOgzFIn1K9GSw4nivCfDtu1epcGLmW9sJQQCQ7Bw4NaNReIq
         Pi9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681591601; x=1684183601;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XbC5zuntweD6WLh93ZLmw5gmLJik5+JvFlAkV2rYC5U=;
        b=BpfHWh4rNU780FbxDFzTbwEFNU1cR8Y8wpVHquLVwBvzwav7qHOc0B6b9IOG1+2V+G
         uiB0zo6WYsKj2plv0r0XfKozyEAaHpVi1FXTj0Ygc7DG0gzjqOh82gl+h0SDyqYAlNuP
         PiE7cpdhC8jGtKCHwLiOEPhDyILOWZnLrb1dq9wCB4YT5zYG36KrxMl2NBtld3LzBOem
         SP+njFC9OX/Pi9Cg9FliyvRFM8qoYF1jJgBjQGejEyNMsBf0hnvVTcOopnZP0RSZoAYY
         tw2ucQ7GRxZIQJn2FDeVQOTDLme7sAdlk95oTJnZfcXPOOlCWSpkykPh1HlhRR1Wsn3r
         k87A==
X-Gm-Message-State: AAQBX9eznvbQpZ+tq4goJbROha3Rwctw+6RQAnMbkG9qOlfXb6WuuPwm
        a7RBgNawWpgUjjeYAHwlrFatQ12FvxAwyh/DIIc=
X-Google-Smtp-Source: AKy350YiNQYQpB0dWRhgskyfwdPAhPjmM2nTdxhxnnOQfCd4JCMza2aR/ivjFLGCFZY1xDpNjtAEig==
X-Received: by 2002:a05:6214:4109:b0:5ac:325c:a28f with SMTP id kc9-20020a056214410900b005ac325ca28fmr9951200qvb.0.1681591601377;
        Sat, 15 Apr 2023 13:46:41 -0700 (PDT)
Received: from [127.0.0.1] ([216.250.210.6])
        by smtp.gmail.com with ESMTPSA id z11-20020a0cfecb000000b005ef5e68b4a0sm946550qvs.90.2023.04.15.13.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Apr 2023 13:46:40 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1681395792.git.asml.silence@gmail.com>
References: <cover.1681395792.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-6.4 00/10] some rsrc fixes and clean ups
Message-Id: <168159159917.11964.3223508176398249499.b4-ty@kernel.dk>
Date:   Sat, 15 Apr 2023 14:46:39 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-00303
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Thu, 13 Apr 2023 15:28:04 +0100, Pavel Begunkov wrote:
> Patch 1 is a simple fix for using indexes w/o array_index_nospec()
> protection.
> 
> Patches 2-5 are fixing a file / buffer table unregistration issue
> when the ring is configured with DEFER_TASKRUN.
> 
> The rest are clean ups on top.
> 
> [...]

Applied, thanks!

[01/10] io_uring/rsrc: use nospec'ed indexes
        commit: 953c37e066f05a3dca2d74643574b8dfe8a83983
[02/10] io_uring/rsrc: remove io_rsrc_node::done
        commit: c732ea242d565c8281c4b017929fc62a246d81b9
[03/10] io_uring/rsrc: refactor io_rsrc_ref_quiesce
        commit: eef81fcaa61e1bc6b7735be65f41bbf1a8efd133
[04/10] io_uring/rsrc: use wq for quiescing
        commit: 4ea15b56f0810f0d8795d475db1bb74b3a7c1b2f
[05/10] io_uring/rsrc: fix DEFER_TASKRUN rsrc quiesce
        commit: 7d481e0356334eb2de254414769b4bed4b2a8827
[06/10] io_uring/rsrc: remove rsrc_data refs
        commit: 0b222eeb6514ba6c3457b667fa4f3645032e1fc9
[07/10] io_uring/rsrc: inline switch_start fast path
        commit: 2f2af35f8e5a1ed552ed02e47277d50092a2b9f6
[08/10] io_uring/rsrc: clean up __io_sqe_buffers_update()
        commit: 9a57fffedc0ee078418a7793ab29cd3864205340
[09/10] io_uring/rsrc: simplify single file node switching
        commit: c87fd583f3b5ef770af33893394ea37c7a10b5b8
[10/10] io_uring/rsrc: refactor io_queue_rsrc_removal
        commit: c899a5d7d0eca054546b63e95c94b1e609516f84

Best regards,
-- 
Jens Axboe



