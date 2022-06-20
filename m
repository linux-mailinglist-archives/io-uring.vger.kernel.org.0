Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFF6551925
	for <lists+io-uring@lfdr.de>; Mon, 20 Jun 2022 14:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242791AbiFTMl5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Jun 2022 08:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242766AbiFTMl4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Jun 2022 08:41:56 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C5B13F55
        for <io-uring@vger.kernel.org>; Mon, 20 Jun 2022 05:41:54 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id l4so10174086pgh.13
        for <io-uring@vger.kernel.org>; Mon, 20 Jun 2022 05:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=MACFbkT580tUAKqrYyKYCYEd5Jk0tYNuL/XjHto2UFk=;
        b=59vMPSC7G3SRodp5Z0aC3G841yhG/KXj7UyvAFxde910JOIH/wpEUgUOc4w4dfHAm2
         TrYvZErzUpwz099QgyRfyXlm4+qyrHuRWAnpcCg5Yar/Ux+6R3cziSrbtxU8BmIunQgI
         ZsRwn2hZHoz8Vy8iGjndK7mVopvf85VzEHYbidbk/tWvSEkI+msR/1YiXDpknjoMxXpa
         piAyE7sV1Dls6MxbqXdUMz5olkZFhjsVUbRBuqLc3HnuQjHpizb7C0pyQT7QKauaDo5H
         3BhkIUlQ//idOAWXnX96PedJECXL56xt/8w9RlYjEJccn5hVU3ZMV6DmgFBYRQxZzGM1
         wj9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=MACFbkT580tUAKqrYyKYCYEd5Jk0tYNuL/XjHto2UFk=;
        b=zLtkkOngq+BB6cAKea14yNmX0nSaDHwt/JO9eMAW31AtqI2Vv+j3NnBZ2+QPHLfj+v
         5pKf6KAuxyAkJ+aDackZ/N/Kwcmwsvs8NL3YhdvvMO6mLQgC1uQ7zh9jAcfDGG2RuzK5
         towA1luob5D4rnVCoSjqJdZfwb69UUn0T5ldybEJ5MLsDDaJPBzvn5IAzmUQ9GM8jmZc
         rGip0dmIZ0649ecwsX/YXFk5n/aSm1coKUlBGypMSBwKp97PYMUFBWb5MYmyOlepytuY
         jbzuyvuBNebZj+eLVzEH/sf9VaT74xOThF2W4efZh0/yIMxSYpUW+X1qmMsi029gDUeU
         xEoA==
X-Gm-Message-State: AJIora85e7/GQIgRms2hWo1t5g6zcrP5/YZEja/AO/JL3i+0cvOM+gL2
        34b35SimdxXFyZ0nWaFXhBfQac6zAv/L2g==
X-Google-Smtp-Source: AGRyM1vPBD9MJfYe/Q844A1Qf/S5sr/2RROW+tF9kvwB/aMqVnV0sdyTrYaXXfBZf2aip467KaVkIg==
X-Received: by 2002:a05:6a00:1805:b0:51c:3a7:54dc with SMTP id y5-20020a056a00180500b0051c03a754dcmr24406769pfa.15.1655728913847;
        Mon, 20 Jun 2022 05:41:53 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id o2-20020a637e42000000b003fe4836abdasm8981837pgn.1.2022.06.20.05.41.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jun 2022 05:41:53 -0700 (PDT)
Message-ID: <82c8a718-cf1d-d40f-f501-34e3f384d77b@kernel.dk>
Date:   Mon, 20 Jun 2022 06:41:52 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: mark reissue requests with REQ_F_PARTIAL_IO
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

If we mark for reissue, we assume that the buffer will remain stable.
Hence if are using a provided buffer, we need to ensure that we stick
with it for the duration of that request.

This only affects block devices that use provided buffers, as those are
the only ones that get marked with REQ_F_REISSUE.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d3ee4fc532fa..87c65a358678 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3437,7 +3437,7 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 	if (unlikely(res != req->cqe.res)) {
 		if ((res == -EAGAIN || res == -EOPNOTSUPP) &&
 		    io_rw_should_reissue(req)) {
-			req->flags |= REQ_F_REISSUE;
+			req->flags |= REQ_F_REISSUE | REQ_F_PARTIAL_IO;
 			return true;
 		}
 		req_set_fail(req);
@@ -3487,7 +3487,7 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res)
 		kiocb_end_write(req);
 	if (unlikely(res != req->cqe.res)) {
 		if (res == -EAGAIN && io_rw_should_reissue(req)) {
-			req->flags |= REQ_F_REISSUE;
+			req->flags |= REQ_F_REISSUE | REQ_F_PARTIAL_IO;
 			return;
 		}
 		req->cqe.res = res;

-- 
Jens Axboe

