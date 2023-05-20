Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 420F670A475
	for <lists+io-uring@lfdr.de>; Sat, 20 May 2023 03:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbjETB53 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 May 2023 21:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbjETB52 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 May 2023 21:57:28 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2841E46
        for <io-uring@vger.kernel.org>; Fri, 19 May 2023 18:57:27 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-64d132c6014so655340b3a.0
        for <io-uring@vger.kernel.org>; Fri, 19 May 2023 18:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1684547847; x=1687139847;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3eBKLivqlTqSr0tiqEicbxYBtC/XTmQzmRYHW+8S1NA=;
        b=w+Y1FW4UxTky/ZiOPKWdydjlUVpMfIVwIRm/mBfGE4N1tqf8wrLDzTthV9iRjkYEu5
         bn+/zK8caYixp35jHZ0PMcGlT3i5HwJ4hnW+MCM1yBIUYEQvTJk1tEIiqe9p/VF2+8qc
         1MRil/o96dSW6vfyG+idmEajul8T2zUvT33ssCdxQV58TLiAnnoNiKU9Ez4EjRAr3nxb
         KLZs8N6FoWJpik3PNNmVYAbRZ75PNbEN/Fqlt+4T+YSMv9CU9A7NJDP7syKxvUh131ww
         wEqxhCLL2NsSK0FNa2YAbMfsPaN+fb2di/VuvZeYLhteyGePJdPNqYilZDtjm6U8ZNUH
         Unaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684547847; x=1687139847;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3eBKLivqlTqSr0tiqEicbxYBtC/XTmQzmRYHW+8S1NA=;
        b=Tf49YqJ/DYotdejGEcLoA0Qp2K+S4MB3kxKjIJ4CuzWLdZNuJZFYSQaHhH40RsFeRB
         2G4Ihukg2zWfvtg5DL/5UZl9cFN1kdoP7U5wI9WLqCroXc0oaOmnJ88P+juMjps3cyAs
         dkqrgJgNiJQNBXkfn3D7czUxM7yNGUdD5ufo4ocNf5eiHHn5SOW9+G83DWYKTsGNZyNS
         1Erp4OyoXab2jSadox2Wo/oqbPz3/NC5h0lXgt6FKLZfFjJL9P4INy7HRnv64LTQhOwB
         0wsgK5pyBn9iHd847o/bd4Smu0vdEXrVghnTs8ZmZHhS3dkBY985KjlqIXgJdfqh+WAi
         NIEA==
X-Gm-Message-State: AC+VfDy8TNsRKyka0OpoJ1WVKmkaFyjDFtHAbFrvhi5AOwcGCPKfIjto
        HPnCoUQlEMPlIvvJBvXgUxklWUsRrqgav3QkoQ4=
X-Google-Smtp-Source: ACHHUZ4xKgarNbf6hiUwQFJf/nfeGoWaKstPIc2I0MsQg6Uhy/ih2tqnOoHyokkAwkQru/0L2tCKRw==
X-Received: by 2002:a05:6a21:999f:b0:dc:e387:566b with SMTP id ve31-20020a056a21999f00b000dce387566bmr3982548pzb.1.1684547847598;
        Fri, 19 May 2023 18:57:27 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t30-20020a63225e000000b0051afa49e07asm348421pgm.50.2023.05.19.18.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 18:57:26 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc:     syzbot+cb265db2f3f3468ef436@syzkaller.appspotmail.com
In-Reply-To: <4de3685e185832a92a572df2be2c735d2e21a83d.1684506056.git.asml.silence@gmail.com>
References: <4de3685e185832a92a572df2be2c735d2e21a83d.1684506056.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: annotate offset timeout races
Message-Id: <168454784628.383343.6563891362415203381.b4-ty@kernel.dk>
Date:   Fri, 19 May 2023 19:57:26 -0600
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


On Fri, 19 May 2023 15:21:16 +0100, Pavel Begunkov wrote:
> It's racy to read ->cached_cq_tail without taking proper measures
> (usually grabbing ->completion_lock) as timeout requests with CQE
> offsets do, however they have never had a good semantics for from
> when they start counting. Annotate racy reads with data_race().
> 
> 

Applied, thanks!

[1/1] io_uring: annotate offset timeout races
      commit: 5498bf28d8f2bd63a46ad40f4427518615fb793f

Best regards,
-- 
Jens Axboe



