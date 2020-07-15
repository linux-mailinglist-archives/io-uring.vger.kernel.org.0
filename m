Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 428DB220928
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2020 11:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730846AbgGOJsz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jul 2020 05:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730824AbgGOJsy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jul 2020 05:48:54 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F7B5C061755
        for <io-uring@vger.kernel.org>; Wed, 15 Jul 2020 02:48:54 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id b15so1126256edy.7
        for <io-uring@vger.kernel.org>; Wed, 15 Jul 2020 02:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=G//ZNk9Ks0UW6XkdRmQRsymk/LSiVO7ak/jFTLjHaY0=;
        b=EJirLhsP8YNm8x49d93ieA1Xl4G3hca8kKMtw03x8k5+mV8N2izOQiL8e5JIfKYjvi
         AzWDnrOhRsHSO8rEwSPeZ3OZR+3JvMOdqwErrZbHZXrIgPu2zW9VoETvgmEHkViikGPP
         LMVR6Rsz1E1fx9SA3ffSXvEHkBl8S2KKPJczg5PxEVDuIiUkB7o6PUaQj6jgy3aGy6ep
         NMY9PVWlYQNfNfNzBmXUQHWuOd5Phbxm8YUImwL+ZnF7RNG815oJ/otc3P5Vh6PkwlOf
         dCWWB+58WJPk4Y2l3EpuvMiJQ8QdaAXLxHlwUH6XXtkRy0ZXi0HKDR25p8fZyDPGfyLS
         VrwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G//ZNk9Ks0UW6XkdRmQRsymk/LSiVO7ak/jFTLjHaY0=;
        b=T2ZmA3N6vXgxFTX78mktbz5UFIsIpupEyj51guCykh1t1hLfJdA2/eySUW9bbXBQko
         nhUxo3VRgLCRAVBeIOymUM1+6TbnKRqLrFCs5ov7qnu/pCWA6aUXygdqd//L3UPthF3y
         sNzGo7z8FLshDTyS3AWAIQiXHwc672+HG6StEYXwBhacTAq7y2ZkUx+OY5CNbBY1Q7r1
         kh28E9N4IJ1fL7jNtiUyXIPiihYCIC2Cf6LWVdZsenxwSo7LyH+BbUSgvaYHxS9a8FBJ
         MsIPbXQ6MhvLii4cHlGF+qZ3PfrbZSmy4CguDYjcklEhQGdWMDfFPBaDfC8jpzk3BTYr
         Tv3w==
X-Gm-Message-State: AOAM532/Ir5p2xcbFASc3wOyO93uvVssBT0LOSwXZomc7gfgh+iFvsja
        5SRQUMInn0Tltn3satTPU5KFU+w/
X-Google-Smtp-Source: ABdhPJzKr3cXgP7vx4GFc5jSAAp/B+Sz/2yLdddjQrqaZwierkgu6JHwFNwehWzyVCMW/RI0MqnPSA==
X-Received: by 2002:a05:6402:304a:: with SMTP id bu10mr8540634edb.70.1594806533008;
        Wed, 15 Jul 2020 02:48:53 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id d13sm1635690edv.12.2020.07.15.02.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 02:48:52 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/4] io_uring: remove empty cleanup of OP_OPEN* reqs
Date:   Wed, 15 Jul 2020 12:46:50 +0300
Message-Id: <d977a8b0d7533e76b669a554fca24c51ef13f8c2.1594806332.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594806332.git.asml.silence@gmail.com>
References: <cover.1594806332.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A switch in __io_clean_op() doesn't have default, it's pointless to list
opcodes that doesn't do any cleanup. Remove IORING_OP_OPEN* from there.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 149a1c37665e..a3157028c591 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5453,9 +5453,6 @@ static void __io_clean_op(struct io_kiocb *req)
 		if (req->flags & REQ_F_BUFFER_SELECTED)
 			kfree(req->sr_msg.kbuf);
 		break;
-	case IORING_OP_OPENAT:
-	case IORING_OP_OPENAT2:
-		break;
 	case IORING_OP_SPLICE:
 	case IORING_OP_TEE:
 		io_put_file(req, req->splice.file_in,
-- 
2.24.0

