Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1386704C90
	for <lists+io-uring@lfdr.de>; Tue, 16 May 2023 13:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233027AbjEPLmt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 May 2023 07:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232415AbjEPLms (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 May 2023 07:42:48 -0400
Received: from mail-vk1-xa2a.google.com (mail-vk1-xa2a.google.com [IPv6:2607:f8b0:4864:20::a2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2FF14C34;
        Tue, 16 May 2023 04:42:46 -0700 (PDT)
Received: by mail-vk1-xa2a.google.com with SMTP id 71dfb90a1353d-4501ac903d6so7577656e0c.1;
        Tue, 16 May 2023 04:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684237366; x=1686829366;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KVawbQRzJyzIOZpz7W6tsAHPXn8J+K2I2Vy2kuKD+TY=;
        b=GE+1XfGpRhmsxgdP9CBWijSHCOfxDy+doCCPTlEKkqVSE4W7e7ym5oHwAm0T6+TULn
         K5jRZLV7LOArn+gRtVVmdJWK2YL9k3XEclQRTezVCI2efKXmF9NIWdXTjgKW8x7hXwBq
         DQHUPDq+dqRMMhc7WzHqV9kr4RNzn0b8YHcnUceeaN6XLg+O/q8/1kTKfh7SKjFzJV0l
         lsp0QrhezU1FNPHoCydO8vrKir1LbISk2SGyZ59fNUNtAySYrM3NCqKIvwv+z6bYO59U
         1THPcm9pMKgjzcJadSpbFwR55/xvACyfVS874ZtDShqA3avbmusDCGaV5U/CDzUglI8i
         1zKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684237366; x=1686829366;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KVawbQRzJyzIOZpz7W6tsAHPXn8J+K2I2Vy2kuKD+TY=;
        b=CCjcl5bqDhGdDS3l4hNkmXZClxzRN1pYvu0rDd9fyybHW6O1XwTh09KOTnQmVyNSlw
         cJAj0nOtllzESDbMv3VcqCssFQyWT6gLrrOhLSSJ1SBK1F6Z+LIPOO+gkxjdYS3Aq+sV
         fBPEAYMTGs2SLSczTNMobWDDZ4mn4vevd9N05XyDzmX3zk3mVyX4xVTQAKv7ow7wH30F
         ehQ14EvkKd2hkEOUtJBhtCx4KWUYqbWNyzql68OPSqXiUBITym76a2psd02d2ZsAzj9N
         RAzWyAIwSr8WPh4PUmQQSMmsxHc5tTZmMoWVYYoKv3DYYQwnQ2D10pn/e8pRBNRB3eLg
         Aalw==
X-Gm-Message-State: AC+VfDzfUA47UatQdqdWlQigilnDeMZlbdmA7CP63HxmMbxhl40JxOWa
        l7s3ja6nxAD4J6hK88njtM1UW2FMRs5yg4ph2w==
X-Google-Smtp-Source: ACHHUZ5kGng/vXSFDLNoSG/RfpGoOQuOl75CpGICyD3XF5aV6Lo94+7eB9YCkzKQYcog+GOpakZ5PSHUdlxMbtIng6Y=
X-Received: by 2002:a1f:54c1:0:b0:456:5823:92c1 with SMTP id
 i184-20020a1f54c1000000b00456582392c1mr3304272vkb.9.1684237365669; Tue, 16
 May 2023 04:42:45 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1684154817.git.asml.silence@gmail.com>
In-Reply-To: <cover.1684154817.git.asml.silence@gmail.com>
From:   Anuj gupta <anuj1072538@gmail.com>
Date:   Tue, 16 May 2023 17:12:08 +0530
Message-ID: <CACzX3Av9yOkAK16QRJ7npQUVAiTjA-nqLR2Doob9p6nYYYkyOg@mail.gmail.com>
Subject: Re: [PATCH for-next 0/2] Enable IOU_F_TWQ_LAZY_WAKE for passthrough
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, axboe@kernel.dk, kbusch@kernel.org,
        hch@lst.de, sagi@grimberg.me, joshi.k@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, May 15, 2023 at 6:29=E2=80=AFPM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> Let cmds to use IOU_F_TWQ_LAZY_WAKE and enable it for nvme passthrough.
>
> The result should be same as in test to the original IOU_F_TWQ_LAZY_WAKE =
[1]
> patchset, but for a quick test I took fio/t/io_uring with 4 threads each
> reading their own drive and all pinned to the same CPU to make it CPU
> bound and got +10% throughput improvement.
>
> [1] https://lore.kernel.org/all/cover.1680782016.git.asml.silence@gmail.c=
om/
>
> Pavel Begunkov (2):
>   io_uring/cmd: add cmd lazy tw wake helper
>   nvme: optimise io_uring passthrough completion
>
>  drivers/nvme/host/ioctl.c |  4 ++--
>  include/linux/io_uring.h  | 18 ++++++++++++++++--
>  io_uring/uring_cmd.c      | 16 ++++++++++++----
>  3 files changed, 30 insertions(+), 8 deletions(-)
>
>
> base-commit: 9a48d604672220545d209e9996c2a1edbb5637f6
> --
> 2.40.0
>

I tried to run a few workloads on my setup with your patches applied. Howev=
er, I
couldn't see any difference in io passthrough performance. I might have mis=
sed
something. Can you share the workload that you ran which gave you the perf
improvement. Here is the workload that I ran -

Without your patches applied -

# taskset -c 0 t/io_uring -r4 -b512 -d64 -c16 -s16 -p0 -F1 -B1 -P0 -O0
-u1 -n1 /dev/ng0n1
submitter=3D0, tid=3D2049, file=3D/dev/ng0n1, node=3D-1
polled=3D0, fixedbufs=3D1/0, register_files=3D1, buffered=3D1, QD=3D64
Engine=3Dio_uring, sq_ring=3D64, cq_ring=3D64
IOPS=3D2.83M, BW=3D1382MiB/s, IOS/call=3D16/15
IOPS=3D2.82M, BW=3D1379MiB/s, IOS/call=3D16/16
IOPS=3D2.84M, BW=3D1388MiB/s, IOS/call=3D16/15
Exiting on timeout
Maximum IOPS=3D2.84M

# taskset -c 0,3 t/io_uring -r4 -b512 -d64 -c16 -s16 -p0 -F1 -B1 -P0
-O0 -u1 -n2 /dev/ng0n1 /dev/ng1n1
submitter=3D0, tid=3D2046, file=3D/dev/ng0n1, node=3D-1
submitter=3D1, tid=3D2047, file=3D/dev/ng1n1, node=3D-1
polled=3D0, fixedbufs=3D1/0, register_files=3D1, buffered=3D1, QD=3D64
Engine=3Dio_uring, sq_ring=3D64, cq_ring=3D64
IOPS=3D5.72M, BW=3D2.79GiB/s, IOS/call=3D16/15
IOPS=3D5.71M, BW=3D2.79GiB/s, IOS/call=3D16/16
IOPS=3D5.70M, BW=3D2.78GiB/s, IOS/call=3D16/15
Exiting on timeout Maximum IOPS=3D5.72M

With your patches applied -

# taskset -c 0 t/io_uring -r4 -b512 -d64 -c16 -s16 -p0 -F1 -B1 -P0 -O0
-u1 -n1 /dev/ng0n1
submitter=3D0, tid=3D2032, file=3D/dev/ng0n1, node=3D-1
polled=3D0, fixedbufs=3D1/0, register_files=3D1, buffered=3D1, QD=3D64
Engine=3Dio_uring, sq_ring=3D64, cq_ring=3D64
IOPS=3D2.83M, BW=3D1381MiB/s, IOS/call=3D16/15
IOPS=3D2.83M, BW=3D1379MiB/s, IOS/call=3D16/15
IOPS=3D2.83M, BW=3D1383MiB/s, IOS/call=3D15/15
Exiting on timeout Maximum IOPS=3D2.83M

# taskset -c 0,3 t/io_uring -r4 -b512 -d64 -c16 -s16 -p0 -F1 -B1 -P0
-O0 -u1 -n2 /dev/ng0n1 /dev/ng1n1
submitter=3D1, tid=3D2037, file=3D/dev/ng1n1, node=3D-1
submitter=3D0, tid=3D2036, file=3D/dev/ng0n1, node=3D-1
polled=3D0, fixedbufs=3D1/0, register_files=3D1, buffered=3D1, QD=3D64
Engine=3Dio_uring, sq_ring=3D64, cq_ring=3D64
IOPS=3D5.64M, BW=3D2.75GiB/s, IOS/call=3D15/15
IOPS=3D5.62M, BW=3D2.75GiB/s, IOS/call=3D16/16
IOPS=3D5.62M, BW=3D2.74GiB/s, IOS/call=3D16/16
Exiting on timeout Maximum IOPS=3D5.64M

--
Anuj Gupta
