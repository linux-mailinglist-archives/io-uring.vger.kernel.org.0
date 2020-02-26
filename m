Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFE6916F483
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2020 01:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729230AbgBZAvo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Feb 2020 19:51:44 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37007 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728865AbgBZAvn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Feb 2020 19:51:43 -0500
Received: by mail-pg1-f193.google.com with SMTP id z12so410252pgl.4
        for <io-uring@vger.kernel.org>; Tue, 25 Feb 2020 16:51:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=A0+GI7phXkJEYh030KpPANTYe+RaGXRbDobTeRN3yfo=;
        b=y89XNeV1tcG49mHbtY4fs5FggpcZ8sfY2S0XKvO2+CiFpSrleHkYCLD8udJmKNE05p
         qJSMdzHlmouBvgah43qNmJvl/bukNX72FEdNN210YeALRNBPYdV5NclS9s0ecBBs4M4P
         yexGTGc82KC/uxeDuOv+pWfbztHFaGd7cbVmsE5tETTwD+Hj+vrGYcAMDAnyHoO0F0lF
         pPLxEcRfJ9QzLdDWOs0Q3RT8u978T1foR12EvD/wUAgTKw6WfRRwmBlEQIZj/KBNzvW4
         CO+82n9JrB1dDgRNgR08Zck/FVGE7wKTCu4r6QCKZI5TpxUx5jKSESle52qBMviNIw+1
         046Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=A0+GI7phXkJEYh030KpPANTYe+RaGXRbDobTeRN3yfo=;
        b=JWPjb6NuAhzwkFqfukXRDzKMAi47qXzsfGpqarUKEmLJqiaNPTwOi56gRZAaEiF/DQ
         XDG8XE52kDEhxvHRGgUToBb+JiBZw0duTmMhxzs8tHP/XoME9dBcXRLf2zM9PrzXlPRV
         ykQpMkneFWMNUi9S0/geBvs5wpvt3A1YIdZ9eSu/K/kOGjiMYydlV7c6DVLW5fekuvuY
         qCIAXCw2qr3YMwc4T+RVjUGXY7sbTFE0lDaSbLoYOy6N/TZ+VgIFbKncFeiOMAL3Bij9
         pdzIK3Cn8SEnvLQtwMFr51dmAbHvqRTD1mP3PMvHQx+ESIRSMrkw4M7TkoVZabNU55eW
         1fbg==
X-Gm-Message-State: APjAAAW0IfS9GKJohN0Lz3IF24y9xy64PU3GqCSpnliGV0xsH4OneZtl
        xN/n3KWwu6mlbqkoCbdqkAlumWt0nW2NAA==
X-Google-Smtp-Source: APXvYqwRRYmmLUoQXciQoXtyDUoCf231s0YQk655wR378dhHSspnq62ZwuUq3F7ezyzbwfW8QotORw==
X-Received: by 2002:a63:24c6:: with SMTP id k189mr1132565pgk.436.1582678301099;
        Tue, 25 Feb 2020 16:51:41 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id 199sm282569pfu.71.2020.02.25.16.51.40
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 16:51:40 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: io_import_iovec() returns 0/-ERROR
Message-ID: <193b0a0e-65d0-e93d-72b4-d23c15da1304@kernel.dk>
Date:   Tue, 25 Feb 2020 17:51:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Unlike the other core import helpers, io_import_iovec() returns 0 on
success, not the length imported. This means that links that depend
on the result of non-vec based IORING_OP_{READ,WRITE} that were added
for 5.5 get errored when they should not be.

Fixes: 3a6820f2bb8a ("io_uring: add non-vectored read/write commands")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

--

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f79ca494bb56..36917c0101fd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2075,7 +2075,7 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 		ssize_t ret;
 		ret = import_single_range(rw, buf, sqe_len, *iovec, iter);
 		*iovec = NULL;
-		return ret;
+		return ret < 0 ? ret : sqe_len;
 	}
 
 	if (req->io) {

-- 
Jens Axboe

