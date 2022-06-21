Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74C375533F9
	for <lists+io-uring@lfdr.de>; Tue, 21 Jun 2022 15:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349847AbiFUNsz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jun 2022 09:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350167AbiFUNsz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jun 2022 09:48:55 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5275F64F5
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 06:48:54 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id p128so14287154iof.1
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 06:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=00VvFG+iMbIce2dPJPN2x+StmKlCvFr6JgwZ1Swej8w=;
        b=lDDIxnQuAwTnQfhrIA+7F/gGrrMrA0avS2nSPZqzTl4dP6KgowQ32BCw+wd0fmUA1Y
         vWAkR4pWwhzW+LW/st+RubwcXIgYQgkvfW/AU7FY2OnX9ISbvFXKW10Ot8yaa9J6hyXU
         FjVG6WW7W3l5IW3BU21HYd3ORk3D6PgudGGQc5KmHUpDo07hebDaPVIIU0hN3QSCIRH2
         o+6ncIkOUb2nbE5IHqViaY1k2hPyJLA06kD8iSZj0iF95bVgxYIcgNcx676sYt67KDD/
         QYO6eFNUbHxgn781jxe7gahFc4eJOYD25OUF+SoF9CxDViXdgIgf9WAfD1etXxzJHhJE
         4YcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=00VvFG+iMbIce2dPJPN2x+StmKlCvFr6JgwZ1Swej8w=;
        b=RffBAaYLxwuj1ybtPcLsVbgEoYeqbERCgSKwRa0zO0NeW8k11lmOmL74TTkn5mZ4H9
         lR1lk8gzw4WQ+XTymSQPoFAH/JWMJtqDDvU2yMmeq/Gm2rRzPJaXUx5elclyRAgUTTpq
         oJbEp7k2MJxJM93VX07Z193sGGMxFzcRQVBq/3cj8Ud53k9084yYA0hhTEtYIvSwluLA
         CTiPa8x+jGV7TWRRHpA4qVp7y17U0ghx7MEOItP2VMRp4d9sAt0sGu3dkQaU8uieNwok
         amygHjY2Eq2k56XJeVXPbaEVuMrCNhp3CPd6rAhq+SThuMhk9ZYwhdRfJO4sZknruPfb
         fR2A==
X-Gm-Message-State: AJIora8eIHpGjC2oh5QP1I5Mo/xJ9dbba4O70MNK/Op6uXZ6qtZ8hh+k
        OIAywTkjeed2961BL6GtNOVA/N1NP4T1Fw==
X-Google-Smtp-Source: AGRyM1urmBaqg20lammmsre3B+Gnhl8DQdsm/vRWhstSeJgtJFTZyLAVh3kKXBdvLIRp3fN/z48BBg==
X-Received: by 2002:a05:6638:150e:b0:339:ce13:80d with SMTP id b14-20020a056638150e00b00339ce13080dmr1125960jat.205.1655819333439;
        Tue, 21 Jun 2022 06:48:53 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id w20-20020a029694000000b003317549aa4bsm7184450jai.71.2022.06.21.06.48.52
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jun 2022 06:48:52 -0700 (PDT)
Message-ID: <422b9cd3-f831-a019-2b87-a46d0ceb1ec0@kernel.dk>
Date:   Tue, 21 Jun 2022 07:48:51 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: fix merge error in checking send/recv addr2 flags
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

With the dropping of the IOPOLL checking in the per-opcode handlers,
we inadvertently left two checks in the recv/recvmsg and send/sendmsg
prep handlers for the same thing, and one of them includes addr2 which
holds the flags for these opcodes.

Fix it up and kill the redundant checks.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 87c65a358678..05508fe92b9c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6077,8 +6077,6 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (unlikely(sqe->file_index))
 		return -EINVAL;
-	if (unlikely(sqe->addr2 || sqe->file_index))
-		return -EINVAL;
 
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
@@ -6315,8 +6313,6 @@ static int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (unlikely(sqe->file_index))
 		return -EINVAL;
-	if (unlikely(sqe->addr2 || sqe->file_index))
-		return -EINVAL;
 
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);

-- 
Jens Axboe

