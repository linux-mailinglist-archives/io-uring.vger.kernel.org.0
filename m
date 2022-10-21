Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E21E607807
	for <lists+io-uring@lfdr.de>; Fri, 21 Oct 2022 15:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbiJUNOp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Oct 2022 09:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbiJUNN1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Oct 2022 09:13:27 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE47426D92B
        for <io-uring@vger.kernel.org>; Fri, 21 Oct 2022 06:13:10 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id bp11so4462944wrb.9
        for <io-uring@vger.kernel.org>; Fri, 21 Oct 2022 06:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jUAXv1LdZ9pWxJhUJt3wJBd5ntX+l5BKmhILqEYKZpU=;
        b=XFzw4RgLbQp2MBCBGarorlJ4ZwOZvBkxt0enuMGflHeazGksi+OUWUay7AWFGNGO0y
         /fLA82eNNdvwp7VjH6I312Eao0yaZYM5Zs2+tMoX9OiTOaNLo8mrK4jMqA+/qoqd4vuK
         MbaXNZ67+iiI0h1Vn1YV0qeBAHHhEvxESvHcrzlweu61nyqZZUq9Af8rdvONYhkV8JLB
         Bq9vTd3t3BGNFeFJeARhNdStV/kVuyN3EKUEiBCchWUG3AZuZJguntPgpI6FW9bDmfT7
         jMSUHuJCN241KCWOGKaUqT49AvkzByWcFVV/AOjYfL+cVrk7LLKamwUw06hLTsQ7fh2x
         ezFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jUAXv1LdZ9pWxJhUJt3wJBd5ntX+l5BKmhILqEYKZpU=;
        b=20MR21EU7IX9dT7TVTs0lOBOKCJa5mvZGlhQ48EHtQiOMKe0sczdmVIkSO3XyPYt1u
         rBo1DIHqtkDVupU4DAZjFcHxa2DmYX7GgfcRaJdU+d39lH7YlN/Yx+tYpKIv6oAWgrah
         xOP7/ryPggwzagWt0EmFZs8KUXcEo6ehslDnGmML3n1+74rT+hkNaGbrykKpM1yWFr8M
         yea5o/mmFoLkIQqkPsEcWV95XhMQqcgsCfFNp02M1gKWs9TUZJ7nphxIBXl5yow6+b8g
         Eu8zQNFlHw2kzHMbDUQ3y6hoIqHG6WPow5MY7lPpgPkSx/CB8WR0AFWgXqxPgQq3XExu
         olMQ==
X-Gm-Message-State: ACrzQf0tizahmkDwjNd+F+IKm62Pwhfuf8B5+yZcvfqat0XAFBW5NAlg
        kYTGRXrYatadw6z9KZJkW/fbdDxq7jk=
X-Google-Smtp-Source: AMsMyM4hBci2wJvwzBesN2epQXnFWqX5E9paOKIUoebCaP/GU1ZW/oxP1S5tE2LSjUu30DHEN7xVWw==
X-Received: by 2002:adf:dd88:0:b0:236:57e3:fc86 with SMTP id x8-20020adfdd88000000b0023657e3fc86mr1052385wrl.493.1666357987794;
        Fri, 21 Oct 2022 06:13:07 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:f27e])
        by smtp.gmail.com with ESMTPSA id n4-20020adf8b04000000b00231893bfdc7sm20739442wra.2.2022.10.21.06.13.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 06:13:07 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 1/3] io_uring_enter.2: add sendzc -EOPNOTSUPP note
Date:   Fri, 21 Oct 2022 14:10:58 +0100
Message-Id: <dfe582705c8c3458f14c6d7f0db9a8bbd371f749.1666357688.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1666357688.git.asml.silence@gmail.com>
References: <cover.1666357688.git.asml.silence@gmail.com>
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

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 man/io_uring_enter.2 | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
index 2ebc6e3..25fdc1e 100644
--- a/man/io_uring_enter.2
+++ b/man/io_uring_enter.2
@@ -1098,8 +1098,11 @@ Available since 5.19.
 Issue the zerocopy equivalent of a
 .BR send(2)
 system call. Similar to IORING_OP_SEND, but tries to avoid making intermediate
-copies of data. Zerocopy execution is not guaranteed and it may fall back to
-copying.
+copies of data. Zerocopy execution is not guaranteed and may fall back to
+copying. The request may also fail with
+.B -EOPNOTSUPP,
+for instance when a protocol doesn't support zerocopy in the first place, in
+which case users are recommended to use copying sends instead.
 
 The
 .I flags
-- 
2.38.0

