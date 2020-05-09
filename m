Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 057711CC289
	for <lists+io-uring@lfdr.de>; Sat,  9 May 2020 18:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgEIQIV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 9 May 2020 12:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727989AbgEIQIU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 9 May 2020 12:08:20 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F81C061A0C;
        Sat,  9 May 2020 09:08:20 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id 50so4962289wrc.11;
        Sat, 09 May 2020 09:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:references:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YuRYksjlF5ENbyJsTQR4HoHAxvMGAxkl1acTB7sGMfI=;
        b=fZrJWbeaLsfHr+qGQLmllVoi/BUSu9J2iOOxYBj7faBRanqKxMW26COqUK7sR/+S+f
         7SSIzr6qPADNsm3Httdw56b0D+5iD1INWG/jyS7ykE/pRVzXDvLdsadL4HKIPkiI57ym
         f+NyOfFpo+iZPrQ7zlbqLiAtJxSWmpVBWxtMxZma1fEctxrndmMe/O3sEP7yt9t0r+WH
         uiqB+2T8GqBoQGBQWPTh7qBbW26Lqb3J+hUwTWOB6JjJDJlq8kXktK+4wviMIS1DeYwZ
         vahPTTBtfOx0U0CB1uBQyfM4okOSi0EZgbFoTPTRJroi0gaw4rynIFDKUiONn2FAT9Un
         usfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:references:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YuRYksjlF5ENbyJsTQR4HoHAxvMGAxkl1acTB7sGMfI=;
        b=q3or11rybBGfJE3+O5uoyqNXy0EQBiGHmG3GJVRTVr0ci5/b21SREssV60WcjtW/nZ
         v0BI15EC+rqoqhAZYLUdn2aa8zfHiYlZDY9bOBUJG00oy5dJD3eHx6E/H2jR9HgTuy9B
         lnPyY72M3LMlPhQiB+P+kqZ8qmWIcB9v8iZBb5Ekl1BNGPAhUf+jHkfCGmlDmr3BNjze
         cjKqESxq94w35zRwADA55zH3rBVpYitly0jQ9j012CdIcURsrL4X9f1VtYOnu/zowD9/
         HMDLP183E1UzyjhMy/TWnzb81qDqyVO+YVO3+xeugnr7D8IcQgdLeo4ug0nOcG+ffZdO
         4jJQ==
X-Gm-Message-State: AGi0PubHQryNKIB5E3AzNHYaQbea0nSrpelgICMT5DT5Zo4DbNiYZsss
        gC0dp9Rs3hXvoJTPimAkp+vQUyN7
X-Google-Smtp-Source: APiQypIz7Hyf+5VR7+ZJ4+5GAX8RL9TYwz9glKIRsNiViqDFhx2B5jm05IJZoO+TJjahMutDpjloWg==
X-Received: by 2002:adf:eec3:: with SMTP id a3mr9661831wrp.164.1589040498695;
        Sat, 09 May 2020 09:08:18 -0700 (PDT)
Received: from [192.168.43.127] ([46.191.65.149])
        by smtp.gmail.com with ESMTPSA id h1sm18505315wme.42.2020.05.09.09.08.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 May 2020 09:08:18 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, Jann Horn <jannh@google.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <c7dc4d15f9065f41df5ad83e051d05e7c46f004f.1588622410.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH for-5.7] io_uring: fix zero len do_splice()
Message-ID: <102cad76-9b98-444f-7ccf-6475245f4031@gmail.com>
Date:   Sat, 9 May 2020 19:07:12 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <c7dc4d15f9065f41df5ad83e051d05e7c46f004f.1588622410.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 04/05/2020 23:00, Pavel Begunkov wrote:
> do_splice() doesn't expect len to be 0. Just always return 0 in this
> case as splice(2) do.
> 

If it was missed, may you take a look? I reattached the patch btw killing
reported warnings.

---
From: Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH] io_uring: fix zero len do_splice()

do_splice() doesn't expect len to be 0. Do the check in io_splice()
exactly as in sys_splice().

Fixes: 7d67af2c0134 ("io_uring: add splice(2) support")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 65458eda2127..70d8943c337b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2772,16 +2772,16 @@ static int io_splice(struct io_kiocb *req, bool
force_nonblock)
 	struct file *out = sp->file_out;
 	unsigned int flags = sp->flags & ~SPLICE_F_FD_IN_FIXED;
 	loff_t *poff_in, *poff_out;
-	long ret;
+	long ret = 0;

 	if (force_nonblock)
 		return -EAGAIN;

 	poff_in = (sp->off_in == -1) ? NULL : &sp->off_in;
 	poff_out = (sp->off_out == -1) ? NULL : &sp->off_out;
-	ret = do_splice(in, poff_in, out, poff_out, sp->len, flags);
-	if (force_nonblock && ret == -EAGAIN)
-		return -EAGAIN;
+
+	if (sp->len)
+		ret = do_splice(in, poff_in, out, poff_out, sp->len, flags);

 	io_put_file(req, in, (sp->flags & SPLICE_F_FD_IN_FIXED));
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-- 
2.24.0
