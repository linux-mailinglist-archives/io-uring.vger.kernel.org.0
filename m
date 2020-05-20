Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 449411DA88C
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2020 05:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgETDXz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 May 2020 23:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbgETDXz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 May 2020 23:23:55 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 892E8C061A0E
        for <io-uring@vger.kernel.org>; Tue, 19 May 2020 20:23:55 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id 5so623179pjd.0
        for <io-uring@vger.kernel.org>; Tue, 19 May 2020 20:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=gnDYES07uSENBODB8wTkIipxmdU4MjDoJtE/1/BMewQ=;
        b=lNSeC3UzM6szWz+CFhQ6gtzQaKbZbWnybRjwyLjgff0ERK+ODbF8Bct9wlAgXXtq8A
         65UxsLNx8m8IkWWUogTG/M6cPNHwkCKPX9VPxYybXReSfo+g1wdMSJ+oStDczEM4xMAI
         MS5HZLR4y2z0YRZJIjggYc1ehzY6FzrqDLhF/Fa18O/zf/PWu5lsTJXT/cBM7/d/7ZbI
         qzJMtJQua3nq8COWqwR6t/5JL8svY2ZpYpSz9fR/pvwjo+uNWvrVAVWk8vnJ+2mevRbt
         0NF2oGF072z+1vSt61bp4wPYcnPprVwrgiqzuGqauIIEOs2oaVPzHpXiI4W5Xw20vCMs
         jZlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=gnDYES07uSENBODB8wTkIipxmdU4MjDoJtE/1/BMewQ=;
        b=m/fPVotZbOGky9pEao6nk4EaXbIunYdC4XwCoTv28udkXL0SzZiN5nsRG2K0Hz/weW
         aApubjx4RiQ69Uvlgjo0OyvWCHfKn7Ne5rvOk+P5zyTTRyt1k2B6EMC4Yy8u2yJnru4P
         XNeJCR+N6aWcoSroZ1EGmTV/8pEGdg3B9ryKQ0C8OeCX4gI41keugrudn9w8MysezpzJ
         OlapaUBl5a7WbD2440cjCyuQks3VUIoS3z2hlzl4T4VMNg4nphzvXX09VHxq/LCyFtPp
         mrRDKqKVJr846xN+nqhGKwR44fcpaOsq0jQKqV3RsHRe5s2gfG+QA/mBJifFkmfExurF
         u/sA==
X-Gm-Message-State: AOAM532O72n5IeZj3ps7Sx6hYg3RPSQwwhzEWZHgdFGokoInQrNZ2MAh
        Z2odQdNPRRvqfampNq4kenXE1xm9Yas=
X-Google-Smtp-Source: ABdhPJymtMumftkIz1aRSpedZLxZqasZgEnsOTECFBkc6msDZtBiuRLN/AhwUK66ZNBhxNwFl4HQkA==
X-Received: by 2002:a17:90a:272b:: with SMTP id o40mr2906022pje.64.1589945034679;
        Tue, 19 May 2020 20:23:54 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:14f4:acbd:a5d0:25ca? ([2605:e000:100e:8c61:14f4:acbd:a5d0:25ca])
        by smtp.gmail.com with ESMTPSA id b29sm731315pff.176.2020.05.19.20.23.53
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2020 20:23:53 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: don't add non-IO requests to iopoll pending list
Message-ID: <04df6eba-a433-9aad-cca9-7e76b986652f@kernel.dk>
Date:   Tue, 19 May 2020 21:23:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We normally disable any commands that aren't specifically poll commands
for a ring that is setup for polling, but we do allow buffer provide and
remove commands to support buffer selection for polled IO. Once a
request is issued, we add it to the poll list to poll for completion. But
we should not do that for non-IO commands, as those request complete
inline immediately and aren't pollable. If we do, we can leave requests
on the iopoll list after they are freed.

Fixes: ddf0322db79c ("io_uring: add IORING_OP_PROVIDE_BUFFERS")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d43f7e98e07a..f9f79ac5ac7b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5306,7 +5306,8 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (ret)
 		return ret;
 
-	if (ctx->flags & IORING_SETUP_IOPOLL) {
+	/* If the op doesn't have a file, we're not polling for it */
+	if ((ctx->flags & IORING_SETUP_IOPOLL) && req->file) {
 		const bool in_async = io_wq_current_is_worker();
 
 		if (req->result == -EAGAIN)
-- 
2.26.2

-- 
Jens Axboe

