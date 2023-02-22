Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5E269F6B3
	for <lists+io-uring@lfdr.de>; Wed, 22 Feb 2023 15:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbjBVOjU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Feb 2023 09:39:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbjBVOjT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Feb 2023 09:39:19 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EBD43402C;
        Wed, 22 Feb 2023 06:39:18 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id l25so7556079wrb.3;
        Wed, 22 Feb 2023 06:39:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ksiQNwU5MPR0eC/6dsPn91M/fVbV2DunahjetFw8SMY=;
        b=SKFV58rhlTF9pv025VM4dZ30e2c1VbXy7lfxTHtAl2MNbX/9zj4IdNslZd05NpxoOr
         qEc8eitFx5SKlbbk3eMNY2AVYN9Qu9kNTqVdEunhyGlJkcCumaS3ei/tWSZNXq3AlZm/
         8bFI5WTVfgOxIs3fo+wDD/T9raCTMSl0OP8OeaEHZYpeH3zZv2c3gxrF40bqmXH1K+am
         Nqd5QyY0YkpTDyrgpyq9Sdtpcm22X959Bex9uVYE91Ge/EJ1uVHdkXKi07YEcJrnb2rR
         oA6e2/UqPeI7ZH9wNxnZO1BqJ8n60UJa6Ko53Ovrx2AjtFZKnfjXEWubnr5drEDfVKll
         zjzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ksiQNwU5MPR0eC/6dsPn91M/fVbV2DunahjetFw8SMY=;
        b=k9GQwqdsLY0BLQvNE+oETeqlWNa8dEiFle17raVMA5WUfyFUF9FTXyzOptPd4tePVg
         sTy+NFj8A9iXURP53nNy2wHqKx0smwEzEDBhRk/fzEmcFGrQBn30WOFDL/B+pkrI+SjC
         8l0cCRNkCSDpUeiQv/bS5dOOvGbYLxX0E85sTnTVabQrxNWkYhzQhi6vEAEutPQSCX0R
         VPiCT6Z1tGHE2vr8eIzxUcKZ0Bhj6VoXqGAZ292Fb/BpoTAoriIWZCvJzJHY4TmHLQrS
         q2VR2kGC3gIh3059MtXjsH+kS0WGmDIFU0DqZ3gyKy272t7iJzBkrhdf6b+9DMBYjg9B
         hiQw==
X-Gm-Message-State: AO0yUKVuBGlObjbGNAoxKO2gAPHxA+yBr24whrAndLNdF6q+Hwy7uKV8
        jSCc3RqIvfU6emvPBMN7kaJEA+TyDf0=
X-Google-Smtp-Source: AK7set9R8NBzLCQenyTTYszkkaWuuxRjxNtX9YJl6XEv1B2r6q5n2md6Vhc8hWUi5EZ3JPeKUAx3bw==
X-Received: by 2002:adf:dfd0:0:b0:2bf:f735:1310 with SMTP id q16-20020adfdfd0000000b002bff7351310mr7246502wrn.2.1677076756473;
        Wed, 22 Feb 2023 06:39:16 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.95.64.threembb.co.uk. [94.196.95.64])
        by smtp.gmail.com with ESMTPSA id o2-20020a5d4742000000b002c59c6abc10sm8151735wrs.115.2023.02.22.06.39.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 06:39:16 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH for-next 0/4] io_uring: registered huge buffer optimisations
Date:   Wed, 22 Feb 2023 14:36:47 +0000
Message-Id: <cover.1677041932.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Improve support for registered buffers consisting of huge pages by
keeping them as a single element bvec instead of chunking them into
4K pages. It improves performance quite a bit cutting CPU cycles on
dma-mapping and promoting a more efficient use of hardware.

With a custom fio/t/io_uring 64K reads benchmark with multiple Optanes
I've got 671 -> 736 KIOPS improvement (~10%).

Pavel Begunkov (4):
  io_uring/rsrc: disallow multi-source reg buffers
  io_uring/rsrc: fix a comment in io_import_fixed()
  io_uring/rsrc: optimise single entry advance
  io_uring/rsrc: optimise registered huge pages

 io_uring/rsrc.c | 58 ++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 45 insertions(+), 13 deletions(-)

-- 
2.39.1

