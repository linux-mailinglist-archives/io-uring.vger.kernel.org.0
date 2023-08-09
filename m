Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0E46776405
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 17:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbjHIPhn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 11:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234534AbjHIPhZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 11:37:25 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0419B35AE
        for <io-uring@vger.kernel.org>; Wed,  9 Aug 2023 08:36:53 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1bbadf9ed37so19775ad.0
        for <io-uring@vger.kernel.org>; Wed, 09 Aug 2023 08:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691595412; x=1692200212;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UceQ9ayfOb6JnYQUyjPbXC6LoDmUFmEEnehW1JnSFlQ=;
        b=j4gwqJm/mDY9iKMLpKJnIfj2EOZ1wASfvR8pLcN9V1R+xsNSr9+KOQgCX1VqlrZ4n+
         oxrj2doIGKIbyKqyIzwJLI94GGXsnkNmJah52NmRkjkJfcPirphgRYCkap2a10u4AeMQ
         3akJwt/038Wk0PHKUCR+f0AQ5CyQDAZlS2P4L8Il8kua7FcARKNqcxMUMeFAzSru5f2B
         Wzri6eErNZ/5EaqXheJb4Ecr2cbO8DF9dEV0vhcddZH09njAB3c40hGKPdaZOj78BYZf
         f7Nrkef7olhv78StX42oEvBqU+W4VYsQSIz8gx3kB7zXSWVf52vem2Q8HFOxtD1DE3Xm
         1vSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691595412; x=1692200212;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UceQ9ayfOb6JnYQUyjPbXC6LoDmUFmEEnehW1JnSFlQ=;
        b=GBl0e5l3bPFrGcqbxVrxxT/XVumR0BQgekax2Yw+IClQrcr8MKznko74qWwRZLr1AX
         CEm9lRIvmAyHxsEDgQBiymtFLS/xBbNrC41xbRfz2dRBmJ4fBbvQlCOiJbstOopB+tAR
         9aR5ZwsezAsuNTbkOLlg7l1TMATIWc/LfEgyU40ygL5PrXKLH5ua8S9QeE3Flbc19EWv
         deNHpQFK+Uwkj0e0Wqzh35Xft6EfXT3XvEW/piUXwGipNJYHh+kzHWDHVknrki8jYXD2
         0sh/88wd+Tg7W1IO12YU8NaqUTSSFcFOJvR2d4g3bCe4EErdS/1UPUBmZLaVZ8TXYUQF
         cBYA==
X-Gm-Message-State: AOJu0YwlvWdgFtIuAlTRjmZ4kWPSGj02+hCtAyKWgYvOXxsG2jVjiJy5
        C73cfAUDqzrp4Iwe/tMHwzG7sqrL8Wb3P/CKesQ=
X-Google-Smtp-Source: AGHT+IFLV9V51SZursphvq7oNq59auw7PUqJq/R4PaCvUPUX7be6BBAXR7UI3CokonTiJG5oqFZOKA==
X-Received: by 2002:a17:902:d503:b0:1b8:95fc:cfe with SMTP id b3-20020a170902d50300b001b895fc0cfemr3730494plg.3.1691595412209;
        Wed, 09 Aug 2023 08:36:52 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id m1-20020a170902d18100b001b9d7c8f44dsm11403977plb.182.2023.08.09.08.36.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 08:36:51 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <c6fbf7a82a341e66a0007c76eefd9d57f2d3ba51.1691541473.git.asml.silence@gmail.com>
References: <c6fbf7a82a341e66a0007c76eefd9d57f2d3ba51.1691541473.git.asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: fix false positive KASAN warnings
Message-Id: <169159541153.37442.8185245478193724357.b4-ty@kernel.dk>
Date:   Wed, 09 Aug 2023 09:36:51 -0600
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


On Wed, 09 Aug 2023 13:22:16 +0100, Pavel Begunkov wrote:
> io_req_local_work_add() peeks into the work list, which can be executed
> in the meanwhile. It's completely fine without KASAN as we're in an RCU
> read section and it's SLAB_TYPESAFE_BY_RCU. With KASAN though it may
> trigger a false positive warning because internal io_uring caches are
> sanitised.
> 
> Remove sanitisation from the io_uring request cache for now.
> 
> [...]

Applied, thanks!

[1/1] io_uring: fix false positive KASAN warnings
      commit: e0b94f7b1ec218f73f9a1e3db4ff77a5fde27203

Best regards,
-- 
Jens Axboe



