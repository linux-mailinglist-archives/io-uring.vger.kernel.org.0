Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE37251F63
	for <lists+io-uring@lfdr.de>; Tue, 25 Aug 2020 20:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbgHYS6V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Aug 2020 14:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbgHYS6U (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Aug 2020 14:58:20 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB3DC061574
        for <io-uring@vger.kernel.org>; Tue, 25 Aug 2020 11:58:20 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id s1so13602226iot.10
        for <io-uring@vger.kernel.org>; Tue, 25 Aug 2020 11:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=u21fmpIk1c7+x/SiwSCalEdV2+Lbsym4rW4P0dLYDm8=;
        b=SOiSpXkA0GbnUdPgcVqfvAKAlrkOhOuILCZKLSA6pJcU6/Uu0O4zqkPIK1DWO39S8m
         VR6uI/d145ymCpp76OF9r+wy16fGuqrwThcASrks0Y/odhrs0qGH0gRgF/oaYd+IfsZ1
         dLJLPtiWrZDuxoajNjEUoV02YM7MYS2/502Z7cqxLSDMavlcXBt580ILSCgOKj1Y+3AZ
         bsPVnALtFmVtuWd+nWdVoogcslhKss4iIIs5rqxWzPtVYitKeNwppVQrAhRriffBByV7
         1EmPFtgnuqgAkfUOOwWhrPEzSPMgM24Tfmc74tLJCBFoJtlerHSuzQCLN5Y6WUGUnBvP
         8Skw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=u21fmpIk1c7+x/SiwSCalEdV2+Lbsym4rW4P0dLYDm8=;
        b=P8MegW/A2CL07mxAuEmonJTihi1u8YWk/Egc3e+rQsj6kXsw+KHIjCCqpFv7hVkpGB
         sAIf4ApY2kaEw0rAgVXzzIUooDQ9RG+frFyoso4JWWt4NUCu5M1Q4rfLItZOYDWyCnBH
         cjVb44SKyah3ccFb29G3WjfY/hpclNEw1l8euk+ysBwilU5V/Vub8kTZ2ogEboVsQ17G
         qtnlZPlUb509nNeSZpF9exdu1oMC2yC7wzVRu57JrzgsKKFD5T8c9vdUzRkF72JJ6n0l
         Mn2i+vcTMHlLkuPCXG4I+SWO+v2vmS3G70rHCmkbQKtAoD/7xDJTIPsVL33gzKkBYTjR
         Rakg==
X-Gm-Message-State: AOAM532H5/1huRDi3s2t4rgoZ7emkwxr3ljOHxUuEZ88sC2AdfjwJIvO
        ASL0g/VLgVCnFNYX81iH0++jxgx/M/ipzKCM
X-Google-Smtp-Source: ABdhPJzbH4gFkZRrwRWtzT+2oXJ8AwMCIUxBxOHW+h2tjuVf0m2ML0cFcZ+HEjgxfFtRPuUSZwkYMQ==
X-Received: by 2002:a5d:80cb:: with SMTP id h11mr10037482ior.189.1598381899413;
        Tue, 25 Aug 2020 11:58:19 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id q17sm9577896ilt.10.2020.08.25.11.58.18
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2020 11:58:18 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: don't use poll handler if file can't be nonblocking
 read/written
Message-ID: <37bd9905-4ba3-ba17-be88-315067e0af87@kernel.dk>
Date:   Tue, 25 Aug 2020 12:58:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There's no point in using the poll handler if we can't do a nonblocking
IO attempt of the operation, since we'll need to go async anyway. In
fact this is actively harmful, as reading from eg pipes won't return 0
to indicate EOF.

Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 384df86dfc69..d15139088e4c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4889,12 +4889,20 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 	struct async_poll *apoll;
 	struct io_poll_table ipt;
 	__poll_t mask, ret;
+	int rw;
 
 	if (!req->file || !file_can_poll(req->file))
 		return false;
 	if (req->flags & REQ_F_POLLED)
 		return false;
-	if (!def->pollin && !def->pollout)
+	if (def->pollin)
+		rw = READ;
+	else if (def->pollout)
+		rw = WRITE;
+	else
+		return false;
+	/* if we can't nonblock try, then no point in arming a poll handler */
+	if (!io_file_supports_async(req->file, rw))
 		return false;
 
 	apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);

-- 
Jens Axboe

