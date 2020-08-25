Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C6E251F6D
	for <lists+io-uring@lfdr.de>; Tue, 25 Aug 2020 21:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbgHYTBX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Aug 2020 15:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbgHYTBV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Aug 2020 15:01:21 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5923C061574
        for <io-uring@vger.kernel.org>; Tue, 25 Aug 2020 12:01:21 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id h4so13623723ioe.5
        for <io-uring@vger.kernel.org>; Tue, 25 Aug 2020 12:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Z3wZ2/ihIZOSd39u9FD/Ndf1BjScSVkdkXSzNnMP2x4=;
        b=X1eC9ITNIg6lEk47cjEj2Qlym9GIauVQyd//lGDJMFbeWHUXn5ELCkRA086CRAK42a
         X0+BffQE0v38CJtm44toV1GTs8J34NTGcY6O4C5Vm2BdFMonBofkNdW2ZkK9Jnjd1TEJ
         CHU7+z4n/PzDj68/FdyIfvqRlgWb9kl8Xuxh4yGOs8Ugi1YbJK6YdCeQOiGnXE2KMib+
         OhMgWZxq9n4ewA902cWGISt+0AtuRXX/JyuCBeKG3CdUVlTjuOqUYJcXLy4cuExX8Co3
         36rI6IFsSkDJ/BQRb7ocm9yaFIezKEnfDAYZvcLBAYbUbeYWcRuyu3/2vL+/AHoC7ZHE
         6rlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Z3wZ2/ihIZOSd39u9FD/Ndf1BjScSVkdkXSzNnMP2x4=;
        b=pQHNtajjR/kVAT03VQOCoXAcpcB5977on71kMo7u8XyKiWSBC5lPRrc1EKhuZivC1y
         VR0QltFDInZcHk58I/A981CWxjhvGyR5Kbmd+onC9s4Ppqlw026vtsGFwUEU0FvWn/KY
         fJNnCA6gFPID0zGLBg57sw0yCDKs7QrhtO5QtgoP/u9pbE4j3pcgkGKJV+Lf6Mjgr10j
         oYh9peThqEj7HTP9w63Ve2AkmYu47U4jeRXyiV6w5UsJhIZ0MP96MB7DKoR7mn/H4y6J
         HzHBoAKgDRVoFlfa1lnkgnEGeBenm9wiSWx1KywGeGk8wj3OhRCI328oPiAFwOjFDVhG
         YHVA==
X-Gm-Message-State: AOAM5312VSmMa4IotkBB3bvKvlze4XhvoWA/oYqAacKeaWHTi2wmPe4Q
        P8DqjEAFLQvYkkULCnEVkRqilDr5mwGsiJvW
X-Google-Smtp-Source: ABdhPJziZpjLpTnO4ewyhSPIw4vqhjEEq6Zx+a1hw/fMsMkN30ThPqG6LXIieaFoosyDAqcNt80YAg==
X-Received: by 2002:a02:82c3:: with SMTP id u3mr11711908jag.81.1598382080789;
        Tue, 25 Aug 2020 12:01:20 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id e23sm8859973iot.28.2020.08.25.12.01.20
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2020 12:01:20 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: ensure read requests go through -ERESTART*
 transformation
Message-ID: <e80b5947-ccfb-4aa6-aabe-21b6bae8480b@kernel.dk>
Date:   Tue, 25 Aug 2020 13:01:18 -0600
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

We need to call kiocb_done() for any ret < 0 to ensure that we always
get the proper -ERESTARTSYS (and friends) transformation done.

At some point this should be tied into general error handling, so we
can get rid of the various (mostly network) related commands that check
and perform this substitution.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d15139088e4c..d9b88644d5e8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3160,7 +3160,8 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 			goto out_free;
 		return -EAGAIN;
 	} else if (ret < 0) {
-		goto out_free;
+		/* make sure -ERESTARTSYS -> -EINTR is done */
+		goto done;
 	}
 
 	/* read it all, or we did blocking attempt. no retry. */
-- 
Jens Axboe

