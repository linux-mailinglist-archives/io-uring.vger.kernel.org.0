Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2D972CFE3
	for <lists+io-uring@lfdr.de>; Mon, 12 Jun 2023 21:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjFLT4e (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Jun 2023 15:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbjFLT4b (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Jun 2023 15:56:31 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0D9102
        for <io-uring@vger.kernel.org>; Mon, 12 Jun 2023 12:56:30 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id ca18e2360f4ac-7747cc8bea0so39432839f.1
        for <io-uring@vger.kernel.org>; Mon, 12 Jun 2023 12:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1686599789; x=1689191789;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r9ofeHvqvAt6ShY55oFXmS+4m8FlIbTOy+uS+/xJl7E=;
        b=XgCoNy0eO2koQDx8zhHoFRk3HC9C8URPs39CipKnvYYSoySg8gvZ97I3+qizzJFdIs
         fQLz0c+KDG74QMw176Pj4ef9awpMdFnZSyNJ68A1Kmx0epmtGCpkw5H1sV5LZTm3J443
         U9KQc7bZgRaDfuazLrp4qGFMJ9cKRJ5PJphSF1bd2qAY/vxChxMFzeFchis55vmKmTDM
         loGodc2ZJ23hzWS+oGgd2i7xolFZLph4sraTym8Pj4x71aw9JVbvCiIL4EMp+P+q6PMS
         8o7GjtJUafFra8PBxd35+U0aMImWPjCMJXlN4O/XrQKuINgnr1RDaKUCm2kUfBgshYe/
         54ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686599789; x=1689191789;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=r9ofeHvqvAt6ShY55oFXmS+4m8FlIbTOy+uS+/xJl7E=;
        b=O7WTwYmek8N8QsjHPc1HxKUXAEtPy27AeO7TmlZ8ODTdCDN7O6DC2+XUPXKj0Y6U0Q
         am4m4z0f8qoMD3P3DL2v3RWY/8j49wQ8CkNLF+IQxEt2084RpqXBTxu7C8+dySgFSs7u
         sDOF2tlt5cu8bIxoQNlHfuh5ZyDVftRcHxLGF0xywrKcuzcRDeHEIVrZuWq9HkIlyG21
         Pq5cAVhMMcCdQzhdUVG8Ot2x5fGbQv+Vq33i6ZJE8ebtj3jIxsM/CRliXxQWv/jBQUgp
         eyl/p/bqYJab/1xnhWUBAVdBHMw3C5efoKKden2fONOKtuEKjNALXIbliS43w/3KqI1m
         S0PQ==
X-Gm-Message-State: AC+VfDzuCbBv0dXy4E2W6dfAjoGYrXHEfA7d+QR+ZQYTVWGX1kwcyRhV
        BYWPzSnKKc3OD9CrEuT4Boe+wv11JdbSw0HQrYY=
X-Google-Smtp-Source: ACHHUZ4hZENqvHX6Y3KFejDSwHfY8TjG7pWH5/cE1QElektrLU5D0gxBRWbFZM3+allGWyAyCZCDcQ==
X-Received: by 2002:a6b:690a:0:b0:77a:ee79:652 with SMTP id e10-20020a6b690a000000b0077aee790652mr5019559ioc.1.1686599789344;
        Mon, 12 Jun 2023 12:56:29 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id o14-20020a02cc2e000000b0041f6957b290sm2941505jap.93.2023.06.12.12.56.28
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jun 2023 12:56:28 -0700 (PDT)
Message-ID: <0b0d4411-c8fd-4272-770b-e030af6919a0@kernel.dk>
Date:   Mon, 12 Jun 2023 13:56:27 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/net: save msghdr->msg_control for retries
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

If the application sets ->msg_control and we have to later retry this
command, or if it got queued with IOSQE_ASYNC to begin with, then we
need to retain the original msg_control value. This is due to the net
stack overwriting this field with an in-kernel pointer, to copy it
in. Hitting that path for the second time will now fail the copy from
user, as it's attempting to copy from a non-user address.

Link: https://github.com/axboe/liburing/issues/880
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/net.c b/io_uring/net.c
index 89e839013837..51b0f7fbb4f5 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -65,6 +65,7 @@ struct io_sr_msg {
 	u16				addr_len;
 	u16				buf_group;
 	void __user			*addr;
+	void __user			*msg_control;
 	/* used only for send zerocopy */
 	struct io_kiocb 		*notif;
 };
@@ -195,11 +196,15 @@ static int io_sendmsg_copy_hdr(struct io_kiocb *req,
 			       struct io_async_msghdr *iomsg)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
+	int ret;
 
 	iomsg->msg.msg_name = &iomsg->addr;
 	iomsg->free_iov = iomsg->fast_iov;
-	return sendmsg_copy_msghdr(&iomsg->msg, sr->umsg, sr->msg_flags,
+	ret = sendmsg_copy_msghdr(&iomsg->msg, sr->umsg, sr->msg_flags,
 					&iomsg->free_iov);
+	/* save msg_control as sys_sendmsg() overwrites it */
+	sr->msg_control = iomsg->msg.msg_control;
+	return ret;
 }
 
 int io_send_prep_async(struct io_kiocb *req)
@@ -297,6 +302,7 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (req_has_async_data(req)) {
 		kmsg = req->async_data;
+		kmsg->msg.msg_control = sr->msg_control;
 	} else {
 		ret = io_sendmsg_copy_hdr(req, &iomsg);
 		if (ret)

-- 
Jens Axboe

