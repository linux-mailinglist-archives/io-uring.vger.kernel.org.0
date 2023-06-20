Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BED673709C
	for <lists+io-uring@lfdr.de>; Tue, 20 Jun 2023 17:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbjFTPhA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Jun 2023 11:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232030AbjFTPg7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Jun 2023 11:36:59 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E7B6A6
        for <io-uring@vger.kernel.org>; Tue, 20 Jun 2023 08:36:57 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id ca18e2360f4ac-77dcff76e35so56360139f.1
        for <io-uring@vger.kernel.org>; Tue, 20 Jun 2023 08:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687275416; x=1689867416;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WkJ04svJmJ8pxzbIDuGNECwuq0g1ybawL1RA2w0s7ho=;
        b=L6KFE89e7+zgirjCUZWW36UIgrZ5LNw74uFBxzLF4m9bbDI24visjfPzaLIRFrEqNf
         MC6XzGIZZ4TI5t7wrCsljqXHJGV/iaQxiYswl2yOSWSIHUS4WQuSRRlv8TA84WgbWAQP
         2oANx9hZ5EicAKuOBF7NbQHxr9HYmEQg/UkClsXWK+ONmjvxGd9ps6+W98U3AACzhwo/
         l/+tbf1MhG+fE3pE/Ac28IUBPOU4RuM+bB7n7LA+cA6pcugio71a/E+0ttY7v1ImDSxS
         zl/2jcRyfZ5kOv8WN3v0s8CkLJfYG+DOWSEf9rpwl1CQeCvc1e2m2OgbeZEv9BmBgo5m
         PYSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687275416; x=1689867416;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WkJ04svJmJ8pxzbIDuGNECwuq0g1ybawL1RA2w0s7ho=;
        b=UuKJxt2R+3KPfj199myKp9IB7XiHgKuYOVdCGaz8R9uxx5Ig4+WsynAh1AKc8u9THs
         X90nrNM7kBf6KCl7884cRdMdBKj636fuJAe7ZZN5WyzqpwH7FxwEN6XmyQQNRRj4VoCr
         L8xGkTLJcuxujRZ3EAUUWFqf1rpnZwnuZst15ALdimfSAav+cbvE4HlyUF9Uj7LcnzZH
         W/SHwv8HRILOjpEePwRjhZcAE7LvAGnh1y3Zjl+S4ox9HZXz4iewKk39/8BD7DJ2dn8k
         13KOt5EPo5qV9juVkvU8guFXnQHvFSInhi5TiaZGYSH0bLYEDKFnA81GE0D0U+n/zQKb
         3ziw==
X-Gm-Message-State: AC+VfDxC8EnJEruimeEA7ts4ptqDWlAR++0c/tNxfuLPUDyYTMV9bpit
        /nZaMXMh0/KLaJK8jMesNUrb1wRH5UuZi2Hi6KU=
X-Google-Smtp-Source: ACHHUZ6E2+IPKqBgYjxavevRje0PDwum0fvMcHa5DWgwSlN6eHtoIUelTC16mhPmxgJ7ueZWPUmz9A==
X-Received: by 2002:a6b:c9c1:0:b0:77d:c323:b52 with SMTP id z184-20020a6bc9c1000000b0077dc3230b52mr9793672iof.2.1687275416531;
        Tue, 20 Jun 2023 08:36:56 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id k15-20020a02a70f000000b0041672c963b3sm712894jam.50.2023.06.20.08.36.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 08:36:56 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
In-Reply-To: <20230620113235.920399-1-hch@lst.de>
References: <20230620113235.920399-1-hch@lst.de>
Subject: Re: io_uring req flags cleanups
Message-Id: <168727541583.3665205.11063729024991422548.b4-ty@kernel.dk>
Date:   Tue, 20 Jun 2023 09:36:55 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-c6835
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Tue, 20 Jun 2023 13:32:27 +0200, Christoph Hellwig wrote:
> while looking at the NOWAIT flag handling I found various bits of code
> related to it pretty convoluted and confusing.  This series tries to
> clean them up, let me know what you think.
> 
> Diffstat:
>  cancel.c    |    5 +----
>  filetable.c |   11 ++++-------
>  filetable.h |   28 +++++++++++++++++-----------
>  io_uring.c  |   41 ++++++++++-------------------------------
>  io_uring.h  |    5 -----
>  msg_ring.c  |    4 +---
>  rsrc.c      |    8 ++++----
>  rw.c        |    4 ++--
>  8 files changed, 39 insertions(+), 67 deletions(-)
> 
> [...]

Applied, thanks!

[1/8] io_uring: remove __io_file_supports_nowait
      commit: b9a6c9459a5aec7bfd9b763554d15148367f1806
[2/8] io_uring: remove the mode variable in io_file_get_flags
      commit: 53cfd5cea7f36bac7f3d45de4fea77e0c8d57aee
[3/8] io_uring: remove a confusing comment above io_file_get_flags
      commit: b57c7cd1c17616ae9db5614525ba703f384afd05
[4/8] io_uring: remove io_req_ffs_set
      commit: 3beed235d1a1d0a4ab093ab67ea6b2841e9d4fa2
[5/8] io_uring: return REQ_F_ flags from io_file_get_flags
      commit: 8487f083c6ff6e02b2ec14f22ef2b0079a1b6425
[6/8] io_uring: use io_file_from_index in __io_sync_cancel
      commit: 60a666f097a8d722a3907925d21e363add289c8c
[7/8] io_uring: use io_file_from_index in io_msg_grab_file
      commit: f432c8c8c12b84c5465b1ffddb6feb7d6b19c1ca
[8/8] io_uring: add helpers to decode the fixed file file_ptr
      commit: 4bfb0c9af832a182a54e549123a634e0070c8d4f

Best regards,
-- 
Jens Axboe



