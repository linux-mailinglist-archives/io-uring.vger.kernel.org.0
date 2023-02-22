Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6194669F6B4
	for <lists+io-uring@lfdr.de>; Wed, 22 Feb 2023 15:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbjBVOjV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Feb 2023 09:39:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbjBVOjU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Feb 2023 09:39:20 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E05837544;
        Wed, 22 Feb 2023 06:39:19 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id 6so7551409wrb.11;
        Wed, 22 Feb 2023 06:39:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PvupsfzCcOKXDRykNFlbD3M522JsoKtEmFaAw+ESIZ4=;
        b=kjEvxcRC92xwc7L6WYECbkxta2Ix9i8Ccqeo2j6WclYyqyqGOnOmAGeq5fFozV7/GA
         zjFFZf8Mn+2FHNLk7wvq8agSoXbjw0XLLp/fHEqmgLCYXbY/KworMugVrnXT+y1x8zGn
         +k5FVGgjdT83dqVY9yFf1e2soQ5uMgWwFNFUS9lfejLuIQh7ok2/BwZjI1oesGZlpyKs
         U4hDz3rOTWp9NzsAb6xaRYXIlpQBajp0MaCYo1yXMXHQw592KfYkYD7q2j9tU6IVGKV3
         C8XBZvVXSs9xSwhrACo0XNVBbASbSld+Xoaldlp7TAOYSqV8daMnKO78611VDsw0q2ga
         /big==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PvupsfzCcOKXDRykNFlbD3M522JsoKtEmFaAw+ESIZ4=;
        b=6bFoaIiVBI8Qrwy5jxJtqB76UwiUSP5VqgYxtt+cqPwU1Q5QO8XYykkh89t/XKraCx
         pbti8QygJWjMKwYZb+h3XrmLbihzP7PsffNd8EmKTNml8JNHv35GfTd+bVDr4ynYE/1a
         qacvab0dBLuFMt4KymN3HLt7BbgageS2SkWQ8OU8wCTw2ebssyVS55ms/z07qXUXx/oB
         BeOybzlhVqRrfP3tLTL/7gkOWFyntWbvm6Yg6axq9BFRCpIz4J9IyCN6C3Hs4pOBJI7/
         16X4iDVvQGZMAgpVaji1z9HwjKjN5qNEWeHFbEWBWZ/QB/0X4Aco4qh0VeEJGTty5bXn
         dPQQ==
X-Gm-Message-State: AO0yUKXX8NKjXdClANq3TApbydFdamEg6pRcYnJ4w4rhVKpy3mv9HuOn
        2iMgXnmfUl7fdYKf5T6p6dICwHGW9H8=
X-Google-Smtp-Source: AK7set99govZ0ojdmAK14T61Q3W/ygyD/Bw9jtguWJZIasm4lcoV1YJ28LmxxupjOe9cn6ofITqyjw==
X-Received: by 2002:adf:dcc5:0:b0:2c7:ce2:6479 with SMTP id x5-20020adfdcc5000000b002c70ce26479mr1780754wrm.40.1677076757339;
        Wed, 22 Feb 2023 06:39:17 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.95.64.threembb.co.uk. [94.196.95.64])
        by smtp.gmail.com with ESMTPSA id o2-20020a5d4742000000b002c59c6abc10sm8151735wrs.115.2023.02.22.06.39.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 06:39:17 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH for-next 1/4] io_uring/rsrc: disallow multi-source reg buffers
Date:   Wed, 22 Feb 2023 14:36:48 +0000
Message-Id: <e2549add4d412bbf443c9200f11d72051a0d910f.1677041932.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1677041932.git.asml.silence@gmail.com>
References: <cover.1677041932.git.asml.silence@gmail.com>
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

If two or more mappings go back to back to each other they can be passed
into io_uring to be registered as a single registered buffer. That would
even work if mappings came from different sources, e.g. it's possible to
mix in this way anon pages and pages from shmem or hugetlb. That is not
a problem but it'd rather be less prone if we forbid such mixing.

Cc: <stable@vger.kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index a59fc02de598..8d7eb1548a04 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1162,14 +1162,17 @@ struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages)
 	pret = pin_user_pages(ubuf, nr_pages, FOLL_WRITE | FOLL_LONGTERM,
 			      pages, vmas);
 	if (pret == nr_pages) {
+		struct file *file = vmas[0]->vm_file;
+
 		/* don't support file backed memory */
 		for (i = 0; i < nr_pages; i++) {
-			struct vm_area_struct *vma = vmas[i];
-
-			if (vma_is_shmem(vma))
+			if (vmas[i]->vm_file != file) {
+				ret = -EINVAL;
+				break;
+			}
+			if (!file)
 				continue;
-			if (vma->vm_file &&
-			    !is_file_hugepages(vma->vm_file)) {
+			if (!vma_is_shmem(vmas[i]) && !is_file_hugepages(file)) {
 				ret = -EOPNOTSUPP;
 				break;
 			}
-- 
2.39.1

